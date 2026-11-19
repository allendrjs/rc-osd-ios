# Design Spec: Screen 5, Appeal

Role: UI/UX Designer.

## File a New Appeal (pushed from Offense Details)

| Element | Details |
| --- | --- |
| Title | "File a New Appeal" (inline) |
| Subtitle | "Request a review of an offense on your record" |
| Offense card | "Offense" label, then "{offense name} • {MM/dd/yyyy · h:mm a}" |
| Message | Label "Message *"; multi-line field, min height 120, placeholder "Explain why you're appealing this offense..." |
| Attachment | "Attach Appeal Letter (optional)". Two buttons: "Take Photo" and "Choose File" (menu: Photo Library / Files). After picking: file name, status ("Uploading..." / "Uploaded" / "Not uploaded") and "Remove" |
| Unclear file note | Amber: "We couldn't clearly read this file. You can still submit, but consider retaking the photo or choosing a clearer copy." |
| Error line | Red, above the button |
| Submit button | "Submit Appeal" / "Submitting..." |
| Confirm dialog | Title "Submit this appeal?", message "You can still edit it while it is pending.", buttons Cancel / Submit |
| Success | Green: "Appeal submitted successfully. Returning to the offense...", then back to the offense after about 1 second |

Validation messages, checked in this order:

1. "Please select which offense you're appealing."
2. "You already have an appeal on file for this offense."
3. "Please enter a message explaining your appeal."
4. "Please wait for your file to finish uploading."
5. "Your attached file did not upload. Remove it or attach it again before submitting."
6. "Couldn't determine your current enrollment. Please try again later."

## My Appeals (Appeal tab)

| Element | Details |
| --- | --- |
| Title | "My Appeals"; subtitle "Create and file offense appeals" |
| Counts | Total Filed, Pending (amber), Approved (green), Denied (red) |
| Filter | All / Pending / Approved / Denied |
| Appeal card | "APPEAL ID: AP-0007" + status pill; offense name; "Reason:" + message; "Edited" label if edited; "Edit appeal" button (Pending only); "Submitted {date-time}"; "Date of Resolution: …" or "Not yet resolved"; "Remarks: …" when present |
| Empty | "No appeals to show." |
| Hint | "To file a new appeal, open an offense in the Offenses tab" (opens the Offenses tab) |

## Edit appeal (sheet)

Title "Edit appeal"; the offense name; a message editor; Cancel and Save (spinner while saving). An empty message shows "Appeal message is required." Saving unchanged text just closes the sheet.

## iOS differences from Android

- "Choose File" offers both Photo Library and Files, because iOS keeps photos and files in separate places.
- On a device without a camera (the Simulator), Take Photo explains "This device has no camera. Use Choose File instead."
