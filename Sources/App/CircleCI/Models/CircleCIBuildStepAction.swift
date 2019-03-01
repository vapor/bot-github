import Vapor

public struct CircleCIBuildStepAction: Content {
    public let outputURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case outputURL = "output_url"
    }
}
