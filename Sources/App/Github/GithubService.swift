import Vapor

public struct GithubService: Service {
    let accessToken: String
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    public func postComment(repo: String, issue: Int, body: String, on req: Request) -> Future<CreateCommentResponse> {
        let requestURL = "https://api.github.com/repos/\(repo)/issues/\(issue)/comments?access_token=\(self.accessToken)"
        let headers = HTTPHeaders(dictionaryLiteral:
            (HTTPHeaderName.contentType.description, "application/json")
        )
        
        do {
            let client = try req.client()
            
            return client.post(requestURL, headers: headers, beforeSend: { req in
                try req.content.encode(CreateGithubCommentBody(body: body))
            }).flatMap { response in
                return try response.content.decode(CreateCommentResponse.self)
            }
        } catch {
            return req.future(error: error)
        }
    }
    
    public func getPermissionLevel(username: String, repo: String, on req: Request) -> Future<GithubPermissionLevel> {
        let requestURL = "https://api.github.com/repos/\(repo)/collaborators/\(username)/permission?access_token=\(self.accessToken)"
 
        do {
            let client = try req.client()
            
            return client.get(requestURL).flatMap { response in
                return try response.content.decode(GithubPermissionLevel.self)
            }
        } catch {
            return req.future(error: error)
        }
    }
}
