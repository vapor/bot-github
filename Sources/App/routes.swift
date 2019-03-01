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
   
    router.post(GithubWebhook.self, at: "git") { (req, webhook) -> Future<Response> in
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
    
    router.post(CircleCIWebhook.self, at: "circle") { (req, webhook) -> Future<HTTPResponseStatus> in
        print("test starting", webhook.buildName)
        guard webhook.buildName == "linux-performance" else { return req.future(.ok) }
     
        let circle = try req.make(CircleCIService.self)
        let github = try req.make(GithubService.self)
        
        let repo = "\(webhook.username)/\(webhook.repoName)"
        
        return circle.getOutput(for: webhook.buildNumber, repo: repo, step: "swift test", on: req)
            .flatMap { (output, pullRequest) -> Future<CreateCommentResponse> in
                guard
                    let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
                    let issueNumber = Int(issueNumberString)
                    else {
                        throw Abort(.notFound)
                    }
                
                let performanceTestParser = ParsePerformanceTestResultsInteractor()
                guard let testResults = try? performanceTestParser.execute(output: output.message) else {
                    return github.postComment(
                        repo: repo,
                        issue: issueNumber,
                        body: "Performance tests failed in an unexpected way",
                        on: req
                    )
                }
                
                let tableGenerator = GithubTableGenerator(
                    columns: "Name", "Expected", "Actual", "Change",
                    rows: testResults
                )
                
                return github.postComment(
                    repo: repo,
                    issue: issueNumber,
                    body: tableGenerator.table,
                    on: req
                )
            }.transform(to: .ok)
    }
}
