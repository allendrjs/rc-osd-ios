import Foundation
import UIKit
import UniformTypeIdentifiers

/// A file ready to upload as an appeal letter.
struct AttachmentFile {
    let data: Data
    let fileName: String
    let mimeType: String

    /// Types allowed in "Choose File" (same as Android: PDF, Word, images).
    static let allowedTypes: [UTType] = [
        .pdf, .image,
        UTType(filenameExtension: "doc") ?? .data,
        UTType(filenameExtension: "docx") ?? .data
    ]

    /// Photos are resized to at most 1500 px on the long side and saved as JPEG (quality 0.8),
    /// matching the Android compression, so uploads are small and fast.
    static func fromImage(_ image: UIImage, baseName: String = "appeal_letter") -> AttachmentFile? {
        let maxSide: CGFloat = 1500
        let size = image.size
        let scale = min(1, maxSide / max(size.width, size.height))
        let target = CGSize(width: (size.width * scale).rounded(), height: (size.height * scale).rounded())

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let resized = UIGraphicsImageRenderer(size: target, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: target))
        }
        guard let jpeg = resized.jpegData(compressionQuality: 0.8) else { return nil }
        let stamp = Int(Date().timeIntervalSince1970)
        return AttachmentFile(data: jpeg, fileName: "\(baseName)_\(stamp).jpg", mimeType: "image/jpeg")
    }

    /// Reads a file chosen in the Files app. Images are compressed like camera photos.
    static func fromFileURL(_ url: URL) -> AttachmentFile? {
        let didAccess = url.startAccessingSecurityScopedResource()
        defer { if didAccess { url.stopAccessingSecurityScopedResource() } }

        guard let data = try? Data(contentsOf: url) else { return nil }
        let type = UTType(filenameExtension: url.pathExtension)

        if let type, type.conforms(to: .image), let image = UIImage(data: data) {
            return fromImage(image, baseName: url.deletingPathExtension().lastPathComponent)
        }
        let mime = type?.preferredMIMEType ?? "application/octet-stream"
        return AttachmentFile(data: data, fileName: url.lastPathComponent, mimeType: mime)
    }
}
