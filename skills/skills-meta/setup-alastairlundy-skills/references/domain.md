# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

<!-- The skill fills in ONE of the two layout variants below based on the user's choice in Step 4. Delete the unused variant. -->

## Single-context layout

This is a single-context repo. The domain vocabulary lives in `GLOSSARY.md` at the repo root.

### Before exploring, read these

- **`GLOSSARY.md`** at the repo root.
- **`docs/adr/`** — read ADRs that touch the area you're about to work in.

If any of these files don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. The producer skill (`/domain-grilling`) creates them lazily when terms or decisions actually get resolved.

### File structure

```
/
├── GLOSSARY.md
├── AGENTS.md
├── <repo-specific structure>
└── docs/
    ├── adr/
    └── agents/
```

## Multi-context layout

This is a multi-context repo. The system-wide domain vocabulary lives in `GLOSSARY.md` at the repo root, and `GLOSSARY-MAP.md` points to per-context `GLOSSARY.md` files.

### Before exploring, read these

- **`GLOSSARY.md`** at the repo root (system-wide terms).
- **`GLOSSARY-MAP.md`** at the repo root — it points at one `GLOSSARY.md` per context. Read each one relevant to the topic.
- **`docs/adr/`** — read ADRs that touch the area you're about to work in. Also check `<context-path>/docs/adr/` for context-scoped decisions.

If any of these files don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. The producer skill (`/domain-grilling`) creates them lazily when terms or decisions actually get resolved.

### File structure

```
/
├── GLOSSARY.md
├── GLOSSARY-MAP.md
├── AGENTS.md
├── <context-a>/
│   ├── GLOSSARY.md
│   └── docs/adr/
├── <context-b>/
│   ├── GLOSSARY.md
│   └── docs/adr/
└── docs/
    ├── adr/
    └── agents/
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `GLOSSARY.md`. Don't drift to synonyms the glossary explicitly avoids.

If the concept you need isn't in the glossary yet, that's a signal — either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for `/domain-grilling`).

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_
