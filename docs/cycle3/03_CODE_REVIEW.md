# Code Review: Cycle 3 (Records + Offense Details)

Role: Code Reviewer. **Verdict: APPROVE WITH SMALL FIXES.** Not compiled yet (written on Windows).

| Severity | File | Problem | Fix (status) |
| --- | --- | --- | --- |
| Major | `Features/Records/RecordsViewModel.swift` | Records were sorted by the raw date text, which can misorder formats like "2026-1-5" | Sort by parsed date (fixed) |
| Minor | `Features/Records/RecordsViewModel.swift` | An unknown status from the backend would vanish from both filters | Unknown statuses count as Active, like Android (fixed) |
| Minor | `Features/Records/OffenseDetailView.swift` | Android shows `dateOfResolution` as raw text; iOS formats it | Formatted with the shared helper, falling back to the raw text (accepted improvement) |
| Nit | `Features/Records/RecordsView.swift` | `offenseCode` is a global function | Fine for now; move into a formatter file if more are added (open) |

Checked and correct: the offense detail reads from the same view model as the list, so it updates after an appeal is filed; the appeal rules match Android (PENDING and no existing appeal); loading, empty, error and not-found states exist; auto-refresh stops when the tab is hidden.

To check on the first Mac build: a push from the list to the details and then to File Appeal and back keeps the back stack correct (iOS 16 `navigationDestination(isPresented:)` inside a path-based stack).
