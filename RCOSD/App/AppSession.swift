import Foundation

/// Holds who is signed in. The token itself lives in the Keychain.
@MainActor
final class AppSession: ObservableObject {
    @Published private(set) var studentId: String?

    var isSignedIn: Bool { studentId != nil }

    private let tokenStore: TokenStore

    init(tokenStore: TokenStore = .shared) {
        self.tokenStore = tokenStore
        if tokenStore.token != nil, let username = tokenStore.username {
            studentId = username
        }
    }

    func signIn(with response: LoginResponse) {
        tokenStore.save(token: response.token, username: response.username, role: response.role)
        studentId = response.username
    }

    func signOut() {
        let client = APIClient.shared
        Task { try? await client.sendWithoutBody(path: "/login/logout", method: "POST", authorized: false) }
        tokenStore.clear()
        studentId = nil
    }
}
