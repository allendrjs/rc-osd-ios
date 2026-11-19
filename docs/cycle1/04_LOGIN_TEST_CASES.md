# Test Cases: Screen 1, Login (iOS)

Role: QA Tester. Use the local test database (every account's password is `1234`, the backend runs on `localhost:8080`) or test accounts on the live server. Never use real student accounts.

| ID | Feature | Preconditions | Steps | Test data | Expected result | Priority | ISO 9126 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| IOS-LGN-01 | Successful login | Backend running | Enter ID and password, tap Sign In | CT23-0002 / 1234 | "Signing in..." shows, then the Dashboard placeholder shows the student's name and section | High | Functionality |
| IOS-LGN-02 | Empty fields | App on Login | Tap Sign In with both fields empty | none | "Student ID and password are required." No request is sent | High | Functionality |
| IOS-LGN-03 | Wrong password counter | Account unlocked | Enter a wrong password once | CT23-0003 / wrong | "Invalid username or password. Attempt 1 of 5." | High | Functionality |
| IOS-LGN-04 | Lockout | Same account | Enter a wrong password 5 times | CT23-0003 / wrong | After the 5th try: "Proceed to prefect office to request for account reactivation" | High | Reliability |
| IOS-LGN-05 | Locked account, correct password | Account from 04 still locked | Enter the correct password | CT23-0003 / 1234 | Same office message; no attempt counter | High | Functionality |
| IOS-LGN-06 | Reactivated account | Admin reactivated it on the web | Log in with the surname password | CT23-0003 / surname | Login succeeds | Medium | Functionality |
| IOS-LGN-07 | Staff account blocked | none | Log in as staff | prefect / 1234 | "This app is for students. Please use the web or desktop app." | Medium | Functionality |
| IOS-LGN-08 | No internet | Wi-Fi off / airplane mode | Tap Sign In | CT23-0002 / 1234 | "Can't reach the server. Check your internet connection and try again." | High | Reliability |
| IOS-LGN-09 | Slow network | Network Link Conditioner "3G" | Log in | CT23-0002 / 1234 | Spinner stays visible, the button can't be tapped twice, login completes | Medium | Efficiency |
| IOS-LGN-10 | Stay signed in | Logged in | Kill the app and reopen it | none | Opens on the Dashboard placeholder without logging in | High | Reliability |
| IOS-LGN-11 | Logout | Logged in | Tap Log Out, then Cancel; tap Log Out, then Log Out | none | Cancel stays signed in; confirming returns to Login, and reopening the app shows Login | High | Functionality |
| IOS-LGN-12 | Show/hide password | Password typed | Tap the eye icon twice | any | The password becomes visible, then hidden again; VoiceOver reads "Show password" / "Hide password" | Medium | Usability |
| IOS-LGN-13 | Keyboard flow | App on Login | Type ID, press Next, type password, press Go | CT23-0002 / 1234 | Focus moves to Password; Go signs in | Low | Usability |
| IOS-LGN-14 | Error clears on typing | An error is shown | Type in either field | any | The error disappears | Low | Usability |
| IOS-LGN-15 | Dark mode | Settings > Display > Dark | Open Login | none | Dark colors, all text readable | Medium | Usability |
| IOS-LGN-16 | Largest text size | Settings > Accessibility > Larger Text max | Open Login | none | Text grows, the card scrolls, nothing is cut off | Medium | Usability |
| IOS-LGN-17 | Small and large iPhone | Simulators: iPhone SE and iPhone Pro Max | Open Login and log in | CT23-0002 / 1234 | Layout fits both; button fully visible with the keyboard open | Medium | Portability |
| IOS-LGN-18 | Background interruption | Login in progress | Send the app to background during sign-in, then return | CT23-0002 / 1234 | No crash; either logged in or a clear error | Low | Reliability |
| IOS-LGN-19 | Parity with Android | Same account on both apps | Repeat 03 and 04 on Android | CT23-0004 / wrong | Same messages on both apps | Medium | Functionality |

Bug report template (for results):

| Title | Severity | Device + iOS | Steps | Expected | Actual | Owner |
| --- | --- | --- | --- | --- | --- | --- |
