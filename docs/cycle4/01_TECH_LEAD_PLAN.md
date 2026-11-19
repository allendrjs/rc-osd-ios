# Cycle 4 Plan: Screen 5 (Appeal: file, list, edit, attachments)

Role: Tech Lead. Goal: students can file an appeal with an optional letter, see all appeals, and edit pending ones, with the same rules and messages as Android.

| # | Task | Owner | Acceptance criteria | Depends on |
| --- | --- | --- | --- | --- |
| 1 | Multipart upload in APIClient | Developer | `upload(...)` sends one file as multipart "file"; same error handling and token refresh as JSON calls | Cycle 1 |
| 2 | Attachment helpers | Developer | Camera, Photo Library and Files pickers; images resized to 1500 px and saved as JPEG 0.8; PDF/Word allowed | none |
| 3 | Appeal service | Developer | Submit (POST /api/appeals), update (PUT /api/appeals/{id}), upload letter (POST /api/documents/upload) | 1 |
| 4 | Design spec | Designer | File Appeal, My Appeals and Edit specs | none |
| 5 | File a New Appeal screen | Developer | Message (required), attachment, upload guard, "Submit this appeal?" dialog, success message, return to the offense | 2, 3, 4 |
| 6 | My Appeals tab | Developer | Counts, filter, appeal cards, Edit appeal for Pending only, Edited label | 3, 4 |
| 7 | Review, tests, tickets | Reviewer, Tester, Ticket Writer | Files 03–05 | 5, 6 |
