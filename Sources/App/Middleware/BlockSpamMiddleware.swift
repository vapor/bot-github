import Vapor


/// Blocks requests from crawlers for security and to prevent clogging up logs
public struct BlockSpamMiddleware: Middleware {
    let spamList = [".jsp", ".php", ".exe"]
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        let hits = spamList.filter { request.http.urlString.contains($0) }
        
        guard hits.isEmpty else {
            return request.future(error: Abort(.notAcceptable, reason: "Request hit blocklist"))
        }
        
        return try next.respond(to: request)
    }
}
