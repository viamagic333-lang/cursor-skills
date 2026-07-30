---
name: refactor
description: >-
  Refactor code safely while preserving observable behavior. Extracts
  functions, simplifies conditionals, renames for clarity, deduplicates
  logic, and modernizes syntax. Use when the user says "refactor",
  "clean up", "simplify", "extract", "rename", "deduplicate", or asks
  to improve code structure without changing behavior. Always run the
  existing test suite before and after; if no tests exist, propose
  characterization tests first.
---

# Refactor

Change structure, not behavior. Every refactor must leave the program
doing the same thing from the user's perspective.

## Non-negotiable rules

1. **Behavior-preserving.** No new features, no bug fixes, no perf
   changes mixed in. If you spot one, note it and stop — don't bundle.
2. **Tests gate everything.** Before refactoring:
   - If a test suite exists → run it, capture green baseline.
   - If none exists → propose characterization tests covering the
     code you're about to touch. Get user approval before proceeding.
   - After refactoring → run the same suite. It must stay green.
   - If a test goes red, revert; the refactor is wrong.
3. **Small steps.** Each commit-sized change should be reviewable on
   its own. Don't combine 5 refactors into one diff.
4. **Read first.** Open the file and its callers/callees before
   editing. Use `Grep` to find all call sites of any symbol you rename.
5. **No churn.** If the code is already clear, leave it. Don't refactor
   for taste alone.

## Workflow

1. **Baseline.** Run tests (or establish them). Record the green state.
2. **Map.** Identify the scope: which files, which symbols, which
   callers. List them so the user can sanity-check the blast radius.
3. **Plan.** State the refactor in one sentence: "Extract X from Y so
   that Z." Get user OK before editing if the change is non-trivial.
4. **Execute.** Make the change in the smallest viable step.
5. **Verify.** Re-run tests. Lint. Type-check. Fix anything red before
   moving on.
6. **Repeat** for the next step. Commit between steps when sensible.
7. **Report.** Summarize what changed, what stayed green, and any
   follow-ups you deferred.

## Common refactors (cheat sheet)

- **Extract function** — move a block into a named function when the
  block has a single purpose or is reused.
- **Inline function** — collapse a one-line helper that adds no
  clarity.
- **Rename** — use a name that says *what*, not *how*. Update all call
  sites.
- **Replace conditional with polymorphism / dispatch** — when a
  switch grows past ~3 arms.
- **Replace magic number/string** — named constant.
- **Consolidate duplicate expression** — identical branches into one.
- **Modernize syntax** — optional chaining, nullish coalescing,
  async/await, f-strings, type hints — only when behavior is identical.
- **Move** — relocate a symbol closer to its callers when cohesion
  improves.

## Naming

- Functions: verbs. `fetchUser`, `parseConfig`, `hasPermission`.
- Booleans: `is/has/can/should`. `isValid`, `hasAccess`.
- Collections: plural. `users`, not `userList`.
- Avoid: `data`, `info`, `helper`, `util`, `manager`, `temp`, `obj`.

## Anti-patterns

- "Drive-by" refactors in unrelated files.
- Renaming public API without updating consumers.
- Changing return types or side effects "while I'm here."
- Refactoring past the test boundary — if it's not covered, add a
  test first.
- Leaving the suite red at any point.

## Additional resources

- For the full catalog of refactor patterns with code shapes, see [reference.md](reference.md).
- For before/after examples with the test discipline called out, see [examples.md](examples.md).

## Verification checklist

Before declaring done:

- [ ] Tests pass (same set as baseline).
- [ ] Lint / type-check clean.
- [ ] No public API signature changed without intent.
- [ ] All call sites updated (search the whole repo, not the file).
- [ ] Commit messages describe the refactor, not the code.
- [ ] No new behavior, no removed behavior.
