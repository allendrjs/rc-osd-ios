# Code Review: Cycle 4 (Appeal)

Role: Code Reviewer. **Verdict: APPROVE WITH SMALL FIXES.** Not compiled yet (written on Windows).

| Severity | File | Problem | Fix (status) |
| --- | --- | --- | --- |
| Major | `Features/Appeal/FileAppealViewModel.swift` | Picking a second file while the first was still uploading could let the first upload's result win | Cancel the previous upload task on a new pick or Remove (fixed) |
| Major | `Core/Attachments/AttachmentFile.swift` | Files from the Files app need security-scoped access or reading fails on a real device | `startAccessingSecurityScopedResource` around the read (fixed) |
| Minor | `Core/Networking/APIClient.swift` | Quotes in a file name would break the multipart header | Quotes removed from the file name (fixed) |
| Minor | `Core/Attachments/AttachmentFile.swift` | Large photos from Files were uploaded uncompressed | Images from Files are compressed like camera photos (fixed) |
| Minor | `Features/Appeal/FileAppealView.swift` | The success message waits a fixed 1.2 s before going back | Same idea as Android; acceptable (accepted) |

Checked and correct:

- **Same rules as Android:** the validation order and texts match, edit is allowed only for PENDING appeals, the "Edited" label appears, and the confirm dialog text matches.
- **Upload guard:** Submit is blocked while uploading or when the upload failed, which is the bug fixed on Android in October.
- **Security:** files are only uploaded after the student picks them, and the token is added by `APIClient`.
- **Accessibility:** the message field is labeled as required, errors are announced, and tap targets are at least 44 pt.

To check on the first Mac build: Info.plist contains the camera and photo usage texts (from `project.yml`); `.photosPicker(isPresented:)` returns images on iOS 16; a PDF chosen in Files uploads with type `application/pdf`.
