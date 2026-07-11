---
name: dependency-review
description: >-
  Audit a project's third-party dependencies for staleness, bloat, tight coupling, deprecation, and recent major changes. Use when a user asks to review dependencies, generate a dependency report, scan for unmaintained packages, or check for upgrade pressure. Also activate when an agent is judging dependency health as part of a broader review. Code-first scope by default; pass `scope: code,non-code` (in the user's message) or `--scope=code,non-code` (forward-compatible CLI flag) to opt in to non-code dependencies (OS, runtimes, hosted services, databases, CI tooling, third-party binaries). Out of scope: organisational dependencies, security/CVE scanning, cross-checked replacement recommendations (deferred to v2), reflection/convention-based implicit-dependency detection (deferred to v2/v3). When user input would clarify the request, invoke ask-questions.
license: MIT
---

# Dependency Review

Audit a project's third-party dependencies and produce a structured report covering four finding categories: dependencies that don't earn their keep, tight coupling between application code and external packages, unmaintained or deprecated packages, and recent major-version changes that warrant attention.

Load `references/dependency-review-guide.md` before Step 1.

## When to Use

- A user asks to review a project's third-party dependencies
- A user asks to generate a dependency report or manifest audit
- A user asks to scan for unmaintained, deprecated, or stale dependencies
- A user asks to find dependencies that don't earn their keep
- A user asks to flag tight coupling between application code and external packages
- A user asks to check for recent major-version changes that need migration attention
- An agent is judging dependency health as part of a broader review of a project
- Scope flag: pass `scope: code,non-code` in the user's message (or `--scope=code,non-code` for the forward-compatible CLI) to opt in to non-code dependencies. Default scope is `code` only
- When user input would clarify the request, invoke `ask-questions`

## When Not to Use

- The task is to add, upgrade, or remove a dependency (use package-management tooling)
- The task is a security or CVE scan (use a vulnerability-specific tool)
- The user wants cross-checked replacement recommendations (deferred to v2)
- The user wants reflection-based or convention-based implicit-dependency detection (deferred to v2/v3)
- The user wants organisational or team-level dependency analysis (out of scope)

## Workflow

The workflow has seven numbered steps. Steps 1 and 2 are deterministic; Steps 3-7 are judgement. Each step's tag is recorded in the Guide and is the seam the future CLI cuts along.

### Step 1 — Discovery [deterministic]

Enumerate the project's third-party dependencies. For each:

1. Identify the project's ecosystems (npm, pip, Maven, NuGet, Cargo, Go modules, etc.) by reading manifest files at the project root
2. Read the manifest(s) and extract the dependency list (direct and, where available, transitive)
3. Apply the per-ecosystem module-level implicit-dependency detection rule (Java package, Python module, .NET namespace, JS file — two units in the same scope where A imports B but B does not import A)
4. Produce a single list of `(ecosystem, name, version, source)` tuples — the discovery output

### Step 2 — Enrichment [deterministic]

For each dependency in the discovery output, gather upstream data via general web search and the manifest itself:

- Latest published version
- Date of last release
- Deprecation notice (if any) on the upstream project
- License in the current version
- Recent major-version changelog highlights

The upstream metadata is the deterministic source of truth; label each finding's source as upstream-anchored or LLM-judgement.

### Step 3 — Doesn't-Earn-Its-Keep analysis [judgement]

For each dependency, apply the Category 1 rubric. Sub-criteria include:

- Trivial task (the dependency solves something a few lines of standard-library or built-in code could solve)
- Cost outweighs reward (size, build time, supply-chain surface)
- Dead code (declared in the manifest but no import references it)

Report the sub-criteria that fired and an overall tier per the tier-composition rule.

### Step 4 — Tightly-Coupled analysis [judgement]

For each dependency, examine the import graph to identify tight coupling: many call sites, deep reach into dependency internals, or application code that mirrors dependency types. Report an overall tier only. Apply the import-surface thresholds (5+ sites baseline; a higher relative percentage of the project's total files counts as wider).

### Step 5 — Unmaintained-Deprecated analysis [judgement]

For each dependency, evaluate the upstream signals gathered in Step 2:

- Long time since last release (default threshold: 12 months)
- Open deprecation notice
- Maintainer-issued end-of-life statement
- Repo archived

Report tier only, with rationale text naming the sub-criterion that fired.

### Step 6 — Recent-Major-Changes analysis [judgement]

For each dependency, identify recent major-version bumps and review their changelog for breaking changes that the project has not yet adopted. Report text only — no tier.

### Step 7 — Report [judgement]

Compose the final report per the output-form rules in the Guide: default to in-conversation prose with a concise summary at the top; write to a file (and print a pointer with path + finding count) when requested or when the report exceeds ~1000 words / ~15 findings; list the evidence consulted per finding; use each category's own report structure (Category 1 sub-criteria + tier, Category 2 tier only, Category 3 tier only with rationale, Category 4 text only).

## Validation

- [ ] Discovery enumerated all manifest-listed dependencies and applied the implicit-dependency rule per ecosystem
- [ ] Enrichment gathered upstream data for every dependency and labelled each finding's source
- [ ] Category 1 findings report sub-criteria labels and an overall tier per the tier-composition rule
- [ ] Category 2 findings report a tier only (no sub-criteria labels in the report)
- [ ] Category 3 findings report a tier only with rationale text naming the sub-criterion
- [ ] Category 4 findings are text only, no tier
- [ ] Every finding lists the evidence that materially supports it (no padding the trail)
- [ ] Output form matches the default (prose) or the file-on-request rule; file suggested when report exceeds ~1000 words or ~15 findings
- [ ] The report states v1 limits where they bind (no cross-checked replacements)
- [ ] Steps 1 and 2 are tagged deterministic; Steps 3-7 are tagged judgement
- [ ] The Guide at `references/dependency-review-guide.md` is loaded before Step 1
- [ ] The eval suite at `evals/dependency-review/` (when built) covers per-step tasks, per-category output structure, and end-to-end scenarios
