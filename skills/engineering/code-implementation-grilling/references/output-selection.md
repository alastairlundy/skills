### Step 7: Output Selection

Present the user with the following two-part choice, one part at a
time.

#### Preamble format cap (rule, not example)

Each preamble the agent emits before presenting options for a branch
question is capped at **2 sentences maximum**, with mandatory
ID-citation of the relevant prior record(s):

- **1 sentence** for simple questions — the preamble is the ID
  reference alone.
- **2 sentences** for complex questions — the first sentence is the
  ID reference, the second adds the specific constraint or
  discriminator the user is being asked to weigh.

The rule is a length cap plus an ID-citation requirement; no verbatim
example is encoded. The preamble must not exceed 2 sentences, and the
first sentence must always carry the `Dxxx`/`Txxx` reference.

**Part A: Output format**

Each option below uses the parent grilling skill's 4-field option
format: **What it is** / **Benefit** / **Cost** / **Risk**, in that
order. Each field is exactly one sentence. All four fields are
required.

**Option A: Implementation Blueprint (Recommended)**

- **What it is**: A standalone blueprint file at the repo root, with
  a `Scope Binding` section that links the blueprint to the source
  spec and the Decision Ledger.
- **Benefit**: High clarity; serves as a clean "Context Pointer"
  for tickets, keeping the PRD focused on "What".
- **Cost**: A temporary file overhead and an extra artifact to keep
  in sync with the PRD.
- **Risk**: The blueprint drifts from the PRD over time if the
  linking discipline lapses.
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

- **What it is**: Appending a "Technical Implementation" section to
  the existing spec/PRD.
- **Benefit**: Single source of truth; no fragmented files to
  reconcile.
- **Cost**: High-level requirements and low-level technical detail
  live in the same document, making each harder to scan.
- **Risk**: Low-level technical noise clutters the requirements view
  and may be skimmed by non-technical readers.
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
