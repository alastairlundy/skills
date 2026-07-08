# Decision Ledger — skills / setup-skill-replace

Topic: create a new setup skill in this repo to replace the dependency on
the global `setup-matt-pocock-skills` skill. Rename `CONTEXT.md` to
`GLOSSARY.md`. Repo self-sufficiency (skill lives in this repo, not in
`~/.agents/skills/`).

### [D001] — ledger path

- **Resolved Answer**: "Open a new ledger"
- **Normalized Requirement**: A new Decision Ledger shall exist at
  `docs/decisions/DECISIONS-skills-setup-skill-replace.md` and shall
  record every decision about the new setup skill from this session.
- **Constraints**: None. Two existing ledgers (`DECISIONS-skills-dependency-review.md`
  and `DECISIONS-calm-falcon-skill-architect-triage.md`) remain in
  place; cross-references use `filename#Dxxx` if needed.

### [D002] — skill name and category

- **Resolved Answer**: "Skill name: setup-alastairlundy-skills. Skill
  category: skills-meta."
- **Normalized Requirement**: The new setup skill shall live at
  `skills/skills-meta/setup-alastairlundy-skills/SKILL.md`. Its
  frontmatter `name` field shall be `setup-alastairlundy-skills`. The
  `skills-meta/` category is the agreed home per AGENTS.md
  ("creating/evaluating skills").
- **Constraints**: The skill is a fork of `setup-matt-pocock-skills`,
  **adapted to this repo and this repo's requirements** — not a 1:1
  fork-and-rename. The personal-reference pattern in the name is
  intentional disambiguation: it gives the skill a unique name against
  other potential setup skills other authors may create for their own
  skill repos (e.g., `setup-mattpocock-skills`, `setup-jane-doe-skills`).
  Going forward, "adapted to this repo" is the framing baseline for all
  feature-scope decisions in this session — the new skill does not have
  to mirror the old one and is free to diverge where this repo's
  requirements differ. **Process notes for the rest of this session:**
  (a) agent shall provide sufficient context on every branch open;
  (b) the context shall be placed *before* the question in the agent's
  turn, not interleaved with options; (c) one question/issue per turn.

### [D003] — issue-tracker feature scope

- **Resolved Answer**: "Full-scope. The user setting up the skills this
  repo provides are likely to use the skills in their own projects or
  for their own repos. It is therefore only fair that they should be
  given some degree of choice/configuration in the setup. A new variant
  should be added for Gitea, Codeberg, and Other Git Host (User
  specified)."
- **Normalized Requirement**: The new skill's issue-tracker setup shall
  support the **full variant set**: GitHub, GitLab, Gitea, Codeberg,
  Other Git Host (User specified), local-markdown, and Other (non-git
  e.g. Jira/Linear). The new variant introduced here is a
  self-hosted/alternative git host category that did not exist in the
  old skill; the old skill's "Other" (non-git) variant is retained.
- **Constraints**: The user's reasoning is that the skill is consumed
  by users setting up skills for their own projects/repos, and they
  should have configuration choice — the variant set is the
  alastairlundy opinion, not a constraint on what other authors'
  setup skills may pick. D003's wording is ambiguous on whether
  "Gitea, Codeberg, and Other Git Host (User specified)" is one
  variant with three sub-options or three separate top-level
  variants — clarification is the next branch (D004).

### [D004] — issue-tracker variant structure

- **Resolved Answer**: "I think the structure of the issue tracker
  options should be: Git Host (In the follow up, the User chooses
  what exact host from the current list or their own specified host),
  Local Markdown files, Other non git workflow (User specified as
  follow up)."
- **Normalized Requirement**: The new skill's issue-tracker setup shall
  present three top-level variants: **Git Host**, **Local Markdown
  files**, **Other non git workflow**. The Git Host choice shall
  trigger a follow-up question to pick the exact host from
  {GitHub, GitLab, Gitea, Codeberg} or specify a user-defined host.
  The Other non git workflow choice shall trigger a follow-up question
  for the user to describe their workflow in prose.
- **Constraints**: `Supersedes: D003`. The D003 seven-entry top-level
  variant list (GitHub, GitLab, Gitea, Codeberg, Other Git Host,
  local-markdown, Other) is replaced by this three-entry structure.
  The host list for the Git Host follow-up ({GitHub, GitLab, Gitea,
  Codeberg}) is inherited from D003; whether that list is the right
  one may be revisited as a separate branch.

### [D005] — triage-labels feature scope

- **Resolved Answer**: "Full scope"
- **Normalized Requirement**: The new skill's triage-labels setup shall
  explain the five canonical roles (`needs-triage`, `needs-info`,
  `ready-for-agent`, `ready-for-human`, `wontfix`) and shall ask the
  user to override any role-to-label-string mappings, then write
  `docs/agents/triage-labels.md` with the resulting table — same shape
  as the old skill.
- **Constraints**: None. The five canonical roles are inherited as a
  domain convention; no role-set change was proposed.

### [D006] — domain-docs feature scope, with rename

- **Resolved Answer**: "Full scope with consistent rename to
  GLOSSARY.md / GLOSSARY-MAP.md"
- **Normalized Requirement**: The new skill's domain-docs setup shall
  ask the user to pick single-context or multi-context. Single-context
  produces `GLOSSARY.md` at the repo root. Multi-context produces
  `GLOSSARY.md` (system-wide) + `GLOSSARY-MAP.md` (the map file at the
  root, pointing to per-context `GLOSSARY.md` files). The setup skill
  shall also write `docs/agents/domain.md` with the new file names
  (replacing the old `CONTEXT.md` / `CONTEXT-MAP.md` references in the
  consumer rules). The rename of `CONTEXT-MAP.md` → `GLOSSARY-MAP.md`
  is the consistent extension of the `CONTEXT.md` → `GLOSSARY.md`
  rename.
- **Constraints**: Migration of existing references in `spec-to-tickets`
  and `domain-grilling` (which currently read `CONTEXT.md` by name) is
  a follow-up work item, not part of this branch — the new skill's
  design is to produce `GLOSSARY.md`, and the existing skills'
  reference updates are tracked separately. The current
  `CONTEXT.md` file in this repo is already titled `# Glossary` in its
  heading; the rename is a file rename (and reference update), not a
  content rewrite.

### [D007] — `## Agent skills` block + AGENTS.md / CLAUDE.md handling

- **Resolved Answer**: "Keep full logic"
- **Normalized Requirement**: The new skill's write step shall (a) choose
  `AGENTS.md` if it exists, `CLAUDE.md` if it exists, or ask the user
  if neither exists; (b) never create `AGENTS.md` when `CLAUDE.md`
  exists or vice versa; (c) update the `## Agent skills` block in-place
  if it exists, creating it if not; (d) not overwrite user edits to
  surrounding sections. The block has the 3 subsections (Issue tracker,
  Triage labels, Domain docs) with one-line summaries pointing to the
  corresponding `docs/agents/*.md` files.
- **Constraints**: Implementation should use a parse-the-block approach
  (find the `## Agent skills` heading, find the next `##` heading at
  the same level, replace the content between them) rather than a
  regex approach. This is a spec-level requirement, not just a
  recommendation — regex-based block updaters are the most common
  source of "surrounding content got mangled" regressions.

### [D008] — Decision Ledger convention

- **Resolved Answer**: "Yes, full scope"
- **Normalized Requirement**: The new skill shall write
  `docs/agents/decision-ledger-audit.md` in the host repo, with the
  rule that Decision Ledger records must be cited as `filename#Dxxx`
  and bare `Dxxx` references are prohibited. The seed template is the
  current 22-line file at `docs/agents/decision-ledger-audit.md` in
  this repo.
- **Constraints**: None. The audit doc joins the other three
  `docs/agents/*.md` files (issue-tracker, triage-labels, domain) as
  part of the skill's standard output.

### [D009] — PR-as-issue-surface follow-up

- **Resolved Answer**: "Keep for all git host variants and the user
  specified sub-option"
- **Normalized Requirement**: After the user picks any Git Host
  sub-option (GitHub, GitLab, Gitea, Codeberg, or Other Git Host
  (User specified)), the new skill shall ask the PR-as-issue-surface
  follow-up question. The question is skipped for Local Markdown files
  and Other non git workflow variants. The seed template for
  `docs/agents/issue-tracker.md` shall record the answer as a
  one-line note in the Issue tracker summary.
- **Constraints**: The PR-as-issue-surface note in
  `docs/agents/issue-tracker.md` uses a boolean (the Git Host pick
  implies PRs are possible), not a three-valued enum. A user-specified
  Git Host that does not support PRs answers "no" and the question
  still applies.

### [D010] — workflow structure

- **Resolved Answer**: "Expand to 7 steps."
- **Normalized Requirement**: The new skill's workflow shall have
  7 steps, expanding on the old skill's 5-step structure. The exact
  7-step split is the next branch (D011).
- **Constraints**: The 7-step structure supersedes the old skill's
  5-step structure. The Explore, Confirm/Review, Write, and Done
  seams from the old skill are the natural places for the expansion;
  the exact split is decided in D011. `Superseded by D011` — the
  user later revised the count to 8 steps with all sub-steps split
  out and Done kept as a distinct final step.

### [D011] — workflow structure (8 steps)

- **Resolved Answer**: "Let's change it to 8 steps so that 'Done' is
  a separate step from Write, and Confirm is a separate step from
  Write." The user supplied the exact structure: 1. Explore,
  2. Present issue tracker (with PR follow-up), 3. Present triage
  labels, 4. Present domain docs, 5. Present decision-ledger-audit,
  6. Confirm, 7. Write, 8. Done.
- **Normalized Requirement**: The new skill's workflow shall have
  8 steps, with the Present step from the old skill split into 4
  sub-steps (one per section: issue tracker, triage labels, domain
  docs, decision-ledger-audit) and all other steps (Explore,
  Confirm, Write, Done) kept as distinct units. The PR-as-issue-
  surface follow-up (per D009) is bundled inside the Present issue
  tracker step, not promoted to its own step.
- **Constraints**: `Supersedes: D010`. The 8-step structure is the
  final count. The Present-issue-tracker step contains the
  PR-as-issue-surface follow-up as a sub-step (not a separate
  top-level step), so the 8-step count is fixed. A future contributor
  adding a 5th section to the Present phase would push the count
  past 8 and should justify the addition explicitly.

### [D012] — references/ folder structure

- **Resolved Answer**: "Option 1. CodeBerg and Forgejo based hosts
  should use 1 file for both."
- **Normalized Requirement**: The new skill's `references/` folder
  shall have one file per variant, with the following layout:
  - `issue-tracker-github.md` — GitHub (uses `gh` CLI)
  - `issue-tracker-gitlab.md` — GitLab (uses `glab` CLI)
  - `issue-tracker-gitea.md` — Gitea (uses `tea` CLI or Gitea API)
  - `issue-tracker-codeberg.md` — Codeberg AND other Forgejo-based
    hosts (shared file — both use the Forgejo API; Codeberg is a
    Forgejo instance, so the API and seed content are the same)
  - `issue-tracker-other-git.md` — Other Git Host (User specified)
  - `issue-tracker-local.md` — Local Markdown
  - `issue-tracker-other-nongit.md` — Other non git workflow
    (User specified)
  - `triage-labels.md` — single file
  - `domain.md` — single file covering single- and multi-context
  - `decision-ledger-audit.md` — single file

  Total: 10 files.
- **Constraints**: When the user picks "Other Git Host (User
  specified)" and names a Forgejo-based host (e.g., a self-hosted
  Codeberg, a self-hosted Forgejo instance), the skill's workflow
  shall resolve to `issue-tracker-codeberg.md` as the seed template.
  The skill's load-trigger sentences in `SKILL.md` shall document
  the "Codeberg covers Forgejo-based hosts" rule explicitly so a
  future contributor adding a new Forgejo-based host knows to reuse
  the Codeberg file rather than create a new one.

### [D013] — migration plan for CONTEXT.md → GLOSSARY.md

- **Resolved Answer**: "Track as separate work item"
- **Normalized Requirement**: The migration of existing `CONTEXT.md`
  references in this repo shall be tracked in the Decision Ledger
  as an **open follow-up** and shall not be done in this session.
  The migration is a separate work item with its own validation
  (re-run the eval suites for `spec-to-tickets` and
  `domain-grilling` after the migration to confirm no regressions).
- **Constraints**: The migration is a separate work item with the
  following scope, recorded here so a future session can pick it
  up without re-discovering the work:

  1. **Rename** `CONTEXT.md` → `GLOSSARY.md` at the repo root.
     Content is unchanged (the file is already titled `# Glossary`
     in its heading).
  2. **Update `skills/engineering/spec-to-tickets/SKILL.md`** to
     reference `GLOSSARY.md` instead of `CONTEXT.md` (~6+ references
     at lines 34, 78, 82-83, 183, 281, 285-286, 428, 445).
  3. **Update `skills/engineering/domain-grilling/SKILL.md`** to
     reference `GLOSSARY.md` instead of `CONTEXT.md` (~5+ references
     at lines 24, 78, 81, 95, 119, 121, 192-193).
  4. **Update `docs/agents/domain.md`** to reference `GLOSSARY.md`
     instead of `CONTEXT.md` (~3+ references at lines 7-8, 11, 15-39,
     43). This file is the consumer doc the new setup skill itself
     writes, so the new skill's output should already reference
     `GLOSSARY.md` from day one.

  This repo is left in a half-migrated state until the work item
  is done. The new skill's design (D003-D012) is independent of
  the migration; the new skill produces `GLOSSARY.md` for new host
  repos regardless of when this repo's migration lands.

### [D014] — references/ file name for Codeberg / Forgejo (re-opened)

- **Resolved Answer**: "The codeberg and Foregjo specific file should
  be called issue-tracker-forgejo.md - CodeBerg is the canonical
  non-profit hosted instance of Forgejo."
- **Normalized Requirement**: The shared seed template for Codeberg
  and other Forgejo-based hosts shall be named
  `references/issue-tracker-forgejo.md` (not
  `references/issue-tracker-codeberg.md`). The naming follows the
  project name (Forgejo), not the most prominent hosted instance
  (Codeberg), so a future contributor adding a new Forgejo-based
  host (e.g., a self-hosted Forgejo, a different non-profit
  instance) naturally reuses the same file.
- **Constraints**: `Supersedes: D012` (for the file name only — the
  rest of D012's file list and structure is unchanged). The
  load-trigger sentences in `SKILL.md` shall name the file
  `issue-tracker-forgejo.md` and shall document the "Codeberg and
  other Forgejo-based hosts" rule so a future contributor
  understands the naming choice.
