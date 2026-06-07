# responsive-a11y-review

---

```yaml
name: responsive-a11y-review
description: Audit frontend UI changes for responsive layout breakage and accessibility violations before deployment
compatibility: opencode >= 1.0.0
```

---

## Purpose

This skill reviews frontend UI changes — specifically catching responsive design breakage and accessibility regressions — that are easy for both humans and AI to overlook. It produces a structured report with categorized findings so issues are fixed before they ship.

---

## When to Activate

Activate when the user asks to review UI changes, check responsive layout, audit accessibility, or any of:

- "review my frontend UI changes"
- "check for responsive problems"
- "audit accessibility before deploy"
- "review frontend before deploy"

Do **not** activate for:
- General code review without UI focus
- Backend or API changes
- Requests to run a browser, take screenshots, or perform visual diffing

---

## Core Rule

**Do not run a browser, take screenshots, or perform visual diffing.** All analysis is static source-code review.

---

## Workflow

### 1. Collect Scope

Resolve the set of files to review from the user's input. Accept a git diff, file globs, or explicit paths.

**Output format:**

```
## Scope

**Source:** <diff / glob / explicit paths>
**Files to review:**
- <path>
- <path>

**Excluded:**
- <test files, stories, build output>

**Edge cases:**
- No relevant UI files found → report "nothing to review", produce a minimal PASS report, and stop

### 2. Responsive Scan

For each layout-relevant file (CSS, JSX/TSX with styles, inline styles), check for viewport-aware patterns:

- Media queries present and cover the target breakpoints (default: 375px, 768px, 1024px, 1440px)
- Relative units (`rem`, `em`, `%`, `vw`, `vh`) used instead of fixed `px` for layout properties
- Fixed-width containers or overflow values that might break at smaller viewports
- Horizontal overflow not handled (`overflow-x: hidden` or scroll wrappers absent)

**Output format:**

```
## Responsive Scan

**Breakpoints checked:** <375px, 768px, 1024px, 1440px — or custom>

| File | Issue | Severity | Details |
|------|-------|----------|---------|
| <path> | <description> | warn / fail | <context> |

**Edge cases:**
- No style-related files found → report "no style changes to review" in the Responsive section, then continue to Accessibility Scan

### 3. Accessibility Scan

Check for common accessibility patterns in UI files:

- ARIA attributes present where needed (`role`, `aria-label`, `aria-hidden`)
- Focus management — visible focus styles, logical tab order
- Colour contrast — flag obvious contrast risks from inline styles, class names, or design tokens when visible; recommend browser/tool-based validation for final confirmation
- Keyboard navigation — interactive elements are focusable and activatable
- Alt text — images and icon buttons have descriptive text or `aria-label`
- Semantic HTML — use of landmark elements (`nav`, `main`, `aside`) or ARIA equivalents

**Output format:**

```
## Accessibility Scan

| File | Issue | Severity | Details |
|------|-------|----------|---------|
| <path> | <description> | warn / fail | <context> |

**Tooling detected:** <axe-core / Lighthouse / none>
**Recommendation:** <if no tooling found, suggest adding it>
```

### 4. Compare with Tools

If the project has axe-core, Lighthouse, or other a11y tool configurations, cross-reference the scan results. Note any gaps the tools would catch but the static scan missed, and vice versa.

**Output format:**

```
## Tool Comparison

**Detected configs:** <list>
**Overlap:** <findings caught by both>
**Gaps:** <findings only in static scan / only in tool output>
```

If no tooling is detected, skip this step and state: *"No a11y tooling detected. Results are based on static analysis only. Consider adding axe-core or Lighthouse CI for automated validation."*

### 5. Compile Report

Produce a consolidated report with overall review status and per-section findings.

**Output format:**

```
## Report

**Overall status:** PASS / WARN / FAIL

- PASS: no blocking issues
- WARN: non-blocking responsive or accessibility concerns
- FAIL: blocking accessibility or responsive regressions

### Responsive Findings
<summary table or "none">

### Accessibility Findings
<summary table or "none">

### Recommendations
- <actionable recommendation>
```

---

## Skill Name Rules

- Use lowercase with hyphens: `responsive-a11y-review`
- Match the directory name to the skill name
- Use a noun phrase describing what the skill does
- Avoid verbs as the first word
- Maximum 4 words
- Must be unique within the project's skill directory

---

## Quality Audit Rubric

| Criterion | Definition |
|-----------|------------|
| **Metadata present** | YAML or metadata block with name, description, compatibility |
| **Purpose clear** | Single paragraph explaining why the skill exists and when it activates |
| **Workflow complete** | All workflow steps documented with clear transition conditions |
| **Output formats defined** | Every workflow step has a documented output format |
| **Do-not rules present** | Explicit prohibitions on dangerous or unwanted behaviors |
| **Trigger clarity** | Trigger pattern precise enough to avoid false positives |
| **No assumptions as facts** | Skill does not assert untested assumptions as established facts |
| **Safety constraints** | Limits on destructive operations, external writes, sensitive data exposure |
| **Naming convention followed** | Name follows the Skill Name Rules |

A skill must pass all criteria to be considered complete.

---

## Do-Not Rules

- Do not run a browser, take screenshots, or perform visual diffing
- Do not modify source files
- Do not enforce framework-specific patterns unless the framework is explicitly confirmed
- Do not fail on missing a11y tooling — flag as warning, not failure
- Do not invent line numbers. If exact lines are unavailable, cite the file path and nearby selector or component name
- Do not claim exact colour contrast compliance without browser or tool evidence
- Do not output CLI exit codes
- Do not install packages or modify project configuration

---

## Safety / Boundaries

**Read access:**
- Frontend source files as specified by the user (diff, glob, explicit paths)

**Write access:**
- Only the report file: `responsive-a11y-report.md` — written to the current working directory or user-specified path

**Prohibited:**
- Running a browser or headless renderer
- Installing npm packages or system dependencies
- Modifying source files
- Executing build commands or dev servers

**Gating:**
- Any write or analysis operation beyond static file review requires user confirmation

---

## Response Style

- Be direct and concise
- Label each workflow step clearly
- Use structured output formats (headings, tables, lists) — not prose paragraphs
- When reporting findings, include file path, issue description, and severity
- When uncertain, state the limitation rather than guessing
