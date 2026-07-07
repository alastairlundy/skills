# Decision Ledger — calm-falcon / skill-architect-triage

Source review: `skill-reviews/skill-architect.md` (17 items: 1 trigger-ability, 4 major, 12 minor, 1 positive note).

### [D001] — triage scope

- **Resolved Answer**: "Grouped by topic."
- **Normalized Requirement**: This session resolves the 17 review items in ~8 thematic batches (schema alignment, loop rigidity, checkability, Output Mode rules, format/host choices, transitions, output completeness, stylistic) rather than 17 individual branches.
- **Constraints**: Each subsequent Dxxx record will list the absorbed review-issue-IDs in its Constraints line for traceability. The positive note (References exist and are correctly load-triggered) is not a defect and gets no Dxxx.

### [D002] — canonical schema (issues 2, 15)

- **Resolved Answer**: "Output mode and Transitions should be conditional and only used when the design needs them. The rest remains mandatory."
- **Normalized Requirement**: AGENTS.md is the canonical schema with 5 mandatory sections (Frontmatter, When to Use, When Not to Use, Workflow, Validation); Output Mode and Transitions are conditional, included only when the design needs them.
- **Constraints**: Absorbed review-issue-IDs: 2, 15. The "when the design needs them" trigger must be encoded as a concrete pattern (default: "include Output Mode if the design has a non-default output behaviour; include Transitions if the design depends on a downstream tool or skill"). `skill-architect`'s Step 4 and Validation list both update to 5 + 2 conditional; AGENTS.md gets the same conditional rule so the foundation and the meta-skill agree.

### [D003] — loop rigidity (issues 3, 4, 9, 12)

- **Resolved Answer**: "Issue 9: Make this a check. Issue 4: Soften to example or description of desired output shape. Issue 3: Keep as is. A Pivot requires a re-write. This is intentional design." Issue 12 unaddressed; "Please continue" treated as explicit close.
- **Normalized Requirement**:
  - **Issue 9**: replace the final statement "We have a deterministic skill design" with a check (e.g., "Have we reached a deterministic design?") plus an explicit re-open rule.
  - **Issue 4**: soften the Step 1 example gate to "the user provides an example OR a description of the desired output's shape" — anti-example is NOT a substitute (user's explicit narrowing of the proposal).
  - **Issue 3**: keep the verbatim 3-value protocol (Accept AS IS / Requires Modifications / Reject) as intentional design — a Pivot is handled via the Reject branch (which restarts the design), NOT a 4th verbatim value.
  - **Issue 12**: DEFERRED — no decision recorded; the loop remains interactive-only.
- **Constraints**: Absorbed review-issue-IDs: 3, 4, 9, 12. User flagged that some of these issues were addressed in prior reviews but the current reviewer cited them as if new — process observation, not a Decision Ledger entry; flagged for the reviewer process. Issue 12 (autonomous mode) remains unaddressed and the loop is interactive-only by default; a future use case may re-open it.

### [D004] — checkability (issues 5, 8, 16)

- **Resolved Answer**: "Issue 8: Name must be under 50 characters. Description must be under 500 characters. Ideally description should be under 350 characters, but this isn't a hard requirement. Issue 5 and 16: Vague criteria should be measurable/objective." Clarified: the skill specification mandates name ≤ 50 characters and description ≤ 500 characters; the 350-character soft target is a project-local preference, not a spec requirement.
- **Normalized Requirement**:
  - **Issue 5**: replace "verifiable outcome" in the Determinism Audit with a measurable proxy — the step must name a specific completion signal (returned value, check, state change, file produced, or equivalent).
  - **Issue 8**: replace "concise" with measurable character limits per the skill specification — name ≤ 50 characters (hard), description ≤ 500 characters (hard), description < 350 characters (soft target, not a hard requirement).
  - **Issue 16**: separate per-step verifiability (Determinism Audit) from per-validation-item verifiability (Validation Utility); tighten wording so the two checks don't overlap on verifiability scope.
- **Constraints**: Absorbed review-issue-IDs: 5, 8, 16. The character limits in issue 8 are project-local (tighter than the Waza eval convention of description ≤ 1024 characters). The proxy design for issue 5 lives in `references/skill-standards.md` and the saving procedure in `references/saving-the-skill.md`.

### [D005] — Output Mode rules (issues 6, 11)

- **Resolved Answer**: "Issue 6: File creation scope declaration must be mandatory. The sentence before it is recommended but can be overruled; however, the sentence preceding file creation scope must clearly indicate a SKILL is being drafted. Issue 11: Significantly soften this rule - The user can indicate if they want it saved to file immediately but by default it shouldn't be saved to file."
- **Normalized Requirement**:
  - **Issue 6**: the Step 1 announcement has two parts — (a) an opening sentence announcing the SKILL is being drafted (recommended, can be rephrased or omitted), and (b) a mandatory sentence declaring file-creation scope ("File creation is in scope" / "File creation is out of scope"). The opening sentence, if present, must clearly indicate a SKILL is being drafted. The file-creation-scope sentence is mandatory and uses verbatim language.
  - **Issue 11**: replace the strong "MUST NOT use file system modification tools unless explicitly requested" rule with a soft default — by default the agent does not save to file; the user can opt in by indicating they want the file saved (e.g., "save it now", "yes write it", or any clear indication of intent to save).
- **Constraints**: Absorbed review-issue-IDs: 6, 11. The trigger pattern for "user can indicate" is broader than the current "explicit request" — any clear indication of intent to save counts, not just a direct response to the announcement. The "ask once" escape hatch from the D005 recommendation is no longer relevant; the new rule is permissive by default with an opt-in for save.

### [D006] — format/host choices (issue 7)

- **Resolved Answer**: "We're committing to Mermaid. Keep as is."
- **Normalized Requirement**: Step 2 retains the Mermaid diagram requirement. The skill explicitly commits to Mermaid as the project's standard diagram format; no ASCII fallback or host-agnostic alternative is added.
- **Constraints**: Absorbed review-issue-IDs: 7. The trade-off (Mermaid is unreadable in hosts that don't render it) is accepted as a project-local standard. `skill-architect` does not produce ASCII trees; downstream consumers must support Mermaid. Document the Mermaid commitment in `skill-architect`'s Step 2 so the choice is visible.

### [D007] — Transitions (issue 10)

- **Resolved Answer**: "Option 2"
- **Normalized Requirement**: Keep the two `waza-skill-evaluator` entries in the Transitions list; add a one-sentence note explaining the difference (Phase 1: generate the suite; Phase 2: run baseline).
- **Constraints**: Absorbed review-issue-IDs: 10. The chain still lists three dependencies structurally, but the note clarifies the two-phase nature of the second dependency.

### [D008] — output completeness (issues 13, 14)

- **Resolved Answer**: "Issue 13: Creating evals is out of scope for the skill. That's the job of waza skilll evaluator. Issue 14: Value proposition should concisely be made clear in the description and in the When to use vs When not to use sections."
- **Normalized Requirement**:
  - **Issue 13**: `skill-architect` does NOT create eval suites. Eval creation is the job of `waza-skill-evaluator` (a separate tool/skill). The transitions to `waza-skill-evaluator` (per D007) document the downstream chain; the user is responsible for invoking it. AGENTS.md's eval requirement is enforced at the project/review level, not by `skill-architect` itself.
  - **Issue 14**: keep the value proposition in Step 1's intake; distribute it across three output fields — (a) the description (a concise "what & why" statement), (b) the When to Use section (scenarios where the skill is valuable), and (c) the When Not to Use section (scenarios where it is not). The value prop is a *design input* that shapes the description and the trigger-shape sections.
- **Constraints**: Absorbed review-issue-IDs: 13, 14. Issue 13 explicitly rejects the reviewer's suggestion that `skill-architect` should enforce eval creation; the project's eval enforcement is at the transitions layer, not the workflow layer. Issue 14 distributes the value prop across three output fields, which means the description's structure becomes project-specific (a "what & why" format). The description may approach the 500-character hard limit (per D004) when the value prop is woven in. **Follow-up (open):** create an ADR documenting the D008 Issue 13 stance — `skill-architect` does not create evals; it is the job of other tools/skills (e.g., `waza-skill-evaluator`) to create and run skill evals.

### [D009] — stylistic / trigger (issue 1)

- **Resolved Answer**: "Switch to Use when and Do not use when style"
- **Normalized Requirement**: Replace the description's "Use for creating or designing a new skill. Do not use for making minor tweaks to existing skills." with "Use when creating or designing a new skill. Do not use when making minor tweaks to existing skills." (or "Don't use when") in `skill-architect`'s frontmatter.
- **Constraints**: Absorbed review-issue-IDs: 1. One-line change in the frontmatter description; no functional impact. Aligns with the AGENTS.md convention that `skill-architect` itself enforces on the skills it designs.
