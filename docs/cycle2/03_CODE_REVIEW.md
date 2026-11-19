# Code Review: Cycle 2 (Dashboard + Tab Bar)

Role: Code Reviewer. Scope: the new and changed files in this cycle.

**Verdict: APPROVE WITH SMALL FIXES.** The code has **not been compiled yet**, because it was written on Windows. Build it on a Mac before testing.

| Severity | File | Problem | Fix (status) |
| --- | --- | --- | --- |
| Major | `Features/Dashboard/DashboardViewModel.swift` | The first version used a helper inside the main-actor class that captured `self` across actors, a likely compile error in `async let` | Copy `service` and the ID into local constants and use a top-level `resultOf` helper (fixed) |
| Minor | `Features/Home/HomePlaceholderView.swift` | Unused after the Dashboard replaced it | Deleted (fixed) |
| Minor | `Shared/Components/AutoRefresh.swift` | The refresh closure captures the view; strict concurrency checking (Swift 6 mode) may warn | Acceptable in Swift 5 mode; revisit when moving to Swift 6 (open) |
| Minor | `Models/Appeal.swift` | The backend may leave out `edited`, `message` or `status` on older rows | Custom decoder with safe defaults (fixed) |
| Nit | `App/MainTabView.swift` | Logout as a tab is not a typical iOS pattern | Kept for parity with Android, as decided in the design spec (accepted) |

Checked and correct:

- **Same rules as Android:** pending appeals are PENDING or UNDER_REVIEW; Recent Activity shows the 3 newest items (offenses plus decided appeals); the Year/Grade fallback is "—"; date-times use `MM/dd/yyyy · h:mm a`.
- **Errors:** each data source can fail on its own. An error appears only when nothing loads, and a failed silent refresh keeps the current data.
- **Performance:** the three requests run in parallel; auto-refresh stops when the view disappears or the app leaves the foreground.
- **Accessibility:** combined elements for the cards, header traits, button hints, and Dynamic Type with scale-to-fit on stat values.

To check on the first Mac build:

1. That `resultOf` inside `async let` compiles without warnings.
2. That a JSON response from `/api/records/student/{id}` decodes into `OffenseRecord` (compare a real response if decoding fails).
3. That the Logout tab returns to the previous tab when you choose Cancel.
