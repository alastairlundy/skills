# Decision Ledger

The Decision Ledger is the durable record of every branch resolved during a
grilling session. It is a single markdown file that lives at
`docs/decisions/DECISIONS-<repo>-<feature>.md` and uses stable `Dxxx` IDs as
the cross-reference key for every downstream consumer (memos, tickets,
blueprints, specialized grilling sessions).

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

## Per-branch record template

```md
### [Dxxx] — <branch name>

- **Resolved Answer**: <verbatim user choice>
- **Normalized Requirement**: <concise, testable statement>
- **Constraints**: <negative requirements, edge cases, or defaults>
```

- `Dxxx` is a zero-padded sequence: `D001`, `D002`, `D003`, … Scan the
  existing ledger file and increment from the highest existing `Dxxx`
  number. Do not reuse IDs.
- `Resolved Answer` is the user's exact wording (or a close paraphrase the
  user has explicitly accepted). It is **not** the agent's summary.
- `Normalized Requirement` is a single concise, testable statement an
  implementer or verifier can act on. The "testable" bar is the same as
  a PRD acceptance criterion.
- `Constraints` are negative requirements, edge cases, or defaults the
  user named (e.g., "Do not collapse multiple tabs into one session",
  "All open tabs must survive restart"). If none, write `None.`

## Re-opens

If a branch is re-opened later in the session (because a new discovery
invalidates the earlier decision), do **not** amend the prior record.
Add a new record with a fresh `Dxxx` ID and a `Supersedes: Dxxx` line in
`Constraints`. The superseded record stays in the ledger for traceability.

Example — the original D007 picked Option 2; a later discovery forces a
revisit:

```md
### [D012] — where the gate lives

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
### [D001] — who hires whom

- **Resolved Answer**: "the contact is a person acting for a client
  organization; the client organization is the payer."
- **Normalized Requirement**: The platform shall distinguish between a
  `Contact` (the person messaging) and a `ClientOrganization` (the legal
  entity that invoices and pays).
- **Constraints**: Both terms must exist in the glossary
  (`docs/CONTEXT.md`) with the definitions recorded inline here.

### [D002] — how payments are routed

- **Resolved Answer**: "client organization is the payer; freelancer is
  the payee; platform takes a percentage fee."
- **Normalized Requirement**: Payment flow shall route funds from
  `ClientOrganization` to `Freelancer` with a platform fee deducted
  before the freelancer payout.
- **Constraints**: `None.`
```
