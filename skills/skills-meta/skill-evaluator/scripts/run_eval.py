#!/usr/bin/env python3
"""Generate a probe plan for skill trigger evaluation.

Instead of executing the probes, this script generates a structured plan 
that an agent can use to execute isolated probes via the Task tool.
"""

import argparse
import json
import sys
from pathlib import Path

from scripts.utils import parse_skill_md


def generate_probe_plan(
    eval_set: list[dict],
    skill_name: str,
    runs_per_query: int,
) -> list[dict]:
    """Create a list of probes with surgical prompts for trigger verification."""
    probes = []

    for item in eval_set:
        query = item["query"]
        should_trigger = item.get("should_trigger", True)
        
        # The surgical prompt is a minimal YES/NO check to minimize token spend
        # and maximize determinism.
        surgical_prompt = (
            f"Did the model trigger the '{skill_name}' skill for the following query?\n\n"
            f"Query: {query}\n\n"
            f"Answer only YES or NO."
        )
        
        probes.append({
            "query": query,
            "should_trigger": should_trigger,
            "surgical_prompt": surgical_prompt,
            "runs_required": runs_per_query
        })
    
    return probes


def main():
    parser = argparse.ArgumentParser(description="Generate a probe plan for skill trigger evaluation")
    parser.add_argument("--eval-set", required=True, help="Path to eval set JSON file")
    parser.add_argument("--skill-path", required=True, help="Path to skill directory")
    parser.add_argument("--runs-per-query", type=int, default=3, help="Number of runs per query (default: 3)")
    args = parser.parse_args()

    eval_set_path = Path(args.eval_set)
    if not eval_set_path.exists():
        print(f"Error: Eval set file not found at {eval_set_path}", file=sys.stderr)
        sys.exit(1)

    eval_set = json.loads(eval_set_path.read_text())
    skill_path = Path(args.skill_path)

    if not (skill_path / "SKILL.md").exists():
        print(f"Error: No SKILL.md found at {skill_path}", file=sys.stderr)
        sys.exit(1)

    name, _, _ = parse_skill_md(skill_path)

    probe_plan = generate_probe_plan(
        eval_set=eval_set,
        skill_name=name,
        runs_per_query=args.runs_per_query,
    )

    print(json.dumps(probe_plan, indent=2))


if __name__ == "__main__":
    main()
