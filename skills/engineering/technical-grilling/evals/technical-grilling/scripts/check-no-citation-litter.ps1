# check-no-citation-litter.ps1
# Verifies that ledger citation IDs did not leak beyond the elicitation
# artifacts into the implementing agent's produced files (source code,
# comments, commit messages, other docs).
#
# Fail criteria (any hit is a FAIL):
#   A file under <workspace> other than the Decision Ledger
#   (docs/decisions/DECISIONS-*.md) and its companion Implementation
#   Blueprint (IMPLEMENTATION-*.md / *.blueprint) contains:
#     - a bare Dxxx/Txxx ID reference:  D\d{3}, T\d{3} in a citation-ish
#       context (matching [ or # or 'DECISIONS' proximity), or
#     - the literal string 'DECISIONS-' followed by anything, or
#     - any of the above inside a git commit message subject line.
#
# Bare IDs are only counted when they appear outside the two whitelisted
# artifact kinds; a code comment '# implements D003' or a commit
# 'feat: watcher (T002)' fail the check.
#
# Environment:
#   WAZA_WORKSPACE_DIR  per-task workspace path (set by waza's `program`
#                       grader). Falls back to the current directory.
#
# Exit codes:
#   0  PASS (no leaked references found)
#   1  FAIL (leaked references found; each hit is printed)

$ErrorActionPreference = 'Stop'

$workspace = $env:WAZA_WORKSPACE_DIR
if (-not $workspace) { $workspace = (Get-Location).Path }

$ledgerDir = Join-Path $workspace 'docs/decisions'

# Whitelisted relative path prefixes (citation-carrying artifacts)
$allowed = @($ledgerDir)
$ledgerResolved = Resolve-Path -LiteralPath $ledgerDir -ErrorAction SilentlyContinue
if ($ledgerResolved) { $allowed = @($ledgerResolved.Path, $ledgerDir) }

$blueprintFiles = @(Get-ChildItem -LiteralPath $workspace -Filter 'IMPLEMENTATION-*.md' -File -ErrorAction SilentlyContinue)

$idInCitationPattern = '(?i)(\[|#|\bDECISIONS-|\bIMPLEMENTATION-)[^\n]{0,80}\b[DT]\d{3}'
$decisionsFilenamePattern = 'DECISIONS-[\w.-]+\.md'
$bareIdPattern = '\b(?:D|T)\d{3}\b'

$hits = @()

function Test-AllowedPath([string]$path) {
  $full = (Get-Item -LiteralPath $path).FullName
  foreach ($a in $allowed) {
    if ($a -and $full.StartsWith($a, [System.StringComparison]::OrdinalIgnoreCase)) { return $true }
  }
  foreach ($b in $script:blueprintFiles) {
    if ($b.FullName -ieq $full) { return $true }
  }
  return $false
}

# Scan all text files in the workspace (excluding .git/ and whitelisted artifacts)
$xargsFiles = Get-ChildItem -LiteralPath $workspace -Recurse -File -ErrorAction SilentlyContinue |
  Where-Object {
    $rel = $_.FullName
    -not ($rel -like "$workspace\.git*") -and
    -not (Test-AllowedPath $rel)
  }

foreach ($file in $xargsFiles) {
  if ($file.Length -gt 5MB) { continue }
  $isBinary = $false
  try {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)[0..([Math]::Min(511, [Math]::Max(0, $file.Length - 1)))]
    $isBinary = ($bytes -contains 0)
  } catch { $isBinary = $false }
  if ($isBinary) { continue }

  $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
  if (-not $content) { continue }

  foreach ($pat in @($idInCitationPattern, $decisionsFilenamePattern)) {
    $m = [regex]::Matches($content, $pat)
    foreach ($match in $m) {
      $hits += "LEAK: $($file.FullName): '$($match.Value.Trim())'"
    }
  }
}

# Scan commit messages for citation patterns
if (Test-Path -LiteralPath (Join-Path $workspace '.git')) {
  $pushd = Get-Location
  try {
    Set-Location -LiteralPath $workspace
    $log = & git log --all --format='%H %s%n%b' 2>$null
    if ($LASTEXITCODE -eq 0 -and $log) {
      foreach ($pattern in @($idInCitationPattern, $decisionsFilenamePattern)) {
        foreach ($line in $log) {
          $m = [regex]::Matches($line, $pattern)
          foreach ($match in $m) {
            $hits += "LEAK: git-commit-message: '$($match.Value.Trim())'"
          }
        }
      }
    }
  } finally {
    Set-Location $pushd
  }
}

if ($hits.Count -gt 0) {
  Write-Output ("FAIL: {0} leaked citation reference(s) found outside the Decision Ledger and Implementation Blueprint:" -f $hits.Count)
  $hits | Select-Object -First 40 | ForEach-Object { Write-Output $_ }
  exit 1
}

Write-Output 'PASS: no Dxxx/Txxx or DECISIONS-*.md references found outside the Decision Ledger and the Implementation Blueprint'
exit 0
