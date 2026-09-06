# ADR 0004: Grilling consolidation

- Status: Accepted
- Date: 2026-09-06

## Context

The repo previously maintained a parent/child skill pair: `grilling` (generic, non-technical decisions) and `technical-grilling` (technical/code decisions). `technical-grilling` depended on `grilling`'s reference files via relative paths (`../grilling/references/...`), creating a tight coupling between two skills that should be independently loadable.

This is the consolidation record. ADR 0002 documents the earlier trigger-discipline fix for competing grilling skills and remains valid historical context; this ADR does not supersede it.

## Decision

Consolidate into a single skill: `technical-grilling`. Remove the generic `grilling` skill entirely.

### Motivation

One grilling skill instead of a parent/child pair. `technical-grilling` must not depend on a separate generic skill's reference files. The self-containment goal (D001) drives every downstream choice: ported references, merged question tables, a standalone ADR, and a clean sweep of live-doc pointers.

### Alternatives considered

- **Keeping the parent/child pair** - rejected. The relative-path dependency means `technical-grilling` cannot load without `grilling` installed. The two skills share reference content (tone, options, recommendations, convergence, ledger) that is identical except for wording about "grilling group" vs. single-skill terms. Maintaining two copies invites drift.
- **Keeping `grilling` as a non-technical home** - rejected (D002). The vacated trigger space for non-technical vague decisions is not worth widening the skill for. The boundary stays technical-only.
- **Adding a conversational-fallback line** - rejected (D007). Consistent with D002: structured elicitation exists only for technical decisions. The three-round soft cap in `ask-questions` stands alone without a handoff target.

### Consequences

**Positive**

- `technical-grilling` is fully self-contained: all reference files live in `skills/engineering/technical-grilling/references/`.
- No relative-path dependency on another skill directory.
- The canonical Decision Ledger reference moves to `technical-grilling/references/decision-ledger.md`, with `spec-to-tickets` and `skill-architect` each shipping their own copies.
- The consolidation ADR (this file) is the sole lineage record, keeping live docs clean of history.

**Negative**

- Non-technical vague decisions have no dedicated skill. This is the deliberate trade-off per D002.
- The over-trigger boundary is enforced empirically by existing no-trigger eval tasks (business-pricing, vague-plan, non-code-idea) rather than by a second skill's deferral pointer.

## Lineage narrative

The grilling skill family has gone through three phases:

1. **Three-skill triangle** - `code-implementation-grilling`, `domain-grilling`, and `grilling` competed for overlapping trigger space. ADR 0002 fixed the trigger discipline by coordinating YAML descriptions and cross-skill deferral pointers across all three skills.

2. **Two-skill parent/child** - `domain-grilling` and `code-implementation-grilling` were merged into `technical-grilling`. The generic `grilling` skill remained as a parent, with `technical-grilling` loading its reference files via relative paths.

3. **Single self-contained skill** - `grilling` was removed. `technical-grilling` absorbed the shared reference set (tone, options, recommendations, convergence, ledger, locked-question-format) as reworded single-skill copies. This ADR is the sole record of the merge history.

## Relationship to ADR 0002

ADR 0002's YAML-craft lessons on trigger discipline remain valid and are not superseded. The status note appended to ADR 0002 records the removal; this ADR provides the full motivation and lineage. ADR 0002 addressed *how* to discriminate between competing skills; this ADR addresses *why* the competition was eliminated.
