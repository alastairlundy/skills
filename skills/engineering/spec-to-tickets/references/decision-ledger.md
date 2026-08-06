# Decision Ledger

The Decision Ledger is the durable record of every branch and clarifying
interaction resolved during a grilling or design session. It is a single
markdown file that uses stable `Dxxx`, `Txxx`, and `Ixxx` IDs as the
cross-reference key for every downstream consumer (memos, tickets,
blueprints, specialized grilling sessions). When citing a record from
outside the ledger file, use the `filename#<Dxxx|Txxx|Ixxx>` format
(e.g., `DECISIONS-repo-feature.md#D001`,
`DECISIONS-repo-feature.md#I002`).

This file is the **own copy** shipped with `spec-to-tickets`. It is
identical to the canonical reference
(`skills/engineering/grilling/references/decision-ledger.md`) except
for the `## When to Use` section below, which lists the skill-specific
triggers for consulting this reference. The two other consumers that
ship their own copies are `skill-architect` and (for the canonical,
loaded via relative path) the two children of `grilling`
(`domain-grilling`, `code-implementation-grilling`).

## When to Use

Use this reference when the agent is operating under `spec-to-tickets`
and needs to:

- Detect a Decision Ledger at the input layer. When the input is a
  spec or PRD that ships with an accompanying Decision Ledger (or
  when the user passes a Decision Ledger path explicitly), load this
  reference for the citation format (`filename#<Dxxx|Txxx>`) and
  the record-completion patterns. The agent does not own a ledger
  itself; it reads and writes to the ledger provided as input.
- Record a clarifying interaction in the input ledger before
  presenting a question to the user. When the agent asks the user a
  clarification question during Step 3 (Input Sufficiency Check),
  Step 4 (Codebase Exploration), or Step 6 (Ticket Decomposition),
  append a fresh `Ixxx` record to the input ledger before the
  question is presented, with `Prompt` filled and the other three
  fields set to `TBD`. After the user responds, complete the `Ixxx`
  in place. The `Ixxx` is anchored to the prompt that was actually
  presented.
- Prompt the user for deletion of the input ledger (and any
  companion implementation blueprint named in the same path family)
  after ticket creation, per the lifecycle in this reference and
  per the Step 10 prompt below. The deletion prompt is non-blocking
  — the user can decline.

## Path derivation

For `spec-to-tickets`, the ledger path is **not derived** by the
agent — the ledger is provided as input, either explicitly (the user
names the path) or implicitly (the spec body or accompanying
documentation references it). The agent reads the user-supplied path
or follows the reference in the spec to the file.

If the input is a `domain-grilling` or `code-implementation-grilling`
output, the ledger typically lives at
`docs/decisions/DECISIONS-<repo>-<feature>.md` and any companion
implementation blueprint at
`docs/blueprints/BLUEPRINT-<repo>-<feature>.md` (or a similar
sibling path). The agent treats the input ledger and any companion
blueprint as the source of truth for resolved decisions and for
ticket-coverage citations.

If no Decision Ledger is detected, the agent routes per Step 3
(DDD-alignment rule) and continues without ledger I/O. The agent
does not create a Decision Ledger of its own — `spec-to-tickets` is
not a ledger-owning skill.

## File format

A ledger file uses three parallel ID streams:

- `Dxxx` — formal design decisions. Zero-padded sequence: `D001`, `D002`,
  `D003`, …
- `Txxx` — technical decisions emitted by `code-implementation-grilling`.
  Zero-padded sequence: `T001`, `T002`, `T003`, …
- `Ixxx` — clarifying interactions. Zero-padded sequence: `I001`, `I002`,
  `I003`, …

Each stream is independent — `Dxxx` and `Ixxx` counters both start at
`001` and are bumped separately. The streams do not share ID space.

### Sentinel comments for next append IDs

Every ledger file ends with one HTML-style sentinel comment per active
stream. For an input ledger that records `Dxxx` and `Ixxx` (or
`Dxxx`, `Txxx`, and `Ixxx`), the sentinels are the same as in the
canonical reference:

```md
<!-- next-d: Dxxx -->
<!-- next-i: Ixxx -->
```

or, for a `code-implementation-grilling` ledger:

```md
<!-- next-d: Dxxx -->
<!-- next-t: Txxx -->
<!-- next-i: Ixxx -->
```

The agent reads each sentinel (via a targeted `read` or `grep`) to find
the next append point for its stream, instead of re-reading the entire
ledger tail. The sentinel update is **atomic with the record write** —
the same `edit` call that appends the new record also bumps the
sentinel to the next available ID.

If a sentinel is missing or out of sync with the highest existing ID
in its stream, fall back to scanning the file for the highest existing
`Dxxx` / `Txxx` / `Ixxx` and re-seeding the sentinel before the next
append on that stream.

## Lazy creation

`spec-to-tickets` does not create ledgers. The agent reads the
input ledger (when one is provided) and appends `Ixxx` records
directly to it. The input ledger must already exist; the agent
does not create `docs/decisions/` or any equivalent directory.

## Real-time appending

Append a record **immediately after the user resolves the branch or
answers the question**, before opening the next branch. Do not batch
the writes at session end — real-time writes give both the user and the
agent a persistent, up-to-date record to reference in later branches,
and they let the user spot a missing or weakened entry at the next
branch and correct it before drift compounds.

For `Ixxx` records, the append fires in two steps:

1. **Pre-question append.** Before presenting a clarification
   question to the user, append an `Ixxx` record to the input
   ledger with the `Prompt` field filled and the other three
   fields marked `TBD`, then bump the `<!-- next-i: Ixxx -->`
   sentinel. The `TBD` placeholders are placeholders, not a
   permanent state.
2. **Post-response complete.** After the user answers and the
   branch resolves, edit the same `Ixxx` record in place to fill
   `User Response`, `Resolution`, and `Notes` with the user's exact
   words and the agent's notes. Read-back to confirm the four
   fields are now filled and the `Ixxx` is in its expected position
   in the file.

## Dxxx record template

```md
### [Dxxx] — <branch name>

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
- `Driver` captures the **why** — the user's underlying principle or
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
  user named. If none, write `None.`

## Txxx record template

`Txxx` records are emitted by `code-implementation-grilling` and use
the same four fields as `Dxxx`, plus an optional `Cites` field for
spec links. The full template is in
`code-implementation-grilling/references/recording-decisions.md`.

## Ixxx record template

```md
### [Ixxx] — <short question label>

- **Prompt**: <verbatim agent prompt that was presented to the user>
- **User Response**: <verbatim user answer, or the closest paraphrase
  the user has explicitly accepted; or TBD if awaiting the response>
- **Resolution**: <how this response was used in the next step — what
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
  user — the input-clarification question, the coverage-gap question,
  the closing-question item, or any other clarifying prompt. Do not
  paraphrase the prompt.
- `User Response` is the **verbatim** user text that answered the
  prompt, or a close paraphrase the user has explicitly accepted. It
  is not the agent's summary. If the user answered with multiple
  sentences, capture the load-bearing sentence and put the rest in
  `Notes`.
- `Resolution` describes what the response was used for — which
  coverage gap it closed, which decision-record citation it clarified,
  which decomposition adjustment it drove. If the response is a
  deferred or non-answer, the resolution still records what the agent
  did in response.
- `Notes` is for context the next reader needs that does not fit in the
  other three fields — non-load-bearing parts of the user response,
  cross-references to a `Dxxx` / `Txxx` record the interaction drove,
  or edge cases the user named in passing.

### TBD placeholder pattern

While waiting for the user response, an `Ixxx` record is appended with
`Prompt` filled and the other three fields marked `TBD`. The `TBD`
marker is a literal string, not a fill-in for the agent to interpret.
After the user answers, edit the same record in place to fill the
three `TBD` fields — do not amend the `Prompt` field, do not create a
new `Ixxx` record for the same interaction, and do not move the record
in the file. The `Ixxx` keeps its original position.

## Goal record

The first `Dxxx` record in the ledger (`D001`) is the **goal record**.
It captures the session's foundational goal as surfaced by the
goal-discovery step. The goal record uses the same template but
with goal-specific content:

```md
### [D001] — session goal

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

If a single Decision Ledger reaches **~30 `Dxxx` / `Txxx` records**,
consider closing it and opening a new one for the next phase of the
interview. The cap is a trigger for reflection, not a hard limit;
override with reasoning if the interview genuinely needs more. The cap
does not apply to `Ixxx` records — interaction records are typically
short-lived and the count can grow without the same reflection
trigger.

## Lifecycle by skill group

The lifecycle of the ledger file differs by the skill that creates it:

- **`skill-architect`** — `.design-ledger.md` is created at the start
  of Step 1 (Intent Intake), or lazily on the first append if the
  target skill directory does not yet exist. The file is **deleted on
  materialization** of the `SKILL.md` (the final step of
  `saving-the-skill.md`, after the file-validity checks pass). The
  deletion is conditional on file existence.
- **Grilling group** (`grilling`, `domain-grilling`,
  `code-implementation-grilling`) — `docs/decisions/DECISIONS-*.md` is
  **persisted by default**. The agent issues a **post-session
  reminder** to delete the ledger from `docs/decisions/` once
  implementation of the resolved decisions is complete. The reminder
  is non-blocking — the user can defer or decline. The ledger is not
  deleted automatically; the user decides.
- **`spec-to-tickets`** — when a Decision Ledger and/or implementation
  blueprint is provided as input, the agent **actively prompts** the
  user after ticket creation whether to delete the source files. The
  prompt is non-blocking — the user can decline.

## Storage conventions per skill

| Skill                              | Storage location                                | Created             | Deleted by             |
|------------------------------------|-------------------------------------------------|---------------------|------------------------|
| `grilling`                         | `docs/decisions/DECISIONS-<repo>-<feature>.md` | First append        | User (post-session)    |
| `domain-grilling`                  | `docs/decisions/DECISIONS-<repo>-<feature>.md` | First append        | User (post-session)    |
| `code-implementation-grilling`     | `docs/decisions/DECISIONS-<repo>-<feature>.md` | First append        | User (post-session)    |
| `skill-architect`                  | `<target-skill-dir>/.design-ledger.md`          | Step 1 / first append | `saving-the-skill.md` |
| `spec-to-tickets`                  | Input ledger (read+write) or none              | n/a — consumes       | User (post-creation)   |

The `spec-to-tickets` skill does not own a ledger; it reads and writes
to the ledger provided as input (when one is provided), and is silent
about ledgers when none is provided.

## Worked example — full ledger excerpt

```md
### [D001] — session goal

- **Driver**: the user wants to track session restore behaviour in
  the desktop client.
- **Resolved Answer**: "clarify the tab session restore flow."
- **Normalized Requirement**: The session shall produce a
  decomposition into implementation tickets that respects the
  resolved tab-restore decisions.
- **Constraints**: `None.`

### [I001] — coverage gap on D004

- **Prompt**: "I notice D004 (per-tab recovery window) has no
  covering ticket in the proposed set. Should I add a ticket for
  it, or is it intentionally out of scope for this PR?"
- **User Response**: "Add a ticket; per-tab window is in scope."
- **Resolution**: drove the addition of TK003 to the proposal;
  the new ticket cites D004 in its acceptance criteria.
- **Notes**: `None.`

### [D002] — per-tab recovery window

- **Driver**: the user wants per-tab recovery windows so partial
  failures do not roll back unrelated tabs.
- **Resolved Answer**: "per-tab recovery window, 5 minutes."
- **Normalized Requirement**: Each tab shall be wrapped in a
  5-minute recovery window; partial failures shall not roll
  back unrelated tabs.
- **Constraints**: Do not collapse multiple tabs into one
  recovery window.
```

<!-- next-d: D001 -->
<!-- next-i: I001 -->
