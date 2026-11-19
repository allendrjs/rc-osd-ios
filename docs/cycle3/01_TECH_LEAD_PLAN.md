# Cycle 3 Plan: Screens 3–4 (Records + Offense Details)

Role: Tech Lead. Goal: the Offenses tab lists every offense and opens its full details, with the File an Appeal button following the same rules as Android.

| # | Task | Owner | Acceptance criteria | Depends on |
| --- | --- | --- | --- | --- |
| 1 | Records view model | Developer | Loads records, appeals and enrollment together; newest offense first; All/Active/Resolved filter; Total/Active/Resolved counts | Cycle 2 models |
| 2 | Records design spec | Designer | Records and Offense Details specs written | none |
| 3 | Records screen | Developer | Summary cards, filter, offense cards (ID, status, name, filed, resolved), empty and error states, pull to refresh, 15 s auto-refresh | 1, 2 |
| 4 | Offense Details screen | Developer | Header, Details card, Disciplinary Action card, File an Appeal button with the blocked messages | 1, 2 |
| 5 | Review, tests, tickets | Reviewer, Tester, Ticket Writer | Files 03–05 in this folder | 3, 4 |
