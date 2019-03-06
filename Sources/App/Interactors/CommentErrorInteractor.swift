import Vapor

public struct CommentErrorInteractor {
    func execute(
        on req: Request,
        build: CircleCIBuild,
        repo: String,
        message: String
    ) -> Future<Response> {
        guard let github = try? req.make(GithubService.self) else {
            return req.future(
                error: ServiceError(identifier: "Github", reason: "GithubService could not be created")
            )
        }
        
        guard
            let pullRequest = build.pullRequests.first,
            let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
            let issueNumber = Int(issueNumberString)
        else {
            return req.future(error: Abort(.ok))
        }
        
        do {
            return try github.postComment(
                repo: repo,
                issue: issueNumber,
                body: message,
                on: req
            ).encode(for: req)
        } catch {
            return req.future(error: error)
        }
    }
}
