import Vapor

public struct LogRequestMiddleware: Middleware, Service {
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        let logger = try request.make(Logger.self)
        
        logger.debug("Incoming request to \(request.http.method.string) \(request.http.urlString)")
        
        return try next.respond(to: request)
    }
}
