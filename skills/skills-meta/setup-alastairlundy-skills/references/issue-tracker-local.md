# Issue tracker: Local Markdown

Issues and PRDs for this repo live as Markdown files under `.scratch/` in this repo. No external issue tracker is used.

## Conventions

- **Create an issue**: Write a new Markdown file under `.scratch/<feature-or-topic>/`. The filename is the issue title (slugified); the file body is the issue description.
- **Read an issue**: Read the Markdown file. Comments are appended as dated sections at the bottom of the same file.
- **List issues**: `ls .scratch/` to list feature directories; `ls .scratch/<feature>/` to list issues within a feature.
- **Comment on an issue**: Append a dated `## Comment — <date>` section to the existing Markdown file.
- **Apply / remove labels**: Add or remove a YAML front-matter `labels:` array in the issue file.
- **Close**: Add `status: closed` to the file's YAML front-matter.

Directory structure:

```
.scratch/
├── <feature-or-topic>/
│   ├── <issue-slug>.md
│   ├── <issue-slug>.md
│   └── ...
└── ...
```

Each issue file has the following front-matter:

```yaml
---
title: <issue title>
status: <open|closed>
labels: [<label-1>, <label-2>]
created: <ISO 8601 date>
---
```

## When a skill says "publish to the issue tracker"

Create a new Markdown file under `.scratch/<feature-or-topic>/`.

## When a skill says "fetch the relevant ticket"

Read the Markdown file at the path the skill specifies.
