# Decision Ledger

Topic: Decision Ledger writes in engineering/grilling

## Records

### [D001] — highest-priority contributing cause

- **Resolved Answer**: "Option 1"
- **Normalized Requirement**: The engineering/grilling skill's post-pick step (SKILL.md:186-200) shall be restructured from a four-action prose bundle into a first-class gated step that requires a successful tool-bound write before the next branch opens.
- **Constraints**: Do not regress evals/grilling/fixtures/example-session-saas-pricing.md. Verification (Option 2 of D001) and gating (Option 3 of D001) are out of scope for D002 — add as separate branches if D002 proves insufficient.

### [D002] — new shape of the post-pick step

- **Resolved Answer**: "Option 2"
- **Normalized Requirement**: The engineering/grilling skill's post-pick step shall include a tool-binding sentence (binding the write to a successful tool-call result) plus a read-back verification step (confirming the new Dxxx line is the last record in the file) before the next branch opens.
- **Constraints**: Read-back must tolerate benign differences (trailing newlines, byte-order). Tool-binding-only (Option 1 of D002) is insufficient because of the silent-drop mode. Halting transition (Option 3 of D002) and four-bullet restructure (Option 4 of D002) are out of scope for D003 — add as separate branches if D003 proves insufficient.

### [D003] — where the post-pick fix lives

- **Resolved Answer**: "Option 1"
- **Normalized Requirement**: The post-pick fix (tool-binding + read-back per D002) shall be implemented as an inline edit to SKILL.md:186-200, with no new reference file or new SKILL.md subsection.
- **Constraints**: The post-pick step's new load-bearing role must be called out in the validation checklist so future editors see it. New section in SKILL.md (Option 2 of D003), adding to references/decision-ledger.md (Option 3 of D003), and new reference file (Option 4 of D003) are out of scope for D004 — add as separate branches if D004 proves insufficient.

### [D004] — how the post-pick fix is validated

- **Resolved Answer**: "Option 4"
- **Normalized Requirement**: The post-pick fix (per D002 and D003) shall be validated through three layers: (a) the validation checklist in SKILL.md is updated to inspect the ledger file's last record (not the transcript); (b) a new eval task under evals/grilling/tasks/ is added that resolves a branch and has the grader inspect the ledger file for the new Dxxx record; (c) the worked example fixture evals/grilling/fixtures/example-session-saas-pricing.md is updated to show the tool-binding and read-back in the post-pick turn.
- **Constraints**: The validation checklist shall be the single source of truth; the eval task and worked example cross-reference it. Single-layer validations (Options 1, 2, 3 of D004) are insufficient as the final form; the defense-in-depth posture is the resolved answer.

### [D005] — resolution of D001 / D002 contradiction

- **Driver**: the post-pick fix must read as a coherent whole — if D002 picks the option that includes verification, then D001's "verification out of scope" clause cannot stand alongside it without leaving the ledger self-contradictory.
- **Resolved Answer**: "a) Supersede D001"
- **Normalized Requirement**: A D005 record with `Supersedes: D001` in `Constraints` documents that D001's "Verification (Option 2 of D001) is out of scope for D002" clause is implicitly overridden by D002's pick of Option 2 (tool-binding plus read-back verification). D001's wording remains intact for traceability.
- **Constraints**: `Supersedes: D001` (verification-out-of-scope clause). D001's original wording stays in the ledger unchanged. Option (b) (accept-as-wording-issue without a new record) is out of scope for D005.
