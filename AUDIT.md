# Security Audit

This document defines the safety contract for every skill in this repo
and how to verify it.

## Safety contract

Every skill in this repo MUST satisfy all of the following:

1. **No network calls.** Skills are plain Markdown. They must not contain
   `curl`, `wget`, `fetch`, `nc`, `ssh`, `scp`, or any other command that
   reaches a remote host.
2. **No executable code.** No `exec`, `eval`, `child_process`, `execSync`,
   `spawnSync`, or base64-encoded payloads. Bash snippets inside Markdown
   are allowed only as **examples the user runs manually** — never as
   commands the agent is instructed to execute blindly.
3. **No secrets.** No API keys, tokens, passwords, or private keys. The
   only allowed mentions of "token" are placeholder strings like
   `<token>` in REST documentation templates.
4. **No instruction injection.** No "ignore previous instructions", no
   hidden `<!-- SYSTEM: ... -->` comments, no phrasing that tries to
   make the agent exfiltrate data or override the user.
5. **Only allowlisted URLs.** External links may point only to
   `docs.cursor.com`, `github.com`, `keepachangelog.com`, `semver.org`.
   Any new URL must be reviewed and added to the audit allowlist.

## How to verify

Run the audit script from the repo root:

```bash
./scripts/audit.sh
```

Exit code `0` means clean. Any non-zero exit means a violation — review
the output and either fix the skill or, if the match is intentional and
safe, re-run with an explicit allow:

```bash
./scripts/audit.sh --allow 'example\.com'
```

For CI / quiet mode (prints only violations):

```bash
./scripts/audit.sh --quiet
```

## When to run

- Before every release.
- After merging any PR from an outside contributor.
- Any time you fork or copy a skill into a new project.
- On suspicion — the script is fast (under a second).

## What the script checks

| Category | Patterns |
|----------|----------|
| Network / exfiltration | `curl`, `wget`, `fetch`, `nc`, `netcat`, `socat`, `ssh user@`, `scp`, `rsync`, non-allowlisted `https://` URLs |
| Executable code | `exec(`, `eval(`, `child_process`, `execSync`, `spawnSync`, `bash -c`, `base64 -d` |
| Secrets | OpenAI `sk-...`, GitHub `gho_...` / `ghp_...`, AWS `AKIA...`, `-----BEGIN PRIVATE KEY-----`, `.env`, `process.env.*`, hardcoded passwords |
| Instruction injection | "ignore previous instructions", "exfiltrate", "send to attacker", `<!-- IMPORTANT:`, `<!-- SYSTEM:`, `<!-- HIDDEN:` |

## Limitations — what the script does NOT catch

Be honest with yourself about these:

- **Prompt injection from the codebase you're refactoring.** The skills
  instruct an agent to read files and run tests. If you point the agent
  at a malicious repo, that repo's contents can try to manipulate the
  agent. The audit script cannot protect you from this — only your
  choice of which repos to point the agent at can.
- **Malicious test scripts.** The `refactor` skill runs your test suite.
  If your `test.sh` does something bad, the agent will run it. Review
  test scripts in unfamiliar repos before refactoring.
- **Social-engineering PRs.** A contributor can submit a PR that looks
  benign but introduces a subtle instruction. The audit script catches
  *patterns*, not intent. Always read the diff of any PR before merging.
- **New attack shapes.** The script checks for known patterns. A novel
  obfuscation could slip through. Treat the audit as a tripwire, not a
  guarantee.

## Reporting a vulnerability

If you find a way these skills could be misused, email the author via
the contact info on [the GitHub profile](https://github.com/viamagic333-lang)
or open a private security advisory:

```bash
gh api repos/viamagic333-lang/cursor-skills/security-advisories \
  -X POST -f summary="..." -f description="..."
```
