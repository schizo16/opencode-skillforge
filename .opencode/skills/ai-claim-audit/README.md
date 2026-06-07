# ai-claim-audit

> Audit AI-generated answers for unsupported claims, overconfident language, and weak evidence.

---

## What This Skill Does

Reviews AI-generated text and identifies when the AI makes claims without supporting evidence, or sounds overconfident despite weak justification. Produces a structured claim ledger categorizing each claim by type (factual, reasoning, assumption, inference, opinion, hypothetical) and evidence status (supported, weak, needs evidence, unsupported).

All analysis is text-internal — no external fact-checking, no web browsing, no true/false labels.

---

## When to Use It

- Before sharing or publishing AI-generated content
- When you need to identify assumptions and weakly supported claims in an AI answer
- As a confidence check — flagging overconfident language where evidence is thin
- As part of a review workflow for AI-assisted research or documentation

---

## Installation

Place the `ai-claim-audit` folder under your project's `.opencode/skills/`:

```
.opencode/
└── skills/
    └── ai-claim-audit/
        ├── SKILL.md
        ├── README.md
        └── templates/
            └── ledger.md
```

The skill activates automatically when OpenCode detects the SKILL.md file.

---

## Usage Prompt

Trigger the skill by asking your agent:

> "Audit this AI answer for evidence quality."
> "Check this response for unsupported claims."
> "Review confidence vs evidence in this text."
> "Identify assumptions and weakly supported claims."

---

## Example Workflow

1. **Ingest text** — agent accepts the text you provide (inline, paste, or file)
2. **Segment into claims** — the text is parsed into individual claim units
3. **Classify claim type** — each claim is labeled as factual, reasoning, assumption, inference, opinion, or hypothetical
4. **Grade evidence status** — each claim is assessed for evidence present in the text
5. **Flag overconfidence** — strong certainty language paired with weak evidence triggers a flag
6. **Compile ledger** — a consolidated `ai-claim-audit-ledger.md` is written with all findings and a summary

---

## Claim Types

| Type | Description |
|------|-------------|
| `factual_claim` | Asserts a verifiable fact (dates, statistics, definitions, events) |
| `reasoning_claim` | Asserts a logical or causal relationship |
| `assumption` | Takes something for granted without justification |
| `inference` | Draws a conclusion from premises |
| `opinion` | Subjective statement, not verifiable |
| `hypothetical_or_rhetorical` | "What if" scenarios, rhetorical questions |

## Evidence Statuses

| Status | Description |
|--------|-------------|
| `supported_in_text` | Direct evidence, source, data, or explicit reasoning provided |
| `weak_support` | Some reasoning or example given, but incomplete or indirect |
| `needs_evidence` | Claim plausible but no citation, data, or explicit support provided |
| `unsupported` | Claim presented as certain but no evidence or reasoning provided |
| `not_applicable` | Opinion, hypothetical, or rhetorical — not graded |

---

## Limitations

- Text-internal analysis only — does not verify claims against external sources
- Does not label claims as true or false
- Cannot detect fabricated citations without external fact-checking
- Domain-specific evidence expectations must be configured by the user
- Hypotheticals and rhetorical questions are identified but not graded
