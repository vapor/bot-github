import Vapor

// Basic router implementation
public class GithubCommandRouter {
    /// The internal router
    private let router: TrieRouter<Responder>
    
    public var routes: [Route<Responder>] {
        return router.routes
    }
    
    public init() {
        self.router = .init()
    }
    
    public func register(route: Route<Responder>) {
        router.register(route: route)
    }

    public func route(command: String, on req: Request) -> Responder? {
        var parameters = Parameters()
        let responder = router.route(path: command.lowercased().split(separator: " "), parameters: &parameters)
        return responder
    }
}

// Convenience functions
extension GithubCommandRouter {
    public func register<T: ResponseEncodable>(
        command: String...,
        closure: @escaping (Request) throws -> T
    ) {
        let pathComponents = command.map { component in
            component.split(separator: " ").map {
                PathComponent.constant(String($0))
            }
        }.flatMap { $0 }
        let responder = BasicResponder { try closure($0).encode(for: $0) }
        let route = Route<Responder>.init(path: pathComponents, output: responder)
        self.register(route: route)
    }
}

public func githubRoutes(router: GithubCommandRouter) throws {
    router.register(command: "@vapor-bot", "test performance") { (req) -> Future<HTTPStatus> in
        guard
            let webhook = try? req.content.syncDecode(GithubWebhook.self),
            let comment = webhook.comment,
            comment.user.login != "vapor-bot"
            else { return req.future(.ok) }
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
    
    router.register(command: "@vapor-bot") { req -> Future<HTTPStatus> in
        guard
            let webhook = try? req.content.syncDecode(GithubWebhook.self),
            let comment = webhook.comment,
            comment.user.login != "vapor-bot"
            else { return req.future(.ok) }
        
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
