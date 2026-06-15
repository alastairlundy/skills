# ADR 0001: Default-on activation for anti-slop skill

- Status: Accepted
- Date: 2026-06-15

## Context

The original `skills/alignment/anti-slop/SKILL.md` had contradictory activation semantics:

1. **YAML said `Always use this skill`** — implying default-on activation.
2. **`When to Use` listed specific triggers** (user must request "concise", "direct", or "no-fluff") — implying opt-in activation.
3. **`When Not to Use` was a cargo door** — any request could be reinterpreted as wanting a "human-like" or "social template" tone, which excluded the skill.

The combined effect: a lazy agent could skip sanitization ~90% of the time (use the stricter opt-in gate) or avoid the skill entirely (claim the request is for a "social template"). The skill existed to maximize information density and maintain a transparent AI identity, but the activation gap meant the skill often didn't run.

## Decision

The skill becomes **default-on**:

- **YAML description**: `Always use this skill. Removes AI slop, vague phrasing, and sycophancy from LLM output. Only defer when the user explicitly requests creative or roleplay content.`
- **When to Use**: a single default statement — "Applies by default to all professional, technical, and analytical responses."
- **When Not to Use**: a single tight line — "When the user explicitly requests creative writing, roleplay, or a non-professional persona."

The activation gate is the `When Not to Use` list, not the `When to Use` list. The skill applies unless the user explicitly excludes it.

## Consequences

**Positive**

- Maximum coverage. The skill is no longer skippable through gate-trick interpretation.
- YAML and body are now consistent.
- User agency preserved: explicit creative/roleplay requests still exclude the skill.
- Tightening `When Not to Use` to a single line closes the cargo door — only "creative writing, roleplay, or non-professional persona" are exempt.

**Negative**

- Some legitimate conversational-but-professional requests (e.g., "Hey, can you help me think through this?") may be over-sanitized.
- Agents may apply the skill in contexts where a warmer tone is genuinely appropriate (e.g., empathic responses to user frustration).
- The default-on behavior is more opinionated — it may conflict with user expectations set by other skills.

**Mitigations**

- The structural rules established for the skill include escape hatches for legitimate uncertainty ("Context-dependent: [condition A] → [recommendation X]; [condition B] → [recommendation Y]"), which allow nuanced responses without forcing false compliance.
- The single-line `When Not to Use` provides a clear override path: if the user wants a different mode, they can say so explicitly.

## Alternatives considered

- **Exhaustive `When to Use` list** — rejected because new use cases would require explicit listing, and the list would grow unbounded.
- **Default-on with reinforcer triggers** — rejected because it preserved the contradiction between YAML and body.
- **Literal `Always use` with no exceptions** — rejected because it removes user agency for legitimate creative/roleplay use cases.
