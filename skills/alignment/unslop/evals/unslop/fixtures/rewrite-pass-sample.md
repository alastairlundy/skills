# Unslop eval fixture: rewrite pass over rule-violating text
# Used by perf-word-list.yaml. The input text is inlined in the task; this file
# documents the fixture and its expected outcome so future task edits stay
# faithful to what the assertion checks.

## Sample input

    One of the things that makes our platform special is that it's not just a
    database, it's a comprehensive data tapestry. This is a testament to our
    intricate architecture, highlighting our commitment to excellence.
    Additionally, the seamless integration serves as a bedrock for our
    developers, and our vibrant community plays a pivotal role. Importantly,
    the three pillars of speed, scalability, and, crucially, security - which
    is crucial - underpin everything. Experts believe this will enhance
    productivity by a lot.

    The deep dive into the importer is empowering: a bare retry command
    streamlines each leg of the run, so the safeguarding ends up belt and
    braces. Essentially, repeated runs get closer and closer to zero
    failures.

## Expected outcome checklist

- Rule 7 words (tapestry, intricate, Additionally, vibrant, pivotal, crucial, enhance) removed or replaced with plain words.
- Rule 9: "it's not just a database, it's..." rewritten as a direct statement.
- Rule 3: the "-ing" flourish ("highlighting our commitment to excellence") deleted or replaced with a real claim.
- Rule 5: "Experts believe..." named as a source or deleted.
- Rule 8: "serves as" reduced to "is".
- Rule 10: the forced rule-of-three ("three pillars of speed, scalability, and security") uses the natural number, and "crucially" / "which is crucial" is no longer a bolt-on.
- Rule 13: the em dash removed.
- Rule 7 fork additions (empowering, deep dive, streamlines/streamline) removed.
- Rule 7 sparingly-list: bare, so, and leg appear at most once each, and "a bare retry command" is rewritten to the state it names (e.g. "a retry with no backoff") unless the original was correct.
- Rule 7 idiom clause: "belt and braces" replaced with the literal phrase ("redundant safeguards" or "two independent checks").
- Rule 23 fork addition: "Essentially" deleted.
- Meaning preserved; no new claims invented.
