public protocol Rowable {
    
    /// Should return all properties that will become table fields as a list of strings
    ///
    /// - Returns: table fields in the form of strings
    func fields() -> [String]
}

public struct GithubTableGenerator {
    public var table = ""
    
    public init(columns: String..., rows: [Rowable]) {
        table.append("| \(columns.joined(separator: " | ")) |\n")
       
        let rows: String = rows.map { result in
            "| \(result.fields().joined(separator: " | ")) |"
        }.joined(separator: "\n")
        
        table.append(contentsOf: rows)
    }
}
