import SwiftUI

extension View {
    /// Runs `action` every `interval` seconds while the view is on screen and the app is
    /// active. Stops automatically when the view disappears (the task is cancelled).
    /// Matches the Android "refresh while visible" behavior (15 s).
    func autoRefresh(every interval: TimeInterval = 15, _ action: @escaping @Sendable () async -> Void) -> some View {
        modifier(AutoRefreshModifier(interval: interval, action: action))
    }
}

private struct AutoRefreshModifier: ViewModifier {
    let interval: TimeInterval
    let action: @Sendable () async -> Void
    @Environment(\.scenePhase) private var scenePhase

    func body(content: Content) -> some View {
        content.task(id: scenePhase) {
            guard scenePhase == .active else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                if Task.isCancelled { break }
                await action()
            }
        }
    }
}
