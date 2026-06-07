# Skill Quality Audit

> Use this template to audit a generated skill file for completeness and safety.

---

**Skill audited:** <!-- skill-name -->

## Scoring

| Criterion | Status | Notes |
|-----------|--------|-------|
| **Metadata present** | PASS / FAIL | YAML front matter or metadata block with name, description, compatibility |
| **Purpose clear** | PASS / FAIL | A single paragraph explaining why the skill exists and when it activates |
| **Workflow complete** | PASS / FAIL | All workflow steps are documented with clear transition conditions |
| **Output formats defined** | PASS / FAIL | Every workflow step has a documented output format |
| **Do-not rules present** | PASS / FAIL | Explicit prohibitions on dangerous or unwanted behaviors |
| **Trigger clarity** | PASS / FAIL | The trigger pattern is precise enough to avoid false positives |
| **No assumptions as facts** | PASS / FAIL | The skill does not assert untested assumptions as established facts |
| **Safety constraints** | PASS / FAIL | Limits on destructive operations, external writes, or sensitive data exposure |
| **Naming convention followed** | PASS / FAIL | Name follows lowercase-with-hyphens convention; noun-first; max 4 words |

**Overall:** PASS / FAIL

**Fixes applied:** <!-- list of fixes, or "none needed" -->
