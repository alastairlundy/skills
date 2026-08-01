### Recording Technical Decisions to the Ledger

After every resolved decision in Steps 4, 5, and 6, append a `Txxx`
record to the ledger using this template:

```md
### [Txxx] — <Decision label>

- **Driver**: <one to two sentences — the user's underlying principle or motivation; write `None.` if no principle is articulated>
- **Resolved Answer**: <verbatim user choice>
- **Normalized Requirement**: <concise, testable statement>
- **Constraints**: <negative requirements, edge cases, or defaults>
- **Cites**: <Dxxx ids from the same ledger whose constraints this answer respects>
```

- `Txxx` is a zero-padded sequence incremented from the highest
  existing `Txxx`.
- `Driver` is **required**, not optional. The `Driver` must be
  specific to the user's stated principle, not a generic restatement
  of the resolved answer. The `Driver` captures the **why** — the
  user's underlying principle or motivation behind the technical
  decision — and is distinct from `Resolved Answer` (the **what**)
  and `Normalized Requirement` (the testable outcome). If the user
  states no principle, write `None.`. The `Driver` field matches the
  parent grilling skill's `Dxxx` template; see
  `../grilling/references/decision-ledger.md`.
- `Cites` lists every `Dxxx` (or earlier `Txxx`) record whose
  `Constraints` the technical answer must respect. A Technical
  Decision that ignores a cited constraint is a silent loss; do not
  cite a record unless the answer actually honours it. The `Cites`
  field semantics are unchanged from the prior Txxx template.
- The real-time appending rule still applies: append the record in
  the same turn the user resolves the decision, before asking the
  next question. See
  `../grilling/references/decision-ledger.md` for the rule.
- The next available `Txxx` ID is read from the trailing
  `<!-- next-id: Txxx -->` sentinel at the end of the ledger file.
  The sentinel is documented in
  `../grilling/references/decision-ledger.md` (Sentinel comment
  for next append ID); the agent uses the sentinel for
  append-point lookup rather than re-reading the full ledger
  tail. If the sentinel is missing or out of sync, fall back to
  scanning the file for the highest existing `Txxx` and re-seed
  the sentinel before the next append.
