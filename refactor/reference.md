# Refactor — Reference

Catalog of behavior-preserving refactors with code shapes. Use as a
menu, not a checklist — only apply a refactor when it improves the
code. Keep this file one level deep from `SKILL.md`.

## Table of contents

- [Extract function](#extract-function)
- [Inline function](#inline-function)
- [Rename](#rename)
- [Extract variable / Inline variable](#extract-variable--inline-variable)
- [Replace magic literal](#replace-magic-literal)
- [Consolidate duplicate expression](#consolidate-duplicate-expression)
- [Replace conditional with dispatch](#replace-conditional-with-dispatch)
- [Replace conditional with polymorphism](#replace-conditional-with-polymorphism)
- [Replace loop with pipeline](#replace-loop-with-pipeline)
- [Move / Move module](#move--move-module)
- [Modernize syntax](#modernize-syntax)
- [Guard clauses](#guard-clauses)
- [Replace nested data with object](#replace-nested-data-with-object)

---

## Extract function

**When** a block has one purpose or is reused.

**Before**

```ts
function totalPrice(items) {
  let sum = 0;
  for (const i of items) {
    if (i.price > 0) sum += i.price * (i.qty || 1);
  }
  if (sum > 100) sum *= 0.9;
  return sum;
}
```

**After**

```ts
function totalPrice(items) {
  const sum = items
    .filter((i) => i.price > 0)
    .reduce((acc, i) => acc + i.price * (i.qty || 1), 0);
  return applyDiscount(sum);
}

function applyDiscount(amount: number) {
  return amount > 100 ? amount * 0.9 : amount;
}
```

**Verify** callers unchanged; tests green.

## Inline function

**When** a one-line helper adds no clarity.

**Before**

```ts
function isAdult(u: User) {
  return u.age >= 18;
}
if (isAdult(u)) { ... }
```

**After**

```ts
if (u.age >= 18) { ... }
```

**Verify** no other callers of `isAdult` remain.

## Rename

**When** a name hides intent.

**Before**

```ts
function proc(d: any[]) { ... }
```

**After**

```ts
function normalizeDiscounts(items: Discount[]) { ... }
```

**Verify** `rg -n "\\boldName\\b"` returns zero hits across the repo
after the change.

## Extract variable / Inline variable

**Extract** when a sub-expression is hard to read.

```ts
// before
return a + b * c > 100;

// after
const threshold = a + b * c;
return threshold > 100;
```

**Inline** when the variable just restates the expression.

```ts
// before
const isEligible = user.age >= 18;
if (isEligible) { ... }

// after
if (user.age >= 18) { ... }
```

## Replace magic literal

**Before**

```ts
if (user.role === 3) { ... }
```

**After**

```ts
const ROLE = { ADMIN: 3 } as const;
if (user.role === ROLE.ADMIN) { ... }
```

## Consolidate duplicate expression

**Before**

```ts
if (a) {
  doX();
  doY();
} else if (b) {
  doX();
  doY();
}
```

**After**

```ts
if (a || b) {
  doX();
  doY();
}
```

## Replace conditional with dispatch

**When** a switch grows past ~3 arms.

**Before**

```ts
function handle(ev: Event) {
  switch (ev.type) {
    case "click": return onClick(ev);
    case "hover": return onHover(ev);
    case "focus": return onFocus(ev);
  }
}
```

**After**

```ts
const handlers: Record<string, (ev: Event) => void> = {
  click: onClick,
  hover: onHover,
  focus: onFocus,
};
function handle(ev: Event) {
  return handlers[ev.type]?.(ev);
}
```

## Replace conditional with polymorphism

**When** new types keep forcing new branches.

**Before**

```ts
function area(shape) {
  switch (shape.kind) {
    case "circle":  return Math.PI * shape.r ** 2;
    case "square":  return shape.s ** 2;
  }
}
```

**After**

```ts
interface Shape { area(): number; }
class Circle implements Shape { area() { return Math.PI * this.r ** 2; } }
class Square implements Shape { area() { return this.s ** 2; } }
```

## Replace loop with pipeline

**Before**

```ts
const out: string[] = [];
for (const u of users) {
  if (u.active) out.push(u.name.toUpperCase());
}
```

**After**

```ts
const out = users.filter((u) => u.active).map((u) => u.name.toUpperCase());
```

## Move / Move module

**When** a symbol is closer to its callers than its current home.

1. Add the symbol at the new location.
2. Re-export from the old location if any external caller imports it.
3. Update internal imports.
4. After callers migrate, drop the re-export.

## Modernize syntax

Only when behavior is identical.

```ts
// before
const x = obj && obj.a && obj.a.b;
const y = a == null ? b : a;
async function f() { return Promise.resolve(5); }

// after
const x = obj?.a?.b;
const y = a ?? b;
async function f() { return 5; }
```

```python
# before
out = []
for u in users:
    if u.active:
        out.append(u.name.upper())

# after
out = [u.name.upper() for u in users if u.active]
```

## Guard clauses

**Before**

```ts
function pay(amount) {
  if (amount > 0) {
    if (user.balance >= amount) {
      // 30 lines
    } else {
      throw new Error("insufficient");
    }
  } else {
    throw new Error("invalid");
  }
}
```

**After**

```ts
function pay(amount) {
  if (amount <= 0) throw new Error("invalid");
  if (user.balance < amount) throw new Error("insufficient");
  // 30 lines, un-nested
}
```

## Replace nested data with object

**Before**

```ts
const row = ["alice", 30, true];
const name = row[0];
```

**After**

```ts
const row = { name: "alice", age: 30, active: true };
const { name } = row;
```

---

## Test discipline (applies to every refactor above)

1. Run the suite. Capture the green baseline (names + count).
2. Make the change in the smallest viable step.
3. Re-run the suite. Same set must pass.
4. If a test goes red:
   - **Do not** modify the test to make it green.
   - Revert the refactor; the behavior change is unintended.
5. Commit between steps when the diff is reviewable on its own.

## Commit message shapes

```
refactor: extract applyDiscount from totalPrice
refactor: rename proc -> normalizeDiscounts
refactor: replace switch with dispatch map in handle()
refactor: inline isAdult helper
```

Never mix `refactor:` with `feat:` or `fix:` in one commit.
