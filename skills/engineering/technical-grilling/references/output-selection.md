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
  authorization.
- **Ledger Binding**: Every technical statement in the blueprint
  body that satisfies a functional requirement must reference the
  `Dxxx` (or earlier `Txxx`) record it satisfies using the
  `filename#<Dxxx|Txxx>` format in square brackets, inline
  (e.g., *"The store [`DECISIONS-repo-feature.md#D012`] will use
  Redis with per-tab key namespaces, so a failed write to one tab
  does not corrupt siblings [`DECISIONS-repo-feature.md#D014`]."*).
  The blueprint must also include a `## Ledger Reference` section
  listing every `Dxxx` and `Txxx` record the blueprint cites, so a
  reader can audit the binding in one pass.

**Step 7.1: Filename confirmation (required)**

Surface the resolved filename in a confirmation prompt (e.g., *"I'm
going to write the blueprint to
`IMPLEMENTATION-acme-store-tab-session-restore.md` at
the repo root - OK?"*). If the user wants a different name, adjust
the filename before writing.

Captured: blueprint filename confirmed before writing.
