import Vapor

// Basic router implementation
public class GithubCommandRouter {
    /// The internal router
    private let router: TrieRouter<Responder>
    
    public var routes: [Route<Responder>] {
        return router.routes
    }
    
    public var middleware: [Middleware]
    
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
        guard command.count > 0 else {
            return
        }
        
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


// Middleware
extension GithubCommandRouter {
//    public func grouped(_ middleware: Middleware...) -> GithubCommandRouter {
//        
//    }
}
