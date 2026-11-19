import Foundation

/// One row in "Recent Activity".
struct ActivityItem: Identifiable, Equatable {
    enum Kind: Equatable { case offenseLogged, appealUpdated(status: String) }

    let id: String
    let kind: Kind
    let offenseName: String
    let rawDate: String?

    var title: String {
        switch kind {
        case .offenseLogged: return "New Offense Logged"
        case let .appealUpdated(status): return "Appeal \(StatusStyle.displayText(status))"
        }
    }

    var subtitle: String {
        "\(offenseName)  •  \(DateFormatting.dateTime(rawDate))"
    }
}

struct DashboardState {
    var isLoading = false
    var hasLoaded = false
    var enrollment: Enrollment?
    var offensesCount = 0
    var pendingAppealsCount = 0
    var recentActivity: [ActivityItem] = []
    var errorMessage: String?
}

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var state = DashboardState()

    let studentId: String
    private let service: StudentDataServicing

    init(studentId: String, service: StudentDataServicing = StudentDataService()) {
        self.studentId = studentId
        self.service = service
    }

    var displayName: String {
        state.enrollment?.student?.person?.fullName ?? studentId
    }

    /// "Extern  •  IT501  •  Student ID CT23-0002" (same pieces as Android)
    var subtitle: String {
        let parts = [state.enrollment?.student?.studentType, state.enrollment?.section]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
        return (parts + ["Student ID \(studentId)"]).joined(separator: "  •  ")
    }

    var disciplinaryStatus: String? {
        state.enrollment?.disciplinaryStatus?.status
    }

    var isGoodStanding: Bool {
        disciplinaryStatus?.localizedCaseInsensitiveContains("good") ?? false
    }

    /// Loads everything. `silent` is used for pull-to-refresh and auto-refresh:
    /// no spinner, and existing data stays on screen if a refresh fails.
    func load(silent: Bool = false) async {
        if !silent {
            state.isLoading = true
            state.errorMessage = nil
        }
        defer { state.isLoading = false }

        let service = self.service
        let id = studentId
        async let enrollmentResult = resultOf { try await service.latestEnrollment(studentId: id) }
        async let recordsResult = resultOf { try await service.records(studentId: id) }
        async let appealsResult = resultOf { try await service.appeals(studentId: id) }

        let (enrollment, records, appeals) = await (enrollmentResult, recordsResult, appealsResult)

        if Task.isCancelled { return }

        // Like Android, each part fails on its own. Only show an error if nothing loaded.
        if case .failure(let error) = records, case .failure = appeals, case .failure = enrollment {
            if !silent || !state.hasLoaded {
                state.errorMessage = Self.message(for: error)
            }
            return
        }

        if case .success(let value) = enrollment { state.enrollment = value }
        let recordList = (try? records.get()) ?? []
        let appealList = (try? appeals.get()) ?? []

        state.offensesCount = recordList.count
        state.pendingAppealsCount = appealList.filter(\.isPending).count
        state.recentActivity = Self.recentActivity(records: recordList, appeals: appealList)
        state.errorMessage = nil
        state.hasLoaded = true
    }

    /// Latest 3 events: offenses logged and decided appeals, newest first.
    static func recentActivity(records: [OffenseRecord], appeals: [Appeal]) -> [ActivityItem] {
        let fromRecords = records.map {
            ActivityItem(id: "record-\($0.recordId)", kind: .offenseLogged,
                         offenseName: $0.offense.offense, rawDate: $0.dateOfViolation)
        }
        let fromAppeals = appeals.filter { !$0.isPending }.map {
            ActivityItem(id: "appeal-\($0.appealId)", kind: .appealUpdated(status: $0.status),
                         offenseName: $0.record?.offense?.offense ?? "Offense",
                         rawDate: $0.dateProcessed ?? $0.dateFiled)
        }
        return (fromRecords + fromAppeals)
            .sorted { (DateFormatting.parse($0.rawDate) ?? .distantPast) > (DateFormatting.parse($1.rawDate) ?? .distantPast) }
            .prefix(3)
            .map { $0 }
    }

    private static func message(for error: Error) -> String? {
        if let apiError = error as? APIError {
            if apiError == .sessionExpired { return nil }
            return apiError.errorDescription
        }
        return "Couldn't load your dashboard. Please try again."
    }
}

/// Runs `work` and returns its outcome as a Result instead of throwing.
func resultOf<T>(_ work: () async throws -> T) async -> Result<T, Error> {
    do { return .success(try await work()) } catch { return .failure(error) }
}
