import Foundation

/// Single entry point for all backend calls.
/// - Adds `Authorization: Bearer <token>` to protected calls.
/// - Turns backend errors into `APIError` with the server's message.
/// - On 401 for a protected call, refreshes the token once and retries.
final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let tokenStore: TokenStore
    private let baseURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(baseURL: URL = AppConfig.apiBaseURL, tokenStore: TokenStore = .shared) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AppConfig.connectTimeout
        configuration.timeoutIntervalForResource = AppConfig.requestTimeout
        configuration.waitsForConnectivity = false
        self.session = URLSession(configuration: configuration)
        self.tokenStore = tokenStore
        self.baseURL = baseURL
    }

    // MARK: Public API

    /// JSON request with an optional JSON body.
    func send<Response: Decodable>(
        path: String,
        method: String = "GET",
        body: (any Encodable)? = nil,
        authorized: Bool = true
    ) async throws -> Response {
        let payload = try body.map { Payload(data: try encoder.encode(AnyEncodable($0)), contentType: "application/json") }
        let data = try await perform(path: path, method: method, payload: payload, authorized: authorized)
        return try decode(Response.self, from: data)
    }

    /// Request whose response body is ignored.
    func sendWithoutBody(path: String, method: String, authorized: Bool = true) async throws {
        _ = try await perform(path: path, method: method, payload: nil, authorized: authorized)
    }

    /// multipart/form-data upload of one file under the given field name (default "file").
    func upload<Response: Decodable>(
        path: String,
        fileData: Data,
        fileName: String,
        mimeType: String,
        fieldName: String = "file"
    ) async throws -> Response {
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        let safeName = fileName.replacingOccurrences(of: "\"", with: "")
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(safeName)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(fileData)
        body.append("\r\n--\(boundary)--\r\n")

        let payload = Payload(data: body, contentType: "multipart/form-data; boundary=\(boundary)")
        let data = try await perform(path: path, method: "POST", payload: payload, authorized: true)
        return try decode(Response.self, from: data)
    }

    // MARK: Internals

    private struct Payload {
        let data: Data
        let contentType: String
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }

    private func perform(
        path: String,
        method: String,
        payload: Payload?,
        authorized: Bool,
        isRetry: Bool = false
    ) async throws -> Data {
        let request = makeRequest(path: path, method: method, payload: payload, authorized: authorized)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            if (error as? URLError)?.code == .cancelled || error is CancellationError {
                throw CancellationError()
            }
            throw APIError.network
        }

        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }

        if (200..<300).contains(http.statusCode) {
            return data
        }

        if http.statusCode == 401, authorized, !isRetry {
            if await refreshToken() {
                return try await perform(path: path, method: method, payload: payload,
                                         authorized: authorized, isRetry: true)
            }
            NotificationCenter.default.post(name: .sessionExpired, object: nil)
            throw APIError.sessionExpired
        }

        let errorBody = try? decoder.decode(APIErrorBody.self, from: data)
        throw APIError.server(status: http.statusCode, code: errorBody?.code, message: errorBody?.message)
    }

    private func makeRequest(path: String, method: String, payload: Payload?, authorized: Bool) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let payload {
            request.setValue(payload.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = payload.data
        }
        if authorized, let token = tokenStore.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    /// Calls POST /login/refresh with the current token. Returns true when a new token was saved.
    private func refreshToken() async -> Bool {
        guard let token = tokenStore.token else { return false }
        var request = URLRequest(url: baseURL.appendingPathComponent("/login/refresh"))
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        guard let result = try? await session.data(for: request),
              (result.1 as? HTTPURLResponse)?.statusCode == 200,
              let refreshed = try? decoder.decode(LoginResponse.self, from: result.0) else {
            return false
        }
        tokenStore.updateToken(refreshed.token)
        return true
    }
}

/// Lets `send` accept any Encodable body.
private struct AnyEncodable: Encodable {
    private let encodeValue: (Encoder) throws -> Void
    init(_ value: any Encodable) { encodeValue = { encoder in try value.encode(to: encoder) } }
    func encode(to encoder: Encoder) throws { try encodeValue(encoder) }
}

private extension Data {
    mutating func append(_ string: String) {
        append(Data(string.utf8))
    }
}
