---
# Copy this file and name the copy after the version, for example 0.6.0.md.
# Do not start the name with "_".
# Delete "draft: true" when the project team approves the text.

title: "X.Y.Z"
date: YYYY-MM-DD
release-type: "Patch"        # Major, Minor, or Patch
results-impact: "No change"  # "No change", or a short phrase such as "Changes inventory totals"
draft: true
#
# Rules for release notes:
# - Write for analysts who use the tool. Describe what changed in the application,
#   not how the code changed.
# - One change per bullet. Start each bullet with a verb: Added, Changed, Fixed, Removed.
# - Never paste commit messages. Never include server names, database names,
#   storage URLs, credentials, file paths, SharePoint links, or staff GitHub user names.
# - Delete any section below that has no entries, except Results impact,
#   Known issues, and Compatibility.
# - Replace every example sentence below the front matter. The site build fails
#   if X.Y.Z, YYYY-MM-DD, or other template text is left in a published page.
---

| Item | Value |
|---|---|
| Version | X.Y.Z |
| Release date | YYYY-MM-DD |
| Type | Patch |
| Installer | `MOVESConformityUtils_Setup_X.Y.Z.exe` |
| SHA-256 | `paste hash here` |

## Results impact

State one of these:

- This version does not change computed emission rates or inventories.
- This version changes [which outputs] for [which inputs]. Rerun [which step] if [condition].

## Changes

### Emission Rate workflow

- Fixed ...

### Emission Inventory workflow

- Changed ...

### Post-Processing workflow

- Added ...

### Application and installer

- Changed ...

## Known issues

- None known at release.

List new issues by ID with a link to [Known issues](../known-issues.qmd#ki-nnn).

## Compatibility

| Item | Value |
|---|---|
| MOVES versions | List the MOVES versions this release supports. |
| Upgrade | Install over the earlier version. State whether existing project files need changes. |

See [Compatibility](../compatibility.qmd).
