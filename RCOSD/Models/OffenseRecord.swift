import Foundation

/// GET /api/records/student/{studentId} (Android: data/model/OffenseRecord.kt)
struct OffenseRecord: Decodable, Identifiable, Hashable {
    let recordId: Int64
    let enrollment: EnrollmentSummary?
    let employee: EmployeeSummary?
    let offense: OffenseSummary
    let dateOfViolation: String
    let action: ActionSummary?
    let dateOfResolution: String?
    let remarks: String?
    let status: String

    var id: Int64 { recordId }

    var recordStatus: RecordStatus { RecordStatus(raw: status) }
}

/// PENDING (appealable), PROCESSING (appeal under review), APPROVED, RESOLVED
enum RecordStatus: String {
    case pending = "PENDING"
    case processing = "PROCESSING"
    case approved = "APPROVED"
    case resolved = "RESOLVED"
    case other

    init(raw: String) {
        self = RecordStatus(rawValue: raw.uppercased()) ?? .other
    }

    /// "Active" on the Records screen = PENDING or PROCESSING.
    var isActive: Bool { self == .pending || self == .processing }
    var isAppealable: Bool { self == .pending }
}
