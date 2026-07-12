### Step 7: Output Selection

Present the user with the following two-part choice, one part at a
time.

**Part A: Output format**

**Option A: Implementation Blueprint (Recommended)**

- **What**: A standalone blueprint file at the repo root, with a
  `Scope Binding` section that links the blueprint to the source
  spec and the Decision Ledger.
- **Filename derivation**: Derive the blueprint filename from the
  spec's identifying token by input type — file path → basename
  without extension (e.g., `docs/prds/feature-x.md` →
  `IMPLEMENTATION-feature-x.md`); issue tracker reference → issue
  number (e.g., `#123` → `IMPLEMENTATION-123.md`); conversation
  context → date prefix in `YYYY-MM-DD` form (e.g., `Conversation
  context (2026-06-15)` → `IMPLEMENTATION-2026-06-15.md`). When
  the spec is referenced by more than one input type, resolve the
  filename using the strict total ordering **file path > issue
  tracker reference > conversation context** — pick the
  highest-precedence source present. The default location is the
  repo root.
- **Trade-offs**: High clarity; serves as a clean "Context Pointer"
  for tickets; keeps the PRD focused on "What".
- **Risks**: Temporary file overhead.
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

**Option B: PRD Augmentation**

- **What**: Appending a "Technical Implementation" section to the
  existing spec/PRD.
- **Trade-offs**: Single source of truth; no fragmented files.
- **Risks**: Can clutter high-level requirements with low-level
  technical noise.
- **Ledger Binding (Option B)**: The appended Technical
  Implementation section must inline-cite the `Dxxx`/`Txxx`
  records using `filename#<Dxxx|Txxx>` format, and must open with a
  `Decision Ledger: <ledger-path>` pointer so readers can audit
  the binding.

**Part B: Downstream consumer**

- **Ticket consumer**: hand off to a workflow that auto-decomposes
  the spec and blueprint into a dependency graph of implementation
  tickets.
- **Issue tracker**: hand off to a workflow that files the spec and
  blueprint as issues in the issue tracker.
- **Manual handoff**: no automated decomposition; the user takes
  the artifacts from here.

**Step 7.1: Filename confirmation (Option A only)**

If the user chose Option A (Implementation Blueprint), surface the
resolved filename in a confirmation prompt (e.g., *"I'm going to
write the blueprint to `IMPLEMENTATION-feature-x.md` at the repo
root — OK?"*). If the user wants a different name, adjust the
filename before writing. Skip this step entirely if the user chose
Option B (PRD Augmentation).

Captured: Output format = Option A | Option B; Downstream consumer
= ticket consumer | issue tracker | manual handoff. The captured
choices drive template selection in the Terminal Output section.
