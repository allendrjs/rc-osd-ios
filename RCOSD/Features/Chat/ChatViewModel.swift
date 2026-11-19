import Foundation

/// Chat assistant with the guided "File an Appeal" flow.
/// Ported step by step from the Android ChatViewModel so both apps behave the same.
@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = []
    @Published var input = "" { didSet { if input != oldValue { errorMessage = nil } } }
    @Published private(set) var isSending = false
    @Published private(set) var isUploadingAttachment = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var quickReplies: [QuickReply] = ChatViewModel.starterQuickReplies
    /// Set when the bot asks the screen to open the camera or a file picker.
    @Published var pickerRequest: AttachmentPickerKind?
    /// Set when the student should be taken to another tab ("offenses" or "appeals").
    @Published var navigationRequest: String?

    private enum FlowStep {
        case pickingOffense([OffenseRecord])
        case writingMessage(OffenseRecord)
        case attachingLetter(OffenseRecord, message: String)
        case confirming(OffenseRecord, message: String, documentId: Int64?)
    }

    private var flowStep: FlowStep?
    private var enrollmentId: Int64?

    let studentId: String
    private let chatService: ChatServicing
    private let dataService: StudentDataServicing
    private let appealService: AppealServicing

    init(studentId: String,
         chatService: ChatServicing = ChatService(),
         dataService: StudentDataServicing = StudentDataService(),
         appealService: AppealServicing = AppealService()) {
        self.studentId = studentId
        self.chatService = chatService
        self.dataService = dataService
        self.appealService = appealService
    }

    /// "Waking up the assistant..." on the first question, "Thinking..." after.
    var typingLabel: String {
        if isUploadingAttachment { return "Uploading your file..." }
        return messages.contains { !$0.isUser } ? "Thinking..." : "Waking up the assistant..."
    }

    static let starterQuickReplies = [
        QuickReply(id: "start_appeal", label: "File an Appeal"),
        QuickReply(id: "check_status", label: "Check My Offenses/Appeals"),
        QuickReply(id: "topic_dress_code", label: "Dress Code"),
        QuickReply(id: "topic_attendance", label: "Attendance"),
        QuickReply(id: "topic_major_offenses", label: "Major Offenses"),
        QuickReply(id: "topic_bullying", label: "Bullying Policy")
    ]

    private static let attachQuickReplies = [
        QuickReply(id: "attach_take_photo", label: "Take Photo"),
        QuickReply(id: "attach_choose_file", label: "Choose File"),
        QuickReply(id: "attach_skip", label: "Skip")
    ]

    private static let confirmQuickReplies = [
        QuickReply(id: "confirm_submit", label: "Submit"),
        QuickReply(id: "confirm_cancel", label: "Cancel")
    ]

    // MARK: Typed messages

    func send() {
        let message = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty, !isSending else { return }

        let history = messages
        messages.append(ChatMessage(role: "user", content: message))
        input = ""
        quickReplies = []
        errorMessage = nil

        switch flowStep {
        case .pickingOffense(let eligible):
            if let matched = eligible.first(where: { $0.offense.offense.localizedCaseInsensitiveContains(message) }) {
                offensePicked(matched)
            } else {
                bot("I didn't recognize that offense. Please pick one below, or type its exact name.")
                quickReplies = offenseQuickReplies(eligible)
            }
        case .writingMessage(let record):
            flowStep = .attachingLetter(record, message: message)
            bot("Would you like to attach a copy of your appeal letter? This is optional.")
            quickReplies = Self.attachQuickReplies
        case .attachingLetter:
            bot("Please tap one of the options below.")
            quickReplies = Self.attachQuickReplies
        case .confirming:
            switch message.lowercased() {
            case "yes", "y", "submit", "confirm", "yeah", "yep": Task { await confirmSubmission() }
            case "no", "n", "cancel", "nope": cancelFlow()
            default:
                bot("Tap Submit to file the appeal, or Cancel to stop.")
                quickReplies = Self.confirmQuickReplies
            }
        case nil:
            if looksLikeAppealIntent(message) {
                Task { await offerAppealChoice() }
            } else {
                Task { await askBot(message, history: history) }
            }
        }
    }

    // MARK: Quick replies

    func select(_ reply: QuickReply) {
        guard !isSending, !isUploadingAttachment else { return }
        messages.append(ChatMessage(role: "user", content: reply.label))
        quickReplies = []

        switch reply.id {
        case "start_appeal": Task { await offerAppealChoice() }
        case "appeal_in_chat": Task { await startFlow() }
        case "check_status": Task { await checkStatus() }
        case "flow_cancel", "confirm_cancel": cancelFlow()
        case "confirm_submit": Task { await confirmSubmission() }
        case "attach_take_photo": pickerRequest = .camera
        case "attach_choose_file": pickerRequest = .files
        case "attach_skip": skipAttachment()
        case "view_offenses", "appeal_go_manual": navigationRequest = "offenses"
        case "view_appeals": navigationRequest = "appeals"
        default:
            if reply.id.hasPrefix("offense_"),
               let recordId = Int64(reply.id.dropFirst("offense_".count)),
               case .pickingOffense(let eligible) = flowStep,
               let record = eligible.first(where: { $0.recordId == recordId }) {
                offensePicked(record)
            } else if reply.id.hasPrefix("topic_") {
                let history = Array(messages.dropLast())
                Task { await askBot(topicQuestion(reply.id), history: history) }
            }
        }
    }

    // MARK: Attachments

    func attachmentPicked(_ file: AttachmentFile?) {
        guard case .attachingLetter(let record, let message) = flowStep else { return }
        guard let file else {
            bot("Couldn't read that file. You can try again, or skip attaching a letter.")
            quickReplies = Self.attachQuickReplies
            return
        }
        isUploadingAttachment = true
        Task {
            defer { isUploadingAttachment = false }
            do {
                let response = try await appealService.uploadLetter(file)
                let note = response.looksUnreadable
                    ? " I couldn't read much text from it — you can still submit, or attach a clearer copy instead."
                    : ""
                bot("Attached \"\(file.fileName)\".\(note)")
                proceedToConfirm(record, message: message, documentId: response.documentId)
            } catch {
                bot(Self.text(for: error, fallback: "Couldn't upload that file. You can try again, or skip attaching a letter."))
                quickReplies = Self.attachQuickReplies
            }
        }
    }

    /// The picker was closed without choosing anything.
    func attachmentPickerCancelled() {
        if case .attachingLetter = flowStep, quickReplies.isEmpty, !isUploadingAttachment {
            quickReplies = Self.attachQuickReplies
        }
    }

    // MARK: Flow steps

    private func eligibleRecords() async throws -> (records: [OffenseRecord], eligible: [OffenseRecord]) {
        let service = dataService
        let id = studentId
        async let recordsCall = service.records(studentId: id)
        async let appealsCall = service.appeals(studentId: id)
        let (records, appeals) = try await (recordsCall, appealsCall)
        let appealed = Set(appeals.compactMap { $0.record?.recordId })
        let eligible = records.filter { $0.recordStatus.isAppealable && !appealed.contains($0.recordId) }
        return (records, eligible)
    }

    private func offerAppealChoice() async {
        isSending = true
        defer { isSending = false }
        do {
            let (records, eligible) = try await eligibleRecords()
            if eligible.isEmpty {
                bot(records.isEmpty
                    ? "You don't have any offenses on file, so there's nothing to appeal."
                    : "You don't currently have any offenses that are eligible for an appeal.")
                quickReplies = Self.starterQuickReplies
            } else {
                bot("Would you like to file it right here in chat, or go do it yourself in the app?")
                quickReplies = [
                    QuickReply(id: "appeal_in_chat", label: "File Here in Chat"),
                    QuickReply(id: "appeal_go_manual", label: "Go to Offenses")
                ]
            }
        } catch {
            bot(Self.text(for: error, fallback: "Couldn't check your offenses right now. Please try again."))
            quickReplies = Self.starterQuickReplies
        }
    }

    private func startFlow() async {
        flowStep = nil
        isSending = true
        defer { isSending = false }
        do {
            let (_, eligible) = try await eligibleRecords()
            if enrollmentId == nil {
                enrollmentId = try? await dataService.latestEnrollment(studentId: studentId).enrollmentId
            }
            if eligible.isEmpty {
                bot("You don't currently have any offenses that are eligible for an appeal.")
                quickReplies = Self.starterQuickReplies
            } else {
                flowStep = .pickingOffense(eligible)
                bot("Which offense would you like to appeal?")
                quickReplies = offenseQuickReplies(eligible)
            }
        } catch {
            bot(Self.text(for: error, fallback: "Couldn't load your offenses right now. Please try again."))
            quickReplies = Self.starterQuickReplies
        }
    }

    private func checkStatus() async {
        isSending = true
        defer { isSending = false }
        do {
            let service = dataService
            let id = studentId
            async let recordsCall = service.records(studentId: id)
            async let appealsCall = service.appeals(studentId: id)
            let (records, appeals) = try await (recordsCall, appealsCall)
            let active = records.filter { $0.recordStatus == .pending }.count
            let pending = appeals.filter(\.isPending).count
            bot("You have \(records.count) offense(s) on file (\(active) still active), and \(appeals.count) appeal(s) filed (\(pending) awaiting a decision).")
            quickReplies = [
                QuickReply(id: "view_offenses", label: "View My Offenses"),
                QuickReply(id: "view_appeals", label: "View My Appeals")
            ] + Self.starterQuickReplies
        } catch {
            bot(Self.text(for: error, fallback: "Couldn't check your status right now. Please try again."))
            quickReplies = Self.starterQuickReplies
        }
    }

    private func offensePicked(_ record: OffenseRecord) {
        flowStep = .writingMessage(record)
        bot("Please describe why you're appealing the \"\(record.offense.offense)\" record, in your own words.")
        quickReplies = [QuickReply(id: "flow_cancel", label: "Cancel")]
    }

    private func skipAttachment() {
        guard case .attachingLetter(let record, let message) = flowStep else { return }
        proceedToConfirm(record, message: message, documentId: nil)
    }

    private func proceedToConfirm(_ record: OffenseRecord, message: String, documentId: Int64?) {
        flowStep = .confirming(record, message: message, documentId: documentId)
        bot("Submit this appeal for \"\(record.offense.offense)\"? You can still edit it while it is pending.")
        quickReplies = Self.confirmQuickReplies
    }

    private func confirmSubmission() async {
        guard case .confirming(let record, let message, let documentId) = flowStep else { return }
        flowStep = nil
        isSending = true
        defer { isSending = false }
        do {
            let currentEnrollmentId: Int64
            if let enrollmentId {
                currentEnrollmentId = enrollmentId
            } else {
                currentEnrollmentId = try await dataService.latestEnrollment(studentId: studentId).enrollmentId
                enrollmentId = currentEnrollmentId
            }
            _ = try await appealService.submit(AppealSubmission(
                recordId: record.recordId, enrollmentId: currentEnrollmentId,
                message: message, documentId: documentId))
            bot("Your appeal for \"\(record.offense.offense)\" has been submitted. Tap below to view it, or keep asking me anything else.")
            quickReplies = [QuickReply(id: "view_appeals", label: "View My Appeals")] + Self.starterQuickReplies
        } catch {
            bot(Self.text(for: error, fallback: "Couldn't submit your appeal. Please try again, or use the Appeals tab."))
            quickReplies = Self.starterQuickReplies
        }
    }

    private func cancelFlow() {
        flowStep = nil
        isUploadingAttachment = false
        bot("No problem, the appeal wasn't submitted. Ask me anything else, or start over anytime.")
        quickReplies = Self.starterQuickReplies
    }

    private func askBot(_ message: String, history: [ChatMessage]) async {
        isSending = true
        defer { isSending = false }
        do {
            let response = try await chatService.ask(message: message, history: history)
            bot(response.reply)
            quickReplies = Self.starterQuickReplies
        } catch is CancellationError {
            return
        } catch {
            errorMessage = Self.text(for: error, fallback: "Couldn't reach the chatbot. Please try again.")
        }
    }

    // MARK: Helpers

    private func bot(_ text: String) {
        messages.append(ChatMessage(role: "assistant", content: text))
    }

    private func offenseQuickReplies(_ eligible: [OffenseRecord]) -> [QuickReply] {
        eligible.map { QuickReply(id: "offense_\($0.recordId)", label: $0.offense.offense) }
            + [QuickReply(id: "flow_cancel", label: "Cancel")]
    }

    private func topicQuestion(_ id: String) -> String {
        switch id {
        case "topic_dress_code": return "What is the dress code policy?"
        case "topic_attendance": return "What is the attendance policy?"
        case "topic_major_offenses": return "What counts as a major offense?"
        case "topic_bullying": return "What is the policy on bullying?"
        default: return id.replacingOccurrences(of: "topic_", with: "").replacingOccurrences(of: "_", with: " ")
        }
    }

    private func looksLikeAppealIntent(_ message: String) -> Bool {
        let phrases = ["file an appeal", "file appeal", "want to appeal", "want to file an appeal",
                       "start an appeal", "submit an appeal", "make an appeal"]
        let normalized = message.lowercased()
        return phrases.contains { normalized.contains($0) }
    }

    private static func text(for error: Error, fallback: String) -> String {
        if let apiError = error as? APIError, case .server(_, _, let message?) = apiError, !message.isEmpty {
            return message
        }
        if (error as? APIError) == .network { return APIError.network.errorDescription ?? fallback }
        return fallback
    }
}
