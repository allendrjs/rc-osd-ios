import Foundation

enum OffenseFilter: String, CaseIterable, Identifiable {
    case all = "All", active = "Active", resolved = "Resolved"
    var id: String { rawValue }
}

/// Shared by the Records list, Offense Details and the File Appeal screen.
@MainActor
final class RecordsViewModel: ObservableObject {
    @Published private(set) var records: [OffenseRecord] = []
    @Published private(set) var appeals: [Appeal] = []
    @Published private(set) var enrollmentId: Int64?
    @Published private(set) var isLoading = false
    @Published private(set) var hasLoaded = false
    @Published private(set) var errorMessage: String?
    @Published var filter: OffenseFilter = .all

    let studentId: String
    private let service: StudentDataServicing

    init(studentId: String, service: StudentDataServicing = StudentDataService()) {
        self.studentId = studentId
        self.service = service
    }

    var filteredRecords: [OffenseRecord] {
        switch filter {
        case .all: return records
        case .active: return records.filter { $0.recordStatus.isActive || $0.recordStatus == .other }
        case .resolved: return records.filter { !$0.recordStatus.isActive && $0.recordStatus != .other }
        }
    }

    var totalCount: Int { records.count }
    var resolvedCount: Int { records.filter { $0.recordStatus == .resolved || $0.recordStatus == .approved }.count }
    var activeCount: Int { totalCount - resolvedCount }

    func record(id: Int64) -> OffenseRecord? {
        records.first { $0.recordId == id }
    }

    /// True when any appeal already exists for this record (same rule as Android).
    func hasAppeal(recordId: Int64) -> Bool {
        appeals.contains { $0.record?.recordId == recordId }
    }

    func load(silent: Bool = false) async {
        if !silent {
            isLoading = true
            errorMessage = nil
        }
        defer { isLoading = false }

        let service = self.service
        let id = studentId
        async let recordsResult = resultOf { try await service.records(studentId: id) }
        async let appealsResult = resultOf { try await service.appeals(studentId: id) }
        async let enrollmentResult = resultOf { try await service.latestEnrollment(studentId: id) }
        let (recordsOutcome, appealsOutcome, enrollmentOutcome) = await (recordsResult, appealsResult, enrollmentResult)

        if Task.isCancelled { return }

        switch recordsOutcome {
        case .success(let list):
            records = list.sorted {
                (DateFormatting.parse($0.dateOfViolation) ?? .distantPast) > (DateFormatting.parse($1.dateOfViolation) ?? .distantPast)
            }
            if case .success(let list) = appealsOutcome { appeals = list }
            if case .success(let enrollment) = enrollmentOutcome { enrollmentId = enrollment.enrollmentId }
            errorMessage = nil
            hasLoaded = true
        case .failure(let error):
            guard !silent || !hasLoaded else { return }
            if (error as? APIError) == .sessionExpired { return }
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't load your offenses. Please try again."
        }
    }
}
