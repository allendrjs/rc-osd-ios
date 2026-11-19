import SwiftUI

/// Appeal tab: "My Appeals".
struct AppealsView: View {
    @ObservedObject var viewModel: AppealsViewModel
    var onGoToOffenses: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Create and file offense appeals")
                        .font(.subheadline)
                        .foregroundStyle(Color.osdaMuted)

                    HStack(spacing: 8) {
                        SummaryCard(value: viewModel.totalCount, label: "Total Filed", color: .osdaHeading)
                        SummaryCard(value: viewModel.pendingCount, label: "Pending", color: .osdaAmber)
                        SummaryCard(value: viewModel.approvedCount, label: "Approved", color: .osdaGreen)
                        SummaryCard(value: viewModel.deniedCount, label: "Denied", color: .osdaRed)
                    }

                    Picker("Filter", selection: $viewModel.filter) {
                        ForEach(AppealFilter.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    content

                    Button(action: onGoToOffenses) {
                        Label("To file a new appeal, open an offense in the Offenses tab", systemImage: "info.circle")
                            .font(.footnote)
                            .foregroundStyle(Color.osdaPrimary)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.osdaBackground.ignoresSafeArea())
            .navigationTitle("My Appeals")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable { await viewModel.load(silent: true) }
            .task { if !viewModel.hasLoaded { await viewModel.load() } }
            .autoRefresh { await viewModel.load(silent: true) }
            .sheet(item: $viewModel.editingAppeal) { _ in
                EditAppealSheet(viewModel: viewModel)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && !viewModel.hasLoaded {
            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 24)
        } else if let message = viewModel.errorMessage, !viewModel.hasLoaded {
            VStack(spacing: 8) {
                Text(message).font(.footnote).foregroundStyle(Color.osdaError)
                Button("Retry") { Task { await viewModel.load() } }
            }
            .frame(maxWidth: .infinity)
        } else if viewModel.filteredAppeals.isEmpty {
            Text("No appeals to show.")
                .font(.subheadline)
                .foregroundStyle(Color.osdaMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
        } else {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.filteredAppeals) { appeal in
                    AppealCard(appeal: appeal,
                               onEdit: appeal.isPending ? { viewModel.startEdit(appeal) } : nil)
                }
            }
        }
    }
}

/// "AP-0007" style ID used on Android.
func appealCode(_ appealId: Int64) -> String {
    "AP-" + String(format: "%04lld", appealId)
}

private struct AppealCard: View {
    let appeal: Appeal
    var onEdit: (() -> Void)?

    var body: some View {
        let style = StatusStyle.appeal(appeal.status)
        OsdaCard {
            HStack(spacing: 8) {
                Text("APPEAL ID: \(appealCode(appeal.appealId))")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.osdaMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                StatusPill(text: StatusStyle.displayText(appeal.status), foreground: style.fg, background: style.bg)
            }
            Text(appeal.record?.offense?.offense ?? "Offense")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.osdaHeading)
                .padding(.top, 4)
            Text("Reason:")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.osdaHeading)
                .padding(.top, 4)
            Text(appeal.message)
                .font(.footnote)
                .foregroundStyle(Color.osdaMuted)
            if appeal.edited {
                Text("Edited")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.osdaPrimary)
            }
            if let onEdit {
                Button(action: onEdit) {
                    Label("Edit appeal", systemImage: "pencil")
                        .font(.footnote.weight(.semibold))
                        .frame(minHeight: 44)
                }
                .foregroundStyle(Color.osdaPrimary)
            }
            Text("Submitted \(DateFormatting.dateTime(appeal.dateFiled))")
                .font(.caption)
                .foregroundStyle(Color.osdaMuted)
            Text("Date of Resolution: \(appeal.dateProcessed == nil ? "Not yet resolved" : DateFormatting.dateTime(appeal.dateProcessed))")
                .font(.caption)
                .foregroundStyle(Color.osdaMuted)
            if let remarks = appeal.remarks, !remarks.isEmpty {
                Text("Remarks: \(remarks)")
                    .font(.caption)
                    .foregroundStyle(Color.osdaMuted)
            }
        }
    }
}

private struct EditAppealSheet: View {
    @ObservedObject var viewModel: AppealsViewModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                if let appeal = viewModel.editingAppeal {
                    Text(appeal.record?.offense?.offense ?? "Offense")
                        .font(.headline)
                        .foregroundStyle(Color.osdaHeading)
                }
                TextEditor(text: $viewModel.editMessage)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .frame(minHeight: 160)
                    .background(Color.osdaSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.osdaBorder))
                    .accessibilityLabel("Appeal message")
                if let error = viewModel.editError {
                    Text(error).font(.footnote).foregroundStyle(Color.osdaError)
                }
                Spacer()
            }
            .padding(20)
            .background(Color.osdaBackground.ignoresSafeArea())
            .navigationTitle("Edit appeal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.cancelEdit() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isSavingEdit {
                        ProgressView()
                    } else {
                        Button("Save") { Task { await viewModel.saveEdit() } }
                    }
                }
            }
            .interactiveDismissDisabled(viewModel.isSavingEdit)
        }
        .presentationDetents([.medium, .large])
    }
}
