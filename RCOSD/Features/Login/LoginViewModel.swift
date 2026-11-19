import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var studentId = "" { didSet { if studentId != oldValue { errorMessage = nil } } }
    @Published var password = "" { didSet { if password != oldValue { errorMessage = nil } } }
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    static let requiredMessage = "Student ID and password are required."
    static let studentsOnlyMessage = "This app is for students. Please use the web or desktop app."

    private let auth: AuthServicing

    init(auth: AuthServicing = AuthService()) {
        self.auth = auth
    }

    /// Returns the login response when sign-in succeeds, otherwise sets `errorMessage`.
    func login() async -> LoginResponse? {
        let id = studentId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !id.isEmpty, !password.isEmpty else {
            errorMessage = Self.requiredMessage
            return nil
        }
        guard !isLoading else { return nil }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await auth.login(studentId: id, password: password)
            guard response.role == nil || response.role == UserRole.student else {
                errorMessage = Self.studentsOnlyMessage
                return nil
            }
            password = ""
            return response
        } catch is CancellationError {
            return nil
        } catch {
            // Shows the server message, e.g. "Invalid username or password. Attempt 1 of 5."
            // or "Proceed to prefect office to request for account reactivation".
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? "Login failed. Please try again."
            return nil
        }
    }
}
