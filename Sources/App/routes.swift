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
    
    router.post(GithubWebhook.self, at: "pullRequestActivity") { (req, webhook) -> Future<Response> in
        // This route will only be responding to merges
        guard
            webhook.action == "closed",
            let isMerged = webhook.issue.pullRequest?.merged,
            isMerged == true
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
            return try req.keyedCache(for: .sqlite).set(String(result.buildNumber), to: true)
        }.transform(to: try HTTPStatus.ok.encode(for: req))
    }
   
    router.post(GithubWebhook.self, at: "comment") { (req, webhook) -> Future<Response> in
        guard
            let comment = webhook.comment,
            comment.user.login != "vapor-bot"
            else { return try HTTPStatus.ok.encode(for: req) }
        
        let githubRouter = GithubCommandRouter()
        try githubRoutes(router: githubRouter)
        
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
    
    // This error type only exists to exit the pipeline early
    enum SkipError: Error {
        case skip
    }
    
    router.post(CircleCIWebhook.self, at: "circle") { (req, webhook) -> Future<HTTPStatus> in
        print("test starting", webhook.buildName)
        
        // Only dealing with perf tests
        guard webhook.buildName == "linux-performance" else { return req.future(.ok) }
     
        let circle = try req.make(CircleCIService.self)
        let github = try req.make(GithubService.self)
        
        let repo = "\(webhook.username)/\(webhook.repoName)"
        
        return circle
            .getOutput(for: webhook.buildNumber, repo: repo, step: "swift test", on: req)
            .flatMap { (output, build) -> Future<HTTPStatus> in
                return try req
                    .keyedCache(for: .sqlite)
                    .get(String(webhook.buildNumber), as: Bool.self)
                    .flatMap { maybeTracked -> Future<[PerformanceTestResults]> in
                        let performanceTestParser = ParsePerformanceTestResultsInteractor()
                        guard let testResults = try? performanceTestParser
                            .execute(
                                output: output.message,
                                date: build.startTime,
                                repoName: build.repoName,
                                on: req
                        ) else {
                            return req.future(error: ParsingError.parsingFailed)
                        }

                        if maybeTracked != nil {
                            return testResults.map { result in
                                result.map { $0.save(on: req) }.flatten(on: req)
                            }.flatMap { _ in
                                // Skipping down to the catch map
                                return req.future(error: SkipError.skip)
                            }
                        } else {
                            return testResults
                        }
                    }.flatMap { testResults -> Future<Response> in
                        guard build.pullRequests.count > 0 else { throw Abort(.notFound) }
                        let pullRequest = build.pullRequests[0]
                        
                        guard
                            let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
                            let issueNumber = Int(issueNumberString)
                        else {
                            throw Abort(.notFound)
                        }
                        
                        let tableGenerator = GithubTableGenerator(
                            columns: "Name", "Expected", "Actual", "Change",
                            rows: testResults
                        )
                        
                        let createCommentResponse: Future<CreateCommentResponse> = github.postComment(
                            repo: repo,
                            issue: issueNumber,
                            body: tableGenerator.table,
                            on: req
                        )
                        
                        return try createCommentResponse.encode(for: req)
                    }.catchFlatMap { error -> Future<Response> in
                        if let error = error as? ParsingError, error == .parsingFailed {
                            guard build.pullRequests.count > 0 else {
                                return req.future(error: Abort(HTTPStatus.ok))
                            }
                            let pullRequest = build.pullRequests[0]
                            
                            guard
                                let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
                                let issueNumber = Int(issueNumberString)
                            else {
                                return req.future(error: Abort(.notFound))
                            }
                            
                            return try github.postComment(
                                repo: repo,
                                issue: issueNumber,
                                body: "Performance tests failed in an unexpected way",
                                on: req
                            ).encode(for: req)
                        } else if let error = error as? SkipError, error == .skip {
                            return try HTTPStatus.ok.encode(for: req)
                        }
                        return req.future(error: error)
                    }.transform(to: .ok)
            }
    }
}
