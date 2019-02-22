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
                return try github.postComment(
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
                    return try github.postComment(
                        repo: repo.fullName,
                        issue: issue.number,
                        body: "Unknown command",
                        on: req
                    ).transform(to: .ok)
                }
                
                return try req.client().get(pullRequest.url).flatMap { response -> Future<String> in
                    let pullRequestHead = try response.content.syncDecode(GithubPullRequest.self).head
                    let branchName = pullRequestHead.name
                    
                    return try circle.start(job: "linux-performance", repo: repo.fullName, branch: branchName, on: req)
                }.flatMap { _ -> Future<CreateCommentResponse> in
                    return try github.postComment(
                        repo: repo.fullName,
                        issue: issue.number,
                        body: "Starting performance test",
                        on: req
                    )
                }.transform(to: .ok)
                
            default:
                return try github.postComment(
                    repo: repo.fullName,
                    issue: issue.number,
                    body: "Unknown command",
                    on: req
                ).transform(to: .ok)
            }
        }
        
        print(comment.body)
        return req.future(.ok)
    }
    
    router.post(CircleCIWebhook.self, at: "circle") { (req, webhook) -> Future<HTTPResponseStatus> in
        print("test starting", webhook.buildName)
        guard webhook.buildName == "linux-performance" else { throw Abort(.ok) }
     
        let circle = try req.make(CircleCIService.self)
        let github = try req.make(GithubService.self)
        
        let repo = "\(webhook.username)/\(webhook.repoName)"
        
        return try circle.getBuild(
            number: webhook.buildNumber,
            repo: repo,
            on: req
        ).flatMap { build -> Future<(CircleCIBuildOutput, PullRequest)> in
            let pullRequest = build.pullRequests[0]
            return try circle.getOutput(for: "swift test", from: build, on: req).map { ($0, pullRequest) }
        }.flatMap { (output, pullRequest) -> Future<CreateCommentResponse> in
            guard
                let issueNumberString = pullRequest.url.absoluteString.split(separator: "/").last,
                let issueNumber = Int(issueNumberString)
                else { throw Abort(.notFound) }
            
            guard let testResults = try? testOutputToTestResults(output: output.message) else {
                return try github.postComment(
                    repo: repo,
                    issue: issueNumber,
                    body: "Performance tests failed in an unexpected way",
                    on: req
                )
            }
            
            var table =
"""
| Expected | Average |
| --- | --- |

"""
            let rows: String = testResults.map { result in
                "| \(result.expected) | \(result.average) |"
            }.joined(separator: "\n")
            
            table.append(contentsOf: rows)
            
            return try github.postComment(
                repo: repo,
                issue: issueNumber,
                body: table,
                on: req
            )
        }.transform(to: .ok)
    }
    
    struct TestResults: Codable {
        public let expected: Double
        public let average: Double
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
        
        let testResults = filterNonPerformance[2...].map { test in
            return (
                expected: Double(matches(for: "expected: [0-9\\.]*", in: String(test))[0].split(separator: " ")[1])!,
                average: Double(matches(for: "average: [0-9\\.]*", in: String(test))[0].split(separator: " ")[1])!
            )
        }
        
        let codableResults = testResults.map { TestResults(expected: $0.expected, average: $0.average) }
        
        return codableResults
    }
}
