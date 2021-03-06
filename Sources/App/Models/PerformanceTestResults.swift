import Foundation
import Vapor
import FluentPostgreSQL

public struct PerformanceTestResults: Content {
    public var id: Int?
    public let date: Date
    public let repoName: String
    public let name: String
    public let expected: Double
    public let average: Double
    public let change: String
    
    public init(
        id: Int? = nil,
        date: Date,
        repoName: String,
        name: String,
        expected: Double,
        average: Double,
        change: String
    ) {
        self.id = id
        self.date = date
        self.repoName = repoName
        self.name = name
        self.expected = expected
        self.average = average
        self.change = change
    }
}

extension PerformanceTestResults: PostgreSQLModel { }
extension PerformanceTestResults: Migration { }

extension PerformanceTestResults: Rowable {
    public func fields() -> [String] {
        return [name, String(expected), String(average), change]
    }
}
