# DDD Initialization and Session Guidelines

Load this file when the `domain-grilling` skill activates, before the
first user question. The workflow in `SKILL.md` expects the DDD baseline
and infrastructure checks below to have been completed.

## DDD Initialization

Upon activation:

1. **Domain state summary.** Check `CONTEXT.md` at the repo root,
   then scan for `docs/adr/` and any existing Decision Ledger files at
   `docs/decisions/DECISIONS-*.md`. Report the `CONTEXT.md` state:
   - **Missing** — no glossary file found; will be created lazily on
     first term. Suggest the `setup-matt-pocock-skills` skill to
     establish the glossary and ADR infrastructure.
   - **Empty** — `CONTEXT.md` exists but is empty or whitespace-only;
     will be populated as terms are resolved.
   - **Present with content** — read and summarize the existing terms
     to the user.
   Summarize the current known domain state to the user *before* asking
   the first question to establish the baseline and prevent redundant
   questioning.
2. **Infrastructure check.** If `docs/decisions/` is
   missing, note that the Decision Ledger directory will be created
   lazily on the first resolved branch (per `grilling/references/decision-ledger.md`).
3. **Ledger path confirmation.** When opening Branch A, derive the
   Decision Ledger path
   (`docs/decisions/DECISIONS-<repo>-<feature>.md`) and confirm it with
   the user before the first append. A later branch must never
   silently redirect to a different ledger file.

## DDD Awareness

During codebase exploration, analyze the following.

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

If a `CONTEXT-MAP.md` exists at the root, the repo uses multiple
contexts. The map identifies the location of each.

### Documentation policy

- **Lazy creation.** If the user chooses not to use the setup skill,
  create `CONTEXT.md` or `docs/adr/` only when the first term or ADR
  is actually resolved and ready to be written.
- **Glossary purity.** `CONTEXT.md` must stay devoid of
  implementation details (e.g., no table names, class names, or API
  endpoints). If a user suggests adding implementation details,
  challenge them to find the underlying domain concept.

## Session Guidelines

### Iterative dependency resolution

- Identify all branches (conceptual areas/decisions) of the design
  tree.
- Resolve branches sequentially, but **re-open any resolved branch**
  if a later discovery reveals a conceptual contradiction or
  dependency that invalidates an earlier decision.
- When re-opening a branch, state which new information triggered it
  and what specifically needs revisiting.
- **Convergence check.** Before declaring convergence, run the
  four-check convergence test from
  `grilling/references/convergence-test.md`.

### Challenge against the glossary

When the user uses a term that conflicts with `CONTEXT.md`, present
the conflict as a choice between the glossary definition and the
user's apparent meaning:

> Your glossary defines `cancellation` as X (voiding the order
> before payment), but you seem to mean Y (refunding after payment).
> These have different domain boundaries. Which is correct for your
> context — or do you need both terms?

### Sharpen fuzzy language

When the user uses a vague or overloaded term, present the possible
meanings as options with their implications:

> You\'re saying `account` — this could mean the Customer (the entity
> that owns the subscription) or the User (the person logging in).
> Those have different boundaries. Which fits your domain?

### Discuss concrete scenarios

Stress-test domain relationships with specific scenarios. Invent edge
cases that force the user to be precise about boundaries between
concepts.

### Cross-reference with code

If the user states how something works, verify it against the code.
Surface any contradictions immediately.

### Offer ADRs sparingly

Only offer to create an ADR when all three criteria in
`references/ADR-FORMAT.md` hold:

1. **Hard to reverse** — the cost of changing your mind later is
   meaningful.
2. **Surprising without context** — a future reader will wonder
   "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine
   alternatives and one was picked for specific reasons.

When suggesting an ADR, explicitly state which of these three
criteria triggered the suggestion.

If the user declines an ADR suggestion for a decision that meets all
three criteria, the decline is itself an ADR-worthy event. Re-offer
with:

> By declining a formal ADR for a decision that meets all three
> criteria, you\'re accepting the trade-off of no durable record. Do
> you want me to record the decline itself as a brief ADR (Decision
> NNN-decline), or proceed without a record?
