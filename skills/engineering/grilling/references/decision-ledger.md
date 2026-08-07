# Decision Ledger

The Decision Ledger is the durable record of every branch and clarifying
interaction resolved during a grilling or design session. It is a single
markdown file that uses stable `Dxxx`, `Txxx`, and `Ixxx` IDs as the
cross-reference key for every downstream consumer (memos, tickets,
blueprints, specialized grilling sessions). When citing a record from
outside the ledger file, use the `filename#<Dxxx|Txxx|Ixxx>` format
(e.g., `DECISIONS-repo-feature.md#D001`,
`DECISIONS-repo-feature.md#I002`).

The canonical reference is this file. The two children of `grilling`
(`domain-grilling`, `code-implementation-grilling`) load it via the
relative path `../grilling/references/decision-ledger.md`. The two other
consumers (`skill-architect`, `spec-to-tickets`) ship their own copies
in their own `references/` directories, with a `## When to Use` section
listing the skill-specific triggers.

## Path derivation

For grilling and its children, the ledger lives at
`docs/decisions/DECISIONS-<repo>-<feature>.md`:

- `<repo>` is the directory name of the working repository.
- `<feature>` is a short kebab-case slug of the topic being grilled
  (e.g., `tab-session-restore`, `pricing-pivot`, `retro-format`).

For `skill-architect`, the ledger lives at
`<target-skill-dir>/.design-ledger.md` — a hidden local file in the
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
stream. A grilling-group file that records both `Dxxx` decisions and
`Ixxx` interactions ends with two sentinels:

```md
<!-- next-d: Dxxx -->
<!-- next-i: Ixxx -->
```

A `code-implementation-grilling` ledger also records `Txxx` decisions
and ends with three sentinels:

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

`docs/decisions/` (or the equivalent parent directory) is created only
when the first record of any stream is about to be written. Do not
create the directory during the initialization summary; create it on
the first real append.

For `skill-architect`, `.design-ledger.md` is created lazily — the
target skill directory is not yet guaranteed to exist when Step 1
begins, so the file is created when the directory exists, on the first
real append at the latest.

## Real-time appending

Append a record **immediately after the user resolves the branch or
answers the question**, before opening the next branch. Do not batch
the writes at session end — real-time writes give both the user and the
agent a persistent, up-to-date record to reference in later branches,
and they let the user spot a missing or weakened entry at the next
branch and correct it before drift compounds.

In a multi-pick round (up to 3 branches resolved in one turn), the
agent reads the current ledger and writes all new `Dxxx` records in
**one tool call** within the same turn as the resolution. Read-back
verification still applies — the agent confirms the new records are
last in the file before opening the next round. If a concurrent append
lands between the read and the write, the write may overwrite it;
read-back verification must catch this. The trailing
`<!-- next-d: Dxxx -->` sentinel is the single source of truth for
the next ID.

For `Ixxx` records, the append fires in two steps:

1. **Pre-question append.** Before presenting the locked question line, append an `Ixxx` record with
   the `Prompt` field filled and the other three fields marked `TBD`,
   then bump the `<!-- next-i: Ixxx -->` sentinel. The `TBD`
   placeholders are placeholders, not a permanent state.
2. **Post-response complete.** After the user answers and the branch
   resolves, edit the same `Ixxx` record in place to fill `User
   Response`, `Resolution`, and `Notes` with the user's exact words
   and the agent's notes. Read-back to confirm the four fields are now
   filled and the `Ixxx` is in its expected position in the file.


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

Once the user confirms the new resolution, the earlier record gains a
Supersedes: Dxxx line in Constraints pointing to the record it
replaces. The new record carries the updated resolution.

### DEFERRED re-ask closure

Each branch may be re-asked at most once. After 1 re-ask with no
clear answer, the branch closes with Resolved Answer = "DEFERRED"
and a Constraints line noting why (e.g., "User did not provide a
clear answer after final re-ask"). The same Dxxx record is updated;
no new record is created for the re-ask itself.

The re-ask preamble is fixed and cited in locked-question-format.md.
The re-ask must not re-introduce the Socratic elicitation turn.

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
  user named (e.g., "Do not collapse multiple tabs into one session",
  "All open tabs must survive restart"). If none, write `None.`

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
  user — the Socratic elicitation question, the locked question line,
  or a single-sentence clarification. Do not paraphrase the prompt.
- `User Response` is the **verbatim** user text that answered the
  prompt, or a close paraphrase the user has explicitly accepted. It
  is not the agent's summary. If the user answered with multiple
  sentences, capture the load-bearing sentence and put the rest in
  `Notes`.
- `Resolution` describes what the response was used for — which option
  it steered, which branch it opened, which constraint it surfaced. If
  the response is a deferred or non-answer (e.g., "skip", "as-is",
  silence), the resolution still records what the agent did in
  response (e.g., "declined the Socratic question; proceeded to Turn 2
  with default framing").
- `Notes` is for context the next reader needs that does not fit in the
  other three fields — non-load-bearing parts of the user response,
  cross-references to a `Dxxx`/`Txxx` record the interaction drove, or
  edge cases the user named in passing.

### TBD placeholder pattern

While waiting for the user response, an `Ixxx` record is appended with
`Prompt` filled and the other three fields marked `TBD`. The `TBD`
marker is a literal string, not a fill-in for the agent to interpret.
After the user answers, edit the same record in place to fill the
three `TBD` fields — do not amend the `Prompt` field, do not create a
new `Ixxx` record for the same interaction, and do not move the record
in the file. The `Ixxx` keeps its original position.

## Goal record

The first `Dxxx` record appended during the session is the **goal record**.
It captures the session's foundational goal as surfaced by the
goal-discovery question. For a new ledger this is `D001`; for an existing
ledger use the next available `Dxxx` ID from the sentinel. The goal record
uses the same template but with goal-specific content:

```md
### [Dxxx] — session goal

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

- **Driver**: the user wants to build a platform that correctly models
  the payment relationship between contacts and client organizations.
- **Resolved Answer**: "clarify the domain model for a freelancing
  platform where contacts message on behalf of client organizations."
- **Normalized Requirement**: The session shall produce a domain model
  that distinguishes contacts from client organizations and defines
  the payment flow.
- **Constraints**: `None.`

### [I001] — payment direction

- **Prompt**: "What are you working toward in this decision? You may
  answer, or skip and see the options as-is."
- **User Response**: "I want the platform fee to be transparent and
  deducted before the freelancer receives funds."
- **Resolution**: drove the framing of the options for D002 toward a
  payer-side fee model; recommended Option 1 on this basis.
- **Notes**: the user also mentioned the freelancer's tax
  responsibilities in passing, deferred to a later branch.

### [D002] — who hires whom

- **Driver**: the user wants the model to reflect real-world agency —
  the contact acts for an organization, not for themselves.
- **Resolved Answer**: "the contact is a person acting for a client
  organization; the client organization is the payer."
- **Normalized Requirement**: The platform shall distinguish between
  a `Contact` (the person messaging) and a `ClientOrganization` (the
  legal entity that invoices and pays).
- **Constraints**: Both terms must exist in the glossary
  (`docs/GLOSSARY.md`) with the definitions recorded inline here.

### [D003] — how payments are routed

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
<!-- next-i: I002 -->
