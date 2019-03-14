import Vapor

public struct CommentTestResultsTableInteractor {
    public func execute(
        on req: Request,
        testResults: Future<[PerformanceTestResults]>,
        build: CircleCIBuild,
        repo: String
    ) -> Future<Response> {
        guard let github = try? req.make(GithubService.self) else {
            return req.future(
                error: ServiceError(identifier: "Github", reason: "GithubService could not be created")
            )
        }
        
        guard let logger = try? req.make(Logger.self) else {
            return req.future(
                error: ServiceError(identifier: "Logger", reason: "Logger could not be created")
            )
        }
        
        return testResults.flatMap { testResults -> Future<Response> in
            guard let pullRequest = build.pullRequests.first else {
                logger.error("There were no pull requests associated with build \(build.number)")
                throw Abort(.notFound)
            }
            
            guard
                let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
                let issueNumber = Int(issueNumberString)
                else {
                    logger.error("Couldn't parse out the issue number string for build \(build.number)")
                    throw Abort(.notFound)
            }
            
            let tableGenerator = GithubTableGenerator(
                columns: "Name", "Expected", "Actual", "Change",
                rows: testResults
            )
            
            let createCommentResponse: Future<CreateCommentResponse> = github.postComment(
                repo: repo,
                issue: issueNumber,
                body: tableGenerator.table,
                on: req
            )
            
            return try createCommentResponse.encode(for: req)
        }
    }
}
