import SwiftUI

/// Bottom tab bar, same tabs as Android: Dashboard, Offenses, Appeal, Profile, Logout.
struct MainTabView: View {
    let studentId: String

    enum Tab: Hashable { case dashboard, offenses, appeal, profile, logout }
    enum Sheet: String, Identifiable { case chat, handbook; var id: String { rawValue } }

    @EnvironmentObject private var session: AppSession
    @StateObject private var recordsViewModel: RecordsViewModel
    @StateObject private var appealsViewModel: AppealsViewModel
    @State private var selection: Tab = .dashboard
    @State private var lastRealTab: Tab = .dashboard
    @State private var recordsPath: [Int64] = []
    @State private var confirmLogout = false
    @State private var sheet: Sheet?

    init(studentId: String) {
        self.studentId = studentId
        _recordsViewModel = StateObject(wrappedValue: RecordsViewModel(studentId: studentId))
        _appealsViewModel = StateObject(wrappedValue: AppealsViewModel(studentId: studentId))
    }

    var body: some View {
        TabView(selection: $selection) {
            DashboardView(
                studentId: studentId,
                onViewOffenses: { openOffenses() },
                onFileAppeal: { openAppeals() },
                onOpenChat: { sheet = .chat },
                onOpenHandbook: { sheet = .handbook }
            )
            .tabItem { Label("Dashboard", systemImage: "square.grid.2x2") }
            .tag(Tab.dashboard)

            RecordsView(viewModel: recordsViewModel, path: $recordsPath)
                .tabItem { Label("Offenses", systemImage: "list.bullet.rectangle") }
                .tag(Tab.offenses)

            AppealsView(viewModel: appealsViewModel, onGoToOffenses: { openOffenses() })
                .tabItem { Label("Appeal", systemImage: "doc.text") }
                .tag(Tab.appeal)

            ProfileView(studentId: studentId)
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(Tab.profile)

            // Acts as a button: selecting it asks to log out and returns to the previous tab.
            Color.clear
                .tabItem { Label("Logout", systemImage: "rectangle.portrait.and.arrow.right") }
                .tag(Tab.logout)
        }
        .tint(.osdaPrimary)
        .onChange(of: selection) { newValue in
            if newValue == .logout {
                selection = lastRealTab
                confirmLogout = true
            } else {
                lastRealTab = newValue
                // Keep counts fresh when switching tabs (e.g. after filing an appeal).
                if newValue == .appeal { Task { await appealsViewModel.load(silent: true) } }
                if newValue == .offenses { Task { await recordsViewModel.load(silent: true) } }
            }
        }
        .alert("Log out?", isPresented: $confirmLogout) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) { session.signOut() }
        }
        .sheet(item: $sheet) { item in
            switch item {
            case .chat:
                ChatView(studentId: studentId) { target in
                    // Wait for the sheet to close before switching tabs.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        if target == "appeals" { openAppeals() } else { openOffenses() }
                    }
                }
            case .handbook:
                HandbookView()
            }
        }
    }

    private func openOffenses() {
        recordsPath = []
        selection = .offenses
    }

    private func openAppeals() {
        selection = .appeal
    }
}
