# Design Spec: Screen 1, Login

Role: UI/UX Designer.

## 1. Purpose

The student signs in with their Student ID and password to reach their records.

## 2. Layout (top to bottom, centered card, scrolls when the keyboard is open)

| Element | Details |
| --- | --- |
| Background | `osdaBackground`, full screen |
| Card | `osdaSurface`, corner radius 20, 1 pt border `osdaBorder`, padding 24, max width 420 |
| Logo | App logo, 72 × 72 pt, circle; placeholder SF Symbol `building.columns.fill` until the asset is added |
| Title | "Office for Student Discipline", `.title3` semibold, `osdaHeading`, centered, 16 pt below logo |
| Subtitle | "Sign in with your Student ID", `.subheadline`, `osdaMuted`, 4 pt below title |
| Student ID label | "STUDENT ID *", `.caption` semibold, `osdaMuted`, 24 pt below subtitle |
| Student ID field | Height 52, radius 12, border `osdaBorder` (focused: `osdaPrimary`, 1.5 pt); no autocorrect, no auto-capitalization, keyboard `.asciiCapable`, return key "Next" |
| Password label | "PASSWORD *", 16 pt below the field |
| Password field | Same style; secure entry; trailing eye button (`eye` / `eye.slash`) toggles visibility; return key "Go" submits |
| Error text | `.footnote`, red (`osdaError`), under the password field, multi-line |
| Sign In button | Full width, height 52, radius 12, `osdaPrimary` fill, white `.headline` text "Sign In"; 20 pt below the fields |

## 3. States

| State | Behavior |
| --- | --- |
| Idle | Button enabled |
| Empty field on submit | Error: "Student ID and password are required." |
| Loading | Button shows a spinner and "Signing in...", fields and button disabled |
| Wrong password | Show the server message, e.g. "Invalid username or password. Attempt 1 of 5." |
| Locked or inactive | Show the server message: "Proceed to prefect office to request for account reactivation" |
| No internet / timeout | "Can't reach the server. Check your internet connection and try again." |
| Non-student account | "This app is for students. Please use the web or desktop app." |
| Typing after an error | Error clears |

## 4. Interactions

- "Next" on Student ID moves focus to Password; "Go" on Password submits.
- Tapping outside the fields dismisses the keyboard.
- On success, the app replaces Login with the main screen (no back navigation to Login).

## 5. Accessibility

- VoiceOver: fields labeled "Student ID" and "Password"; eye button "Show password" / "Hide password"; errors announced when they appear.
- Tap targets at least 44 × 44 pt (the eye button included).
- Supports Dynamic Type up to accessibility sizes; the card scrolls instead of clipping.
- Contrast: white on `#14123A` passes WCAG AA; muted text `#6D6D7F` on white passes AA for normal text.
- Dark mode uses the dark palette.

## 6. iOS differences from Android

- Uses the iOS keyboard "Next/Go" flow and `.textContentType(.username/.password)` so iCloud Keychain can fill saved passwords.
- No floating menu button on Login (the Android screenshot shows one; it is not needed here).

## Developer checklist

- [ ] All copy matches this spec
- [ ] Loading, error and empty states implemented
- [ ] Show/hide password works and is accessible
- [ ] Keyboard Next/Go flow
- [ ] Works in dark mode and at the largest text size
