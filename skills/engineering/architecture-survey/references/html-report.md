<!--
  Derived from HTML-REPORT.md (improve-codebase-architecture skill) by Matt Pocock
  Source: https://github.com/mattpocock/skills/blob/main/skills/engineering/improve-codebase-architecture/HTML-REPORT.md
  Original license: MIT
  Adapted: file naming, GLOSSARY.md conventions, not-proposed footer cites Decision Ledger
  records, vocabulary pointer to design-vocabulary.md.
-->

# HTML report format

The survey renders as a single self-contained HTML file in the OS temp directory. Tailwind and Mermaid come from CDNs. Mermaid handles graph-shaped diagrams; hand-built divs and inline SVG handle the editorial visuals (mass diagrams, cross-sections). Mix the two. A report where every diagram is a Mermaid graph looks generic.

## Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture survey for {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* small custom layer for things Tailwind doesn't cover cleanly:
         dashed seam lines, hand-drawn-feeling arrow heads, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="not-proposed">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

Name the file `architecture-survey-<repo>-<YYYYMMDD-HHMM>.html`. Every run gets a fresh file.

## Header

Repo name, date, the scope the survey walked (user-named direction, or the hot-spot paths from git churn), and a compact legend: solid box = module, dashed line = seam, red arrow = leakage, thick dark box = deep module. No introduction paragraph. Straight into the candidates.

## Candidate card

The diagrams carry the weight. Prose stays sparse and plain, using the terms from `references/design-vocabulary.md` and the domain names from `GLOSSARY.md` without ceremony.

Each candidate is one `<article>`:

- **Title** - short, names the deepening (e.g. "Collapse the Order intake pipeline").
- **Badge row** - recommendation strength (`Strong` = emerald, `Worth exploring` = amber, `Speculative` = slate), plus the dependency category (`in-process`, `local-substitutable`, `ports & adapters`, `mock`).
- **Files** - monospaced list, `font-mono text-sm`.
- **Before / After diagram** - the centrepiece, two columns side by side. See patterns below.
- **Problem** - one sentence. What hurts.
- **Solution** - one sentence. What changes.
- **Wins** - bullets, 6 words or fewer each. e.g. "Tests hit one interface", "Pricing logic stops leaking", "Delete 4 shallow wrappers".
- **ADR callout** (when the candidate contradicts one) - one line in an amber-tinted box.

No paragraphs of explanation. If a diagram needs a paragraph to be understood, redraw the diagram.

## Diagram patterns

Pick the pattern that fits the candidate. Mix them. Variety is part of the point.

### Mermaid graph (the workhorse for dependencies and call flow)

Use a Mermaid `flowchart` or `graph` when the point is "X calls Y calls Z, and look at the mess." Wrap it in a Tailwind-styled card so it matches the page. Style with classDef to colour leakage edges red and the deep module dark. Sequence diagrams work well for "before: 6 round-trips; after: 1."

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### Hand-built boxes and arrows (when Mermaid's layout fights you)

Modules as `<div>`s with borders and labels. Arrows as inline SVG `<line>` or `<path>` elements positioned over a relative container. Reach for this when the "after" diagram should read as one thick-bordered deep module with greyed-out internals, because Mermaid cannot render that with the right weight.

### Cross-section (for layered shallowness)

Stack horizontal bands (`h-12 border-l-4`) to show the layers a call passes through. Before: 6 thin layers each doing nothing. After: 1 thick band labelled with the consolidated responsibility.

### Mass diagram (for "interface as wide as implementation")

Two rectangles per module: interface surface area and implementation. Before: the interface rectangle is nearly as tall as the implementation rectangle, which is shallow. After: interface short, implementation tall.

### Call-graph collapse

Before: a tree of function calls as nested boxes. After: the same tree collapsed into one box, with the now-internal calls faded inside it.

## Style guidance

- Editorial, not corporate-dashboard. Generous whitespace. Serif optional for headings (`font-serif` works well with stone/slate).
- Colour sparingly: one accent (emerald or indigo), red for leakage, amber for warnings.
- Keep diagrams around 320px tall so before/after sits side by side without scrolling.
- Use `text-xs uppercase tracking-wider` for module labels inside diagrams, so they read as schematic rather than UI.
- The only scripts are the Tailwind CDN and the Mermaid ESM import. The report is static beyond Mermaid's own rendering.

## Not-proposed footer

One short section listing every candidate Step 4 dropped, each with its reference on one line: an ADR number or a Decision Ledger citation in `filename#Dxxx` form. The reader sees exactly what the survey did not re-propose, and where the standing decision lives.

## Top recommendation section

One larger card. Candidate name, one sentence on why, anchor link to its card. Nothing else.

## Tone

Plain English, concise, with the architectural nouns and verbs straight from `references/design-vocabulary.md`. Concision is not an excuse to drift.

Use exactly: module, interface, implementation, depth, deep, shallow, seam, adapter, leverage, locality.

Never say, when the glossary term fits: component, service, or unit for module; API or signature for interface; boundary for seam; layer or wrapper for module.

For domain names, use `GLOSSARY.md` vocabulary. If `GLOSSARY.md` defines "Order", write "the Order intake module", not "the FooBarHandler" and not "the Order service".

Phrasings that fit:

- "Order intake module is shallow: interface nearly matches the implementation."
- "Pricing leaks across the seam."
- "Deepen: one interface, one place to test."
- "Two adapters justify the seam: HTTP in prod, in-memory in tests."

Wins bullets name the gain in vocabulary terms: "locality: bugs concentrate in one module", "leverage: one interface, N call sites", "interface shrinks; implementation absorbs the wrappers". "Easier to maintain" and "cleaner code" say nothing; cut them.

No hedging, no throat-clearing, no "it is worth noting that...". If a sentence could be a bullet, make it a bullet. If a bullet could be cut, cut it. If a term is not in the design vocabulary, pick one that is before inventing a new one.
