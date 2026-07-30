---
name: docs-generator
description: >-
  Generate and keep documentation in sync with source code. Produces
  README sections, API references, JSDoc/docstrings, and architecture
  overviews directly from the codebase. Use when the user asks to
  "document this code", "generate API docs", "write a README", "add
  docstrings", "describe the module", or when new code lands without
  docs. Also use proactively after non-trivial public API changes.
---

# Docs Generator

Generate accurate, low-drift documentation by reading the code, not by guessing.

## Core principles

1. **Read before writing.** Open the actual files (types, signatures, call sites) before producing any prose. Never document from memory.
2. **Match existing style.** If the repo already has JSDoc, Google-style pydoc, or TSDoc — follow that exact format. If unsure, ask.
3. **One source of truth.** Prefer extracting from code comments + signatures. Avoid restating behavior that the code already expresses; explain *why*, not *what*.
4. **No hallucinated examples.** Every code example must compile against the current codebase. If you can't verify, mark it `<!-- unverified -->` and tell the user.
5. **Keep it in sync.** When the user edits code, offer to update the related docs. When the user edits docs, check that the referenced symbols still exist.

## Workflow

1. **Scope.** Ask (or infer) what to document: a single function, a module, a package, or the whole repo.
2. **Inventory.** List the public surface: exported symbols, public classes, HTTP routes, CLI commands, config keys. Use `Grep`/`Glob`, not memory.
3. **Read.** Open each relevant file. Note signatures, types, defaults, side effects, and existing comments.
4. **Draft.** Produce docs in the format the user asked for (see Formats below). Keep prose tight; let signatures carry detail.
5. **Verify.** Re-check every symbol name, parameter, and path against the source. Fix any mismatch.
6. **Write.** Save to the agreed location. If a file exists, edit it; otherwise create it.
7. **Report.** Summarize what was generated, what was skipped, and any symbols you couldn't verify.

## Formats

### README section / file

```markdown
## `functionName(args)`

Short one-line purpose.

Why it exists or when to use it. Any non-obvious behavior, edge cases,
or performance notes.

\`\`\`ts
import { functionName } from "./module";
functionName(input, { option: true });
\`\`\`
```

### JSDoc / TSDoc

```ts
/**
 * One-line summary.
 *
 * Longer explanation when needed. Mention side effects, async behavior,
 * or throws conditions.
 *
 * @param name - What it is. Required/optional.
 * @returns What comes back, including shape and null/undefined cases.
 * @throws {ErrorName} When this can happen.
 */
```

### Python docstring (Google style)

```python
def fn(name, *, strict=False):
    """One-line summary.

    Optional longer description.

    Args:
        name: Description.
        strict: Description. Defaults to False.

    Returns:
        Description of return value.

    Raises:
        ValueError: When ...
    """
```

### API reference (REST)

For each endpoint: method, path, auth requirement, request body schema, response schema, example request/response, error codes.

### Architecture overview

Module map (one sentence each), data flow, key invariants, where to look for X.

## Anti-patterns

- Restating the implementation line-by-line.
- Documenting private helpers unless asked.
- Examples that import symbols that don't exist or aren't exported.
- "See documentation" links that point nowhere.
- Generating docs for code you haven't actually opened in this session.

## Verification checklist

Before finishing, confirm:

- [ ] Every documented symbol exists in the current source.
- [ ] Parameter names, types, and defaults match the source.
- [ ] Examples use real import paths and valid signatures.
- [ ] No documented behavior contradicts the code.
- [ ] Style matches existing docs in the repo.
