---
name: write-changelog
description: >-
  Generates an ecosystem-aware, user-facing markdown changelog by analyzing git history, transforming commit messages, and categorizing changes into logical sub-projects. Use when the user wants to write a changelog/release notes, or wants to know what happened between two specified versions. Do not use for summarizing git commit changes.
license: MIT
---

# Write Changelog

## When to Use

- Create release notes for a new version.
- Summarize changes between two git tags or a tag and the current HEAD.
- Generate structured changelogs for monorepos with multiple sub-projects.
- When user input would clarify the request, invoke ask-questions

## When Not to Use

- For extremely large commit ranges where high-level manual curation is required.
- In repositories with fewer than 5 commits between the prior and target points, or with no tags in the range.

The 5-commit threshold is a default, not a hard rule; a user may override by ignoring this guidance. The empty-range abort in Step 2 is the mechanical guard that catches the genuine edge case.

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Prior Git Tag/Commit | Yes | The starting point of the changelog range. |
| Target Branch/Commit | No | The end point of the range. Defaults to current HEAD. |
| Destination file | No | Path to save the output. If omitted, outputs to the conversation. |
| Use Emojis | No | Prefix category headings with emoji (🆕 🗑️ ⚙️ 🐛 📄 ⚠️). Set to "No" for plain text. Defaults to "Yes". |

## Workflow

### Step 1: Project Discovery
- **Glossary**: a *Package* is a Sub-project that is BOTH a library AND distributable via a package manager (Cargo, NPM, NuGet, etc.). "Sub-projects" and "Packages" are related but not synonymous; this skill uses "Sub-projects" as the standard term.
- **First-run probe** (always run, before naming a destination): scan for any of `CHANGELOG.md`, `HISTORY.md`, `RELEASES.md`, `docs/changelog.md`. If found, surface the path to the user and default the destination to that path; the user may override.
- Identify sub-projects in an ecosystem-aware manner:
    1. Scan for project files (`.csproj`, `package.json`, `go.mod`, `pom.xml`, etc.) at the top level using `glob`.
    2. **Sub-projects threshold**: sub-project sections are introduced only when 2 or more project files are detected at the top level. A 1-project-file repo falls back to Global grouping; the 2+ threshold is the trigger.
    3. If no project files are found, group by top-level directories. Exclude any directory that appears in the repo's `.gitignore`, plus the three explicit carve-outs (`docs/`, `.github/`, `tests/`). Gitignore parsing must handle wildcards, negation (`!`), and anchored patterns; behaviour on an unparseable pattern is to fail open (include) rather than fail closed, so a changelog is never silently dropped.
    4. If `.gitignore` is absent or unparseable, fall back to the inline list: exclude `docs/`, `.github/`, `tests/`.
    5. If the structure is still ambiguous:
        - **Interactive run**: list detected directories and ask the user to define the sub-projects (via the ask-questions skill).
        - **Non-interactive run**: default to grouping by top-level directories using the same exclusion rule as step 3 (or the inline-list fallback in step 4).

### Step 2: Commit Retrieval & Analysis
- Retrieve git history for the specified range.
- **Empty-range guard**: if the retrieved commit list is empty, emit a one-line human-readable explanation ("The commit range is empty — no changelog to generate.") followed by the parseable error marker from `references/ci-integration.md` (`[CHANGELOG-MARKER] empty-range` with `prior:` and `target:` lines). Do not write a changelog. The CI wrapper translates the marker into a non-zero exit code.
- For each commit, determine the category using a tiered analysis:
    1. **Conventional Commit Check**: if the commit message has a Conventional Commit prefix, map it to the corresponding category using the table below.
    2. **Diff Analysis**: if the prefix is absent or the mapping is ambiguous, analyze the `git diff` for additions, removals, or modifications.
    3. **User Guidance**: if still unclear, present the commit message and diff to the user and ask for the correct category and description.

Conventional Commit prefix mapping (co-located with the tier list so the two do not drift):

| Prefix | Category |
|--------|----------|
| `feat:` | Additions |
| `fix:` | Bug Fixes |
| `refactor:` | Modifications |
| `perf:` | Modifications |
| `docs:` | Non Source Code |
| `chore:` | Modifications |
| (no prefix) | Modifications (default) |

**Autonomous-mode rule** (when the ask-questions skill is unavailable or the user declines): the Conventional Commit prefix mapping above is the primary signal; tier 2 (diff analysis) may be applied, but tier 3 (user prompt) is skipped and the default "Modifications" is used. The dependency-classification rule (Step 5) is the secondary signal that overrides the prefix for `chore:`-prefixed commits that touch dependency files.

### Step 3: Message Transformation
- Rewrite commit messages to be "changelog style":
    - Convert imperative ("Add X") to descriptive ("Added X").
    - Remove technical noise (e.g., "closes #123", JIRA IDs).
    - Summarize long, rambling messages into concise, impact-focused sentences.
    - Validate the transformation against the diff to ensure no meaning is lost.

### Step 4: Global Section Title Selection
- Analyze the repo structure to recommend a title for the first changelog section:
    - **Global** — recommended when the repo root contains mixed content (docs, CI, scripts, config).
    - **All Packages** — recommended for monorepos with multiple sub-projects (see glossary in Step 1).
    - **All Projects** — recommended for solution-based repos (e.g., .NET `.sln` with multiple `.csproj`).
- **Step 4.1 — User choice**: present exactly three choices — "Global", "All Packages", "All Projects" — and ask the user to pick one via the ask-questions skill. Do not offer a free-form "Other (specify)" option; the three named options are the only choices.
- **Step 4.2 — Fallback**: if the ask-questions skill is unavailable or the user declines, default to "Global" and surface the default in the output by appending `(defaulted)` to the section header (e.g., `## Global (defaulted)`). The marker is local to the section header and must not break downstream CHANGELOG consumers (linters, release pipelines) — see `references/ci-integration.md` for the marker contract.

### Step 5: Markdown Construction
- Start the document with: `## Changes since [Prior Git Tag]`
- **Emoji-to-category mapping** (table is the source of truth; the prose below uses the same mapping in the same order — update the table and the prose together to prevent drift):

    | Emoji | Category |
    |-------|----------|
    | 🆕 | Additions |
    | ⚙️ | Modifications |
    | ⚠️ | Deprecations |
    | 🗑️ | Removals |
    | 🐛 | Bug Fixes |
    | 📄 | Non Source Code |

- Organize the layout as follows:
    1. **Global Section** (title from Step 4): Changes at the root or in global folders. If dependency updates exist, split them into the following sub-sections (only include sub-sections that have entries):
        - **Runtime Dependencies**: Package/dependency updates for library or runtime projects.
        - **CI Dependencies**: GitHub Actions, analyzers, build tooling, and CI configuration changes.
        - **Testing Dependencies**: Test framework packages and test infrastructure updates.
    2. **Sub-project Sections**: Grouped by the sub-projects identified in Step 1.
        - **Dependency updates within a sub-project**: appear as inline `⚙️ Modifications` entries within that sub-project's section, with no Runtime/CI/Testing sub-categories.
- **Dependency classification** (source of truth: `references/dependency-classification.md`): classify each dependency update as Runtime, CI, or Testing using the rule in the reference file. Load `references/dependency-classification.md` before classifying any commit that touches a dependency file — the inline summary below mirrors the reference and the two must be updated together.

    Inline summary:

    | Example | Category |
    |---------|----------|
    | `package.json` `dependencies` change | Runtime |
    | `package.json` `devDependencies` test framework (jest, vitest, mocha, ...) | Testing |
    | `.github/workflows/*` change | CI |

    Tie-breaker for ambiguous cases: classify by file path, not by dependency name. Files in `.github/workflows/`, build scripts, or named `*rc*` / `*.config.*` are CI; files matching `*Tests*` / `*Spec*` / `*Test*` are Testing; everything else is Runtime.

- Within each section, group changes by category. Categories follow Keep-a-Changelog order; the Security category is omitted (security-related fixes land in 🐛 Bug Fixes). Categories appear in the following order: 🆕 Additions, ⚙️ Modifications, ⚠️ Deprecations, 🗑️ Removals, 🐛 Bug Fixes, 📄 Non Source Code. When `Use Emojis: Yes` (the default), each category heading is prefixed with the emoji shown in the table above; when `Use Emojis: No`, each category is rendered as a plain bold heading with no prefix. The table and the prose below share the same mapping and must be updated together if the mapping ever changes.
- **Non Source Code** = documentation, configuration, assets, and any other change that is not source code. The Keep-a-Changelog "Documentation" category is a strict subset of this. (The scope note and the category name must be updated together to prevent drift — see the table above and this prose.)
- Use markdown bullet points for each entry.

### Step 6: Output Phase
- If a destination file is provided and does not exist, write the final markdown to that path.
- If the destination file already exists, present a three-way choice (interactive run):
    1. **Overwrite** — replace the existing file.
    2. **Append** — append a new `## Changes since <prior>` section to the existing file.
    3. **Refuse** — do not write to disk. Output the final markdown to the conversation and surface a one-line offer: "Say `write to <path>` to save to a new location."
- **Autonomous mode**: the three-way choice collapses to a deterministic default (overwrite is the safest for an unattended CI run; the follow-up branch tracked under D003's open follow-up may revise this). When the user explicitly refuses overwrite in interactive mode, no file is written.
- When no destination is provided, output the final markdown string to the conversation. In non-interactive runs, the skill applies the Step 1, Step 2, and Step 4 fallbacks above and does not prompt the user.

## Validation

- [ ] The header accurately reflects the starting Git tag.
- [ ] Changes are grouped by sub-projects and categorized by impact.
- [ ] Commit messages are transformed from developer-style to user-facing style.
- [ ] "Non Source Code" changes are appropriately split between Global and Package sections.
- [ ] Global dependency sub-sections (Runtime, CI, Testing) are only present when they contain entries.
- [ ] Toggling the `Use Emojis` input flips the presence of emoji prefixes on category headings (default = emojis present).

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Incorrect project mapping | Ensure the discovery process prioritizes project files over simple directory names. |
| Over-simplifying messages | Always validate the rewritten message against the `git diff` to ensure technical accuracy. |
| Missing category | Fall back to "Modifications" if a change is source-code related but doesn't fit elsewhere. |
