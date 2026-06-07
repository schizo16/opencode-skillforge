# ai-claim-audit

---

```yaml
name: ai-claim-audit
description: Audit AI-generated answers for unsupported claims, overconfident language, and weak evidence
compatibility: opencode >= 1.0.0
```

---

## Purpose

This skill reviews AI-generated text and identifies when the AI makes claims without supporting evidence, or sounds overconfident despite weak justification. It produces a structured claim ledger that separates what the AI asserts from what it assumes, infers, or treats as hypothetical — without consulting external sources or labeling claims as true or false.

---

## When to Activate

Activate when the user asks to audit, review, or check an AI answer for evidence quality, unsupported claims, or overconfident language:

- "audit this answer for evidence quality"
- "check this AI response for unsupported claims"
- "review confidence vs evidence in this answer"
- "identify assumptions and weakly supported claims"
- "analyze the claim types in this text"

Do **not** activate for:
- Requests to fact-check against external sources or the web
- Requests to verify whether a claim is true or false
- Requests to rewrite or improve the text

---

## Core Rule

**Do not verify claims against external sources.** This skill analyzes the text itself — it assesses whether evidence is present in the provided text, not whether the claim is factually correct.

---

## Workflow

### 1. Ingest Text

Accept input as inline text, a file path, or a block identified in the conversation.

**Output format:**

```
## Input

**Source:** <inline / file path / conversation block>
**Text length:** <word or character count>
```

### 2. Segment into Claims

Parse the input text into individual claim units — sentences or clauses that assert something. Group closely related claims where useful.

**Output format:**

```
## Segmented Claims

| # | Claim text | Source context |
|---|------------|---------------|
| 1 | <extracted claim> | <surrounding sentence or paragraph> |
| 2 | <extracted claim> | <surrounding sentence or paragraph> |
```

### 3. Classify Claim Type

Assign one of six categories to each claim:

- `factual_claim` — asserts a verifiable fact (dates, statistics, definitions, events, historical statements)
- `reasoning_claim` — asserts a logical or causal relationship ("X leads to Y", "because of Z")
- `assumption` — takes something for granted without justification
- `inference` — draws a conclusion from premises
- `opinion` — subjective statement, not verifiable
- `hypothetical_or_rhetorical` — "what if", "imagine", rhetorical questions — flag separately, do not grade

**Output format:**

```
## Claim Types

| # | Claim text | Type |
|---|------------|------|
| 1 | <claim> | factual_claim |
| 2 | <claim> | inference |
```

### 4. Grade Evidence Status

Assign one of five evidence statuses to each claim. Only grade `factual_claim`, `reasoning_claim`, `assumption`, and `inference`. Opinions and hypotheticals receive `not_applicable`.

- `supported_in_text` — the text provides direct evidence, quoted source, data, concrete example, or explicit reasoning that supports the claim
- `weak_support` — the text gives some reasoning or example, but it is incomplete, indirect, or not enough for the strength of the claim
- `needs_evidence` — the claim may be plausible, but the text provides no citation, data, example, source, or explicit support
- `unsupported` — the claim is presented as established or certain, but the text provides neither evidence nor reasoning, or the claim uses broad/absolute language without support
- `not_applicable` — used for opinions, hypotheticals, rhetorical questions, or subjective preferences

**Output format:**

```
## Evidence Status

| # | Claim text | Claim type | Evidence status |
|---|------------|------------|----------------|
| 1 | <claim> | factual_claim | supported_in_text |
| 2 | <claim> | inference | weak_support |
```

### 5. Flag Overconfidence

Scan each claim for strong certainty markers: "definitely", "always", "proven", "undoubtedly", "it is certain that", "without a doubt", "clearly", "obviously". Cross-reference against evidence status.

Flag a claim as overconfident only when strong certainty language is paired with `weak_support`, `needs_evidence`, or `unsupported`.

Do **not** flag appropriately hedged language ("may", "suggests", "could", "might", "possibly").

**Output format:**

```
## Overconfidence Flags

| # | Claim text | Confidence language | Evidence status | Flagged |
|---|------------|---------------------|----------------|---------|
| 1 | <claim> | "undoubtedly" | unsupported | YES |
| 2 | <claim> | "suggests" | weak_support | no |
```

### 6. Compile Claim Ledger

Produce a consolidated claim ledger with all findings.

**Output format:**

```
## ai-claim-audit-ledger

| # | Claim text | Claim type | Evidence status | Confidence language | Overconfidence flag | Recommendation |
|---|------------|------------|----------------|---------------------|--------------------|----------------|
| 1 | <claim> | factual_claim | supported_in_text | none | no | — |
| 2 | <claim> | inference | weak_support | "clearly" | YES | strengthen with direct evidence |

### Summary

- **Total claims:** <count>
- **By type:** factual_claim: <n>, reasoning_claim: <n>, assumption: <n>, inference: <n>, opinion: <n>, hypothetical_or_rhetorical: <n>
- **Unsupported:** <n> | **Needs evidence:** <n> | **Weak support:** <n>
- **Overconfidence flags:** <n>
- **Risk level:** low / moderate / high
```

---

## Skill Name Rules

- Use lowercase with hyphens: `ai-claim-audit`
- Match the directory name to the skill name
- Use a noun phrase describing what the skill does
- Avoid verbs as the first word
- Maximum 4 words
- Must be unique within the project's skill directory

---

## Quality Audit Rubric

| Criterion | Definition |
|-----------|------------|
| **Metadata present** | YAML or metadata block with name, description, compatibility |
| **Purpose clear** | Single paragraph explaining why the skill exists and when it activates |
| **Workflow complete** | All workflow steps documented with clear transition conditions |
| **Output formats defined** | Every workflow step has a documented output format |
| **Do-not rules present** | Explicit prohibitions on dangerous or unwanted behaviors |
| **Trigger clarity** | Trigger pattern precise enough to avoid false positives |
| **No assumptions as facts** | Skill does not assert untested assumptions as established facts |
| **Safety constraints** | Limits on destructive operations, external writes, sensitive data exposure |
| **Naming convention followed** | Name follows the Skill Name Rules |

A skill must pass all criteria to be considered complete.

---

## Do-Not Rules

- Do not verify claims against external sources or browse the web
- Do not mark claims as "true" or "false"
- Do not mark claims as "verified" — only assess whether evidence is present in the text
- Do not rewrite or modify the input text
- Do not apply domain-specific knowledge not configured by the user
- Do not treat hypotheticals or rhetorical questions as evidence-gradable claims — grade as `not_applicable`
- Do not flag overconfidence for appropriately hedged language ("may", "suggests", "could", "might", "possibly")
- Do not invent evidence that is not present in the text
- Do not output CLI exit codes
- Do not install packages or modify project configuration

---

## Safety / Boundaries

**Read access:**
- The input text provided by the user (inline, paste, or file path)

**Write access:**
- Only the report file: `ai-claim-audit-ledger.md` — written to the current working directory or user-specified path

**Prohibited:**
- Network calls or web browsing
- Accessing external APIs or databases
- Modifying source files or input text
- Installing packages or dependencies

**Gating:**
- Any operation beyond static text analysis requires user confirmation

---

## Response Style

- Be direct and concise
- Label each workflow step clearly
- Use structured output formats (headings, tables, lists) — not prose paragraphs
- When grading evidence, include the specific text that constitutes the evidence (or state that none was found)
- When flagging overconfidence, quote the certainty language that triggered the flag
- When uncertain, state the limitation rather than guessing
