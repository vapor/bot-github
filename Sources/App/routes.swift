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
}
