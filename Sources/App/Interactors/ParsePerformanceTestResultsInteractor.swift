import Foundation

public struct ParsePerformanceTestResultsInteractor {
    enum OutputParsingError: Error {
        case missingTestCases
    }
    
    public init() { }
    
    public func execute(output: String) throws -> [PerformanceTestResults] {
        let doubleChars = [(UInt32("0")...UInt32("9")), (UInt32(".")...UInt32("."))].joined().map { Character(UnicodeScalar($0)!) }
        
        let split = output.split(separator: "\r\n")
        let filterNonExpected = split.filter { $0.contains("[PERFORMANCE] test") }
        let filterNonPerformance = split.filter { $0.contains("measured [Time") }
        let expectedResults = filterNonExpected.map { $0.split(separator: " ")[3] }.map { str in str.filter { doubleChars.contains($0) } }.map { Double($0)! }
        let results = filterNonPerformance.map { $0.split(separator: " ")[8] }.map { str in str.filter { doubleChars.contains($0) } }.map { Double($0)! }
        let names = filterNonExpected.map { $0.split(separator: " ")[1] }.map { funcName in funcName.filter { ("A"..."z").contains($0) } }.map { String($0) }
        
        let testResults = zip(names, zip(results, expectedResults)).map { name, stats -> (name: String, expected: Double, average: Double, change: String) in
            let (average, expected) = stats
            
            return (
                name: name,
                expected: expected,
                average: average,
                change: "\(String(format:"%.2f", Double((expected - average))/expected * 100))%"
            )
        }
        
        let codableResults = testResults.map { PerformanceTestResults(name: $0.name, expected: $0.expected, average: $0.average, change: $0.change) }
        
        return codableResults
    }
}
