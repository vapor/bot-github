import Foundation

public struct PerformanceTestResults: Codable {
    public let name: String
    public let expected: Double
    public let average: Double
    public let change: String
}

extension PerformanceTestResults: Rowable {
    public func fields() -> [String] {
        return [name, String(expected), String(average), change]
    }
}
