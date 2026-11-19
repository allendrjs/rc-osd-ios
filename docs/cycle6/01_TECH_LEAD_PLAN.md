# Cycle 6 Plan: Screens 7–8 (Handbook + Profile) and wrap-up

Role: Tech Lead. Goal: the last two screens, dark mode, and the app ready for its first build and test round. After this cycle, every Android screen exists on iOS.

| # | Task | Owner | Acceptance criteria | Depends on |
| --- | --- | --- | --- | --- |
| 1 | Handbook and guardian data | Developer | GET /api/handbook and /api/guardians/student/{id} decode correctly | Cycle 1 |
| 2 | Design spec | Designer | Handbook and Profile specs | none |
| 3 | Handbook screen | Developer | Department sections as expandable cards, search, empty/no-match/error states | 1, 2 |
| 4 | Profile screen | Developer | Header, counts, Dark Mode switch, Personal Information, Guardians | 1, 2 |
| 5 | Dark mode | Developer | Light by default; the switch on Profile changes the whole app and is remembered | 4 |
| 6 | Wire all tabs | Developer | Placeholders removed; tabs, sheets and jumps from the chat work | 3, 4 |
| 7 | Review, tests, tickets | Reviewer, Tester, Ticket Writer | Files 03–05, plus the first-build checklist | all |
