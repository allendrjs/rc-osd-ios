import Foundation

protocol ChatServicing {
    func ask(message: String, history: [ChatMessage]) async throws -> ChatResponse
}

struct ChatService: ChatServicing {
    var client: APIClient = .shared

    func ask(message: String, history: [ChatMessage]) async throws -> ChatResponse {
        try await client.send(path: "/api/chat", method: "POST",
                              body: ChatRequest(message: message, history: history))
    }
}
