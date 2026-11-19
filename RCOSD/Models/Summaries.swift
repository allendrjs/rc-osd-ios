import Foundation

/// Small nested objects the backend embeds in records and appeals
/// (Android: data/model/Common.kt).

struct OffenseSummary: Decodable, Hashable {
    let offenseId: Int64
    let offense: String
    let type: String?
}

struct EmployeeSummary: Decodable, Hashable {
    let employeeId: String
    let fullName: String?
    let employeeRole: String?
}

struct ActionSummary: Decodable, Hashable {
    let actionId: Int64
    let actionName: String?
}

struct StudentSummary: Decodable, Hashable {
    let studentId: String
    let fullName: String?
}

struct EnrollmentSummary: Decodable, Hashable {
    let enrollmentId: Int64
    let student: StudentSummary?
    let schoolYear: String?
    let studentLevel: String?
    let section: String?
    let department: String?
}

struct RecordSummary: Decodable, Hashable {
    let recordId: Int64
    let offense: OffenseSummary?
    let status: String?
}
