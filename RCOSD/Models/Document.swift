import Foundation

/// POST /api/documents/upload (Android: data/model/Document.kt)
struct DocumentUploadResponse: Decodable {
    let documentId: Int64
    let extractedText: String?
    let aiSuggestion: String?

    /// Same rule as Android: very little readable text means the photo may be unclear.
    var looksUnreadable: Bool {
        guard let text = extractedText else { return false }
        return text.trimmingCharacters(in: .whitespacesAndNewlines).count < 25
    }
}
