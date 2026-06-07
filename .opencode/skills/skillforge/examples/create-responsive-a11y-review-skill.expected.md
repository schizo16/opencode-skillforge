# Expected SkillForge Output

> SkillForge processes the vague request through its 7-step workflow.

---

## Skill Intent Analysis

**Request summary:**
User wants a skill that reviews frontend UI changes — specifically catching responsive design breakage and accessibility regressions — before they ship. The concern is that these issues are easy for both humans and AI to overlook.

**Identified purpose:**
Audit frontend UI changes for responsive layout breakage and accessibility violations before deployment.

**Key signals:**
- Trigger pattern: "review UI changes", "check responsive/a11y", "audit frontend before deploy"
- Expected input: Frontend source diff or file paths (HTML, CSS, JSX/TSX)
- Expected output: Structured report of responsive and accessibility issues with file references, and line numbers when available from diff/tool output
- Frequency estimate: Repeated (every PR with UI changes)
- Workflow specificity: Custom — combines two specialized domains (responsive + a11y) into one review

---

## Existing Skill Check

**Locally available skills:**
- `frontend-review` — generic frontend review skill (covers styling, a11y, perf broadly but shallowly)

**Potential matches for this request:**
- `frontend-review` — includes a11y and style checks but has no dedicated responsive review logic

**Verdict:**
- [x] Partial overlap — `frontend-review` covers accessibility at a general level, but does not include responsive checks or a combined responsive/a11y report format

**Decision:** A specialized skill is justified. The request targets two specific domains (responsive + a11y) that require dedicated review logic, viewport-aware analysis, and a combined report format. A generic review skill would treat both categories as shallow checklist items. Creating a new skill is the right call.

---

## Blocking Questions

No blockers. The skill works with sensible defaults.

1. **Which frontend framework?** (optional — default: framework-agnostic) — The skill checks common responsive and a11y patterns regardless of framework. Framework-specific hints (React `aria-` props, Vue `v-bind` class bindings) can be enabled if you tell us, but are not required.
2. **What viewport breakpoints?** (optional — default: 375px, 768px, 1024px, 1440px) — These cover mobile, tablet, laptop, and desktop. Custom breakpoints can be provided later; the skill proceeds with presets by default.
3. **Existing a11y tools?** (optional — default: manual checklist) — The skill scans the repo for `axe-core`, `@axe-core/react`, or Lighthouse configs. If found, it delegates to those. If not, it uses a built-in manual checklist and recommends adding tooling.

---

## Skill Spec

**Name:** `responsive-a11y-review`

**Trigger description:**
Activates when the user asks to review UI changes, check responsive layout, audit accessibility, or "review frontend before deploy."

**Workflow steps:**
1. **Collect scope** — resolve target files from diff, glob, or explicit paths; exclude non-UI files (`.test.*`, `.stories.*`, `build/`)
2. **Responsive scan** — for each layout-relevant file (CSS, JSX/TSX with styles), check for viewport-aware patterns: media queries, relative units, fixed widths, overflow handling
3. **Accessibility scan** — check for: ARIA attributes, focus management, flag obvious contrast risks from inline styles, class names, or design tokens when visible; recommend browser/tool-based validation for final confirmation; keyboard navigation, alt text
4. **Compare with tools** — if axe-core or Lighthouse configs are detected, cross-reference results and note gaps
5. **Compile report** — produce `responsive-a11y-report.md` with review status (PASS/WARN/FAIL), per-category findings, severity, and file references (with line numbers when available)

**Input contract:**
- Target file paths, glob patterns, or a git diff (e.g. `main...HEAD`)
- Optional: breakpoint overrides, framework name, axe/Lighthouse config path

**Output contract:**
- `responsive-a11y-report.md` — structured report with two sections (Responsive, Accessibility), each with per-check status and an overall review status of PASS (no blocking issues), WARN (non-blocking concerns), or FAIL (blocking responsive/a11y regressions)

**Key behaviors:**
- Viewport presets apply automatically; custom breakpoints override them
- Detects framework patterns when framework is specified; stays generic otherwise
- Cross-references CI a11y tool output when available; does not duplicate it
- Skips non-UI files automatically

**Edge cases:**
- No UI files changed → report "nothing to review"
- No CSS or style files → responsive section reports "no style changes to review"
- No a11y tooling found → uses manual checklist and recommends installation

**Do-not behaviors:**
- Do not run a browser, take screenshots, or perform visual diffing
- Do not modify source files
- Do not enforce framework-specific patterns unless the framework is explicitly confirmed
- Do not fail on missing a11y tooling — flag as warning, not failure
- Do not invent line numbers. If exact lines are unavailable, cite the file path and nearby selector/component instead

---

## Generated File Plan

### `.opencode/skills/responsive-a11y-review/SKILL.md`
Full skill file with the 5-step workflow, trigger patterns, output formats, viewport presets, and a11y checklist.

### `.opencode/skills/responsive-a11y-review/README.md`
Installation instructions, usage prompt, and example workflow walkthrough.

### `.opencode/skills/responsive-a11y-review/templates/report.md`
Template for the responsive + accessibility report output.

---

## Skill Quality Audit

**Skill:** `responsive-a11y-review`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Metadata present | PASS | Name, description, compatibility defined in spec |
| Purpose clear | PASS | "Audit frontend UI changes for responsive layout breakage and accessibility violations" |
| Workflow complete | PASS | 5 steps from scope collection to report compilation |
| Output formats defined | PASS | Report format (`responsive-a11y-report.md`) with review status (PASS/WARN/FAIL) specified |
| Do-not rules present | PASS | No browser/visual-diff, no source modification, no unconfirmed framework enforcement, no invented line numbers |
| Trigger clarity | PASS | "Review UI changes", "check responsive/a11y", "audit frontend before deploy" |
| No assumptions as facts | PASS | Framework, breakpoints, and a11y tooling all configurable with documented defaults |
| Safety constraints | PASS | Read-only; no install/build/deploy; no screenshots or visual diffing |
| Naming convention followed | PASS | `responsive-a11y-review` — lowercase, hyphenated, noun-first, max 4 words |

**Overall:** PASS

**Fixes applied:** None needed

---

## Usage Instructions

**Install:** Place the skill folder under `.opencode/skills/responsive-a11y-review/`.

**Verify:** Run: *"Review my frontend UI changes for responsive and a11y problems"* — confirm the skill activates and produces a report.

**Files created:**
- `.opencode/skills/responsive-a11y-review/SKILL.md`
- `.opencode/skills/responsive-a11y-review/README.md`
- `.opencode/skills/responsive-a11y-review/templates/report.md`
