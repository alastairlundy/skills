---
name: release-readiness-review
description: >-
  Assess whether a project is ready for its FIRST public release (initial release or 1.0) by exploring the codebase, running the build and tests, and triaging findings into Blockers, Should-haves, and Nice-to-haves. Use when a user asks if a project is ready to ship, cut a 1.0, or do an initial release. Not for post-1.0 patch/minor releases or routine maintenance.
license: MIT
---

## When to Use
- When the user asks whether a project is ready for its first public release, an initial release, or a 1.0 - phrases like "is this ready to release", "can I ship this", "is this 1.0 ready", "should I cut a first release", "do a pre-release check".
- When the user says "release readiness", "ship it", or "is this ready to ship" about a new project.
- When the user wants a structured gap analysis before publishing a project for the first time.
- When the detected project type or intended distribution channel is ambiguous and the workflow needs user clarification, invoke the `ask-questions` skill to resolve it before triaging.

## When Not to Use
- For post-1.0 releases (patch or minor version bumps to an already-published project) - use a standard review or PR review skill.
- For ongoing code quality, architecture, or security review unrelated to a release decision.
- When the project is not intended for distribution or public release (e.g. a personal scratch script) and the user has not asked for a release assessment.
- For deep source-level code review, security audit, or test-strategy design - use the dedicated skills for those.
- When the user wants an automated release pipeline or CI/CD setup - use a dedicated deployment skill.

## Workflow

### Step 1 - Detect the project
In one parallel pass, attempt to read each of these top-level paths. Skip silently if missing (absence is not yet a finding):
- Manifests: `*.sln`, `*.slnx`, `*.csproj`, `*.fsproj`, `package.json`, `pyproject.toml`, `setup.py`, `Cargo.toml`, `go.mod`, `Gemfile`, `pubspec.yaml`, `Dockerfile`, `docker-compose.yml`, `Makefile`, `justfile`
- Docs: `README.md`, `README.rst`, `LICENSE*`, `CHANGELOG.md`
- Config: `.gitignore`, `.editorconfig`
- CI: `.github/workflows/*.yml`, `.gitlab-ci.yml`, `azure-pipelines.yml`, `.circleci/config.yml`

Derive a project profile:
- `ecosystem`: `dotnet` | `node` | `python` | `rust` | `go` | `ruby` | `dart` | `container` | `mixed` | `none` - pick from the manifest present; `mixed` if two or more clearly present.
- `type`: `library` | `application` | `cli` | `web` | `mobile` | `desktop` | `unknown` - use these heuristics:
  - `library`: manifest has packaging config AND no entry-point file at root (`Program.cs`, `main.go`, `app.py`, `index.js`, `lib.rs`, etc.).
  - `application`: entry-point file at root OR a `Dockerfile` exists.
  - `cli`: `bin` field in `package.json`, a single `[[bin]]` in `Cargo.toml`, or a console/cli SDK.
  - `web`/`mobile`/`desktop`: framework manifest (React/Vue/Next, Flutter/native mobile, Electron/Tauri/Avalonia). Best-effort.
  - `unknown`: none match.
- `distribution-channel`: `package-registry:<name>` | `container` | `binary` | `source-only` | `undetermined` - first match wins:
  1. CI workflow has a `publish`/`push` step to a known registry → `package-registry:<name>` (nuget/npm/pypi/crates-io/rubygems/pub-dev).
  2. Manifest has explicit packaging config (no CI publish) → inferred registry.
  3. `Dockerfile` present (no other packaging) → `container`.
  4. `Makefile`/`justfile` `install*` target writing outside the tree → `binary`.
  5. None → `undetermined`.

Ambiguity rule (mandatory): if `type` is `unknown`, `distribution-channel` is `undetermined`, or `ecosystem` is `mixed`, invoke `ask-questions` with discrete choices before any later step. Do not pick a default. A user's answer overrides derivation and is recorded as a `user-asserted` field.

Completion signal: a project profile with `ecosystem`, `type`, `distribution-channel` populated (derived or user-asserted) and confirmed.

### Step 2 - Inventory evidence (read-only)
Reuse the top-level files read in Step 1. In a parallel pass, read the ecosystem/type-specific files below. For every check, record `{check, applicable, status: present|absent, evidence}`. Set `applicable: false` for checks that do not apply to the detected type and do not surface them later.

Always: README (description + ≥1 usage example, or scaffold?), LICENSE (real text?), CHANGELOG (entry for the intended version?), `.gitignore`, CI workflow (build/test/publish steps?), repository URL (manifest/README/CI?).
By ecosystem (read only the relevant manifest fields): dotnet - central `.csproj` `PackageId`, `Version`, `Authors`, `Description`, `IsPackable`, `PackageLicenseExpression`, plus `Directory.Build.props`/`Directory.Packages.props`; node - `package.json` `name`, `version`, `description`, `bin`, `main`, `publishConfig`, `repository`, `bugs`, `engines`, `files`, `license`; python - `pyproject.toml` `[project]` `name`, `version`, `description`, `authors`, `license`, `readme`, `requires-python`, `classifiers`, `dependencies`; rust - `Cargo.toml` `[package]` `name`, `version`, `description`, `authors`, `license`, `repository`, `readme`, `edition`, and `[lib]`/`[[bin]]`; go - `go.mod` module path and `go` version; ruby - `.gemspec` `name`, `version`, `authors`, `summary`, `license`, `homepage`; dart - `pubspec.yaml` `name`, `version`, `description`, `author`, `homepage`, `repository`.
By type: `application`/`web`/`mobile`/`desktop` - `Dockerfile` valid (`FROM`/`CMD`/`ENTRYPOINT`) and deployment manifest present?; `library` - README has API docs or usage examples beyond install?; `ui-bearing` - logo/icon asset referenced?; `cli` - manifest declares a `bin`/`[[bin]]` entry?; tests - test project present, count of test files, framework detectable from manifest deps, test file names.

Completion signal: an evidence map where every applicable check has a present/absent status with supporting evidence.

### Step 3 - Probe build and tests
Before this step, load `references/probe-commands.md` for the per-ecosystem install/build/test command table.

Run install/restore, then build, then test, sequentially. Wrap each command with a 300s timeout; on timeout record the step as failed ("timed out"). Capture exit code and the last 30 lines (or error block) of output for each.
- On build failure only, run one clean rebuild (`dotnet clean`/`cargo clean`/`go clean`) and re-run once to rule out stale artifacts; record the final result. Do not retry tests.
- Optional application smoke test (gated): if the project is `application`/`web`/`cli` and a documented, non-interactive, side-effect-free run command exists (e.g. `./app --version`), run it once and capture the exit code. Skip if it needs interactive input, network writes, or a long-running process; record `smoke: skipped (<reason>)`.

Infeasibility (mandatory): if the required CLI is not on PATH, record `infeasible: <missing tool>`, STOP the probe phase, and do not fabricate results. State in the report that runtime checks were skipped and fall back to the strongest static signal (CI status badges / CI workflow contents from Step 2).

Completion signal: a probe result object `{build:{ran,exit_code,error_snippet,passed}, test:{ran,exit_code,passed,pass_count,fail_count,error_snippet}, smoke:{ran,passed,skipped_reason}, infeasible:<tool|null>}`.

### Step 4 - Triage into buckets
Before this step, load `references/triage-rules.md` and classify every finding from Steps 2–3 into exactly one bucket: Blockers, Should-haves, Nice-to-haves. Apply the tier rules from that file; do not invent tiers.

Completion signal: every applicable finding assigned to exactly one bucket with a tier reason.

### Step 5 - Report
Return a markdown report in the conversation (do not write a file unless the user asks):

```
## Release Readiness - <manifest name>
**Project profile** (confirm this is correct):
- Ecosystem: ...
- Type: ...
- Intended distribution: ...
- Probe status: ran | infeasible (<tool>, static evidence only)
**Tally:** N blockers · M should-haves · K nice-to-haves
```
If a field was user-asserted in Step 1, mark it `(confirmed by you)`.

Then three sections in order: `### Blockers`, `### Should-haves`, `### Nice-to-haves`. If a bucket is empty, print `None.`. Within each bucket, order items by category sequence: functional correctness → legal/licensing → distribution/packaging → build & CI → documentation → testing → presentation/polish.

Per item:
```
- **<Short finding title>** - _absent/present_
  - *Why it matters:* <one line, tied to the tier rule>
  - *Action:* <concrete fix>
  - *Evidence:* `<file>` - <snippet> | `not found`
```

Close with: if Blockers non-empty, `Address the N blocker(s) above before releasing.`; else `No release blockers detected. Remaining items are recommendations, not gates.` Do NOT issue a "ready to release" / "ship it" verdict.

Completion signal: a complete markdown report with header, all three buckets (populated or `None.`), and the closing line.

## Validation
- [ ] Project profile (`ecosystem`, `type`, `distribution-channel`) is populated by derivation or user assertion and confirmed.
- [ ] If `type`/`channel`/`ecosystem` was ambiguous, `ask-questions` was invoked and no default was assumed.
- [ ] Every applicable evidence check has a present/absent status with supporting evidence; non-applicable checks are excluded.
- [ ] Probe phase ran with captured exit codes, or recorded `infeasible` with reason and no fabricated results.
- [ ] Each finding is assigned to exactly one bucket per `references/triage-rules.md`.
- [ ] Report has the header, all three buckets (each `None.` if empty), and the closing line; no go/no-go verdict was issued.
- [ ] Items not applicable to the detected type are absent from the report.

## Transitions
- After the report, if the user wants to act on findings, hand off to `spec-to-tickets` to turn blockers/should-haves into implementation tickets, or `implement-tickets` to execute them.
- If the user wants a dedicated review of code quality or security before release, point them to the relevant review/audit skill instead of re-running this one.
