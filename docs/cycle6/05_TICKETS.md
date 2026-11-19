# Tickets: Cycle 6 (Handbook + Profile) and wrap-up

---

### IOS-? Student Handbook screen

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** Students read and search the handbook for their own department.

**User story:** As a student, I want to read the rules in the app, so that I can check them without a printed copy.

**Acceptance criteria:**

- [ ] Shows the sections for the student's department as cards that expand when tapped.
- [ ] Search filters by title and text; no results shows "No sections match "…"."
- [ ] With no content: "No handbook content is available yet for your department."

---

### IOS-? Profile screen with dark mode

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** Students see their personal and guardian details and can switch to dark mode.

**User story:** As a student, I want to check my details and choose dark mode, so that my information is correct and the app is comfortable to use.

**Acceptance criteria:**

- [ ] Shows name, Student ID, section, offense and pending appeal counts, and year level.
- [ ] Personal Information: Name, Date of Birth (MM/DD/YYYY), Contact Number, Guardian's Contact, Section.
- [ ] Guardians listed with relationship and contact number, or "No guardian information on file."
- [ ] The Dark Mode switch changes the whole app and is remembered after restart.

---

### IOS-? Connect all tabs and screens

**Type:** Task · **Owner:** Developer · **Status:** Done

**Description:** Replace the placeholders so every tab and shortcut opens the real screen.

**Acceptance criteria:**

- [ ] Dashboard shortcuts open Offenses, Appeal, Chat and Handbook.
- [ ] Chat buttons "View My Offenses/Appeals" close the chat and open the right tab.
- [ ] No "coming in a later update" screens remain.

---

### IOS-? First build and full test round on a Mac

**Type:** Task · **Owner:** Developer + Tester · **Status:** Open

**Description:** The whole app was written on Windows and must be built and tested on a Mac.

**Acceptance criteria:**

- [ ] The app builds in Xcode 15+ with no errors.
- [ ] Every test file in cycles 1–6 has been run, with results recorded.
- [ ] The real app icon and school logo are added.
- [ ] No Critical or High bugs remain open before the TestFlight pilot.
