import Vapor

public struct GithubUser: Content {
    public let id: Int
    public let login: String
}
