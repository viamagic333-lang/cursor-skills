---
name: fmsi
description: >-
  Check whether the user has done similar work before — across past agent
  chats, projects on disk, git history, and existing skills — and return
  a verdict: "делал" (done), "делал похоже" (similar), or "не делал"
  (never). Use automatically when a new task, request, or project is
  described, before starting work. Also use when the user invokes /FMSI
  explicitly, says "я делал это раньше?", "проверь делал ли я такое",
  "FMSI", or asks whether something has been done before.
---

# FMSI — Find My Similar Ink

Before starting any new task, check whether the user has already done
similar work. Return a verdict so the user can decide: reuse, reference,
or start fresh.

## When to activate

Activate automatically when the user describes a new task, project, or
request — *before* doing the work. Also activate on explicit `/FMSI`,
"я делал это раньше?", "проверь делал ли я такое", or any question
about prior work.

Do **not** activate for: trivial questions, pure conversation, or
clarifications about the current task that don't introduce new scope.

## The four sources

Search all four, in this order. Stop early if you find an exact match.

1. **Past agent chats** — `~/.cursor/projects/*/agent-transcripts/*.jsonl`
2. **Projects on disk** — `~/Desktop`, `~/Documents`, `~/Projects`
3. **Git history** — commit messages and branch names in known repos
4. **Existing skills** — `~/.cursor/skills/*/SKILL.md` and the
   `cursor-skills` repo

## Workflow

### 1. Extract the task signature

From the user's request, pull:
- **Verbs** — what action (refactor, build, generate, deploy, scrape…)
- **Nouns/domains** — what subject (users, payments, videos, docs…)
- **Tech** — languages, frameworks, tools mentioned
- **Artifact** — what's produced (script, skill, README, API, video…)

Keep the signature to ~5–10 keywords. Discard filler.

### 2. Search past agent chats

```bash
# Find chat files modified in the last 90 days that mention any keyword.
rg -l --max-filesize 2M -i "<keyword1>|<keyword2>" \
  ~/.cursor/projects/*/agent-transcripts/*.jsonl 2>/dev/null | head -20
```

For each hit, read enough to judge relevance — usually the first user
message of the chat and the last assistant message. Skip files over
2 MB (likely binary dumps).

### 3. Search projects on disk

```bash
# Project folders (heuristic: contains .git, package.json, pyproject.toml,
# Cargo.toml, or *.xcodeproj).
ls -d ~/Desktop/*/ ~/Documents/*/ ~/Projects/*/ 2>/dev/null | head -50

# Match by folder name first.
ls -d ~/*/<*keyword*> 2>/dev/null

# Then peek at README / package metadata in candidate folders.
rg -l --max-depth 2 -i "<keyword>" ~/Desktop ~/Documents 2>/dev/null | head -20
```

### 4. Search git history

For each known repo (start with the workspace, then `~/Desktop/*`,
`~/Documents/*` if they have `.git`):

```bash
git log --all --oneline --since="12 months ago" \
  -E --grep="<keyword1>|<keyword2>" -i | head -20
git branch -a | rg -i "<keyword>"
```

### 5. Search existing skills

```bash
rg -l -i "<keyword>" ~/.cursor/skills/*/SKILL.md \
  "/Users/magic/Desktop/My Skils"/*/SKILL.md 2>/dev/null
```

### 6. Score each find

For every hit, assign:

- **Match type** — `exact` (same task + same domain), `similar` (overlap
  in 2+ of: verb, domain, tech, artifact), or `tangential` (1 overlap).
- **Confidence** — `high` / `medium` / `low`.
- **Where** — path or chat ID.
- **When** — date if available.

### 7. Return the verdict

Use this exact format (in Russian unless the user wrote in English):

```
**Вердикт: <делал | делал похоже | не делал>**

Уверенность: <высокая | средняя | низкая>

<Если "делал" или "делал похоже":>
Найдено:
- <одна строка на каждое релевантное совпадение: дата — где — кратко что это>

<Если "делал похоже": одна строка о том, чем похожая работа отличается от текущей.>

<Если "не делал": одна строка с предложением — начать с нуля, или попросить пример.>
```

Keep the verdict under 8 lines. The user can ask for details.

## Scoring rules

- **делал** — at least one `exact` match: same verb AND same domain
  (e.g., "refactor + payments" matches a past "refactor + payments").
- **делал похоже** — at least one `similar` match, no `exact`: 2+ of
  {verb, domain, tech, artifact} overlap.
- **не делал** — only `tangential` or no hits.

## Anti-patterns

- Don't search only one source and call it done — all four matter.
- Don't dump every match — only the top 3–5 most relevant.
- Don't skip the verdict line. The user wants an answer, not a list.
- Don't read entire chat files; sample the start and end.
- Don't claim "делал" without a concrete path or chat reference.

## Verification

Before returning the verdict, confirm:

- [ ] Searched all four sources, not just one.
- [ ] Every "делал" / "делал похоже" claim has a concrete reference
      (path, chat ID, commit hash, or skill name).
- [ ] Verdict line is present and uses one of the three exact words.
- [ ] Confidence is stated.
- [ ] Total response is under 8 lines unless the user asked for details.

## Additional resources

- For detailed search strategies per source and edge cases, see [reference.md](reference.md).
