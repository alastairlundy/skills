# Decision Ledger

The Decision Ledger is the durable record of every branch and clarifying
interaction resolved during a design or decision-elicitation session. It is a single
markdown file that uses stable `Dxxx`, `Txxx`, and `Ixxx` IDs as the
cross-reference key for every downstream consumer (memos, tickets,
blueprints, specialized decision-elicitation sessions). When citing a record from
outside the ledger file, use the `filename#<Dxxx|Txxx|Ixxx>` format
(e.g., `DECISIONS-repo-feature.md#D001`,
`DECISIONS-repo-feature.md#I002`).

This file is the **own copy** shipped with `skill-architect`. It is
identical to the canonical reference
(`skills/engineering/technical-grilling/references/decision-ledger.md`) except
for the `## When to Use` section below, which lists the skill-specific
triggers for consulting this reference. The other consumer that
ships its own copy is `spec-to-tickets`.

## When to Use

Use this reference when the agent is operating under `skill-architect`
and needs to:

- Initialize the design ledger at `<target-skill-dir>/.design-ledger.md`
  in Step 1 of the workflow (or lazily on the first append if the
  target skill directory does not yet exist).
- Append a new `Dxxx` design-decision record to the design ledger
  when the agent records a structural design decision (e.g., a
  deterministic-translation acceptance, a section-presence choice, an
  Output Mode / Transitions inclusion choice, a value-proposition
  weaving decision). The `Driver` field captures the user's underlying
  principle or motivation.
- Append a new `Ixxx` clarifying-interaction record before presenting
  the verbatim review question ("Does this translation of your intent
  into deterministic actions accurately capture what you want the
  agent to do?"), the value-proposition clarification (when the
  inference is unclear), the scope declaration confirmation, or any
  other clarifying prompt to the user. The `Ixxx` is anchored to the
  prompt that was actually presented.
- Complete a `TBD` `Ixxx` record in place after the user responds, by
  filling `User Response`, `Resolution`, and `Notes` while keeping
  the `Ixxx` in its original position in the file.
- Delete the design ledger on materialization of the `SKILL.md`,
  per the lifecycle in this reference and `saving-the-skill.md`
  Step 8 (delete only if the file exists; the deletion is conditional
  on successful materialization).

## Path derivation

For `skill-architect`, the ledger lives at
`<target-skill-dir>/.design-ledger.md` - a hidden local file in the
target skill directory, deleted on materialization. The hidden
filename (`.design-ledger.md`) keeps it out of casual file listings
while still being plain markdown.

Examples:

- Designing a new skill in `skills/engineering/<new-skill>/` →
  `skills/engineering/<new-skill>/.design-ledger.md`.
- Designing a new skill in `skills/alignment/<new-skill>/` →
  `skills/alignment/<new-skill>/.design-ledger.md`.
- Designing a new skill in `skills/skills-meta/<new-skill>/` →
  `skills/skills-meta/<new-skill>/.design-ledger.md`.

## File format

A ledger file uses three parallel ID streams:

- `Dxxx` - formal design decisions. Zero-padded sequence: `D001`, `D002`,
  `D003`, …
- `Txxx` - technical decisions emitted by `technical-grilling`.
  Zero-padded sequence: `T001`, `T002`, `T003`, …
- `Ixxx` - clarifying interactions. Zero-padded sequence: `I001`, `I002`,
  `I003`, …

Each stream is independent - `Dxxx` and `Ixxx` counters both start at
`001` and are bumped separately. The streams do not share ID space.

### Sentinel comments for next append IDs

Every ledger file ends with one HTML-style sentinel comment per active
stream. For `skill-architect`, both `Dxxx` and `Ixxx` are active:

```md
<!-- next-d: Dxxx -->
<!-- next-i: Ixxx -->
```

The agent reads each sentinel (via a targeted `read` or `grep`) to find
the next append point for its stream, instead of re-reading the entire
ledger tail. The sentinel update is **atomic with the record write**  - 
the same `edit` call that appends the new record also bumps the
sentinel to the next available ID.

If a sentinel is missing or out of sync with the highest existing ID
in its stream, fall back to scanning the file for the highest existing
`Dxxx` / `Ixxx` and re-seeding the sentinel before the next append on
that stream.

## Lazy creation

For `skill-architect`, `.design-ledger.md` is created lazily - the
target skill directory is not yet guaranteed to exist when Step 1
begins, so the file is created when the directory exists, on the first
real append at the latest. The directory is created by
`saving-the-skill.md` Step 3, before any `SKILL.md` is written. If the
agent has not yet reached Step 3, the agent attempts to create the
ledger but tolerates a "directory does not exist" failure and defers
the first append until the directory exists.

## Real-time appending

Append a record **immediately after the user resolves the branch or
answers the question**, before opening the next branch. Do not batch
the writes at session end - real-time writes give both the user and the
agent a persistent, up-to-date record to reference in later branches,
and they let the user spot a missing or weakened entry at the next
branch and correct it before drift compounds.

For `Ixxx` records, the append fires in two steps. Both steps apply
only to clarifying interactions as defined under *What counts as a
clarifying interaction* in the Ixxx record template section below -
never to a fixed elicitation prompt:

1. **Pre-question append.** Before presenting the verbatim review
   question, the value-proposition clarification, or any other
   clarifying prompt to the user, append an `Ixxx` record with the
   `Prompt` field filled and the other three fields marked `TBD`,
   then bump the `<!-- next-i: Ixxx -->` sentinel. The `TBD`
   placeholders are placeholders, not a permanent state.
2. **Post-response complete.** After the user answers, edit the same
   `Ixxx` record in place to fill `User Response`, `Resolution`, and
   `Notes` with the user's exact words and the agent's notes. Read-back
   to confirm the four fields are now filled and the `Ixxx` is in its
   expected position in the file.

## Dxxx record template

```md
### [Dxxx] - <branch name>

- **Driver**: <the user's underlying principle or motivation>
- **Resolved Answer**: <verbatim user choice>
- **Normalized Requirement**: <concise, testable statement>
- **Constraints**: <negative requirements, edge cases, or defaults>
```

- `Dxxx` is a zero-padded sequence: `D001`, `D002`, `D003`, … The next
  available ID is read from the trailing `<!-- next-d: Dxxx -->`
  sentinel. Do not reuse IDs. If the sentinel is missing or out of
  sync, fall back to scanning the file for the highest existing `Dxxx`
  and re-seeding the sentinel before the next append.
- `Driver` captures the **why** - the user's underlying principle or
  motivation behind the decision. It is distinct from `Resolved Answer`
  (the **what**) and `Normalized Requirement` (the testable outcome).
  If the user states multiple motivations, record the primary one and
  note the rest in `Constraints`.
- `Resolved Answer` is the user's exact wording (or a close paraphrase
  the user has explicitly accepted). It is **not** the agent's summary.
- `Normalized Requirement` is a single concise, testable statement an
  implementer or verifier can act on. The "testable" bar is the same as
  a PRD acceptance criterion.
- `Constraints` are negative requirements, edge cases, or defaults the
  user named (e.g., "Do not collapse multiple tabs into one session",
  "All open tabs must survive restart"). If none, write `None.`

## Anti-fabrication rules

- **Resolved Answer must come from a user response.** Never write a
  `Dxxx` record with a `Resolved Answer` that was not spoken by the
  user. If the user skips a branch or declines to answer, close with
  `DEFERRED` - do not fill the answer yourself.
- **Never mark foundation or convergence complete without explicit user
  confirmation.** The LLM may observe that checks pass; it must not
  declare convergence or foundation-complete on its own authority. The
  user must explicitly say "converged", "complete", "close out", or
  equivalent.
- **Never fabricate or reconstruct a ledger from partial context.** If
  the ledger is lost or incomplete, surface the gap to the user and
  ask how to proceed. Do not synthesize `Resolved Answer` fields from
  memory or reasoning. Valid `Ixxx` records containing permitted `TBD`
  placeholders (i.e. awaiting user response) are expected and must not
  be treated as gaps; resume completion of those records in place.

## Txxx record template

`Txxx` records are emitted by `technical-grilling` and are
not used by `skill-architect`. The full template is in
`technical-grilling/references/recording-decisions.md`.

## Ixxx record template

```md
### [Ixxx] - <short question label>

- **Prompt**: <verbatim agent prompt that was presented to the user>
- **User Response**: <verbatim user answer, or the closest paraphrase
  the user has explicitly accepted; or TBD if awaiting the response>
- **Resolution**: <how this response was used in the next step - what
  decision it drove, what option it steered toward, what constraint it
  surfaced; or TBD if awaiting the response>
- **Notes**: <anything the agent should remember for the rest of the
  session or for a future reader; or TBD if awaiting the response>
```

- `Ixxx` is a zero-padded sequence: `I001`, `I002`, `I003`, … The next
  available ID is read from the trailing `<!-- next-i: Ixxx -->`
  sentinel. Do not reuse IDs. If the sentinel is missing or out of
  sync, fall back to scanning the file for the highest existing `Ixxx`
  and re-seeding the sentinel before the next append.
- `Prompt` is the **verbatim** agent text that was presented to the
  user - the verbatim review question, the value-proposition
  clarification, the scope-declaration confirmation, or any other
  clarifying prompt. Do not paraphrase the prompt. For a user-posed
  clarifying interaction, prefix the verbatim user question with
  `<user-posed>`; the agent's answer goes in `Resolution`.
- `User Response` is the **verbatim** user text that answered the
  prompt, or a close paraphrase the user has explicitly accepted. It
  is not the agent's summary. If the user answered with multiple
  sentences, capture the load-bearing sentence and put the rest in
  `Notes`. The three fixed response types in Step 3
  ("Accept AS IS" / "Requires Modifications" / "Reject") are recorded
  verbatim here.
- `Resolution` describes what the response was used for - which
  branch it accepted, which modification it requested, which
  constraint it surfaced. If the response is a deferred or non-answer
  (e.g., "skip", "as-is", silence), the resolution still records what
  the agent did in response.
- `Notes` is for context the next reader needs that does not fit in the
  other three fields - non-load-bearing parts of the user response,
  cross-references to a `Dxxx` record the interaction drove, or edge
  cases the user named in passing.

### What counts as a clarifying interaction

An `Ixxx` record is appended only for a **clarifying interaction**: a
question that resolves an ambiguity, contradiction, or missing piece of
information that the fixed elicitation prompts do not already elicit,
and without which the current step cannot proceed. The interaction may
be agent-posed (the agent asks the user) or user-posed (the user asks
the agent mid-step).

**Never append an `Ixxx` record for a fixed elicitation prompt** - a
question the workflow asks in every session, in a fixed format, whose
outcome is already captured elsewhere. In a `technical-grilling`
session these are:

- **The goal-discovery question** - the response is the goal record
  (`Dxxx`).
- **Locked branch questions** - the context block, options table, and
  recommendation are the fixed elicitation format; the user's choice is
  recorded as a `Dxxx`/`Txxx` record.
- **Re-asks** - the DEFERRED re-ask closure records the outcome on the
  branch's own record; no separate record is created for the re-ask.
- **Gate A locked-item confirmations** - confirmed settled items are
  recorded as `Dxxx`/`Txxx` with Resolved Answer = "Resolved (by
  provided spec)".
- **Gate B readiness, output selection, and the exit gate** - fixed
  workflow prompts whose outcomes are recorded in the ledger or the
  plan output.
- **Term-resolution and ADR offers** - the acceptance is recorded by
  the `GLOSSARY.md` write, the ADR, or the branch's own record.

Other skills govern their own fixed elicitation prompts in their
`SKILL.md` and `## When to Use` sections.

**Clarifying interactions include** (non-exhaustive):

- The user's answer to a prior prompt is ambiguous, contradictory, or
  missing a load-bearing detail, and a single-sentence follow-up
  resolves it before the current step proceeds.
- The spec, codebase, or ledger surfaces a conflict or coverage gap the
  fixed prompts cannot express, and the question is asked before the
  affected step commits.
- The session's scope or intent is ambiguous and the workflow permits
  one clarifying question to pin it down.
- The user poses a clarifying question mid-step that affects how the
  step resolves.

### TBD placeholder pattern

While waiting for the user response, an `Ixxx` record is appended with
`Prompt` filled and the other three fields marked `TBD`. The `TBD`
marker is a literal string, not a fill-in for the agent to interpret.
After the user answers, edit the same record in place to fill the
three `TBD` fields - do not amend the `Prompt` field, do not create a
new `Ixxx` record for the same interaction, and do not move the record
in the file. The `Ixxx` keeps its original position.

## Goal record

The first `Dxxx` record in the ledger (`D001`) is the **goal record**.
It captures the session's foundational goal as surfaced by the
goal-discovery step. The goal record uses the same template but
with goal-specific content:

```md
### [D001] - session goal

- **Driver**: <the user's underlying motivation for the session>
- **Resolved Answer**: <the user's stated goal or goals>
- **Normalized Requirement**: <a testable statement of the session's purpose>
- **Constraints**: <any scope boundaries the user named>
```

If the user's goal changes mid-session, add a new goal record with a
fresh `Dxxx` ID and a `Supersedes: Dxxx` line in `Constraints` linking
to the prior goal record. Do not amend the prior goal record.

## Re-opens

If a branch is re-opened later in the session (because a new discovery
invalidates the earlier decision), do **not** amend the prior record.
Add a new record with a fresh `Dxxx` ID and a `Supersedes: Dxxx` line
in `Constraints`. The superseded record stays in the ledger for
traceability.

## Soft cap

If a single Decision Ledger reaches **~30 `Dxxx` records**, consider
closing it and opening a new one for the next phase of the interview.
The cap is a trigger for reflection, not a hard limit; override with
reasoning if the interview genuinely needs more. The cap does not
apply to `Ixxx` records - interaction records are typically
short-lived and the count can grow without the same reflection
trigger.

## Lifecycle by skill group

The lifecycle of the ledger file differs by the skill that creates it:

- **`skill-architect`** - `.design-ledger.md` is created at the start
  of Step 1 (Intent Intake), or lazily on the first append if the
  target skill directory does not yet exist. The file is **deleted on
  materialization** of the `SKILL.md` (the final step of
  `saving-the-skill.md`, after the file-validity checks pass). The
  deletion is conditional on file existence.
- **`technical-grilling`** - `docs/decisions/DECISIONS-*.md` is
  **persisted by default**. The agent issues a **post-session
  reminder** to delete the ledger from `docs/decisions/` once
  implementation of the resolved decisions is complete. The reminder
  is non-blocking - the user can defer or decline. The ledger is not
  deleted automatically; the user decides.
- **`spec-to-tickets`** - when a Decision Ledger and/or implementation
  blueprint is provided as input, the agent **actively prompts** the
  user after ticket creation whether to delete the source files. The
  prompt is non-blocking - the user can decline.

## Storage conventions per skill

| Skill                              | Storage location                                | Created             | Deleted by             |
|------------------------------------|-------------------------------------------------|---------------------|------------------------|
| `technical-grilling`               | `docs/decisions/DECISIONS-<repo>-<feature>.md` | First append        | User (post-session)    |
| `skill-architect`                  | `<target-skill-dir>/.design-ledger.md`          | Step 1 / first append | `saving-the-skill.md` |
| `spec-to-tickets`                  | Input ledger (read+write) or none              | n/a - consumes       | User (post-creation)   |

The `spec-to-tickets` skill does not own a ledger; it reads and writes
to the ledger provided as input (when one is provided), and is silent
about ledgers when none is provided.

## Worked example - full ledger excerpt

```md
### [D001] - session goal

- **Driver**: the user wants to design a new skill for the
  organization of daily retro notes.
- **Resolved Answer**: "design a skill that turns a brainstormed
  list of what-went-well / what-didnt / actions into a structured
  retro document."
- **Normalized Requirement**: The session shall produce a
  `SKILL.md` for a retro-formatting skill that accepts a freeform
  list and emits a structured retro document.
- **Constraints**: `None.`

### [I001] - output shape

- **Prompt**: "What does the desired output's shape look like? You
  can describe it in prose or show an example."
- **User Response**: "a markdown file with three sections: What
  Went Well, What Did Not, Action Items. Each section is a list."
- **Resolution**: drove the Output Mode decision in D002 toward
  producing a structured markdown document; informed the
  Always-present sections list.
- **Notes**: user mentioned the file should be under 200 lines and
  live at `docs/retros/<date>.md`.

### [D002] - output structure

- **Driver**: the user wants the output to be readable in a
  single screen and easy to copy into a wiki.
- **Resolved Answer**: "always-present sections, no conditional
  sections, three sections in fixed order."
- **Normalized Requirement**: The `SKILL.md` shall list three
  Always-present sections (`What Went Well`, `What Did Not`,
  `Action Items`) in fixed order; no conditional sections are
  required.
- **Constraints**: `None.`
```

<!-- next-d: D003 -->
<!-- next-i: I002 -->
