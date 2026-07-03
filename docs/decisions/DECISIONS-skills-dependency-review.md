# Decision Ledger — dependency review skill

### [D001] — scope of "dependency"

- **Resolved Answer**: "Code first, Option 2 is opt in."
- **Normalized Requirement**: Code artefacts (package manifests + import-level code dependencies) shall always be in scope. Non-code dependencies on external software/infra (OS, runtimes, hosted services, databases, CI tooling, third-party binaries) shall be opt-in via a scope flag passed to the skill. Organisational dependencies are out of scope.
- **Constraints**: The "organisational dependencies" tier (Option 3 from D001) is explicitly excluded. The opt-in flag must be discoverable from the skill's "When to Use" section.

### [D003] — CLI surface

- **Resolved Answer**: CLI is deferred; ship the Skill + Guide first, build the CLI later. The user's original phrasing: "Does it make sense to start with the Guide and the Skill and then develop the CLI from it later?"
- **Normalized Requirement**: The skill shall ship without a CLI. The CLI is a future artefact; the Guide shall be designed to make deterministic pieces extractable into a CLI without rewriting the workflow.
- **Constraints**: The deferred CLI is to be re-opened as a new branch when the deterministic gaps in the Skill-only path are documented. The Skill is the only shipping artefact for now.

### [D002] — output form

- **Resolved Answer**: "Option 3 - It fits the previously decided mapping." (Mapping: "Just Skill -> LLM drafts report as output text by default (if user message asks for file then LLM can create report file) with a concise summary at the beginning. No CLI.")
- **Normalized Requirement**: The skill shall draft the full report as in-conversation prose with a concise summary at the top by default. If the user's message (or a flag passed to the skill) asks for a file, the skill shall write the full report to a file and print a pointer (path + finding count) in the conversation.
- **Constraints**: The "always file" path (Option 4 from D002) is explicitly rejected. The file location and naming convention are deferred to the moment the user requests a file. The skill should suggest writing a file when the report exceeds a size threshold at which inline prose becomes unwieldy.

### [D005] — trigger shape

- **Resolved Answer**: "Option 2 is what I described in my prior comment about when the skill" (referring to the original "user invocable AND agent runnable" requirement).
- **Normalized Requirement**: The skill shall activate on explicit user request, and an LLM agent may also load it when it judges the current task touches dependency health, even without explicit naming. The "When to Use" section of `SKILL.md` is the trigger definition and must be specific enough to bound relevance.
- **Constraints**: Event-driven triggers (Option 3 from D005) and combined triggers (Option 4) are deferred. The "When to Use" section is the sole trigger; the skill does not run on a schedule or hook.

### [D006] — v1 scope

- **Resolved Answer**: "Option 2 seems the most feasible. Cross-checked recommendations would be more complex in implementation."
- **Normalized Requirement**: v1 shall ship discovery (features 1, 2) and the five finding categories (features 3, 4, 5, 6). v1 shall not name specific cross-checked replacement alternatives (feature 7); the skill surfaces "this dependency looks problematic" without proposing a drop-in replacement. v2 shall add cross-checked alternatives once v1 usage has shown which ecosystems matter.
- **Constraints**: Feature 7 (cross-checked recommendations) is deferred to v2. The v1 report must be honest about what it does not yet know — the skill states that replacement suggestions are out of scope for v1 rather than providing weak or unverified alternatives.

### [D007] — workflow structure

- **Resolved Answer**: "Option 3 - Six steps isn't too many for an LLM and breaking it down means it's less likely to muddle multiple sub-steps together or otherwise not follow the instructions correctly. There is a point of diminishing returns to this - an LLM may skip portions of infinitely long list, but 6 steps is not that point."
- **Normalized Requirement**: The skill workflow shall be seven numbered steps (the original "Six" was a counting error in the option label — the breakdown Discovery + Enrichment + 4 finding categories + Report is seven): Step 1 Discovery (deterministic), Step 2 Enrichment (deterministic), Step 3 Doesn't-Earn-Its-Keep analysis (judgement), Step 4 Tightly-Coupled analysis (judgement), Step 5 Unmaintained-Deprecated analysis (judgement), Step 6 Recent-Major-Changes analysis (judgement), Step 7 Report (judgement). Each step is a single, focused unit; an LLM agent can follow the seven steps without muddling sub-steps.
- **Constraints**: Discovery and Enrichment are separate steps (not collapsed). The four finding categories (3, 4, 5, 6 from the original spec) each get their own step. Report is the final step. The total count is at the upper edge of the diminishing-returns threshold the user named; future additions should be folded into existing steps or justified explicitly.

### [D004] — build order

- **Resolved Answer**: "Option 1 with the Guide design tag system specified (tag as deterministic for future CLI extraction or 'judgement' (LLM only)."
- **Normalized Requirement**: The build shall proceed in this order: (1) write the Guide, (2) write the Skill against the Guide, (3) use on real projects, (4) extract the tagged deterministic steps into a CLI when the gap warrants. Each step in the Guide shall be tagged `deterministic` (future-CLI extractable) or `judgement` (LLM-only); the tag is the seam the future CLI cuts along.
- **Constraints**: The Guide is the source of truth for the workflow. The Skill is a consumer of the Guide. The CLI, when built, is also a consumer of the same Guide. No step may be tagged ambiguously; if a step is mixed, it must be split.

### [D008] — enrichment method

- **Resolved Answer**: "Option 2 makes sense. Option 3 re-litigates the cross-checking deferred to v2."
- **Normalized Requirement**: Step 2 Enrichment shall use the project's manifest plus general web search to gather upstream data (latest version, last release date, deprecation notice, license in current version, recent major-version changelog) for each dependency. The skill shall not introduce per-ecosystem tooling in v1; that surface is owned by the v2 cross-checked-recommendations feature.
- **Constraints**: The deterministic tag on Step 2 is honoured by structured web search (the LLM extracts from the deterministic source of truth — upstream package metadata). The skill must be explicit in the report about which findings are anchored in upstream data and which are LLM judgement. Per-ecosystem tooling is owned by v2; introducing it in v1 would re-litigate the cross-checking decision deferred by D006.

### [D009] — judgement criteria calibration

- **Resolved Answer**: "Option 3 but we need to be restrictive on allowing overrides - Overrides don't add additional content to the report - They should just change the finding of specific results for specific tests e.g. short period of time but marked as deprecated = recommend switching dependency, etc."
- **Normalized Requirement**: Steps 3-6 analysis shall use a structured rubric with example thresholds (deterministic baseline) and the LLM may override a threshold for a specific finding when the context warrants. Overrides shall be restricted to changing the finding's outcome for a specific dependency; they shall not add explanatory prose to the report. The canonical pattern is two criteria compounding to produce a finding neither alone would produce (e.g., short time-since-last-release + deprecated status = recommend switching, even though neither criterion alone would trip a threshold).
- **Constraints**: Overrides do not add new content to the report; the report must be self-explanatory through the finding itself, not through override annotations. The structured rubric (example thresholds + qualitative guidance) is in the Guide; the LLM's overrides are the only departure from the rubric, and they are auditable through the resulting finding.

### [D010] — severity and prioritisation

- **Resolved Answer**: "Option 2 though we need to determine the criteria for each section."
- **Normalized Requirement**: Each finding shall carry a three-tier severity label (High / Medium / Low). The criteria for each tier are not yet finalised in this ledger entry — they are a follow-up branch (D011).
- **Constraints**: The tier criteria must be observable and category-specific (deferred to D011). The Guide is the authoritative source for tier definitions; the LLM does not invent severity in the moment.

### [D011] — severity criteria structure

- **Resolved Answer**: "Per category criteria although some categories may benefit from not following the tier system. So we need to examine each category on a case by case basis to determine the criteria or if the category should avoid the Tier system and use a text based approach without ranking."
- **Normalized Requirement**: Severity criteria shall be per-category rather than uniform across all four finding categories. Some categories may opt out of the tier system and use a text-based approach without ranking; the per-category examination is the follow-up branch (D012).
- **Constraints**: `Superseded by D013 and D014.` A uniform tier definition was rejected; each of the four finding categories is examined individually for whether tiers or text-based reporting fits best.

### [D012] — per-category tier structure (initial)

- **Resolved Answer**: "Per category criteria although some categories may benefit from not following the tier system. So we need to examine each category on a case by case basis to determine the criteria or if the category should avoid the Tier system and use a text based approach without ranking." (Same response as D011; the user wanted per-category examination before committing.)
- **Normalized Requirement**: Each finding category shall be examined individually to determine whether the tier system applies or whether a text-based approach is more appropriate. The per-category decision is the follow-up branch (D014).
- **Constraints**: `Superseded by D014.` The initial D012 question was reopened after D013 surfaced the sub-criteria + tier pattern; D014 records the per-category resolution.

### [D013] — Category 1 sub-criteria + overall tier

- **Resolved Answer**: "Option 1 sounds like a good compromise between too little information and too much on Category 1."
- **Normalized Requirement**: Each finding in Category 1 (Doesn't-Earn-Its-Keep) shall report (a) the sub-criteria that fired (e.g., "trivial-task + cost-outweighs-reward") and (b) a single High/Medium/Low overall tier. The two dimensions are independent — sub-criteria answer "which kind of badness," tier answers "how bad."
- **Constraints**: The tier-composition rule (how sub-criteria tiers roll up to an overall tier) must be specified in the Guide, e.g., "any sub-criterion at High forces the overall tier to at least Medium; two or more fired sub-criteria forces the overall tier up one notch from the highest individual." Without an explicit rule, the LLM produces inconsistent overall tiers across runs.

### [D014] — per-category tier structure (revisited)

- **Resolved Answer**: "For category 3 specifically: Option 1. Category 1 sub-criteria + tier, Category 2 tier only, Category 4 - Text only" (Category 3 is Option 1 = tier only; rationale text names which sub-criterion fired).
- **Normalized Requirement**: The four finding categories shall have category-specific report structures: Category 1 (Doesn't-Earn-Its-Keep) sub-criteria labels + overall tier (per D013); Category 2 (Tightly-Coupled) tier only; Category 3 (Unmaintained-Deprecated) tier only with rationale text naming the sub-criterion; Category 4 (Recent-Major-Changes) text-based, no tier.
- **Constraints**: The Report step (Step 7) shall present each category in its own structure with a clear header per category; the report is not a single severity-sorted list across all categories. Category 3's tier-only structure means sub-criteria (deprecated-notice vs. stale-no-recent-activity) are conveyed in the rationale text, not as first-class labels — accepted trade-off for keeping the report less dense.

### [D015] — confidence (evidence trail)

- **Resolved Answer**: "Option 3 makes sense and can be judged by the user."
- **Normalized Requirement**: Each finding shall list the sources of evidence the LLM consulted (manifest data, upstream changelog data, import-graph data, etc.) without an aggregate confidence label. The user reads the evidence and judges confidence themselves.
- **Constraints**: The Guide must specify a minimum-quality rule for the evidence trail (e.g., "list only the evidence that materially supports the finding, not every lookup performed") to prevent the LLM from padding the trail with irrelevant lookups. The evidence trail is the audit trail; no aggregate confidence label is added on top.

### [D016] — implicit-dependency detection

- **Resolved Answer**: "Option 2 works for now but Option 3 should be documented for future consideration in v2 or a possible v3."
- **Normalized Requirement**: Step 1 Discovery shall include module-level implicit-dependency detection (the LLM reads the source to find classes/modules that share a unit — Java package, Python module, .NET namespace, JS file — and are coupled by forward references: A uses B, B doesn't use A). The LLM reports these as implicit dependencies. Broader implicit-dep patterns (reflection-based, convention-based) are out of scope for v1 and documented as future work for v2 or v3.
- **Constraints**: v1 implements module-level only. The Guide must define "shares a unit" per ecosystem (Java package, Python module, .NET namespace, JS file) so the LLM applies an explicit rule, not a vibe. Reflection-based and convention-based implicit-dep detection are explicitly out of scope for v1 and noted as deferred in the Guide.

### [D017] — category and skill name

- **Resolved Answer**: "Option 1 aligns more closely for a skill that that is either user triggered or agent triggered."
- **Normalized Requirement**: The skill shall live at `skills/engineering/dependency-review/`. The skill's name in frontmatter and directory is `dependency-review`.
- **Constraints**: The engineering category is the right home for code-analysis skills. The name is reserved against future overlapping skills (per the forward risk in D017).

### [D018] — eval suite structure

- **Resolved Answer**: "Option 4 makes the most sense - Per step tasks without end to end testing amounts to wishful thinking/hoping that it must work out alright if everything separately works by itself."
- **Normalized Requirement**: The eval suite at `evals/dependency-review/` shall be a mixed structure: per-step tasks for the deterministic pieces (Step 1 Discovery, Step 2 Enrichment) and per-category output structure validation (Categories 1-4 per D014), plus end-to-end scenarios that test the full workflow integration. The two parts must be kept aligned — every end-to-end task shall be decomposable into the per-step tasks it covers.
- **Constraints**: The eval suite's per-step and end-to-end parts must be reviewed together when either changes. A regression in a per-step task with no corresponding end-to-end scenario is a coverage gap to surface. Per-step tasks without end-to-end coverage are insufficient (per the user's reasoning); end-to-end tasks without per-step coverage are insufficient.
