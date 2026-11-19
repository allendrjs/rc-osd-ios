import PhotosUI
import SwiftUI

/// Which picker to show for an appeal letter.
enum AttachmentPickerKind: Identifiable {
    case camera, photoLibrary, files
    var id: Self { self }
}

extension View {
    /// Attaches the camera, photo library and Files pickers to a view. Set `kind` to show one;
    /// `onPicked` receives the prepared file, or nil if it could not be read.
    func attachmentPickers(kind: Binding<AttachmentPickerKind?>,
                           onPicked: @escaping (AttachmentFile?) -> Void) -> some View {
        modifier(AttachmentPickersModifier(kind: kind, onPicked: onPicked))
    }
}

private struct AttachmentPickersModifier: ViewModifier {
    @Binding var kind: AttachmentPickerKind?
    let onPicked: (AttachmentFile?) -> Void

    @State private var photoItem: PhotosPickerItem?

    private var showCamera: Binding<Bool> { flag(.camera) }
    private var showPhotos: Binding<Bool> { flag(.photoLibrary) }
    private var showFiles: Binding<Bool> { flag(.files) }

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: showCamera) {
                CameraPicker { image in onPicked(AttachmentFile.fromImage(image)) }
                    .ignoresSafeArea()
            }
            .photosPicker(isPresented: showPhotos, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { item in
                guard let item else { return }
                photoItem = nil
                Task {
                    let data = try? await item.loadTransferable(type: Data.self)
                    let file = data.flatMap(UIImage.init(data:)).flatMap { AttachmentFile.fromImage($0) }
                    await MainActor.run { onPicked(file) }
                }
            }
            .fileImporter(isPresented: showFiles, allowedContentTypes: AttachmentFile.allowedTypes) { result in
                switch result {
                case .success(let url): onPicked(AttachmentFile.fromFileURL(url))
                case .failure: onPicked(nil)
                }
            }
    }

    private func flag(_ target: AttachmentPickerKind) -> Binding<Bool> {
        Binding(
            get: { kind == target },
            set: { isShown in if !isShown, kind == target { kind = nil } }
        )
    }
}
