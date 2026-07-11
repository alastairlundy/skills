# Decision Ledger — code-implementation-grilling skill token efficiency

This ledger records the triage decisions for the 15 token-efficiency opportunities
identified in the OCPM session (see `session-ses_0b73.md`). Each `Dxxx` is a
single triage (Address / Defer / Ignore / Different fix). "Address" rows will be
drilled into in subsequent branches to specify the exact skill change.

## Triage records

### [D001] — Triage: options block format (2–4 options × 4 fields)

- **Resolved Answer**: "Address"
- **Normalized Requirement**: The code-implementation-grilling skill's options block format shall be redesigned to reduce the per-question token cost while preserving the user's ability to discriminate between options.
- **Constraints**: The change is for v1 of the skill (not deferred). The four-field shape (What it is / Benefit / Cost / Risk) may be condensed but the user must still be able to compare options without reading the source code.

### [D002] — Triage: recommendation block (Reasoning + Forward risk)

- **Resolved Answer**: "Address"
- **Normalized Requirement**: The code-implementation-grilling skill's recommendation block shall be redesigned to reduce the per-record token cost while preserving the verbatim-name rule.
- **Constraints**: The change is for v1 of the skill. The verbatim-name rule from `recommendation-format.md` (line 14–18) must be preserved. The user's read pattern (read the recommendation, not the four fields) is the design constraint.

### [D003] — Triage: reference file loading pattern

- **Resolved Answer**: "Address"
- **Normalized Requirement**: The code-implementation-grilling skill's reference file loading shall be changed from "load all 6 references upfront" to a more selective pattern, since most references are not re-read in a typical session.
- **Constraints**: The change is for v1 of the skill. The pre-flight check (verify all 6 references exist) from `grilling/SKILL.md` (line 36–50) shall be retained. The skill must still guarantee the formats are applied verbatim when used.

### [D004] — Triage: Cites accumulation (5–12 references per T-record)

- **Resolved Answer**: "Defer"
- **Normalized Requirement**: Cites accumulation is acknowledged but not addressed in the v1 skill revision. The Cites line remains explicit and non-hierarchical.
- **Constraints**: A v2 skill revision may introduce an `Inherits:` or `Cites-Transitive:` mechanism. Any v1 record's `Cites:` line must remain human-readable without inheritance, and the user must be able to walk the constraint graph by hand.

### [D005] — Triage: ledger re-reads (~17 partial reads per session)

- **Resolved Answer**: "Address"
- **Normalized Requirement**: The code-implementation-grilling skill shall be updated to reduce the number of ledger partial re-reads. The agent currently re-reads the ledger's tail ~17 times per session to find the next append point.
- **Constraints**: The change is for v1 of the skill. The agent must still verify the ledger's on-disk state before writing (the next-append offset is held in memory but the file is re-read at session start to pick up changes by other processes).

### [D006] — Triage: re-shaped context preambles (D037 explained 9 times)

- **Resolved Answer**: "Address"
- **Normalized Requirement**: The code-implementation-grilling skill's TDP-opening "Re-shaped context." preambles shall be eliminated or condensed. The current pattern repeats the same D037 facts across multiple TDPs; a v1 contributor should be able to understand the current state from a TDP's preamble alone without re-reading prior TDPs.
- **Constraints**: The change is for v1 of the skill. The preamble may be condensed to a one-line "current state" pointer that cites the relevant prior record by ID; the TDP-specific context is inlined separately.

### [D007] — Triage: implementation blueprint (9.6 KB, re-derives ledger)

- **Resolved Answer**: "Address"
- **Normalized Requirement**: The code-implementation-grilling skill's Implementation Blueprint shall be shortened. The current shape re-derives ~80% of the technical statements from the ledger in prose form; the blueprint should cite the ledger without restating the technical choices in prose.
- **Constraints**: The change is for v1 of the skill. The blueprint's role as a "Context Pointer" (per `output-selection.md`) must be preserved. The `## Scope Binding` section and the inline `filename#<Dxxx|Txxx>` citations must still be present.

### [D008] — Triage: "Per the skill..." self-talk (workflow re-derivation per turn)

- **Resolved Answer**: "Ignore"
- **Normalized Requirement**: The "Per the skill..." self-talk is not a real problem; the workflow re-derivation per turn is intrinsic to the agent's reasoning and the token cost is part of the skill's design.
- **Constraints**: None.

### [D009] — Triage: locked question format (template repeated 25+ times)

- **Resolved Answer**: "Ignore"
- **Normalized Requirement**: The locked question format's per-question repetition is not a real problem; the template's stability is a feature (per `locked-question-format.md` line 9, "the format is locked because it makes the question unmistakable") and the per-question cost is intrinsic.
- **Constraints**: None.

### [D010] — Triage: convergence test execution (not run at end of OCPM session)

- **Resolved Answer**: "Address"
- **Normalized Requirement**: The code-implementation-grilling skill shall be updated to require the 4-check convergence test to be run at the end of every session, not just at the user's request. The OCPM session did not run the convergence test at the end and the session closed with a Part B question pending.
- **Constraints**: The change is for v1 of the skill. The 4 checks (all branches resolved, no contradictions, no new question in last 3 turns, Decision Ledger complete) per `convergence-test.md` remain unchanged.

### [D011] — Triage: re-ask cycles (3 re-asks of T011, zero output)

- **Resolved Answer**: "Address"
- **Normalized Requirement**: The code-implementation-grilling skill shall be updated to handle re-ask cycles more efficiently. The T011 shebang cycle consumed 3 full Q&A exchanges to produce zero ledger output; the skill should provide an explicit "close this branch without a record" pattern that does not require the agent to ask the question first.
- **Constraints**: The change is for v1 of the skill. The user must still be allowed to push back on options. A "close without record" pattern shall produce a `Dxxx` (or `Txxx`) record that documents the closure, not silent skip.

### [D012] — Triage: T014/T015 stale cite chain after D037 supersede

- **Resolved Answer**: "Defer"
- **Normalized Requirement**: The T014/T015 stale cite chain (caused by D037 supersede without T014a/T015a re-record) is acknowledged but not addressed in the v1 skill revision. A v2 skill revision may add a "re-record stale records" pattern to the re-open protocol.
- **Constraints**: Any T-record that supersedes a prior record's assumption shall still be cross-checked against the prior record's `Cites:` line. The next-record ID is incremented from the highest existing, with no gaps; if T011-style "closed without record" is added (D011), the gap rule is preserved.

### [D013] — Triage: out-of-session D030–D036 verification gap

- **Resolved Answer**: "Defer"
- **Normalized Requirement**: The out-of-session D030–D036 verification gap (agent cites records it did not help produce) is acknowledged but not addressed in the v1 skill revision. A v2 skill revision may add a "verify out-of-session decisions before citing" step to the session start.
- **Constraints**: The agent must still cite out-of-session records by ID in the current session. The deferral does not change the rule that `Cites:` lines shall be human-readable without re-verification.

### [D014] — Triage: tone prohibitions (forbidden words, "scan before submit" rule)

- **Resolved Answer**: "Defer"
- **Normalized Requirement**: The tone prohibitions (forbidden words list, "scan before submit" rule, ~200 tokens of pre-loaded material) are acknowledged but not addressed in the v1 skill revision; the rules are kept as-is.
- **Constraints**: The forbidden-words list in `tone-and-output.md` (lines 60–67) is unchanged. The "Professional Minimalist style" guidance (lines 80–88) is unchanged.

### [D015] — Triage: tool call frequency (35 edits, 20 reads, 10 webfetches)

- **Resolved Answer**: "Defer"
- **Normalized Requirement**: The tool call frequency is acknowledged but not addressed in the v1 skill revision. The per-call overhead is intrinsic to the agent's workflow and not a skill-design problem.
- **Constraints**: A v2 skill revision may add a "batch tool calls where independent" guideline. v1 keeps the per-call workflow as-is.

## Drill-down: design choices for the Address items

### [D016] — Options block format design (drill-down of D001)

- **Resolved Answer**: "Option 3 - The 4 fields are sufficient but the sentence requirement needs enforcing"
- **Normalized Requirement**: The code-implementation-grilling skill's options block format shall keep the 4-field shape (What it is / Benefit / Cost / Risk) but enforce the "one sentence per field" rule from `options-format.md` (line 17) via a strict per-field check (per-field word cap or sentence-count check) applied at write time or in CI; the existing rule is currently broken on most turns.
- **Constraints**: The 4-field shape is unchanged. The per-field cap is the mechanism, not a new field. The complex-option risk (a branch with 4 sub-decisions) is mitigated by promoting complex options to separate branches per the existing format guidance. A v1.2 contributor adding a sub-question to a branch already at the cap must split the branch, not break the rule.
- **Cites**: D001 (triage: options block format → Address), `options-format.md` line 17 (the existing rule that is being enforced).

### [D017] — Recommendation block design (drill-down of D002)

- **Resolved Answer**: Option 4 — drop Forward risk AND enforce Reasoning length (1–2 sentences)
- **Normalized Requirement**: The code-implementation-grilling skill's Recommendation block shall consist of two fields: Recommendation (with the verbatim-name rule preserved) and Reasoning (1–2 sentences enforced via a strict cap); the Forward risk field is removed from the block; risk articulation lives in the option's own Risk field or in Reasoning.
- **Constraints**: The verbatim-name rule on the first line (recommendation-format.md lines 14–18) is sacred and not negotiable. The 1–2 sentence cap on Reasoning is enforced. Forward risk is removed with no fallback field. The v1.2 contributor who needs to surface a failure mode must do so in the option's Risk field or in Reasoning, not by re-introducing Forward risk.
- **Cites**: D002 (triage: Recommendation block → Address), `recommendation-format.md` lines 14–18 (verbatim-name rule), sub-agent evidence D002 (Forward risk is "speculative noise in 90% of cases" and the user never engages with it).

### [D018] — Reference file loading design (drill-down of D003)

- **Resolved Answer**: "Eager load the first 4. Load the Tone and Output reference on demand. Convergence test should be loaded on demand once convergence is believed to have been reached."
- **Normalized Requirement**: The code-implementation-grilling skill shall adopt a hybrid reference-loading policy expressed in a per-skill manifest (file format TBD in a sub-decision). Classifications:
  - **Eager (load at session start)**: the 4 always-used references (recording-decisions.md, interface-and-model-branch.md, output-selection.md, and the format-check reference)
  - **Lazy (load on demand when a tone/style question arises)**: tone-and-output.md
  - **Lazy (load on demand once convergence is believed to have been reached)**: convergence-test.md
  The policy is per-reference explicit so a v1.2 contributor adding a new reference has to fill in the load policy; the default is no-load (contributor must opt in).
- **Constraints**: The 4 always-used references stay eager (zero trigger overhead). The 2 occasional references are lazy with specific triggers. The manifest makes the policy explicit. A v1.2 contributor adding a new reference must specify `eager` or `lazy (trigger: X)`; the default is no-load.
- **Cites**: D003 (triage: reference loading → Address), sub-agent evidence D003 (4 always used, 1 checked once, 1 never used — applied as a template for the code-implementation-grilling skill's 5 references), user's explicit per-reference classifications.

### [D019] — Ledger re-reads design (drill-down of D005)

- **Resolved Answer**: "Option 2 - Though grilling's ledger reference needs to be updated to effect this."
- **Normalized Requirement**: The ledger file shall end with a sentinel comment `<!-- next-id: Dxxx -->` that the agent reads via a single-line `read` or `grep` to find the append point, instead of re-reading the whole ledger. The sentinel update must be atomic with the record write (same `edit` call) or the agent must verify the sentinel before the next write to prevent ID collision. The change applies to all skills that use the ledger pattern and requires:
  - Updating the code-implementation-grilling skill's guidance (recording-decisions.md or equivalent)
  - Updating the parent `grilling` skill's `references/decision-ledger.md` to document the sentinel pattern as the standard ledger convention
- **Constraints**: The ledger is the source of truth; the sentinel is part of the file. The sentinel-update must be atomic with the record write. Cross-session resumption is automatic. This is a cross-skill change, not just the code-implementation-grilling skill.
- **Cites**: D005 (triage: ledger re-reads → Address), sub-agent evidence D005 (3 re-reads × ~1K tokens = ~3K tokens), user's clarification (parent grilling skill's ledger reference must also be updated to effect the change).

### [D020] — Re-shaped context preambles design (drill-down of D006)

- **Resolved Answer**: "Option 2 but softened to allow up to 2 sentences. The specific example given within Option 2 is just an example and need not be encoded into the skill update"
- **Normalized Requirement**: The code-implementation-grilling skill's preambles shall be condensed to ≤2 sentences per question, citing prior records by ID (e.g., "Context: per D019, ledger re-reads cost ~3K tokens; goal is single-line sentinel lookup."), leveraging the ledger pattern from D019. The agent may use 1 sentence for a simple question (ID reference only) or 2 sentences for a complex question (ID reference + the specific constraint or discriminator). The exact wording of any example is illustrative only; the rule is the length cap (≤2 sentences) and the ID-citation requirement, not a verbatim sample.
- **Constraints**: ≤2 sentences per preamble. ID-citation is required. No verbatim example is encoded in the skill; the format is the rule, not a sample. The 1-vs-2-sentence flexibility lets complex questions establish context without breaking the cap.
- **Cites**: D006 (triage: re-shaped context preambles → Address), sub-agent evidence D006 (T003/T004/T005 each had 218–244 words of preamble, ~2,250 tokens total), D019 (sentinel pattern; prior decisions live in the ledger so preambles cite by ID), user's clarification (≤2 sentences; example is illustrative).

### [D021] — Implementation Blueprint design (drill-down of D007)
- **Resolved Answer**: Option 4 — drop per-branch blueprints; write one consolidated implementation plan at the end of the grilling covering all 8 Address items.

- **Normalized Requirement**: The code-implementation-grilling skill shall drop per-branch Implementation Blueprints from inline output. Instead, the agent writes a single consolidated `IMPLEMENTATION-PLAN.md` (or appends a "Consolidated Implementation Plan" section to the ledger) at the natural endpoint of the grilling — after the 8th Address item is resolved — listing every file change across all Address items. The consolidated plan shall group changes by file so a single-file change is a single section; a v1.2 contributor applying one branch at a time can extract their change.
- **Constraints**: Per-branch blueprints are dropped from inline output. The consolidated plan is automatic at the endpoint. The consolidated plan groups changes by file for selective extraction. The D-records in the ledger remain the source of truth for per-branch verification.
- **Cites**: D007 (triage: Implementation Blueprint → Address), sub-agent evidence D007 (195–203 words per blueprint, ~2,500 tokens total, user reads 0% of inline blueprints).

### [D022] — Convergence test design (drill-down of D010)

- **Resolved Answer**: (a) Approve the 4 universal bullets as written; (b) end-of-grilling test uses the 4 bullet points but also checks that all D records fit together and don't internally contradict.
- **Normalized Requirement**: The code-implementation-grilling skill's convergence test shall retain the multi-bullet checklist format (per `convergence-test.md`) but replace the bullet content with universal questions that work across different repositories. The test runs at two points with different bullet counts:
  1. **Per-item (after each Address item is resolved)**: 4 universal bullets:
     1. **Implementability** — Can a new contributor apply the change from the D-record + Cites alone (without re-asking the originating user)?
     2. **Enforceability** — Are the Constraints checkable by an objective mechanism (write-time, CI, lint, or external test) rather than relying on agent judgment?
     3. **Internal consistency** — Does the change preserve all cited prior records' Constraints (i.e., nothing in the new D-record contradicts a cited Dxxx)?
     4. **Format compliance** — Is the new content under the format caps defined in the relevant format references (per-field sentence cap, preamble length cap, etc.)?
  2. **End-of-grilling (after the last Address item is resolved)**: the same 4 bullets PLUS a 5th bullet:
     5. **Cross-record consistency** — Do all N D-records fit together without internal contradictions (i.e., the consolidated design is self-consistent, not just each record in isolation)?
- **Constraints**: Format (multi-bullet checklist) is retained; bullet content is replaced. Bullets are universal — no specific D-record IDs, no specific skill name, no specific version number. Per-item test runs after each Address item (8 runs). End-of-grilling test runs once after the last Address item.
- **Cites**: D010 (triage: convergence test execution → Address), `convergence-test.md` lines 8–14 (existing 4-bullet format; 3 of 4 bullets are tautological/impossible per D010), user's clarifications (universal framing; run at two points; end-of-grilling adds a cross-record consistency check).

### [D023] — Re-ask cycles design (drill-down of D011)

- **Resolved Answer**: "Re-ask once then close, The re-ask must explicitly state that this is the final re-ask and the question will be closed without an answer."
- **Normalized Requirement**: The code-implementation-grilling skill's re-ask cycle shall be capped at 1 re-ask (max 2 total attempts per T-record question). The re-ask must explicitly state, in its preamble, that this is the final re-ask and that the question will be closed without an answer if a clear answer is not provided. If the second response is still not a clear T-record answer, the agent writes a closure D-record (status: closed without resolution) and moves to the next item. The "When Not to Use" section shall explicitly say "do not use this skill for questions that require back-and-forth clarification — use the `ask-questions` skill instead."
- **Constraints**: Max 2 total attempts (1 initial + 1 re-ask). The re-ask preamble must include the explicit "final re-ask" warning. Closure produces a D-record (status: closed without resolution), not silence. Questions that need back-and-forth clarification are out of scope.
- **Cites**: D011 (triage: re-ask cycles → Address), sub-agent evidence D011 (T011 re-asked 3 times with zero output, ~600 tokens), user's clarification (1 re-ask with explicit final-re-ask warning, closure as D-record).

### [D024] — Manifest file format (sub-decision of D018)

- **Resolved Answer**: Option 4 — inline in `SKILL.md` prose under a "References" section. Reason: introducing YAML frontmatter change risks breaking `SKILL.md` compatibility and causing issues with the skill.
- **Normalized Requirement**: The code-implementation-grilling skill's reference-loading manifest shall be inline in the `SKILL.md` prose under a "References" section. Each reference is listed with its path and load policy (eager or lazy with explicit trigger). The format is human-readable prose, not machine-readable. The trade-off: CI validation, if desired, must use a prose parser; the `SKILL.md` frontmatter is unchanged from the existing `name` / `description` / `license` keys.
- **Constraints**: No YAML frontmatter changes. The manifest is prose, not machine-readable. The "References" section lives in the `SKILL.md` body, not the frontmatter. A v1.2 contributor adding a new reference must update the "References" section in the same edit as adding the reference file.
- **Cites**: D018 (sub-decision of manifest format), user's clarification (frontmatter compatibility risk; no YAML changes).

### [D025] — Cross-skill update location (sub-decision of D019)

- **Resolved Answer**: Option 1 — update the "Real-time appending" section to mention the sentinel
- **Normalized Requirement**: The parent `grilling` skill's `references/decision-ledger.md` shall be updated by modifying the "Real-time appending" section (line 30–37) to document the sentinel pattern. The current append-ID mechanism shall be replaced with text that mentions: the ledger file ends with `<!-- next-id: Dxxx -->`; the agent reads the sentinel (a single line) to find the append point; the sentinel update is atomic with the record write; if the sentinel is missing or out of sync, fall back to scanning the file. The change affects all skills that use the ledger pattern.
- **Constraints**: No new section; no template change. The fallback to scanning preserves compatibility with existing ledger files without a sentinel. The change is centralized in one section. The change applies to the canonical path in the skills repo (not the installed `.agents/skills/` mirror).
- **Cites**: D019 (sub-decision of cross-skill update location), user's clarification (Option 1).

## Consolidated Implementation Plan

**Convergence:** all 8 Address items resolved (D016–D023), 2 sub-decisions resolved (D024, D025). End-of-grilling 5-bullet test passed after gap resolution. Per D022, this consolidated plan serves as the "all items resolved" marker.

**Order:** apply in the order listed (1 → 7). Item 1 is the foundation; items 2–6 are reference updates; item 7 is the `SKILL.md`.

### 1. Parent `grilling` skill — `references/decision-ledger.md`

- **Update the "Real-time appending" section (line 30–37)** to mention the sentinel pattern.
- **Replace** the current append-ID mechanism with: the ledger file ends with `<!-- next-id: Dxxx -->`; the agent reads the sentinel (a single line) to find the append point; the sentinel update is atomic with the record write; if the sentinel is missing or out of sync, fall back to scanning the file.
- **Path:** canonical location in skills repo (not the installed `.agents/skills/` mirror).
- **Cites:** D019, D025.

### 2. code-implementation-grilling — `references/options-format.md`

- **Add a per-field sentence cap mechanism** to the "one sentence per field" rule (line 17).
- **Mechanism:** per-field word cap (e.g., 20 words per field) or sentence-count check (max 1 sentence per field), applied at write time or in CI.
- **Cites:** D016.

### 3. code-implementation-grilling — `references/recommendation-format.md`

- **Remove the Forward risk field**; enforce 1–2 sentence cap on Reasoning.
- **Preserve** the verbatim-name rule on the first line (lines 14–18) — sacred and not negotiable.
- **Cites:** D017.

### 4. code-implementation-grilling — `references/convergence-test.md`

- **Replace the 4 existing bullets** with the 4 universal bullets (Implementability, Enforceability, Internal consistency, Format compliance). Add a 5th bullet (Cross-record consistency) for the end-of-grilling run only.
- **Cadence:** per-item (4 bullets, 8 runs) + end-of-grilling (4 + 1 bullets, 1 run).
- **Cites:** D022.

### 5. code-implementation-grilling — `references/output-selection.md`

- **Add a preamble format cap:** ≤2 sentences per preamble; ID-citation required.
- **Flexibility:** 1 sentence for simple questions (ID reference only); 2 sentences for complex questions (ID + constraint or discriminator).
- **Cites:** D020.

### 6. code-implementation-grilling — `references/recording-decisions.md`

- **Update to reference the sentinel pattern** (per changes to parent `decision-ledger.md` in item 1).
- **Note:** the sentinel is documented in the parent reference; this file just points to it.
- **Cites:** D019.

### 7. code-implementation-grilling — `SKILL.md`

- **Add a "References" section** with the inline manifest: each reference listed with its path and load policy (eager or lazy with explicit trigger). (D018, D024)
- **Drop the per-branch Implementation Blueprints** from the workflow; replace with: "the agent writes a single consolidated `IMPLEMENTATION-PLAN.md` (or appends a 'Consolidated Implementation Plan' section to the ledger) at the natural endpoint of the grilling." (D021)
- **Update the convergence test step** in the workflow: per-item test after each Address item; end-of-grilling test after the last. (D022)
- **Update the re-ask cycle**: cap at 1 re-ask; require explicit "final re-ask" warning in the re-ask preamble; closure as D-record. (D023)
- **Add to "When Not to Use"**: "do not use this skill for questions that require back-and-forth clarification — use the `ask-questions` skill instead." (D023)
- **Cites:** D016, D017, D018, D020, D021, D022, D023, D024.

**Files not changed (out of scope or unchanged):** `references/interface-and-model-branch.md`, `references/validation.md`, `references/terminal-output.md` — no design changes from D016–D025.

<!-- next-id: D026 -->

