# Cycle 5 Plan: Screen 6 (Chat assistant)

Role: Tech Lead. Goal: the chatbot answers questions and can file an appeal step by step, behaving exactly like the Android chat.

| # | Task | Owner | Acceptance criteria | Depends on |
| --- | --- | --- | --- | --- |
| 1 | Chat models and service | Developer | POST /api/chat with `{message, history[{role, content}]}`; reads `{reply, timestamp}` | Cycle 1 |
| 2 | Design spec | Designer | Chat layout, quick replies, typing indicator, appeal flow messages | none |
| 3 | Chat view model | Developer | Same quick replies, intent phrases, appeal flow steps (pick offense, write message, attach letter, confirm) and texts as Android | 1 |
| 4 | Chat screen | Developer | Bubbles, Markdown in replies, quick-reply chips, input bar, camera/file pickers when asked, "View My Offenses/Appeals" jump to the tab | 2, 3 |
| 5 | Review, tests, tickets | Reviewer, Tester, Ticket Writer | Files 03–05 | 4 |
