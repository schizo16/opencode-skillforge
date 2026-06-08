# SkillForge

**Create, adapt, and audit agent skills — from vague idea to production-ready.**

---

## What Problem It Solves

Users ask for agent skills in vague terms: *"Make a skill that reviews my code"* or *"I need something to check my PRs."* A naive agent generates a skill immediately — filling in missing details with assumptions, skipping safety checks, and producing something fragile.

SkillForge enforces a structured workflow: analyze intent, check what already exists, ask only blocking questions, write a spec, generate files, audit the result, and explain how to use it. It treats skill creation as engineering, not prompting.

---

## How It Works

SkillForge is an OpenCode skill that activates when you ask to create, adapt, or audit a skill. It follows 7 steps in sequence:

1. **Skill Intent Analysis** — restates the request and extracts purpose, trigger pattern, and frequency
2. **Existing Skill Check** — looks for local skills that could be adapted instead of created
3. **Blocking Questions** — asks only what would block progress (max 3)
4. **Skill Spec** — writes a spec contract for user approval before any file is touched
5. **Generate Skill Files** — produces SKILL.md, README.md, and templates from the approved spec
6. **Skill Quality Audit** — scores the generated skill against 9 criteria; fails until all pass
7. **Install / Usage Instructions** — tells the user how to install and verify

---

## File Structure

```
skillforge/
├── README.md                         # This file
└── .opencode/
    └── skills/
        └── skillforge/
            ├── SKILL.md              # SkillForge's own workflow definition
            ├── README.md             # Skill-level documentation
            ├── templates/
            │   ├── skill-spec.md     # Spec template for new skills
            │   ├── skill-audit.md    # Audit scoring template
            │   └── skill-readme.md   # README template for new skills
            └── examples/
                ├── create-frontend-review-skill.input.md              # Vague request example
                ├── create-frontend-review-skill.expected.md           # Expected workflow output
                ├── create-responsive-a11y-review-skill.expected.md    # Expected workflow output
                ├── create-ai-claim-audit-skill.input.md               # Vague request example
                └── create-ai-claim-audit-skill.expected.md            # Expected workflow output
```

---

## Installation

1. Make sure you have OpenCode installed.
2. Clone or copy the `skillforge` folder into your project:

```bash
# From your project root
cp -r path/to/skillforge/.opencode .
```

3. Verify the skill is available:

```
.opencode/skills/skillforge/SKILL.md
```

4. Activate by asking your agent to create a skill:

> *"I need a skill that reviews my frontend code before PRs."*

---

## Usage Example

**User:** *"Make a skill that reviews my frontend code."*

SkillForge will:
1. Restate the intent and identify key signals (trigger, inputs, frequency)
2. Check for existing local skills that might already cover this
3. Ask 2–3 blocking questions (e.g. *"Which framework?"*, *"Do you have a lint config?"*)
4. Present a Skill Spec for your approval
5. Generate the skill files under `.opencode/skills/frontend-review/`
6. Audit the generated skill and report pass/fail per criterion
7. Tell you how to test it

See `examples/create-frontend-review-skill.expected.md` for a complete walkthrough.

---

## What Makes It Different

| Aspect | Simple "create-skill" prompt | SkillForge |
|--------|------------------------------|------------|
| Intent analysis | Assumes it knows what you want | Explicitly restates and confirms |
| Existing skills | Ignores them | Checks before creating |
| Questions | Anything that comes to mind | Only blocking questions (max 3) |
| Spec | None — generates immediately | Written contract, user-approved |
| Quality check | None | 9-criterion audit, fails until clean |
| Safety | Implicit | Explicit boundaries documented |

---

## Roadmap

1. **OpenCode skill** — SkillForge as a self-contained skill (current)
2. **MCP server** — expose SkillForge workflows via the Model Context Protocol for editor integration
3. **OpenCode plugin** — package as a plugin with auto-discovery and versioning
4. **CLI / GitHub Action** — standalone CLI for CI pipelines and non-OpenCode environments

---

## Limitations

- The existing-skill check only searches locally available skills — there is no global registry search
- SkillForge creates skill files but does not install or activate them; the user must place them in the correct directory
- Templates are Markdown-only; no programmatic validation of generated skills
- No version management or dependency resolution between skills

---

## License

MIT — see [LICENSE](LICENSE) for details.
