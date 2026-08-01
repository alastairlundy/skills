# check-ledger-record.ps1
# Verifies the post-pick step wrote a new Dxxx record to the Decision
# Ledger file.
#
# Pass criteria:
#   1. A DECISIONS-*.md file exists under <workspace>/docs/decisions/.
#   2. The file contains at least two `### [Dxxx]` records.
#   3. The last record in the file (by file order, not by numeric value)
#      includes a `Driver` line.
#   4. The last record's D-id is the highest D-id in the file (the new
#      append is the latest record, not a re-write of an earlier one).
#
# Environment:
#   WAZA_WORKSPACE_DIR  per-task workspace path (set by waza's `program`
#                       grader). Falls back to the current directory.
#
# Exit codes:
#   0  PASS
#   1  FAIL (any criterion above not met)

$ErrorActionPreference = 'Stop'

$workspace = $env:WAZA_WORKSPACE_DIR
if (-not $workspace) { $workspace = (Get-Location).Path }

$decisionsDir = Join-Path $workspace 'docs/decisions'
if (-not (Test-Path -LiteralPath $decisionsDir)) {
  Write-Output 'FAIL: docs/decisions/ directory not found in workspace'
  exit 1
}

$ledgers = @(Get-ChildItem -LiteralPath $decisionsDir -Filter 'DECISIONS-*.md' -File)
if ($ledgers.Count -eq 0) {
  Write-Output 'FAIL: no DECISIONS-*.md file found under docs/decisions/'
  exit 1
}

$headerPattern = '### \[D(\d{3})\]'

$passing = $false
$report = ''
foreach ($ledger in $ledgers) {
  $content = Get-Content -LiteralPath $ledger.FullName -Raw
  $matches = [regex]::Matches($content, $headerPattern)
  if ($matches.Count -lt 2) { continue }

  $ids = @()
  foreach ($m in $matches) { $ids += [int]$m.Groups[1].Value }
  $maxId = ($ids | Measure-Object -Maximum).Maximum
  $priorCount = @($ids | Where-Object { $_ -lt $maxId }).Count

  $lastMatch = $matches[$matches.Count - 1]
  $lastBlock = $content.Substring($lastMatch.Index)
  $lastId = [int]$lastMatch.Groups[1].Value
  $hasDriver = $lastBlock -match 'Driver'
  $isHighest = ($lastId -eq $maxId) -and ($priorCount -ge 1)

  if ($hasDriver -and $isHighest) {
    $passing = $true
    $report = "PASS: $($ledger.Name) ends with D$('{0:D3}' -f $lastId) (highest of $($ids.Count) records, Driver field present)"
    break
  }
}

if (-not $passing) {
  Write-Output 'FAIL: no ledger satisfied the post-pick criteria (>=2 Dxxx records, last record has Driver, last record is the highest D-id)'
  exit 1
}

Write-Output $report
exit 0
