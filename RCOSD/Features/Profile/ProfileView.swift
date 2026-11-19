import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var enrollment: Enrollment?
    @Published private(set) var guardians: [Guardian] = []
    @Published private(set) var offensesCount = 0
    @Published private(set) var pendingAppealsCount = 0
    @Published private(set) var isLoading = false
    @Published private(set) var hasLoaded = false
    @Published private(set) var errorMessage: String?

    let studentId: String
    private let service: StudentDataServicing

    init(studentId: String, service: StudentDataServicing = StudentDataService()) {
        self.studentId = studentId
        self.service = service
    }

    var person: PersonRef? { enrollment?.student?.person }
    var fullName: String { person?.fullName ?? studentId }

    /// First guardian's number, same as Android's "Guardian's Contact".
    var guardianContact: String {
        guardians.compactMap(\.contactNumber).first { !$0.isEmpty } ?? "Not on file"
    }

    func load(silent: Bool = false) async {
        if !silent {
            isLoading = true
            errorMessage = nil
        }
        defer { isLoading = false }

        let service = self.service
        let id = studentId
        async let enrollmentResult = resultOf { try await service.latestEnrollment(studentId: id) }
        async let guardiansResult = resultOf { try await service.guardians(studentId: id) }
        async let recordsResult = resultOf { try await service.records(studentId: id) }
        async let appealsResult = resultOf { try await service.appeals(studentId: id) }
        let (e, g, r, a) = await (enrollmentResult, guardiansResult, recordsResult, appealsResult)

        if Task.isCancelled { return }

        if case .failure(let error) = e, case .failure = r {
            if (error as? APIError) == .sessionExpired { return }
            if !silent || !hasLoaded {
                errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't load your profile. Please try again."
            }
            return
        }
        if case .success(let value) = e { enrollment = value }
        if case .success(let value) = g { guardians = value }
        if case .success(let value) = r { offensesCount = value.count }
        if case .success(let value) = a { pendingAppealsCount = value.filter(\.isPending).count }
        errorMessage = nil
        hasLoaded = true
    }
}

/// Profile tab: personal and guardian information, dark mode.
struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @AppStorage("darkMode") private var darkMode = false

    init(studentId: String) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(studentId: studentId))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    HStack(spacing: 10) {
                        SummaryCard(value: viewModel.offensesCount, label: "Offenses", color: .osdaHeading)
                        SummaryCard(value: viewModel.pendingAppealsCount, label: "Pending Appeals", color: .osdaAmber)
                        levelCard
                    }

                    if let error = viewModel.errorMessage {
                        HStack {
                            Text(error).font(.footnote).foregroundStyle(Color.osdaError)
                            Spacer()
                            Button("Retry") { Task { await viewModel.load() } }.font(.footnote.weight(.semibold))
                        }
                    }

                    sectionTitle("Appearance")
                    OsdaCard {
                        Toggle("Dark Mode", isOn: $darkMode)
                            .tint(Color.osdaPrimary)
                            .foregroundStyle(Color.osdaHeading)
                    }

                    sectionTitle("Personal Information")
                    OsdaCard {
                        InfoRow(label: "Name", value: viewModel.fullName)
                        InfoRow(label: "Date of Birth", value: DateFormatting.date(viewModel.person?.dateOfBirth))
                        InfoRow(label: "Contact Number", value: nonEmpty(viewModel.enrollment?.student?.contactNumber) ?? "Not on file")
                        InfoRow(label: "Guardian's Contact", value: viewModel.guardianContact)
                        InfoRow(label: "Section", value: nonEmpty(viewModel.enrollment?.section) ?? "—")
                    }

                    sectionTitle("Guardians")
                    if viewModel.guardians.isEmpty {
                        Text("No guardian information on file.")
                            .font(.subheadline)
                            .foregroundStyle(Color.osdaMuted)
                    } else {
                        ForEach(viewModel.guardians) { guardian in
                            OsdaCard {
                                Text(guardian.person?.fullName ?? "Guardian")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(Color.osdaHeading)
                                if let relationship = nonEmpty(guardian.relationship) {
                                    Text(relationship).font(.caption).foregroundStyle(Color.osdaMuted)
                                }
                                InfoRow(label: "Contact Number", value: nonEmpty(guardian.contactNumber) ?? "Not on file")
                            }
                        }
                    }

                    Text("Information comes from the school's records. Ask the prefect office to correct any wrong details.")
                        .font(.caption)
                        .foregroundStyle(Color.osdaMuted)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.osdaBackground.ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable { await viewModel.load(silent: true) }
            .task { if !viewModel.hasLoaded { await viewModel.load() } }
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            Text(initials(viewModel.fullName))
                .font(.headline)
                .foregroundStyle(Color.osdaOnPrimary)
                .frame(width: 56, height: 56)
                .background(Circle().fill(Color.osdaPrimary))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.fullName)
                    .font(.headline)
                    .foregroundStyle(Color.osdaHeading)
                Text(["Student ID \(viewModel.studentId)", viewModel.enrollment?.section]
                        .compactMap { $0 }.joined(separator: "  •  "))
                    .font(.caption)
                    .foregroundStyle(Color.osdaMuted)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var levelCard: some View {
        VStack(spacing: 2) {
            Text(nonEmpty(viewModel.enrollment?.studentLevel) ?? "—")
                .font(.title3.weight(.bold))
                .foregroundStyle(Color.osdaHeading)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text("Year Level").font(.caption).foregroundStyle(Color.osdaMuted)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.osdaSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.osdaBorder, lineWidth: 1))
        .accessibilityElement(children: .combine)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(Color.osdaHeading)
            .accessibilityAddTraits(.isHeader)
    }

    private func initials(_ name: String) -> String {
        let parts = name.split(separator: " ")
        let letters = [parts.first, parts.count > 1 ? parts.last : nil].compactMap { $0?.first }
        return String(letters).uppercased()
    }

    private func nonEmpty(_ value: String?) -> String? {
        guard let value, !value.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        return value
    }
}

private struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label).font(.subheadline).foregroundStyle(Color.osdaMuted)
            Spacer(minLength: 12)
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.osdaHeading)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
