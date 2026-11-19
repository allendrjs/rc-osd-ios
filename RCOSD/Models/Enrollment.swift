import Foundation

/// GET /api/enrollments/student/{studentId}/latest
/// Field names match the Android model (data/model/Enrollment.kt).
struct Enrollment: Decodable {
    let enrollmentId: Int64
    let student: StudentRef?
    let schoolYear: String?
    let studentLevel: String?
    let section: String?
    let department: String?
    let disciplinaryStatus: DisciplinaryStatusRef?
}

struct StudentRef: Decodable {
    let studentId: String
    let person: PersonRef?
    let studentType: String?
    let department: String?
    let contactNumber: String?
}

struct PersonRef: Decodable {
    let lastName: String
    let firstName: String
    let middleName: String?
    let dateOfBirth: String?

    var fullName: String {
        [firstName, middleName, lastName]
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

struct DisciplinaryStatusRef: Decodable {
    let disciplinaryStatusId: Int64?
    let status: String?
    let description: String?
}
