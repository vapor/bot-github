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
    
    router.post(GithubWebhook.self, at: "git") { (req, webhook) -> Future<HTTPStatus> in
        guard
            let comment = webhook.comment,
            comment.user.login != "vapor-bot"
            else { return req.future(.ok) }
        let repo = webhook.repository
        let issue = webhook.issue
       
        if comment.body.hasPrefix("@vapor-bot") {
            let commands = comment.body.replacingOccurrences(of: "@vapor-bot ", with: "🔤").split(separator: "🔤")
            let github = try req.make(GithubService.self)
            guard commands.count >= 1 else {
                return github.postComment(
                    repo: repo.fullName,
                    issue: issue.number,
                    body: "Sorry? Didn't catch that.",
                    on: req
                ).transform(to: .ok)
            }
            let command = commands[0]
            
            switch command.lowercased() {
            case "test performance":
                let circle = try req.make(CircleCIService.self)
                
                guard let pullRequest = webhook.issue.pullRequest else {
                    return github.postComment(
                        repo: repo.fullName,
                        issue: issue.number,
                        body: "Unknown command",
                        on: req
                    ).transform(to: .ok)
                }
                
                return try req.client().get(pullRequest.url).flatMap { response -> Future<String> in
                    let pullRequestHead = try response.content.syncDecode(GithubPullRequest.self).head
                    let branchName = pullRequestHead.name
                    
                    return circle.start(job: "linux-performance", repo: repo.fullName, branch: branchName, on: req)
                }.flatMap { _ -> Future<CreateCommentResponse> in
                    return github.postComment(
                        repo: repo.fullName,
                        issue: issue.number,
                        body: "Starting performance test",
                        on: req
                    )
                }.transform(to: .ok)
                
            default:
                return github.postComment(
                    repo: repo.fullName,
                    issue: issue.number,
                    body: "Unknown command",
                    on: req
                ).transform(to: .ok)
            }
        }
        
        return req.future(.ok)
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
                
                var table =
"""
| Test | Expected | Average | Change |
| --- | --- | --- | --- |

"""
                let rows: String = testResults.map { result in
                    "| \(result.name) | \(result.expected) | \(result.average) | \(result.change) |"
                }.joined(separator: "\n")
                
                table.append(contentsOf: rows)
                
                return github.postComment(
                    repo: repo,
                    issue: issueNumber,
                    body: table,
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
    
    struct TestResults: Codable {
        public let name: String
        public let expected: Double
        public let average: Double
        public let change: String
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
