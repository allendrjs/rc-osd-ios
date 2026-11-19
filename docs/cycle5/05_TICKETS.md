# Tickets: Cycle 5 (Chat)

---

### IOS-? Chat assistant

**Type:** Story · **Owner:** Developer + Designer · **Status:** Done (needs testing)

**Description:** Students ask the chatbot about the handbook and their own records.

**User story:** As a student, I want to ask questions any time, so that I understand the rules and my record without visiting the office.

**Acceptance criteria:**

- [ ] Answers questions using the handbook, and says when it can't answer.
- [ ] Shows "Waking up the assistant..." for the first answer and "Thinking..." after.
- [ ] Starter chips: File an Appeal, Check My Offenses/Appeals, Dress Code, Attendance, Major Offenses, Bullying Policy.
- [ ] "Check My Offenses/Appeals" gives counts that match the app and links to the Offenses or Appeal tab.

---

### IOS-? File an appeal in the chat

**Type:** Story · **Owner:** Developer · **Status:** Done (needs testing)

**Description:** A guided, step-by-step appeal inside the chat, the same as on Android.

**User story:** As a student, I want the chatbot to walk me through filing an appeal, so that it's easy even if I'm unsure what to do.

**Acceptance criteria:**

- [ ] Only offenses that can be appealed are offered; with none, the bot says so.
- [ ] Steps: pick offense, write reason, optional letter (Take Photo / Choose File / Skip), confirm.
- [ ] After Submit, the appeal appears on the Appeal tab and the offense shows Processing.
- [ ] Cancel at any step stops without submitting.

---

### IOS-? Test the chat

**Type:** Task · **Owner:** Tester · **Status:** Open

**Acceptance criteria:**

- [ ] All cases in `04_CHAT_TEST_CASES.md` are run with the backend and Ollama running.
- [ ] No Critical or High bugs remain open.
