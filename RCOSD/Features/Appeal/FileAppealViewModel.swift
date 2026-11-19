import Foundation

/// Filing one appeal for one offense, with an optional letter (Android: AppealViewModel filing mode).
@MainActor
final class FileAppealViewModel: ObservableObject {
    @Published var message = "" { didSet { if message != oldValue { submitError = nil } } }
    @Published private(set) var attachmentFileName: String?
    @Published private(set) var attachmentDocumentId: Int64?
    @Published private(set) var isUploading = false
    @Published private(set) var attachmentLooksUnreadable = false
    @Published private(set) var attachmentError: String?
    @Published private(set) var isSubmitting = false
    @Published private(set) var submitError: String?
    @Published private(set) var submitSuccess = false

    static let pleaseWaitMessage = "Please wait for your file to finish uploading."
    static let uploadFailedMessage = "Your attached file did not upload. Remove it or attach it again before submitting."

    private let service: AppealServicing
    private var uploadTask: Task<Void, Never>?

    init(service: AppealServicing = AppealService()) {
        self.service = service
    }

    // MARK: Attachment

    func attach(_ file: AttachmentFile?) {
        guard let file else {
            attachmentError = "Couldn't read the selected file. Please try again."
            return
        }
        uploadTask?.cancel()
        attachmentFileName = file.fileName
        attachmentDocumentId = nil
        attachmentLooksUnreadable = false
        attachmentError = nil
        submitError = nil
        isUploading = true

        uploadTask = Task {
            do {
                let response = try await service.uploadLetter(file)
                guard !Task.isCancelled else { return }
                attachmentDocumentId = response.documentId
                attachmentLooksUnreadable = response.looksUnreadable
            } catch is CancellationError {
                return
            } catch {
                attachmentDocumentId = nil
                attachmentError = (error as? APIError)?.errorDescription ?? "Couldn't upload that file. Please try again."
            }
            isUploading = false
        }
    }

    func removeAttachment() {
        uploadTask?.cancel()
        uploadTask = nil
        attachmentFileName = nil
        attachmentDocumentId = nil
        attachmentLooksUnreadable = false
        attachmentError = nil
        isUploading = false
    }

    // MARK: Submit

    /// Checks everything before the "Submit this appeal?" dialog (same order as Android).
    func validate(record: OffenseRecord?, alreadyAppealed: Bool, enrollmentId: Int64?) -> Bool {
        guard record != nil else {
            submitError = "Please select which offense you're appealing."
            return false
        }
        if alreadyAppealed {
            submitError = "You already have an appeal on file for this offense."
            return false
        }
        if message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            submitError = "Please enter a message explaining your appeal."
            return false
        }
        if isUploading {
            submitError = Self.pleaseWaitMessage
            return false
        }
        if attachmentFileName != nil && attachmentDocumentId == nil {
            submitError = Self.uploadFailedMessage
            return false
        }
        if enrollmentId == nil {
            submitError = "Couldn't determine your current enrollment. Please try again later."
            return false
        }
        return true
    }

    func submit(recordId: Int64, enrollmentId: Int64) async {
        guard !isSubmitting else { return }
        isSubmitting = true
        submitError = nil
        defer { isSubmitting = false }
        do {
            _ = try await service.submit(AppealSubmission(
                recordId: recordId,
                enrollmentId: enrollmentId,
                message: message.trimmingCharacters(in: .whitespacesAndNewlines),
                documentId: attachmentDocumentId
            ))
            submitSuccess = true
        } catch is CancellationError {
            return
        } catch {
            submitError = (error as? APIError)?.errorDescription ?? "Couldn't submit your appeal. Please try again."
        }
    }
}
