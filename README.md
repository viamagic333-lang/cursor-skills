# Cursor Agent Skills — Portfolio

A curated collection of [Cursor Agent Skills](https://docs.cursor.com) I use across every project — portable, framework-agnostic, and designed to make AI-assisted development *safer* rather than just *faster*.

> These skills encode how I think about code: behavior-preserving changes, docs that don't drift, and tests as the gate — not the afterthought. They're published here so clients and collaborators can see the engineering standards I bring to a codebase.

## What's inside

| Skill | Purpose | Why it matters |
|------|---------|----------------|
| [`docs-generator`](docs-generator/SKILL.md) | Generates README sections, API references, JSDoc/docstrings, and architecture overviews **from the actual codebase** — and keeps them in sync. | Docs that hallucinate are worse than no docs. This skill reads before writing and verifies every symbol exists. |
| [`refactor`](refactor/SKILL.md) | Behavior-preserving refactors: extract, rename, simplify, deduplicate. Test-gated, small-stepped, no drive-by edits. | A refactor that changes behavior is a bug. This skill treats tests as the contract and refuses to bundle concerns. |
| [`fmsi`](fmsi/SKILL.md) | "Find My Similar Ink" — checks whether the user has done similar work before, across past agent chats, projects on disk, git history, and existing skills. Returns a verdict: делал / делал похоже / не делал. | Before starting a new task, know what you've already done. Saves time, prevents duplicate work, surfaces prior solutions. |

Each skill ships with:
- `SKILL.md` — the agent-facing instructions (under 500 lines, progressive disclosure)
- `reference.md` — detailed format templates / refactor catalog
- `examples.md` — before/after pairs with the verification discipline called out

## Engineering principles these skills enforce

- **Read before write.** Never document or refactor from memory. Open the file.
- **Behavior is the contract.** A refactor is only a refactor if tests stay green.
- **No mixed concerns.** A `refactor:` commit never silently fixes a bug.
- **Verify, don't trust.** Every documented symbol is checked against the source. Every renamed symbol is searched repo-wide.
- **Small steps.** Each change is reviewable on its own. No 5-in-1 diffs.

## Install

### Cursor (personal — all your projects)

```bash
git clone https://github.com/viamagic333-lang/cursor-skills.git ~/cursor-skills

ln -s ~/cursor-skills/docs-generator ~/.cursor/skills/docs-generator
ln -s ~/cursor-skills/refactor         ~/.cursor/skills/refactor
ln -s ~/cursor-skills/fmsi             ~/.cursor/skills/fmsi
```

Restart Cursor. The skills are now available across every project.

### Cursor (project — shared with the team)

```bash
cd /path/to/repo
mkdir -p .cursor/skills
cp -R ~/cursor-skills/docs-generator .cursor/skills/
cp -R ~/cursor-skills/refactor        .cursor/skills/
cp -R ~/cursor-skills/fmsi            .cursor/skills/
git add .cursor/skills && git commit -m "chore: add agent skills"
```

Anyone who clones the repo gets the skills automatically.

### VS Code / Claude Desktop / other agents

These skills are plain Markdown. Any agent that loads a `SKILL.md` can use them. See [`INSTALL.md`](INSTALL.md) for per-tool setup.

## Using a skill

In any agent session, just describe the task — the description's trigger terms will surface the skill:

- "Refactor `parseConfig` — extract the validation block."
- "Generate API docs for the `users` module."
- "Add JSDoc to `src/auth.ts`."
- "/FMSI — did I do something like this before?"

Or invoke explicitly: `/docs-generator`, `/refactor`, `/fmsi`.

## Repository layout

```
.
├── README.md
├── INSTALL.md
├── AUDIT.md
├── CHANGELOG.md
├── LICENSE
├── scripts/
│   └── audit.sh
├── docs-generator/
│   ├── SKILL.md
│   ├── reference.md
│   └── examples.md
├── refactor/
│   ├── SKILL.md
│   ├── reference.md
│   └── examples.md
└── fmsi/
    ├── SKILL.md
    └── reference.md
```

## License

MIT — see [`LICENSE`](LICENSE). Use them, fork them, ship them.

## Author

Built and maintained by [@viamagic333-lang](https://github.com/viamagic333-lang).

If you're considering working with me, this repo is a small but honest sample of how I approach engineering: small, verifiable, behavior-preserving changes — and tooling that makes that the default rather than the exception.
