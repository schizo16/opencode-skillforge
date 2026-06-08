# SkillForge — Promotion

Assets and copy for sharing SkillForge publicly.

---

## One-Liner

Create better OpenCode skills from vague user requests.

---

## Short Description

SkillForge is an OpenCode skill that walks an AI agent through a 7-step workflow — intent analysis, existing-skill check, blocking questions, spec, generation, quality audit, and usage instructions — before writing a single file. It turns vague "write me a skill" prompts into reviewed, read-only skills with explicit safety boundaries.

---

## Longer Description

Most AI skill generation works like this: you type "make a skill that reviews my frontend code," and the agent immediately writes a vague `SKILL.md` filled with assumptions about your framework, tools, and workflow. No spec. No audit. No safety boundaries.

SkillForge changes that. It's an OpenCode skill that intercepts "create a skill" requests and runs a disciplined 7-step workflow before writing anything:

1. **Skill Intent Analysis** — restates the request and extracts purpose, trigger pattern, and expected input/output
2. **Existing Skill Check** — looks for locally available skills that could be adapted instead of created from scratch
3. **Configuration / Blocking Questions** — asks only what would block progress; uses sensible defaults when possible
4. **Skill Spec** — produces a written contract covering workflow, input/output contracts, edge cases, and do-not behaviors
5. **Generate Skill Files** — creates `SKILL.md`, `README.md`, and templates from the approved spec
6. **Skill Quality Audit** — scores the generated skill against 9 criteria; blocks release until all pass
7. **Usage Instructions** — tells the user how to install and verify

SkillForge treats skill creation as engineering, not prompting. It is read-only by default, never assumes facts the user hasn't confirmed, and audits every generated file before declaring it complete.

---

## Social Post (X / Twitter)

```
Most AI agents write skills the wrong way:
"Make a skill" → immediately vague SKILL.md with assumptions.

SkillForge fixes this.

7-step workflow. User-approved spec. Quality audit. Read-only by default.

Open-source, OpenCode-first:
github.com/schizo16/opencode-skillforge
```

---

## Reddit / Discord Post

```
I built SkillForge — an OpenCode skill that creates other skills properly.

Most "write me a skill" prompts produce vague, assumptive skills. SkillForge makes the agent interview, spec, generate, and audit before writing anything.

7 steps:
1. Intent analysis
2. Existing skill check (no redundant skills)
3. Blocking/configuration questions (max 3)
4. User-approved spec
5. File generation
6. 9-criterion quality audit
7. Usage instructions

No CLI, no MCP, no plugin — just an OpenCode skill you drop into your project.
Read-only. No assumptions. Audited output.

https://github.com/schizo16/opencode-skillforge

Would love feedback from anyone building agent workflows.
```

---

## GitHub Awesome-List Entry

- [SkillForge](https://github.com/schizo16/opencode-skillforge) — OpenCode skill that creates, adapts, and audits other skills from vague user requests using a 7-step structured workflow.

---

## Alternate Taglines

1. *Stop guessing. Start specifying. SkillForge audits skills before they exist.*
2. *From "make a skill" to a reviewed spec in 7 steps.*
3. *Your agent's skill generator, but with a spec review gate.*
4. *Skill engineering, not skill prompting.*
5. *Vague ideas → audited skills. No shortcuts.*

---

## Screenshot / Demo Ideas

1. **Before/After comparison** — side-by-side: naive agent output vs SkillForge structured output for the same prompt
2. **Workflow step screencap** — the 7-step ASCII diagram from the README as a clean graphic
3. **Spec approval moment** — showing the Skill Spec output and the user's approval before generation
4. **Quality audit pass** — the 9-criterion table showing all PASS
5. **Generated skill tree** — `demo.md` file tree showing what SkillForge produced

---

## Suggested GitHub Topics

```
opencode
opencode-skill
agent-skills
ai-agent
skill-creation
skill-audit
developer-tools
open-source
```
