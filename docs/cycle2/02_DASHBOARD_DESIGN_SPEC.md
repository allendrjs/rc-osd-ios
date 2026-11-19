# Design Spec: Screen 2, Dashboard + Tab Bar

Role: UI/UX Designer.

## 1. Purpose

The student sees a summary of their record at a glance and jumps to the main tasks.

## 2. Layout (scrolls; 20 pt side margins; 16 pt between sections)

| Element | Details |
| --- | --- |
| Navigation title | "Dashboard", large title |
| Welcome card | `osdaPrimary` fill, radius 16, padding 18. Line 1: "Welcome back, {full name}" (`.headline`, white). Line 2: "{student type}  •  {section}  •  Student ID {id}" (`.caption`, white 75%). Optional status pill with the disciplinary status: green if it contains "good", amber otherwise |
| Error line | Red `.footnote` text with a "Retry" button; only when nothing could be loaded |
| Stat cards | Three equal cards in a row: "{n} Offenses" (heading color), "{n} Pending Appeals" (amber), "{level} Year/Grade" (heading color; "—" if missing). Value `.title2` bold, label `.caption` muted |
| "Quick Actions" | Section title `.headline`. Four tappable rows (icon tile, title, subtitle, chevron) |
| "Recent Activity" | Section title. Up to 3 cards, newest first |
| Tab bar | Dashboard (`square.grid.2x2`), Offenses (`list.bullet.rectangle`), Appeal (`doc.text`), Profile (`person.crop.circle`), Logout (`rectangle.portrait.and.arrow.right`); selected tint `osdaPrimary` |

Quick Actions copy (same as Android):

| Title | Subtitle | Goes to |
| --- | --- | --- |
| View Offenses | See your disciplinary records | Offenses tab |
| File an Appeal | Request a review of a case | Appeal tab |
| Ask the Chatbot | Get answers about your offenses and appeals | Chat (sheet) |
| Student Handbook | Read the policies for your department | Handbook (sheet) |

Recent Activity rows:

- Offense: title "New Offense Logged", subtitle "{offense name}  •  {MM/dd/yyyy · h:mm a}".
- Decided appeal: title "Appeal Approved" or "Appeal Denied", subtitle "{offense name}  •  {date processed or filed}".

## 3. States

| State | Behavior |
| --- | --- |
| First load | Stat cards shown as gray placeholders; spinner in Recent Activity |
| Loaded | All values shown |
| No activity | "Nothing to show yet." |
| No enrollment | Name falls back to the Student ID; Year/Grade shows "—" |
| Everything failed | Error line with Retry, e.g. "Can't reach the server. Check your internet connection and try again." |
| Refresh fails after data loaded | Keep the current data; no error shown |
| Session expired | Return to Login (handled by the app) |

## 4. Interactions

- Pull down to refresh.
- Auto-refresh every 15 s while the Dashboard is visible and the app is open; stops in the background.
- Logout tab: shows "Log out?" with Cancel / Log Out; Cancel returns to the tab the student was on.

## 5. Accessibility

- The welcome card and each stat card are read as one element (e.g. "2 Offenses").
- Quick Action rows are buttons with the subtitle as a hint.
- Section titles are headers. Dynamic Type supported; stat values shrink to fit instead of cutting off.
- Dark mode uses the dark palette and dark status colors.

## 6. iOS differences from Android

- Logout lives in the tab bar to match Android, but behaves like a button (iOS tabs are normally places, not actions).
- Chat and Handbook open as sheets that slide up, the usual iOS pattern for side tasks.

## Developer checklist

- [ ] Copy matches the tables above
- [ ] Loading, empty, error and no-enrollment states
- [ ] Pull to refresh and 15 s auto-refresh
- [ ] Logout confirmation and returning to the previous tab
- [ ] Dark mode and largest text size
