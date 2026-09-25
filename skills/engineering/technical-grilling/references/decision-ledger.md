# Decision Ledger

The Decision Ledger is the durable record of every branch resolved
during a `technical-grilling` session. It is a single markdown file
that uses stable `Dxxx` and `Txxx` IDs as the cross-reference key for
every downstream consumer (memos, tickets, blueprints). When citing a
record from outside the ledger file, use the
`filename#<Dxxx|Txxx>` format (e.g.,
`DECISIONS-repo-feature.md#D001`).

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

A ledger file uses two parallel ID streams:

- `Dxxx` - formal design decisions. Zero-padded sequence: `D001`, `D002`,
  `D003`, …
- `Txxx` - technical decisions emitted by `technical-grilling`.
  Zero-padded sequence: `T001`, `T002`, `T003`, …

Each stream is independent - the `Dxxx` and `Txxx` counters both start
at `001` and are bumped separately. The streams do not share ID space.

Legacy compatibility: older ledgers may contain an `Ixxx` stream
(clarifying interactions). Read those records as historical interactives
but do not append new ones, edit them, or maintain their sentinel.

### Sentinel comments for next append IDs

Every ledger file ends with one HTML-style sentinel comment per active
stream. A `technical-grilling` ledger records `Dxxx` and `Txxx` and
ends with two sentinels:

```md
<!-- next-d: Dxxx -->
<!-- next-t: Txxx -->
```

The agent reads each sentinel (via a targeted `read` or `grep`) to find
the next append point for its stream, instead of re-reading the entire
ledger tail. The sentinel update is **atomic with the record write**  - 
the same `edit` call that appends the new record also bumps the
sentinel to the next available ID.

If a sentinel is missing or out of sync with the highest existing ID
in its stream, fall back to scanning the file for the highest existing
`Dxxx` / `Txxx` and re-seeding the sentinel before the next
append on that stream. A legacy ledger may still carry a
`<!-- next-i: Ixxx -->` sentinel; leave it in place (do not maintain,
re-seed, or interpret it as an active append point).

## Lazy creation

`docs/decisions/` (or the equivalent parent directory) is created only
when the first record of any stream is about to be written. Do not
create the directory during the initialization summary; create it on
the first real append.

When the ledger file is created
lazily on first append, it must include both ID-stream sentinels
(`next-d`, `next-t`), seeded at the initial IDs (`D001`,
`T001`), not only the stream being appended.

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

## Record correction

When a resolved: `Dxxx`/`Txxx` record turns out to rest on a false
assumption or wrong information (a misread spec, a clarified fact, an
invalidated premise), correct the record itself. Identify which field
carries the false content and rewrite that field in place: the
`Normalized Requirement` and `Constraints` are the usual candidates,
since they carry the agent's testable restatement of the decision.
Never rewrite `Resolved Answer` except to correct a transcription
error, and never move the record. For minor corrections, the field
rewrite suffices; for load-bearing reversals, the dynamic-conflict
mechanic applies instead (Supersedes record).

If a record rests on an unresolved premise instead of a false one, do
not silently correct: open the deferred branch, ask the user, and
resolve it, then correct any affected records.

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

### DEFERRED closure

A branch closes as DEFERRED **only** when the user explicitly defers
it: the user's response names the deferral (a clear "defer",
"later", or equivalent) or declines the branch after being shown the
full resolution path. Silence, an unrelated answer, or an
unacknowledged skip never produces a DEFERRED record - an
unresolved branch stays open, and the convergence test keeps it on
the surface until the user settles or defers it.

At closure: if a `Dxxx`/`Txxx` record already exists for the branch,
update it in place; otherwise create a DEFERRED record for the
branch. The DEFERRED record's `Constraints` line carries two
entries: the user's deferral (verbatim, e.g., `User deferred: "defer
to implementation"`) and the **fallback default** - the agent's
recommendation from the round, stated as the resting state a
downstream implementer falls back to when the user never settles the
branch (e.g., `Default if unowned: the round's recommended
option`). A DEFERRED record with no default leaves downstream readers
no resting state; the convergence test's coverage check surfaces the
gap at the next round boundary (`references/convergence-test.md`,
check 6). Restating a fallback default in a later consumer (blueprint,
tickets) must mark it as the agent-applied default, not as a
user-confirmed decision.

## DECLINED optional branches

An optional branch the user declines (e.g., the Interface & Model
branch) is a record, not a skip. Append a `Dxxx`/`Txxx` record for the
declined branch with Resolved Answer = "DECLINED" and a `Constraints`
line recording the decline reason and the recommended path forward
(e.g., `Interfaces deferred to implementation; expect more
Collaborative tickets`). The governing SKILL.md supplies the
warning text before the decline is finalized; this rule fixes how the
outcome is recorded. A DECLINED record appears in the close-out
residual inventory as Deferred and in the blueprint's `## Deferrals
and Defaults` section (`references/output-selection.md`).

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
  "All open tabs must survive restart"), and the unpinned sub-parts
  of a composite answer: when the user's pick settles some sub-parts
  of a branch and leaves others open, the unpinned sub-parts are
  enumerated here (or promoted to follow-up branches at that turn -
  see `references/convergence-test.md`, check 6). If none, write
  `None.`
- **Approval turn (mandatory).** For every resolved branch, the
  content of `Normalized Requirement` and `Constraints` is drafted
  by the agent but requires user approval before the session
  continues. Emit the drafted fields and ask the user to confirm or
  revise them; on revision, update the record in place and re-confirm.
  The next branch does not open until the approval lands. A pick
  without an approval turn is an unresolved branch, not a resolved
  decision.

## Anti-fabrication rules

- **Resolved Answer must come from a user response.** Never write a
  `Dxxx` record with a `Resolved Answer` that was not spoken by the
  user. Do not fill the answer yourself. An unresolved branch stays
  open, it does not close as DEFERRED without the user's explicit
  deferral (see DEFERRED closure above).
- **Never mark foundation or convergence complete without explicit user
  confirmation.** The LLM may observe that checks pass; it must not
  declare convergence or foundation-complete on its own authority. The
  user must explicitly say "converged", "complete", "close out", or
  equivalent.
- **Never fabricate or reconstruct a ledger from partial context.** If
  the ledger is lost or incomplete, surface the gap to the user and
  ask how to proceed. Do not synthesize `Resolved Answer` fields from
  memory or reasoning. Legacy `Ixxx` records are historical artifacts;
  do not fabricate companions for them, and do not treat them as
  gaps to fill.

## Txxx record template

`Txxx` records are emitted by `technical-grilling` and use
the same four fields as `Dxxx`, plus a `Cites` field for
spec links. The full template is in
`technical-grilling/references/recording-decisions.md`.

### Approval turn and detail extraction (Txxx)

The approval turn and the detail-extraction rules apply to `Txxx`
records exactly as to `Dxxx` records.

### Detail extraction from composite answers

A composite pick names a technology or approach without exhausting
its load-bearing sub-decisions. When the user resolves a branch with
such a pick (e.g., "we'll use EF Core"/"we'll use unit testing"),
the agent must extract the pick's sub-decisions at that turn, before
the approval turn closes:

1. Identify the sub-decisions the pick leaves open (mechanism,
   tooling, scope, configuration, ownership).
2. Open follow-up branches for them in the same round, or pin them
   on the record's `Constraints`.
3. The approval turn then covers the pick and its extracted
   sub-decisions together.

Gaps that persist after this extraction are deliberate gaps the user
named during the session, not unasked gaps.

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

If a single Decision Ledger reaches **~50 `Dxxx`/`Txxx` records**,
consider closing it and opening a new one for the next phase of the
interview. The cap is a trigger for reflection, not a hard limit;
override with reasoning if the interview genuinely needs more.

## Lifecycle

`docs/decisions/DECISIONS-*.md` is **persisted by default**. The agent
issues a **post-session reminder** to delete the ledger from
`docs/decisions/` once implementation of the resolved decisions is
complete. When an Implementation Blueprint was produced, the reminder
also states the dependency: the blueprint's inline citations and its
`## Ledger Reference` section resolve against this ledger file, so
deleting the ledger orphans the blueprint's binding. The user decides
when both artifacts are no longer needed. The reminder is
non-blocking - the user can defer or decline.
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