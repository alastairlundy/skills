# Decision Ledger

The Decision Ledger is the durable record of every branch and clarifying
interaction resolved during a `technical-grilling` session. It is a single
markdown file that uses stable `Dxxx`, `Txxx`, and `Ixxx` IDs as the
cross-reference key for every downstream consumer (memos, tickets,
blueprints). When citing a record from
outside the ledger file, use the `filename#<Dxxx|Txxx|Ixxx>` format
(e.g., `DECISIONS-repo-feature.md#D001`,
`DECISIONS-repo-feature.md#I002`).

The canonical reference is this file. Two other consumers
(`skill-architect`, `spec-to-tickets`) ship their own copies
in their own `references/` directories, with a `## When to Use` section
listing the skill-specific triggers.

## Path derivation

For `technical-grilling`, the ledger lives at
`docs/decisions/DECISIONS-<repo>-<feature>.md`:

- `<repo>` is the directory name of the working repository.
- `<feature>` is a short kebab-case slug of the topic being decided
  (e.g., `tab-session-restore`, `pricing-pivot`, `retro-format`).

For `skill-architect`, the ledger lives at
`<target-skill-dir>/.design-ledger.md` - a hidden local file in the
target skill directory, deleted on materialization.

Examples:

- Working in `~/code/acme-store`, topic is "tab session restore" →
  `docs/decisions/DECISIONS-acme-store-tab-session-restore.md`.
- Working in `~/code/acme-store`, topic is "should we pivot to per-seat
  pricing" → `docs/decisions/DECISIONS-acme-store-pivot-per-seat.md`.
- Designing a new skill in `skills/engineering/<new-skill>/` →
  `skills/engineering/<new-skill>/.design-ledger.md`.

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
stream. A `technical-grilling` ledger records `Dxxx`, `Txxx`, and
`Ixxx` and ends with three sentinels:

```md
<!-- next-d: Dxxx -->
<!-- next-t: Txxx -->
<!-- next-i: Ixxx -->
```

The agent reads each sentinel (via a targeted `read` or `grep`) to find
the next append point for its stream, instead of re-reading the entire
ledger tail. The sentinel update is **atomic with the record write**  - 
the same `edit` call that appends the new record also bumps the
sentinel to the next available ID.

If a sentinel is missing or out of sync with the highest existing ID
in its stream, fall back to scanning the file for the highest existing
`Dxxx` / `Txxx` / `Ixxx` and re-seeding the sentinel before the next
append on that stream.

## Lazy creation

`docs/decisions/` (or the equivalent parent directory) is created only
when the first record of any stream is about to be written. Do not
create the directory during the initialization summary; create it on
the first real append.

When the ledger file is created
lazily on first append, it must include all three ID-stream sentinels
(`next-d`, `next-t`, `next-i`), seeded at the initial IDs (`D001`,
`T001`, `I001`), not only the stream being appended.

## Real-time appending

Append a record **immediately after the user resolves the branch or
answers the question**, before opening the next branch. Do not batch
the writes at session end - real-time writes give both the user and the
agent a persistent, up-to-date record to reference in later branches,
and they let the user spot a missing or weakened entry at the next
branch and correct it before drift compounds.

In a multi-pick round (up to 3 branches resolved in one turn), the
agent reads the current ledger and writes all new `Dxxx` records in
**one tool call** within the same turn as the resolution. Read-back
verification still applies - the agent confirms the new records are
last in the file before opening the next round. If a concurrent append
lands between the read and the write, the write may overwrite it.
Read-back detects this (the concurrent append is missing). On detection,
the agent re-reads the ledger, appends both the concurrent record and
its own records in a new single tool call, and verifies again. The trailing
`<!-- next-d: Dxxx -->` sentinel is the single source of truth for
the next ID.

For `Ixxx` records, the append fires in two steps. Both steps apply
only to clarifying interactions as defined under *What counts as a
clarifying interaction* in the Ixxx record template section below -
never to a fixed elicitation prompt:

1. **Pre-question append.** Before presenting a clarifying question,
   append an `Ixxx` record with the `Prompt` field filled and the
   other three fields marked `TBD`, then bump the
   `<!-- next-i: Ixxx -->` sentinel. The `TBD` placeholders are
   placeholders, not a permanent state.
2. **Post-response complete.** After the user answers, edit the same
   `Ixxx` record in place to fill `User Response`, `Resolution`, and
   `Notes` with the user's exact words and the agent's notes. Read-back
   to confirm the four fields are now filled and the `Ixxx` is in its
   expected position in the file.

## Conflict resolution mechanics

### Static conflict (record vs. record)

When two resolved Dxxx records have mutually-exclusive Normalized
Requirements, the agent detects the conflict before the newer branch
can resolve. The agent pauses, surfaces a fixed "Conflict detected"
callout naming both records and the contradictory Normalized
Requirements, and asks the user which resolution stands. The user owns
the resolution; the agent does not auto-resolve.

Once the user picks, the superseded record gains a
Superseded by: Dxxx line in Constraints pointing to the winning
record. The winning record is unchanged.

### Dynamic conflict (drift)

When a new resolution contradicts a prior resolution (the user changes
their mind), the agent detects the drift before the new branch can
resolve. The agent pauses, surfaces a fixed "Contradiction detected"
callout naming the prior record and the new resolution, and re-asks
the branch with the new context. The user confirms, revises, or opens
a goal-change flow.

Once the user confirms the new resolution, the new record gains a
Supersedes: Dxxx line in Constraints pointing to the earlier record it
replaces.

### DEFERRED re-ask closure

Each branch may be re-asked at most once. After 1 re-ask with no
clear answer, the branch closes with Resolved Answer = "DEFERRED"
and a Constraints line noting why (e.g., "User did not provide a
clear answer after final re-ask"). If a Dxxx record already exists
for this branch, update it in place. If no Dxxx record exists yet
(e.g., the user never provided a clear initial answer), create a
new DEFERRED Dxxx record with the branch name and the constraints
line. No separate record is created for the re-ask itself.

The re-ask preamble is fixed and cited in locked-question-format.md.

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
  user. Do not fill the answer yourself. A skip or decline on the first
  encounter triggers the single permitted re-ask (see DEFERRED re-ask
  closure above); only after the re-ask also receives no clear answer
  does the branch close with `DEFERRED`.
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

`Txxx` records are emitted by `technical-grilling` and use
the same four fields as `Dxxx`, plus an optional `Cites` field for
spec links. The full template is in
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
  user - a clarifying question posed outside the fixed elicitation
  prompts (see *What counts as a clarifying interaction* below). Do not
  paraphrase the prompt, and never use a locked question line, options
  table, gate prompt, or exit prompt here. For a user-posed clarifying
  interaction, prefix the verbatim user question with `<user-posed>`;
  the agent's answer goes in `Resolution`.
- `User Response` is the **verbatim** user text that answered the
  prompt, or a close paraphrase the user has explicitly accepted. It
  is not the agent's summary. If the user answered with multiple
  sentences, capture the load-bearing sentence and put the rest in
  `Notes`.
- `Resolution` describes what the response was used for - which option
  it steered, which branch it opened, which constraint it surfaced. If
  the response is a deferred or non-answer (e.g., "skip", "as-is",
  silence), the resolution still records what the agent did in
  response.
- `Notes` is for context the next reader needs that does not fit in the
  other three fields - non-load-bearing parts of the user response,
  cross-references to a `Dxxx`/`Txxx` record the interaction drove, or
  edge cases the user named in passing.

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

The first `Dxxx` record appended during the session is the **goal record**.
It captures the session's foundational goal as surfaced by the
goal-discovery question. For a new ledger this is `D001`; for an existing
ledger use the next available `Dxxx` ID from the sentinel. The goal record
uses the same template but with goal-specific content:

```md
### [Dxxx] - session goal

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

If a single Decision Ledger reaches **~30 `Dxxx`/`Txxx` records**,
consider closing it and opening a new one for the next phase of the
interview. The cap is a trigger for reflection, not a hard limit;
override with reasoning if the interview genuinely needs more. The cap
does not apply to `Ixxx` records - interaction records are typically
short-lived and the count can grow without the same reflection
trigger.

## Lifecycle

`docs/decisions/DECISIONS-*.md` is **persisted by default**. The agent
issues a **post-session reminder** to delete the ledger from
`docs/decisions/` once implementation of the resolved decisions is
complete. The reminder is non-blocking - the user can defer or decline.
The ledger is not deleted automatically; the user decides.

`skill-architect` creates a `.design-ledger.md` that is **deleted on
materialization** of the `SKILL.md` (the final step of
`saving-the-skill.md`, after the file-validity checks pass). The
deletion is conditional on file existence.

`spec-to-tickets` does not own a ledger; it reads and writes
to the ledger provided as input (when one is provided), and is silent
about ledgers when none is provided.

## Storage conventions

| Skill                              | Storage location                                | Created             | Deleted by             |
|------------------------------------|-------------------------------------------------|---------------------|------------------------|
| `technical-grilling`               | `docs/decisions/DECISIONS-<repo>-<feature>.md` | First append        | User (post-session)    |
| `skill-architect`                  | `<target-skill-dir>/.design-ledger.md`          | Step 1 / first append | `saving-the-skill.md` |
| `spec-to-tickets`                  | Input ledger (read+write) or none              | n/a - consumes       | User (post-creation)   |

## Worked example - full ledger excerpt

```md
### [D001] - session goal

- **Driver**: the user wants to build a platform that correctly models
  the payment relationship between contacts and client organizations.
- **Resolved Answer**: "clarify the domain model for a freelancing
  platform where contacts message on behalf of client organizations."
- **Normalized Requirement**: The session shall produce a domain model
  that distinguishes contacts from client organizations and defines
  the payment flow.
- **Constraints**: `None.`

### [I001] - payer ambiguity

- **Prompt**: "When you say the contact pays - do you mean the person
  messaging, or the client organization they act for?"
- **User Response**: "The client organization - and the platform fee
  is transparent and deducted before the freelancer receives funds."
- **Resolution**: disambiguated the payer before D002 resolved; the
  client organization is the payer in D002's Normalized Requirement,
  and the fee-transparency motivation is D003's Driver.
- **Notes**: agent-posed follow-up after the user's initial answer for
  D002 was ambiguous; the fee detail was stated in passing.

### [D002] - who hires whom

- **Driver**: the user wants the model to reflect real-world agency  - 
  the contact acts for an organization, not for themselves.
- **Resolved Answer**: "the contact is a person acting for a client
  organization; the client organization is the payer."
- **Normalized Requirement**: The platform shall distinguish between
  a `Contact` (the person messaging) and a `ClientOrganization` (the
  legal entity that invoices and pays).
- **Constraints**: Both terms must exist in the glossary
  (`docs/GLOSSARY.md`) with the definitions recorded inline here.

### [D003] - how payments are routed

- **Driver**: the user wants the platform fee to be transparent and
  deducted before the freelancer receives funds.
- **Resolved Answer**: "client organization is the payer; freelancer
  is the payee; platform takes a percentage fee."
- **Normalized Requirement**: Payment flow shall route funds from
  `ClientOrganization` to `Freelancer` with a platform fee deducted
  before the freelancer payout.
- **Constraints**: `None.`
```

<!-- next-d: D004 -->
<!-- next-t: T001 -->
<!-- next-i: I002 -->
