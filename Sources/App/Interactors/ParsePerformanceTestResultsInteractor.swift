import Foundation
import Vapor
import FluentSQLite

public struct ParsePerformanceTestResultsInteractor {
    enum OutputParsingError: Error {
        case missingTestCases
    }
    
    public func execute(output: String, date: Date, repoName: String, on req: Request) throws -> Future<[PerformanceTestResults]> {
        // TODO: Remove reliance on [PERFORMANCE]
        let replaced = output.replacingOccurrences(of: "[PERFORMANCE]", with: "🔤")
        let split = replaced.split(separator: "🔤")
        let filterNonPerformance = split.filter { $0.contains("performance") }
        
        guard filterNonPerformance.count >= 3 else { throw OutputParsingError.missingTestCases }
        
        let testResults = filterNonPerformance.map { (test: String.SubSequence) -> Future<(name: String, expected: Double, average: Double, change: String)> in
//            let expected = Double(matches(for: "expected: [0-9\\.]*", in: String(test))[0].split(separator: " ")[1])!
            let name = String(matches(for: ".*\\(\\)", in: String(test))[0].split(separator: "(")[0])
            
            return PerformanceTestResults
                .query(on: req)
                .filter(\.repoName == repoName)
                .filter(\.name == name)
                .sort(\PerformanceTestResults.date, SQLiteDirection.ascending)
                .first()
                // TODO: Don't actually abort. We need to handle the case that there's no initial data,
                // and provide some default baseline
                .unwrap(or: Abort(.notFound))
                .map { result in
                    let average = Double(self.matches(for: "average: [0-9\\.]*", in: String(test))[0].split(separator: " ")[1])!
                    let expected = result.average
                    
                    return (
                        name: name,
                        expected: expected,
                        average: average,
                        change: "\(String(format:"%.2f", Double((expected - average))/expected * 100))%"
                    )
                }
            
        }.flatten(on: req)
        
        return testResults.map { results in
            results.map { result in
                PerformanceTestResults(
                    date: date,
                    repoName: repoName,
                    name: result.name,
                    expected: result.expected,
                    average: result.average,
                    change: result.change
                )

            }
        }
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
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
    
}
