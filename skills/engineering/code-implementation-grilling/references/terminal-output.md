## Terminal Output (Required)

This block is mandatory. A workflow run that ends without emitting
it is incomplete.

At the end of the workflow, the agent emits exactly one of the
following pre-written handoff templates. Template selection is
keyed on the captured choices from Step 7: first select the
template set by Output format (Option A = Implementation Blueprint,
Option B = PRD Augmentation), then select the specific template by
Downstream consumer. The agent substitutes `<spec-path>`,
`<blueprint-path>` (Option A only), and `<ledger-path>` only. Do
not add any other prose around the template.

### Option A: Implementation Blueprint

**Template: ticket consumer (`spec-to-tickets`)**

> Run the `spec-to-tickets` skill with the spec at `<spec-path>`,
> with the blueprint at `<blueprint-path>`, and the Decision Ledger at
> `<ledger-path>` as context. Every ticket's acceptance criteria
> and constraints must cite a `Dxxx` or `Txxx` record using
> `filename#<Dxxx|Txxx>` format.

**Template: issue tracker (file the spec and blueprint as issues in the project's issue tracker)**

> File the spec and blueprint as issues in the project's issue tracker,
> citing the Decision Ledger per the same constraints as the
> ticket-consumer template. Every issue's acceptance criteria
> and constraints must cite a `Dxxx` or `Txxx` record using
> `filename#<Dxxx|Txxx>` format.

**Template: manual handoff**

> Manual handoff. The spec is at `<spec-path>`, the technical
> blueprint is at `<blueprint-path>`, and the Decision Ledger is
> at `<ledger-path>`. Use these to drive ticket creation or
> implementation planning in your own workflow. Every ticket's
> acceptance criteria and constraints must cite a `Dxxx` or `Txxx`
> record using `filename#<Dxxx|Txxx>` format.

### Option B: PRD Augmentation

**Template: ticket consumer (`spec-to-tickets`)**

> Run the `spec-to-tickets` skill with the spec at `<spec-path>`
> (which now includes the Technical Implementation section) and
> the Decision Ledger at `<ledger-path>` as context. Every
> ticket's acceptance criteria and constraints must cite a
> `Dxxx` or `Txxx` record using `filename#<Dxxx|Txxx>` format.

**Template: issue tracker (file the spec and blueprint as issues in the project's issue tracker)**

> File the spec (which now includes the Technical Implementation
> section) and the Decision Ledger as issues in the project's
> issue tracker, citing the Decision Ledger per the same
> constraints as the ticket-consumer template. Every issue's
> acceptance criteria and constraints must cite a `Dxxx` or
> `Txxx` record using `filename#<Dxxx|Txxx>` format.

**Template: manual handoff**

> Manual handoff. The spec is at `<spec-path>` (which now
> includes the Technical Implementation section) and the
> Decision Ledger at `<ledger-path>`. Use these to drive ticket
> creation or implementation planning in your own workflow.
> Every ticket's acceptance criteria and constraints must cite a
> `Dxxx` or `Txxx` record using `filename#<Dxxx|Txxx>` format.
