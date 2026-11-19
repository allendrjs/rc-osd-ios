import Foundation

protocol AppealServicing {
    func submit(_ submission: AppealSubmission) async throws -> Appeal
    func update(appealId: Int64, message: String) async throws -> Appeal
    func uploadLetter(_ file: AttachmentFile) async throws -> DocumentUploadResponse
}

struct AppealService: AppealServicing {
    var client: APIClient = .shared

    func submit(_ submission: AppealSubmission) async throws -> Appeal {
        try await client.send(path: "/api/appeals", method: "POST", body: submission)
    }

    func update(appealId: Int64, message: String) async throws -> Appeal {
        try await client.send(path: "/api/appeals/\(appealId)", method: "PUT", body: AppealUpdate(message: message))
    }

    func uploadLetter(_ file: AttachmentFile) async throws -> DocumentUploadResponse {
        try await client.upload(path: "/api/documents/upload",
                                fileData: file.data, fileName: file.fileName, mimeType: file.mimeType)
    }
}
