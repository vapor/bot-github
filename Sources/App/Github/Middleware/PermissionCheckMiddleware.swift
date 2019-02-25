import Vapor

public struct PermissionCheckMiddleware: Middleware {
    let target: PermissionLevel
    
    public init(target: PermissionLevel) {
        self.target = target
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        return try request.content.decode(GithubWebhook.self).flatMap { webhook in
            guard let comment = webhook.comment,
                comment.user.login != "vapor-bot"
                else { return try HTTPStatus.ok.encode(for: request) }
            let repo = webhook.repository
            
            let github = try request.make(GithubService.self)
            
            return github.getPermissionLevel(username: comment.user.login, repo: repo.fullName, on: request).flatMap { permissions in
                if permissions.level.meetsRequirement(target: self.target) {
                    return try next.respond(to: request)
                } else {
                    return request.future(error: Abort(HTTPStatus.unauthorized))
                }
            }
        }
    }
}
