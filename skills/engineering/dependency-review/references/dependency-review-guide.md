# Dependency Review Guide

> Source of truth for the `dependency-review` skill. The Skill (in `SKILL.md`) is the only consumer. Each step in this guide is tagged `deterministic` (could in principle be mechanised) or `judgement` (LLM-only) — the tag signals to the agent what kind of step is in front of it. Update this Guide first when the workflow changes; then update the Skill.

## Scope

### In scope (code, default — `scope: code`)

- Package manifests (package.json, requirements.txt, pyproject.toml, pom.xml, *.csproj, Cargo.toml, go.mod, Gemfile, composer.json, etc.)
- Import-level code dependencies (language-level references in source files)
- Lockfile-resolved transitive dependencies (read-only, for discovery)

### In scope (non-code, opt-in — `scope: code,non-code`)

Adding the non-code tier to the scope flag adds:

- Operating system requirements
- Language runtimes and version managers
- Hosted services and SaaS dependencies
- Database engines
- CI tooling
- Third-party binaries

### Out of scope

- Organisational dependencies (which team owns a dependency, internal-only packages) — explicit exclusion
- Security and CVE scanning — use a dedicated vulnerability tool

## Output Form

The default output is the full report as in-conversation prose with a concise summary at the top. If the user's message or a flag passed to the skill asks for a file:

- Write the full report to a file
- Print a pointer in the conversation: file path + finding count

The "always file" path is rejected. File location and naming are deferred to the moment of request. The skill should suggest a file when the report exceeds ~1000 words or ~15 findings.

## Workflow

The workflow has seven numbered steps. Steps 1 and 2 are deterministic; Steps 3-7 are judgement. Load `references/worked-examples.md` on first report — the worked threshold examples for each tiered category live there.

### Step 1 — Discovery [deterministic]

**Goal**: produce a single, exhaustive list of `(ecosystem, name, version, source)` tuples for every third-party dependency the project actually uses.

**Inputs**: the project root.

**Procedure**:

1. **Ecosystem detection** — read the project root for manifest files. Common markers:
   - Node: `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
   - Python: `pyproject.toml`, `requirements.txt`, `setup.py`, `Pipfile`, `poetry.lock`
   - Java/Kotlin: `pom.xml`, `build.gradle`, `build.gradle.kts`
   - .NET: `*.csproj`, `*.fsproj`, `packages.config`
   - Rust: `Cargo.toml`, `Cargo.lock`
   - Go: `go.mod`, `go.sum`
   - Ruby: `Gemfile`, `Gemfile.lock`
   - PHP: `composer.json`, `composer.lock`
2. **Manifest read** — for each manifest, extract:
   - Direct dependencies (the top-level `dependencies`, `devDependencies`, etc.)
   - Where available, transitive dependencies (lockfile or resolved graph)
3. **Implicit-dependency detection (module-level)** — for each ecosystem, apply the "shares a unit + forward references" rule. A unit is two classes / modules / types / files that share an organisational scope; the rule fires when one references the other but the reverse is false. Per-ecosystem definitions:
   - **Java**: two classes in the same Java package (same `package` declaration)
   - **Python**: two modules in the same Python package (same directory containing `__init__.py`)
   - **.NET**: two types sharing a namespace (same `namespace` block, or full name path)
   - **JavaScript / TypeScript**: two files in the same module path (same folder, or explicitly declared module)
   Report these as implicit dependencies with the `source` set to `implicit-<ecosystem>`.

**Output**: a discovery list with one tuple per dependency. The `source` field records `manifest`, `lockfile`, or `implicit-<ecosystem>`.

### Step 2 — Enrichment [deterministic]

**Goal**: for each dependency, gather upstream metadata that the judgement steps will use.

**Inputs**: the discovery list.

**Procedure**: for each dependency, perform a structured web search (and, where available, read upstream package metadata directly) to collect:

- **Latest published version** — anchor for "is this current"
- **Date of last release** — anchor for "is this maintained"
- **Deprecation notice** — read the upstream README, CHANGELOG, or project page for an explicit deprecation statement
- **License in the current version** — read `LICENSE` or upstream metadata
- **Recent major-version changelog** — find the changelog for the most recent major version bump and extract the breaking-change summary

The deterministic source of truth is the upstream project itself, reached via structured web search.

**Source labelling**: every piece of data gathered here is upstream-anchored. The judgement steps must label every finding as `upstream-anchored` (the finding rests on data from Step 2) or `llm-judgement` (the finding rests on the LLM's reasoning over the data).

### Step 3 — Doesn't-Earn-Its-Keep analysis [judgement]

**Goal**: identify dependencies whose cost exceeds their value, or whose absence would not be felt.

**Sub-criteria** (Category 1):

- **Trivial task** — the dependency solves a problem that a few lines of standard-library or built-in code could solve. Examples: a date-formatting library used once for a single `YYYY-MM-DD` format; a UUID library used for a non-cryptographic identifier; a string-padding helper
- **Cost outweighs reward** — the dependency adds disproportionate size, build time, native-binary surface, transitive-dependency surface, or compile time relative to the value it delivers
- **Dead code** — declared in the manifest but not referenced by any import in the source tree (excludes transitive-only declarations, which are not the project's choice)

**Report structure**:

- The sub-criteria that fired (e.g., `trivial-task + cost-outweighs-reward`)
- A single overall tier (High / Medium / Low) per the tier-composition rule

### Step 4 — Tightly-Coupled analysis [judgement]

**Goal**: identify dependencies whose public API is being bypassed, mirrored, or absorbed into application code in ways that raise the cost of swapping or upgrading.

**Sub-criteria** (Category 2):

- **Wide import surface** — many distinct import statements touching the dependency across the source tree
- **Internal-API reach** — application code references types or functions not in the dependency's documented public API
- **Type mirroring** — application code defines types whose shape mirrors dependency types, suggesting the dependency's data model has leaked into the application

**Report structure**: tier only. No sub-criteria labels in the report; the rationale paragraph names what was found.

### Step 5 — Unmaintained-Deprecated analysis [judgement]

**Goal**: identify dependencies whose upstream signals indicate the project is no longer being maintained, or has been explicitly deprecated.

**Sub-criteria** (Category 3):

- **Long time since last release** — no release in the trailing 12 months (default; the LLM may override for a specific finding when ecosystem pace warrants)
- **Deprecation notice** — upstream README, CHANGELOG, or project page contains an explicit deprecation statement
- **End-of-life** — maintainer-issued end-of-life statement
- **Repo archived** — the source repository is marked archived on its hosting platform

**Report structure**: tier only. The rationale text names the sub-criterion that fired (e.g., "tier: High — sub-criterion: repo archived"). The sub-criterion is not a first-class label.

### Step 6 — Recent-Major-Changes analysis [judgement]

**Goal**: identify dependencies whose recent major-version bump includes breaking changes that the project has not yet adopted.

**Procedure**:

1. For each dependency, find the most recent major-version bump in the upstream history
2. Read the breaking-change summary for that bump
3. Compare the breaking changes to the project's actual usage of the dependency (the import graph from Step 4)
4. Report dependencies where the project has not yet adopted the new major version AND would be affected by the breaking changes

**Report structure**: text only. No tier. The text names the dependency, the upstream version, the breaking changes, and the migration impact.

### Step 7 — Report [judgement]

**Goal**: compose the final report.

**Structure**:

- **Summary** at the top: finding count, high-tier count, the most actionable finding
- **Category 1** — Doesn't-Earn-Its-Keep: sub-criteria + tier per dependency
- **Category 2** — Tightly-Coupled: tier only per dependency
- **Category 3** — Unmaintained-Deprecated: tier only with rationale per dependency
- **Category 4** — Recent-Major-Changes: text only per dependency

**Output form**:

- Default: full report as in-conversation prose with the summary at the top
- File-on-request: write to file, print pointer (path + finding count) in conversation
- Size threshold: when the report exceeds ~1000 words or ~15 findings, suggest a file to the user

**Evidence trail**: each finding lists the evidence consulted — manifest data, upstream changelog data, import-graph data — without an aggregate confidence label. List only the evidence that materially supports the finding; padding the trail with irrelevant lookups is a violation of the evidence-trail quality rule.

## Tier Composition

The tier for a finding is computed from sub-criteria per the following rules:

- Any sub-criterion at **High** forces the overall tier to at least **Medium**
- Two or more fired sub-criteria force the overall tier **up one notch** from the highest individual sub-criterion tier
- Single sub-criterion at Low → overall Low; single at Medium → overall Medium

These are the only tier-composition rules. Without them, the LLM produces inconsistent overall tiers across runs. The rules are auditable through the resulting finding.

## Override Policy

The LLM may override a rubric threshold for a specific finding when the context warrants. Constraints:

- Overrides change the finding's outcome only (e.g., from Low to High, or from a recommendation to "monitor" to "switch")
- Overrides do **not** add explanatory prose to the report
- The canonical pattern is two criteria compounding to produce a finding neither alone would produce: short time-since-last-release + deprecated status = recommend switching, even though neither criterion alone would trip a threshold

The rubric is the default; overrides are the only departure, and they are auditable through the resulting finding.
