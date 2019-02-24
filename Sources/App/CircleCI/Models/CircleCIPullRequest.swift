import Vapor


public struct CircleCIPullRequest: Content {
    let headCommit: String
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case headCommit = "head_sha"
        case url
    }
}
