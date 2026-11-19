import Foundation

/// GET /api/handbook (Android: data/model/Handbook.kt)
struct HandbookResponse: Decodable {
    let department: String
    let sections: [HandbookSection]
}

struct HandbookSection: Decodable, Identifiable, Hashable {
    let id = UUID()
    let sectionTitle: String?
    let content: String

    enum CodingKeys: String, CodingKey { case sectionTitle, content }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        sectionTitle = try c.decodeIfPresent(String.self, forKey: .sectionTitle)
        content = try c.decodeIfPresent(String.self, forKey: .content) ?? ""
    }
}

/// GET /api/guardians/student/{studentId} (Android: data/model/Guardian.kt)
struct Guardian: Decodable, Identifiable {
    let guardianID: Int64
    let person: PersonRef?
    let contactNumber: String?
    let relationship: String?

    var id: Int64 { guardianID }
}
