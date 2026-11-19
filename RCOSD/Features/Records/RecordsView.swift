import SwiftUI

/// Offenses tab: list of the student's disciplinary records.
struct RecordsView: View {
    @ObservedObject var viewModel: RecordsViewModel
    @Binding var path: [Int64]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Track and view all logged offenses")
                            .font(.subheadline)
                            .foregroundStyle(Color.osdaMuted)
                    }

                    HStack(spacing: 10) {
                        SummaryCard(value: viewModel.totalCount, label: "Total", color: .osdaHeading)
                        SummaryCard(value: viewModel.activeCount, label: "Active", color: .osdaAmber)
                        SummaryCard(value: viewModel.resolvedCount, label: "Resolved", color: .osdaGreen)
                    }

                    Picker("Filter", selection: $viewModel.filter) {
                        ForEach(OffenseFilter.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    content
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.osdaBackground.ignoresSafeArea())
            .navigationTitle("My Disciplinary Records")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Int64.self) { recordId in
                OffenseDetailView(viewModel: viewModel, recordId: recordId)
            }
            .refreshable { await viewModel.load(silent: true) }
            .task { if !viewModel.hasLoaded { await viewModel.load() } }
            .autoRefresh { await viewModel.load(silent: true) }
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
            .padding(.vertical, 16)
        } else if viewModel.filteredRecords.isEmpty {
            Text("No offenses on file.")
                .font(.subheadline)
                .foregroundStyle(Color.osdaMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
        } else {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.filteredRecords) { record in
                    NavigationLink(value: record.recordId) {
                        OffenseCard(record: record)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

/// "OF-0012" style ID used on Android.
func offenseCode(_ recordId: Int64) -> String {
    "OF-" + String(format: "%04lld", recordId)
}

private struct OffenseCard: View {
    let record: OffenseRecord

    var body: some View {
        let style = StatusStyle.record(record.status)
        OsdaCard {
            HStack(alignment: .center, spacing: 8) {
                Text("OFFENSE ID: \(offenseCode(record.recordId))")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.osdaMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                StatusPill(text: StatusStyle.displayText(record.status), foreground: style.fg, background: style.bg)
            }
            Text(record.offense.offense)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.osdaHeading)
                .padding(.top, 4)
            Text("Filed: \(DateFormatting.dateTime(record.dateOfViolation))")
                .font(.caption)
                .foregroundStyle(Color.osdaMuted)
            if let resolved = record.dateOfResolution {
                Text("Resolved: \(DateFormatting.dateTime(resolved, fallback: resolved))")
                    .font(.caption)
                    .foregroundStyle(Color.osdaMuted)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens offense details")
    }
}

struct SummaryCard: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.title3.weight(.bold))
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.osdaMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.osdaSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.osdaBorder, lineWidth: 1))
        .accessibilityElement(children: .combine)
    }
}
