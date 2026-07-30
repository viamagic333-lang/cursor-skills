---
name: design-hunt
description: >-
  Hunt advanced web design templates across 8 reference sites —
  awwwards.com, dribbble.com, behance.net, templatemonster.com,
  themeforest.net, framer.com/templates, tailwindui.com, and
  ui.shadcn.com — using the Playwright MCP browser. Four modes:
  inspiration (browse trends), extract (pull components/CSS),
  screenshots (save references to disk), replicate (rebuild a
  seen design in code). Use when the user says "find design for X",
  "найди шаблон для Y", "покажи трендовые дизайны Z", "вытащи
  компонент с сайта", "сделай скриншоты дизайнов", "реплицируй
  дизайн", or invokes /design-hunt.
---

# Design Hunt

Browse 8 reference sites with the Playwright MCP browser, in one of
four modes. Always confirm the mode with the user before opening
browser sessions — browsing is slow and visible.

## The 8 sites

| Site | Best for | URL |
|------|----------|-----|
| awwwards.com | Award-winning creative sites of the week | https://www.awwwards.com |
| dribbble.com | UI shots, component concepts | https://dribbble.com |
| behance.net | Full design case studies | https://behance.net |
| templatemonster.com | Ready-made templates (paid + free) | https://www.templatemonster.com |
| themeforest.net | Premium templates (Envato) | https://themeforest.net |
| framer.com/templates | Modern Framer templates | https://www.framer.com/templates |
| tailwindui.com | Tailwind CSS components | https://tailwindui.com |
| ui.shadcn.com | Modern React component library | https://ui.shadcn.com |

## The 4 modes

Ask the user which mode they want. Default to **inspiration** if
unclear.

### Mode 1 — inspiration

Goal: see what's trending, gather visual references.

1. Ask the user: what domain? (e.g., "landing page for SaaS",
   "e-commerce for fashion", "portfolio for photographer")
2. Open 2–3 sites most relevant to the domain:
   - Creative / portfolio / brand → awwwards, behance
   - Component-level UI → dribbble, tailwindui, shadcn
   - Full templates → templatemonster, themeforest, framer
3. Search each site for the domain keyword.
4. Take 1 screenshot per site (the search results or first result).
5. Return: 3–5 links to specific designs, with one-line "why it fits"
   per link. No code.

### Mode 2 — extract

Goal: pull a specific component or style from a site for reuse.

1. Ask the user: which URL, and which component (hero, nav, card,
   pricing table, footer…).
2. `browser_navigate` to the URL.
3. `browser_snapshot` to see the DOM tree.
4. Use `browser_evaluate` to extract:
   - The component's outerHTML
   - Its computed styles (color, font, spacing, radius, shadow)
   - Any CSS variables / Tailwind classes on the element
5. Return: the HTML + a minimal CSS/JSX snippet that reproduces the
   component. **Attribute the source URL** in a comment.

**Do not** copy an entire page verbatim — extract the specific
component the user asked about.

### Mode 3 — screenshots

Goal: build a local library of references.

1. Ask the user: which sites, how many designs, what domain.
2. For each site: navigate, search, take screenshots of the top N
   results.
3. Save each screenshot to `~/Desktop/design-references/<site>/<date>/`
   with a slugified name.
4. Return: a list of saved paths + a one-line caption per file.

```bash
# Save path pattern
~/Desktop/design-references/<site>/<YYYY-MM-DD>/<slug>.png
```

### Mode 4 — replicate

Goal: rebuild a seen design 1:1 in the user's stack.

1. Ask the user: which URL, and which stack (HTML/CSS, React +
   Tailwind, React + shadcn, etc.).
2. `browser_navigate` to the URL.
3. `browser_take_screenshot` of the full page (and key sections).
4. `browser_snapshot` to capture the structure.
5. `browser_evaluate` to extract computed colors, fonts, spacing.
6. Rebuild the page in the requested stack, using the user's existing
   project conventions if available.
7. **Attribute** the source URL in a comment at the top of the file.

**Important:** replication is for learning and personal reference.
Don't republish someone else's template as your own — credit the
source. For commercial work, buy the template or build an original
design inspired by it.

## Workflow (all modes)

1. **Confirm mode** with the user (inspiration / extract /
   screenshots / replicate). Default: inspiration.
2. **Confirm scope** — which sites, what domain, how many results.
3. **Open browser** with `browser_navigate`. Resize to a sensible
   viewport first (default 1280×800 desktop, or 390×844 mobile if
   the user asked for mobile).
4. **Capture** what you need (snapshot, screenshot, evaluate).
5. **Close** the browser with `browser_close` when done — browser
   sessions are heavy.
6. **Return** the result in the mode's specific format.

## Anti-patterns

- Don't open the browser without confirming the mode and scope first.
- Don't take 50 screenshots "just in case" — disk fills up.
- Don't extract a full page's HTML and call it "extract component".
- Don't replicate a paid template 1:1 for a commercial project.
- Don't forget to close the browser.
- Don't skip attribution — always credit the source URL.

## Verification

Before returning, confirm:

- [ ] Mode was confirmed with the user.
- [ ] Browser was closed at the end.
- [ ] For `extract` and `replicate`: source URL is in a comment.
- [ ] For `screenshots`: files exist on disk at the stated paths.
- [ ] For `inspiration`: 3–5 links with one-line justifications.
- [ ] No more than ~10 screenshots per session unless asked.

## Additional resources

- For per-site navigation tips, search syntax, and extraction
  snippets, see [reference.md](reference.md).
