# Cycle 1 Plan: Core Setup + Screen 1 (Login)

Role: Tech Lead. Goal of this cycle: a running iOS app that logs a student in against the existing backend, keeps them signed in, shows their name, and logs them out.

| # | Task | Owner | Acceptance criteria | Depends on |
| --- | --- | --- | --- | --- |
| 1 | Project scaffold | Developer | `project.yml` generates an Xcode project with the `RCOSD` app target, iOS 16 minimum, Debug and Release configs | none |
| 2 | Theme | Developer | Brand colors from Android available as `Color.osdaPrimary` etc., with light and dark values | 1 |
| 3 | App config | Developer | Debug uses `http://localhost:8080`, Release uses `https://rc-osd.tech`; changeable in one place | 1 |
| 4 | Keychain storage | Developer | Token, username and role saved in the Keychain; cleared on logout; survives app restart | 1 |
| 5 | API client | Developer | Adds `Authorization: Bearer`; decodes `{timestamp,status,code,message}`; shows the server message; refreshes the token once on 401 for protected calls; 15 s connect timeout | 3, 4 |
| 6 | Date helper | Developer | `MM/dd/yyyy` and `MM/dd/yyyy · h:mm a` from backend dates | 1 |
| 7 | Login design spec | Designer | Every element, state and message for Login written down | none |
| 8 | Login screen | Developer | Matches the spec; shows "Attempt X of 5" and the locked-account message from the server; show/hide password; blocks empty fields | 5, 7 |
| 9 | Session and home placeholder | Developer | After login, a placeholder screen shows the student's name and section; Log Out asks for confirmation and returns to Login; reopening the app stays signed in | 4, 5 |
| 10 | Code review | Reviewer | Review report with verdict; all Blocker and Major items fixed | 8, 9 |
| 11 | Login test cases | Tester | Test table covering happy path, errors, lockout, devices, accessibility | 7 |

Decisions for the team:

- Staff accounts (admin, prefect, dept head) can technically log in, but the app is for students. This cycle shows "This app is for students. Please use the web or desktop app." for non-student roles. The Android app does not do this yet.
- XcodeGen is used so the project file is generated, not hand-edited. If the team prefers, create the project in Xcode and drag the `RCOSD` folder in instead (see README).
