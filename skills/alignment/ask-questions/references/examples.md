# Examples

Nine worked examples covering the key branches of the ask-questions workflow: seven positive examples (A-G) and two anti-examples (H-I) that look correct on the surface but fail the citation requirement. Examples A, D, F, and G (wrong form) include field-check annotations that verify the workflow''s hard limits (header length, label length, description length, option count). Examples B, C, and E are prose-only and have no field-check annotations.

## Example A: Should-ask

**Context:** the LLM is helping a user scaffold a new project. The choice of dependency injection library affects every file.

- **Trigger:** the answer would change the LLM''s next action (which DI library to install and configure); the LLM cannot infer the user''s preference from context.
- **Fit:** real decision, 3 realistic options.

**Context prose:**
```
You''ll need a DI container. Three reasonable options:
- Autofac — featureful, supports advanced scenarios like assembly scanning
- Manual constructor injection — no library, just `new()` everywhere
- Microsoft.Extensions.DependencyInjection — built into ASP.NET Core, no extra dependency

Which fits?
```

**Tool call:** 1 question, 3 options, alphabetical by underlying name, no recommendation (depends on context not in scope).

```json
{
  "questions": [
    {
      "header": "DI container",
      "question": "Which DI container should we wire up?",
      "options": [
        {
          "label": "Autofac",
          "description": "Featureful, supports assembly scanning"
        },
        {
          "label": "Manual constructor injection",
          "description": "No library, just `new()` everywhere"
        },
        {
          "label": "Microsoft.Extensions.DependencyInjection",
          "description": "Built into ASP.NET Core, no extra dep"
        }
      ]
    }
  ]
}
```

**Field-check annotations:**

- `header: "DI container"` — 12 chars, under the 30-char cap.
- All 3 `label` values — noun phrases, parallel form, ≤6 words.
- All 3 `description` values — 38, 35, 37 chars respectively; all under the 80-char cap; each discriminates (explains why pick this over the others).
- 1 question, 3 options — within the 1 / 2-4 limits.

## Example B: Should-not-ask

**Context:** the LLM is implementing a function and the user wrote a comment "use sensible defaults."

- **Trigger:** the user has signaled "use your judgment" — opt-out mode. The LLM should proceed with sensible defaults without asking.
- **Action:** do not ask. Pick defaults, document them in the response, proceed.

## Example C: Mis-appropriation avoided

**Context:** the user says "tell me about your idea for a CI pipeline."

- **Trigger:** the user is asking the LLM to describe something, not asking the LLM to ask them a question.
- **Fit:** the question "what''s your idea?" is exploratory, not a decision. The tool cannot answer it.
- **Action:** do not call `ask_question`. Respond in prose with the LLM''s idea.

## Example D: Under-trigger recovered

**Context:** the user asks "should I add a retry policy to the HTTP client?" The LLM initially considered answering based on general best practices.

- **Trigger:** the user''s *specific* context (is the API idempotent? how expensive are failed requests?) determines the right answer. The LLM cannot infer these.
- **Fit:** real decision, 3 realistic options (no retries, exponential backoff, manual retry only). Each option changes the LLM''s next action.

**Context prose:**
```
The right answer depends on your context — is the API idempotent, and how expensive are failed requests?

Three honest options:
- Exponential backoff — assume transient failures, retry up to 3 times
- Manual retry only — let the caller decide per-request
- No retries — surface failures fast

Which fits your API?
```

**Tool call:** 1 question, 3 options, alphabetical by underlying name, no recommendation (depends on the user''s API).

```json
{
  "questions": [
    {
      "header": "Retry policy",
      "question": "Which retry policy fits your API?",
      "options": [
        {
          "label": "Exponential backoff",
          "description": "Retry up to 3 times on transient failures"
        },
        {
          "label": "Manual retry only",
          "description": "Caller decides per-request, no automatic retry"
        },
        {
          "label": "No retries",
          "description": "Surface failures fast, no automatic retry"
        }
      ]
    }
  ]
}
```

**Field-check annotations:**

- `header: "Retry policy"` — 13 chars, under the 30-char cap.
- All 3 `label` values — verb phrases, parallel form, ≤6 words.
- All 3 `description` values — 42, 47, 40 chars respectively; all under the 80-char cap; each discriminates.
- 1 question, 3 options — within the 1 / 2-4 limits.

## Example E: Invited mode (sequenced across turns)

**Context:** the user has said "grill me — ask me everything you need to know to design this system." Invited mode.

- **Trigger and fit:** the LLM has 4 independent decisions to gather. Each is a real decision with 2-3 realistic options. None depend on each other.
- **Construct:** the LLM may ask all 4 across separate turns, one tool call per turn. No batching into a single call. Example sequence:

  Turn 1 — Q1: *Where will the system run?* — Cloud-hosted, On-premises, Hybrid
  Turn 2 — Q2: *Who is the primary user?* — End users, Internal staff, External API consumers
  Turn 3 — Q3: *What is the read/write ratio?* — Read-heavy, Write-heavy, Balanced
  Turn 4 — Q4: *What is the consistency requirement?* — Strong, Eventual, Best-effort

The invited-mode permission justifies asking several questions across turns because the user has explicitly licensed it. Batching them into a single call would still violate the one-question-per-call rule.

## Example F: Recommendation provided

**Context:** the user is starting a new web service and needs to choose a database. The LLM has a defensible default for most use cases: Postgres.

- **Trigger:** the answer would change the LLM''s next action (which database client to install, which migrations framework to set up).
- **Fit:** real decision, 3 realistic options.

**Context prose:**
```
For a new web service, the database choice locks in the persistence layer. For most use cases, Postgres is the right default — strong consistency, mature tooling, broad ecosystem support. Pick SQLite only for embedded/CLI tools; pick MongoDB only if you have a document-model use case that justifies the consistency tradeoffs.
```

**Tool call:** 1 question, 3 options, alphabetical by underlying name, with `(Recommended)` as a suffix on the Postgres label.

```json
{
  "questions": [
    {
      "header": "Database",
      "question": "Which database should the new web service use?",
      "options": [
        {
          "label": "MongoDB",
          "description": "Document model; consistency tradeoffs"
        },
        {
          "label": "Postgres (Recommended)",
          "description": "Strong consistency, mature tooling"
        },
        {
          "label": "SQLite",
          "description": "Embedded/CLI tools; single-file storage"
        }
      ]
    }
  ]
}
```

**Field-check annotations:**

- `header: "Database"` — 8 chars, under the 30-char cap.
- All 3 `label` values — sorted alphabetically by underlying name (MongoDB < Postgres < SQLite); `(Recommended)` is a suffix and does not change position.
- All 3 `description` values — 39, 36, 41 chars respectively; all under the 80-char cap; each discriminates.
- 1 question, 3 options — within the 1 / 2-4 limits.

The recommendation is justified in the prose-before ("for most use cases, Postgres is the right default") and is what the LLM would commit to on the user''s behalf given the stated context (new web service). A user with a different use case can still pick MongoDB or SQLite with full information — the marker is a pointer, not a coercion.

## Example G: Over-asking avoided

**Context:** the user has asked the LLM to make changes to a file and the LLM is uncertain which changes to make. The LLM is tempted to ask: "What changes would you like me to make?"

- **Trigger:** the LLM has no real decision to gather; the user''s question is open-ended. Gate 1.2 (Real Decision precondition) fails: the user has not narrowed the space to 2-4 realistic options.
- **Fit:** the LLM cannot honestly construct 2-4 realistic options because it is doing the same work in every option ("Tell me" / "Write your own" / "Use my judgment" all reduce to "the LLM will do something"). Gate 2 Sub-check A fails.

**Wrong (over-asking via tool):**

```json
{
  "questions": [
    {
      "header": "Changes",
      "question": "What changes would you like me to make?",
      "options": [
        {
          "label": "Tell me",
          "description": "You''ll tell the LLM what to change"
        },
        {
          "label": "Use my judgment",
          "description": "LLM picks a reasonable default"
        },
        {
          "label": "Write your own",
          "description": "You''ll write the change yourself"
        }
      ]
    }
  ]
}
```

**Field-check annotations (failure):**

- 1 question, 3 options — passes Count Gate.
- All 3 `label` values — sorted alphabetically.
- **Realistic alternative test: FAILED.** None of the 3 options is a real decision the user can act on that the LLM cannot already make. "Tell me" and "Use my judgment" both mean the LLM will do something; the user has not narrowed the space. Gate 1.2 fails; the tool call should not be made.

**Right (prose proposal):**

```
Here''s my plan: refactor the imports in `src/foo.ts` to use named exports, replace the `any` types in `processRequest` with a discriminated union on the response status, and add a `try`/`catch` around the network call that surfaces a typed error. If you want different changes, tell me what to revise.
```

The LLM proposes a default in prose, makes the work visible, and invites correction. The user can accept, revise, or replace — the same options they would have had via the tool, but with less friction and no leaky choice architecture.

---

## Example H: Anti-example — plausible-looking options all derived from LLM inference

**Context:** the user says "I need to pick a caching strategy for my API." The user has not mentioned any specific requirements, traffic patterns, or constraints.

The LLM considers asking via the tool with 3 options that all sound reasonable.

**Surface check (passes):** 1 question, 3 options, alphabetical, labels ≤6 words, descriptions ≤80 chars.

**Wrong (looks realistic but fails citation):**

```json
{
  "questions": [
    {
      "header": "Caching strategy",
      "question": "Which caching strategy fits your API?",
      "options": [
        {
          "label": "In-memory cache",
          "description": "Fastest reads, single-server only"
        },
        {
          "label": "Redis cache",
          "description": "Distributed, supports multi-server"
        },
        {
          "label": "Response caching middleware",
          "description": "HTTP-level, no app code changes"
        }
      ]
    }
  ]
}
```

**Why this fails the citation requirement:** None of the three options is supported by a user-stated fact. The user said only "I need to pick a caching strategy for my API" — no mention of single-server vs multi-server, no mention of read/write ratios, no mention of infrastructure constraints. The LLM generated all three options from general knowledge. Each option may be *plausible*, but none is *grounded* in the user''s stated context. Drop all three and ask in prose (or probe for constraints first).

---

## Example I: Anti-example — one option lacks a user-stated basis

**Context:** the user says "I''m building a React dashboard app that will be used internally by our team of 5. We need to pick a state management library. We already use Redux in our other projects." The user has stated a preference for familiarity and team consistency.

The LLM constructs 3 options.

**Surface check (passes):** 1 question, 3 options, alphabetical, labels ≤6 words, descriptions ≤80 chars.

**Wrong (looks realistic but fails citation):**

```json
{
  "questions": [
    {
      "header": "State management",
      "question": "Which state management library should we use?",
      "options": [
        {
          "label": "Jotai",
          "description": "Atomic state, good for small teams"
        },
        {
          "label": "Redux Toolkit (Recommended)",
          "description": "Already used in other projects; team knows it"
        },
        {
          "label": "Zustand",
          "description": "Minimal boilerplate, scales well"
        }
      ]
    }
  ]
}
```

**Why this fails the citation requirement:** Two options pass the test: "Redux Toolkit" is supported by the user-stated fact "we already use Redux in our other projects," and the LLM can defensibly recommend it. "Zustand" is unsupported — the user has said nothing about desiring minimal boilerplate or avoiding Redux''s conventions. No user-stated fact makes Zustand a realistic alternative given "we already use Redux." Drop Zustand before proceeding. (If only two options remain, that is within the 2-4 limit.)