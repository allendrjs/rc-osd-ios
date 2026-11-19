# Test Cases: Screen 5, Appeal (iOS)

Role: QA Tester. Test accounts only. Use a real iPhone for camera cases.

| ID | Feature | Steps | Expected result | Priority | ISO 9126 |
| --- | --- | --- | --- | --- | --- |
| IOS-APL-01 | Open form | Pending offense, then File an Appeal | Form shows the offense name and date | High | Functionality |
| IOS-APL-02 | Empty message | Tap Submit Appeal with no message | "Please enter a message explaining your appeal." | High | Functionality |
| IOS-APL-03 | Submit without a file | Type a message, Submit, then confirm Submit | Success message, back to the offense, status becomes Processing | High | Functionality |
| IOS-APL-04 | Confirm dialog cancel | Submit, then Cancel | Nothing sent; still on the form | Medium | Usability |
| IOS-APL-05 | Take Photo | Real iPhone: Take Photo, then use the photo | Shows "Uploading...", then "Uploaded"; the file is a small JPEG | High | Functionality |
| IOS-APL-06 | No camera | Simulator: Take Photo | "This device has no camera. Use Choose File instead." | Low | Usability |
| IOS-APL-07 | Choose from Photo Library | Choose File, then Photo Library | Image uploads and shows "Uploaded" | High | Functionality |
| IOS-APL-08 | Choose a PDF from Files | Choose File, then Files, pick a PDF | Uploads; the prefect can open it on the desktop app | High | Functionality |
| IOS-APL-09 | Submit while uploading | Attach a large file and tap Submit at once | "Please wait for your file to finish uploading." | High | Reliability |
| IOS-APL-10 | Failed upload | Turn off Wi-Fi during upload, then Submit | "Your attached file did not upload. Remove it or attach it again before submitting." | High | Reliability |
| IOS-APL-11 | Remove | Attach, then Remove | Attachment cleared; can attach again | Medium | Functionality |
| IOS-APL-12 | Unclear photo | Upload a blurry photo | Amber "We couldn't clearly read this file…" note | Low | Functionality |
| IOS-APL-13 | My Appeals counts | Open the Appeal tab | Total/Pending/Approved/Denied match Android | High | Functionality |
| IOS-APL-14 | Filters | Choose each filter | Only appeals with that status | Medium | Functionality |
| IOS-APL-15 | Denied appeal | View a denied appeal | Red status, "Date of Resolution" filled, "Remarks: …" shown | High | Functionality |
| IOS-APL-16 | Edit pending | Edit appeal, change the text, Save | Card updates and shows "Edited" | High | Functionality |
| IOS-APL-17 | Edit empty | Clear the text and Save | "Appeal message is required." | Medium | Functionality |
| IOS-APL-18 | No edit on decided | Look at an approved appeal | No Edit button | High | Functionality |
| IOS-APL-19 | Parity | File the same kind of appeal on Android and iOS | Same result on the desktop prefect screen | Medium | Functionality |
