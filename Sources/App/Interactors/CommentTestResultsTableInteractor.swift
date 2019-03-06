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
        
        return testResults.flatMap { testResults -> Future<Response> in
            guard build.pullRequests.count > 0 else { throw Abort(.notFound) }
            let pullRequest = build.pullRequests[0]
            
            guard
                let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
                let issueNumber = Int(issueNumberString)
                else {
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
