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

### 2. Existing Skill Check

Check whether an existing skill already covers the request. Consult available skill registries, file systems under `.opencode/skills/`, and any referenced skill directories.

**If live search (e.g. web fetch, registry API) is unavailable**, state: *"Live registry search is unavailable — this check is limited to locally available skills and may not reflect the full ecosystem."*

**Output format:**

```
## Existing Skill Check

**Locally available skills:**
- <skill name> — <brief description>
- <skill name> — <brief description>

**Potential matches for this request:**
- <skill name> — <why it might fit, or "none found">

**Verdict:**
- [ ] An existing skill covers this request → recommend adaptation
- [ ] No existing skill matches → recommend creation
```

**Decision rule:**
- Prefer **adapting** an existing skill when the request is generic or when a similar skill exists with minor differences.
- Prefer **creating** a new skill when the workflow is specific, repeated, high-value, or needs a custom output contract.

---

### 3. Blocking Questions

Ask only questions that would block progress — clarifications without which the skill cannot be correctly built. Do not ask nice-to-have questions.

**Output format:**

```
## Blocking Questions

1. <question>
2. <question>
```

Limit to 3 questions maximum. If no blocking questions remain, state: *"No blocking questions. Proceeding to Skill Spec."*

---

### 4. Skill Spec

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
```

The user must approve the Skill Spec before proceeding to generation.

---

### 5. Generate Skill Files

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

### 6. Skill Quality Audit

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

### 7. Install / Usage Instructions

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
