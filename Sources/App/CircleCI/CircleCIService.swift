import Vapor

public struct CircleCIService: Service {
    public enum CircleCIError: Error {
        case noOutputURL
    }
    
    public let authToken: String
    
    public init(authToken: String) {
        self.authToken = authToken
    }
    
    public func getBuild(number: Int, repo: String, on req: Request) -> Future<CircleCIBuild> {
        let requestURL = "https://circleci.com/api/v1.1/project/github/\(repo)/\(number)?circle-token=\(self.authToken)"
       
        do {
            let client = try req.client()
            
            return client.get(requestURL).flatMap { response in
                response.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
                return try response.content.decode(CircleCIBuild.self)
            }
        } catch {
            return req.future(error: error)
        }
    }
    
    func getOutput(
        for buildNumber: Int,
        repo: String,
        step: String,
        on req: Request,
        retries: Int = 3
    ) -> Future<(CircleCIBuildOutput, CircleCIBuild)> {
        guard retries != 0 else { return req.future(error: Abort(.internalServerError)) }
        let circle: CircleCIService
        
        do {
            circle = try req.make(CircleCIService.self)
        } catch {
            return req.future(error: error)
        }
        
        return circle.getBuild(
            number: buildNumber,
            repo: repo,
            on: req
        ).flatMap { build -> Future<(CircleCIBuildOutput, CircleCIBuild)> in
            
            return circle.getOutput(for: "swift test", from: build, on: req).map { ($0, build) }
        }.catchFlatMap { (error) -> Future<(CircleCIBuildOutput, CircleCIBuild)> in
            if let error = error as? CircleCIService.CircleCIError, error == .noOutputURL {
                sleep(1)
                return self.getOutput(for: buildNumber, repo: repo, step: step, on: req, retries: retries - 1)
            }
            throw error
        }
    }
    
    fileprivate func getOutput(for buildStep: String, from build: CircleCIBuild, on req: Request) -> Future<CircleCIBuildOutput> {
        guard let step = (build.steps.first { $0.name == buildStep }) else {
            return req.future(error: Abort(.notFound))
        }
        
        guard let outputURL = step.actions[0].outputURL else {
            return req.future(error: CircleCIError.noOutputURL)
        }
      
        do {
            let client = try req.client()
            
            return client.get(outputURL).map { response in
                return try response.content.syncDecode([CircleCIBuildOutput].self)[0]
            }
        } catch {
            return req.future(error: error)
        }
    }
    
    public func start(
        job: String,
        repo: String,
        branch: String,
        on req: Request
    ) -> Future<CircleCIRunJobResult> {
        let requestURL = "https://circleci.com/api/v1.1/project/github/\(repo)/tree/\(branch)?circle-token=\(self.authToken)"
        
        do {
            let client = try req.client()
            
            return client.post(requestURL, beforeSend: { request in
                let body = CircleCIRunJobBody(buildParameters: job)
                try request.content.encode(body)
            }).flatMap { response in
                response.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
                return try response.content.decode(CircleCIRunJobResult.self)
            }
        } catch {
            return req.future(error: error)
        }
    }
}
