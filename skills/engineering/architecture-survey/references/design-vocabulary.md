<!--
  Derived from SKILL.md and DESIGN-IT-TWICE.md (codebase-design skill) by Matt Pocock
  Source: https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/SKILL.md
  Original license: MIT
  Condensed and adapted for the architecture-survey skill's self-contained vocabulary.
-->

# Design Vocabulary

The shared language for every candidate, card, and diagram this skill produces. Use these terms exactly. Consistent language is the whole point. Do not use `depth`, `deep`, `shallow`, `seam`, `leverage`, or `locality`. Their replacements below are the only allowed forms.

## Glossary

**Module** - anything with an interface and an implementation. Scale-agnostic: a function, class, package, or tier-spanning slice. Do not say unit, component, or service.

**Interface** - everything a caller must know to use the module correctly: the type signature, plus invariants, ordering constraints, error modes, required configuration, and performance characteristics. Do not say API or signature; both cover only the type-level surface. Where the interface is drawn is its own design decision, separate from what sits behind it. Do not say boundary; that word belongs to DDD's bounded context. There is no separate noun for the interface location. Say where the interface sits.

**Implementation** - the code inside a module. Distinct from **adapter**: a Postgres repository is a large implementation behind a small interface; an in-memory fake is the reverse. Say adapter when where-the-interface-sits is the topic, implementation otherwise.

**Consolidate** (verb) - move behavior behind one interface and delete the wrappers around it. A module is **consolidated** when a large amount of behaviour sits behind a small interface, **thin** when the interface is nearly as complex as the implementation. Never say deepen, deep, depth, or shallow.

**Adapter** - a concrete thing that shares one interface with another implementation. It names the slot it fills, not what is inside. Two implementations sharing one interface (HTTP in prod, in-memory in tests) make the interface real.

**Reuse** - what callers get from consolidation: more capability per unit of interface learned. Always state with N call sites and M tests. Never say leverage. Example: `reuse: one interface, 4 call sites`.

**Concentration** - what maintainers get from consolidation: change, bugs, knowledge, and verification sit in one named place instead of spreading across callers. Always state with the location. Never say locality. Example: `concentration: pricing bugs land in Order intake`.

## Consolidated vs thin

```
Consolidated module              Thin module (avoid)
+---------------------+          +---------------------------+
|   Small interface   |          |       Large interface     |
+---------------------+          +---------------------------+
|                    |           |  Thin implementation    |
| Consolidated behavior|          |                        |
|                    |           +---------------------------+
+---------------------+
```

When designing an interface ask: can I reduce the number of methods? Can I simplify the parameters? Can I hide more complexity inside?

## Principles

- **Consolidation is a property of the interface, not the implementation.** A consolidated module can still contain small, swappable parts internally; they simply are not part of its public interface. A module can have internal interfaces (private to its implementation, used by its own tests) as well as the public interface.
- **The deletion test.** Imagine deleting the module. If the complexity vanishes, the module was a pass-through and the answer is "complexity just moves". If the complexity reappears across N callers, the module was doing real work and the answer is "complexity concentrates here". Only the second answer keeps a candidate.
- **The interface is the test surface.** Callers and tests cross the same interface. A test that must reach past the interface means the module is the wrong shape.
- **One adapter means a hypothetical interface. Two adapters mean a real one.** Introduce an interface split only when something actually varies across it.

## Testability heuristics

Good interfaces make testing natural:

1. Accept dependencies, do not create them: take the gateway as a parameter, do not construct `new StripeGateway()` inside.
2. Return results, do not produce side effects: return a `Discount`, do not mutate `cart.total`.
3. Keep the surface small: fewer methods means fewer tests; fewer parameters means simpler setup.

## Design-it-twice

When the user wants to explore alternative interfaces for a consolidated module:

1. Fix the behaviour the interface must expose. Write it down once.
2. Spawn parallel sub-agents. Each designs a radically different interface for the same behaviour, unseen by the others.
3. Compare the proposals on reuse, concentration, and interface placement using the glossary above. Pick one, or blend. Let the running `technical-grilling` session record the choice and its reason in the Decision Ledger.

## Vocabulary drift

Say module, interface, implementation, consolidate, consolidated, thin, adapter, reuse, concentration. Do not substitute component, service, API, signature, boundary, layer, or wrapper for a defined term. Never use depth, deep, shallow, deepen, seam, leverage, or locality. Rewrite any card or diagram that drifts before shipping the report.
