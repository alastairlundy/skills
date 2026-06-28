# ADR 0003: LLM Recommendations are on-demand only

- Status: Accepted
- Date: 2026-06-28

## Context

The `grilling` skill workflow presents a recommendation block at the end of every branch — a single named option the agent argues for, with a one-or-two-sentence reasoning line and a forward-risk line. The convention was inherited by `domain-grilling` and `code-implementation-grilling`. Three options for the recommendation's role were considered during a domain-grilling session on the question of how to involve the user more actively in decisions made by the grilling workflow.

The reported failure mode: when the recommendation is the default channel, the user can adopt the LLM's named option verbatim and feel the work is done. The user did not articulate the decision; the LLM did. This makes the LLM a default decision-maker rather than a translator of the user's intent. The user reported that "it is too easy to just adopt the LLM recommendations" and that they want the user to be more responsible for the decision.

The LLM's role in the grilling workflow is to translate the user's stated intent (which may be fuzzy or unstated) into 2–4 concrete natural options and let the user pick. A default-channel recommendation biases the picking step. Three options for the recommendation's role:

1. **Remove entirely** — the LLM never produces a recommendation; each branch ends at the concrete natural options.
2. **On-demand only** — the LLM offers a recommendation only if the user explicitly asks for one (e.g., "what's your take?", "what do you think?"). The default branch flow ends at the options.
3. **Retain, but only after the user picks** — the LLM surfaces the options first; after the user picks, the LLM optionally surfaces a one-line "alternative perspective" naming the trade-off the user just accepted.

The trade-off being made: keeping recommendations in any form risks the rubber-stamp failure mode. Removing them entirely loses the second-opinion affordance that some users rely on for subtle trade-offs.

## Decision

LLM Recommendations are on-demand only.

- The LLM shall not produce a recommendation in the default flow of any branch.
- The LLM shall surface a recommendation only if the user explicitly asks for one ("what's your take?", "what do you think?", "what would you do?"). The user's exact phrasing is not required; any unambiguous request for the LLM's opinion qualifies.
- The LLM shall not pre-suggest ("would you like my take?") at the end of a branch. The user is expected to know the affordance exists; the LLM surfaces it on request, not by invitation.
- A forced-justification mechanism (a follow-up branch that would have required the user to give a one-line reason for adopting the recommendation verbatim) is formally retired along with the default-channel recommendation.
- A follow-up branch in the same Decision Ledger is required to record the LLM-disciplined-no-pre-suggest rule explicitly in the `grilling` skill workflow (`skills/engineering/grilling/SKILL.md`) and the inherited workflows of `domain-grilling` and `code-implementation-grilling`. This ADR establishes the convention; the skill edits propagate it.

## Consequences

**Positive**

- The default channel is recommendation-free, removing the rubber-stamp failure mode at the structural level rather than at the level of individual agent discipline.
- The user is the named decision-maker on every branch. The LLM's role is reduced to translator and (on request) second opinion.
- The second-opinion affordance is preserved for users who want it, with a clear, observable signal (the user asking) that the user has chosen to see it.
- The convention is durable — anchored in this ADR — and propagates to all skills that inherit the grilling workflow.

**Negative**

- Users who relied on the default-channel recommendation for subtle trade-off second opinions must learn to ask. The cost is a one-time learning curve; the benefit is durable agency.
- The LLM must be disciplined about not pre-suggesting at the end of a branch. The "no pre-suggest" rule is a positive constraint that requires an explicit instruction in the skill body — the absence of the recommendation block alone is not enough to enforce it.
- If the LLM interprets "would you like my take?" type phrasings as part of helpful closing remarks, the rule is violated silently. The rule must be stated explicitly in the skill workflow.

**Mitigations**

- The follow-up branch records the LLM-disciplined-no-pre-suggest rule as an explicit instruction in the `grilling` skill body and the inherited bodies. The rule is a positive constraint, not a derived behaviour.
- This ADR makes the convention citable from any future skill edit. A future maintainer who edits the recommendation block can be pointed to this ADR.
- The on-demand affordance is reachable by any user phrasing the LLM recognises as a request for its opinion. The skill does not lock the affordance behind a specific magic phrase.
- The forced-justification mechanism's retirement is recorded as a consequence, so a future re-proposal of the mechanism is forced to engage with this ADR rather than re-deriving the design from scratch.

## Alternatives considered

- **Remove entirely.** The LLM never produces a recommendation. Rejected because it loses the second-opinion affordance for users who want it. A user who explicitly asks "what do you think?" would have to be redirected to invent a new format; the on-demand pattern keeps the affordance reachable.

- **Retain, but only after the user picks (post-pick perspective).** The LLM surfaces the options first; after the user picks, the LLM optionally surfaces a one-line alternative perspective. Rejected because the post-hoc commentary reads as the LLM second-guessing the user, which can prompt unnecessary re-opens. The on-demand pattern moves the affordance to a user-initiated moment, where the user is already asking for the second opinion.

- **Defer the recommendation question to a follow-up branch.** Keep the default-channel recommendation pending a separate decision. Rejected because the user reported the failure mode as a current problem, not a hypothetical one. Deferral leaves the failure mode in place.

- **Default-channel recommendation with a forced-justification mechanism.** The LLM still produces a recommendation by default, but the user must give a one-line reason for adopting it. Rejected because the mechanism is reactive — it catches the failure mode after the user has rubber-stamped, not at the point of decision. The on-demand pattern is proactive: the recommendation does not appear in the default flow at all.
