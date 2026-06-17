# Initialization and Domain Awareness

Load this file when the `domain-grilling` skill activates, before the first user
question. The workflow in `SKILL.md` expects the baseline and infrastructure
checks below to have been completed.

## Initialization and Setup

Upon activation:
1. **Domain State Summary**: Scan the repository for `CONTEXT.md`, `docs/adr/`, and any existing Decision Ledger files at `docs/decisions/DECISIONS-*.md`. Summarize the current known domain state to the user *before* asking the first question. This establishes the baseline and prevents redundant questioning.
2. **Infrastructure Check**: If `CONTEXT.md` is missing, inform the user and suggest the `setup-matt-pocock-skills` skill to establish the glossary and ADR infrastructure. If `docs/decisions/` is missing, note that the Decision Ledger directory will be created lazily on the first resolved branch (per the Decision Ledger section in `SKILL.md`).
3. **Ledger Path Confirmation**: When opening Branch A, derive the Decision Ledger path (`docs/decisions/DECISIONS-<repo>-<feature>.md`) and confirm it with the user before the first append. A later branch must never silently redirect to a different ledger file.

## Domain Awareness

During codebase exploration, analyze the following:

### File structure
Most repos follow a single-context layout:
```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```
If a `CONTEXT-MAP.md` exists at the root, the repo uses multiple contexts. The map identifies the location of each.

### Documentation Policy
- **Lazy Creation**: If the user chooses not to use the setup skill, create `CONTEXT.md` or `docs/adr/` only when the first term or ADR is actually resolved and ready to be written.
- **Glossary Purity**: `CONTEXT.md` must stay devoid of implementation details (e.g., no table names, class names, or API endpoints). If a user suggests adding implementation details, challenge them to find the underlying domain concept.

## Session Guidelines

### Iterative Dependency Resolution
- Identify all "branches" (conceptual areas/decisions) of the design tree.
- Resolve these branches sequentially, but **re-open any resolved branch** if a later discovery reveals a conceptual contradiction or dependency that invalidates an earlier decision.
- When re-opening a branch, state which new information triggered it and what specifically needs revisiting.
- **Convergence Check**: before declaring convergence, verify that all resolved branches remain mutually consistent. If any branch contradicts another, re-open the conflicting branches and resolve the contradiction before proceeding.

### Challenge against the glossary
When the user uses a term that conflicts with `CONTEXT.md`, present the conflict as a choice between the glossary definition and the user's apparent meaning. "Your glossary defines 'cancellation' as X (voiding the order before payment), but you seem to mean Y (refunding after payment). These have different domain boundaries. Which is correct for your context — or do you need both terms?"

### Sharpen fuzzy language
When the user uses a vague or overloaded term, present the possible meanings as options with their implications. "You're saying 'account' — this could mean the Customer (the entity that owns the subscription) or the User (the person logging in). Those have different boundaries. Which fits your domain?"

### Discuss concrete scenarios
Stress-test domain relationships with specific scenarios. Invent edge cases that force the user to be precise about boundaries between concepts.

### Cross-reference with code
If the user states how something works, verify it against the code. Surface any contradictions immediately.

### Offer ADRs sparingly
Only offer to create an ADR when all three are true:
1. **Hard to reverse** — the cost of changing your mind later is meaningful.
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and one was picked for specific reasons.

When suggesting an ADR, explicitly state which of these three criteria triggered the suggestion. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

If the user declines an ADR suggestion for a decision that meets all three criteria, the decline is itself an ADR-worthy event (it changes the durable record of the decision). Re-offer with: "By declining a formal ADR for a decision that meets all three criteria, you're accepting the trade-off of no durable record. Do you want me to record the decline itself as a brief ADR (Decision NNN-decline), or proceed without a record?"

## Convergence

Convergence is the point at which the grilling session may declare a shared understanding and offer exit paths. To certify convergence, all of the following must hold:

- **All branches resolved.** Every branch opened during the session has a recorded decision, or has been explicitly closed by the user.
- **No contradictions.** Re-open any branch whose recorded decision contradicts another branch's recorded decision, and resolve the contradiction first.
- **No new question in the last three turns.** The most recent three exchanges have not introduced a new branch, surfaced a contradiction, or required a glossary revision. If a new question or contradiction appeared in the last three turns, the session is not yet convergent — continue grilling.
- **Decision Ledger complete.** Read the Decision Ledger file and verify that every branch resolved during this session has a corresponding `Dxxx` record, and that every re-opened branch has a fresh `Supersedes: Dxxx` record. A branch that is resolved in conversation but missing from the ledger is a silent loss; re-open it, write the record, and re-verify before declaring convergence. Do not allow convergence on the strength of conversational memory alone.

When all four checks pass, declare: "We have reached a shared understanding." Do not declare convergence based on intent or partial progress; the test is observable in the recent exchange history and in the ledger file.
