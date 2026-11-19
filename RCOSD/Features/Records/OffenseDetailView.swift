import SwiftUI

struct OffenseDetailView: View {
    @ObservedObject var viewModel: RecordsViewModel
    let recordId: Int64

    @State private var showFileAppeal = false

    var body: some View {
        Group {
            if let record = viewModel.record(id: recordId) {
                details(record)
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Text("This offense couldn't be found.")
                    .foregroundStyle(Color.osdaMuted)
                    .padding(20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.osdaBackground.ignoresSafeArea())
        .navigationTitle("Offense Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showFileAppeal) {
            FileAppealView(viewModel: viewModel, recordId: recordId)
        }
    }

    private func details(_ record: OffenseRecord) -> some View {
        let style = StatusStyle.record(record.status)
        let alreadyAppealed = viewModel.hasAppeal(recordId: record.recordId)
        let canAppeal = record.recordStatus.isAppealable && !alreadyAppealed

        return VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    OsdaCard {
                        HStack {
                            Text("OFFENSE ID: \(offenseCode(record.recordId))")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.osdaMuted)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            StatusPill(text: StatusStyle.displayText(record.status), foreground: style.fg, background: style.bg)
                        }
                        Text(record.offense.offense)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color.osdaHeading)
                            .padding(.top, 6)
                    }

                    OsdaCard {
                        Text("Details")
                            .font(.headline)
                            .foregroundStyle(Color.osdaHeading)
                            .padding(.bottom, 6)
                        DetailRow(label: "Type", value: record.offense.type ?? "Not on file")
                        DetailRow(label: "Date of Violation", value: DateFormatting.dateTime(record.dateOfViolation))
                        DetailRow(label: "Date of Resolution",
                                  value: record.dateOfResolution.map { DateFormatting.dateTime($0, fallback: $0) } ?? "Not yet resolved")
                        DetailRow(label: "Reported By", value: record.employee?.fullName ?? "Not on file")
                        DetailRow(label: "Status", value: StatusStyle.displayText(record.status))
                    }

                    OsdaCard {
                        Text("Disciplinary Action")
                            .font(.headline)
                            .foregroundStyle(Color.osdaHeading)
                        Text(record.action?.actionName ?? record.remarks ?? "No action recorded yet.")
                            .font(.subheadline)
                            .foregroundStyle(Color.osdaMuted)
                    }
                }
                .padding(20)
            }

            VStack(spacing: 8) {
                Button {
                    showFileAppeal = true
                } label: {
                    Text("File an Appeal")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .foregroundStyle(Color.osdaOnPrimary)
                        .background(canAppeal ? Color.osdaPrimary : Color.osdaPrimary.opacity(0.35))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(!canAppeal)

                if !canAppeal {
                    Text(blockedReason(record, alreadyAppealed: alreadyAppealed))
                        .font(.caption)
                        .foregroundStyle(Color.osdaMuted)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.osdaBackground)
        }
    }

    private func blockedReason(_ record: OffenseRecord, alreadyAppealed: Bool) -> String {
        if record.recordStatus == .processing || alreadyAppealed {
            return "This offense is already under appeal review."
        }
        return "This offense is \(StatusStyle.displayText(record.status).lowercased()) and can no longer be appealed."
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.osdaMuted)
            Spacer(minLength: 8)
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.osdaHeading)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
