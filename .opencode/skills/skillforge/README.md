# SkillForge — Skill

Create, adapt, and audit agent skills from vague user needs.

---

## Installation

Place the `skillforge` folder under your project's `.opencode/skills/`:

```
.opencode/
└── skills/
    └── skillforge/
        ├── SKILL.md
        ├── README.md
        ├── templates/
        └── examples/
```

The skill activates automatically when OpenCode detects the SKILL.md file.

---

## Usage

Ask your agent to create, adapt, or audit a skill:

> "Make a skill that reviews my frontend code before PRs."
> "Update this skill to also check accessibility."
> "Audit the skill in .opencode/skills/deploy-check/."

SkillForge runs through 9 steps: Intent Analysis → Composition Analysis → Community Discovery → Questions → Skill Spec → Generate Files → Quality Audit → Usage Instructions.

---

## Reference

| File | Description |
|------|-------------|
| `SKILL.md` | Full workflow definition with output formats for each step |
| `templates/skill-spec.md` | Use to define a new skill before writing files |
| `templates/skill-audit.md` | Use to audit a generated skill for completeness |
| `templates/skill-readme.md` | Use to document a generated skill |
| `examples/` | Walkthrough showing the workflow applied to a frontend-review request |
