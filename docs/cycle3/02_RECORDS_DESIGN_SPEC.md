# Design Spec: Screens 3–4, Records + Offense Details

Role: UI/UX Designer.

## Records (Offenses tab)

Purpose: the student sees every offense on their record and opens one.

| Element | Details |
| --- | --- |
| Title | "My Disciplinary Records" (inline) |
| Subtitle | "Track and view all logged offenses", `.subheadline` muted |
| Summary cards | Total (heading color), Active (amber), Resolved (green) |
| Filter | Segmented control: All / Active / Resolved |
| Offense card | Row 1: "OFFENSE ID: OF-0012" (caption, muted) and the status pill. Row 2: offense name (bold). "Filed: MM/dd/yyyy · h:mm a". "Resolved: …" only when resolved |
| Empty | "No offenses on file." |
| Error (first load) | Server message and Retry |

Active = PENDING or PROCESSING. Resolved = APPROVED or RESOLVED. Status pill colors: Resolved/Approved green, Processing blue, Pending amber.

## Offense Details

| Element | Details |
| --- | --- |
| Title | "Offense Details" (inline, back button) |
| Header card | "OFFENSE ID: OF-0012" + status pill; offense name `.title2` bold |
| Details card | Type ("Not on file"), Date of Violation, Date of Resolution ("Not yet resolved"), Reported By ("Not on file"), Status |
| Disciplinary Action card | Action name, or remarks, or "No action recorded yet." |
| Bottom button | "File an Appeal" (full width, primary). Disabled at 35% opacity when appeals aren't allowed |
| Blocked message | PROCESSING or already appealed: "This offense is already under appeal review." Approved/Resolved: "This offense is {status} and can no longer be appealed." |
| Not found | "This offense couldn't be found." |

Accessibility: each card and detail row is read as one element; the button is disabled (not hidden) so VoiceOver explains it; Dynamic Type supported.

## Developer checklist

- [ ] Filters and counts follow the Active/Resolved rules above
- [ ] Newest offense first
- [ ] File an Appeal is enabled only for PENDING offenses with no appeal yet
- [ ] Blocked messages match exactly
