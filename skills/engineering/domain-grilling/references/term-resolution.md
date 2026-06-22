# Term Resolution

When a resolved branch introduces a new glossary term, the term must
be written to `CONTEXT.md` immediately. This file owns the workflow.

## Workflow

During the session, if a term is identified that belongs in the domain
glossary:

1. **Propose the term and the working definition to the user.** Do
   not write to `CONTEXT.md` until the user has accepted the term and
   its definition.
2. **On acceptance, write the term to `CONTEXT.md` immediately.** Do
   not batch writes — immediate writes prevent drift and give both
   the user and the agent a persistent, up-to-date record to
   reference in later branches. If `CONTEXT.md` does not exist,
   create it now (per the Lazy Creation rule in
   `references/ddd-initialization.md`).
3. **If the user revises the definition** during a later branch,
   update the `CONTEXT.md` entry at that point.

## Completion criterion

Every glossary term is in `CONTEXT.md` with the same definition as in
the Decision Ledger record that introduced it.

## Worked example

**User resolution (turn 3):** "the contact is a person acting for a
client organization; the client organization is the payer."

**Compliant agent continuation:**

> Two new glossary terms to write: **Contact** — the person messaging
> the freelancer; **Client Organization** — the legal entity that
> invoices and pays. Confirm both before I write to `CONTEXT.md`.

**After user confirms:**

```
$ cat docs/CONTEXT.md
# Glossary

## Contact

The person messaging the freelancer. Acts on behalf of a Client
Organization.

## Client Organization

The legal entity that invoices and pays for the freelancer\'s work.
```

The Decision Ledger record and the `CONTEXT.md` entry have the same
working definition. Both writes are independent — do not skip one
because the other exists.
