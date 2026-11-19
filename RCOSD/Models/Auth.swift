import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}

/// POST /login and POST /login/refresh
struct LoginResponse: Decodable {
    let token: String
    let username: String
    let role: String?
}

enum UserRole {
    static let student = "ROLE_USER"
}
