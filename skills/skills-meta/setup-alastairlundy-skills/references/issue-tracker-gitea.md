# Issue tracker: Gitea

Issues and PRDs for this repo live as Gitea issues. Use the `tea` CLI or the Gitea REST API for all operations.

## Conventions

- **Create an issue**: `tea issues create --repo <owner>/<repo> --title "..." --description "..."`
- **Read an issue**: `tea issues view --repo <owner>/<repo> <number>`
- **List issues**: `tea issues list --repo <owner>/<repo> --state open` with appropriate `--label` filters.
- **Comment on an issue**: `tea issues comments create --repo <owner>/<repo> <number> --body "..."`
- **Apply / remove labels**: `tea issues labels add --repo <owner>/<repo> <number> <label-id>` / `tea issues labels remove --repo <owner>/<repo> <number> <label-id>`
- **Close**: `tea issues update --repo <owner>/<repo> <number> --state closed`

Alternatively, use the Gitea REST API directly via `curl`:

- **Create**: `POST /api/v1/repos/<owner>/<repo>/issues`
- **Read**: `GET /api/v1/repos/<owner>/<repo>/issues/<number>` (comments: `GET .../issues/<number>/comments`)
- **List**: `GET /api/v1/repos/<owner>/<repo>/issues?type=issues&state=open`
- **Comment**: `POST /api/v1/repos/<owner>/<repo>/issues/<number>/comments`
- **Labels**: `POST /api/v1/repos/<owner>/<repo>/issues/<number>/labels` (body: `{"labels": [<id>]}`) / `DELETE` with same path
- **Close**: `PATCH /api/v1/repos/<owner>/<repo>/issues/<number>` with `{"state": "closed"}`

Infer the owner and repo from `git remote -v`.

<!-- PR-as-issue-surface: insert one of the following lines into this section, or omit entirely -->
<!-- If user answered yes:  "- **Pull requests as issue surface**: PRs in this repo are treated as an issue surface. Skills that publish to the issue tracker may open a PR instead of (or in addition to) an issue." -->
<!-- If user answered no or skipped: no line needed — this is the default. -->

## When a skill says "publish to the issue tracker"

Create a Gitea issue.

## When a skill says "fetch the relevant ticket"

Run `tea issues view --repo <owner>/<repo> <number>` or `GET /api/v1/repos/<owner>/<repo>/issues/<number>`.
