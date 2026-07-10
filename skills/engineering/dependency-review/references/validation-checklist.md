# Validation Checklist

Run this checklist before delivering the final report. Each item must be true.

- [ ] Discovery enumerated all manifest-listed dependencies and applied the implicit-dependency rule per ecosystem
- [ ] Enrichment gathered upstream data for every dependency and labelled each finding's source
- [ ] Category 1 findings report sub-criteria labels and an overall tier per the tier-composition rule
- [ ] Category 2 findings report a tier only (no sub-criteria labels in the report)
- [ ] Category 3 findings report a tier only with rationale text naming the sub-criterion
- [ ] Category 4 findings are text only, no tier
- [ ] Every finding lists the evidence that materially supports it (no padding the trail)
- [ ] Output form matches the default (prose) or the file-on-request rule; file suggested when report exceeds ~1000 words or ~15 findings
- [ ] Steps 1 and 2 are tagged deterministic; Steps 3-7 are tagged judgement
- [ ] The Guide at `references/dependency-review-guide.md` is loaded before Step 1
- [ ] The eval suite at `evals/dependency-review/` (when built) covers per-step tasks, per-category output structure, and end-to-end scenarios
