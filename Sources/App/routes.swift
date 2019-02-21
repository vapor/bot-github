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
    
    router.post(GithubWebhook.self, at: "git") { (req, webhook) -> Future<HTTPResponseStatus> in
        let comment = webhook.comment
        let repo = webhook.repository
        let issue = webhook.issue
       
        if comment.body.contains("@vapor-bot") {
            let github = try req.make(GithubService.self)
            return try github.postComment(
                repo: repo.fullName,
                issue: issue.number,
                body: "This is an automated response",
                on: req
            ).transform(to: .ok)
        }
        
        print(comment.body)
        return req.future(.ok)
    }
    
    router.post(CircleCIWebhook.self, at: "circle") { (req, webhook) -> Future<String> in
        let circle = try req.make(CircleCIService.self)
        let github = try req.make(GithubService.self)
        
        let repo = "\(webhook.username)/\(webhook.repoName)"
        
        return try circle.getBuild(
            number: webhook.buildNumber,
            repo: repo,
            on: req
        ).flatMap { build -> Future<(CircleCIBuildOutput, PullRequest)> in
            let pullRequest = build.pullRequests[0]
            return try circle.getOutput(for: "Uploading artifacts", from: build, on: req).map { ($0, pullRequest) }
        }.flatMap { (output, pullRequest) -> Future<CreateCommentResponse> in
            guard
                let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
                let issueNumber = Int(issueNumberString)
                else { throw Abort(.notFound) }
            
            return try github.postComment(
                repo: repo,
                issue: issueNumber,
                body: "Build finished",
                on: req
            )
        }.transform(to: "hello")
    }
}
