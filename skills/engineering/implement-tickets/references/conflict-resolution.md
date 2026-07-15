# Conflict Resolution Rules

Per `DECISIONS-skills-ticket-implementer.md#D006`, when two or more per-ticket
commits in the same batch touch the same file, the coordinator must apply a
deterministic resolution rule. This file is the source of truth for the rule
set; until a real rule is settled, the **default last-writer-wins (LWW)** rule
applies.

## Conflict detection

After every batch completes (every per-ticket commit in the batch is on the
shared branch), the coordinator runs the following detection:

1. List the per-ticket commits in the batch in topological order (blockers
   first, then dependents). This is the order they were committed.
2. For each pair of adjacent commits, diff the files changed. A conflict is
   detected when:
   - Both commits modified the same file path (relative to repo root), AND
   - The diff hunks overlap (any line modified in commit N is also modified in
     commit N+1 in the same region of the same file).
3. A conflict is **content-overlap** (above) or **adjacent-hunk** (the
   hunks do not overlap but are within 3 lines of each other and touch the
   same logical block — e.g., two functions defined back-to-back). Both are
   conflicts for the purposes of this rule.

A file touched by two commits in different batches is **not** a conflict for
this rule, because the later batch's commits are the only commits touching the
file in their range; the file is already on the shared branch at the start of
the later batch and is treated as the new baseline.

## Default rule — Last-Writer-Wins (LWW)

Until a replacement rule is authored, the default rule is **LWW by commit
order on the shared branch**:

- For each conflict, the later commit in topological order is the source of
  truth.
- The earlier commit's changes to the overlapping region are dropped.
- The later commit's diff is applied as-is to the shared branch.
- The earlier commit's diff is preserved in the run summary under `Conflicts`
  with `resolution: lww-dropped` so the user can see what was lost.

### Why LWW is the default

- It is deterministic and does not require the coordinator to reason about
  content.
- It keeps the shared branch's history linear and reviewable.
- It produces a result that is always committable, never requires a manual
  merge resolution step.
- The dropped content is recoverable from the run summary and the per-ticket
  commits themselves; the user can re-apply it in a follow-up.

### When LWW is not safe

LWW can violate a ticket's stated acceptance criteria. The LWW rule must be
**suspended** in the following cases:

1. The dropped change is cited in any ticket's `Acceptance criteria` as a
   required output (e.g., "exports a function `foo`" — if the earlier ticket
   added `foo` and the later ticket removed it, LWW drops the add, breaking
   the earlier ticket's criteria).
2. The dropped change is the **only** implementation of a public API or
   schema the dependent ticket consumes.
3. The two commits are by the same sub-agent dispatch unit (same-file group
   per `DECISIONS-skills-ticket-implementer.md#D005`); within a group, all
   tickets share a single staging area, so LWW is a contradiction.

In any of these cases, the coordinator **escalates to the user** with a
clear description of the conflict and pauses the batch.

## Resolution shape

Every detected conflict is recorded in the run summary under `Conflicts` with
this shape:

```
- batch: <n>
  tickets:
    - <earlier-ticket-id>
    - <later-ticket-id>
  files:
    - <path>
  kind: <content-overlap | adjacent-hunk | same-dispatch-group>
  rule_applied: <lww-keep-later | lww-dropped | escalate>
  dropped: <one-line summary of what was lost, or empty if rule kept earlier>
  escalation: <yes | no>
  ticket_criteria_at_risk:
    - <ticket-id> — <one-line: which criterion is at risk if the rule is applied>
```

## Future rule authoring

A future revision of this file may replace the default LWW rule with one of:

- **Three-way merge**: the coordinator runs `git merge-tree` between the two
  commits with the batch's pre-batch commit as the base. If the result is
  clean, apply it. If the result has conflicts, escalate.
- **Acceptance-criteria-aware merge**: the coordinator re-dispatches the
  earlier ticket with the later ticket's diff as additional context, asking
  the sub-agent to resolve the conflict and produce a new commit.
- **Manual-only**: every conflict escalates; the run pauses for the user.

Until one of these is authored and this file is updated, LWW applies and the
rule may be re-decided at any time per the D006 hedge ("if snapshot isolation
proves too heavy, the design can be revisited").

## Co-location with the SKILL

The SKILL's Phase 4 references this file. The reference is loaded on first
conflict, not before, to keep the SKILL body lean. If this file is moved or
renamed, update the SKILL's Phase 4 reference and the Validation list in the
same edit.
