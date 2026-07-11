# Decision Ledger

Topic: grilling single-question enforcement

## Records

### [D001] — failure mode classification

- **Resolved Answer**: most cases are attention drift, with some efficiency bundling
- **Normalized Requirement**: the fix must target generation-time attention drift as the primary failure mode, with efficiency bundling as a secondary concern
- **Constraints**: None.

### [D002] — guard mechanism

- **Resolved Answer**: hard stop after first question
- **Normalized Requirement**: the agent must emit exactly one locked question per turn, then stop generating
- **Constraints**: no escape hatches or self-check mechanisms

### [D003] — placement and form of the reasoning

- **Resolved Answer**: inline rationale after the rule
- **Normalized Requirement**: add a single sentence directly after the "One question per turn" rule in `locked-question-format.md`
- **Constraints**: the rationale must sit next to the rule it justifies

### [D004] — validation enforcement

- **Resolved Answer**: add a diverge mode
- **Normalized Requirement**: add "Asking multiple questions in one turn" to the diverge modes list in `convergence-test.md`
- **Constraints**: no validation-time checklist item (too late to help the user)

### [D005] — efficiency bundling exception

- **Resolved Answer**: no exception, hard stop always
- **Normalized Requirement**: the one-question rule is absolute; no exceptions for related questions
- **Constraints**: None.

### [D006] — wording of the rationale

- **Resolved Answer**: direct user impact
- **Normalized Requirement**: use the wording "Asking multiple questions at once confuses the user and is bewildering"
- **Constraints**: use the user's own words
