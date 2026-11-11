---
name: unslop
description: >-
  Use when writing user facing documentation, README content, commit messages, or editing text files. Do not use for substantive rewrites, factual
  revision, or formatting-only edits.
license: MIT
---

# Unslop

Attribution: adapted from the [unslop
skill](https://github.com/cursor/plugins/blob/main/pstack/skills/unslop/SKILL.md)
in `cursor/plugins` (pstack plugin), © 2026 Lauren Tan, MIT License.

## When to Use

- The user explicitly invokes the skill: `/unslop`, "unslop this", "unslop the PR description", "de-slop the changelog".
- The user names the skill and a text target in one message: that invocation is the trigger.

## When Not to Use
- Substantive rewrites that change meaning, add missing facts, or restructure arguments. Fix the content first, then invoke this skill on the result.
- Formatting-only edits (HTML/Markdown conversion, whitespace, layout).
- Translations, quoted text (dialogue, citations, code comments in other files), and text whose "tells" are intentional (parody).

## Workflow

### Step 1: Scan

Scan the relevant target for every pattern in the rule list below. For each rule that matches, record the matching span before rewriting anything - the rewrite step consumes the record.

### Step 2: Rewrite

Edit the text to remove the recorded matches. Preserve meaning and match the intended tone of the surrounding text. Two changes are always in scope (they are what the user asked for): deleting a match without replacement, and replacing a match with a plain word of equal meaning.

A banned word is not banned inside quoted text, a proper noun, or a named API/code identifier - leave those untouched and say so in the summary.

### Step 3: Report

After editing, report one line per rule that matched: rule number, what changed, and any match left untouched (quoted text, identifiers). If no rule matched, say that plainly - an empty pass is a valid outcome.

### Content

3. **Superficial -ing phrases.** "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete or expand with real sources.
5. **Vague attributions.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source or delete.

### Language

7. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore, vibrant, empowering, deep dive, streamline. Replace with plain words.

    Fork note - local additions with no rule numbers of their own, so upstream rule numbers never collide. On an upstream sync, keep upstream's list and re-apply what is marked fork below.

    - **Use sparingly, don't ban** (plain words the model overuses; rewrite repeats and misuses, not every occurrence): bare (also usually misused here: "a bare ID" typically names an unquoted or unwrapped value; write what the state actually is, e.g. "an unquoted ID"), so (at most once per paragraph; do not include it as a filler sentence opener), leg (fine for "leg of a journey" - a distinct stretch with a start, end, and separate risks; rewrite repeat uses to "phase" or "attempt").
    - **Niche and overused idioms, not a blanket ban.** For each idiom in the target text, replace it with its literal phrase only when both conditions hold; otherwise keep it as written.
        1. A plain literal phrase exists for the idiom's meaning ("belt and braces" becomes "redundant safeguards" or "two independent checks").
        2. The idiom is niche (a general reader may misparse it - "belt and braces" is British and commonly parsed as belt-or-braces), difficult to parse, or already overused in the text at hand.
      An idiom that passes both is human voice, not a tell - keep it. Rule 32 carries the same literal-phrase test for metaphor and flourish outside the word list; these two conditions are the idiom case of it.
8. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Say "is" or "has".
9. **"Not just X, but Y."** State the point directly instead.
10. **Rule of three.** Don't force ideas into groups of three. Use the natural number.
11. **Synonym cycling.** Protagonist, main character, central figure, hero all in one paragraph. Pick one, repeat it.
12. **False ranges.** "from X to Y" where X and Y aren't on a meaningful scale. List topics directly.

### Style

13. **Em dash use.** Avoid em dashes entirely. Use periods or commas only (no parentheses, no en dashes, no hyphen-as-dash substitutes). If a thought needs separation, end the sentence or use a comma.
14. **Colon overuse.** Colons are fine before a list or example, not as mid-sentence connectors. "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" adds nothing with the colon. Rewrite to let the point stand on its own without comparison framing. "Describing when the scheduler should fire works best as plain English." Same meaning, no crutch punctuation.
15. **Boldface overuse.** Don't bold every proper noun or acronym.
16. **Inline-header lists.** The tell is a bold label and colon that restates the line: "**Performance:** Performance improved...". Convert those to prose. A bold lead-in that ends in a period, names the item, and is followed by genuinely new detail ("**Schema in TypeScript.** Tables live in one file.") is fine, not a tell.
17. **Title case headings.** Use sentence case.
18. **Decorative emojis.** Remove from headings and bullets.
19. **Curly quotes.** Use straight quotes.
20. **Run on sentences.**  Avoid long running sentences that rely on "so" or other connecting words to bridge substantially different ideas. Long sentences should be used sparingly. If a sentence has more than 3 commas in it and the sentence doesn't list items, it needs splitting up.
21. **Oxford Commas.** Use Oxford commas.  "I like chicken, beef, and pork" is clearer and easier to understand than "I like chicken, beef and pork".

### Communication artifacts

22. **Chatbot phrases.** "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" Remove.
23. **Sycophantic tone.** "Great question! You're absolutely right!" Respond directly.

### Filler
24. **Filler phrases.** "In order to" becomes "To". "Due to the fact that" becomes "Because". Delete "It is important to note that". Fork addition: delete "essentially" (it hedges without adding; the plain sentence carries the claim alone).
25. **Excessive hedging.** "could potentially possibly be argued that it might" becomes "may".
26. **Generic conclusions.** "The future looks bright." State specific plans or facts.

### Jargon

27. **Abstract metaphor nouns.** Substrate (base), wedge, wedge in (add), vector (way, method), locus, vantage, nexus, primitive as a noun, harness as a metaphor, surface as in "API surface", bedrock, scaffolding as a metaphor, modality, paradigm, gold-plating (more than the job needs), ratchet as a metaphor (the mechanism's real name, or a limit that only tightens), evacuate for moving code (move out), endgame (the last phase), north star, flywheel. These usually have a plainer concrete word. Pick the concrete word.

### Plain speech

28. **Say what it does, not how it feels.** "SQL you can read", "types that follow your schema" name a feeling. The fix names the mechanism or a number: "`.toSQL()` returns the exact string sent to the database", "a column rename fails the build". Ask what the sentence tells the reader to do or know, then write that. If you can't restate it as a concrete instruction, fact, or number, cut it. One more check: if the sentence could appear unchanged in another project's docs, it says nothing about this one. Cut it.
29. **Shorten or split dense sentences.** If the reader has to backtrack to parse a sentence, break it in two or drop clauses. One idea per sentence.
30. **Active voice.** Prefer it. Catch "is/are/was/were + past participle" and name the actor: "queries are validated" becomes "the compiler validates queries", "the file is parsed by the loader" becomes "the loader parses the file". Passive is fine only when the actor is unknown or genuinely doesn't matter.
31. **Cut adverbs, or use a stronger verb.** "runs quickly" becomes "is fast" or the number, and "significantly improves" becomes the measured delta. An adverb propping up a weak verb means the verb is wrong.
32. **Prefer the plain word.** "utilize" and "leverage" become "use", "facilitate" becomes "help", "numerous" becomes "many", "in the event that" becomes "if". The fancier synonym is rarely clearer.
33. **Mannered prose.** Metaphor or flourish where a literal phrase exists: aphorisms ("wire it or delete it"), rhetorical fragments for effect, personified code ("the plan holds it"), figurative verbs ("rides along", "stands on"), stock framing phrases. "A dial worth turning" becomes "a parameter worth varying". Say what you mean. Rule 26 covers the metaphor nouns.
34. **Over-compression.** Dropped articles, verbless fragments, symbol-speak, and abbreviations that make the reader decode instead of read. "Parser rejects bad date → exit 2, no write" becomes "The parser rejects a bad date, exits with code 2, and writes nothing." Write whole sentences with their articles and verbs, and spell out arrows and abbreviations.

## Validation

- [ ] The skill ran only because of an explicit invocation; it did not fire on prose work that merely looked slop-like.
- [ ] Every rule in the rule list was checked against the scan target; matches were recorded before any edit.
- [ ] Banned words inside quoted text, proper nouns, and identifiers were left untouched and reported as untouched.
- [ ] Meaning and the surrounding tone were preserved; only tell-removal edits were made.
- [ ] The report lists every matched rule with a change or an explicit untouched note; a pass with no matches is reported as empty rather than skipped silently.
- [ ] Sparing-list words (bare, so, leg) were rewritten only when repeated in one passage or used in their named misuse; single correct uses survive.
- [ ] Idioms were replaced with the literal phrase only when niche, difficult to parse, or overused; common idioms survive.
- [ ] The attribution header names the upstream skill, author, license, and fork-point commit SHA.
