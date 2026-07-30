#!/usr/bin/env bash
# audit.sh — verify that no skill in this repo contains network calls,
# executable code, or secrets that could harm the user or exfiltrate data.
#
# Run before publishing, after every PR merge, or any time you want to
# confirm the skills still match the safety contract documented in AUDIT.md.
#
# Usage:
#   ./scripts/audit.sh                 # check everything, exit 1 on violation
#   ./scripts/audit.sh --quiet          # only print violations
#   ./scripts/audit.sh --allow <file>   # permit a specific URL/pattern (one per call)
#
# Exit codes:
#   0 — clean
#   1 — one or more violations found
#   2 — script itself failed (missing deps, wrong dir, etc.)

set -euo pipefail

QUIET=0
ALLOW_PATTERNS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet) QUIET=1; shift ;;
    --allow) ALLOW_PATTERNS+=("$2"); shift 2 ;;
    -h|--help)
      sed -n '2,15p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

# Locate repo root (directory containing this script's parent).
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$ROOT"

if ! command -v rg >/dev/null 2>&1; then
  echo "error: ripgrep (rg) is required. brew install ripgrep" >&2
  exit 2
fi

# Only scan skill content files. Skip .git, this script, and supporting docs.
scan_paths=(
  "$SKILLS_DIR/docs-generator"
  "$SKILLS_DIR/refactor"
)
for d in "${scan_paths[@]}"; do
  [ -d "$d" ] || { echo "error: missing $d" >&2; exit 2; }
done

violations=0
section() {
  [ "$QUIET" -eq 1 ] && return
  echo
  echo "## $1"
}

check() {
  local label="$1" pattern="$2"
  local hits
  hits="$(rg -n --no-heading "$pattern" "${scan_paths[@]}" 2>/dev/null || true)"
  if [ -n "$hits" ]; then
    # Filter out allowlisted patterns.
    for allow in "${ALLOW_PATTERNS[@]+"${ALLOW_PATTERNS[@]}"}"; do
      hits="$(printf '%s\n' "$hits" | rg -v "$allow" || true)"
    done
    if [ -n "$hits" ]; then
      echo "FAIL: $label"
      printf '%s\n' "$hits"
      violations=$((violations + 1))
    else
      [ "$QUIET" -eq 0 ] && echo "ok: $label (all matches allowlisted)"
    fi
  else
    [ "$QUIET" -eq 0 ] && echo "ok: $label"
  fi
}

section "Network / data exfiltration"
check "curl/wget/fetch calls"        '(curl|wget|fetch)\s+https?://'
check "raw http(s) URLs to non-doc hosts" 'https?://(?!docs\.cursor\.com|github\.com|keepachangelog\.com|semver\.org)[a-z0-9.-]+'
check "nc / netcat / socat"          '\b(nc|netcat|socat)\b'
check "ssh / scp / rsync to host"    '\b(ssh|scp|rsync)\s+[a-z_][a-z0-9_]*@'

section "Executable code inside skills"
check "python exec"                  '\bexec\s*\(|\beval\s*\('
check "node child_process"           'child_process|execSync|spawnSync'
check "bash heredoc that runs"       'bash\s*-c\s'
check "base64-encoded payloads"      'base64\s+-d|base64\s--decode'

section "Secrets / credentials"
check "high-entropy API keys (sk-/gho_/ghp_/AKIA)" '(sk-[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{36}|ghp_[A-Za-z0-9]{36}|AKIA[A-Z0-9]{16})'
check "private key blocks"           '-----BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----'
check "env file references"          '\.env\b|process\.env\.[A-Z_]+|os\.environ\[['"'"'"][A-Z_]+'
check "hardcoded passwords"          'password\s*[:=]\s*['"'"'"][^'"'"'"]{4,}'

section "Suspicious instruction injection"
check "ignore previous instructions" '(?i)ignore (all )?(previous|prior) instructions'
check "exfiltrate / send to attacker" '(?i)exfiltrate|send (home|to attacker)|upload to'
check "hidden instruction comments"  '(?i)<!--\s*(IMPORTANT|SYSTEM|HIDDEN):'

section "Result"
if [ "$violations" -eq 0 ]; then
  [ "$QUIET" -eq 0 ] && echo "clean: no violations"
  exit 0
else
  echo
  echo "VIOLATIONS: $violations"
  echo "Review the matches above. If any are intentional, re-run with --allow '<regex>'."
  exit 1
fi
