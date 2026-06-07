#!/usr/bin/env python3
"""Aggregate raw probe results from subagent executions.

This utility takes the outputs of isolated subagent probes (YES/NO answers)
and calculates final trigger rates and pass/fail metrics for a skill.
"""

import argparse
import json
import sys
from pathlib import Path

def aggregate_probes(probes_data: list[dict]) -> dict:
    """
    Aggregate raw probe results.
    
    Expected input format: A list of probes where each probe contains:
    - query: The original trigger query
    - should_trigger: Boolean indicating if it was expected to trigger
    - results: List of 'YES'/'NO' responses from the subagent runs
    """
    summary = {
        "total_queries": 0,
        "passed_queries": 0,
        "failed_queries": 0,
        "details": []
    }

    for probe in probes_data:
        query = probe.get("query", "Unknown Query")
        should_trigger = probe.get("should_trigger", True)
        results = [r.strip().upper() == "YES" for r in probe.get("results", [])]
        
        if not results:
            continue

        trigger_count = sum(results)
        runs = len(results)
        trigger_rate = trigger_count / runs
        
        # A query passes if it triggers when it should, or doesn't when it shouldn't.
        # We use the trigger_rate for the verdict. 
        # (e.g., rate > 0.5 means it generally triggers)
        did_pass = (trigger_rate > 0.5) == should_trigger
        
        if did_pass:
            summary["passed_queries"] += 1
        else:
            summary["failed_queries"] += 1
            
        summary["details"].append({
            "query": query,
            "should_trigger": should_trigger,
            "trigger_rate": trigger_rate,
            "triggers": trigger_count,
            "runs": runs,
            "pass": did_pass
        })
        summary["total_queries"] += 1

    summary["pass_rate"] = summary["passed_queries"] / summary["total_queries"] if summary["total_queries"] > 0 else 0
    return summary

def main():
    parser = argparse.ArgumentParser(description="Aggregate raw probe results for skill trigger evaluation")
    parser.add_argument("--input", required=True, help="Path to raw probe results JSON file")
    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input file not found at {input_path}", file=sys.stderr)
        sys.exit(1)

    with open(input_path, "r") as f:
        probes_data = json.load(f)

    aggregated = aggregate_probes(probes_data)
    print(json.dumps(aggregated, indent=2))

if __name__ == "__main__":
    main()
