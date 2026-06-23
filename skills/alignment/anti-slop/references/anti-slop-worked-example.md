# Anti-Slop Worked Example

This file walks through one complete run of the anti-slop workflow: a vague user request, the Step 1 Goal Constraint, a Step 2 draft with banned vocabulary, and the Step 3 sanitized output with each pass's diff visible.

---

## User request

> Write documentation for our team's new CI pipeline. It runs linting, tests, and deploys to staging after every push to main.

---

## Step 1 — Goal Constraint Validation

**Goal**: Document the CI pipeline so a new team member can understand what runs on each push, how to read a failure, and how to trigger a re-deploy.

**Completion criterion**: The goal is a concrete constraint (onboarding a reader), not a vague desire.

---

## Step 2 — Draft (with banned vocabulary)

Load `references/banned-vocabulary.md` before Step 2 to access the full per-category lists.

*Violations are marked with `<<<` for visibility.*

> Great question! <<< (sycophantic)
> Let me walk you through our innovative new CI pipeline. <<< (meta-talk, vague adjective)
> This robust and streamlined system will empower your team to ship code faster than ever before. <<< (vague adjectives: robust, streamlined; AI-ism: empower; redundant intensifier: ever)
>
> The pipeline leverages a state-of-the-art multi-stage architecture that truly revolutionizes how we deliver software. <<< (AI-isms: leverages, state-of-the-art, revolutionizes; redundant intensifier: truly)
> When you push to main, the system will automatically trigger a seamless build process. <<< (vague adjective: seamless)
> First, it's important to note that linting runs, which helps foster code quality. <<< (meta-talk, AI-ism: foster)
> Next, the testing suite validates your changes. If everything passes, the system deploys to staging.
>
> I'm excited to help you with this! <<< (sycophantic)
> Feel free to reach out if you have any questions. <<< (sycophantic)

---

## Step 3 — Sanitization

### Pass 1: Vocabulary verification

Replace each banned term with its substitution from Contrast Pairs or the sycophantic phrase entries.

> ~~Great question!~~ (delete)
> ~~Let me walk you through~~ (delete) our ~~innovative~~ new CI pipeline.
> This ~~robust and streamlined~~ system will ~~empower your team~~ let the team ship code ~~faster than ever before~~.
>
> The pipeline ~~leverages~~ uses a ~~state-of-the-art~~ multi-stage architecture that ~~truly revolutionizes~~ is the basis for how we deliver software.
> When you push to main, the system will automatically trigger a ~~seamless~~ build process.
> First, ~~it's important to note that~~ linting runs, which helps ~~foster~~ maintain code quality.
> Next, the testing suite validates your changes. If everything passes, the system deploys to staging.
>
> ~~I'm excited to help you with this!~~ (delete)
> ~~Feel free to reach out if you have any questions.~~ (delete)

**After Pass 1**:

> Our new CI pipeline. The system will let the team ship code.
>
> The pipeline uses a multi-stage architecture that is the basis for how we deliver software.
> When you push to main, the system will automatically trigger a build process.
> First, linting runs, which helps maintain code quality.
> Next, the testing suite validates your changes. If everything passes, the system deploys to staging.

### Pass 2: Structural rules enforcement

Apply Goal-alignment > Measurability > Qualifier-ban in precedence.

**Goal-alignment check**: The draft should help a new team member understand the pipeline. Several sentences are too vague ("the system will let the team ship code") or missing specifics (what happens on failure, how to re-deploy).

**Measurability check**: No concrete metrics or outcomes are named.

**Qualifier-ban check**: No hedging present.

**Edited output**:

> The CI pipeline runs on every push to the `main` branch. It executes three stages in order:
>
> 1. **Lint** — runs ESLint and Prettier. If either check fails, the pipeline stops and reports the failure in the GitHub Actions summary.
> 2. **Test** — runs `npm test`. If any test fails, the pipeline stops and reports the failure.
> 3. **Deploy** — runs the deploy-to-staging script. A successful deploy posts the staging URL as a commit status.
>
> To trigger a re-deploy, push an empty commit (`git commit --allow-empty`) to `main`.

**Completion criterion**: The draft passes Pass 1 (no banned vocabulary) and Pass 2 (all three structural rules satisfied).
