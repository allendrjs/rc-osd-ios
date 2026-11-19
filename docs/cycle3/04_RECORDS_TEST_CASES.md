# Test Cases: Screens 3–4, Records + Offense Details (iOS)

Role: QA Tester. Test accounts only (local DB password `1234`).

| ID | Feature | Steps | Expected result | Priority | ISO 9126 |
| --- | --- | --- | --- | --- | --- |
| IOS-REC-01 | List loads | Open the Offenses tab | Offenses shown newest first; same list as Android | High | Functionality |
| IOS-REC-02 | Counts | Compare Total/Active/Resolved with Android | Numbers match | High | Functionality |
| IOS-REC-03 | Filter Active | Choose Active | Only Pending and Processing offenses | High | Functionality |
| IOS-REC-04 | Filter Resolved | Choose Resolved | Only Approved and Resolved offenses | High | Functionality |
| IOS-REC-05 | Card content | Look at one card | "OFFENSE ID: OF-xxxx", colored status, name, "Filed: MM/dd/yyyy · h:mm a" | Medium | Functionality |
| IOS-REC-06 | Empty | Student with no offenses | "No offenses on file." | Medium | Functionality |
| IOS-REC-07 | Pull to refresh / auto-refresh | Add an offense on the desktop app, wait 15 s | It appears without leaving the screen | High | Reliability |
| IOS-REC-08 | Open details | Tap an offense | Offense Details shows Type, both dates, Reported By, Status, Disciplinary Action | High | Functionality |
| IOS-REC-09 | Missing values | Offense with no action and no resolution | "No action recorded yet." and "Not yet resolved" | Medium | Functionality |
| IOS-REC-10 | Appeal allowed | Open a PENDING offense with no appeal | File an Appeal is enabled | High | Functionality |
| IOS-REC-11 | Already under review | Open a PROCESSING offense | Button disabled; "This offense is already under appeal review." | High | Functionality |
| IOS-REC-12 | Closed offense | Open a RESOLVED offense | Button disabled; "This offense is resolved and can no longer be appealed." | High | Functionality |
| IOS-REC-13 | Back navigation | Details, then swipe back | Returns to the list at the same scroll position | Medium | Usability |
| IOS-REC-14 | No internet | Airplane mode, open the tab for the first time | Error with Retry | Medium | Reliability |
| IOS-REC-15 | Large text / dark mode | Largest text, dark mode | Cards and rows readable, nothing cut off | Medium | Usability |
