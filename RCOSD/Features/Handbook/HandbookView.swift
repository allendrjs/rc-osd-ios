import SwiftUI

@MainActor
final class HandbookViewModel: ObservableObject {
    @Published private(set) var department: String?
    @Published private(set) var sections: [HandbookSection] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var query = ""

    private let service: StudentDataServicing
    private var loaded = false

    init(service: StudentDataServicing = StudentDataService()) {
        self.service = service
    }

    var filteredSections: [HandbookSection] {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return sections }
        return sections.filter {
            ($0.sectionTitle?.localizedCaseInsensitiveContains(q) ?? false) || $0.content.localizedCaseInsensitiveContains(q)
        }
    }

    func loadIfNeeded() async {
        guard !loaded else { return }
        await load()
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await service.handbook()
            department = response.department
            sections = response.sections
            loaded = true
        } catch is CancellationError {
            return
        } catch {
            if (error as? APIError) == .sessionExpired { return }
            errorMessage = (error as? APIError)?.errorDescription
                ?? "Couldn't load the Student Handbook right now. Please try again."
        }
    }
}

/// "Student Handbook", opened as a sheet from the Dashboard.
struct HandbookView: View {
    @StateObject private var viewModel = HandbookViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if let department = viewModel.department {
                        Text("\(department) Student Handbook")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.osdaMuted)
                    }
                    content
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.osdaBackground.ignoresSafeArea())
            .navigationTitle("Student Handbook")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search the handbook…")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } }
            }
            .task { await viewModel.loadIfNeeded() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.sections.isEmpty {
            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 24)
        } else if let error = viewModel.errorMessage {
            VStack(spacing: 8) {
                Text(error).font(.footnote).foregroundStyle(Color.osdaError).multilineTextAlignment(.center)
                Button("Retry") { Task { await viewModel.load() } }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        } else if viewModel.sections.isEmpty {
            Text("No handbook content is available yet for your department.")
                .font(.subheadline)
                .foregroundStyle(Color.osdaMuted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
        } else if viewModel.filteredSections.isEmpty {
            Text("No sections match \"\(viewModel.query)\".")
                .font(.subheadline)
                .foregroundStyle(Color.osdaMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
        } else {
            ForEach(viewModel.filteredSections) { section in
                HandbookSectionCard(section: section)
            }
        }
    }
}

private struct HandbookSectionCard: View {
    let section: HandbookSection
    @State private var expanded = false

    var body: some View {
        OsdaCard {
            DisclosureGroup(isExpanded: $expanded) {
                Text(section.content)
                    .font(.subheadline)
                    .foregroundStyle(Color.osdaHeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                    .textSelection(.enabled)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(section.sectionTitle ?? "Handbook Section")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.osdaHeading)
                        .multilineTextAlignment(.leading)
                    if !expanded {
                        Text(section.content)
                            .font(.caption)
                            .foregroundStyle(Color.osdaMuted)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .tint(Color.osdaMuted)
        }
    }
}
