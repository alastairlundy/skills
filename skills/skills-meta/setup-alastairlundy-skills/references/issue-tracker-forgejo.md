# Issue tracker: Forgejo

Issues and PRDs for this repo live as Forgejo issues. Use the Forgejo REST API for all operations. This template applies to Codeberg (a Forgejo instance) and any other Forgejo-based host.

## Conventions

- **Create an issue**: `POST /api/v1/repos/<owner>/<repo>/issues` with JSON body `{"title": "...", "body": "..."}`
- **Read an issue**: `GET /api/v1/repos/<owner>/<repo>/issues/<number>` (comments: `GET .../issues/<number>/comments`)
- **List issues**: `GET /api/v1/repos/<owner>/<repo>/issues?type=issues&state=open` with `&labels=<id>` filters
- **Comment on an issue**: `POST /api/v1/repos/<owner>/<repo>/issues/<number>/comments` with JSON body `{"body": "..."}`
- **Apply / remove labels**: `POST /api/v1/repos/<owner>/<repo>/issues/<number>/labels` with `{"labels": [<id>]}` / `DELETE` with same path
- **Close**: `PATCH /api/v1/repos/<owner>/<repo>/issues/<number>` with `{"state": "closed"}`

Authenticate with a Forgejo API token passed as `Authorization: token <token>` header. Infer the owner and repo from `git remote -v`.

<!-- Host-specific note: if the user named a specific Forgejo-based host (e.g. Codeberg), insert the base URL here, e.g. "Base URL: https://codeberg.org/api/v1" -->

<!-- PR-as-issue-surface: insert one of the following lines into this section, or omit entirely -->
<!-- If user answered yes:  "- **Pull requests as issue surface**: PRs in this repo are treated as an issue surface. Skills that publish to the issue tracker may open a PR instead of (or in addition to) an issue." -->
<!-- If user answered no or skipped: no line needed — this is the default. -->

## When a skill says "publish to the issue tracker"

Create a Forgejo issue via the REST API.

## When a skill says "fetch the relevant ticket"

Run `GET /api/v1/repos/<owner>/<repo>/issues/<number>` against the Forgejo instance.
