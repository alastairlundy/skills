# Worked Examples

Worked threshold examples for each tiered category. Load on first report.

## Category 1 — Doesn't-Earn-Its-Keep

- All three sub-criteria firing → High
- Trivial-task + dead-code → Medium
- Cost-outweighs-reward alone → Low to Medium (calibrate on the size of the cost)

These are defaults; the LLM may override per the override policy.

## Category 2 — Tightly-Coupled

- 10+ import sites (absolute) OR a high relative share of the project's source files (project-size-relative — 5+ sites in a small project is more significant than 5+ in a large project) + internal-API reach → High
- 5+ import sites + type mirroring → Medium
- 5+ import sites, public API only → Low

The "wide import surface" threshold is a mixture: 5+ sites baseline, with project-size relativity — a higher relative percentage of the project's total files counts as wider.

## Category 3 — Unmaintained-Deprecated

- Repo archived or end-of-life → High
- Deprecation notice + long time since last release (12+ months) → High
- Long time since last release alone → Medium
- Deprecation notice alone, recent activity → Low (recommend planning a switch but no urgency)
