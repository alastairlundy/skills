#!/usr/bin/env python3
"""Generate an HTML report from trigger evaluation results.

Takes the JSON output from the trigger aggregation utility and generates a visual HTML report
showing the trigger performance for a set of queries.
"""

import argparse
import html
import json
import sys
from pathlib import Path

def generate_html(data: dict, auto_refresh: bool = False, skill_name: str = "") -> str:
    """Generate HTML report from aggregated probe data. If auto_refresh is True, adds a meta refresh tag."""
    details = data.get("details", [])
    title_prefix = html.escape(skill_name + " \u2014 ") if skill_name else ""

    refresh_tag = '    <meta http-equiv="refresh" content="5">\n' if auto_refresh else ""

    html_parts = [f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
{refresh_tag}    <title>{title_prefix}Trigger Discoverability Report</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600&family=Lora:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body {{
            font-family: 'Lora', Georgia, serif;
            max-width: 100%;
            margin: 0 auto;
            padding: 20px;
            background: #faf9f5;
            color: #141413;
        }}
        h1 {{ font-family: 'Poppins', sans-serif; color: #141413; }}
        .explainer {{
            background: white;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid #e8e6dc;
            color: #b0aea5;
            font-size: 0.875rem;
            line-height: 1.6;
        }}
        .summary {{
            background: white;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid #e8e6dc;
        }}
        .summary p {{ margin: 5px 0; }}
        .best {{ color: #788c5d; font-weight: bold; }}
        .table-container {{
            overflow-x: auto;
            width: 100%;
        }}
        table {{
            border-collapse: collapse;
            background: white;
            border: 1px solid #e8e6dc;
            border-radius: 6px;
            font-size: 12px;
            min-width: 100%;
        }}
        th, td {{
            padding: 8px;
            text-align: left;
            border: 1px solid #e8e6dc;
            white-space: normal;
            word-wrap: break-word;
        }}
        th {{
            font-family: 'Poppins', sans-serif;
            background: #141413;
            color: #faf9f5;
            font-weight: 500;
        }}
        th.query-col {{ min-width: 200px; }}
        td.result {{
            text-align: center;
            font-size: 16px;
            min-width: 40px;
        }}
        .pass {{ color: #788c5d; }}
        .fail {{ color: #c44; }}
        .rate {{
            font-size: 9px;
            color: #b0aea5;
            display: block;
        }}
        tr:hover {{ background: #faf9f5; }}
        .score {{
            display: inline-block;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 11px;
        }}
        .score-good {{ background: #eef2e8; color: #788c5d; }}
        .score-ok {{ background: #fef3c7; color: #d97706; }}
        .score-bad {{ background: #fceaea; color: #c44; }}
        .legend {{ font-family: 'Poppins', sans-serif; display: flex; gap: 20px; margin-bottom: 10px; font-size: 13px; align-items: center; }}
        .legend-item {{ display: flex; align-items: center; gap: 6px; }}
        .legend-swatch {{ width: 16px; height: 16px; border-radius: 3px; display: inline-block; }}
        .swatch-positive {{ background: #141413; border-bottom: 3px solid #788c5d; }}
        .swatch-negative {{ background: #141413; border-bottom: 3px solid #c44; }}
    </style>
</head>
<body>
    <h1>{title_prefix}Trigger Discoverability Report</h1>
    <div class="explainer">
        <strong>Surgical Probing Analysis.</strong> This report shows the trigger performance of the skill description across a set of test queries.
        A checkmark indicates the skill triggered (or didn't trigger) as expected.
    </div>
    <div class="summary">
        <p><strong>Total Queries:</strong> {data.get("total_queries", 0)}</p>
        <p><strong>Passed Queries:</strong> {data.get("passed_queries", 0)}</p>
        <p><strong>Failed Queries:</strong> {data.get("failed_queries", 0)}</p>
        <p><strong>Pass Rate:</strong> {round(data.get("pass_rate", 0) * 100, 2)}%</p>
    </div>

    <div class="legend">
        <span style="font-weight:600">Query columns:</span>
        <span class="legend-item"><span class="legend-swatch swatch-positive"></span> Should trigger</span>
        <span class="legend-item"><span class="legend-swatch swatch-negative"></span> Should NOT trigger</span>
    </div>

    <div class="table-container">
    <table>
        <thead>
            <tr>
                <th class="query-col">Query</th>
                <th>Expected</th>
                <th>Result</th>
                <th>Trigger Rate</th>
            </tr>
        </thead>
        <tbody>
"""]

    for probe in details:
        should_trigger = probe.get("should_trigger", True)
        did_pass = probe.get("pass", False)
        polarity = "Positive" if should_trigger else "Negative"
        icon = "✓" if did_pass else "✗"
        css_class = "pass" if did_pass else "fail"
        rate = f"{probe.get('triggers', 0)}/{probe.get('runs', 0)}"
        
        html_parts.append(f"""
            <tr>
                <td>{html.escape(probe.get('query', ''))}</td>
                <td>{polarity}</td>
                <td class="result {css_class}">{icon}</td>
                <td><span class="rate">{rate}</span></td>
            </tr>
        """)
    
    html_parts.append("""
        </tbody>
    </table>
    </div>
</body>
</html>
""")
    return "".join(html_parts)

def main():
    parser = argparse.ArgumentParser(description="Generate HTML report from trigger evaluation results")
    parser.add_argument("input", help="Path to JSON output from aggregate_probes.py (or - for stdin)")
    parser.add_argument("-o", "--output", default=None, help="Output HTML file (default: stdout)")
    parser.add_argument("--skill-name", default="", help="Skill name to include in the report title")
    args = parser.parse_args()

    if args.input == "-":
        data = json.load(sys.stdin)
    else:
        data = json.loads(Path(args.input).read_text())

    html_output = generate_html(data, skill_name=args.skill_name)

    if args.output:
        Path(args.output).write_text(html_output)
        print(f"Report written to {args.output}", file=sys.stderr)
    else:
        print(html_output)

if __name__ == "__main__":
    main()
