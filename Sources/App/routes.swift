import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    let githubRoutes = router.grouped("github")
    
    githubRoutes.post(GithubPullRequestWebhook.self, at: "pr") { (req, webhook) -> Future<Response> in
        // This route will only be responding to merges
        guard
            webhook.action == "closed",
            webhook.pullRequest.merged == true
        else {
            return try HTTPStatus.ok.encode(for: req)
        }
    
        let circle = try req.make(CircleCIService.self)
        
        return circle.start(
            job: "linux-performance",
            repo: webhook.repository.fullName,
            branch: "master",
            on: req
        ).map { result in
            return try req.keyedCache(for: .psql).set(String(result.buildNumber), to: true)
        }.transform(to: try HTTPStatus.ok.encode(for: req))
    }
   
    githubRoutes.post(GithubCommentWebhook.self, at: "comment") { (req, webhook) -> Future<Response> in
        guard
            let comment = webhook.comment,
            comment.user.login != "vapor-bot"
            else { return try HTTPStatus.ok.encode(for: req) }
        
        let githubRouter = try req.make(GithubCommandRouter.self)
        
        guard let responder = githubRouter.route(command: comment.body, on: req) else {
            return try HTTPStatus.notFound.encode(for: req)
        }
        
        do {
            return try responder.respond(to: req).encode(for: req)
        } catch {
            return try HTTPStatus.ok.encode(for: req)
        }
    }
    
    enum ParsingError: Error {
        case parsingFailed
    }
    
    let circleGroup = router.grouped("circle")
    
    circleGroup.post(CircleCIWebhook.self, at: "result") { (req, webhook) -> Future<Response> in
        let logger = try req.make(Logger.self)
        
        logger.info("Finished build: \(webhook.buildName)")
        
        let saveResultsInteractor = SaveTestResultsInteractor()
        let commentResultsInteractor = CommentTestResultsTableInteractor()
        
        // Only dealing with perf tests
        guard webhook.buildName == "linux-performance" else {
            return try HTTPStatus.ok.encode(for: req)
        }
     
        let circle = try req.make(CircleCIService.self)
        
        let repo = "\(webhook.username)/\(webhook.repoName)"
        
        return circle
            .getOutput(for: webhook.buildNumber, repo: repo, step: "swift test", on: req)
            .flatMap { output, build -> Future<Response> in
                let performanceTestParser = ParsePerformanceTestResultsInteractor()
                let testResults = performanceTestParser
                    .execute(
                        output: output.message,
                        date: build.startTime,
                        repoName: build.repoName,
                        on: req
                )
                
                return try req
                    .cacheContains(key: String(webhook.buildNumber), databaseIdentifier: .psql)
                    .flatMap { isResultOfMerge -> Future<Response> in
                        if isResultOfMerge {
                            logger.info("Job number \(build.job) is the result of a merge")
                            return saveResultsInteractor
                                .execute(on: req, testResults: testResults)
                        } else {
                            logger.info("Job number \(build.job) is not the result of a merge")
                            return commentResultsInteractor
                                .execute(
                                    on: req,
                                    testResults: testResults,
                                    build: build,
                                    repo: repo
                                )
                        }
                    }.catchFlatMap { error -> Future<Response> in
                        if let error = error as? ParsingError, error == .parsingFailed {
                            let commentErrorInteractor = CommentErrorInteractor()
                            return commentErrorInteractor
                                .execute(
                                    on: req,
                                    build: build,
                                    repo: repo,
                                    message: "Performance test results could not be parsed"
                                )
                        }
                        return req.future(error: error)
                    }
            }
    }
    
    router.get("perf") { (req) -> Future<[PerformanceTestResults]> in
        return PerformanceTestResults.query(on: req).all()
    }
}
