# Decision Ledger: write-changelog review

Repo: `skills`. Feature: `write-changelog-review`.

## Session context

- **Direction toward automation / CI use.** Stated by user at D004. Future branches that involve interactive-vs-autonomous fallbacks, ambiguous parsing, or non-deterministic outputs should weight automation-friendliness as a design constraint. Most directly affects D003's open follow-up (autonomous-mode refusal path) and any later branches touching Step 6's output phase or Step 4's user-facing prompts.

### [D001] — Step 4 ask-questions fallback

- **Resolved Answer**: "(2) makes sense but I would not have described this as a major issue."
- **Normalized Requirement**: Step 4 shall keep the ask-questions skill dependency and rewrite the fallback as a visible, named step in the workflow. When ask-questions is unavailable or the user declines, the agent shall default to `Global` and surface the default in the output (e.g., a `(defaulted)` marker on the section header) so the user sees the assumption rather than having it hidden. The fallback shall be a numbered step in the workflow, not prose — a prose-only default is easy to skip under context pressure.
- **Constraints**: The surfaced-default marker shall not break downstream CHANGELOG consumers (linters, release pipelines). User considers the issue a Minor, not a Major; severity label is a property of the review file, not the skill, and is not enforced by this ledger.

### [D002] — Step 1 directory-exclusion rule

- **Resolved Answer**: "(2) makes sense"
- **Normalized Requirement**: Step 1 shall exclude any directory that appears in the repo's `.gitignore`, plus the three explicit carve-outs (`docs/`, `.github/`, `tests/`). The rule applies in both the no-project-files fallback and the ambiguous-structure non-interactive fallback, eliminating the duplicated three-directory list.
- **Constraints**: The skill must include a fallback that emits the inline list (`docs/`, `.github/`, `tests/`) when `.gitignore` is absent or unparseable. Gitignore parsing must handle wildcards, negation (`!`), and anchored patterns; behavior on an unparseable pattern is to fail open (include) rather than fail closed, so a changelog is never silently dropped.

### [D003] — Destination file overwrite refusal

- **Resolved Answer**: "(3)"
- **Normalized Requirement**: Step 6 shall, on overwrite refusal, output the final markdown to the conversation and surface a one-line offer ("Say `write to <path>` to save to a new location") so the user can name the new path explicitly. No file is written on refusal.
- **Constraints**: Autonomous (non-interactive) mode is not fully covered by Option 3 — the "say `write to <path>`" offer is a no-op without a user. A follow-up branch is required to decide the autonomous-mode refusal path (e.g., fail closed with a visible error, or write to a deterministic new path such as `<destination>.new.<ext>`). Open follow-up; not resolved by D003. Automation-friendly direction (see Session context) is relevant: the follow-up should weight a deterministic, non-interactive default.

### [D004] — "Other (specify)" rule in Step 4

- **Resolved Answer**: "(2) Remove Other. Global works as a sensible default if All Packages or All Projects is inappropriate."
- **Normalized Requirement**: Step 4 shall drop the "Other (specify)" option and present exactly three choices: "Global", "All Packages", "All Projects". When none of the three fits (or, in autonomous mode, when the ask-questions skill is unavailable or the user declines), the skill shall default to "Global". The default shall be surfaced in the output (consistent with D001's `(defaulted)` marker convention).
- **Constraints**: No re-introduction of a free-form "Other" option. The three named options remain the only choices; the skill does not invent a fourth category to satisfy a user request that doesn't fit.

### [D005] — Inputs table Title Case (false positive)

- **Resolved Answer**: "(2) makes sense to avoid ambiguity"
- **Normalized Requirement**: The Inputs table Title Case is consistent and no skill edit is required. The `skill-reviews/write-changelog.md` file shall be annotated to mark the entry as a closed false positive so future readers do not re-open the branch.
- **Constraints**: The annotation must cite this ledger record (`D005`) so the resolution is traceable from the review file to the ledger. The annotation format is a status prepended to the entry heading, not a strikethrough of the entire entry (the prose reasoning is still useful).

### [D006] — Emoji list placement

- **Resolved Answer**: "(1) Makes the most sense."
- **Normalized Requirement**: Step 5 shall include a 6-row, 2-column table at the top mapping each emoji to its category (`🆕` → Additions, `⚙️` → Modifications, `⚠️` → Deprecations, `🗑️` → Removals, `🐛` → Bug Fixes, `📄` → Non Source Code). The table is the source of truth for the mapping; the prose below it uses the same mapping in the category order.
- **Constraints**: The skill must include a one-line instruction in Step 5 noting that the table and the prose below share the same mapping and must be updated together, to prevent drift between the two representations. When `Use Emojis: No`, the table is not rendered (the plain-text headings are used instead); the table itself remains in the skill as a reference.

### [D007] — Pre-existing changelog detection

- **Resolved Answer**: "(4) Makes sense."
- **Normalized Requirement**: Step 1 shall include a first-run probe that scans for any of `CHANGELOG.md`, `HISTORY.md`, `RELEASES.md`, or `docs/changelog.md` and surfaces the existence to the user *before* the destination is named. If a file is found, the destination defaults to that path; the user may override. Step 6 shall offer a three-way choice when the destination exists: overwrite, append under a new `## Changes since <tag>` section, or refuse (D003 path).
- **Constraints**: The autonomous-mode default for the three-way choice is not fully resolved by D007 — it collapses to a config-knob decision. This is tracked under D003's open follow-up. The probe filename list (`CHANGELOG.md`, `HISTORY.md`, `RELEASES.md`, `docs/changelog.md`) is the initial set; a follow-up branch may extend it if a convention is missed.

### [D008] — "clear history" fuzziness

- **Resolved Answer**: "(1) is the right call."
- **Normalized Requirement**: The "When Not to Use" entry shall be rewritten to: "In repositories with fewer than 5 commits between the prior and target points, or with no tags in the range." The phrase "clear history" is removed.
- **Constraints**: The 5-commit threshold is a default, not a hard rule. The skill shall include a one-line note that a user may override by ignoring the "When Not to Use" guidance. The empty-range abort (D017) is the mechanical guard that catches the genuine edge case; the "When Not to Use" entry remains a softer guide.

### [D009] — Step 2 User Guidance tier mode-cut

- **Resolved Answer**: "(1) is the best choice - It's robust and does what is likely expected"
- **Normalized Requirement**: In autonomous mode, Step 2's User Guidance tier shall resolve as follows: if the commit message has a Conventional Commit prefix, map it to the corresponding category (`feat:` → Additions, `fix:` → Bug Fixes, `refactor:` → Modifications, `perf:` → Modifications, `docs:` → Non Source Code, `chore:` → Modifications); if no prefix is present, default to "Modifications". The mapping table is documented in Step 2.
- **Constraints**: A `chore:` commit that is a runtime dependency bump is miscategorized as Modifications. The skill shall include a one-line note in Step 2 stating that the Conventional Commit prefix mapping is the primary signal and the dependency-classification rule (D010) is the secondary signal for `chore:`-prefixed commits that touch dependency files. The mapping table must be co-located with the tier list in Step 2 to prevent drift.

### [D010] — Dependency classification rule

- **Resolved Answer**: "(1) - We need mappings for popular major languages like Javascript, Python, Go, and Java. The question then is where does this all belong once we've accumulated all the ecosystem classification rules? A reference file or something else?"
- **Normalized Requirement**: Step 5 shall include a deterministic three-category rule (Runtime / CI / Testing) with explicit ecosystem mappings for the major languages. The rule is the single source of truth for dependency classification. The "where does it live" question is deferred to a follow-up branch (D011).
- **Constraints**: The rule must explicitly cover: JavaScript (`package.json` `dependencies` → Runtime; `devDependencies` split by tool type — test frameworks → Testing, linters/formatters/bundlers → CI; `yarn.lock` / `package-lock.json` / `pnpm-lock.yaml` lockfile changes → Runtime); Python (`requirements.txt`, `pyproject.toml` `[project] dependencies` → Runtime; `requirements-dev.txt`, `pyproject.toml` `[project.optional-dependencies]` test groups → Testing; CI configs → CI); Go (`go.mod` `require` → Runtime; test-only packages imported in `*_test.go` files → Testing; CI configs → CI); Java (`pom.xml` `<dependencies>` → Runtime; `<scope>test</scope>` → Testing; `build.gradle` / `build.gradle.kts` dependency blocks → Runtime; CI configs → CI). The skill must include a tie-breaker rule for ambiguous cases (e.g., a `devDependency` that is a build tool like `webpack`): the tie-breaker is the file path, not the dependency name — files in `.github/workflows/`, build scripts, or named `*rc*` / `*.config.*` are CI; files matching `*Tests*` / `*Spec*` / `*Test*` are Testing; everything else is Runtime. Open follow-up (D011): where the rule lives (inline table vs reference file).

### [D011] — Dependency classification rule location

- **Resolved Answer**: "(3) Makes sense but we need to make sure the dependency classification reference is triggered/viewed by the LLM if needed."
- **Normalized Requirement**: Step 5 shall include a short inline summary (3-row table: one example per category, plus a tie-breaker line) and a load-trigger sentence pointing to `references/dependency-classification.md`. The reference file is the single source of truth; the inline summary mirrors it.
- **Constraints**: The load-trigger sentence must be in an active voice that an LLM agent will parse as an action, not a passive description. The trigger should name a concrete moment at which the reference must be loaded — e.g., "Load `references/dependency-classification.md` before classifying any commit that touches a dependency file." The reference file's header must declare itself the source of truth and instruct that the inline summary in `SKILL.md` must mirror it. Drift between the two is a known risk; the trigger's "before classifying" wording is the design mitigation.

### [D012] — Sub-projects rule for when to introduce sub-project sections

- **Resolved Answer**: "(1)"
- **Normalized Requirement**: Step 1 shall introduce sub-project sections only when 2 or more project files (e.g., `.csproj`, `package.json`, `go.mod`, `pom.xml`) are detected at the top level. When only 1 project file is detected, the skill falls back to Global grouping (consistent with D004's Global default). When no project files are detected, the D002 directory-exclusion rule applies.
- **Constraints**: A single-project repo that *does* want sub-project sections (e.g., a multi-module Gradle build) must restructure to have 2+ project files, or the rule may be overridden by a future input. A non-standard monorepo (1 project file, many top-level directories) is classified as single-project; this is an accepted limitation.

### [D013] — Inputs table to references/inputs.md (deferred disclosure)

- **Resolved Answer**: "(1) - No action is needed"
- **Normalized Requirement**: The Inputs table remains inline in `SKILL.md` at its current 4 rows. No deferred-disclosure rule is encoded in the skill. The convention from `AGENTS.md` ("short templates live inline") is followed.
- **Constraints**: A future edit that inflates the table past 6 rows is not blocked by this ledger; a maintainer may add a deferred-disclosure note in a follow-up if the table grows.

### [D014] — "Inline the dependency-classification rule" (verify and close)

- **Resolved Answer**: "(1)"
- **Normalized Requirement**: The review's Other tweak 2 is closed as already-resolved by D010 (rule content) and D011 (rule location). No additional skill edit is required.
- **Constraints**: If this branch is re-opened, the re-opener must re-read D010 and D011 first — the substantive decisions live there. The hybrid placement (inline summary + reference file) was the user's explicit choice at D011, including the load-trigger concern; a re-open to "inline only" would reverse D011 and is not supported.

### [D015] — "Sub-projects" vs "Packages" terminology

- **Resolved Answer**: "Standardize on Sub-projects. Sub-projects are only 'packages' if they are A) a library and B) are distributable via Cargo, NPM, NuGet, or any other package manager."
- **Normalized Requirement**: The skill shall use "Sub-projects" as the standard term throughout. Step 1's "Sub-projects/packages" becomes "Sub-projects". Step 5's "Sub-project Sections" stays as "Sub-project Sections". A glossary line at the top of Step 1 shall define the relationship: a "Package" is a Sub-project that is BOTH a library AND distributable via a package manager (Cargo, NPM, NuGet, etc.); the two terms are related but not synonymous.
- **Constraints**: D004's "All Packages" choice is in tension with the standardised term — "All Packages" now means a narrower set than the literal D004 wording suggested. This tension is logged for a follow-up; the user has not asked to re-open D004. The glossary line must define both terms precisely so the relationship is visible to a future agent. The skill shall not use "Sub-projects" and "Packages" as interchangeable synonyms.

### [D016] — "Add a first run probe" (verify and close)

- **Resolved Answer**: "(1)"
- **Normalized Requirement**: The review's Other tweak 4 is closed as already-resolved by D007 (first-run probe in Step 1 + three-way choice in Step 6). No additional skill edit is required.
- **Constraints**: If this branch is re-opened, the re-opener must re-read D007 first — the substantive decision lives there. The probe + three-way choice is the user's explicit resolution; a re-open to "probe only" would reverse D007 Option 1 and is not supported.

### [D017] — "If the commit range is empty, abort"

- **Resolved Answer**: "(2) is potentially a lot more useful for end user debugging. We're going with (2)"
- **Normalized Requirement**: In Step 2, if the retrieved commit list is empty, the skill shall emit a one-line human-readable explanation ("The commit range is empty — no changelog to generate.") followed by a parseable error marker (e.g., ```` ```\n[CHANGELOG-MARKER] empty-range\nprior: <prior>\ntarget: <target>\n``` ````). No changelog is written. The wrapper contract for translating the marker into a non-zero exit code is documented in a shared `references/ci-integration.md` (also covering D001's `(defaulted)` marker and D003's autonomous-mode refusal marker).
- **Constraints**: A skill is a prompt template, not an executable — it cannot return a process exit code. The skill produces a structured marker; the CI wrapper translates the marker into a non-zero exit. The wrapper contract must be explicit: the wrapper matches the `[CHANGELOG-MARKER]` marker (and the marker block), not the human prose above it, to avoid false matches. The `references/ci-integration.md` file is the canonical home for the marker vocabulary across all decisions that emit markers (D001, D003, D017, and future branches).

### [D018] — Fix typos in frontmatter description

- **Resolved Answer**: "(2)"
- **Normalized Requirement**: The frontmatter `description` field shall be edited to fix two typos in the same sentence: "betweeen" → "between" and "speified" → "specified". The corrected sentence reads: "Use when the user wants to write a changelog/release notes, or wants to know what happened between two specified versions."
- **Constraints**: The edit was applied to the global copy at `~/.agents/skills/write-changelog/SKILL.md` line 4 during the grilling session. **The repo copy at `skills/engineering/write-changelog/SKILL.md` line 4 was NOT edited** — the user flagged this and asked for the repo edit to be done later. A follow-up task is required to apply the same edit to the repo copy. The two copies must remain in sync. A future edit that introduces new typos in the frontmatter is not blocked by this ledger; a maintainer may add a proofreading note in a follow-up. The validation list is not extended (D018 Option 3 was not chosen) — the rule is that the frontmatter should be carefully proofread, not that a validation rule enforces it.

### [D019] — "Move emoji list to a small table at the top of Step 5" (verify and close)

- **Resolved Answer**: "(1)"
- **Normalized Requirement**: The review's Other tweak 7 is closed as already-resolved by D006 (small inline table at the top of Step 5 with the emoji-to-category mapping). No additional skill edit is required.
- **Constraints**: If this branch is re-opened, the re-opener must re-read D006 first — the substantive decision lives there. The inline-table placement is the user's explicit resolution; a re-open to a reference file would reverse D006 and is not supported.

### [D020] — "Replace 'Non Source Code' with 'Docs'"

- **Resolved Answer**: "(4) makes sense"
- **Normalized Requirement**: Step 5 shall keep the "Non Source Code" category name and add a one-line scope note immediately above or below the category in the category order: "Non Source Code = documentation, configuration, assets, and any other change that is not source code. The Keep-a-Changelog 'Documentation' category is a strict subset of this." The emoji table (D006) and the prose in Step 5 share the same category name and must be updated together if the name ever changes.
- **Constraints**: The scope note must be co-located with the category in both the inline emoji table (D006) and the prose category order, with a one-line instruction noting that the note and the category name must be updated together to prevent drift. The relationship to Keep-a-Changelog's narrower "Documentation" category is explicit so a future agent can choose to narrow the category later if their repo's usage turns out to be documentation-only.
