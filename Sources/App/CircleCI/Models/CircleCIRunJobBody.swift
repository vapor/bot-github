import Vapor

public struct CircleCIRunJobBody: Content {
    public static var defaultContentType: MediaType {
        return .urlEncodedForm
    }
    
    let buildParameters: String
    
    enum CodingKeys: String, CodingKey {
        case buildParameters = "build_parameters[CIRCLE_JOB]"
    }
}
