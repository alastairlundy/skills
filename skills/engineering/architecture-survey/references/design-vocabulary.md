<!--
  Derived from SKILL.md and DESIGN-IT-TWICE.md (codebase-design skill) by Matt Pocock
  Source: https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/SKILL.md
  Original license: MIT
  Condensed and adapted for the architecture-survey skill's self-contained vocabulary.
-->

# Design Vocabulary

The shared language for every candidate, card, and diagram this skill produces. Use these terms exactly. Consistent language is the whole point.

## Glossary

**Module** - anything with an interface and an implementation. Scale-agnostic: a function, class, package, or tier-spanning slice. Do not say unit, component, or service.

**Interface** - everything a caller must know to use the module correctly: the type signature, plus invariants, ordering constraints, error modes, required configuration, and performance characteristics. Do not say API or signature; both cover only the type-level surface.

**Implementation** - the code inside a module. Distinct from **adapter**: a Postgres repository is a large implementation behind a small adapter; an in-memory fake is the reverse. Say adapter when the seam is the topic, implementation otherwise.

**Depth** - leverage at the interface: how much behaviour a caller (or test) can exercise per unit of interface they must learn. A module is **deep** when a large amount of behaviour sits behind a small interface, **shallow** when the interface is nearly as complex as the implementation.

**Seam** (Michael Feathers) - a place where you can alter behaviour without editing in that place; the location where a module's interface lives. Where the seam goes is its own design decision, separate from what sits behind it. Do not say boundary; that word belongs to DDD's bounded context.

**Adapter** - a concrete thing that satisfies an interface at a seam. It names the slot it fills, not what is inside.

**Leverage** - what callers get from depth: more capability per unit of interface learned. One implementation pays back across N call sites and M tests.

**Locality** - what maintainers get from depth: change, bugs, knowledge, and verification concentrate in one place instead of spreading across callers. Fix once, fixed everywhere.

## Deep vs shallow

```
Deep module                      Shallow module (avoid)
+---------------------+          +---------------------------+
|   Small interface   |          |       Large interface     |
+---------------------+          +---------------------------+
|                    |           |  Thin implementation    |
|  Deep implementation|           |                        |
|                    |           +---------------------------+
+---------------------+
```

When designing an interface ask: can I reduce the number of methods? Can I simplify the parameters? Can I hide more complexity inside?

## Principles

- **Depth is a property of the interface, not the implementation.** A deep module can still contain small, swappable parts internally; they simply are not part of its interface. A module can have internal seams (private to its implementation, used by its own tests) as well as the external seam at its interface.
- **The deletion test.** Imagine deleting the module. If the complexity vanishes, the module was a pass-through and the answer is "complexity just moves". If the complexity reappears across N callers, the module was doing real work and the answer is "complexity concentrates here". Only the second answer keeps a candidate.
- **The interface is the test surface.** Callers and tests cross the same seam. A test that must reach past the interface means the module is the wrong shape.
- **One adapter means a hypothetical seam. Two adapters mean a real one.** Introduce a seam only when something actually varies across it.

## Testability heuristics

Good interfaces make testing natural:

1. Accept dependencies, do not create them: take the gateway as a parameter, do not construct `new StripeGateway()` inside.
2. Return results, do not produce side effects: return a `Discount`, do not mutate `cart.total`.
3. Keep the surface small: fewer methods means fewer tests; fewer parameters means simpler setup.

## Design-it-twice

When the user wants to explore alternative interfaces for a deepened module:

1. Fix the behaviour the interface must expose. Write it down once.
2. Spawn parallel sub-agents. Each designs a radically different interface for the same behaviour, unseen by the others.
3. Compare the proposals on depth, locality, and seam placement using the glossary above. Pick one, or blend. Let the running `technical-grilling` session record the choice and its reason in the Decision Ledger.

## Vocabulary drift

Say module, interface, depth, seam, adapter, leverage, locality. Do not substitute component, service, API, signature, boundary, layer, or wrapper for a defined term. Rewrite any card or diagram that drifts before shipping the report.
