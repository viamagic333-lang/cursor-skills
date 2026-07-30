# My Cursor Agent Skills

Personal collection of [Cursor Agent Skills](https://docs.cursor.com) — portable, framework-agnostic, and usable anywhere that supports the `SKILL.md` convention (Cursor, VS Code + Claude, Claude Desktop, and other MCP/agent clients).

## Skills

| Skill | What it does |
|------|--------------|
| [`docs-generator`](docs-generator/SKILL.md) | Generates README sections, API references, JSDoc/docstrings, and architecture overviews from the actual codebase — and keeps them in sync. |
| [`refactor`](refactor/SKILL.md) | Behavior-preserving refactors: extract, rename, simplify, deduplicate. Test-gated and small-stepped. |

## Install

### Cursor (personal — all your projects)

```bash
# Clone anywhere
git clone https://github.com/<you>/my-cursor-skills.git ~/my-cursor-skills

# Symlink each skill into ~/.cursor/skills/
ln -s ~/my-cursor-skills/docs-generator ~/.cursor/skills/docs-generator
ln -s ~/my-cursor-skills/refactor         ~/.cursor/skills/refactor
```

Restart Cursor. The skills are now available across every project.

### Cursor (project — shared with the team)

Copy the skill folders into `.cursor/skills/` inside your repo:

```bash
cd /path/to/repo
mkdir -p .cursor/skills
cp -R ~/my-cursor-skills/docs-generator .cursor/skills/
cp -R ~/my-cursor-skills/refactor        .cursor/skills/
git add .cursor/skills && git commit -m "chore: add agent skills"
```

Anyone who clones the repo gets the skills automatically.

### VS Code + Claude / Claude Desktop / other agents

These skills are plain Markdown. Any agent that reads a `SKILL.md` (or system prompt instructions) can use them. Point your agent's skills directory at this repo, or copy the `SKILL.md` files into your tool's configured skills folder.

See [`INSTALL.md`](INSTALL.md) for per-tool setup details.

## Using a skill

In any agent session, just say what you want — the description's trigger terms will surface the skill:

- "Refactor `parseConfig` — extract the validation block."
- "Generate API docs for the `users` module."
- "Add JSDoc to `src/auth.ts`."

Or invoke explicitly: `/docs-generator`, `/refactor`.

## Authoring your own

See [Cursor's skill authoring guide](https://docs.cursor.com). Each skill is a folder with a `SKILL.md` containing YAML frontmatter (`name`, `description`) and a markdown body. Keep the body under ~500 lines and prefer progressive disclosure (link to `reference.md` / `examples.md`).

## License

MIT — see [`LICENSE`](LICENSE).
