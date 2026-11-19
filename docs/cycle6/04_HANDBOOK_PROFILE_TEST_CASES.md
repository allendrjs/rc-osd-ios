# Test Cases: Screens 7–8, Handbook + Profile (iOS)

Role: QA Tester. Test accounts only.

| ID | Feature | Steps | Expected result | Priority | ISO 9126 |
| --- | --- | --- | --- | --- | --- |
| IOS-HBK-01 | Open handbook | Dashboard, then Student Handbook | Sections for the student's department (e.g. "COLLEGE Student Handbook") | High | Functionality |
| IOS-HBK-02 | Expand section | Tap a section | Full text shown; tap again collapses it | Medium | Usability |
| IOS-HBK-03 | Search | Type "dress" | Only matching sections | High | Functionality |
| IOS-HBK-04 | No match | Type "zzzz" | "No sections match "zzzz"." | Low | Functionality |
| IOS-HBK-05 | Department | Log in as a JHS student and as a College student | Each sees their own handbook | High | Functionality |
| IOS-HBK-06 | No content | Department without handbook data | "No handbook content is available yet for your department." | Medium | Functionality |
| IOS-PRF-01 | Header and counts | Open Profile | Name, Student ID, section; counts match the Dashboard | High | Functionality |
| IOS-PRF-02 | Personal information | Check the rows | Name, Date of Birth (MM/dd/yyyy), Contact Number, Guardian's Contact, Section | High | Functionality |
| IOS-PRF-03 | Guardians | Student with guardians | One card each with name, relationship and number | Medium | Functionality |
| IOS-PRF-04 | No guardians | Student without guardians | "No guardian information on file." | Low | Functionality |
| IOS-PRF-05 | Dark mode on | Turn on Dark Mode | Every screen switches to dark at once | High | Usability |
| IOS-PRF-06 | Dark mode remembered | Turn it on, kill and reopen the app | Still dark | Medium | Reliability |
| IOS-PRF-07 | Not editable | Try to change a detail | Nothing is editable; the footer note explains who to ask | Low | Functionality |
| IOS-ALL-01 | Full journey | Login → Dashboard → Offense → File Appeal → Appeal tab → Chat → Handbook → Profile → Logout | Every step works; no crash | High | Reliability |
| IOS-ALL-02 | Parity sweep | Same student on Android and iOS | Same numbers, statuses and messages everywhere | High | Functionality |
