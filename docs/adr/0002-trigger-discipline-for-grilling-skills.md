# ADR 0002: Trigger discipline for competing grilling skills

- Status: Accepted
- Date: 2026-06-15

## Context

`skills/engineering/code-implementation-grilling/SKILL.md` over-triggered: the agent selected it whenever the user said "plan," even with no spec/PRD present. Two root causes:

1. **YAML `description` carried the bare token "plan"** in its positive clause ("from a plan, spec, or PRD"). The trigger model matched on that token broadly.
2. **The discriminator lived in the body's `When Not to Use`** ("Do not use for... creating a plan without a specification to base it from"). The trigger model does not read body sections when selecting a skill — it reads YAML only. The body gate was structurally invisible to the selector.

Compounding this, `domain-grilling`'s YAML claims "a shared understanding of a plan" without positively claiming the fuzzy-idea / no-spec territory. The two skills therefore had overlapping positive triggers ("plan") and only one of them (the wrong one for the bug) had a visible gate.

This is the cross-skill counterpart to the lesson in ADR 0001. ADR 0001 fixed single-skill activation semantics (default-on vs. opt-in). This ADR fixes *cross-skill* trigger discrimination: when two skills compete for the same trigger space, where the gate must live and how it must be encoded.

## Decision

For skills that compete for the same trigger space, the discriminator lives in the **YAML `description`**, not the body. Concretely for `code-implementation-grilling`:

- **Lead with verb + output noun** in the YAML: *"Produces a code implementation plan by grilling the user on technical choices..."* The trigger model matches on the *thing the user is asking for*, not on the negative space around it.
- **State the input precondition explicitly**: *"Use only when a spec/PRD already exists — as a referenced document or substantively present in the conversation — for a code/programming project."* The precondition names the discriminator in concrete terms (referenced, attached, substantively in conversation) rather than relying on the bare word "plan."
- **Encode cross-skill deferral by naming the alternative**: *"Defer to `domain-grilling` for vague ideas, domain modeling, or terminology alignment."* A positive pointer the trigger model can use as a tie-breaker.
- **Mirror the YAML's negative clause in the body's `When Not to Use`**, per ADR 0001's no-contradiction rule. The two surfaces stay textually close to limit drift.
- **Add `evals.json` trigger tests** covering both directions: 3 `trigger` cases (spec file path referenced; substantive conversational spec; explicit invocation) and 3 `no-trigger` cases (vague "I have a plan"; non-code idea; domain modeling question). The Skill Evaluator is what makes the wording change a verified fix rather than a hypothesis.
- **Add a glossary term** ("Code implementation plan") to `CONTEXT.md` so the discriminator has a canonical noun and a clear boundary against "general plan," "domain model," and "spec/PRD."

A follow-up task is queued to sharpen `domain-grilling`'s YAML in a coordinated way — explicitly claiming the fuzzy-idea / domain-modeling territory and deferring code-implementation work back to `code-implementation-grilling`. The current change is intentionally scoped to one skill to avoid co-editing without that skill owner's review.

## Consequences

**Positive**

- Over-trigger fixed at the source surface (YAML `description`), which is the surface the trigger model actually reads.
- Body's `When Not to Use` is now a textual restatement of the YAML's negative clause — ADR 0001's no-contradiction rule satisfied by construction.
- Cross-skill deferral pattern is documented and reusable for any future competing-skill pair.
- `evals.json` provides regression coverage for both over-trigger (the reported bug) and under-trigger (the asymmetric risk).
- New glossary term "Code implementation plan" locks the meaning so it cannot drift across skills.

**Negative**

- Under-trigger risk: legitimate conversational specs that do not use the literal words "spec/PRD" may now be routed to `domain-grilling` instead. This is the deliberate trade-off — we are tolerating under-trigger to eliminate over-trigger.
- Asymmetric fix: `domain-grilling` is not updated in this change. Until the follow-up lands, the boundary is one-sided and borderline cases may still resolve to the wrong skill.
- Two surfaces to keep in sync (YAML `description` and body's `When Not to Use`). Drift between them re-introduces the original bug.

**Mitigations**

- `evals.json` trigger tests verify both directions and can be re-run after any future YAML edit.
- Follow-up task is queued as a tracked issue (not a TODO comment) so it does not slip.
- The body's `When Not to Use` is intentionally short (3 bullets) and textually close to the YAML, making manual sync reviewable in a single diff.
- "Code implementation plan" is a glossary term — if the meaning drifts, the glossary will surface it in cross-skill reviews.

## Alternatives considered

- **Body-only gate (strengthen `When Not to Use`, leave YAML unchanged)** — rejected. The trigger model does not read body sections when selecting a skill. This is the structural reason the original over-trigger happened — putting the gate there again is rearranging the deck chairs.
- **Single-skill fix without cross-reference to `domain-grilling`** — rejected. Without naming the alternative skill in the YAML, the trigger model has no positive tie-breaker for borderline cases. The deferral clause is what gives the model a routing instruction rather than just a list of exclusions.
- **Amend ADR 0001 to add a cross-skill section** — rejected. ADR 0001 is specifically about single-skill activation semantics (default-on vs. opt-in). The lesson here is *cross-skill* trigger discrimination, a different problem. Conflating them in one ADR weakens both and makes future links ambiguous.
- **Defer `evals.json` to a follow-up** — rejected. The wording change is a hypothesis until verified. Shipping the fix without evals means betting on the new wording with no way to know it works. The 6 test cases are small and give the Skill Evaluator something concrete to run.
