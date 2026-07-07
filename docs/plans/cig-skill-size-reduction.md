# CIG Skill Size Reduction Plan

## 1. Measured Current Size

**Total lines: 464** (ticket baseline: 467; drift: −3 lines). The file was likely trimmed since the ticket was written.

### Section line ranges and lengths

| Section | Lines | Length | Ticket baseline | Drift |
|---|---|---|---|---|
| Frontmatter | 1–9 | 9 | — | — |
| H1 + intro | 11–23 | 13 | — | — |
| ## When to Use | 25–31 | 7 | — | — |
| ## When Not to Use | 33–38 | 6 | — | — |
| ## Workflow (overall) | 40–341 | 302 | — | — |
| Core Constraint | 42–44 | 3 | — | — |
| ### Step 1: Load the references | 46–60 | 15 | — | — |
| ### Step 2: Spec & Ledger resolution | 62–95 | 34 | — | — |
| ### Recording Technical Decisions to the Ledger | 97–119 | 23 | 22 | +1 |
| ### Step 3: Foundation Establishment | 121–143 | 23 | — | — |
| ### Step 4: Spec-Driven Technical Extraction | 145–159 | 15 | — | — |
| ### Step 5: Interface & Model Branch | 161–238 | 78 | 78 | ±0 |
| ### Step 6: Output Selection | 240–318 | 79 | 79 | ±0 |
| ### Step 7: Final Alignment Check & Convergence | 320–341 | 22 | — | — |
| ## Terminal Output (Required) | 343–409 | 67 | 67 | ±0 |
| ## Validation | 411–464 | 54 | 53 | +1 |

Two blocks drifted: Recording (ticket: 22 → actual: 23, +1 line) and Validation (ticket: 53 → actual: 54, +1 line). The other measurements match exactly.

## 2. Target Line Count with Justification

**Target: 120 lines** (down from 464, a 74% reduction).

Rationale:
- The AGENTS.md convention states that **templates ≥20 lines** belong in `references/` and are loaded on demand via a load-trigger sentence. However, Step 5 and Step 6 are *procedural prose*, not reusable templates — they describe branching workflows with conditional sub-steps. The AGENTS.md rule strictly applies to templates; procedural blocks must be justified by a different argument.
- The different justification is **per-activation context cost**: every line in `SKILL.md` is loaded on every activation. The Interface & Model Branch (Step 5) fires only when the user opts in; Output Selection (Step 6) is a terminal choice; Terminal Output is a post-workflow emission; Validation is a checklist. None of these are needed during the opening questions of Steps 1–4. Moving them out saves ~278 tokens of context per activation.
- Promoting all five candidate blocks leaves ~163 lines (frontmatter + Steps 1–4 + Step 7 + blank separators). Trimming an additional ~43 lines from the remaining prose (tightening descriptions in Steps 1–4 and Step 7) reaches the 120 target.
- **100 as stretch target**: achievable after further pruning of the core workflow (e.g., condensing Step 2's ledger resolution sub-steps, merging Step 7's convergence checklist with Validation), but risks making the remaining workflow too terse to be deterministic. 120 is a safer floor.

## 3. Candidate Blocks with Proposed `references/` Filenames

| Block | Lines | Line range | Proposed filename | Rationale |
|---|---|---|---|---|
| Step 6: Output Selection | 79 | 240–318 | `references/output-selection.md` | Largest block; fully procedural (output format choice with sub-options, downstream consumer, filename confirmation). Never needed during Steps 1–5. |
| Step 5: Interface & Model Branch | 78 | 161–238 | `references/interface-and-model-branch.md` | Second-largest; optional branch (user must opt in). 3-phase nested workflow. Never needed if user declines. |
| Terminal Output | 67 | 343–409 | `references/terminal-output.md` | Post-workflow emission only. Contains 6 template variants. Not a workflow step — purely output formatting. |
| Validation | 54 | 411–464 | `references/validation.md` | End-of-session checklist (17 checkboxes). Not part of the active workflow — only needed for final verification. |
| Recording Technical Decisions to the Ledger | 23 | 97–119 | `references/recording-decisions.md` | Borderline (23 lines, just above the 20-line threshold). Contains the `Txxx` record template (~8 lines of actual template; the rest is prose). Including it keeps the SKILL.md cleaner and avoids a near-threshold exception. |

**Order by descending size**: Step 6 (79) → Step 5 (78) → Terminal Output (67) → Validation (54) → Recording (23).

## 4. Implementation Outline and Activation-Cost Estimate

### Activation-cost estimate

Sum of candidate block lengths: 79 + 78 + 67 + 54 + 23 = **301 lines**.
As a percentage of 464: **64.9%** of the current file is consumed by blocks that are not needed on every activation.

### Future implementation steps

1. **Promote Step 6 (`output-selection.md`, 79 lines)** — largest non-borderline. Add load-trigger sentence at the end of Step 5 (or before the existing Step 6 anchor):
   > Load `references/output-selection.md` before presenting the output format choice to the user.

2. **Promote Step 5 (`interface-and-model-branch.md`, 78 lines)** — second largest. Replace the Phase 1–3 body with a load-trigger sentence:
   > Load `references/interface-and-model-branch.md` before asking the user whether they want interface grilling.

3. **Promote Terminal Output (`terminal-output.md`, 67 lines)** — replace the entire block with:
   > Load `references/terminal-output.md` before emitting the terminal handoff template.

4. **Promote Validation (`validation.md`, 54 lines)** — replace the entire block with:
   > Load `references/validation.md` before declaring convergence in Step 7.

5. **Promote Recording block (`recording-decisions.md`, 23 lines)** — replace with:
   > Load `references/recording-decisions.md` before the first `Txxx` append in Step 2.

### Cross-references between `references/` files

None. Each block is self-contained. The Terminal Output block depends on choices captured in Step 6, but that dependency is resolved at runtime (the agent already holds the captured choices in memory before loading the template). No `references/` file needs to reference another.

### Remaining SKILL.md structure after all promotions

- Frontmatter (9)
- H1 + intro (13)
- When to Use (7)
- When Not to Use (6)
- Workflow header + Core Constraint (5)
- Step 1: Load references (15)
- Step 2: Ledger resolution (34, with Recording trigger sentence)
- Step 3: Foundation (23)
- Step 4: Extraction (15)
- Step 5: trigger sentence to `references/interface-and-model-branch.md` (~3)
- Step 6: trigger sentence to `references/output-selection.md` (~3)
- Step 7: Alignment (~22, with Validation trigger sentence)
- Terminal Output trigger sentence (~3)

Rough remaining total: ~158 lines. Additional tightening of ~38 lines in Steps 1–4 and Step 7 needed to reach 120.
