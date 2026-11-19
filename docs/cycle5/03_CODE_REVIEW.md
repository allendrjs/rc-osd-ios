# Code Review: Cycle 5 (Chat)

Role: Code Reviewer. **Verdict: APPROVE WITH SMALL FIXES.** Not compiled yet (written on Windows).

| Severity | File | Problem | Fix (status) |
| --- | --- | --- | --- |
| Major | `Features/Chat/ChatViewModel.swift` | `async let` read main-actor properties (`dataService`, `studentId`) from a child task, a likely compile error | Copy them into local constants first (fixed) |
| Minor | `Features/Chat/ChatView.swift` | Closing a picker without choosing left the flow with no buttons | Restore the Take Photo / Choose File / Skip chips after the picker closes (fixed) |
| Minor | `Models/Chat.swift` | `ChatMessage` needs an `id` for the list but must not send it to the backend | `id` excluded from Codable keys (fixed) |
| Minor | `Features/Chat/ChatView.swift` | Opening a tab while the sheet is still closing can be ignored by SwiftUI | Switch tabs after a short delay (fixed) |
| Nit | `Features/Chat/ChatViewModel.swift` | The flow logic is long (Android has the same) | Could be split into a separate flow type later (open) |

Checked and correct: the quick-reply IDs, intent phrases and every flow message match the Android `ChatViewModel`; only PENDING offenses without an appeal are offered, so filing with zero eligible offenses is impossible; history is sent with each question; server and network errors show friendly text.

To check on the first Mac build: Markdown rendering of a real bot reply (lists keep their line breaks with `inlineOnlyPreservingWhitespace`).
