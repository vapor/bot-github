import Vapor

// Basic router implementation
public class GithubCommandRouter: Service {
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
    public func command<T: ResponseEncodable>(
        _ command: String...,
        closure: @escaping (Request, GithubWebhook) throws -> T
    ) {
        let pathComponents = command.map { component in
            component.split(separator: " ").map {
                PathComponent.constant(String($0))
            }
        }.flatMap { $0 }
        
        let responder = BasicResponder { request in
            try request.content.decode(GithubWebhook.self).flatMap { webhook in
                try closure(request, webhook).encode(for: request)
            }
        }
        
        let route = Route<Responder>.init(path: pathComponents, output: responder)
        self.register(route: route)
    }
}
