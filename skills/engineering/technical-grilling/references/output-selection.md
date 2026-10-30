### Step 7: Implementation Blueprint Exit

This is a **required** step - do not skip it. The Implementation
Blueprint is the sole exit: a standalone-file Consolidated
Implementation Plan. There is no format selection and no downstream
consumer selection.

**Implementation Blueprint**

- **What it is**: A standalone blueprint file at the repo root, with
  a `Scope Binding` section that links the blueprint to the source
  spec and the Decision Ledger.
- **Filename derivation**: Mirror the Decision Ledger filename so the
  blueprint is paired with the work it records -
  `docs/decisions/DECISIONS-<repo>-<feature>.md` →
  `IMPLEMENTATION-<repo>-<feature>.md` (e.g.,
  `docs/decisions/DECISIONS-acme-store-tab-session-restore.md` →
  `IMPLEMENTATION-acme-store-tab-session-restore.md`). The
  `<repo>-<feature>` stem is feature-based and indicative of the
  work the ledger deals with. If no ledger file exists yet, derive
  the stem with the ledger path rules in
  `references/decision-ledger.md` (working repository directory
  name + kebab-case topic slug from the goal record). The default
  location is the repo root. Never use a bare `IMPLEMENTATION.md`,
  a date stamp, or an issue number as the stem.
- **Scope Binding contents**: The blueprint must include
  `Linked Spec: <path_to_spec>`,
  `Decision Ledger: <ledger-path>`, and a notice that the
  blueprint is a context pointer valid ONLY for the linked spec
  and must not be applied to other specifications without explicit
  authorization. The blueprint must also include the traceability
  boundary, verbatim:

  > Citations to `Dxxx`/`Txxx` records appear only in this
  > blueprint and in the Decision Ledger. Do not write them into
  > source code, code comments, docstrings, commit messages, PR
  > descriptions, README files, or any other repository file.
  > When code or docs need the rationale inline, name the decision's
  > topic instead of its ID.

  The implementing session never loads this skill, so the blueprint
  itself is the only place the boundary can be stated before code is
  written.
- **Ledger Binding**: Every technical statement in the blueprint
  body that satisfies a functional requirement is covered by a
  section-level citation: each file section (or coherent work unit)
  cites, once, the set of `Dxxx`/`Txxx` records its statements
  satisfy, using the `filename#<Dxxx|Txxx>` format in square
  brackets at the end of the section (e.g., *"### `store/session.py`
  ... `[`DECISIONS-repo-feature.md#D012`, `DECISIONS-repo-feature.md#D014`]"*).
  Statements inside a section carry no inline citations; the
  section-level grouping is the binding. Coarser or finer placement
  than section-level is a binding miss that the convergence test can
  surface. The blueprint must also include a `## Ledger Reference`
  section listing every `Dxxx` and `Txxx` record the blueprint
  cites, so a reader can audit the binding in one pass.
- **Deferrals and Defaults section**: The blueprint must include a
  `## Deferrals and Defaults` section listing every DEFERRED
  record's item, the agent's recommended default, and the
  `filename#<Dxxx|Txxx>` citation. The same row lists optional
  branches the user declined (e.g., the Interface & Model branch,
  recorded with Resolved Answer = `DECLINED`). Where the blueprint
  body applies a deferred default, the affected statements are
  marked as carrying the default rather than as user-confirmed
  decisions. The `## Ledger Reference` section does not list a
  record cited only by the Deferrals section. The residual inventory
  in `references/coverage-sweep.md` is the source for this section's
  rows.

**Step 7.1: Filename confirmation (required)**

Surface the resolved filename in a confirmation prompt (e.g., *"I'm
going to write the blueprint to
`IMPLEMENTATION-acme-store-tab-session-restore.md` at
the repo root - OK?"*). If the user wants a different name, adjust
the filename before writing.

Captured: blueprint filename confirmed before writing.
