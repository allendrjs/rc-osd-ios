# Design Spec: Screen 6, Chat

Role: UI/UX Designer.

## Layout (sheet from the Dashboard)

| Element | Details |
| --- | --- |
| Title | "Ask the Chatbot" (inline), "Close" on the left |
| Intro | "Ask about your own offense records, appeal status, or how to file an appeal." (centered, muted) |
| Student bubble | Right side, `osdaPrimary` fill, white text |
| Bot bubble | Left side, white card with border; Markdown (bold, lists) shown formatted; text can be selected |
| Typing indicator | Spinner and "Waking up the assistant..." (first answer) / "Thinking..." / "Uploading your file..." |
| Quick replies | Horizontal chips above the input; hidden while waiting |
| Input bar | "Type a message..." (grows to 4 lines) and a send arrow (disabled when empty or waiting) |

Starter quick replies: File an Appeal, Check My Offenses/Appeals, Dress Code, Attendance, Major Offenses, Bullying Policy.

## Appeal flow (texts must match Android)

1. "File an Appeal", or typing "file an appeal", "want to appeal" and similar.
2. No eligible offense: "You don't have any offenses on file, so there's nothing to appeal." or "You don't currently have any offenses that are eligible for an appeal."
3. Otherwise: "Would you like to file it right here in chat, or go do it yourself in the app?" with File Here in Chat / Go to Offenses.
4. "Which offense would you like to appeal?" with one chip per eligible offense, plus Cancel.
5. "Please describe why you're appealing the "{offense}" record, in your own words."
6. "Would you like to attach a copy of your appeal letter? This is optional." with Take Photo / Choose File / Skip.
7. "Submit this appeal for "{offense}"? You can still edit it while it is pending." with Submit / Cancel.
8. Done: "Your appeal for "{offense}" has been submitted. Tap below to view it, or keep asking me anything else." with View My Appeals.
9. Cancel: "No problem, the appeal wasn't submitted. Ask me anything else, or start over anytime."

"Check My Offenses/Appeals" answers: "You have N offense(s) on file (X still active), and M appeal(s) filed (Y awaiting a decision)." with View My Offenses / View My Appeals, which close the chat and open that tab.

## Accessibility

Each bubble is read as "You: …" or "Assistant: …". Chips are buttons at least 36 pt tall inside a scrolling row, and the send button is labeled "Send". Dynamic Type is supported.
