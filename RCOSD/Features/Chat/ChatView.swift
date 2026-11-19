import SwiftUI

/// "Ask the Chatbot", opened as a sheet from the Dashboard.
struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    var onNavigate: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @FocusState private var inputFocused: Bool

    init(studentId: String, onNavigate: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(studentId: studentId))
        self.onNavigate = onNavigate
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                messageList
                quickReplyBar
                inputBar
            }
            .background(Color.osdaBackground.ignoresSafeArea())
            .navigationTitle("Ask the Chatbot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .attachmentPickers(kind: pickerBinding) { viewModel.attachmentPicked($0) }
            .onChange(of: viewModel.navigationRequest) { target in
                guard let target else { return }
                viewModel.navigationRequest = nil
                dismiss()
                onNavigate(target)
            }
        }
    }

    /// Clears the request when the picker closes and restores the attach options if nothing was picked.
    private var pickerBinding: Binding<AttachmentPickerKind?> {
        Binding(
            get: { viewModel.pickerRequest },
            set: { newValue in
                if newValue == nil, viewModel.pickerRequest != nil {
                    viewModel.pickerRequest = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        viewModel.attachmentPickerCancelled()
                    }
                } else {
                    viewModel.pickerRequest = newValue
                }
            }
        )
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    Text("Ask about your own offense records, appeal status, or how to file an appeal.")
                        .font(.footnote)
                        .foregroundStyle(Color.osdaMuted)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 8)

                    ForEach(viewModel.messages) { message in
                        ChatBubble(message: message).id(message.id)
                    }

                    if viewModel.isSending || viewModel.isUploadingAttachment {
                        HStack(spacing: 8) {
                            ProgressView().controlSize(.small)
                            Text(viewModel.typingLabel)
                                .font(.footnote)
                                .foregroundStyle(Color.osdaMuted)
                        }
                        .id("typing")
                        .accessibilityElement(children: .combine)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error).font(.footnote).foregroundStyle(Color.osdaError).id("error")
                    }
                }
                .padding(16)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.messages.count) { _ in
                if let last = viewModel.messages.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
            .onChange(of: viewModel.isSending) { sending in
                if sending { withAnimation { proxy.scrollTo("typing", anchor: .bottom) } }
            }
        }
    }

    @ViewBuilder
    private var quickReplyBar: some View {
        if !viewModel.quickReplies.isEmpty && !viewModel.isSending && !viewModel.isUploadingAttachment {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.quickReplies) { reply in
                        Button(reply.label) { viewModel.select(reply) }
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal, 14)
                            .frame(minHeight: 36)
                            .foregroundStyle(Color.osdaPrimary)
                            .background(Capsule().stroke(Color.osdaPrimary, lineWidth: 1))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Type a message...", text: $viewModel.input, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.osdaSurface)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.osdaBorder))
                .focused($inputFocused)
                .submitLabel(.send)
                .onSubmit { viewModel.send() }

            Button {
                viewModel.send()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(canSend ? Color.osdaPrimary : Color.osdaMuted)
            }
            .disabled(!canSend)
            .accessibilityLabel("Send")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.osdaSurface.ignoresSafeArea(edges: .bottom))
    }

    private var canSend: Bool {
        !viewModel.isSending && !viewModel.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

private struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }
            Text(Self.render(message.content))
                .font(.subheadline)
                .foregroundStyle(message.isUser ? Color.osdaOnPrimary : Color.osdaHeading)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(message.isUser ? Color.osdaPrimary : Color.osdaSurface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(message.isUser ? Color.clear : Color.osdaBorder)
                )
                .textSelection(.enabled)
            if !message.isUser { Spacer(minLength: 40) }
        }
        .accessibilityLabel((message.isUser ? "You: " : "Assistant: ") + message.content)
    }

    /// Bot replies may contain Markdown (bold, lists); show it formatted when possible.
    static func render(_ text: String) -> AttributedString {
        let options = AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        return (try? AttributedString(markdown: text, options: options)) ?? AttributedString(text)
    }
}
