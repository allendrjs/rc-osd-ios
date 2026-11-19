import SwiftUI

/// "Attach Appeal Letter (optional)" block: Take Photo / Choose File, upload status, Remove.
struct AttachmentSection: View {
    let fileName: String?
    let isUploading: Bool
    let isUploaded: Bool
    let looksUnreadable: Bool
    let error: String?
    var onPick: (AttachmentPickerKind) -> Void
    var onRemove: () -> Void

    @State private var showNoCamera = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Attach Appeal Letter (optional)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.osdaHeading)

            if let fileName {
                HStack(spacing: 10) {
                    Image(systemName: "doc.fill")
                        .foregroundStyle(Color.osdaPrimary)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(fileName)
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(Color.osdaHeading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        statusLine
                    }
                    Spacer(minLength: 8)
                    Button("Remove", role: .destructive, action: onRemove)
                        .font(.footnote.weight(.semibold))
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.osdaBorder))

                if looksUnreadable && isUploaded {
                    Text("We couldn't clearly read this file. You can still submit, but consider retaking the photo or choosing a clearer copy.")
                        .font(.caption)
                        .foregroundStyle(Color.osdaAmber)
                }
            } else {
                HStack(spacing: 10) {
                    pickerButton("Take Photo", systemImage: "camera") {
                        if CameraPicker.isAvailable { onPick(.camera) } else { showNoCamera = true }
                    }
                    Menu {
                        Button { onPick(.photoLibrary) } label: { Label("Photo Library", systemImage: "photo.on.rectangle") }
                        Button { onPick(.files) } label: { Label("Files", systemImage: "folder") }
                    } label: {
                        pickerLabel("Choose File", systemImage: "paperclip")
                    }
                }
            }

            if let error {
                Text(error).font(.caption).foregroundStyle(Color.osdaError)
            }
        }
        .alert("Camera not available", isPresented: $showNoCamera) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This device has no camera. Use Choose File instead.")
        }
    }

    @ViewBuilder
    private var statusLine: some View {
        if isUploading {
            HStack(spacing: 6) {
                ProgressView().controlSize(.mini)
                Text("Uploading...").font(.caption).foregroundStyle(Color.osdaMuted)
            }
        } else if isUploaded {
            Label("Uploaded", systemImage: "checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(Color.osdaGreen)
        } else {
            Text("Not uploaded").font(.caption).foregroundStyle(Color.osdaError)
        }
    }

    private func pickerButton(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { pickerLabel(title, systemImage: systemImage) }
    }

    private func pickerLabel(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundStyle(Color.osdaPrimary)
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.osdaPrimary, lineWidth: 1))
    }
}
