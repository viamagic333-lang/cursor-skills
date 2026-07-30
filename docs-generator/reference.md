# Docs Generator — Reference

Detailed format templates the agent can fall back on. Keep this
file one level deep from `SKILL.md`.

## Table of contents

- [README — module overview](#readme--module-overview)
- [README — single function](#readme--single-function)
- [JSDoc / TSDoc — full tag set](#jsdoc--tsdoc--full-tag-set)
- [Python — Google-style docstring](#python--google-style-docstring)
- [Python — NumPy-style docstring](#python--numpy-style-docstring)
- [REST API — endpoint reference](#rest-api--endpoint-reference)
- [CLI — command reference](#cli--command-reference)
- [Architecture overview](#architecture-overview)
- [Changelog entry](#changelog-entry)
- [Verification snippet](#verification-snippet)

---

## README — module overview

```markdown
## `moduleName`

One-sentence purpose.

### Public API

- `fnA(input)` — short description.
- `fnB(opts)` — short description.

### Usage

\`\`\`ts
import { fnA } from "moduleName";
const result = fnA(input);
\`\`\`

### Notes

- Any non-obvious behavior, side effects, or performance characteristics.
- Links to deeper docs if applicable.
```

## README — single function

```markdown
### `functionName(arg1, arg2, opts?)`

One-line summary.

Longer paragraph: why this exists, when to use it, edge cases.

**Params**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `arg1` | `string` | — | Required. |
| `opts.strict` | `boolean` | `false` | Throw on invalid input. |

**Returns** `Promise<Result>` — description.

**Throws** `ValidationError` when `strict` is true and `arg1` is empty.

**Example**

\`\`\`ts
await functionName("x", 1, { strict: true });
\`\`\`
```

## JSDoc / TSDoc — full tag set

```ts
/**
 * One-line summary (imperative, end with period).
 *
 * Optional longer description. Mention side effects, async behavior,
 * or anything callers must know.
 *
 * @param name - Description. State required/optional and shape.
 * @param opts.strict - Nested option description.
 * @returns Description of the resolved value, including null/undefined cases.
 * @throws {ErrorType} When this can be raised.
 * @see {@link otherFn} for related behavior.
 * @example
 *
 * ```ts
 * fn("x", { strict: true });
 * ```
 */
```

Use `@template` for generics, `@deprecated` with a replacement, `@internal`
for non-public helpers, `@yields` for generators.

## Python — Google-style docstring

```python
def fn(name: str, *, strict: bool = False) -> Result:
    """One-line summary.

    Optional longer description.

    Args:
        name: Description.
        strict: Description. Defaults to False.

    Returns:
        Description of the return value, including shape.

    Raises:
        ValueError: When ...
    """
```

## Python — NumPy-style docstring

```python
def fn(name, *, strict=False):
    """One-line summary.

    Extended description.

    Parameters
    ----------
    name : str
        Description.
    strict : bool, optional
        Description. Default is False.

    Returns
    -------
    Result
        Description.

    Raises
    ------
    ValueError
        When ...
    """
```

## REST API — endpoint reference

```markdown
### POST /v1/users

Create a user.

**Auth** `Bearer <token>` with `users:write` scope.

**Request body**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email` | string | yes | Unique. |
| `name` | string | no | Display name. |

**Example request**

\`\`\`http
POST /v1/users HTTP/1.1
Authorization: Bearer <token>
Content-Type: application/json

{ "email": "a@b.com", "name": "A" }
\`\`\`

**Response 201**

\`\`\`json
{ "id": "usr_123", "email": "a@b.com", "name": "A" }
\`\`\`

**Errors**

| Status | Code | When |
|--------|------|------|
| 400 | `invalid_email` | Email malformed. |
| 409 | `email_taken` | Email already registered. |
```

## CLI — command reference

```markdown
### `mytool build [options]`

Build the project.

**Usage**

\`\`\`bash
mytool build --target prod --out dist/
\`\`\`

**Options**

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--target` | `dev\|prod` | `dev` | Build target. |
| `--out` | path | `dist/` | Output directory. |
| `--watch` | bool | `false` | Rebuild on change. |

**Exit codes** `0` success, `1` build error, `2` config error.
```

## Architecture overview

```markdown
# Architecture

## Module map

- `core/` — domain model, no I/O.
- `adapters/` — implementations of ports (HTTP, DB, queue).
- `app/` — orchestration; depends on `core` and `adapters`.

## Data flow

1. Request hits `app/handler.ts`.
2. Handler calls a port from `core/`.
3. Port is fulfilled by an adapter.
4. Result returned; errors normalized at the app boundary.

## Invariants

- `User.id` is never reused after deletion.
- All money values are integers in the smallest currency unit.

## Where to look

- Adding a new endpoint → `app/handler.ts` + `adapters/http/*`.
- Changing persistence → `adapters/db/*` only.
```

## Changelog entry

```markdown
## [Unreleased]

### Added
- `fnX` for doing Y. (#123)

### Changed
- `fnY` now returns `Promise<Result>` instead of `Result`. Migration: `await`.

### Deprecated
- `fnOld` — use `fnNew`. Removed in next major.

### Fixed
- Crash when input was empty. (#124)
```

## Verification snippet

After generating docs, run a quick sanity check (adjust per language):

```bash
# TypeScript: every documented symbol exists and is exported
rg --type ts "export (function|class|const) <name>" src/

# Python: every documented symbol exists
rg "^(def|class) <name>" --type py

# Markdown links: no broken intra-repo links
rg -n "\]\(([^)]+\.md)\)" README.md | while read -r line; do
  path=$(echo "$line" | sed -E 's/.*\]\(([^)]+)\).*/\1/')
  [ -f "$path" ] || echo "broken: $path"
done
```
