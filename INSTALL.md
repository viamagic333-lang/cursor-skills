# Installation Guide

These skills are plain Markdown files (`SKILL.md`). They work in any agent that loads skills from a directory. Below are per-tool setup instructions.

## Cursor

### Option A — Personal (recommended for solo use)

Available in every project on your machine.

```bash
git clone https://github.com/<you>/my-cursor-skills.git ~/my-cursor-skills

mkdir -p ~/.cursor/skills
ln -s ~/my-cursor-skills/docs-generator ~/.cursor/skills/docs-generator
ln -s ~/my-cursor-skills/refactor         ~/.cursor/skills/refactor
```

Restart Cursor. Done.

### Option B — Project (shared with collaborators)

Lives inside the repo so anyone who clones it gets the skills.

```bash
cd /path/to/your/repo
mkdir -p .cursor/skills
cp -R ~/my-cursor-skills/docs-generator .cursor/skills/
cp -R ~/my-cursor-skills/refactor        .cursor/skills/
git add .cursor/skills
git commit -m "chore: add agent skills"
```

> **Note:** never create skills in `~/.cursor/skills-cursor/` — that directory is reserved for Cursor's built-in skills.

## VS Code (Claude extension / Continue / similar)

Most agent extensions expose a "skills", "instructions", or "rules" directory in settings. Point it at this repo, or copy the `SKILL.md` files into that directory.

Example for a Claude-style extension:

```bash
# Find your extension's skills directory, e.g.
mkdir -p ~/.claude/skills
cp -R ~/my-cursor-skills/docs-generator ~/.claude/skills/
cp -R ~/my-cursor-skills/refactor        ~/.claude/skills/
```

## Claude Desktop (MCP / agent skills)

If your setup loads agent skills from a folder, drop the skill directories there:

```bash
# Replace the path with your agent's configured skills folder
cp -R ~/my-cursor-skills/docs-generator <agent-skills-dir>/
cp -R ~/my-cursor-skills/refactor        <agent-skills-dir>/
```

## Verify it works

After installing into any tool, start a new agent session and ask:

> "Refactor the largest function in this file — extract the validation logic."

or

> "Generate JSDoc for `src/index.ts`."

The matching skill should activate automatically based on its `description` trigger terms.

## Updating

```bash
cd ~/my-cursor-skills
git pull
```

Symlinks pick up changes automatically. For copies, re-run the `cp -R` step.

## Uninstall

```bash
rm ~/.cursor/skills/docs-generator
rm ~/.cursor/skills/refactor
# or remove the copied folders from .cursor/skills/ for project installs
```
