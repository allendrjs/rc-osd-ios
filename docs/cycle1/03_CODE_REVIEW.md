# Code Review: Cycle 1 (Core Setup + Login)

Role: Code Reviewer. Scope: everything under `RCOSD/` plus `project.yml`.

**Verdict: APPROVE WITH SMALL FIXES.** All Blocker and Major items below were fixed in the same cycle. The code has **not been compiled yet**, because it was written outside a Mac. The first step on a Mac is to build it and fix any compiler errors.

| Severity | File | Problem | Fix (status) |
| --- | --- | --- | --- |
| Blocker | `Core/Networking/APIClient.swift` (refreshToken) | `guard let (data, response) = try? ...` is a tuple pattern in an optional binding, which Swift does not allow | Bind the result first, then use `result.0` / `result.1` (fixed) |
| Major | `Features/Home/HomePlaceholderView.swift` | `.topBarTrailing` only exists on iOS 17, but the minimum is iOS 16 | Use `.navigationBarTrailing` (fixed) |
| Major | `App/RootView.swift` | The `sessionExpired` notification can arrive on a background thread, and SwiftUI state must change on the main thread | Add `.receive(on: RunLoop.main)` (fixed) |
| Minor | `Core/Networking/APIClient.swift` (AnyEncodable) | `value.encode` as a method reference on `any Encodable` may not compile on older toolchains | Wrap it in a closure (fixed) |
| Minor | `App/AppSession.swift` | Logout ran as an authorized call after the token was cleared, which could trigger a refresh attempt | Call `/login/logout` with `authorized: false` (fixed) |
| Minor | `project.yml` | `NSAllowsLocalNetworking` stays on in Release. It only allows `localhost`/`.local`, not the internet, so App Store review accepts it | Keep it. Revisit if Apple asks (open) |
| Nit | `Features/Login/LoginView.swift` | The logo is an SF Symbol placeholder | Add the real logo to `Assets.xcassets` in cycle 2 (open) |

Checked and correct:

- **Security:** the token is stored only in the Keychain (`kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`). No tokens or passwords are logged, the password field is cleared after a successful login, and Release uses HTTPS.
- **Errors:** the server's `message` is shown, so the Attempt counter and the locked-account text match Android. Network failures, timeouts and cancellation are handled.
- **Architecture:** views do no networking directly except the temporary Home placeholder, which gets a ViewModel in cycle 2. There's one `APIClient` and one date helper.
- **Accessibility:** labeled fields, a 44 pt eye button, error announcements, Dynamic Type through system text styles, and dark mode colors.

Done well:

1. The token refresh happens once and then cleanly signs the user out.
2. Copy and messages match the Android app and the design spec.
3. A small, readable structure that follows the folder layout in the prompt pack.
