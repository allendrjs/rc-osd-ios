import Foundation

/// POST /api/chat (Android: data/model/Chat.kt)
struct ChatMessage: Codable, Identifiable, Equatable {
    let id = UUID()
    let role: String      // "user" or "assistant"
    let content: String

    var isUser: Bool { role == "user" }

    enum CodingKeys: String, CodingKey { case role, content }

    init(role: String, content: String) {
        self.role = role
        self.content = content
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        role = try c.decode(String.self, forKey: .role)
        content = try c.decode(String.self, forKey: .content)
    }
}

struct ChatRequest: Encodable {
    let message: String
    let history: [ChatMessage]
}

struct ChatResponse: Decodable {
    let reply: String
    let timestamp: String?
}

struct QuickReply: Identifiable, Equatable {
    let id: String
    let label: String
}
