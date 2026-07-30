# Design Hunt — Reference

Per-site navigation tips, search syntax, and extraction snippets.
Use when the quick workflow in `SKILL.md` isn't enough.

## Table of contents

- [Playwright MCP tools](#playwright-mcp-tools)
- [Per-site tactics](#per-site-tactics)
  - [awwwards.com](#awwwardscom)
  - [dribbble.com](#dribbblecom)
  - [behance.net](#behancenet)
  - [templatemonster.com](#templatemonstercom)
  - [themeforest.net](#themeforestnet)
  - [framer.com/templates](#framercomtemplates)
  - [tailwindui.com](#tailwinduicom)
  - [ui.shadcn.com](#uishadcncom)
- [Extraction snippets](#extraction-snippets)
- [Viewport sizes](#viewport-sizes)
- [File naming](#file-naming)
- [Legal & ethical notes](#legal--ethical-notes)

---

## Playwright MCP tools

| Tool | Use |
|------|-----|
| `browser_navigate` | Open a URL |
| `browser_navigate_back` | Back button |
| `browser_resize` | Set viewport (1280×800, 390×844, etc.) |
| `browser_snapshot` | Get the DOM tree as accessibility tree |
| `browser_take_screenshot` | Save a screenshot |
| `browser_evaluate` | Run JS in the page (extract HTML, computed styles) |
| `browser_click` | Click an element |
| `browser_fill_form` | Fill inputs (e.g., search box) |
| `browser_press_key` | Press Enter, Escape, etc. |
| `browser_close` | Close the browser session — **always do this at the end** |
| `browser_network_requests` | See what the page loaded (useful for finding asset URLs) |
| `browser_console_messages` | See console output (useful when a page breaks) |

Always call `browser_resize` once at the start, before navigating,
so screenshots are consistent.

## Per-site tactics

### awwwards.com

- **Search URL:** `https://www.awwwards.com/websites/<category>/`
  - Categories: `site-of-the-day`, `portfolio`, `e-commerce`,
    `agencies`, `restaurants`, `magazines`, `minimal`, `color`,
    `typography`, `photography`, `animation`, `mobile`
- **Search box:** top-right, label "Search".
- **Best for:** inspiration mode. Each site has a "Visit Site"
  button — follow it to see the live design.
- **Tip:** the "Site of the Day" archive is the highest-quality
  filter. Use it when the user wants "the best of the best".

### dribbble.com

- **Search URL:** `https://dribbble.com/search/<keyword>`
- **Filters:** popular, recent, shots, collections.
- **Best for:** component-level inspiration (hero sections, nav
  bars, pricing cards, onboarding screens).
- **Tip:** most shots are static images, not live code. Use
  inspiration mode, not extract.

### behance.net

- **Search URL:** `https://www.behance.net/search/<keyword>`
- **Filters:** project, all, sort by most appreciated.
- **Best for:** full case studies — see the brief, the iterations,
  and the final design.
- **Tip:** scroll past the first image; case studies often have
  10+ screens.

### templatemonster.com

- **Search URL:** `https://www.templatemonster.com/<type>/<keyword>/`
  - Types: `wordpress-themes`, `website-templates`, `ecommerce-templates`
- **Filter by:** free / paid, category, rating.
- **Best for:** full template evaluation. Live demo links usually
  point to a real, browsable site.
- **Tip:** the "Live Demo" button is the entry point for
  extract/replicate modes.

### themeforest.net

- **Search URL:** `https://themeforest.net/search?term=<keyword>`
- **Categories:** WordPress, Site Templates, CMS Themes, eCommerce,
  Marketing.
- **Best for:** premium templates with professional polish.
- **Tip:** preview the live demo, not the marketplace thumbnail.

### framer.com/templates

- **URL:** `https://www.framer.com/templates`
- **Filter:** Free, Portfolio, Startup, Agency, Personal, Blog,
  Photography, Store.
- **Best for:** modern, fast, animation-heavy templates.
- **Tip:** each template has a "Preview" link to a live Framer site.
  Use `browser_evaluate` to extract the structure; Framer sites are
  React under the hood.

### tailwindui.com

- **URL:** `https://tailwindui.com`
- **Sections:** Preview, Components, Templates.
- **Best for:** extract mode — every component is shipped as
  Tailwind HTML/JSX.
- **Tip:** requires a paid license for the actual code, but the
  preview pages are free to view and replicate manually.

### ui.shadcn.com

- **URL:** `https://ui.shadcn.com`
- **Sections:** Components, Blocks, Charts, Examples.
- **Best for:** extract mode for React + Tailwind projects. The
  source code is open and MIT-licensed.
- **Tip:** the "Blocks" section has full page sections (hero,
  pricing, footer) ready to copy.

## Extraction snippets

### Get the outerHTML of a clicked element

After `browser_snapshot`, find the element's ref, then:

```js
// browser_evaluate
() => {
  const el = document.querySelector('<selector>');
  return el ? el.outerHTML : null;
}
```

### Get computed styles of an element

```js
() => {
  const el = document.querySelector('<selector>');
  if (!el) return null;
  const cs = getComputedStyle(el);
  return {
    color: cs.color,
    background: cs.backgroundColor,
    fontFamily: cs.fontFamily,
    fontSize: cs.fontSize,
    fontWeight: cs.fontWeight,
    lineHeight: cs.lineHeight,
    padding: cs.padding,
    margin: cs.margin,
    borderRadius: cs.borderRadius,
    boxShadow: cs.boxShadow,
    border: cs.border,
  };
}
```

### Extract CSS variables from :root

```js
() => {
  const root = document.documentElement;
  const styles = getComputedStyle(root);
  const vars = {};
  for (const sheet of document.styleSheets) {
    try {
      for (const rule of sheet.cssRules) {
        if (rule.selectorText === ':root') {
          for (const decl of rule.style) {
            if (decl.startsWith('--')) vars[decl] = rule.style.getPropertyValue(decl).trim();
          }
        }
      }
    } catch {}
  }
  return vars;
}
```

### Get all Tailwind classes on an element

```js
() => {
  const el = document.querySelector('<selector>');
  return el ? el.className : null;
}
```

### Screenshot the full page

```
browser_take_screenshot({ fullPage: true, filename: "name.png" })
```

## Viewport sizes

| Device | Width × Height |
|--------|---------------|
| Desktop default | 1280 × 800 |
| Desktop large | 1440 × 900 |
| Laptop | 1366 × 768 |
| iPad portrait | 768 × 1024 |
| iPhone 14 | 390 × 844 |
| iPhone SE | 375 × 667 |
| Pixel 7 | 412 × 915 |

Always set viewport **before** navigating so the layout matches.

## File naming

For screenshots saved to disk:

```
~/Desktop/design-references/<site>/<YYYY-MM-DD>/<slug>.png
```

- `<site>` — `awwwards`, `dribbble`, `behance`, `templatemonster`,
  `themeforest`, `framer`, `tailwindui`, `shadcn`
- `<slug>` — lowercase, hyphens, max 40 chars, derived from the
  design's title or the search query

Example:
```
~/Desktop/design-references/awwwards/2026-07-30/saas-landing-dark-mode.png
```

## Legal & ethical notes

- **Inspiration** is always fine.
- **Extract** for personal learning is fine. Don't ship extracted
  code as your own without checking the source license.
- **Screenshots** for personal reference are fine. Don't republish
  them without credit.
- **Replicate** for personal learning is fine. For commercial work:
  - Buy the template if it's paid (ThemeForest, TemplateMonster,
    Tailwind UI).
  - Use open licenses (shadcn/ui is MIT) freely.
  - For Awwwards / Dribbble / Behance designs: build *inspired by*,
    not *copied from*. Credit the original designer in the README.
- Never claim someone else's design as your own in your portfolio.
