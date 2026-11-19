# Tickets: Cycle 4 (Appeal)

---

### IOS-? File upload support

**Type:** Task · **Owner:** Developer · **Status:** Done

**Description:** The app can send a file (photo, PDF, Word) to the backend.

**User story:** As a student, I want to attach my appeal letter, so that the office can read my proof.

**Acceptance criteria:**

- [ ] Photos are made smaller (max 1500 px, JPEG) before upload.
- [ ] PDF and Word files upload as they are.
- [ ] Upload errors show a clear message.

---

### IOS-? File a New Appeal

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** Students file an appeal for one offense, with an optional letter.

**User story:** As a student, I want to explain why I'm appealing and attach a letter, so that the prefect can review my case.

**Acceptance criteria:**

- [ ] The message is required ("Please enter a message explaining your appeal.").
- [ ] Take Photo and Choose File (Photo Library or Files) both work.
- [ ] Submit is blocked while uploading ("Please wait for your file to finish uploading.") or after a failed upload ("Your attached file did not upload. Remove it or attach it again before submitting.").
- [ ] "Submit this appeal?" asks for confirmation.
- [ ] After success: "Appeal submitted successfully. Returning to the offense...", and the offense shows Processing.

---

### IOS-? My Appeals and editing

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** The Appeal tab lists all appeals and lets students edit pending ones.

**User story:** As a student, I want to track my appeals and fix a pending one, so that I don't need to visit the office.

**Acceptance criteria:**

- [ ] Shows Total Filed, Pending, Approved and Denied counts and an All/Pending/Approved/Denied filter.
- [ ] Each card shows the appeal ID, status, offense, reason, submitted date, date of resolution and remarks.
- [ ] "Edit appeal" appears only on Pending appeals; after saving, the card shows "Edited".
- [ ] An empty edit shows "Appeal message is required."

---

### IOS-? Test the Appeal screens

**Type:** Task · **Owner:** Tester · **Status:** Open

**Acceptance criteria:**

- [ ] All cases in `04_APPEAL_TEST_CASES.md` are run, the camera cases on a real iPhone.
- [ ] No Critical or High bugs remain open.
