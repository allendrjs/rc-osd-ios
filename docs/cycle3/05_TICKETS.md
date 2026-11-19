# Tickets: Cycle 3 (Records + Offense Details)

---

### IOS-? Offenses list (Records)

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** The Offenses tab shows every offense on the student's record.

**User story:** As a student, I want to see all my offenses in one list, so that I know what is on my record.

**Acceptance criteria:**

- [ ] Shows Total, Active and Resolved counts.
- [ ] The All / Active / Resolved filter works (Active = Pending or Processing).
- [ ] Each card shows "OFFENSE ID: OF-xxxx", a colored status, the offense name and "Filed: MM/DD/YYYY · h:mm AM/PM".
- [ ] Newest offense first; "No offenses on file." when empty.
- [ ] Pull to refresh, plus an automatic refresh every 15 seconds.

---

### IOS-? Offense Details

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** Full information about one offense, and the starting point for an appeal.

**User story:** As a student, I want to see the details of an offense and appeal it if allowed, so that I can respond to it.

**Acceptance criteria:**

- [ ] Shows Type, Date of Violation, Date of Resolution ("Not yet resolved"), Reported By, Status and Disciplinary Action.
- [ ] File an Appeal works only for Pending offenses with no appeal yet.
- [ ] Otherwise it shows "This offense is already under appeal review." or "This offense is {status} and can no longer be appealed."

---

### IOS-? Test Records and Offense Details

**Type:** Task · **Owner:** Tester · **Status:** Open

**Acceptance criteria:**

- [ ] All cases in `04_RECORDS_TEST_CASES.md` are run; results match Android.
- [ ] No Critical or High bugs remain open.
