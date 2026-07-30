# FMSI — Reference

Detailed search strategies per source. Use when the quick workflow in
`SKILL.md` isn't enough.

## Table of contents

- [Past agent chats](#past-agent-chats)
- [Projects on disk](#projects-on-disk)
- [Git history](#git-history)
- [Existing skills](#existing-skills)
- [Scoring rubric](#scoring-rubric)
- [Edge cases](#edge-cases)
- [Performance tips](#performance-tips)

---

## Past agent chats

Chats live as JSONL at `~/.cursor/projects/*/agent-transcripts/*.jsonl`.
Each line is one message. Files can be large; never read them whole.

### Find relevant chats

```bash
# List chats modified in last 90 days, by date.
find ~/.cursor/projects/*/agent-transcripts -name "*.jsonl" \
  -mtime -90 -printf "%T+ %p\n" 2>/dev/null | sort -r | head -30
```

### Search by keyword

```bash
# File-level match: which chats mention the keyword anywhere.
rg -l --max-filesize 2M -i "<keyword>" \
  ~/.cursor/projects/*/agent-transcripts/*.jsonl 2>/dev/null

# Line-level: see the actual matching messages (truncate long lines).
rg -i --max-filesize 2M -o "<keyword>.{0,120}" \
  ~/.cursor/projects/*/agent-transcripts/*.jsonl 2>/dev/null | head -20
```

### Sample a chat without reading it whole

```bash
# First user message (usually the task description).
head -3 "<chat-file>.jsonl"

# Last assistant message (what was actually delivered).
tail -3 "<chat-file>.jsonl"
```

### What to extract

- The first user message — what the user asked for.
- The last assistant message — what was actually produced.
- File modification time — when.

### Limit

- Skip files > 2 MB (likely binary dumps, base64, or huge logs).
- Sample at most 5 chats in detail; if none are relevant, move on.

## Projects on disk

### Heuristic: what counts as a "project"

A folder is a project if it contains any of:
- `.git/`
- `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`
- `*.xcodeproj`, `*.xcworkspace`
- `README.md` AND at least one source file

### Find project folders

```bash
# Top-level folders in common work locations.
ls -d ~/Desktop/*/ ~/Documents/*/ ~/Projects/*/ 2>/dev/null

# Folders matching a keyword in the name.
ls -d ~/*/*<keyword>* 2>/dev/null

# Folders that are git repos.
find ~/Desktop ~/Documents ~/Projects -maxdepth 3 -name ".git" \
  -type d 2>/dev/null | sed 's|/.git||'
```

### Peek inside a candidate

```bash
# README first line (project description).
head -1 "<project>/README.md" 2>/dev/null

# Package name + description from package.json.
rg '"(name|description)"' "<project>/package.json" 2>/dev/null

# Top-level file names (often reveal the project type).
ls "<project>" 2>/dev/null | head -20
```

### What to extract

- Folder name (often the project name).
- README first paragraph.
- Tech stack from manifest files.
- Last modified date.

## Git history

### Find repos to search

```bash
find ~/Desktop ~/Documents ~/Projects -maxdepth 3 -name ".git" \
  -type d 2>/dev/null | sed 's|/.git||'
```

### Search commit messages

```bash
# Inside a repo: commits matching keyword.
git -C "<repo>" log --all --oneline --since="12 months ago" \
  -E --grep="<keyword1>|<keyword2>" -i | head -20

# Branch names matching keyword.
git -C "<repo>" branch -a | rg -i "<keyword>"

# Recent commits regardless of keyword (gives a sense of activity).
git -C "<repo>" log --all --oneline -10
```

### Across many repos at once

```bash
for repo in $(find ~/Desktop ~/Documents -maxdepth 3 -name ".git" -type d \
  2>/dev/null | sed 's|/.git||'); do
  hits=$(git -C "$repo" log --all --oneline --since="12 months ago" \
    -E --grep="<keyword>" -i 2>/dev/null | head -5)
  [ -n "$hits" ] && echo "=== $repo ===" && echo "$hits"
done
```

### What to extract

- Commit hash + message.
- Branch name.
- Date.
- Repo path.

## Existing skills

### Search skill descriptions and bodies

```bash
# Personal skills.
rg -l -i "<keyword>" ~/.cursor/skills/*/SKILL.md 2>/dev/null

# Portfolio repo skills.
rg -l -i "<keyword>" "/Users/magic/Desktop/My Skils"/*/SKILL.md 2>/dev/null
```

### What to extract

- Skill name (from frontmatter).
- One-line description.
- Path.

## Scoring rubric

For each find, compute a 4-dimensional overlap with the current task:

| Dimension | Example |
|-----------|---------|
| Verb | "refactor", "build", "scrape", "deploy" |
| Domain | "payments", "users", "videos", "docs" |
| Tech | "typescript", "python", "react", "supabase" |
| Artifact | "script", "skill", "API", "README", "video" |

- 4/4 overlap → `exact` → "делал"
- 2–3/4 overlap → `similar` → "делал похоже"
- 1/4 overlap → `tangential` → ignored unless nothing else found
- 0/4 → drop

Confidence:
- `high` — exact match, recent (< 3 months), clear reference.
- `medium` — similar match, or exact but old (> 6 months).
- `low` — tangential only, or evidence is thin.

## Edge cases

### Task is very generic
"Build a website" — too generic. Ask the user for one specific detail
(domain, tech, or feature) before searching, otherwise everything
matches.

### No sources exist yet
If `~/.cursor/projects/*/agent-transcripts` is empty, no `~/Desktop`
projects, no git repos — return "не делал" with confidence "низкая"
and explain that no history was found.

### Conflicting evidence
One source says "делал" (exact), another says "не делал" — trust the
exact match but note the conflict in one line.

### Huge number of hits
If a keyword appears in 50+ chats, narrow by adding a second keyword
or filtering by date (`-mtime -30`). Never dump 50 hits to the user.

### User asks about a specific past task
If the user says "я делал X раньше?" — search for X specifically, not
for the current task. The signature is X, not the current request.

## Performance tips

- Use `rg -l` first (file list), then `rg` (content) only on hits.
- Always pass `--max-filesize 2M` on chat files.
- Limit `find` with `-maxdepth 3` to avoid scanning the whole disk.
- Run the four source searches in parallel when possible.
- Cache nothing — the user's disk changes between invocations.
- Total time budget: ~10 seconds. If slower, narrow the keywords.
