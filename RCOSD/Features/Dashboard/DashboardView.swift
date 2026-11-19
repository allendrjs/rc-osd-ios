import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel

    var onViewOffenses: () -> Void
    var onFileAppeal: () -> Void
    var onOpenChat: () -> Void
    var onOpenHandbook: () -> Void

    init(studentId: String,
         onViewOffenses: @escaping () -> Void,
         onFileAppeal: @escaping () -> Void,
         onOpenChat: @escaping () -> Void,
         onOpenHandbook: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(studentId: studentId))
        self.onViewOffenses = onViewOffenses
        self.onFileAppeal = onFileAppeal
        self.onOpenChat = onOpenChat
        self.onOpenHandbook = onOpenHandbook
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    welcomeCard
                    if let message = viewModel.state.errorMessage {
                        errorBanner(message)
                    }
                    statRow
                    sectionTitle("Quick Actions")
                    quickActions
                    sectionTitle("Recent Activity")
                    recentActivity
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.osdaBackground.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .refreshable { await viewModel.load(silent: true) }
            .task {
                if !viewModel.state.hasLoaded { await viewModel.load() }
            }
            .autoRefresh { await viewModel.load(silent: true) }
        }
    }

    // MARK: Sections

    private var welcomeCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome back, \(viewModel.displayName)")
                .font(.headline)
                .foregroundStyle(Color.osdaOnPrimary)
            Text(viewModel.subtitle)
                .font(.caption)
                .foregroundStyle(Color.osdaOnPrimary.opacity(0.75))
            if let status = viewModel.disciplinaryStatus {
                StatusPill(
                    text: status,
                    foreground: viewModel.isGoodStanding ? .osdaGreen : .osdaAmber,
                    background: viewModel.isGoodStanding ? .osdaGreenBg : .osdaAmberBg
                )
                .padding(.top, 6)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.osdaPrimary))
        .accessibilityElement(children: .combine)
    }

    private func errorBanner(_ message: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(message)
                .font(.footnote)
                .foregroundStyle(Color.osdaError)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button("Retry") { Task { await viewModel.load() } }
                .font(.footnote.weight(.semibold))
        }
    }

    private var statRow: some View {
        HStack(spacing: 10) {
            StatCard(value: "\(viewModel.state.offensesCount)", label: "Offenses", color: .osdaHeading)
            StatCard(value: "\(viewModel.state.pendingAppealsCount)", label: "Pending Appeals", color: .osdaAmber)
            StatCard(value: viewModel.state.enrollment?.studentLevel ?? "—", label: "Year/Grade", color: .osdaHeading)
        }
        .redacted(reason: viewModel.state.isLoading && !viewModel.state.hasLoaded ? .placeholder : [])
    }

    private var quickActions: some View {
        VStack(spacing: 10) {
            QuickActionRow(title: "View Offenses", subtitle: "See your disciplinary records",
                           systemImage: "list.bullet.rectangle", action: onViewOffenses)
            QuickActionRow(title: "File an Appeal", subtitle: "Request a review of a case",
                           systemImage: "doc.text", action: onFileAppeal)
            QuickActionRow(title: "Ask the Chatbot", subtitle: "Get answers about your offenses and appeals",
                           systemImage: "bubble.left.and.bubble.right", action: onOpenChat)
            QuickActionRow(title: "Student Handbook", subtitle: "Read the policies for your department",
                           systemImage: "book", action: onOpenHandbook)
        }
    }

    @ViewBuilder
    private var recentActivity: some View {
        if viewModel.state.isLoading && !viewModel.state.hasLoaded {
            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 12)
        } else if viewModel.state.recentActivity.isEmpty {
            Text("Nothing to show yet.")
                .font(.subheadline)
                .foregroundStyle(Color.osdaMuted)
                .padding(.vertical, 8)
        } else {
            VStack(spacing: 10) {
                ForEach(viewModel.state.recentActivity) { item in
                    OsdaCard {
                        Text(item.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.osdaHeading)
                        Text(item.subtitle)
                            .font(.caption)
                            .foregroundStyle(Color.osdaMuted)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(Color.osdaHeading)
            .padding(.top, 4)
            .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Building blocks

private struct StatCard: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.osdaMuted)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 6)
        .frame(maxWidth: .infinity)
        .background(Color.osdaSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.osdaBorder, lineWidth: 1))
        .accessibilityElement(children: .combine)
    }
}

private struct QuickActionRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.osdaPrimary)
                    .frame(width: 40, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.osdaPrimaryMuted.opacity(0.35)))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.osdaHeading)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.osdaMuted)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.osdaMuted)
                    .accessibilityHidden(true)
            }
            .padding(12)
            .background(Color.osdaSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.osdaBorder, lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(subtitle)
    }
}
