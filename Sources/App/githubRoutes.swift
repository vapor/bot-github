import Vapor

public func githubRoutes(router: GithubCommandRouter) throws {
    router.command("@vapor-bot", "test performance") { (req, webhook) -> Future<HTTPStatus> in
        guard let comment = webhook.comment, comment.user.login != "vapor-bot" else {
            return req.future(.ok)
        }
        let repo = webhook.repository
        let issue = webhook.issue
        
        let circle = try req.make(CircleCIService.self)
        let github = try req.make(GithubService.self)
        
        guard let pullRequest = webhook.issue.pullRequest else {
            return github.postComment(
                repo: repo.fullName,
                issue: issue.number,
                body: "Unknown command",
                on: req
            ).transform(to: .ok)
        }
        
        return try req.client().get(pullRequest.url).flatMap { response -> Future<String> in
            let pullRequestHead = try response.content.syncDecode(GithubPullRequest.self).head
            let branchName = pullRequestHead.name
            
            return circle.start(job: "linux-performance", repo: repo.fullName, branch: branchName, on: req)
        }.flatMap { _ -> Future<CreateCommentResponse> in
            return github.postComment(
                repo: repo.fullName,
                issue: issue.number,
                body: "Starting performance test",
                on: req
            )
        }.transform(to: .ok)
    
    }
    
    router.command("@vapor-bot") { (req, webhook) -> Future<HTTPStatus> in
        guard let comment = webhook.comment, comment.user.login != "vapor-bot" else {
            return req.future(.ok)
        }
        
        let repo = webhook.repository
        let issue = webhook.issue
        
        let github = try req.make(GithubService.self)
        
        return github.postComment(
            repo: repo.fullName,
            issue: issue.number,
            body: "Sorry? Didn't catch that.",
            on: req
        ).transform(to: .ok)
    }
}
