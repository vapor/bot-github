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

public struct CircleCIService: Service {
    public enum CircleCIError: Error {
        case noOutputURL
    }
    
    public let authToken: String
    
    public init(authToken: String) {
        self.authToken = authToken
    }
    
    public func getBuild(number: Int, repo: String, on req: Request) throws -> Future<CircleCIBuild> {
        let requestURL = "https://circleci.com/api/v1.1/project/github/\(repo)/\(number)?circle-token=\(self.authToken)"
       
        return try req.client().get(requestURL).flatMap { response in
            print("BUILD_RESPONSE:", response)
            response.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
            let build = try response.content.decode(CircleCIBuild.self)
            return build
        }
    }
    
    
    public func getOutput(for buildStep: String, from build: CircleCIBuild, on req: Request) throws -> Future<CircleCIBuildOutput> {
        print("BUILD_OBJECT:", build)
        guard let step = (build.steps.first { $0.name == buildStep }) else {
            return req.future(error: Abort(.notFound))
        }
        
        guard let outputURL = step.actions[0].outputURL else {
            throw CircleCIError.noOutputURL
        }
        
        return try req.client().get(outputURL).map { response in
            return try response.content.syncDecode([CircleCIBuildOutput].self)[0]
        }
    }
    
    public func start(job: String, repo: String, branch: String, on req: Request) throws -> Future<String> {
        let requestURL = "https://circleci.com/api/v1.1/project/github/\(repo)/tree/\(branch)?circle-token=\(self.authToken)"
        
        return try req.client().post(requestURL, beforeSend: { request in
            let body = CircleCIRunJobBody(buildParameters: job)
            try request.content.encode(body)
        }).map { response -> Response in
            print(response)
            return response
        }.transform(to: "hello")
    }
    
}
