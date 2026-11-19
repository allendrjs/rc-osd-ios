# Tickets: Cycle 2 (Dashboard + Tab Bar)

Role: Ticket Writer. Replace `IOS-?` with the real Jira key.

---

### IOS-? Data models for records and appeals

**Type:** Task · **Owner:** Developer · **Status:** Done (not yet built on a Mac)

**Description:** Teach the iOS app to read the student's offenses and appeals from the backend, using the same fields as the Android app.

**User story:** As a developer, I want ready data models, so that every screen reads records and appeals the same way.

**Acceptance criteria:**

- [ ] Records from the backend load without errors and include the offense name, status and dates.
- [ ] Appeals load even when older rows have no "edited" value.
- [ ] Offense statuses are understood as Pending, Processing, Approved or Resolved.

---

### IOS-? Shared screen pieces

**Type:** Task · **Owner:** Developer · **Status:** Done

**Description:** Reusable parts for upcoming screens: status labels, cards, auto-refresh and a "coming soon" placeholder.

**User story:** As a student, I want status labels and cards to look the same everywhere, so that the app is easy to read.

**Acceptance criteria:**

- [ ] Status labels stay on one line and use green, blue, amber or red like Android.
- [ ] Auto-refresh runs every 15 seconds only while the screen is visible and the app is open.
- [ ] Unfinished screens show "{Screen} is coming in a later update."

---

### IOS-? Bottom tab bar with logout

**Type:** Story · **Owner:** Developer · **Status:** Done

**Description:** The same five tabs as the Android app at the bottom of the screen.

**User story:** As a student, I want a tab bar, so that I can move between the main parts of the app.

**Acceptance criteria:**

- [ ] Tabs: Dashboard, Offenses, Appeal, Profile, Logout.
- [ ] Logout shows "Log out?" with Cancel and Log Out.
- [ ] Cancel keeps the student on the tab they were on.
- [ ] Log Out returns to the Login screen.

---

### IOS-? Dashboard screen

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** The first screen after login, showing the student's summary and shortcuts.

**User story:** As a student, I want to see my offenses, pending appeals and latest updates right after I log in, so that I know my status quickly.

**Acceptance criteria:**

- [ ] Shows "Welcome back, {full name}" with the student type, section and Student ID.
- [ ] Shows the disciplinary status in green for good standing, amber otherwise.
- [ ] Shows three counts: Offenses, Pending Appeals and Year/Grade ("—" if not enrolled).
- [ ] Four Quick Actions: View Offenses, File an Appeal, Ask the Chatbot, Student Handbook.
- [ ] Recent Activity shows up to 3 items, newest first, or "Nothing to show yet."
- [ ] Pulling down refreshes the data; it also refreshes by itself every 15 seconds.
- [ ] Without internet on first load, an error appears with a Retry button.

---

### IOS-? Test the Dashboard and tab bar

**Type:** Task · **Owner:** Tester · **Status:** Open

**Description:** Run the 20 Dashboard test cases and compare the results with the Android app.

**User story:** As the team, we want the Dashboard tested, so that the numbers students see are correct.

**Acceptance criteria:**

- [ ] All cases in `04_DASHBOARD_TEST_CASES.md` are run on an iPhone SE and a large iPhone simulator.
- [ ] The counts match the Android app for the same student.
- [ ] Failures have bug reports; no Critical or High bugs remain open.

---

### IOS-? Check cycle 2 on the first Mac build

**Type:** Task · **Owner:** Developer · **Status:** Open

**Description:** Cycle 2 was written on Windows and needs a compile check on a Mac.

**User story:** As a developer, I want cycle 2 to build cleanly, so that testing can start.

**Acceptance criteria:**

- [ ] The app builds with no errors in Xcode 15 or newer.
- [ ] The three items in `03_CODE_REVIEW.md` "To check on the first Mac build" are confirmed.
