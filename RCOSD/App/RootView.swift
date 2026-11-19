import SwiftUI

struct RootView: View {
    @EnvironmentObject private var session: AppSession
    /// Same as Android: light by default, Dark Mode switch on the Profile tab.
    @AppStorage("darkMode") private var darkMode = false

    var body: some View {
        Group {
            if let studentId = session.studentId {
                MainTabView(studentId: studentId)
                    .id(studentId)
            } else {
                LoginView()
            }
        }
        .preferredColorScheme(darkMode ? .dark : .light)
        .animation(.default, value: session.isSignedIn)
        .onReceive(NotificationCenter.default.publisher(for: .sessionExpired).receive(on: RunLoop.main)) { _ in
            session.signOut()
        }
    }
}
