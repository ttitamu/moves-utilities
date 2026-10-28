# Adding News and Release Notes

This page is for the MOVES Utilities project team at the Texas A&M Transportation Institute, who publish to this site. Each change takes three steps. The site rebuilds when the change reaches the `main` branch.

## Add a news post

1. Copy `news/_template.md` to a new file in `news/`. Name it after the topic, for example `news/moves6-support-status.md`. Do not start the name with `_`.
2. Fill in `title`, `date` (YYYY-MM-DD), `description`, and `categories`. Replace the example sentences below the front matter with the post. The comment lines that start with `#` are not published. Keep `draft: true` for now.
3. Open a pull request. After the project team approves the text, delete `draft: true` and merge.

## Add a release note

Release notes and their news posts are normally created by the release script. Use these steps to write one by hand.

1. Copy `releases/_template.md` to `releases/X.Y.Z.md`. Fill in every field, including **Results impact**.
2. Update `_variables.yml`: `latest.version`, `latest.date`, `latest.notes`, and the `conformity` download URL, file name, size, and SHA-256. The **Current** row of the **Version support status** table on `releases/index.qmd` follows `_variables.yml`. Add a row below it for the previous version with its new status (**Limited use** or **Retired**).
3. Copy `news/_release-announcement-template.md` to `news/release-X.Y.Z.md` and replace each `{{PLACEHOLDER}}`. Open one pull request with all changes. Merge after approval.

The site build fails if a published page still contains template text (`X.Y.Z`, `YYYY-MM-DD`, `{{PLACEHOLDER}}`). Builds that deploy the site also fail on any `TODO(owner)` marker. Drafts are not checked.

## Update a known issue

Edit `known-issues.qmd`. Add a section with the next ID and a row in the summary table. When a fix ships, set the status to **Fixed** and fill in **Fixed in**. Do not delete fixed entries.

## Writing rules

- Use short declarative sentences with dates and version numbers.
- Say whether results change. Say what the reader has to do.
- Do not use promotional words such as "seamless", "robust", "powerful", or "streamline".
- Do not include server names, database names, storage URLs, credentials, local file paths, SharePoint links, or staff GitHub user names.
- Do not paste commit messages. Describe the change as the user sees it.
