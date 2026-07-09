---
name: setup-alastairlundy-skills
description: >-
  Configures a host repository to use the alastairlundy AI-agent skill
  family by writing four agent-consumable docs (issue-tracker,
  triage-labels, domain/GLOSSARY, decision-ledger-audit) and adding the
  `## Agent skills` block to AGENTS.md or CLAUDE.md. Use when setting
  up a new repo for AI agents, switching the repo's issue tracker, or
  re-running after a config change.
license: MIT
---

# Setup Alastairlundy Skills

Scaffolds the per-repo configuration that the alastairlundy AI-agent skill family assumes. Produces four `docs/agents/*.md` files plus an in-place `## Agent skills` block in the host repo's `AGENTS.md` (or `CLAUDE.md`).

The skill is a fork of `setup-matt-pocock-skills`, adapted to this repo's requirements — extended with multi-host support and a decision-ledger-audit section.

## When to Use

- When the user wants to set up a new host repository to use the alastairlundy AI-agent skill family.
- When the user wants to switch the host repository's issue tracker (e.g., GitHub → Gitea, GitLab → Local Markdown, or any host → Other non git workflow).
- When the user wants to re-run setup after a config change (new triage labels, new domain layout, new decision-ledger convention, or a new host).
- When the user must pick between issue-tracker variants, Git Host sub-options, domain layout (single- vs multi-context), or label-mapping overrides, invoke the `ask-questions` skill to surface the choice before proceeding.

## When Not to Use

- When the user is mid-task and does not want to be interrupted — this skill writes files to the host repo and is best run as a discrete work item.

## Output Mode

- Default behaviour is **file-writing**: the skill writes four `docs/agents/*.md` files and updates the `## Agent skills` block in the host repo's `AGENTS.md` (or `CLAUDE.md` if `AGENTS.md` does not exist).
- The Confirm step (Step 6) is the **per-file opt-out**: the user can decline any individual file before it is written.
- No top-level dry-run flag, no preview mode. The Confirm step is the only safety net.
- The skill does not overwrite user edits to sections of `AGENTS.md` / `CLAUDE.md` that are outside the `## Agent skills` block.

## Workflow

### Step 1: Explore

Run `git status` and `git log --oneline -10` in the host repo to confirm a clean working tree and to inspect recent commit style. Probe the host repo's starting state — read whatever exists; do not assume:

- `git remote -v` and `.git/config` — is this a GitHub, GitLab, Gitea, Codeberg, or other-host repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `GLOSSARY.md` and `GLOSSARY-MAP.md` at the repo root (the new naming; `CONTEXT.md` is the legacy name from before the rename).
- `docs/adr/` and any `src/*/docs/adr/` directories.
- `docs/agents/` — does this skill's prior output already exist?
- `.scratch/` — sign that a local-markdown issue tracker convention is already in use.

Completion criterion: a clean working tree is reported, and the presence/absence of `AGENTS.md`, `CLAUDE.md`, the `## Agent skills` block, and the prior `docs/agents/*.md` outputs is recorded.

### Step 2: Present issue tracker (with PR follow-up)

Invoke the `ask-questions` skill to present three top-level variants:

- **Git Host** — issues live on a Git host's native issue tracker
- **Local Markdown files** — issues live as files under `.scratch/<feature>/` in this repo
- **Other non git workflow** — issues live in a non-git system the user describes in prose

Sub-rules for the **Git Host** pick:

- Ask a follow-up to pick the exact host from {GitHub, GitLab, Gitea, Codeberg} or specify a user-defined host. If the user names a Forgejo-based host (self-hosted Codeberg, self-hosted Forgejo, a non-profit Forgejo instance), resolve to the **Forgejo** seed template — `issue-tracker-forgejo.md` is the shared file for Codeberg and all Forgejo-based hosts (Codeberg is a Forgejo instance, so the API and seed content are identical).
- After any Git Host pick, ask the PR-as-issue-surface follow-up (yes / no, default no). The answer is recorded as a one-line note in the `## Conventions` section of `docs/agents/issue-tracker.md`. Skip this question for Local Markdown and Other non git workflow.

Sub-rules for the **Other non git workflow** pick:

- Ask a follow-up for the user to describe the workflow in prose; the description is inlined verbatim into `docs/agents/issue-tracker.md`.

Load the matching seed template (load triggers below), fill in the user's answers, and present the proposed `docs/agents/issue-tracker.md`.

Completion criterion: a `docs/agents/issue-tracker.md` candidate is presented to the user, with the `## Conventions` and `## When a skill says` sections populated for the chosen variant, and the PR-as-issue-surface note recorded (Git Host variants only).

### Step 3: Present triage labels

Explain the five canonical roles:

- `needs-triage` — maintainer needs to evaluate
- `needs-info` — waiting on reporter
- `ready-for-agent` — fully specified, AFK-ready
- `ready-for-human` — needs human implementation
- `wontfix` — will not be actioned

Invoke the `ask-questions` skill to ask whether to override any role-to-label-string mapping. Load `references/triage-labels.md`, apply the user's overrides, and present the proposed `docs/agents/triage-labels.md`.

Completion criterion: a `docs/agents/triage-labels.md` candidate is presented to the user, with the five-row label-mapping table (or the user's overridden mapping) populated.

### Step 4: Present domain docs

Invoke the `ask-questions` skill to ask the user to pick the domain-docs layout:

- **Single-context** — one `GLOSSARY.md` at the repo root. Most repos are this.
- **Multi-context** — `GLOSSARY.md` (system-wide) + `GLOSSARY-MAP.md` at the root, pointing to per-context `GLOSSARY.md` files (typically a monorepo).

Load `references/domain.md` and fill in the chosen layout. The consumer rules in `docs/agents/domain.md` reference `GLOSSARY.md` (and `GLOSSARY-MAP.md` for multi-context), not the legacy `CONTEXT.md` name. Present the proposed `docs/agents/domain.md`.

Completion criterion: a `docs/agents/domain.md` candidate is presented to the user, with the consumer rules referencing `GLOSSARY.md` (not `CONTEXT.md`).

### Step 5: Present decision-ledger-audit

Load `references/decision-ledger-audit.md` and present the proposed `docs/agents/decision-ledger-audit.md`. The content is the canonical seed documenting the `filename#Dxxx` citation rule — bare `Dxxx` references are prohibited.

Completion criterion: a `docs/agents/decision-ledger-audit.md` candidate is presented to the user.

### Step 6: Confirm

Present the four candidates from Steps 2-5 in a single summary table. For each file, the user accepts or declines. Declined files are not written in Step 7. The `## Agent skills` block (Step 7) is included in the summary as a fifth item with the same accept/decline treatment — if declined, only the four `docs/agents/*.md` files are written.

Completion criterion: each of the four candidates (plus the `## Agent skills` block) has an explicit accept/decline from the user; the accepted list is recorded.

### Step 7: Write

For each accepted file, write it to the host repo:

- Write `docs/agents/issue-tracker.md` (if accepted).
- Write `docs/agents/triage-labels.md` (if accepted).
- Write `docs/agents/domain.md` (if accepted).
- Write `docs/agents/decision-ledger-audit.md` (if accepted).

For the `## Agent skills` block (if accepted):

- Choose `AGENTS.md` if it exists, `CLAUDE.md` if it exists, or ask the user if neither exists. Never create `AGENTS.md` when `CLAUDE.md` exists or vice versa.
- Update the `## Agent skills` block in-place using a **parse-the-block** approach: find the `## Agent skills` heading, find the next `##` heading at the same level, replace the content between them. If the block does not exist, append it. Do not overwrite user edits to surrounding sections.
- The block has three subsections (Issue tracker, Triage labels, Domain docs) with one-line summaries pointing to the corresponding `docs/agents/*.md` files:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked, plus the PR-as-issue-surface note for Git Host variants]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

Completion criterion: every accepted file is written; the `## Agent skills` block is updated; `git status` shows only the expected changes; surrounding user content in `AGENTS.md` / `CLAUDE.md` is preserved.

### Step 8: Done

Report the following four components:

- (a) **Confirmation** that the four `docs/agents/*.md` files were written (or skipped, per Step 6 declines) and the `## Agent skills` block was updated.
- (b) **Skill mapping** — a small table mapping each `docs/agents/*.md` file to the skills that read it (e.g., `issue-tracker.md` ← `triage`, `domain.md` ← `domain-grilling`, `decision-ledger-audit.md` ← `grilling` / `dependency-review`).
- (c) **Edit-directly note** — "you can edit any of these files directly; the in-place update logic preserves your changes on re-run".
- (d) **Re-run note** — "re-run this skill to switch issue trackers, update triage labels, or change the domain-docs layout".

Completion criterion: the user has a complete summary of what was written, where, and what the file-to-skill mapping is.

## Validation

Do not mark the skill as complete until every item below passes.

- [ ] `docs/agents/issue-tracker.md` exists and contains the expected `## Conventions` and `## When a skill says` sections for the chosen variant (Git Host, Local Markdown, or Other non git workflow).
- [ ] For a Git Host variant, `docs/agents/issue-tracker.md` records the PR-as-issue-surface note (yes / no) in the `## Conventions` section.
- [ ] `docs/agents/triage-labels.md` exists and has 5 rows in the label-mapping table (or the user's overridden mapping).
- [ ] `docs/agents/domain.md` exists and references `GLOSSARY.md` (not `CONTEXT.md`) in its consumer rules; for multi-context, it also references `GLOSSARY-MAP.md`.
- [ ] `docs/agents/decision-ledger-audit.md` exists and contains the `filename#Dxxx` citation rule (bare `Dxxx` references prohibited).
- [ ] The `## Agent skills` block in `AGENTS.md` (or `CLAUDE.md`) references all four `docs/agents/*.md` files and uses the parse-the-block in-place update (no duplicate block).
- [ ] `git status` shows only the expected files; no surrounding user content in `AGENTS.md` / `CLAUDE.md` was overwritten.

## Reference files (load triggers)

Load each `references/*.md` file only when its load-trigger condition is met. Do not load all of them upfront.

- Before presenting an issue-tracker candidate, load the seed for the chosen variant:
  - `references/issue-tracker-github.md` — GitHub (uses `gh` CLI)
  - `references/issue-tracker-gitlab.md` — GitLab (uses `glab` CLI)
  - `references/issue-tracker-gitea.md` — Gitea (uses `tea` CLI or Gitea API)
  - `references/issue-tracker-forgejo.md` — Codeberg AND other Forgejo-based hosts (shared file — both use the Forgejo API; Codeberg is a Forgejo instance). When the user names a Forgejo-based host under "Other Git Host (User specified)", load this file.
  - `references/issue-tracker-other-git.md` — Other Git Host (User specified) for non-Forgejo hosts
  - `references/issue-tracker-local.md` — Local Markdown
  - `references/issue-tracker-other-nongit.md` — Other non git workflow (User specified)
- Before presenting a triage-labels candidate (Step 3), load `references/triage-labels.md`.
- Before presenting a domain-docs candidate (Step 4), load `references/domain.md`.
- Before presenting a decision-ledger-audit candidate (Step 5), load `references/decision-ledger-audit.md`.

## Attribution

Adapted from the `setup-matt-pocock-skills` skill in the [`mattpocock/skills`](https://github.com/mattpocock/skills) repository, licensed under MIT by Matt Pocock and Contributors. The issue-tracker, triage-labels, and domain-docs features are extended with multi-host support (Gitea, Codeberg, other Forgejo-based hosts, other Git hosts, and other non-git workflows) and a decision-ledger-audit section, per `docs/decisions/DECISIONS-skills-setup-skill-replace.md` (D001-D021). The `CONTEXT.md` → `GLOSSARY.md` rename is a project-local extension.
