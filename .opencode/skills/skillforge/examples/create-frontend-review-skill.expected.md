# Expected SkillForge Output

> SkillForge processes the vague request through its 7-step workflow.

---

## Skill Intent Analysis

**Request summary:**
User wants an automated frontend code review skill that checks for styling, accessibility, and performance issues before PR submission.

**Identified purpose:**
Review frontend source files against a quality checklist before a PR is opened.

**Key signals:**
- Trigger pattern: User asks to "review frontend code" or "check before PR"
- Expected input: Frontend source files (JSX/TSX, CSS, JS/TS)
- Expected output: Structured review report with pass/fail per category
- Frequency estimate: Repeated (every PR)
- Workflow specificity: Generic (many projects need code review)

---

## Existing Skill Check

**Locally available skills:**
*(none — empty project)*

**Potential matches for this request:**
- "code-review" — generic skill, not frontend-specific
- "accessibility-check" — narrow scope, doesn't cover styling or performance

**Verdict:**
- [ ] An existing skill covers this request → recommend adaptation
- [x] No existing skill matches → recommend creation

**Note:** Live registry search is unavailable — this check is limited to locally available skills and may not reflect the full ecosystem.

**Decision:** Creating a new skill is appropriate. The workflow is repeated (every PR), high-value (catches issues before code review), and needs a custom output contract (structured review report).

---

## Blocking Questions

1. **Which frontend framework does your project use?** (React, Vue, Angular, or vanilla?) — The review rules differ significantly by framework; without this we cannot write accurate checks.
2. **Do you have an existing style guide or lint config?** (e.g. ESLint, Prettier, Stylelint) — If yes, the skill should delegate to those tools instead of duplicating rules.
3. **What file types should be reviewed?** (e.g. `.tsx`/`.jsx` only, or also `.css`, `.test.ts`, `.stories.tsx`?) — Defines the skill's search scope.

---

## Skill Spec

**Name:** `frontend-review`

**Trigger description:**
Activates when the user asks to review frontend code, check a PR, or audit UI components.

**Workflow steps:**
1. Collect scope — determine which files to review based on user input or diff
2. Run lint checks — delegate to ESLint/Prettier/Stylelint if configs exist
3. Accessibility audit — check for ARIA attributes, keyboard navigation, colour contrast
4. Performance scan — identify large bundles, missing lazy loading, render-heavy patterns
5. Style consistency — verify naming conventions, import order, file structure
6. Compile report — produce a structured pass/fail report per category

**Input contract:**
- Target file paths, glob patterns, or a git diff
- Optional: framework name, lint config paths

**Output contract:**
- `frontend-review-report.md` — structured report with per-category results
- Exit code: 0 (all pass), 1 (warnings), 2 (failures)

**Key behaviors:**
- Delegates to project lint tools when configs exist
- Skips non-frontend files automatically
- Reports actionable items with file:line references

**Edge cases:**
- Empty diff / no frontend files changed → report "nothing to review"
- Missing lint config → warn and do basic checks only
- Generated files (e.g. `build/`, `.next/`) → always excluded

**Do-not behaviors:**
- Do not modify source files
- Do not run destructive commands (install, build, deploy)
- Do not enforce personal style preferences not in the project config

---

## Generated File Plan

### `.opencode/skills/frontend-review/SKILL.md`
Full skill file with 6-step workflow, trigger patterns, and output formats for each step.

### `.opencode/skills/frontend-review/README.md`
Installation instructions, usage prompt, and example workflow walkthrough.

### `.opencode/skills/frontend-review/templates/report.md`
Template for the structured review report output.

---

## Skill Quality Audit

**Skill:** `frontend-review`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Metadata present | PASS | Name, description, and compatibility defined in spec |
| Purpose clear | PASS | "Review frontend source files against a quality checklist before a PR is opened" |
| Workflow complete | PASS | 6 steps from scope collection to report compilation |
| Output formats defined | PASS | Report format (`frontend-review-report.md`) and exit codes specified |
| Do-not rules present | PASS | No source modification, no destructive commands, no personal style enforcement |
| Trigger clarity | PASS | "Review frontend code" or "check before PR" — precise enough |
| No assumptions as facts | PASS | Framework, lint config, and file types all gated by blocking questions |
| Safety constraints | PASS | Read-only by design; generated files excluded; build/deploy prohibited |
| Naming convention followed | PASS | `frontend-review` — lowercase, hyphenated, noun-first |

**Overall:** PASS

**Fixes applied:** None needed

---

## Usage Instructions

**Install:** Place the skill folder under `.opencode/skills/frontend-review/`.

**Verify:** Run: *"Review my frontend code before I open a PR"* — confirm the skill activates and produces a report.

**Files created:**
- `.opencode/skills/frontend-review/SKILL.md`
- `.opencode/skills/frontend-review/README.md`
- `.opencode/skills/frontend-review/templates/report.md`
