# Decision Ledger - skills - grilling consolidation

Records for the session consolidating `technical-grilling` into a self-contained skill and removing the generic `grilling` skill. Format per `grilling/references/decision-ledger.md`.

### [D001] - session goal

- **Driver**: one grilling skill instead of a parent/child pair - `technical-grilling` must not depend on a separate generic skill's reference files.
- **Resolved Answer**: "Make technical-grilling self-contained and delete the generic grilling skill" - confirmed as stated; deletion is fixed, not negotiable.
- **Normalized Requirement**: The repo shall contain a single grilling-family skill (`technical-grilling`) whose reference set lives entirely inside `skills/engineering/technical-grilling/`, and `skills/engineering/grilling/` shall be removed.
- **Constraints**: Deletion of `skills/engineering/grilling/` is confirmed in scope. The fate of non-technical decision support is an open branch (D002), not pre-decided.

### [I001] - ledger path confirmation

- **Prompt**: "No Decision Ledger exists yet. Per the grilling workflow, records for this session would be appended to a derived path. Confirm it?"
- **User Response**: "Use derived path (Recommended)" - `docs/decisions/DECISIONS-skills-grilling-consolidation.md`.
- **Resolution**: ledger path confirmed; goal record D001 written on file creation.
- **Notes**: asked via the ask-questions tool before this file existed.

### [I002] - goal confirmation

- **Prompt**: "Your stated goal bundles two things: make technical-grilling self-contained, and delete the generic grilling skill. Is deletion fixed, or negotiable?"
- **User Response**: "Confirm as stated" - both self-containment and deletion are in scope.
- **Resolution**: recorded as goal record D001 with deletion confirmed in Constraints.
- **Notes**: `None.`

### [D002] - non-technical routing

- **Driver**: the user wants the technical boundary sharp and the change small; the vacated trigger space is not worth widening the skill for.
- **Resolved Answer**: Option B - non-technical vague decisions get no dedicated skill; the boundary stays technical-only.
- **Normalized Requirement**: `technical-grilling`'s YAML and body shall claim only technical/code-related decisions; non-technical vague decisions shall have no dedicated skill and no handoff pointer to one.
- **Constraints**: All "use `grilling` instead" pointers shall be removed or rewritten without inventing a replacement skill. No conversational-fallback line is added (Option C rejected).

### [D003] - reference consolidation

- **Driver**: self-containment without permanently forking the question format into two variants.
- **Resolved Answer**: Option A - port and consolidate: copy the 5 non-colliding parent references into `technical-grilling/references/` and merge the parent 4-row question table into the local 5-row `locked-question-format.md`.
- **Normalized Requirement**: `technical-grilling/SKILL.md` shall reference only local `references/` files; each parent reference shall exist locally as a ported copy or merged content; no `../grilling/references/` path shall remain in the repo.
- **Constraints**: Ported content is reworded from "grilling group"/parent-child language to single-skill terms; sentinel rules describe `technical-grilling` only.

### [D004] - cross-reference sweep

- **Driver**: the deletion should leave no dangling references - consolidation complete, not partial.
- **Resolved Answer**: Option A - full sweep: update the 4 live referencing files (`ask-questions`, README, `docs/agents/domain.md`, `setup-alastairlundy-skills`) and append a status note to ADR 0002.
- **Normalized Requirement**: After the change, no live repo file shall instruct use of a `grilling` skill, and ADR 0002 shall carry a status note recording the removal.
- **Constraints**: CHANGELOG historical text stays untouched; existing ADR 0002 text is not rewritten, only appended to.

### [I003] - D002 non-technical routing

- **Prompt**: "For D002 – non-technical routing: pick an option, hybridize, or provide your own answer."
- **User Response**: "D002: Option B"
- **Resolution**: accepted the gap - technical-only boundary; shaped D004's ask-questions rewording and confirmed the existing no-trigger eval tasks stay valid.
- **Notes**: Appended post-response; the pre-question TBD append was skipped this session. Recommendation (C) was rejected.

### [I004] - D003 reference consolidation

- **Prompt**: "For D003 – reference consolidation: pick an option, hybridize, or provide your own answer."
- **User Response**: "D003: Option A"
- **Resolution**: port-and-consolidate selected; governs how the 6 parent references become local files.
- **Notes**: Appended post-response; pre-question TBD append skipped this session.

### [I005] - D004 cross-reference sweep

- **Prompt**: "For D004 – cross-reference sweep: pick an option, hybridize, or provide your own answer."
- **User Response**: "D004: Option A"
- **Resolution**: full sweep including the ADR 0002 status note.
- **Notes**: Appended post-response; pre-question TBD append skipped this session.

### [D005] - eval inheritance

- **Driver**: the deletion should not cost the strongest verification the removed skill owned - a mechanical gate beats LLM-judged rubrics.
- **Resolved Answer**: Option A - port `check-ledger-record.ps1` into `technical-grilling`'s evals and wire it into `eval.yaml`.
- **Normalized Requirement**: `technical-grilling/evals/` shall contain a ported ledger-record check script wired into eval.yaml, reworked for the dual `Dxxx`/`Txxx` stream.
- **Constraints**: The example-session fixture is not ported (Option C rejected); grilling's remaining eval tasks are deleted with the skill.

### [D006] - record-keeping

- **Driver**: the why of the consolidation must survive post-implementation ledger cleanup.
- **Resolved Answer**: Option A - write `docs/adr/0003` for the consolidation and keep this ledger until implementation ends.
- **Normalized Requirement**: `docs/adr/0003-grilling-consolidation.md` shall exist capturing motivation, alternatives, and consequences; this ledger persists until implementation completes.
- **Constraints**: ADR 0003 derives its content from this ledger's Dxxx records; the post-session deletion reminder applies to the ledger per skill lifecycle.

### [D007] - ask-questions handoff target

- **Driver**: consistency with D002 - structured elicitation exists only for technical decisions, so the handoff should not pretend otherwise.
- **Resolved Answer**: Option C - drop the handoff sentence; the three-round soft cap stands alone.
- **Normalized Requirement**: `ask-questions/SKILL.md` shall no longer name any grilling skill in its handoff guidance; the three-round soft cap remains as the escape-hatch boundary.
- **Constraints**: No replacement handoff target is added (Option A rejected); D004's sweep of ask-questions is limited to removing the sentence.

### [I006] - D005 eval inheritance

- **Prompt**: "For D005 – eval inheritance: pick an option, hybridize, or provide your own answer."
- **User Response**: "D005: Option A"
- **Resolution**: script check ported into technical-grilling's evals; fixture not ported.
- **Notes**: Appended post-response; pre-question TBD append skipped this session.

### [I007] - D006 record-keeping

- **Prompt**: "For D006 – record-keeping: pick an option, hybridize, or provide your own answer."
- **User Response**: "D006: Option A"
- **Resolution**: ADR 0003 to be written; ledger kept until implementation ends.
- **Notes**: Appended post-response; pre-question TBD append skipped this session.

### [I008] - D007 ask-questions handoff target

- **Prompt**: "For D007 – ask-questions handoff target: pick an option, hybridize, or provide your own answer."
- **User Response**: "D007: Option C"
- **Resolution**: handoff sentence deleted; no replacement target; consistent with D002.
- **Notes**: Recommendation (A) was rejected. Appended post-response; pre-question TBD append skipped this session.

### [D008] - ADR 0003 scope

- **Driver**: the consolidation record should stand on its own without retroactively weakening ADR 0002's still-valid YAML-craft lessons.
- **Resolved Answer**: Option A - standalone ADR 0003 documenting the merge and deletion, citing ADR 0002 as historical context.
- **Normalized Requirement**: ADR 0003 shall document motivation, alternatives, and consequences of the consolidation and cite ADR 0002 as context without superseding it.
- **Constraints**: ADR 0002 is not marked superseded; its text is unchanged beyond D004's status note.

### [D009] - YAML description wording

- **Driver**: positive claims are the strongest trigger signal per ADR 0002's craft lessons; negations weaken routing.
- **Resolved Answer**: Option A - positive-only YAML description claiming the technical territory; every negation clause dropped.
- **Normalized Requirement**: `technical-grilling`'s YAML description and body When-Not-to-Use shall state coverage positively with no "Do not use for non-technical..." negation clause.
- **Constraints**: The over-trigger boundary is enforced empirically by the existing no-trigger eval tasks (business-pricing, vague-plan, non-code-idea).

### [D010] - self-description lineage

- **Driver**: live docs describe the present; history belongs in the ADR, not the skill header.
- **Resolved Answer**: Option A - erase lineage from live docs; SKILL.md and README describe the skill standalone, lineage lives only in ADR 0003.
- **Normalized Requirement**: No live doc shall describe `technical-grilling` as specializing in, parenting from, or merging with `grilling`; ADR 0003 is the sole lineage record.
- **Constraints**: The former domain-grilling/code-implementation-grilling merge narrative moves to ADR 0003; README's technical-grilling row is rewritten to standalone wording.

### [I009] - D008 ADR 0003 scope

- **Prompt**: "For D008 – ADR 0003 scope: pick an option, hybridize, or provide your own answer."
- **User Response**: "D008: Option A"
- **Resolution**: standalone ADR; ADR 0002 cited as context, not superseded.
- **Notes**: Appended post-response; pre-question TBD append skipped this session.

### [I010] - D009 YAML description wording

- **Prompt**: "For D009 – YAML description wording: pick an option, hybridize, or provide your own answer."
- **User Response**: "D009: Option A"
- **Resolution**: positive-only claims; negation clauses dropped from YAML and body.
- **Notes**: Appended post-response; pre-question TBD append skipped this session.

### [I011] - D010 self-description lineage

- **Prompt**: "For D010 – self-description lineage: pick an option, hybridize, or provide your own answer."
- **User Response**: "D010: Option A"
- **Resolution**: lineage erased from live docs; ADR 0003 is the sole lineage record.
- **Notes**: Appended post-response; pre-question TBD append skipped this session.

### [I012] - ADR number collision

- **Prompt**: "Conflict found during exploration: D006 and D008 name the consolidation record `docs/adr/0003-grilling-consolidation.md`, but `docs/adr/0003-skill-architect-does-not-create-evals.md` already occupies the 0003 slot. Which path should the consolidation ADR use? (a) `docs/adr/0004-grilling-consolidation.md` - next free number (recommended); (b) keep the ledger-named 0003 path and renumber the existing skill-architect ADR; (c) your own path."
- **User Response**: "ADR Conflict: (a)" - use `docs/adr/0004-grilling-consolidation.md`, the next free number.
- **Resolution**: consolidation ADR path fixed to `docs/adr/0004-grilling-consolidation.md`; ticket 006 and all citations use 0004. D006/D008 keep their original text (D-records are not amended); this record documents the correction.
- **Notes**: `docs/adr/0003-skill-architect-does-not-create-evals.md` is untouched.

### [I013] - sweep scope beyond D004 enumeration

- **Prompt**: "Coverage-gap question: D004's normalized requirement says no live repo file shall instruct use of a `grilling` skill, but the record enumerates only 4 files. The full-text sweep found three more live files with grilling instructions or lineage claims: (1) `skills/engineering/spec-to-tickets/SKILL.md` - YAML description and When-Not-to-Use instruct using/recommending `grilling`; (2) `skills/engineering/spec-to-tickets/references/decision-ledger.md` - cites the canonical `skills/engineering/grilling/` path and calls technical-grilling the child of `grilling`; (3) `skills/skills-meta/skill-architect/references/decision-ledger.md` - same canonical-path and lineage mentions. Options: (a) extend the sweep ticket to cover all three (recommended); (b) extend it to the spec-to-tickets files only; (c) keep D004's original 4-file scope and leave the three files dangling."
- **User Response**: "Sweep Scope: (a)" - extend the sweep ticket to cover all three files.
- **Resolution**: ticket 004 scope extended to `skills/engineering/spec-to-tickets/SKILL.md`, `skills/engineering/spec-to-tickets/references/decision-ledger.md`, and `skills/skills-meta/skill-architect/references/decision-ledger.md`; rewording follows D002 (no replacement skill invented) and D010 (lineage erased).
- **Notes**: `CHANGELOG.md` line 19 and ADR 0002's historical body stay untouched per D004 constraints.

### [I014] - decomposition validation

- **Prompt**: "The six tickets above propose the full decomposition of the grilling consolidation ledger.\n\nA few things to check:\n\nWhich tickets, if any, would you combine, split, or rescope?\n\nAre there any spec requirements not yet covered by a ticket, or any ticket that doesn't trace back to a requirement?\n\nAre there any tickets where the `Blocked by` chain or Independent/Collaborative classification feels off?"
- **User Response**: answered the two gap questions (I012 option a, I013 option a); gave no combine/split/rescope, coverage, or classification feedback - treated as a clear pass on the proposal.
- **Resolution**: decomposition approved as proposed; proceeded to ticket generation and publishing under the resolved gap answers.
- **Notes**: partial answers accepted per the multi-part pattern.

<!-- next-d: D011 -->
<!-- next-i: I015 -->
