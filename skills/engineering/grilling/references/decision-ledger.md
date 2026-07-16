# Decision Ledger

The Decision Ledger is the durable record of every branch resolved during a
grilling session. It is a single markdown file that lives at
`docs/decisions/DECISIONS-<repo>-<feature>.md` and uses stable `Dxxx` IDs as
the cross-reference key for every downstream consumer (memos, tickets,
blueprints, specialized grilling sessions). When citing a record from outside
the ledger file, use the `filename#Dxxx` format
(e.g., `DECISIONS-repo-feature.md#D001`).

## Path derivation

- `<repo>` is the directory name of the working repository.
- `<feature>` is a short kebab-case slug of the topic being grilled
  (e.g., `tab-session-restore`, `pricing-pivot`, `retro-format`).

Examples:

- Working in `~/code/acme-store`, topic is "tab session restore" →
  `docs/decisions/DECISIONS-acme-store-tab-session-restore.md`.
- Working in `~/code/acme-store`, topic is "should we pivot to per-seat
  pricing" → `docs/decisions/DECISIONS-acme-store-pivot-per-seat.md`.

## Lazy creation

`docs/decisions/` is created only when the first `Dxxx` record is about to
be written. Do not create the directory during the initialization summary;
create it on the first real append.

## Real-time appending

Append a `Dxxx` record **immediately after the user resolves a branch**,
before opening the next branch. Do not batch the writes at session end —
real-time writes give both the user and the agent a persistent,
up-to-date record to reference in later branches, and they let the user
spot a missing or weakened entry at the next branch and correct it
before drift compounds.

### Sentinel comment for next append ID

Every ledger file ends with a single-line sentinel comment that encodes
the next available `Dxxx` ID:

```md
<!-- next-id: Dxxx -->
```

The agent reads this one line (via a targeted `read` or `grep`) to find
the next append point, instead of re-reading the entire ledger tail.
The sentinel update is **atomic with the record write** — the same
`edit` call that appends the new `Dxxx` record also bumps the sentinel
to `<!-- next-id: D<NEXT> -->`.

If the sentinel is missing or out of sync with the highest existing ID,
fall back to scanning the file for the highest existing `Dxxx` and
re-seeding the sentinel before the next append.

## Per-branch record template

```md
### [Dxxx] — <branch name>

- **Driver**: <the user's underlying principle or motivation>
- **Resolved Answer**: <verbatim user choice>
- **Normalized Requirement**: <concise, testable statement>
- **Constraints**: <negative requirements, edge cases, or defaults>
```

- `Dxxx` is a zero-padded sequence: `D001`, `D002`, `D003`, … The
  next available ID is read from the trailing `<!-- next-id: Dxxx -->`
  sentinel at the end of the ledger file (see
  [Sentinel comment for next append ID](#sentinel-comment-for-next-append-id)).
  Do not reuse IDs. If the sentinel is missing or out of sync, fall
  back to scanning the file for the highest existing `Dxxx` and
  re-seeding the sentinel before the next append.
- `Driver` captures the **why** — the user's underlying principle or
  motivation behind the decision. It is distinct from `Resolved Answer`
  (the **what**) and `Normalized Requirement` (the testable outcome).
  If the user states multiple motivations, record the primary one and
  note the rest in `Constraints`.
- `Resolved Answer` is the user's exact wording (or a close paraphrase the
  user has explicitly accepted). It is **not** the agent's summary.
- `Normalized Requirement` is a single concise, testable statement an
  implementer or verifier can act on. The "testable" bar is the same as
  a PRD acceptance criterion.
- `Constraints` are negative requirements, edge cases, or defaults the
  user named (e.g., "Do not collapse multiple tabs into one session",
  "All open tabs must survive restart"). If none, write `None.`

## Goal record

The first record in the ledger (D001) is the **goal record**. It captures
the session's foundational goal as surfaced by the goal-discovery question.
The goal record uses the same template but with goal-specific content:

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
Add a new record with a fresh `Dxxx` ID and a `Supersedes: Dxxx` line in
`Constraints`. The superseded record stays in the ledger for traceability.

Example — the original D007 picked Option 2; a later discovery forces a
revisit:

```md
### [D012] — where the branch lives

- **Driver**: the user wants precondition failures to be visible at the
  call site, not deferred to a later validation step.
- **Resolved Answer**: encode the precondition inside the constructor of
  the tab container.
- **Normalized Requirement**: `TabContainer` shall reject construction
  with `null` dependencies at the call site, raising
  `ArgumentNullException` synchronously.
- **Constraints**: `Supersedes: D007`. The check must be a hard
  precondition, not a post-condition validator. The exception type is
  fixed (no custom exception class).
```

## Soft cap

If a single Decision Ledger reaches **~30 records**, consider closing it
and opening a new one for the next phase of the interview. The cap is a
trigger for reflection, not a hard limit; override with reasoning if the
interview genuinely needs more.

## Worked example — full ledger excerpt

```md
### [D001] — session goal

- **Driver**: the user wants to build a platform that correctly models
  the payment relationship between contacts and client organizations.
- **Resolved Answer**: "clarify the domain model for a freelancing
  platform where contacts message on behalf of client organizations."
- **Normalized Requirement**: The session shall produce a domain model
  that distinguishes contacts from client organizations and defines the
  payment flow.
- **Constraints**: `None.`

### [D002] — who hires whom

- **Driver**: the user wants the model to reflect real-world agency —
  the contact acts for an organization, not for themselves.
- **Resolved Answer**: "the contact is a person acting for a client
  organization; the client organization is the payer."
- **Normalized Requirement**: The platform shall distinguish between a
  `Contact` (the person messaging) and a `ClientOrganization` (the legal
  entity that invoices and pays).
- **Constraints**: Both terms must exist in the glossary
  (`docs/CONTEXT.md`) with the definitions recorded inline here.

### [D003] — how payments are routed

- **Driver**: the user wants the platform fee to be transparent and
  deducted before the freelancer receives funds.
- **Resolved Answer**: "client organization is the payer; freelancer is
  the payee; platform takes a percentage fee."
- **Normalized Requirement**: Payment flow shall route funds from
  `ClientOrganization` to `Freelancer` with a platform fee deducted
  before the freelancer payout.
- **Constraints**: `None.`
```
