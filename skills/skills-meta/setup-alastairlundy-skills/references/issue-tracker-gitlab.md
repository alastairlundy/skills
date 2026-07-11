# Issue tracker: GitLab

Issues and PRDs for this repo live as GitLab issues. Use the `glab` CLI for all operations.

## Conventions

- **Create an issue**: `glab issue create --title "..." --description "..."`
- **Read an issue**: `glab issue view <number> --comments`
- **List issues**: `glab issue list --state opened --output json` with appropriate `--label` filters.
- **Comment on an issue**: `glab issue note <number> --message "..."`
- **Apply / remove labels**: `glab issue update <number> --label "..."` / `--unlabel "..."`
- **Close**: `glab issue update <number> --close`

Infer the project from `git remote -v` — `glab` resolves the project automatically when run inside a clone.

<!-- PR-as-issue-surface: insert one of the following lines into this section, or omit entirely -->
<!-- If user answered yes:  "- **Merge requests as issue surface**: Merge requests in this repo are treated as an issue surface. Skills that publish to the issue tracker may open a merge request instead of (or in addition to) an issue." -->
<!-- If user answered no or skipped: no line needed — this is the default. -->

## When a skill says "publish to the issue tracker"

Create a GitLab issue.

## When a skill says "fetch the relevant ticket"

Run `glab issue view <number> --comments`.
