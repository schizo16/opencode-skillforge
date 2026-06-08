# Cross-Agent Compatibility

> SkillForge is OpenCode-first. This guide explains how its workflow can be adapted to other coding agents.

---

## Compatibility Table

| Agent | Works directly? | Mechanism | Status |
|-------|---------------|-----------|--------|
| OpenCode | Yes | `.opencode/skills/skillforge/SKILL.md` | Primary target. Fully supported. |
| Claude Code | Partial | Claude Agent Skill (same SKILL.md format) | Workflow is portable. Not fully tested. |
| Codex | Partial | `AGENTS.md` / `CODEX.md` project instructions | Workflow logic can be ported. Format differs. |
| Cursor | Partial | Cursor Rules / `AGENTS.md` | Workflow logic can be ported. Format differs. |
| Gemini CLI | Partial | Skill activation via tool mapping | Workflow is adaptable. Not tested. |
| Other agents | Partial | Custom instruction files | Workflow steps are reusable as guidelines. |

---

## What Works Directly

The following aspects of SkillForge are agent-agnostic:

- The workflow (Intent Analysis → Composition Analysis → Community Discovery → Project Context → Questions → Skill Spec → Quality Audit → Instructions)
- The `templates/` (skill-spec.md, skill-audit.md, skill-readme.md)
- The `examples/` (expected workflow outputs)
- The quality audit rubric
- The safety boundaries and do-not rules
- The decision rubrics for existing skills, MCP, and community resources

---

## What Needs Adaptation

| Feature | OpenCode | Other agents |
|---------|----------|--------------|
| Auto-activation | Uses `.opencode/skills/` convention | May require manual instruction-based activation |
| SKILL.md format | Native format | May need conversion to agent-specific instruction format |
| Tool references | OpenCode-native tools | Must be mapped to the target agent's tool set |
| Skill directory convention | `.opencode/skills/` | Each agent has its own convention for custom skills |

---

## Suggested Porting Structure

When adapting SkillForge to another agent, preserve:

1. **Workflow sequence** — keep the 7 steps in order
2. **Output formats** — keep the structured headings, tables, and code blocks
3. **Safety rules** — keep all do-not rules and safety boundaries
4. **Decision rubrics** — keep the fit-level rubric, skill-vs-MCP rubric, and community safety rules
5. **Audit rubric** — keep the 9-criterion quality audit

Adapt:

1. **Activation triggers** — rewrite for the target agent's trigger mechanism
2. **File paths** — adjust `.opencode/skills/` to the target agent's skill directory
3. **Tool names** — replace OpenCode tool names with equivalent tools in the target agent

---

## Warnings

- **Not tested** — SkillForge has not been fully tested on Claude Code, Codex, Cursor, Gemini CLI, or other non-OpenCode agents. The workflow is designed to be portable, but actual behavior depends on each agent's implementation.
- **No native support claims** — Do not claim "native support" for any agent unless verified through testing.
- **Review third-party resources** — Community skills, MCP servers, and public repositories referenced during Community Discovery should be reviewed for safety and relevance before use.
