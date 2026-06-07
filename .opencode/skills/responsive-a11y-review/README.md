# responsive-a11y-review

> Audit frontend UI changes for responsive layout breakage and accessibility violations before deployment.

---

## What This Skill Does

Reviews frontend UI source code to catch responsive design issues and accessibility regressions that are easy to overlook. Produces a structured report with categorized findings and an overall status of PASS, WARN, or FAIL.

All analysis is static — no browser, no screenshots, no visual diffing.

---

## When to Use It

- Before opening a PR with UI changes
- When you need a responsive layout sanity check across common viewport sizes
- As an accessibility pre-check before running heavier tooling (axe, Lighthouse)
- As part of a "review frontend before deploy" workflow

---

## Installation

Place the `responsive-a11y-review` folder under your project's `.opencode/skills/`:

```
.opencode/
└── skills/
    └── responsive-a11y-review/
        ├── SKILL.md
        ├── README.md
        └── templates/
            └── report.md
```

The skill activates automatically when OpenCode detects the SKILL.md file.

---

## Usage Prompt

Trigger the skill by asking your agent:

> "Review my frontend UI changes for responsive and a11y problems."
> "Check these files for responsive breakage and accessibility issues."
> "Audit the frontend diff before I open a PR."

---

## Example Workflow

1. **Collect scope** — agent resolves target files from your input (diff, glob, or explicit paths)
2. **Responsive scan** — each layout file is checked against default viewport presets (375/768/1024/1440)
3. **Accessibility scan** — ARIA, focus, contrast risks, keyboard nav, alt text are reviewed
4. **Tool comparison** — if axe-core or Lighthouse configs are found, results are cross-referenced
5. **Report** — a consolidated `responsive-a11y-report.md` is written with per-category findings and overall PASS/WARN/FAIL

---

## Limitations

- Static analysis only — cannot verify runtime behaviour, animations, or dynamic content
- Colour contrast assessment flags obvious risks only; final validation requires a browser tool
- Line numbers depend on diff or tool output — the skill never invents them
- Framework-specific patterns are only checked when the framework is explicitly specified
- No browser automation — interactive states (hover, focus, active) are assessed from source only
