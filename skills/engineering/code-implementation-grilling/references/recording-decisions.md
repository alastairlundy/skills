### Recording Technical Decisions to the Ledger

After every resolved decision in Steps 4, 5, and 6, append a `Txxx`
record to the ledger using this template:

```md
### [Txxx] — <Decision label>

- **Resolved Answer**: <verbatim user choice>
- **Normalized Requirement**: <concise, testable statement>
- **Constraints**: <negative requirements, edge cases, or defaults>
- **Cites**: <Dxxx ids from the same ledger whose constraints this answer respects>
```

- `Txxx` is a zero-padded sequence incremented from the highest
  existing `Txxx`.
- `Cites` lists every `Dxxx` (or earlier `Txxx`) record whose
  `Constraints` the technical answer must respect. A Technical
  Decision that ignores a cited constraint is a silent loss; do not
  cite a record unless the answer actually honours it.
- The real-time appending rule still applies: append the record in
  the same turn the user resolves the decision, before asking the
  next question. See
  `../grilling/references/decision-ledger.md` for the rule.
