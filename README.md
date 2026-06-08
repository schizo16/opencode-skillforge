# SkillForge

**Create better OpenCode skills from vague user requests.**

---

Most *"write me a skill"* prompts produce vague, assumptive skills. SkillForge makes the agent **interview, spec, generate, and audit** the skill before writing a single file — turning a fuzzy request into a reviewed, read-only skill you can trust.

---

## Before vs After

| Before (simple prompt) | After (SkillForge) |
|---|---|
| "Make a skill that reviews my frontend code." | Same prompt — but the agent first analyzes intent, checks existing skills, asks clarifying questions, writes a spec for approval, generates files, then audits the result. |
| AI immediately writes a vague `SKILL.md` with assumptions about your framework, tools, and workflow. | The agent waits for your spec approval before touching any file. |
| No spec. No audit. No safety boundaries. | 9-criterion quality audit. Explicit safety boundaries. Read-only by default. |

---

## How It Works

```text
Vague request
  ↓
Intent analysis
  ↓
Existing-skill check
  ↓
Questions / defaults
  ↓
Skill spec
  ↓
Generated file plan
  ↓
Quality audit
  ↓
User approval
  ↓
Generate skill files
```

SkillForge is an OpenCode skill. Install it, ask for a skill, and the agent walks through all 7 steps before writing anything.

---

## Quick Install

```bash
# macOS / Linux
curl -sSL https://raw.githubusercontent.com/schizo16/skillforge/main/install.sh | bash
```

```powershell
# Windows PowerShell
iex (Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/schizo16/skillforge/main/install.ps1')
```

[Manual install instructions →](INSTALL.md)

---

## Quick Verification

Run this in OpenCode:

> *"Use the SkillForge skill. Make a skill that reviews frontend code. Do not create files yet."*

Expected: Skill Intent Analysis, Existing Skill Check, and Configuration Questions — **not** a generated file.

[Full verification guide →](INSTALL.md#verify)

---

## Compatibility

| Agent | How to use SkillForge |
|-------|----------------------|
| **OpenCode** | Primary target. Place `.opencode/skills/skillforge/` in your project. The skill activates automatically via `SKILL.md`. |
| **Claude Code** | The workflow can be adapted as a Claude Agent Skill using the same `SKILL.md` format. Follow Claude Code's skill installation process. |
| **Codex** | The workflow can be ported into `AGENTS.md` or `CODEX.md` as structured project instructions. |
| **Cursor** | The workflow can be adapted into Cursor Rules or `AGENTS.md`. |
| **Other agents** | The 7-step workflow can be used as reusable project instructions for any coding agent that supports custom rules or instructions. |

SkillForge is **OpenCode-first**. Support for other agents requires adaptation and has not been fully tested. See [`docs/compatibility.md`](docs/compatibility.md) for detailed porting guidance.

---

## File Structure

```
skillforge/
├── README.md                         # This file
├── INSTALL.md                        # Install and verification guide
├── demo.md                           # Browse generated skill examples
├── install.sh                        # macOS/Linux install script
├── install.ps1                       # Windows install script
├── LICENSE
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
                ├── create-frontend-review-skill.input.md
                ├── create-frontend-review-skill.expected.md
                ├── create-responsive-a11y-review-skill.expected.md
                ├── create-ai-claim-audit-skill.input.md
                └── create-ai-claim-audit-skill.expected.md
```

---

See [`demo.md`](demo.md) and [`.opencode/skills/skillforge/examples/`](.opencode/skills/skillforge/examples/) for complete workflow walkthroughs.

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

## Verification

No-code manual checks for v0.1.1:

1. **Skill file exists** — confirm `.opencode/skills/skillforge/SKILL.md` is present in your project.
2. **Agent does not jump to generation** — ask: *"Make a skill that reviews frontend code."* The first output should be Skill Intent Analysis, Existing Skill Check, and Blocking/Configuration Questions — not a generated SKILL.md file.
3. **[Browse examples →](.opencode/skills/skillforge/examples/)** — complete workflow walkthroughs.
4. **[Browse generated skills →](demo.md)** — skills produced by SkillForge: `responsive-a11y-review`, `ai-claim-audit`.

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
