---
name: write-changelog
description: >-
  Generates an ecosystem-aware, user-facing markdown changelog in the Keep a Changelog 1.1.0 format by analyzing git history, transforming commit messages, and categorizing changes into logical sub-projects. Use when the user wants to write a changelog/release notes, or wants to know what happened between two specified versions. Do not use for summarizing git commit changes.
license: MIT
---

# Write changelog

Format note: the output format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) (MIT, created and maintained by Olivier Lacan). Categories, heading shapes, and section order follow that specification.

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

## Workflow

### Step 1: Project discovery
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

### Step 2: Commit retrieval & analysis
- Retrieve git history for the specified range.
- **Empty-range guard**: if the retrieved commit list is empty, emit a one-line human-readable explanation ("The commit range is empty - no changelog to generate.") followed by the parseable error marker from `references/ci-integration.md` (`[CHANGELOG-MARKER] empty-range` with `prior:` and `target:` lines). Do not write a changelog. The CI wrapper translates the marker into a non-zero exit code.
- For each commit, determine the category using a tiered analysis:
    1. **Conventional Commit Check**: if the commit message has a Conventional Commit prefix, map it to the corresponding category using the table below.
    2. **Security Check**: if the commit message contains a `security:` prefix, a CVE reference (`CVE-YYYY-NNNNN`), or a GHSA reference (`GHSA-xxxx-xxxx-xxxx`), classify the commit as Security regardless of any other prefix. The security check may be applied at tier 1 alongside the prefix check.
    3. **Diff Analysis**: if the prefix is absent, the mapping is ambiguous, and no security reference is present, analyze the `git diff` for additions, removals, or modifications.
    4. **User Guidance**: if still unclear, present the commit message and diff to the user and ask for the correct category and description.

Conventional Commit prefix mapping (co-located with the tier list so the two do not drift):

| Prefix | Category |
|--------|----------|
| `feat:` | Added |
| `fix:` | Fixed |
| `security:` | Security |
| `refactor:` | Changed |
| `perf:` | Changed |
| `docs:` | Changed |
| `chore:` | Changed |
| (no prefix) | Changed (default) |

**Autonomous-mode rule** (when the ask-questions skill is unavailable or the user declines): the Conventional Commit prefix mapping above is the primary signal; tier 3 (diff analysis) may be applied, but tier 4 (user prompt) is skipped and the default "Changed" is used. The dependency-classification rule (Step 5) is the secondary signal that overrides the prefix for `chore:`-prefixed commits that touch dependency files.

### Step 3: Message transformation
- Rewrite commit messages to be "changelog style":
    - Convert imperative ("Add X") to descriptive ("Added X").
    - Remove technical noise (e.g., "closes #123", JIRA IDs).
    - Summarize long, rambling messages into concise, impact-focused sentences.
    - Validate the transformation against the diff to ensure no meaning is lost.

### Step 4: Sub-project section title selection
- Analyze the repo structure to recommend a title for the first changelog sub-project section (an H3 heading inside the version section, see Step 5):
    - **Global** - recommended when the repo root contains mixed content (docs, CI, scripts, config).
    - **All Packages** - recommended for monorepos with multiple sub-projects (see glossary in Step 1).
    - **All Projects** - recommended for solution-based repos (e.g., .NET `.sln` with multiple `.csproj`).
- **Step 4.1 - User choice**: present exactly three choices - "Global", "All Packages", "All Projects" - and ask the user to pick one via the ask-questions skill. Do not offer a free-form "Other (specify)" option; the three named options are the only choices.
- **Step 4.2 - Fallback**: if the ask-questions skill is unavailable or the user declines, default to "Global" and surface the default in the output by appending `(defaulted)` to the sub-project section header (e.g., `### Global (defaulted)`). The marker is local to the section header and must not break downstream CHANGELOG consumers (linters, release pipelines) - see `references/ci-integration.md` for the marker contract.

### Step 5: Markdown construction
- **Preamble** (emitted when creating a new file; skipped when appending to an existing file that already has it):

    ```markdown
    # Changelog

    All notable changes to this project will be documented in this file.

    The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
    and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
    ```

    Omit the "adheres to Semantic Versioning" sentence when the prior tag is not a semver tag.

- **Version heading**: use tag as-is (no semver normalization):
    - `## [<Prior Tag as-is>] - <YYYY-MM-DD>` where the date is the tag's creation date. The date format is ISO 8601 (year-month-day), per Keep a Changelog.
    - **Unreleased**: when the target is HEAD and the user did not provide a final version, use `## [Unreleased]` with no date.
- **Layout hierarchy**:
    1. `## [<version>] - <date>` (version heading, H2)
    2. Sub-project section (H3): the title from Step 4, or the sub-project name. Sub-project sections appear only when 2 or more project files were detected (Step 1 threshold).
    3. Category headings (H4), in Keep a Changelog order, omitted when empty: `#### Added`, `#### Changed`, `#### Deprecated`, `#### Removed`, `#### Fixed`, `#### Security`.
- **Category definitions** (source: Keep a Changelog - do not rename or reorder): `Added` for new features; `Changed` for changes in existing functionality; `Deprecated` for soon-to-be removed features; `Removed` for now removed features; `Fixed` for any bug fixes; `Security` in case of vulnerabilities. Category headings are plain text - no emoji prefixes.
- **Uses for each category**:

    | Category | Conventional Commit prefixes | Examples |
    |----------|------------------------------|----------|
    | Added | `feat:` | New features, new sub-commands, new package exports |
    | Changed | `refactor:`, `perf:`, `docs:`, `chore:` | Refactors, performance work, doc/config/asset updates |
    | Deprecated | (diff analysis) | API marked `[Obsolete]`, deprecation warnings added |
    | Removed | (diff analysis) | Deleted features, dropped package exports |
    | Fixed | `fix:` | Bug fixes, crash fixes |
    | Security | `security:`, CVE/GHSA refs | Vulnerability patches, dependency bumps fixing CVEs |

- **Dependency classification** (source of truth: `references/dependency-classification.md`): classify each dependency update as Runtime, CI, or Testing using the rule in the reference file. Load `references/dependency-classification.md` before classifying any commit that touches a dependency file - the inline summary below mirrors the reference and the two must be updated together.

    Inline summary:

    | Example | Category |
    |---------|----------|
    | `package.json` `dependencies` change | Runtime |
    | `package.json` `devDependencies` test framework (jest, vitest, mocha, ...) | Testing |
    | `.github/workflows/*` change | CI |

    Tie-breaker for ambiguous cases: classify by file path, not by dependency name. Files in `.github/workflows/`, build scripts, or named `*rc*` / `*.config.*` are CI; files matching `*Tests*` / `*Spec*` / `*Test*` are Testing; everything else is Runtime.

- Within each section, group changes by category using the headings above. The Runtime/CI/Testing dependency sub-groups remain sub-bullets under the section's `#### Changed` (or the category their commits map to) - keep the sub-group labels (Runtime Dependencies, CI Dependencies, Testing Dependencies) as bold run-in labels, not markdown headings.
- Use markdown bullet points for each entry.
- **Link footer**: when the remote URL is derivable from `git remote`, append a link-reference definition block at the end of the document comparing the previous tag to this one:

    ```markdown
    [<version>]: https://github.com/<owner>/<repo>/compare/<previous-tag>...<tag>
    ```

    Use the repo's actual host (GitHub, GitLab, etc.). Skip the footer silently when no remote is derivable.

### Step 6: Output phase
- If a destination file is provided and does not exist, write the final markdown to that path (including the Preamble).
- If the destination file already exists, present a three-way choice (interactive run):
    1. **Overwrite** - replace the existing file.
    2. **Append** - insert a new `## [<version>] - <date>` section above the existing newest version section (Keep a Changelog is reverse chronological); do not duplicate the Preamble.
    3. **Refuse** - do not write to disk. Output the final markdown to the conversation and surface a one-line offer: "Say `write to <path>` to save to a new location."
- **Autonomous mode**: the three-way choice collapses to a deterministic default (overwrite is the safest for an unattended CI run; an open follow-up may revise this). When the user explicitly refuses overwrite in interactive mode, no file is written.
- When no destination is provided, output the final markdown string to the conversation. In non-interactive runs, the skill applies the Step 1, Step 2, and Step 4 fallbacks above and does not prompt the user.

## Validation

- [ ] The version heading matches `## [<tag-as-is>] - <YYYY-MM-DD>` (ISO 8601 date, tag used without rewriting); `## [Unreleased]` is used when the target is HEAD with no final version.
- [ ] New files carry the Keep a Changelog preamble; appends to existing files do not duplicate it.
- [ ] Step 1's first-run probe ran and any pre-existing changelog (`CHANGELOG.md`, `HISTORY.md`, `RELEASES.md`, `docs/changelog.md`) was surfaced before the destination was named.
- [ ] Step 1's directory exclusion used `.gitignore` plus the `docs/` / `.github/` / `tests/` carve-outs (or the inline-list fallback when `.gitignore` is absent or unparseable).
- [ ] Sub-project sections appear only when 2 or more project files were detected at the top level, as H3 headings.
- [ ] Step 2's empty-range guard emitted the `[CHANGELOG-MARKER] empty-range` marker when the commit list was empty; no changelog was written.
- [ ] Each commit's category was determined via the tiered analysis (Conventional Commit prefix → security reference → diff analysis → user prompt) using the mapping table in Step 2.
- [ ] Category headings are plain `#### Added` / `#### Changed` / `#### Deprecated` / `#### Removed` / `#### Fixed` / `#### Security`, in Keep a Changelog order, with empty categories omitted; no emoji or "Non Source Code" headings appear.
- [ ] Step 4 presented exactly three named choices ("Global", "All Packages", "All Projects"); no "Other (specify)" option was offered. When the fallback ran, the sub-project heading carries the `(defaulted)` marker.
- [ ] Step 5's dependency classification used `references/dependency-classification.md` (loaded before any dependency commit was classified) and the inline summary mirrors the reference.
- [ ] Commit messages are transformed from developer-style to user-facing style.
- [ ] Global dependency sub-groups (Runtime, CI, Testing) appear as bold run-in labels only when they contain entries.
- [ ] The link footer contains a compare link for the new version when the remote URL was derivable; no footer when it was not.
- [ ] Step 6's three-way choice (overwrite / append / refuse) was offered when the destination already existed; on append, the new section was inserted above the existing newest version; on refusal, the final markdown was output to the conversation with the one-line "write to `<path>`" offer.

## Common pitfalls

| Pitfall | Solution |
|---------|----------|
| Incorrect project mapping | Ensure the discovery process prioritises project files over simple directory names, and only introduces sub-project sections at the 2+ project file threshold. |
| Over-simplifying messages | Always validate the rewritten message against the `git diff` to ensure technical accuracy. |
| Missing category | Fall back to "Changed" if a change is source-code related but doesn't fit elsewhere. |
| Prose version heading | Emit `## [X] - YYYY-MM-DD`, never `## Changes since X`. |
| Rewriting a non-semver tag | Use the tag as-is inside the brackets; never invent a version number. |
| Treating "Sub-projects" and "Packages" as synonyms | Use "Sub-projects" as the standard term; "Package" is a Sub-project that is BOTH a library AND distributable via a package manager (see glossary in Step 1). |
| Empty-range commit list | Emit the `[CHANGELOG-MARKER] empty-range` marker from Step 2; do not write a changelog. |
| Drift between the inline dependency-classification summary and the reference file | Update `SKILL.md` and `references/dependency-classification.md` in the same edit (Step 5). |
