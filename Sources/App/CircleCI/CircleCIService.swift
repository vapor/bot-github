import Vapor

public struct CircleCIService: Service {
    public let authToken: String
    
    public init(authToken: String) {
        self.authToken = authToken
    }
}
