import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.post("git") { req -> Future<Response> in
        guard
            let webhook = try? req.content.syncDecode(GithubWebhook.self),
            let comment = webhook.comment,
            comment.user.login != "vapor-bot"
            else { return try HTTPStatus.ok.encode(for: req) }
        let repo = webhook.repository
        let issue = webhook.issue
        
        let githubRouter = GithubCommandRouter()
        try githubRoutes(router: githubRouter)
        
        guard let responder = githubRouter.route(command: comment.body, on: req) else {
            return try HTTPStatus.notFound.encode(for: req)
        }
        
        do {
            return try responder.respond(to: req).encode(for: req)
        } catch {
            return try HTTPStatus.ok.encode(for: req)
        }
    }
    
    router.post(CircleCIWebhook.self, at: "circle") { (req, webhook) -> Future<HTTPResponseStatus> in
        print("test starting", webhook.buildName)
        guard webhook.buildName == "linux-performance" else { return req.future(.ok) }
     
        let circle = try req.make(CircleCIService.self)
        let github = try req.make(GithubService.self)
        
        let repo = "\(webhook.username)/\(webhook.repoName)"
        
        return getOutput(for: webhook.buildNumber, repo: repo, step: "swift test", on: req)
            .flatMap { (output, pullRequest) -> Future<CreateCommentResponse> in
                guard
                    let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
                    let issueNumber = Int(issueNumberString)
                    else {
                        throw Abort(.notFound)
                    }
                
                guard let testResults = try? testOutputToTestResults(output: output.message) else {
                    return github.postComment(
                        repo: repo,
                        issue: issueNumber,
                        body: "Performance tests failed in an unexpected way",
                        on: req
                    )
                }
                
                let tableGenerator = GithubTableGenerator(
                    columns: "Name", "Expected", "Actual", "Change",
                    rows: testResults
                )
                
                return github.postComment(
                    repo: repo,
                    issue: issueNumber,
                    body: tableGenerator.table,
                    on: req
                )
            }.transform(to: .ok)
    }
    
    func getOutput(
        for buildNumber: Int,
        repo: String,
        step: String,
        on req: Request,
        retries: Int = 3
    ) -> Future<(CircleCIBuildOutput, PullRequest)> {
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
        ).flatMap { build -> Future<(CircleCIBuildOutput, PullRequest)> in
            let pullRequest = build.pullRequests[0]
            return circle.getOutput(for: "swift test", from: build, on: req).map { ($0, pullRequest) }
        }.catchFlatMap { (error) -> Future<(CircleCIBuildOutput, PullRequest)> in
            if let error = error as? CircleCIService.CircleCIError, error == .noOutputURL {
                sleep(1)
                return getOutput(for: buildNumber, repo: repo, step: step, on: req, retries: retries - 1)
            }
            throw error
        }
    }
    
    enum OutputParsingError: Error {
        case missingTestCases
    }
    
    func testOutputToTestResults(output: String) throws -> [TestResults] {
        func matches(for regex: String, in text: String) -> [String] {
            do {
                let regex = try NSRegularExpression(pattern: regex)
                let results = regex.matches(in: text,
                                            range: NSRange(text.startIndex..., in: text))
                return results.map {
                    String(text[Range($0.range, in: text)!])
                }
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
                return []
            }
        }
        
        let replaced = output.replacingOccurrences(of: "[PERFORMANCE]", with: "🔤")
        let split = replaced.split(separator: "🔤")
        let filterNonPerformance = split.filter { $0.contains("performance") }
        
        guard filterNonPerformance.count >= 3 else { throw OutputParsingError.missingTestCases }
        
        let testResults = filterNonPerformance.map { (test: String.SubSequence) -> (name: String, expected: Double, average: Double, change: String) in
            let expected = Double(matches(for: "expected: [0-9\\.]*", in: String(test))[0].split(separator: " ")[1])!
            let average = Double(matches(for: "average: [0-9\\.]*", in: String(test))[0].split(separator: " ")[1])!
            return (
                name: String(matches(for: ".*\\(\\)", in: String(test))[0].split(separator: "(")[0]),
                expected: expected,
                average: average,
                change: "\(String(format:"%.2f", Double((expected - average))/expected * 100))%"
            )
        }
        
        let codableResults = testResults.map { TestResults(name: $0.name, expected: $0.expected, average: $0.average, change: $0.change) }
        
        return codableResults
    }
}
