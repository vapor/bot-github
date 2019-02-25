import Vapor

public enum PermissionLevel: String, Codable {
    case none
    case read
    case write
    case admin
    
    func meetsRequirement(target: PermissionLevel) -> Bool {
        let ordered: [PermissionLevel] = [.none, .read, .write, .admin]
        
        for item in ordered {
            if item == self {
                return true
            } else if item == target {
                return false
            }
        }
        return false
    }
}

public struct GithubPermissionLevel: Content {
    public let level: PermissionLevel
    
    enum CodingKeys: String, CodingKey {
        case level = "permission"
    }
}
