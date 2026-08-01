# Decision Ledger Reference Audit

Bare `Dxxx`/`Txxx` references outside the Decision Ledger file itself are prohibited. Every record citation must use the `filename#Dxxx` format so references survive file relocation and remain resolvable.

## The Rule

When referencing a Decision Ledger record from any file outside `docs/decisions/DECISIONS-*.md`, wrap the record ID in the source filename:

- `DECISIONS-repo-feature.md#D001` — correct
- `D001` — incorrect (bare reference)

This applies to `SKILL.md` files, reference docs, eval fixtures, and any other document in the repo.

## Remediation

To fix a violation, replace the bare `Dxxx`/`Txxx` reference with the full `filename#Dxxx` format. If the source ledger file is unknown, use the most specific filename that contains the referenced record.

## Scope

This audit covers all files in the repo. Ledger files (`docs/decisions/DECISIONS-*.md`) are exempt — they define the records and use bare IDs in their own headings.

Generic examples (e.g., `D001` used as a template placeholder in reference files) are also exempt, as they do not cite a specific record.
