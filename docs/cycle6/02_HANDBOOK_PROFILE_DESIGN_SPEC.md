# Design Spec: Screens 7–8, Handbook + Profile

Role: UI/UX Designer.

## Student Handbook (sheet from the Dashboard)

| Element | Details |
| --- | --- |
| Title | "Student Handbook" (inline), "Close" on the left |
| Search | Always-visible search bar, prompt "Search the handbook…"; matches section titles and text |
| Department line | "{JHS/SHS/COLLEGE} Student Handbook" (caption, muted) |
| Section card | Title ("Handbook Section" if missing) with a 2-line preview; tapping expands the full text (selectable) |
| Empty | "No handbook content is available yet for your department." |
| No match | "No sections match "{query}"." |
| Error | Server message and Retry |

## Profile (tab)

| Element | Details |
| --- | --- |
| Header | Initials circle (`osdaPrimary`), full name, "Student ID {id}  •  {section}" |
| Counts | Offenses, Pending Appeals (amber), Year Level |
| Appearance | Card with a "Dark Mode" switch |
| Personal Information | Name, Date of Birth (MM/dd/yyyy, "Not on file"), Contact Number, Guardian's Contact (first guardian), Section ("—") |
| Guardians | One card per guardian: name, relationship, contact number; "No guardian information on file." if none |
| Footer note | "Information comes from the school's records. Ask the prefect office to correct any wrong details." |

Dark mode: the app is light by default (same as Android). Turning the switch on applies the dark palette to every screen immediately and is remembered after restart.

Accessibility: rows read as "label, value"; section titles are headers; the switch is a standard toggle; Dynamic Type supported.
