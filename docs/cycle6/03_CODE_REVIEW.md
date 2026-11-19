# Code Review: Cycle 6 (Handbook + Profile) and full-app pass

Role: Code Reviewer. **Verdict: APPROVE WITH SMALL FIXES.** Not compiled yet (written on Windows). This review also re-checked how the whole app is wired together.

| Severity | File | Problem | Fix (status) |
| --- | --- | --- | --- |
| Major | `App/MainTabView.swift` | "File an Appeal" on the Dashboard went to Offenses, but Android opens the Appeals tab | Opens the Appeal tab (fixed) |
| Minor | `App/RootView.swift` | Switching accounts could keep the previous student's screens in memory | `.id(studentId)` rebuilds the tabs for each login (fixed) |
| Minor | `Shared/Components/ComingSoonView.swift` | No longer used | Deleted (fixed) |
| Minor | `Features/Profile/ProfileView.swift` | The Dark Mode setting is stored in UserDefaults | It's a display preference, not private data; allowed by the project rules (accepted) |
| Nit | `Models/HandbookAndGuardian.swift` | Sections get a random `id` on each load, so expanded cards close after a refresh | Acceptable, since the handbook only loads once per opening (accepted) |

Full-app checks:

- Every Android screen now exists: Login, Dashboard, Records, Offense Details, Appeal (file, list, edit), Chat, Handbook, Profile.
- No placeholder screens remain, and no references to deleted files.
- One `APIClient`, one date helper and one set of status colors are used everywhere.
- The token lives only in the Keychain, nothing sensitive is logged, and Release uses HTTPS.

## First Mac build checklist

1. `xcodegen generate`, then build in Xcode 15+ and fix any compiler errors.
2. Run all test files: cycle 1 Login, cycle 2 Dashboard, cycle 3 Records, cycle 4 Appeal, cycle 5 Chat, cycle 6 Handbook/Profile.
3. Confirm the "To check on the first Mac build" items in each cycle's `03_CODE_REVIEW.md`.
4. Add the real app icon and school logo in `Assets.xcassets` (still SF Symbol placeholders).
