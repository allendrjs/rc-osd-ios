# Test Cases: Screen 2, Dashboard + Tab Bar (iOS)

Role: QA Tester. Use the local test database (password `1234`) or test accounts only.

| ID | Feature | Preconditions | Steps | Test data | Expected result | Priority | ISO 9126 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| IOS-DSH-01 | Welcome card | Logged in | Open the Dashboard | CT23-0002 | "Welcome back, {full name}" and "{type}  •  {section}  •  Student ID CT23-0002" | High | Functionality |
| IOS-DSH-02 | Disciplinary status pill | Student has a status | Look at the welcome card | any | Status shown; green if "Good Standing", amber otherwise | Medium | Functionality |
| IOS-DSH-03 | Offense count | Student with offenses | Compare with the Android app | CT23-0002 | "Offenses" equals the number of records on Android | High | Functionality |
| IOS-DSH-04 | Pending appeals count | Student with a pending appeal | Check the stat card | any | Count matches the pending appeals on Android | High | Functionality |
| IOS-DSH-05 | Year/Grade | Enrolled student | Check the stat card | any | Shows the level, e.g. "3rd Year"; "—" if no enrollment | Medium | Functionality |
| IOS-DSH-06 | Quick Action: View Offenses | On Dashboard | Tap "View Offenses" | none | Switches to the Offenses tab | High | Functionality |
| IOS-DSH-07 | Quick Action: File an Appeal | On Dashboard | Tap "File an Appeal" | none | Switches to the Appeal tab | High | Functionality |
| IOS-DSH-08 | Quick Action: Chat / Handbook | On Dashboard | Tap each | none | A sheet slides up (placeholder this cycle); swipe down closes it | Medium | Functionality |
| IOS-DSH-09 | Recent Activity | Student with offenses and a decided appeal | Check the list | any | At most 3 items, newest first, correct titles and MM/dd/yyyy · h:mm a dates | High | Functionality |
| IOS-DSH-10 | Empty activity | Student with no records or appeals | Open the Dashboard | a clean test student | "Nothing to show yet." | Medium | Functionality |
| IOS-DSH-11 | Pull to refresh | On Dashboard | Pull down | none | Refreshes without clearing the screen | Medium | Usability |
| IOS-DSH-12 | Auto-refresh | Dashboard open | Log a new offense for the student on the desktop app; wait about 15 s | any | The new offense appears without touching the phone | High | Reliability |
| IOS-DSH-13 | No internet on first load | Airplane mode | Log in from a saved session and open the Dashboard | none | Error line with Retry; Retry works after reconnecting | High | Reliability |
| IOS-DSH-14 | Internet drops after loading | Data shown | Turn on airplane mode and wait 15 s | none | Data stays on screen; no crash | Medium | Reliability |
| IOS-DSH-15 | Logout tab, cancel | On Offenses tab | Tap Logout, then Cancel | none | Stays on the Offenses tab, still signed in | High | Usability |
| IOS-DSH-16 | Logout tab, confirm | Signed in | Tap Logout, then Log Out | none | Returns to Login; reopening the app shows Login | High | Functionality |
| IOS-DSH-17 | Session expired | Token expired (wait past 60 min or restart the backend with a new secret) | Pull to refresh | none | Returns to Login | Medium | Reliability |
| IOS-DSH-18 | Dark mode and large text | Dark mode, largest text | Open the Dashboard | none | Everything readable; stat values shrink to fit; nothing cut off | Medium | Usability |
| IOS-DSH-19 | VoiceOver | VoiceOver on | Swipe through the Dashboard | none | Reads "Welcome back…", each stat as one item, Quick Actions as buttons | Low | Usability |
| IOS-DSH-20 | Small and large iPhone | iPhone SE and Pro Max simulators | Open the Dashboard | none | The stat row fits on both; no overlapping text | Medium | Portability |
