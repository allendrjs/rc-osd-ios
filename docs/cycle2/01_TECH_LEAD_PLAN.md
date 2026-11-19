# Cycle 2 Plan: Screen 2 (Dashboard) + Tab Bar

Role: Tech Lead. Goal: after login, the student lands on a working Dashboard with the bottom tab bar, the same as the Android app.

| # | Task | Owner | Acceptance criteria | Depends on |
| --- | --- | --- | --- | --- |
| 1 | Data models | Developer | `OffenseRecord`, `Appeal` and the nested summaries decode the backend JSON (field names copied from the Android models) | none |
| 2 | Student data service | Developer | One place that loads the latest enrollment, the student's records and the student's appeals | 1 |
| 3 | Shared components | Developer | Status pill (one line, colored by status), card, 15-second auto-refresh, "coming soon" placeholder | none |
| 4 | Dashboard design spec | Designer | Every element, state and message written down | none |
| 5 | Tab bar | Developer | Tabs: Dashboard, Offenses, Appeal, Profile, Logout; Logout asks "Log out?" and stays on the current tab if cancelled | 3 |
| 6 | Dashboard screen | Developer | Matches the spec: welcome card, three stat cards, four Quick Actions, Recent Activity (latest 3), pull to refresh, auto-refresh every 15 s | 2, 3, 4 |
| 7 | Code review | Reviewer | Report with verdict; Blocker and Major items fixed | 5, 6 |
| 8 | Test cases | Tester | Dashboard and tab bar test table | 4 |
| 9 | Tickets | Ticket Writer | Tickets file for this cycle | all |

Out of scope (later cycles): the Offenses, Appeal and Profile tabs and the Chat and Handbook screens show a "coming in a later update" placeholder for now.
