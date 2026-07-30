# Templates

Reusable starter templates for new skills and scripts.

## What's here

| Template | Use |
|----------|-----|
| [`skill-template/`](skill-template/SKILL.md) | Blank skill with `SKILL.md`, `reference.md`, `examples.md` — copy this folder to start a new skill. |
| [`script-template.sh`](script-template.sh) | Blank bash script with arg parsing, help, dependency check, logging — copy to start a new script. |

## How to create a new skill from the template

```bash
cd ~/Desktop/My\ Skils

# Copy the template
cp -R templates/skill-template my-new-skill

# Edit the files
# - my-new-skill/SKILL.md       — name, description, workflow
# - my-new-skill/reference.md   — detailed reference
# - my-new-skill/examples.md    — before/after examples

# Install to personal skills
cp -R my-new-skill ~/.cursor/skills/

# Commit and push
git add -A
git commit -m "feat(my-new-skill): <what it does>"
git push
```

## How to create a new script from the template

```bash
cd ~/Desktop

# Copy the template
cp ~/Desktop/My\ Skils/templates/script-template.sh myscript.sh

# Make it executable
chmod +x myscript.sh

# Edit it
# - Replace the logic section with your own
# - Update the help text in the header

# Run it
./myscript.sh --name Viacheslav
./myscript.sh --help
```

## Conventions

### Skill naming

- lowercase, hyphens, max 64 chars: `my-skill-name`
- description: third person, includes WHAT and WHEN
- body: under 500 lines, progressive disclosure (link to reference.md)

### Script naming

- lowercase, hyphens, `.sh` extension: `my-script.sh`
- always `#!/usr/bin/env bash` as first line
- always `set -euo pipefail` after the header
- support `--help` / `-h`
- exit codes: `0` success, `1` runtime error, `2` usage error

### Audit

After creating a new skill, run the audit script to verify it's clean:

```bash
cd ~/Desktop/My\ Skils
./scripts/audit.sh
```

The script auto-discovers all skill folders in the repo, so new skills
are checked automatically.

## See also

- [../README.md](../README.md) — main repo README
- [../AUDIT.md](../AUDIT.md) — safety contract
- [../scripts/audit.sh](../scripts/audit.sh) — audit script
