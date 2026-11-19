# Test Cases: Screen 6, Chat (iOS)

Role: QA Tester. Test accounts only. The backend needs Ollama running for the free-form answers.

| ID | Feature | Steps | Expected result | Priority | ISO 9126 |
| --- | --- | --- | --- | --- | --- |
| IOS-CHT-01 | Open chat | Dashboard, then Ask the Chatbot | Sheet with the intro text and starter chips | High | Functionality |
| IOS-CHT-02 | Free question | Type "What is the dress code?" | "Waking up the assistant...", then an answer from the handbook | High | Functionality |
| IOS-CHT-03 | Topic chip | Tap "Attendance" | Answer about the attendance policy | Medium | Functionality |
| IOS-CHT-04 | Out-of-scope | Ask about something unrelated (e.g. the weather) | The bot says it can't answer that; it does not make something up | High | Functionality |
| IOS-CHT-05 | Status check | Tap "Check My Offenses/Appeals" | Counts match the Offenses and Appeal tabs | High | Functionality |
| IOS-CHT-06 | Jump to tab | Then tap "View My Appeals" | Chat closes, Appeal tab opens | Medium | Usability |
| IOS-CHT-07 | No eligible offense | Student whose offenses are all processed | "You don't currently have any offenses that are eligible for an appeal." | High | Functionality |
| IOS-CHT-08 | Full appeal flow | File an Appeal, File Here in Chat, pick offense, type reason, Skip, Submit | Success message; the appeal shows on the Appeal tab; the offense becomes Processing | High | Functionality |
| IOS-CHT-09 | Flow with photo | Same, but Take Photo (real iPhone) | "Attached "…"", then the confirm step | High | Functionality |
| IOS-CHT-10 | Cancel | Cancel during the flow | "No problem, the appeal wasn't submitted…" | Medium | Functionality |
| IOS-CHT-11 | Typed offense name | At the pick step, type part of the offense name | That offense is selected | Low | Usability |
| IOS-CHT-12 | Picker closed | At the attach step, open Choose File and cancel | Take Photo / Choose File / Skip chips come back | Medium | Reliability |
| IOS-CHT-13 | No internet | Airplane mode, send a question | "Can't reach the server…" shown | High | Reliability |
| IOS-CHT-14 | Slow server | First question after the server has been idle | Indicator stays visible; the answer arrives (time behavior) | Medium | Efficiency |
| IOS-CHT-15 | Accessibility | VoiceOver and largest text | Bubbles read as "You:" / "Assistant:"; chips scroll; nothing cut off | Medium | Usability |
