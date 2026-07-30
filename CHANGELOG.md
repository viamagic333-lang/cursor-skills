# Changelog

All notable changes to this collection of Cursor Agent Skills.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-07-30

### Added
- `templates/` folder with reusable starters:
  - `skill-template/` — blank skill (SKILL.md + reference.md + examples.md)
  - `script-template.sh` — blank bash script with arg parsing, help, logging
  - `README.md` — usage instructions for both templates
- README updated with templates section and updated repo layout.

## [0.3.0] - 2026-07-30

### Added
- `design-hunt` skill: hunts advanced web design templates across 8
  reference sites — awwwards.com, dribbble.com, behance.net,
  templatemonster.com, themeforest.net, framer.com/templates,
  tailwindui.com, ui.shadcn.com — using the Playwright MCP browser.
- Four modes: `inspiration` (browse trends), `extract` (pull
  components/CSS), `screenshots` (save references to
  `~/Desktop/design-references/<site>/<date>/`), `replicate` (rebuild
  a seen design in the user's stack).
- Auto-activates on "find design for X", "найди шаблон для Y",
  "вытащи компонент с сайта", "реплицируй дизайн", or `/design-hunt`.
- `reference.md` for `design-hunt`: per-site navigation tips, search
  syntax, extraction JS snippets, viewport sizes, file naming, and
  legal/ethical notes (paid vs open-source, inspired-by vs copy).

## [0.2.0] - 2026-07-30

### Added
- `fmsi` skill ("Find My Similar Ink"): checks whether the user has done
  similar work before, across four sources — past agent chats
  (`~/.cursor/projects/*/agent-transcripts/*.jsonl`), projects on disk
  (`~/Desktop`, `~/Documents`, `~/Projects`), git history, and existing
  skills. Returns a verdict: делал / делал похоже / не делал, with
  confidence and concrete references.
- Auto-activates on new task descriptions; also invokable via `/FMSI`.
- `reference.md` for `fmsi`: detailed search strategies per source,
  scoring rubric, edge cases, performance tips.

## [0.1.0] - 2026-07-30

### Added
- `docs-generator` skill: README sections, API references, JSDoc/TSDoc,
  Google-style and NumPy-style docstrings, REST endpoint references,
  CLI command references, architecture overviews, and changelog entries —
  all generated from the actual codebase with symbol verification.
- `refactor` skill: behavior-preserving refactors (extract, inline, rename,
  consolidate, replace conditional with dispatch/polymorphism, modernize
  syntax, guard clauses) with a strict test-gated workflow.
- `reference.md` for each skill: full format templates and refactor catalog.
- `examples.md` for each skill: before/after pairs with verification
  discipline called out, plus anti-examples.
- `README.md` with portfolio overview and install instructions.
- `INSTALL.md` with per-tool setup (Cursor, VS Code, Claude Desktop, other
  agents).
- `LICENSE` (MIT).
- `.gitignore`.

[Unreleased]: https://github.com/viamagic333-lang/cursor-skills/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/viamagic333-lang/cursor-skills/releases/tag/v0.4.0
[0.3.0]: https://github.com/viamagic333-lang/cursor-skills/releases/tag/v0.3.0
[0.2.0]: https://github.com/viamagic333-lang/cursor-skills/releases/tag/v0.2.0
[0.1.0]: https://github.com/viamagic333-lang/cursor-skills/releases/tag/v0.1.0
