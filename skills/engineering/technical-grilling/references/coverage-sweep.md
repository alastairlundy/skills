# Coverage Sweep and Residual Inventory

This reference owns two mechanics that keep never-asked decisions from
leaving the session unresolved:

- **Coverage sweep** - the deterministic walk over the decision surface.
  It runs twice: as the **minimum sweep** before Phase 2 TDP rounds are
  planned, and as **check 6** of the convergence test
  (`references/convergence-test.md`) at every round boundary.
- **Residual inventory** - the table that accompanies the close-out
  prompt, so the user's sign-off is informed.

Both mechanics are walk-based: every surface item maps to one of three
outcomes. A category the agent skipped is an unwalked category, and
unwalked is not an outcome.

## Load trigger

Load this file before Phase 2 Step 2 (Spec-Driven Technical Extraction)
and before running the convergence test. Phase 2 extraction uses it to
enumerate branches; the convergence test uses it to verify outcomes.

## The decision surface

The surface is the set of items the walkthrough must cover:

- **(a) Spec or goal items.** When a spec is supplied: its sections and
  functional requirements. When no spec exists: the functional areas
  the user named in the goal record, enumerated once and numbered.
- **(b) Taxonomy categories.** The implementation-ambiguity taxonomy
  below.

Session intent scopes the walk:

- `concept-only` - walk (a) only. The taxonomy rows are emitted once in
  the residual inventory, marked `Out of scope (no implementation
  track)`.
- `implementation-only` or `concept-then-implementation` - walk (a) and
  (b).

## Implementation-ambiguity taxonomy

Specs commonly leave these implementation decisions unstated. Walk
every category in order; do not reorder and do not skip:

1. **Persistence** - storage engine, schema ownership, migration
   tooling.
2. **Identity and access** - authentication mechanism, identity
   propagation, authorization model.
3. **Validation** - where inputs are validated, what surfaces for
   invalid input.
4. **Error handling and failure modes** - what fails, what retries,
   what reaches the user.
5. **Configuration and secrets** - where settings live, how secrets
   are injected.
6. **Deployment and hosting** - target environment, service topology,
   rollout.
7. **Testing strategy** - unit/integration/end-to-end split, what runs
   in CI.
8. **Observability** - logging, metrics, tracing.
9. **External contracts** - API surface, DTOs, versioning and
   backward-compatibility policy.
10. **Concurrency and state** - parallelism, idempotency, ordering
    guarantees.
11. **Data lifecycle** - retention, deletion, backup and restore.
12. **Security and privacy** - threat surface, data classification.
13. **Performance and capacity** - expected load, latency targets,
    resource ceilings.

## The three outcomes

Every surface item maps to exactly one outcome:

- **Resolved** - a `Dxxx`/`Txxx` record covers it. Cite the record.
- **Deferred** - the user explicitly deferred the decision, or a
  declined optional branch covers it. Cite the DEFERRED/DECLINED
  record; it carries the deferral or decline reason and the fallback
  default (see `references/decision-ledger.md`, DEFERRED closure, and
  DECLINED optional branches).
- **Out of scope** - not applicable or explicitly excluded. The
  ledger's Constraints, the goal record, or the spec must carry the
  exclusion; if none does, append the explicit out-of-scope entry
  before proceeding.

## The minimum sweep (Phase 2 Step 2)

Before planning TDP rounds:

1. Walk surface (a) item by item. Each item maps to one or more
   planned branches or an out-of-scope entry.
2. Walk the taxonomy categories above. Each category maps to one or
   more planned branches or an out-of-scope entry.
3. Group the unblocked planned branches into dependency-ordered rounds
   of at most 3; the frontier statement reports how many surface items
   remain in each stream.

The sweep may produce many rounds. Under-asking is the failure mode
this sweep exists to prevent; a short round list produced by skipping
items is a violation, not a shortcut.

## Check 6 - Coverage (convergence test)

At each round boundary, after checks 1-5 pass:

1. Every surface (a) item maps to Resolved, Deferred, or Out of scope.
2. Every taxonomy category maps to Resolved, Deferred, or Out of scope
   (per the session-intent rule above).
3. Every Deferred row is backed by a DEFERRED (explicit user deferral)
   or DECLINED (declined optional branch) record whose `Constraints`
   carry the reason and the fallback default.
4. Any surface item newly discovered mid-session (a late technical
   gap, an unpinned sub-decision from a composite answer) joins the
   surface before close-out. Composite sub-decisions were extracted
   at pick time (`references/decision-ledger.md`, Detail extraction
   from composite answers), so unpinned items reaching this check are
   the deliberate gaps the user deferred.

Any miss fails the check: open the missing branch or record the
explicit out-of-scope entry, then re-run the check.

## Residual inventory (close-out gate)

When the close-out prompt is offered, emit the inventory with it, as a
table with three columns:

| Surface item | Outcome | Record |
|--------------|---------|--------|

- One row per surface (a) item and per taxonomy category.
- `Outcome` is Resolved / Deferred / Out of scope.
- `Record` is the `filename#Dxxx`/`filename#Txxx` citation, the
  out-of-scope ledger entry, or `None.` for the taxonomy rows marked
  out of scope by the session-intent rule.

The close-out prompt is invalid without the table. The user's
close-out confirmation is recorded against the table, not against a
bare "all checks pass" line.

## Worked example

A CLI tool that watches a directory and indexes markdown into SQLite.
Spec has two sections; taxonomy walked per the implementation track.

| Surface item                              | Outcome      | Record                                             |
|-------------------------------------------|--------------|----------------------------------------------------|
| §2 index build                            | Resolved     | DECISIONS-repo-md-index.md#T004                    |
| §3 CLI verb set                           | Deferred     | DECISIONS-repo-md-index.md#T009 (default: `index`, `watch`, `search`) |
| Persistence                               | Resolved     | DECISIONS-repo-md-index.md#T001                    |
| Concurrency and state                     | Out of scope | Goal record Constraints: single-user tool          |
| Performance and capacity                  | Deferred     | DECISIONS-repo-md-index.md#T011 (default: no target; revisit under load) |
