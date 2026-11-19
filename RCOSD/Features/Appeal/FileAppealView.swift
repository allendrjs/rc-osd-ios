import SwiftUI

/// "File a New Appeal" for one offense, opened from Offense Details.
struct FileAppealView: View {
    @ObservedObject var viewModel: RecordsViewModel
    let recordId: Int64

    @StateObject private var form = FileAppealViewModel()
    @State private var pickerKind: AttachmentPickerKind?
    @State private var confirmSubmit = false
    @Environment(\.dismiss) private var dismiss
    @FocusState private var messageFocused: Bool

    private var record: OffenseRecord? { viewModel.record(id: recordId) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Request a review of an offense on your record")
                    .font(.subheadline)
                    .foregroundStyle(Color.osdaMuted)

                OsdaCard {
                    Text("Offense")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.osdaHeading)
                    Text(record.map { "\($0.offense.offense) • \(DateFormatting.dateTime($0.dateOfViolation))" } ?? "Offense not found")
                        .font(.body)
                        .foregroundStyle(Color.osdaHeading)
                }

                if form.submitSuccess {
                    Label("Appeal submitted successfully. Returning to the offense...", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color.osdaGreen)
                } else {
                    messageField
                    AttachmentSection(
                        fileName: form.attachmentFileName,
                        isUploading: form.isUploading,
                        isUploaded: form.attachmentDocumentId != nil,
                        looksUnreadable: form.attachmentLooksUnreadable,
                        error: form.attachmentError,
                        onPick: { pickerKind = $0 },
                        onRemove: form.removeAttachment
                    )

                    if let error = form.submitError {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(Color.osdaError)
                            .accessibilityLabel("Error: \(error)")
                    }

                    Button(action: askToSubmit) {
                        HStack(spacing: 8) {
                            if form.isSubmitting { ProgressView().tint(Color.osdaOnPrimary) }
                            Text(form.isSubmitting ? "Submitting..." : "Submit Appeal").font(.headline)
                        }
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .foregroundStyle(Color.osdaOnPrimary)
                        .background(Color.osdaPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .disabled(form.isSubmitting)
                }
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.osdaBackground.ignoresSafeArea())
        .navigationTitle("File a New Appeal")
        .navigationBarTitleDisplayMode(.inline)
        .attachmentPickers(kind: $pickerKind) { form.attach($0) }
        .alert("Submit this appeal?", isPresented: $confirmSubmit) {
            Button("Cancel", role: .cancel) {}
            Button("Submit") { submit() }
        } message: {
            Text("You can still edit it while it is pending.")
        }
        .onChange(of: form.submitSuccess) { success in
            guard success else { return }
            Task {
                await viewModel.load(silent: true)
                try? await Task.sleep(nanoseconds: 1_200_000_000)
                dismiss()
            }
        }
    }

    private var messageField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Message *")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.osdaHeading)
            ZStack(alignment: .topLeading) {
                if form.message.isEmpty {
                    Text("Explain why you're appealing this offense...")
                        .font(.body)
                        .foregroundStyle(Color.osdaMuted)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .accessibilityHidden(true)
                }
                TextEditor(text: $form.message)
                    .font(.body)
                    .foregroundStyle(Color.osdaHeading)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .frame(minHeight: 120)
                    .focused($messageFocused)
                    .accessibilityLabel("Appeal message, required")
            }
            .background(Color.osdaSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(messageFocused ? Color.osdaPrimary : Color.osdaBorder, lineWidth: messageFocused ? 1.5 : 1)
            )
        }
    }

    private func askToSubmit() {
        messageFocused = false
        if form.validate(record: record,
                         alreadyAppealed: viewModel.hasAppeal(recordId: recordId),
                         enrollmentId: viewModel.enrollmentId) {
            confirmSubmit = true
        }
    }

    private func submit() {
        guard let enrollmentId = viewModel.enrollmentId else { return }
        Task { await form.submit(recordId: recordId, enrollmentId: enrollmentId) }
    }
}
