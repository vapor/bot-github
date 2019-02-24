import Foundation

public struct ParsePerformanceTestResultsInteractor {
    enum OutputParsingError: Error {
        case missingTestCases
    }
    
    public func execute(output: String) throws -> [PerformanceTestResults] {
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
        
        let codableResults = testResults.map { PerformanceTestResults(name: $0.name, expected: $0.expected, average: $0.average, change: $0.change) }
        
        return codableResults
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
