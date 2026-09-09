# check-ledger-record.ps1
# Verifies the post-pick step wrote a new Dxxx or Txxx record to the
# Decision Ledger file.
#
# Pass criteria:
#   1. A DECISIONS-*.md file exists under <workspace>/docs/decisions/.
#   2. The file contains at least two `### [Dxxx]` or `### [Txxx]` records
#      combined (at least one of each stream is not required).
#   3. The last record in the file (by file order, not by numeric value)
#      includes a `Driver` line.
#   4. The last record's ID is the highest ID in its stream (the new
#      append is the latest record, not a re-write of an earlier one).
#   5. The file ends with all three sentinel comments:
#      `<!-- next-d: Dxxx -->`, `<!-- next-t: Txxx -->`, `<!-- next-i: Ixxx -->`.
#   6. Every `### [Ixxx]` record (if any) is a completed clarifying
#      interaction: no `TBD` remains, and the Prompt does not carry
#      locked-question or goal-discovery phrasing ("pick an option",
#      "hybridize", "You may answer, or skip") - fixed elicitation
#      prompts are recorded as Dxxx/Txxx records, not Ixxx.
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

$dPattern = '### \[D(\d{3})\]'
$tPattern = '### \[T(\d{3})\]'
$sentinelPattern = '<!-- (next-[dti]): ([A-Z]\d{3}) -->'
$ixxPattern = '### \[I(\d{3})\]'
$recordPattern = '### \[(?:[DTI]\d{3})\]'
$lockedPromptPattern = '(pick an option|hybridize|You may answer, or skip)'

$passing = $false
$report = ''
foreach ($ledger in $ledgers) {
  $content = Get-Content -LiteralPath $ledger.FullName -Raw
  $dMatches = [regex]::Matches($content, $dPattern)
  $tMatches = [regex]::Matches($content, $tPattern)
  $totalRecords = $dMatches.Count + $tMatches.Count

  if ($totalRecords -lt 2) { continue }

  # Check the last record by file order (could be D or T)
  $allMatches = @($dMatches) + @($tMatches)
  $allMatches = $allMatches | Sort-Object { $_.Index }

  $lastMatch = $allMatches[$allMatches.Count - 1]
  $lastBlock = $content.Substring($lastMatch.Index)
  $lastId = $lastMatch.Groups[1].Value
  $lastPrefix = $lastMatch.Groups[0].Value.Substring(5, 1)
  $hasDriver = $lastBlock -match 'Driver'

  # Verify the last record is the highest in its stream
  if ($lastPrefix -eq 'D') {
    $ids = @($dMatches | ForEach-Object { [int]$_.Groups[1].Value })
    $maxId = ($ids | Measure-Object -Maximum).Maximum
    $priorCount = @($ids | Where-Object { $_ -lt $maxId }).Count
    $isHighest = ([int]$lastId -eq $maxId) -and ($priorCount -ge 1)
  } else {
    $ids = @($tMatches | ForEach-Object { [int]$_.Groups[1].Value })
    $maxId = ($ids | Measure-Object -Maximum).Maximum
    $priorCount = @($ids | Where-Object { $_ -lt $maxId }).Count
    $isHighest = ([int]$lastId -eq $maxId) -and ($priorCount -ge 1)
  }

  # Check all three sentinels exist
  $sentinelMatches = [regex]::Matches($content, $sentinelPattern)
  $sentinelTypes = @($sentinelMatches | ForEach-Object { $_.Groups[1].Value })
  $hasAllSentinels = ($sentinelTypes -contains 'next-d') -and
                     ($sentinelTypes -contains 'next-t') -and
                     ($sentinelTypes -contains 'next-i')

  # Ixxx discipline: any Ixxx record must be a completed clarifying
  # interaction - no TBD left, no locked-question/goal-discovery
  # phrasing in its Prompt.
  $ixxMatches = [regex]::Matches($content, $ixxPattern)
  $recordMatches = [regex]::Matches($content, $recordPattern)
  $ixxViolations = @()
  foreach ($ixx in $ixxMatches) {
    $nextRecord = $recordMatches |
      Where-Object { $_.Index -gt $ixx.Index } |
      Sort-Object Index |
      Select-Object -First 1
    $blockEnd = if ($nextRecord) { $nextRecord.Index } else { $content.Length }
    $ixxBlock = $content.Substring($ixx.Index, $blockEnd - $ixx.Index)
    if (($ixxBlock -match '\bTBD\b') -or ($ixxBlock -match $lockedPromptPattern)) {
      $ixxViolations += "I$($ixx.Groups[1].Value)"
    }
  }

  if ($hasDriver -and $isHighest -and $hasAllSentinels -and $ixxViolations.Count -gt 0) {
    Write-Output ("FAIL: Ixxx discipline violation(s) at {0} in {1} (Ixxx records must be completed clarifying interactions - no TBD, no locked-question/goal-discovery phrasing)" -f ($ixxViolations -join ', '), $ledger.Name)
    exit 1
  }

  if ($hasDriver -and $isHighest -and $hasAllSentinels) {
    $passing = $true
    $report = "PASS: $($ledger.Name) ends with $($lastPrefix)$lastId (highest of $totalRecords records, Driver field present, 3 sentinels present, $($ixxMatches.Count) Ixxx record(s) clean)"
    break
  }
}

if (-not $passing) {
  Write-Output 'FAIL: no ledger satisfied the post-pick criteria (>=2 Dxxx/Txxx records, last record has Driver, last record is highest in its stream, 3 sentinels present, all Ixxx records clean of TBD/locked-question phrasing)'
  exit 1
}

Write-Output $report
exit 0
