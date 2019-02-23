import Foundation

struct TestResults: Codable {
    public let name: String
    public let expected: Double
    public let average: Double
    public let change: String
}

extension TestResults: Rowable {
    func fields() -> [String] {
        return [name, String(expected), String(average), change]
    }
}
