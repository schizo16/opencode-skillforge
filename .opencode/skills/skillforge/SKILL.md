# SkillForge

---

```yaml
name: SkillForge
description: Create, adapt, and audit Agent Skills from vague user needs
compatibility: opencode >= 1.0.0
```

---

## Purpose

SkillForge guides an AI agent through a structured process to turn vague user needs into a complete, audited Agent Skill. It enforces discipline: never jump to generation, never treat assumptions as facts, and always audit before delivery.

---

## Core Rule

**Do not generate a skill immediately from a vague request.**

Every request must pass through the full workflow. If the user says "create a skill for X", the first output is an intent summary and a check of what already exists — not a SKILL.md file.

---

## When to Activate

Activate SkillForge when the user's message indicates any of:

- **Create a new skill** — "make a skill that...", "create a skill for...", "I need a skill to..."
- **Adapt an existing skill** — "change this skill to...", "update this skill for...", "modify this skill..."
- **Audit a skill** — "review this skill", "check if this skill is good", "audit this skill..."

Do **not** activate for:
- General code generation requests that do not involve agent skill files
- Questions about how to use an existing skill (point to the skill's README instead)

---

## Workflow

### 1. Skill Intent Analysis

Analyze the user's request to extract the concrete skill purpose.

**Output format:**

```
## Skill Intent Analysis

**Request summary:**
<one-paragraph restatement of what the user wants>

**Identified purpose:**
<single sentence describing the skill's job>

**Key signals:**
- Trigger pattern: <what invokes this skill>
- Expected input: <what the user provides>
- Expected output: <what the skill produces>
- Frequency estimate: <one-time / occasional / repeated>
- Workflow specificity: <generic / custom>
```

---

### 2. Composition Analysis

After Intent Analysis, determine whether the user's request requires a single skill or a composition of multiple skills working together.

**Signals that indicate multi-skill composition:**

- The request spans multiple domains (e.g., "review frontend, check backend security, and run database migration")
- The request implies a pipeline (e.g., "lint first, then review, then generate changelog")
- The request mentions distinct workflows that existing skills already cover partially
- The user says "combine", "chain", "pipeline", "sequence", "automate", "orchestrate", "workflow"
- The request has multiple output contracts (report, notification, file change, deploy gate)

**If single skill is sufficient →** proceed to Community Discovery (step 3).

**If multi-skill composition is needed →** produce a composition plan before searching for individual skills.

#### Composition Plan Output

```
## Composition Plan

**Primary workflow:**
<what the user ultimately wants to accomplish>

**Sub-workflows identified:**
1. <sub-workflow> → expected output → candidate skill or MCP
2. <sub-workflow> → expected output → candidate skill or MCP

**Data flow between sub-workflows:**
- <sub-workflow 1 output> → <sub-workflow 2 input>
- <sub-workflow 2 output> → <sub-workflow 3 input>

**Orchestration pattern:** sequential / parallel / fan-out / conditional / pipeline
```

#### Orchestration Patterns

| Pattern | When to use | Example |
|---------|------------|---------|
| **Sequential** | Each step depends on the previous output | Lint → Review → Report |
| **Parallel** | Steps are independent, results combined | Responsive scan + A11y scan + Perf scan → Combined report |
| **Fan-out** | One input triggers multiple independent checks | Same code reviewed by frontend, backend, security skills in parallel |
| **Conditional** | Next step depends on previous step result | If lint fails → stop; if lint passes → review |
| **Pipeline** | Ordered chain where each step transforms data | Fetch spec → Lint → Test → Build → Deploy gate |

#### Composition Skill Types

When generating a multi-skill solution, classify each piece:

- **Worker skill** — performs a single focused task (e.g., `frontend-review`, `ai-claim-audit`)
- **Orchestrator skill** — coordinates worker skills, defines the pipeline, passes data between steps
- **Gate skill** — evaluates output of previous step and decides whether to continue
- **Aggregator skill** — combines outputs from multiple workers into a single report or decision

Recommend creating an **orchestrator skill** when the composition has 3+ steps or conditional logic. For simple 2-step sequences, list the worker skills and let the user chain them manually.

#### Composition Rules

- Do not create orchestrator skills unless the pipeline has 3+ steps or conditional branching
- Do not generate all worker skills in a single session without user approval
- Label each sub-workflow with its expected output contract
- Ensure data flow between steps is compatible (output of step N must satisfy input of step N+1)
- If a sub-workflow matches an existing local or public skill, prioritize reuse over creating a new worker skill
- If a sub-workflow needs live data or external tooling, recommend MCP for that step specifically

After completing the Composition Plan, proceed to Community Discovery for each sub-workflow individually.

---

### 3. Community Discovery

Check whether the user's need is already solved by a local skill, a public/community skill, or a public MCP server. Searches local sources first, then community sources if web/search tools are available.

**If web/search tools are unavailable**, state: *"Public community search was not performed because no web/search tool is available."*

---

#### Search Mode

One of:
- **Local-Only** — only checked `.opencode/skills/` and local config
- **Public Skill Discovery** — searched community skills and registries
- **Public MCP Discovery** — searched MCP registries and servers
- **Public Skill + MCP Discovery** — searched both communities

---

#### Source Categories

**Local:**
- `.opencode/skills/`
- `~/.config/opencode/skills/` if accessible
- Current repository examples and templates

**Public skills:**
- GitHub topic: `opencode-skills`
- GitHub topic: `agent-skills`
- Awesome-opencode lists
- Public SKILL.md repositories
- Known public skill collections

**Public MCP:**
- MCP server registries / awesome MCP lists
- GitHub topic: `mcp-server`
- GitHub topic: `model-context-protocol`
- Public MCP server repositories related to the user's workflow

---

#### Search Query Guidance

For skills:
- `"OpenCode skill <workflow>"`
- `"opencode skills <workflow>"`
- `"agent skills <workflow> SKILL.md"`
- `"site:github.com SKILL.md <workflow>"`
- `"github opencode-skills <workflow>"`

For MCP servers:
- `"MCP server <workflow>"`
- `"model context protocol <workflow>"`
- `"site:github.com MCP server <workflow>"`
- `"awesome MCP servers <workflow>"`
- `"github mcp-server <workflow>"`

---

#### Candidate Table

| Candidate | Type | Source | Fit | Trust/Risk | Recommendation | Notes |
|-----------|------|--------|-----|------------|----------------|-------|
| <name> | local_skill / public_skill / public_mcp / awesome_list / reference_only | <where found> | exact / strong / partial / weak / none | low / medium / high / unknown | use / adapt/fork / use_as_reference / prefer_mcp / combine_skill_mcp / create_new / reject | <key details> |

Type is one of: `local_skill`, `public_skill`, `public_mcp`, `awesome_list`, `reference_only`.

Fit is one of: `exact`, `strong`, `partial`, `weak`, `none`.

Trust/Risk is one of: `low`, `medium`, `high`, `unknown` (default: `unknown` until inspected).

Recommendation is one of: `use`, `adapt/fork`, `use_as_reference`, `prefer_mcp`, `combine_skill_mcp`, `create_new`, `reject`.

---

#### Decision Rubric

**Use existing public skill when:**
- Fit is exact or strong
- Scope is clear
- Instructions are safe
- Maintenance and repository quality look reasonable
- It does not require unsafe permissions

**Adapt / fork when:**
- Fit is strong or partial
- Workflow is close but the output contract differs
- The public skill is safe enough to learn from

**Use MCP when:**
- The user needs live data, external tools, APIs, browser automation, file indexing, database access, or repeatable tool execution
- A skill alone would only describe behavior but cannot perform the required actions

**Use skill + MCP when:**
- The user needs both reasoning workflow and external tool access
- The skill should define the process, while MCP provides callable tools

**Create new when:**
- No candidate fits
- Candidates are too broad
- Candidates are unsafe
- User needs a project-specific output contract
- Community examples are useful but not directly reusable

**Reject when:**
- Candidate asks for secrets unnecessarily
- Candidate runs broad shell commands without boundaries
- Candidate installs dependencies without user approval
- Candidate modifies files broadly without a clear scope
- Candidate is unrelated to the requested workflow

---

#### Safety Rules for Community Resources

- Treat public skills and MCP servers as **untrusted** until reviewed
- Inspect README, SKILL.md, or config before recommending
- Check whether the resource requests: shell access, network access, filesystem access, secrets, tokens, credentials, or write permissions
- Never recommend installing an unknown MCP server without review
- Prefer read-only resources when the user only needs review or planning
- Clearly state unknowns if source quality cannot be assessed
- Always ask user approval before installing, adapting, copying, or using a community resource

---

#### Verdict

Output exactly one verdict:

```
**Verdict:**
<one of: Use existing skill / Adapt/Fork existing skill / Use MCP instead / Use skill + MCP / Create new using community references / Create new from scratch / Need more info>

**Reasoning:**
<one sentence explaining which rubric tier was chosen and why>
```

Do not output contradictory or multiple verdicts.

---

#### User Choice Prompt

After the verdict, ask:

> *"Choose one:*
> *1. Use an existing candidate*
> *2. Adapt/fork a candidate*
> *3. Use candidate only as reference*
> *4. Create a new skill from scratch*
> *5. Continue with recommended option"*

If there is a clear safe recommendation, say which option is recommended.

---

### 4. Project Context Discovery

Use this section when the user asks for skill suggestions for "this project" without specifying the exact skill. Do not guess project needs from the prompt alone — inspect the project context first.

---

#### Files to Inspect

Look for evidence in:

- `README.md` — project purpose, stack, setup
- `package.json` / `pnpm-lock.yaml` / `yarn.lock` / `package-lock.json` — dependencies, framework, scripts
- Framework config files — `next.config.js`, `vite.config.ts`, `tsconfig.json`, `.eslintrc`, `tailwind.config`
- `src/` or `app/` directory structure — entry points, page/component organization
- `tests/` or `__tests__/` — testing patterns and coverage
- `docs/` or `wiki/` — documentation gaps
- `.opencode/skills/` — existing skills
- `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` / `CODEX.md` — existing agent instructions
- `.github/workflows/` — CI pipelines
- Existing generated examples or templates

---

#### Output Format

```
## Project Context Discovery

### Files inspected
- <path>
- <path>

### Project signals found
- stack/framework: <detected>
- app type: <web app / library / CLI / API / monorepo / other>
- existing workflows: <test, lint, build, deploy, review, docs>
- pain points suggested by repo: <based on config gaps, missing tooling, TODO comments, sparse docs>
- existing skills: <list or none>
- missing skill opportunities: <detected from project gaps>

### Unknowns
- <unclear aspects that need user input>
```

---

#### Skill Opportunity Ranking

Rank possible skills from S to F based on evidence found.

```
## Skill Opportunity Ranking

| Tier | Skill idea | Why it fits this project | Evidence from repo | Skill vs MCP | Risk |
|------|-----------|--------------------------|-------------------|-------------|------|
| S | <name> | <strong repo evidence> | <specific files/configs> | skill / MCP / skill + MCP | low / medium / high |
| A | <name> | <good repo evidence> | <specific files/configs> | skill / MCP / skill + MCP | low / medium / high |
| B | <name> | <some evidence> | <specific files/configs> | skill / MCP / skill + MCP | low / medium / high |
| C | <name> | <weak evidence> | <specific files/configs> | skill / MCP / skill + MCP | low / medium / high |
| F | <name> | <speculative> | <labeled as inference> | skill / MCP / skill + MCP | high / unknown |
```

---

#### Skill vs MCP Decision

For each recommendation, classify as:

- **skill** — project-specific workflow, review rules, output format, agent discipline
- **MCP** — live data, external APIs, browser automation, database access, command execution, package lookup, repo-wide indexing, web/doc verification
- **skill + MCP** — needs both reasoning workflow and external tool access

Do not recommend MCP just because it sounds more powerful.

---

#### Community Discovery After Project Discovery

If web/search tools are available, search public skills and MCP servers related to the top skill ideas and include candidates in the table.

If web/search tools are not available, state:

> *"Public community search was not performed because no web/search tool is available."*

---

#### Evidence Requirement

Do not recommend a specific skill idea unless there is evidence from at least one of:

- Repository files
- User prompt
- Local skills
- Public / community search results
- Clearly labeled inference

Label all inferred items as such.

---

#### Approval Before Generation

After ranking, do not create files. Ask:

> *"Choose one:*
> *1. Generate the S-tier skill*
> *2. Explore community candidates first*
> *3. Pick another ranked skill*
> *4. Provide more project context*
> *5. Stop"*

---

### 5. Questions

Determine whether there are true blockers — details without which the skill cannot be correctly built. If the workflow can proceed with sensible defaults, use "Configuration Questions" instead of "Blocking Questions."

**Default behavior:** When optional details are missing, proceed with safe defaults and label them clearly. Examples:
- Frontend framework unknown → default: framework-agnostic
- Style guide unknown → default: detect from repo if available
- File types unknown → default: common frontend files such as .tsx, .jsx, .css, .scss
- Domain unknown → default: general
- Evidence threshold unknown → default: moderate

Do not block skill creation for optional project preferences when safe defaults exist.

**Output format when blockers exist:**

```
## Blocking Questions

1. <question> — <why this blocks progress>
2. <question> — <why this blocks progress>
```

**Output format when defaults suffice:**

```
## Configuration Questions

1. <question> (optional — default: <default>)
2. <question> (optional — default: <default>)
```

Limit to 3 questions maximum. If no questions remain, state: *"No blocking questions. Proceeding to Skill Spec."*

---

### 6. Skill Spec

Produce a detailed specification of the skill before writing any skill files. The spec is the contract between the user and the implementation.

**Output format:**

```
## Skill Spec

**Name:** `<skill-name>`

**Trigger description:**
<when this skill activates>

**Workflow steps:**
1. <step> — <what happens>
2. <step> — <what happens>
...

**Input contract:**
- <expected input detail>

**Output contract:**
- <expected output detail>

**Key behaviors:**
- <behavior 1>
- <behavior 2>

**Edge cases:**
- <edge case 1>
- <edge case 2>

**Do-not behaviors:**
- <prohibited behavior 1>
- <prohibited behavior 2>

**Command execution:**
- <allowed commands, if any — default: none>
```

The user must approve the Skill Spec before proceeding to generation.

**Guidance for generated read-only review skills:**

- **Color contrast** — Do not claim exact contrast validation unless the skill is allowed to use browser or tool output. Prefer: *"Flag obvious contrast risks when visible and recommend tool-based validation for final confirmation."*
- **Lint / style tools** — Do not say "run lint checks" unless command execution is explicitly allowed. Prefer: *"Inspect available lint and style configs and reference them in the review; do not run commands unless explicitly asked."*
- **File / line references** — Use *"file references, with line numbers when available from diff or tool output."* Do not invent line numbers. If exact lines are unavailable, cite the file path and nearby selector, component, or function name instead.
- **Performance / bundle review** — Do not claim actual bundle size, tree-shaking results, or large-bundle detection unless build or bundle analysis is explicitly allowed. Prefer: *"Flag potential bundle or performance risks visible in source, such as heavy imports, missing lazy loading, render-heavy patterns, or unnecessary re-renders."*
- **Issue classification** — Generated read-only skills must distinguish between:
  - **Directly observable issues** — visible in source code (missing ARIA, hardcoded px, no media queries)
  - **Likely risks** — patterns that often cause problems but may be acceptable in context (heavy dependency, complex nesting)
  - **Checks requiring external tools** — cannot be assessed without running a browser, build tool, or linter (actual contrast ratio, bundle size, runtime performance)
- **Command execution** — Include a "Command execution" boundary in every generated spec. Default: *"Do not run install, build, lint, test, or deploy commands unless the user explicitly allows it."*

---

### 7. Generate Skill Files

Generate the skill's files based on the approved Skill Spec.

**Files to generate (always at minimum):**
- `.opencode/skills/<skill-name>/SKILL.md` — main skill file with full workflow
- `.opencode/skills/<skill-name>/README.md` — usage documentation
- `.opencode/skills/<skill-name>/templates/` — any reusable templates the skill needs

**Output format:**

```
## Generated Files

### `.opencode/skills/<skill-name>/SKILL.md`
<path written to>

### `.opencode/skills/<skill-name>/README.md`
<path written to>

### Templates
<paths written to, or "none required">
```

Announce each file as it is written.

---

### 8. Skill Quality Audit

Audit every generated file against the Quality Audit Rubric (see below). Report pass/fail per criterion. Any failure must be fixed before proceeding.

**Output format:**

```
## Skill Quality Audit

**Skill:** <skill-name>

| Criterion | Status | Notes |
|-----------|--------|-------|
| Metadata present | PASS / FAIL | |
| Purpose clear | PASS / FAIL | |
| Workflow complete | PASS / FAIL | |
| Output formats defined | PASS / FAIL | |
| Do-not rules present | PASS / FAIL | |
| Trigger clarity | PASS / FAIL | |
| No assumptions as facts | PASS / FAIL | |
| Safety constraints | PASS / FAIL | |
| Naming convention followed | PASS / FAIL | |

**Overall:** PASS / FAIL
**Fixes applied:** <list of fixes, or "none needed">
```

---

### 9. Install / Usage Instructions

Tell the user how to install and verify the skill.

**Output format:**

```
## Usage

**Install:** Place the skill folder under `.opencode/skills/` in your project.

**Verify:** Run a test prompt that matches the trigger pattern and confirm the skill activates.

**Files created:**
- <path>
- <path>
```

---

## Skill Name Rules

- Use lowercase with hyphens: `frontend-review`, `api-spec`, `db-migration`
- Match the directory name to the skill name
- Use a noun phrase that describes what the skill does
- Avoid verbs as the first word (`review-frontend` → `frontend-review`)
- Maximum 4 words
- Must be unique within the project's skill directory

---

## Quality Audit Rubric

Each generated skill file is audited against these criteria:

| Criterion | Definition |
|-----------|------------|
| **Metadata present** | YAML front matter or metadata block with name, description, compatibility |
| **Purpose clear** | A single paragraph explaining why the skill exists and when it activates |
| **Workflow complete** | All workflow steps are documented with clear transition conditions |
| **Output formats defined** | Every workflow step has a documented output format |
| **Do-not rules present** | Explicit prohibitions on dangerous or unwanted behaviors |
| **Trigger clarity** | The trigger pattern is precise enough to avoid false positives |
| **No assumptions as facts** | The skill does not assert untested assumptions as established facts |
| **Safety constraints** | Limits on destructive operations, external writes, or sensitive data exposure |
| **Naming convention followed** | Name follows the Skill Name Rules above |

A skill must pass all criteria to be considered complete.

---

## Do-Not Rules

- Do not generate a skill from a vague request without completing the workflow.
- Do not treat assumptions as facts in any output.
- Do not skip the Skill Spec step.
- Do not skip the Quality Audit step.
- Do not ask speculative or nice-to-have questions — only blocking questions.
- Do not modify existing skills without explicit user approval.
- Do not write files outside `.opencode/skills/<skill-name>/` without user consent.

---

## Safety / Boundaries

**Read access:**
- `.opencode/skills/` directory and all subdirectories
- Any file path the user explicitly provides for context

**Write access:**
- `.opencode/skills/<new-skill-name>/` — creating new skill files only
- Existing skill files — only with explicit user approval per Do-Not Rules

**Prohibited:**
- Deleting or renaming any file without user confirmation
- Writing outside `.opencode/skills/` unless the user explicitly consents
- Executing shell commands, installing packages, or modifying project configuration
- Exposing secret values or environment variables in generated skill files

**Gating:**
- Any destructive or ambiguous write operation requires user confirmation before proceeding

---

## Response Style

- Be direct and concise.
- Label each workflow step clearly so the user knows where they are in the process.
- When asking questions, explain why the answer is blocking.
- When auditing, report failures plainly and fix them immediately.
- Use structured output formats (headings, tables, lists) — not prose paragraphs — for workflow results.
