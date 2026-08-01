# Term Resolution

When a resolved branch introduces a new glossary term, the term must
be written to `GLOSSARY.md` immediately. This file owns the workflow.

## Workflow

During the session, if a term is identified that belongs in the domain
glossary:

1. **Propose the term and the working definition to the user.** Do
   not write to `GLOSSARY.md` until the user has accepted the term and
   its definition.
2. **On acceptance, write the term to `GLOSSARY.md` immediately.** Do
   not batch writes — immediate writes prevent drift and give both
   the user and the agent a persistent, up-to-date record to
   reference in later branches. If `GLOSSARY.md` does not exist,
   create it now (per the Lazy Creation rule in
   `references/ddd-initialization.md`).
3. **If the user revises the definition** during a later branch,
   update the `GLOSSARY.md` entry at that point.

## Term Store Consistency

The Decision Ledger and `GLOSSARY.md` are the two stores for glossary
terms. They must stay in sync. This section defines the rules that
keep them consistent.

### (a) On initial term acceptance

When the user accepts a proposed term and its definition:

1. Write the term and its definition to `GLOSSARY.md` (per the Workflow
   above, steps 1–2).
2. Append a `Dxxx` record for the term to the Decision Ledger.
3. Verify that the definition in the Decision Ledger record and the
   `GLOSSARY.md` entry match exactly. Fix any mismatch before
   proceeding.

### (b) On term revision

When the user revises an existing glossary term during a later branch:

1. Open a new Decision Ledger record with a fresh `Dxxx` ID and a
   `Supersedes: Dxxx` line in `Constraints` (per the re-open pattern
   in `../../grilling/references/decision-ledger.md`).
2. Update the `GLOSSARY.md` entry for the term in the same turn.
3. Run the verification step (c) below.

### (c) Verification after revision

Confirm that the new Decision Ledger record and the updated
`GLOSSARY.md` entry define the term identically. Fix any mismatch
before proceeding.

## Completion criterion

Every glossary term is in `GLOSSARY.md` with the same definition as in
the Decision Ledger record that introduced it.

## Worked example

**User resolution (turn 3):** "the contact is a person acting for a
client organization; the client organization is the payer."

**Compliant agent continuation:**

> Two new glossary terms to write: **Contact** — the person messaging
> the freelancer; **Client Organization** — the legal entity that
> invoices and pays. Confirm both before I write to `GLOSSARY.md`.

**After user confirms:**

```
$ cat docs/GLOSSARY.md
# Glossary

## Contact

The person messaging the freelancer. Acts on behalf of a Client
Organization.

## Client Organization

The legal entity that invoices and pays for the freelancer\'s work.
```

The Decision Ledger record and the `GLOSSARY.md` entry have the same
working definition. Both writes are independent — do not skip one
because the other exists.
