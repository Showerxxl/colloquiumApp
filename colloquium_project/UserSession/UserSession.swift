import Foundation

enum UserRole: String, Codable {
    case student
    case assistant
}

struct UserSession: Codable {
    let email: String
    let role: UserRole
}
