# Docs Generator — Examples

Before/after pairs showing the skill in action. Use these as a quality
bar, not a rigid template.

## Example 1 — JSDoc for a single function

### Before

```ts
export function parseConfig(raw, opts = {}) {
  if (!raw) throw new Error("empty");
  const strict = opts.strict ?? false;
  const parsed = JSON.parse(raw);
  if (strict && !parsed.version) throw new Error("missing version");
  return { ...parsed, strict };
}
```

### After

```ts
/**
 * Parse a JSON config string into a typed object.
 *
 * Use when loading user-supplied config. In strict mode, rejects
 * payloads without a `version` field so migrations can be enforced.
 *
 * @param raw - JSON string. Required.
 * @param opts.strict - Reject payloads without `version`. Defaults to false.
 * @returns The parsed config with `strict` echoed back for downstream checks.
 * @throws {Error} When `raw` is empty or not valid JSON.
 * @throws {Error} When `opts.strict` is true and `version` is missing.
 *
 * @example
 *
 * ```ts
 * const cfg = parseConfig('{"version":1}', { strict: true });
 * ```
 */
export function parseConfig(raw, opts = {}) {
  // ...
}
```

## Example 2 — README section for a module

### Before

`src/users.ts` exports `createUser`, `getUser`, `deleteUser`. No docs.

### After (excerpt of `README.md`)

```markdown
## `users`

CRUD helpers for the `users` table.

### Public API

- `createUser(input)` — insert a user, returns the created row.
- `getUser(id)` — fetch by id, returns `null` if missing.
- `deleteUser(id)` — soft-delete; idempotent.

### Usage

```ts
import { createUser } from "./src/users";
const u = await createUser({ email: "a@b.com" });
```

### Notes

- `deleteUser` is idempotent: deleting a missing id returns `0`, not an error.
- All functions reject with `DbError` on connection loss.
```

## Example 3 — REST endpoint

### After

```markdown
### GET /v1/users/:id

Fetch a single user.

**Auth** `Bearer <token>` with `users:read` scope.

**Path params**

| Name | Type | Description |
|------|------|-------------|
| `id` | string | `usr_`-prefixed id. |

**Response 200**

```json
{ "id": "usr_123", "email": "a@b.com", "name": "A" }
```

**Errors**

| Status | Code | When |
|--------|------|------|
| 404 | `not_found` | User does not exist. |
| 403 | `forbidden` | Token lacks `users:read`. |
```

## Example 4 — keeping docs in sync

A user edits `parseConfig` to also accept `opts.allowComments`. The skill:

1. Reads the new signature.
2. Updates the `@param` block.
3. Updates the `@example` to show the new option.
4. Adds a changelog entry under `### Added`.
5. Re-runs verification: confirms `parseConfig` is still exported and
   the example compiles.

## Anti-example — what NOT to produce

```ts
/**
 * This function parses the config. It takes a string and parses it
 * using JSON.parse. Then it returns the parsed object. Parsing is
 * done with JSON.parse because JSON is a common format.
 */
```

Why it's bad: restates the implementation, adds no caller-facing
value, and will drift the moment the code changes.
