import Foundation

/// Read-only student data used by several screens.
protocol StudentDataServicing {
    func latestEnrollment(studentId: String) async throws -> Enrollment
    func records(studentId: String) async throws -> [OffenseRecord]
    func appeals(studentId: String) async throws -> [Appeal]
    func guardians(studentId: String) async throws -> [Guardian]
    func handbook() async throws -> HandbookResponse
}

struct StudentDataService: StudentDataServicing {
    var client: APIClient = .shared

    func latestEnrollment(studentId: String) async throws -> Enrollment {
        try await client.send(path: "/api/enrollments/student/\(studentId)/latest")
    }

    func records(studentId: String) async throws -> [OffenseRecord] {
        try await client.send(path: "/api/records/student/\(studentId)")
    }

    func appeals(studentId: String) async throws -> [Appeal] {
        try await client.send(path: "/api/appeals/student/\(studentId)")
    }

    func guardians(studentId: String) async throws -> [Guardian] {
        try await client.send(path: "/api/guardians/student/\(studentId)")
    }

    /// The backend returns the handbook for the signed-in student's own department.
    func handbook() async throws -> HandbookResponse {
        try await client.send(path: "/api/handbook")
    }
}
