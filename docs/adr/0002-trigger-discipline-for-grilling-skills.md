# ADR 0002: Trigger discipline for competing grilling skills

- Status: Accepted
- Date: 2026-06-15
- Follow-up: 2026-08-20 - symmetric fix landed (see Follow-up section)

## Context

`skills/engineering/code-implementation-grilling/SKILL.md` over-triggered: the agent selected it whenever the user said "plan," even with no spec/PRD present. Two root causes:

1. **YAML `description` carried the bare token "plan"** in its positive clause ("from a plan, spec, or PRD"). The trigger model matched on that token broadly.
2. **The discriminator lived in the body's `When Not to Use`** ("Do not use for... creating a plan without a specification to base it from"). The trigger model does not read body sections when selecting a skill - it reads YAML only. The body gate was structurally invisible to the selector.

Compounding this, `domain-grilling`'s YAML claims "a shared understanding of a plan" without positively claiming the fuzzy-idea / no-spec territory. The two skills therefore had overlapping positive triggers ("plan") and only one of them (the wrong one for the bug) had a visible gate.

This is the cross-skill counterpart to the lesson in ADR 0001. ADR 0001 fixed single-skill activation semantics (default-on vs. opt-in). This ADR fixes *cross-skill* trigger discrimination: when two skills compete for the same trigger space, where the gate must live and how it must be encoded.

## Decision

For skills that compete for the same trigger space, the discriminator lives in the **YAML `description`**, not the body. Concretely for `code-implementation-grilling`:

- **Lead with verb + output noun** in the YAML: *"Produces a code implementation plan by grilling the user on technical choices..."* The trigger model matches on the *thing the user is asking for*, not on the negative space around it.
- **State the input precondition explicitly**: *"Use only when a spec/PRD already exists - as a referenced document or substantively present in the conversation - for a code/programming project."* The precondition names the discriminator in concrete terms (referenced, attached, substantively in conversation) rather than relying on the bare word "plan."
- **Encode cross-skill deferral by naming the alternative**: *"Defer to `domain-grilling` for vague ideas, domain modeling, or terminology alignment."* A positive pointer the trigger model can use as a tie-breaker.
- **Mirror the YAML's negative clause in the body's `When Not to Use`**, per ADR 0001's no-contradiction rule. The two surfaces stay textually close to limit drift.
- **Add `evals.json` trigger tests** covering both directions: 3 `trigger` cases (spec file path referenced; substantive conversational spec; explicit invocation) and 3 `no-trigger` cases (vague "I have a plan"; non-code idea; domain modeling question). The Skill Evaluator is what makes the wording change a verified fix rather than a hypothesis.
- **Add a glossary term** ("Code implementation plan") to `GLOSSARY.md` so the discriminator has a canonical noun and a clear boundary against "general plan," "domain model," and "spec/PRD."

A follow-up task is queued to sharpen `domain-grilling`'s YAML in a coordinated way - explicitly claiming the fuzzy-idea / domain-modeling territory and deferring code-implementation work back to `code-implementation-grilling`. The current change is intentionally scoped to one skill to avoid co-editing without that skill owner's review.

## Consequences

**Positive**

- Over-trigger fixed at the source surface (YAML `description`), which is the surface the trigger model actually reads.
- Body's `When Not to Use` is now a textual restatement of the YAML's negative clause - ADR 0001's no-contradiction rule satisfied by construction.
- Cross-skill deferral pattern is documented and reusable for any future competing-skill pair.
- `evals.json` provides regression coverage for both over-trigger (the reported bug) and under-trigger (the asymmetric risk).
- New glossary term "Code implementation plan" locks the meaning so it cannot drift across skills.

**Negative**

- Under-trigger risk: legitimate conversational specs that do not use the literal words "spec/PRD" may now be routed to `domain-grilling` instead. This is the deliberate trade-off - we are tolerating under-trigger to eliminate over-trigger.
- Asymmetric fix: `domain-grilling` is not updated in this change. Until the follow-up lands, the boundary is one-sided and borderline cases may still resolve to the wrong skill. **Resolved 2026-08-20** - see Follow-up.
- Two surfaces to keep in sync (YAML `description` and body's `When Not to Use`). Drift between them re-introduces the original bug.

**Mitigations**

- `evals.json` trigger tests verify both directions and can be re-run after any future YAML edit.
- Follow-up task is queued as a tracked issue (not a TODO comment) so it does not slip.
- The body's `When Not to Use` is intentionally short (3 bullets) and textually close to the YAML, making manual sync reviewable in a single diff.
- "Code implementation plan" is a glossary term - if the meaning drifts, the glossary will surface it in cross-skill reviews.

## Alternatives considered

- **Body-only gate (strengthen `When Not to Use`, leave YAML unchanged)** - rejected. The trigger model does not read body sections when selecting a skill. This is the structural reason the original over-trigger happened - putting the gate there again is rearranging the deck chairs.
- **Single-skill fix without cross-reference to `domain-grilling`** - rejected. Without naming the alternative skill in the YAML, the trigger model has no positive tie-breaker for borderline cases. The deferral clause is what gives the model a routing instruction rather than just a list of exclusions.
- **Amend ADR 0001 to add a cross-skill section** - rejected. ADR 0001 is specifically about single-skill activation semantics (default-on vs. opt-in). The lesson here is *cross-skill* trigger discrimination, a different problem. Conflating them in one ADR weakens both and makes future links ambiguous.
- **Defer `evals.json` to a follow-up** - rejected. The wording change is a hypothesis until verified. Shipping the fix without evals means betting on the new wording with no way to know it works. The 6 test cases are small and give the Skill Evaluator something concrete to run.

## Follow-up (2026-08-20)

The symmetric fix queued under "Consequences" landed. The full three-skill trigger triangle now mirrors across all sides, and the negation failure mode (GLOSSARY.md § Negation) is cured at the trigger surface.

### What changed

Three SKILL files were updated together (single coordinated change, no co-editing risk):

- `skills/engineering/domain-grilling/SKILL.md` - YAML description rewritten to lead with user-natural vocabulary ("align terms", "name a concept", "define a vocabulary", "nail down the language") and defer to `code-implementation-grilling` once the question turns to technical choices. Body `When Not to Use` mirrored.
- `skills/engineering/grilling/SKILL.md` - YAML description tightened from the broad "ambiguous or unclear decision" trigger (which matched too loosely against DDD-shaped prompts) to a concrete-domain list ("business, product, process, or organizational"). Both negation clauses replaced with positive deferrals to `domain-grilling` and `code-implementation-grilling`. Body `When Not to Use` mirrored.
- `skills/engineering/code-implementation-grilling/SKILL.md` - YAML description expanded to spell out the spec/PRD precondition (referenced document, attachment, or substantively present in conversation) and add reciprocal deferrals to both `domain-grilling` and `grilling`. Body `When Not to Use` mirrored.

### Why this completes the fix

The original ADR 0002 change was structurally correct for `code-implementation-grilling` but created a one-sided boundary: `code-implementation-grilling` deferred to `domain-grilling`, but `domain-grilling` and `grilling` had no reciprocal deferrals. The trigger model had a routing instruction in only one direction, so DDD-shaped prompts (e.g. "I want to align our terms", "what do we call this thing", "let's think through the concepts") still routed to `grilling` first because its bare-token trigger ("ambiguous or unclear decision") matched those prompts more loosely than `domain-grilling`'s jargon-heavy trigger.

The follow-up establishes symmetry:

| From → To | Deferral present? |
|---|---|
| `code-implementation-grilling` → `domain-grilling` | Yes (ADR 0002) |
| `code-implementation-grilling` → `grilling` | **Yes (this follow-up)** |
| `domain-grilling` → `code-implementation-grilling` | **Yes (this follow-up)** |
| `grilling` → `domain-grilling` | **Yes (this follow-up)** |
| `grilling` → `code-implementation-grilling` | **Yes (this follow-up)** |
| `domain-grilling` → `grilling` | **Yes (this follow-up)** |

Every directed edge in the triangle now has an explicit positive pointer.

### Cures applied

- **Negation failure mode** - every "Do not use when …" prohibition in the three YAMLs is replaced with a positive "Defer to …" pointer. Per writing-great-skills/GLOSSARY.md § Negation, prohibitions name the forbidden concept into context; the trigger model now routes by positive direction instead of exclusion-by-name.
- **Leading-word mismatch** - `domain-grilling`'s trigger sentence now contains the user-natural vocabulary ("align terms", "name a concept", "define a vocabulary") rather than only DDD jargon. Per GLOSSARY.md § Leading word, the trigger sentence should be worded with the leading words users actually use.
- **Body mirror** - every YAML change has a textually close body `When Not to Use` mirror (ADR 0001 no-contradiction rule), so a future edit cannot reintroduce the bug through surface drift.

### Still open

- **Eval expansion not included in this change.** Recommended additions: `trigger-vocabulary-prompt.yaml` (user-natural vocabulary only) and `no-trigger-business-pricing.yaml` (pure business decision that should route to `grilling`, not `domain-grilling`) on the `domain-grilling/evals/.../tasks/` side. Lower the no-trigger threshold on `grilling`'s `no-trigger-terminology-decision.yaml` from 0.4 to 0.5. Until those land, the wording change is a hypothesis verified by manual trigger testing, not by the Skill Evaluator.
- **GLOSSARY.md** does not yet have a "domain model" term to match the "Code implementation plan" entry added by the original ADR 0002. Recommended addition: a `domain model` term that distinguishes the conceptual map produced by `domain-grilling` from a "general plan", "code implementation plan", and "spec/PRD".
