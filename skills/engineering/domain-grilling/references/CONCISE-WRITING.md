# Concise Writing Guide

This document provides optional style guidance for the domain-grilling skill. It is not mandatory — the hard constraints in SKILL.md take priority. Consult this reference when you want to improve the clarity and tightness of your output.

## Principles

1. **Every sentence must earn its place.** If removing a sentence doesn't lose information, remove it.
2. **Prefer active voice.** "The LLM may ignore this" not "This may be ignored by the LLM."
3. **One idea per sentence.** If a sentence contains "and" connecting two independent clauses, split it.
4. **Cut hedge words.** "might possibly" → "might". "could potentially" → "could".
5. **Cut redundant qualifiers.** "very unique" → "unique". "completely eliminate" → "eliminate".

## Common Patterns to Avoid

The single source of truth for banned phrases is the **Forbidden Filler Words** list in `SKILL.md`. This reference does not duplicate it — consult `SKILL.md` for the canonical list, and apply it via the principles below.

## Before and After

**Before:** The recommendation is essentially that Option 2 sets the precondition, which means that the gate gets encoded at registration time, and it's worth noting that this approach is actually more deterministic than Option 1.

**After:** Option 2 sets the precondition. The gate is encoded at registration time. This is more deterministic than Option 1.

**Before:** It is important to keep in mind that the risk of data overlap exists, and note that consumers can end up with the same model described in three different shapes from three different HTTP calls, which could potentially lead to hidden coupling.

**After:** Data overlap is a risk. Consumers may receive the same model in three different shapes from three HTTP calls. This creates hidden coupling.

## Sentence Structure

- **Target:** 10-15 words per sentence.
- **Maximum:** 20 words for hard-constrained fields (Benefit, Cost, Risk, What it is).
- **Avoid:** sentences that require the reader to re-read to understand the subject.
- **Prefer:** subject-verb-object order. Put the actor first.
