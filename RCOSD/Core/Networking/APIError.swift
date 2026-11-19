import Foundation

/// Backend error body: {timestamp, status, code, message}
struct APIErrorBody: Decodable {
    let status: Int?
    let code: String?
    let message: String?
}

enum APIError: LocalizedError, Equatable {
    /// The server answered with an error. `message` is shown to the user when present.
    case server(status: Int, code: String?, message: String?)
    /// The session is no longer valid and could not be refreshed.
    case sessionExpired
    /// No internet, timeout or server unreachable.
    case network
    /// The response could not be read.
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case let .server(status, _, message):
            if let message, !message.isEmpty { return message }
            switch status {
            case 401: return "Invalid username or password."
            case 403: return "You do not have access to this."
            case 404: return "The requested item was not found."
            case 413: return "That file is too large to upload. Please attach a smaller file."
            default: return "Something went wrong. Please try again."
            }
        case .sessionExpired:
            return "Your session has ended. Please sign in again."
        case .network:
            return "Can't reach the server. Check your internet connection and try again."
        case .invalidResponse:
            return "Something went wrong. Please try again."
        }
    }

    var code: String? {
        if case let .server(_, code, _) = self { return code }
        return nil
    }
}

extension Notification.Name {
    /// Posted when a protected call fails and the token cannot be refreshed.
    static let sessionExpired = Notification.Name("RCOSDSessionExpired")
}
