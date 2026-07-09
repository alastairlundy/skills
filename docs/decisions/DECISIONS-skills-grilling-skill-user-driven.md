# Decision Ledger — skills / grilling-skill-user-driven

Topic: revise the `grilling` skill so the user owns each decision and the
LLM facilitates. Shift decision authority from the LLM's recommendation
to the user's own reasoning.

### [D001] — recommendation role

- **Resolved Answer**: "Option 1 but some tiny degree of Socratic elicitation is needed for the LLM to provide helpful options that don't just make the user's answer look better by comparison."
- **Normalized Requirement**: The grilling skill's recommendation step shall invite the user to state their own answer first; the LLM shall then present options with What/Benefit/Cost/Risk and a goal-aligned recommendation as a reference set, allowing the user to confirm, revise, or hybridize; the LLM shall perform a small amount of Socratic elicitation before generating options so the options are grounded in the user's actual values rather than merely affirming the user's pre-existing answer.
- **Constraints**: The Socratic elicitation shall be limited in scope (a small set of questions, not a full Socratic interview) to avoid the cost of Option 2's full elicitation flow. The post-pick LLM step shall be informational, not adversarial. The recommendation's reasoning shall be grounded in goal alignment, not option-versus-option comparison.

### [D002] — elicitation scope

- **Resolved Answer**: "Option 1. Only an explicit answer that is required can meaningfully enact this change."
- **Normalized Requirement**: The grilling skill shall ask exactly one targeted Socratic question before the user states their own answer; the user shall be required (not merely invited) to provide an explicit answer before the LLM presents options, so the user's own answer is the actual anchor that drives the decision.
- **Constraints**: An "invitation" to provide an answer is not sufficient — the requirement is the mechanism that enacts the user-driven shift. The elicitation question must be genuinely Socratic (open, value-surfacing) and must be designed together with the locked question format so the format requires the answer rather than merely inviting it.

### [D003] — locked question format

- **Resolved Answer**: "Option 2 - The requirement should be explicit, not a hidden or opaque requirement or surprise."
- **Normalized Requirement**: The grilling skill's locked question format shall explicitly state the requirement to provide an answer (e.g., "required — state your answer before the LLM presents options") so the user is not surprised by an implicit requirement enforced by flow alone.
- **Constraints**: The explicit "required" framing aligns with the Socratic and honest posture of the skill. Hidden or opaque requirements enforced only by flow are forbidden; the format must make the requirement transparent and upfront.

### [D004] — ledger content format

- **Resolved Answer**: "The driver field"
- **Normalized Requirement**: The Decision Ledger template shall add a "Driver" field that captures the user's underlying principle or motivation behind the decision, alongside the existing Resolved Answer, Normalized Requirement, and Constraints fields.
- **Constraints**: The Driver field captures the "why" (the user's underlying principle) separately from the "what" (Resolved Answer) and the "testable outcome" (Normalized Requirement). The format guidance must define the boundary clearly to prevent overlap with Normalized Requirement.

### [D005] — context provision

- **Resolved Answer**: "Always provide fixed content block"
- **Normalized Requirement**: The grilling skill shall require the LLM to provide a fixed context block before every locked question, containing the goal of the overall decision, the prior decisions that affect the current branch (with ledger citations), the stakes (why this decision matters), and the scope (what is in and out of the decision).
- **Constraints**: All four elements (goal, prior decisions, stakes, scope) are mandatory for every branch. The format guidance must cap each element at one sentence to keep context bounded and predictable.

### [D006] — recommendation reasoning

- **Resolved Answer**: "Option 1 with some tweaks - The user should be told they can ask the LLM for the recommendation rationale. If prompted for the recommendation rationale the LLM should provide concise reasoning as to why the other options are less aligned with the user's goal. If the user clarifies their goal during the grilling: open branches should be re-asked, the user should be asked if closed branches need revisiting. The goal change/clarification should be documented in the decision ledger."
- **Normalized Requirement**: The grilling skill's Reasoning field shall be purely goal-alignment with no option-comparison. The LLM shall inform the user that they can ask for the recommendation rationale (the rejection rationale for the other options). When the user asks, the LLM shall provide concise goal-aligned rejection rationale. When the user clarifies or changes their goal mid-session: open branches shall be re-asked with the updated context; the user shall be asked whether closed branches need revisiting (the LLM shall not decide unilaterally); and the goal change or clarification shall be documented as its own record in the Decision Ledger.
- **Constraints**: The rejection rationale, when requested, must be goal-aligned, not option-comparison. Open branches must be re-asked explicitly, not silently re-anchored. The user decides whether closed branches need revisiting; the LLM does not decide. Goal changes are documented as new records (with their own Driver field per D004), not amended into prior records.

### [D007] — Socratic elicitation question

- **Resolved Answer**: "Option 1 - An open-ended question is the right type of question. The phasing 'what matters most in this decision' may narrow down the answer which is somewhat contrary to the open ended question type's purpose."
- **Normalized Requirement**: The grilling skill's Socratic elicitation question shall be open-ended and value-surfacing, asking the user to articulate what they care about for the current decision without presupposing what "matters most" or any other narrowing framing.
- **Constraints**: The question must genuinely open the user's thinking rather than narrow it. Preset dimensions like "what matters most" or "what does success look like" can steer the user toward a particular priority; the question format should be open enough to let the user define the dimension, not just rank within a preset one.

### [D008] — goal initialization

- **Resolved Answer**: "Option 2 - The issue with Option 1 is that the user may or may not know the goal upfront, but even if they do - the LLM must then extract the goal from the initial message. This seems less reliable than just asking the user as a 'step zero'."
- **Normalized Requirement**: The grilling skill's first turn shall be an open Socratic question to surface the goal of the session; the user's response shall be recorded as the foundational goal record in the Decision Ledger; subsequent context blocks (per D005) and recommendation reasoning (per D006) shall reference this record.
- **Constraints**: The LLM's question must be genuinely open and not steer the user's articulation of the goal. The LLM shall always ask the goal-discovery question as step zero, even if the user has pre-stated a goal in the initial message; relying on extraction from the initial message is forbidden because it is less reliable than asking explicitly. The goal-discovery question and the per-branch Socratic elicitation question (per D007) must be defined together for consistency.

### [D009] — goal-discovery question phrasing

- **Resolved Answer**: "Option 1 with a tweak. The should be an instruction for answering the goal-discovery question that says that providing one goal or multiple goals is allowed."
- **Normalized Requirement**: The grilling skill's goal-discovery question shall be "What are your goals for this idea?" with acknowledgment of any pre-stated goal and an ask for confirmation or refinement. The question's instruction shall explicitly state that the user may provide one goal or multiple goals.
- **Constraints**: The plural wording of "goals" must be paired with an explicit instruction that one goal is also a valid answer; the LLM must not pressure the user to provide multiple goals when they have one. The acknowledgment + confirmation pattern for the pre-stated case is preserved.

### [D010] — options as reference set

- **Resolved Answer**: "Option 1 - Preamble before options"
- **Normalized Requirement**: The grilling skill's options block shall be preceded by a brief preamble that explicitly states the options are a reference set the user can use to refine or confirm their own answer, allowing the user to pick one, reject all, or hybridize.
- **Constraints**: The preamble must be part of the options block (not optional prose). The existing options format (What it is / Benefit / Cost / Risk) is preserved. The wording must convey the reference framing without lecturing.

### [D011] — per-branch Socratic elicitation question phrasing

- **Resolved Answer**: "Option 1"
- **Normalized Requirement**: The grilling skill's per-branch Socratic elicitation question shall be "What are you working toward in this decision?" — an open-ended, value-surfacing question scoped to the current decision that uses goal-articulation language to draw out the user's values before they state their own answer.
- **Constraints**: The question is asked after the context block (per D005) and before the user states their own answer for the branch. The question uses goal-articulation language, not problem-solving language. The per-branch question and the goal-discovery question (per D009) must be defined together for consistency.

### [D012] — post-pick step

- **Resolved Answer**: "Option 1"
- **Normalized Requirement**: After the user resolves a branch, the LLM shall confirm the pick in one sentence, remind the user they can ask for the goal-aligned rejection rationale for the other options, record the decision in the Decision Ledger, and move to the next branch.
- **Constraints**: The post-pick confirmation is one sentence. The "you can ask" reminder is part of the post-pick template, not optional prose. The LLM does not volunteer analysis the user did not ask for. The recording happens before moving to the next branch, per the real-time appending rule.

### [D013] — goal-change handling workflow

- **Resolved Answer**: "Option 3 is the right choice but we haven't discussed how the LLM flags potential shifts in goals."
- **Normalized Requirement**: The grilling skill's goal-change handling workflow shall support two paths: the user can initiate a goal change explicitly, and the LLM can flag a potential goal shift. In both cases, the user decides whether a change has occurred. When a change is confirmed, the LLM shall document the change as its own record in the Decision Ledger (with a Driver field per D004 and a link to the prior goal record), re-ask open branches with the updated context, and ask the user whether closed branches need revisiting.
- **Constraints**: The LLM's flag is a question, not a determination. The user always decides whether the goal has changed. The LLM's flagging mechanism — when the LLM surfaces a question vs. stays quiet — is defined in a separate branch.

### [D014] — LLM's flagging mechanism for potential goal shifts

- **Resolved Answer**: "Option 1 - Contradictions are flagged."
- **Normalized Requirement**: The LLM shall surface a goal-shift question only when the user's response directly contradicts the recorded goal. The LLM shall not flag subtle or gradual shifts; the user can initiate a goal change explicitly at any time.
- **Constraints**: Direct contradiction is the only trigger for the LLM's flag. The LLM's flag is a question, not a determination. The post-pick template should remind the user that they can initiate a goal change at any time, so the user-initiated path is discoverable.

### [D015] — workflow steps

- **Resolved Answer**: "Option 1 - full workflow redesign is the only way to fully implement the changes specified."
- **Normalized Requirement**: The grilling skill's workflow shall be redesigned as a sequence of clearly named phases: initialization (step zero, goal-discovery question per D008–D009), per-branch (context block per D005, Socratic elicitation per D007/D011, user-stated answer, options with preamble per D010, recommendation per D001/D006, pick), post-pick (confirmation and "you can ask" reminder per D012, recording), goal-change handling (per D013/D014), convergence, and exit paths.
- **Constraints**: Each phase shall have a clear name and trigger. The workflow is a full redesign, not an incremental update. The format guidance should make the phases discoverable (e.g., a one-line summary of each phase at the top of the workflow section).

### [D016] — convergence test

- **Resolved Answer**: "Option 2 - If the goal shifts then the grilling is clearly not over and there are potential unresolved problems until the user confirms whether the goal shift is valid/not and whether the goal shift warrants revisiting the branches if the goal shift is valid."
- **Normalized Requirement**: The convergence test shall add a check for unresolved goal shifts — if a goal shift has been flagged (per D014) or initiated by the user (per D013) but not yet confirmed by the user, or if confirmed but the question of revisiting closed branches has not yet been resolved, convergence is not reached.
- **Constraints**: The check covers both confirmation of the shift and the revisit decision. A flagged-but-unconfirmed shift blocks convergence. A confirmed shift with an unresolved revisit decision also blocks convergence. Once both are resolved, convergence can proceed.

### [D017] — exit paths

- **Resolved Answer**: "Remove 'Document the decision' as an exit path. 'Specialize to DDD' should only be shown as an exit path if there are genuine domain or terminology alignment issues that need resolving. 'Specialize to Code Implementation Grilling' should only be shown as an exit path if the problem would benefit from a code/technical implementation of a solution."
- **Normalized Requirement**: The grilling skill's exit paths shall be revised as follows: (1) "Document the decision" is removed as an exit path; the ledger is the documentation. (2) "Specialize to DDD" is conditional, shown only when genuine domain or terminology alignment issues need resolving. (3) "Specialize to Code Implementation Grilling" is conditional, shown only when the problem would benefit from a code/technical implementation. The remaining exit paths (Decompose, Handoff, Custom save) are preserved.
- **Constraints**: The conditional paths are only shown when the condition is met, not always offered. The LLM must assess whether the conditions are met, but the user owns the decision and can override. The exit paths are offered as a reference set (consistent with D010), and the user can pick, reject, or propose their own.

### [D018] — goal-change record format

- **Resolved Answer**: "Option 2"
- **Normalized Requirement**: The Decision Ledger template shall add a "Supersedes" field that explicitly links to the prior record being replaced (e.g., `Supersedes: Dxxx`), separate from the Constraints field. The field is empty for most records and is used only when a record supersedes a prior one (e.g., a goal change).
- **Constraints**: The "Supersedes" field is empty for non-superseding records. The field is separate from Constraints, which remains for negative requirements, edge cases, and defaults. The Driver field (per D004) and the Supersedes field together capture the goal change's "why" and "from where."

### [D019] — validation section

- **Resolved Answer**: "Option 1"
- **Normalized Requirement**: The validation checklist shall be updated to reflect the new design, organized by phase (initialization, per-branch, post-pick, goal-change, convergence, exit). The checklist shall include pre-conditions (six references loaded, goal-discovery question asked, ledger path confirmed) and output checks (context block provided, Socratic elicitation asked, user-stated answer before options, options preamble present, recommendation reasoning is goal-aligned, "you can ask" reminder in post-pick, goal-change handling correct, conditional exit paths correctly applied, no LLM-led options comparison, ledger complete with Driver and Supersedes fields where applicable).
- **Constraints**: The checklist should pair each check with the principle behind it, so the checklist verifies principles, not just boxes. The checklist should distinguish "must pass" checks from "should pass" checks.

### [D020] — tone and output discipline

- **Resolved Answer**: "Option 1"
- **Normalized Requirement**: The tone and output discipline shall be updated to include the new design principles: (1) no LLM-led framing — the LLM does not decide for the user; (2) explicit requirements — no hidden or opaque requirements enforced only by flow; (3) no adversarial pushback — the LLM does not push back against the user's choice; (4) Socratic posture — the LLM draws out the user's thinking rather than directing it. The existing tone rules (no evaluative openers, no forbidden filler words, conciseness, branch transitions) are preserved.
- **Constraints**: The tone rules and the validation checklist (per D019) shall be distinguished: tone rules describe how the LLM writes, the validation checklist verifies whether the LLM followed the rules. The tone rules should state the principles, with prohibitions following from the principles, not a bare list of prohibitions.

### [D021] — "When to Use" / "When Not to Use" sections

- **Resolved Answer**: "Option 1"
- **Normalized Requirement**: The "When to Use" section shall be updated with triggers that reflect the new design — e.g., "the user wants to own each decision," "the user wants the LLM to facilitate rather than direct," "the user is willing to articulate their own answers." The "When Not to Use" section shall be updated with anti-patterns that reflect the new design — e.g., "the user wants the LLM to decide for them," "the user wants the LLM to push back on their choices," "the user wants a quick recommendation without deliberation."
- **Constraints**: The triggers must be specific enough that the skill is discoverable for the right use cases. The anti-patterns must be specific enough to exclude the wrong cases. The format guidance should give examples of substantive triggers and anti-patterns, not just rewording.

### [D022] — SKILL.md implementation approach

- **Resolved Answer**: "Option 3 but I'll do that later after grilling has concluded"
- **Normalized Requirement**: The actual SKILL.md implementation shall be done using the Skill Architect skill, but the implementation is deferred until after the current grilling session concludes.
- **Constraints**: The Skill Architect skill must be provided with all 22 decisions (D001–D022) as context so the new SKILL.md reflects the new design. The existing six reference files may need updates to reflect the new design — these updates should be done together with the SKILL.md rewrite so the SKILL.md and references stay in sync.
