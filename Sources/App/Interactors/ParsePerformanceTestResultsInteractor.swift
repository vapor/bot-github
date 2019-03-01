import Foundation
import Vapor
import FluentSQLite

public struct ParsePerformanceTestResultsInteractor {
    enum OutputParsingError: Error {
        case missingTestCases
    }
    
    
    public func execute(output: String, date: Date, repoName: String, on req: Request) throws -> Future<[PerformanceTestResults]> {
        let doubleChars = [(UInt32("0")...UInt32("9")), (UInt32(".")...UInt32("."))]
            .joined()
            .map { Character(UnicodeScalar($0)!) }
        
        let split = output.split(separator: "\r\n")
        let filterNonPerformance = split.filter { $0.contains("measured [Time") }
        let results = filterNonPerformance
            .map { $0.split(separator: " ")[8] }
            .map { str in str.filter { doubleChars.contains($0) } }
            .map { Double($0)! }
        let names = filterNonPerformance
            .map { $0.split(separator: " ")[3].split(separator: ".")[1] }
            .map { funcName in funcName.filter { ("A"..."z").contains($0) } }
            .map { String($0) }
        
        let partialTestResults = zip(names, results)
        
        let testResults = partialTestResults.map { (name, average) -> Future<(name: String, expected: Double, average: Double, change: String)> in
            
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
}
