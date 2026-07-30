# Refactor — Examples

Before/after pairs with the test discipline called out. Use these as
a quality bar.

## Example 1 — Extract function

### Before

```ts
function totalPrice(items: Item[]) {
  let sum = 0;
  for (const i of items) {
    if (i.price > 0) sum += i.price * (i.qty || 1);
  }
  if (sum > 100) sum *= 0.9;
  return sum;
}
```

### After

```ts
function totalPrice(items: Item[]) {
  const sum = items
    .filter((i) => i.price > 0)
    .reduce((acc, i) => acc + i.price * (i.qty || 1), 0);
  return applyDiscount(sum);
}

function applyDiscount(amount: number) {
  return amount > 100 ? amount * 0.9 : amount;
}
```

### Test discipline

- Baseline: `npm test` → 12 passing.
- Apply refactor.
- `npm test` → 12 passing. Same set.
- Commit: `refactor: extract applyDiscount from totalPrice`.

## Example 2 — Rename, repo-wide

### Before

```ts
// src/users.ts
export function proc(d: any[]) { ... }

// src/handler.ts
import { proc } from "./users";
proc(data);
```

### After

```ts
// src/users.ts
export function normalizeDiscounts(items: Discount[]) { ... }

// src/handler.ts
import { normalizeDiscounts } from "./users";
normalizeDiscounts(data);
```

### Test discipline

- `rg -n "\\bproc\\b"` before the change → 4 hits (definition + 3 call sites).
- Apply rename at all 4 sites.
- `rg -n "\\bproc\\b"` after → 0 hits.
- `npm test` → green.

## Example 3 — Replace conditional with dispatch

### Before

```ts
function handle(ev: Event) {
  switch (ev.type) {
    case "click": return onClick(ev);
    case "hover": return onHover(ev);
    case "focus": return onFocus(ev);
    case "blur":  return onBlur(ev);
  }
}
```

### After

```ts
const handlers: Record<string, (ev: Event) => void> = {
  click: onClick,
  hover: onHover,
  focus: onFocus,
  blur:  onBlur,
};
function handle(ev: Event) {
  return handlers[ev.type]?.(ev);
}
```

### Test discipline

- Existing tests cover all 4 event types.
- Apply refactor.
- Tests still green; behavior identical for unknown types (returns
  `undefined` in both versions).

## Example 4 — Modernize syntax

### Before

```ts
const name = user && user.profile && user.profile.name;
const fallback = config.timeout == null ? 1000 : config.timeout;
```

### After

```ts
const name = user?.profile?.name;
const fallback = config.timeout ?? 1000;
```

### Test discipline

- Confirm `user.profile` is never `0` or `""` in a way that would
  change `&&` → `?.` semantics. (It can't — `?.` only short-circuits
  on `null`/`undefined`, while `&&` also short-circuits on falsy.)
- If any falsy-but-not-nullish value mattered, **stop** — this is not
  behavior-preserving. Note it and skip the change.

## Example 5 — Guard clauses

### Before

```ts
function pay(amount: number) {
  if (amount > 0) {
    if (user.balance >= amount) {
      // 30 lines of payment logic
    } else {
      throw new Error("insufficient");
    }
  } else {
    throw new Error("invalid");
  }
}
```

### After

```ts
function pay(amount: number) {
  if (amount <= 0) throw new Error("invalid");
  if (user.balance < amount) throw new Error("insufficient");
  // 30 lines, un-nested
}
```

### Test discipline

- Tests cover: valid payment, insufficient balance, invalid amount.
- All three still pass with the same assertions.

## Anti-example — refactor that broke behavior

```ts
// before
const x = a && a.b && a.b.c;

// "after" — WRONG
const x = a?.b?.c;
```

Why it's wrong: if `a.b` is `0` or `""`, the original returns that
falsy value, the new version returns `undefined`. The skill must
detect this and **not** apply the change, or note it and stop.

## Anti-example — mixed concerns

```ts
// "refactor" commit that also fixes a bug:
function applyDiscount(amount: number) {
  return amount > 100 ? amount * 0.9 : amount;
}
// ^^^ silently also fixed: was `>= 100` before, now `> 100`
```

The skill must never bundle a behavior change into a refactor commit.
If a bug is spotted, note it in the report and let the user decide.
