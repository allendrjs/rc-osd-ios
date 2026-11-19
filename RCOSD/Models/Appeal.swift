import Foundation

/// GET /api/appeals/student/{studentId} (Android: data/model/Appeal.kt)
struct Appeal: Decodable, Identifiable, Hashable {
    let appealId: Int64
    let record: RecordSummary?
    let enrollment: EnrollmentSummary?
    let message: String
    let dateFiled: String?
    let status: String
    let dateProcessed: String?
    let remarks: String?
    let edited: Bool

    var id: Int64 { appealId }

    /// Same rule as Android: PENDING or UNDER_REVIEW counts as pending.
    var isPending: Bool { ["PENDING", "UNDER_REVIEW"].contains(status.uppercased()) }

    enum CodingKeys: String, CodingKey {
        case appealId, record, enrollment, message, dateFiled, status, dateProcessed, remarks, edited
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        appealId = try c.decode(Int64.self, forKey: .appealId)
        record = try c.decodeIfPresent(RecordSummary.self, forKey: .record)
        enrollment = try c.decodeIfPresent(EnrollmentSummary.self, forKey: .enrollment)
        message = try c.decodeIfPresent(String.self, forKey: .message) ?? ""
        dateFiled = try c.decodeIfPresent(String.self, forKey: .dateFiled)
        status = try c.decodeIfPresent(String.self, forKey: .status) ?? "PENDING"
        dateProcessed = try c.decodeIfPresent(String.self, forKey: .dateProcessed)
        remarks = try c.decodeIfPresent(String.self, forKey: .remarks)
        edited = try c.decodeIfPresent(Bool.self, forKey: .edited) ?? false
    }
}

/// POST /api/appeals
struct AppealSubmission: Encodable {
    let recordId: Int64
    let enrollmentId: Int64
    let message: String
    let documentId: Int64?
}

/// PUT /api/appeals/{id}
struct AppealUpdate: Encodable {
    let message: String
}
