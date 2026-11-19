import Foundation

protocol AuthServicing {
    func login(studentId: String, password: String) async throws -> LoginResponse
}

struct AuthService: AuthServicing {
    var client: APIClient = .shared

    func login(studentId: String, password: String) async throws -> LoginResponse {
        try await client.send(
            path: "/login",
            method: "POST",
            body: LoginRequest(username: studentId, password: password),
            authorized: false
        )
    }
}
