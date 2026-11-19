# RC-OSD iOS

iPhone version of the RC-OSD student app (Swift, SwiftUI, iOS 16+). It uses the same backend as the Android app; the backend is not changed.

Status: **All screens written (cycles 1–6)**: Login, Dashboard, Records, Offense Details, Appeal (file, list, edit, attachments), Chat (with guided appeal), Handbook, Profile with dark mode. The code was written on Windows and has **not been compiled yet**. Next step: first build and full test round on a Mac (see `docs/cycle6/03_CODE_REVIEW.md`).

## Requirements

- A Mac with Xcode 15 or newer
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- The backend running locally on port 8080 for Debug builds (see the team setup guide)

## Run it

```bash
cd rc-osd-ios
xcodegen generate        # creates RCOSD.xcodeproj from project.yml
open RCOSD.xcodeproj
```

In Xcode, choose an iPhone simulator and press Run. Test login: `CT23-0002` / `1234` on the local test database.

The simulator shares the Mac's network, so `http://localhost:8080` reaches a backend running on the same Mac. To test on a real iPhone against a local backend, change `API_BASE_URL` for Debug in `project.yml` to the Mac's Wi-Fi IP (for example `http://192.168.1.10:8080`).

**Without XcodeGen:** create a new iOS App project named `RCOSD` (SwiftUI, Swift) in Xcode, delete its generated Swift files, drag the `RCOSD` folder in, and copy the Info.plist keys from `project.yml`.

Windows teammates can edit the Swift files in VS Code and push to Git; building and running needs the Mac.

## Structure

```
RCOSD/
  App/            app entry, session, root view
  Core/Config     base URL and timeouts
  Core/Networking API client and error handling
  Core/Storage    Keychain token storage
  Core/Util       date formatting (MM/dd/yyyy)
  Models/         Codable models matching the backend
  Features/       one folder per screen (View + ViewModel)
  Shared/Theme    brand colors (light and dark)
docs/
  AI_ROLE_PROMPTS.md   prompts for Designer, Developer, Reviewer, Tester, Ticket Writer
  cycle1/              plan, design spec, code review, test cases, tickets
```
