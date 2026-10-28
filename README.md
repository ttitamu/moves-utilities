# MOVES Utilities website

Source for <https://ttitamu.github.io/moves-utilities/>: releases, release notes, news, known issues, and MOVES compatibility for MOVES Utilities. The site is built with [Quarto](https://quarto.org) and published to GitHub Pages by `.github/workflows/publish.yml` on every push to `main`.

## Add news or a release note

Step-by-step instructions and writing rules: [CONTRIBUTING-NEWS.md](CONTRIBUTING-NEWS.md).

- **News:** copy `news/_template.md` to `news/<topic>.md`, fill in the front matter, write the post. It appears on the News page, in the home page list, and in the RSS feed (`news/index.xml`).
- **Release note:** copy `releases/_template.md` to `releases/X.Y.Z.md`. Update `_variables.yml` (version, date, download URL, file name, size, SHA-256) in the same pull request.
- **Release announcements** are created by the release pipeline from `news/_release-announcement-template.md` (category `release`).
- Keep `draft: true` until the text is approved. Drafts are not published, listed, searched, or included in the feed.
- Files whose names start with `_` are templates. Quarto never renders or lists them. Do not rename them.

## Preview locally

Requires Quarto 1.8 or later.

```sh
quarto preview                  # published view: drafts hidden
quarto preview --profile review # review view: drafts shown
```

`quarto render` writes the site to `_site/` (the review profile writes `.site-review/`). Neither folder is committed.

## Layout

| Path | Contents |
|---|---|
| `_quarto.yml` | Site settings, navigation, footer, feed |
| `_variables.yml` | Current version, date, download URL, checksum, contact link. Pages read it with `{{< var >}}` |
| `index.qmd`, `about.qmd`, `compatibility.qmd`, `known-issues.qmd` | Site pages |
| `news/`, `releases/` | News posts and release notes, one Markdown file each |
| `design/theme.scss` | Visual theme. `design/site.scss` holds additions for site-specific markup |
| `_filters/mu.lua` | Table accessibility (header scope, scroll regions), status labels, TODO markers |
| `_includes/` | Skip link, navbar adjustments, head tags |
| `_scripts/check-placeholders.lua` | Post-render check: fails the build on template text, and on `TODO(owner)` in deploy builds |
| `assets/fonts/` | Self-hosted Public Sans (SIL Open Font License 1.1, see `assets/fonts/OFL.txt`) |

## License

Copyright © 2026 Texas A&M Transportation Institute. All rights reserved. See [LICENSE](LICENSE). The Public Sans font files in `assets/fonts/` are under the SIL Open Font License 1.1 (`assets/fonts/OFL.txt`).
