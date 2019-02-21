import Vapor

public struct CircleCIService: Service {
    public let authToken: String
    
    public init(authToken: String) {
        self.authToken = authToken
    }
    
    public func getBuild(number: Int, repo: String, on req: Request) throws -> Future<CircleCIBuild> {
        let requestURL = "https://circleci.com/api/v1.1/project/github/\(repo)/\(number)?circle-token=\(self.authToken)"
       
        return try req.client().get(requestURL).flatMap { response in
            response.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
            let build = try response.content.decode(CircleCIBuild.self)
            return build
        }
    }
    
    
    public func getOutput(for buildStep: String, from build: CircleCIBuild, on req: Request) throws -> Future<CircleCIBuildOutput> {
        guard
            let step = (build.steps.first { $0.name == buildStep }),
            let outputURL = step.actions[0].outputURL
            else {
                return req.future(error: Abort(.notFound))
            }
        
        return try req.client().get(outputURL).map { response in
            return try response.content.syncDecode([CircleCIBuildOutput].self)[0]
        }
    }
    
}
