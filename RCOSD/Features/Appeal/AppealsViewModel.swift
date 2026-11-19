import Foundation

enum AppealFilter: String, CaseIterable, Identifiable {
    case all = "All", pending = "Pending", approved = "Approved", denied = "Denied"
    var id: String { rawValue }
}

/// Appeal tab: "My Appeals" list and editing a pending appeal.
@MainActor
final class AppealsViewModel: ObservableObject {
    @Published private(set) var appeals: [Appeal] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasLoaded = false
    @Published private(set) var errorMessage: String?
    @Published var filter: AppealFilter = .all

    // Editing
    @Published var editingAppeal: Appeal?
    @Published var editMessage = "" { didSet { if editMessage != oldValue { editError = nil } } }
    @Published private(set) var isSavingEdit = false
    @Published private(set) var editError: String?

    let studentId: String
    private let dataService: StudentDataServicing
    private let appealService: AppealServicing

    init(studentId: String,
         dataService: StudentDataServicing = StudentDataService(),
         appealService: AppealServicing = AppealService()) {
        self.studentId = studentId
        self.dataService = dataService
        self.appealService = appealService
    }

    var filteredAppeals: [Appeal] {
        switch filter {
        case .all: return appeals
        case .pending: return appeals.filter(\.isPending)
        case .approved: return appeals.filter { $0.status.uppercased() == "APPROVED" }
        case .denied: return appeals.filter { $0.status.uppercased() == "DENIED" }
        }
    }

    var totalCount: Int { appeals.count }
    var pendingCount: Int { appeals.filter(\.isPending).count }
    var approvedCount: Int { appeals.filter { $0.status.uppercased() == "APPROVED" }.count }
    var deniedCount: Int { appeals.filter { $0.status.uppercased() == "DENIED" }.count }

    func load(silent: Bool = false) async {
        if !silent {
            isLoading = true
            errorMessage = nil
        }
        defer { isLoading = false }
        do {
            let list = try await dataService.appeals(studentId: studentId)
            appeals = Self.sortedNewestFirst(list)
            errorMessage = nil
            hasLoaded = true
        } catch is CancellationError {
            return
        } catch {
            guard !silent || !hasLoaded else { return }
            if (error as? APIError) == .sessionExpired { return }
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't load your appeals. Please try again."
        }
    }

    // MARK: Edit

    func startEdit(_ appeal: Appeal) {
        guard appeal.isPending else { return }
        editMessage = appeal.message
        editError = nil
        editingAppeal = appeal
    }

    func cancelEdit() {
        editingAppeal = nil
        editError = nil
    }

    func saveEdit() async {
        guard let appeal = editingAppeal, !isSavingEdit else { return }
        let newMessage = editMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !newMessage.isEmpty else {
            editError = "Appeal message is required."
            return
        }
        if newMessage == appeal.message.trimmingCharacters(in: .whitespacesAndNewlines) {
            cancelEdit()
            return
        }
        isSavingEdit = true
        defer { isSavingEdit = false }
        do {
            _ = try await appealService.update(appealId: appeal.appealId, message: newMessage)
            editingAppeal = nil
            await load(silent: true)
        } catch is CancellationError {
            return
        } catch {
            editError = (error as? APIError)?.errorDescription ?? "Couldn't save your changes. Please try again."
        }
    }

    static func sortedNewestFirst(_ list: [Appeal]) -> [Appeal] {
        list.sorted { (DateFormatting.parse($0.dateFiled) ?? .distantPast) > (DateFormatting.parse($1.dateFiled) ?? .distantPast) }
    }
}
