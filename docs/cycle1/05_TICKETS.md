# Tickets: Cycle 1 (Core Setup + Login)

Role: Ticket Writer. Copy each ticket into Jira and replace `IOS-?` with the real key.

---

### IOS-? Set up the iOS project

**Type:** Task · **Owner:** Developer · **Status:** Done (not yet built on a Mac)

**Description:** Create the iOS project for the RC-OSD student app so the team can start building screens.

**User story:** As a developer, I want a ready project with the agreed folder layout, so that everyone builds screens the same way.

**Acceptance criteria:**

- [ ] Running `xcodegen generate` creates `RCOSD.xcodeproj` with the `RCOSD` app target and iOS 16 minimum.
- [ ] The Debug build talks to `http://localhost:8080` and the Release build to `https://rc-osd.tech`.
- [ ] The camera and photo library permission messages are in Info.plist.
- [ ] The app opens in the iPhone simulator.

---

### IOS-? Brand colors and dark mode

**Type:** Task · **Owner:** Developer · **Status:** Done

**Description:** Copy the Android app's colors into the iOS app with light and dark versions.

**User story:** As a student, I want the iPhone app to look like the Android app, so that both feel like the same product.

**Acceptance criteria:**

- [ ] Colors such as `osdaPrimary` and `osdaBackground` match the Android values.
- [ ] Dark mode switches automatically with the phone setting.

---

### IOS-? Secure session storage

**Type:** Story · **Owner:** Developer · **Status:** Done

**Description:** Keep the student signed in safely between app launches.

**User story:** As a student, I want to stay signed in after closing the app, so that I don't log in every time.

**Acceptance criteria:**

- [ ] The login token is saved only in the iPhone Keychain.
- [ ] Reopening the app keeps the student signed in.
- [ ] Logging out deletes the saved token.

---

### IOS-? Backend connection layer

**Type:** Story · **Owner:** Developer · **Status:** Done

**Description:** One shared way for all screens to call the existing backend and show its error messages.

**User story:** As a student, I want clear messages when something goes wrong, so that I know what to do.

**Acceptance criteria:**

- [ ] Every protected call sends the login token.
- [ ] Server error messages are shown as written by the server.
- [ ] No internet or a timeout shows "Can't reach the server. Check your internet connection and try again."
- [ ] If the token has expired, the app renews it once; if that fails, the student is returned to Login.

---

### IOS-? Shared date format

**Type:** Task · **Owner:** Developer · **Status:** Done

**Description:** Show every date the same way as the Android app.

**User story:** As a student, I want dates written the same way on every screen, so that records are easy to read.

**Acceptance criteria:**

- [ ] Dates show as MM/DD/YYYY, for example 10/07/2026.
- [ ] Date and time show as MM/DD/YYYY · h:mm AM/PM.
- [ ] A missing date shows "Not on file".

---

### IOS-? Login screen

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** Students sign in with their Student ID and password, with the same rules and messages as the Android app.

**User story:** As a student, I want to sign in with my Student ID, so that I can see my records.

**Acceptance criteria:**

- [ ] Empty fields show "Student ID and password are required."
- [ ] A wrong password shows the server message with the attempt count, e.g. "Attempt 1 of 5".
- [ ] A locked or inactive account shows "Proceed to prefect office to request for account reactivation".
- [ ] The eye icon shows and hides the password.
- [ ] Staff accounts see "This app is for students. Please use the web or desktop app."
- [ ] While signing in, the button shows "Signing in..." and cannot be tapped twice.

---

### IOS-? Temporary home screen and logout

**Type:** Story · **Owner:** Developer · **Status:** Done (replaced by the Dashboard next cycle)

**Description:** A simple screen after login that proves the session works, plus logout.

**User story:** As a student, I want to see my name after signing in and be able to log out, so that I know I'm in the right account.

**Acceptance criteria:**

- [ ] The screen shows the student's full name, student ID, year level and section.
- [ ] Log Out asks "Log out?" with Cancel and Log Out.
- [ ] Confirming returns to Login.

---

### IOS-? Test the Login screen

**Type:** Task · **Owner:** Tester · **Status:** Open

**Description:** Run the 19 Login test cases on the simulator and a real iPhone.

**User story:** As the team, we want Login fully tested, so that students don't get stuck at sign-in.

**Acceptance criteria:**

- [ ] All test cases in `04_LOGIN_TEST_CASES.md` are run on an iPhone SE simulator and a large iPhone simulator.
- [ ] Results are recorded, and every failure has a bug report.
- [ ] No Critical or High bugs remain open.

---

### IOS-? First build on a Mac

**Type:** Task · **Owner:** Developer · **Status:** Open

**Description:** The code was written outside a Mac and has not been compiled yet.

**User story:** As a developer, I want the project to build cleanly in Xcode, so that testing can start.

**Acceptance criteria:**

- [ ] `xcodegen generate` runs without errors.
- [ ] The app builds with no errors in Xcode 15 or newer.
- [ ] The app runs in the simulator and IOS-LGN-01 passes against the local backend.
