# Expected SkillForge Output

> SkillForge processes the vague request through its 7-step workflow.

---

## Skill Intent Analysis

**Request summary:**
User wants a skill that reviews AI-generated text and identifies when the AI makes claims without supporting evidence, or sounds overconfident despite weak justification.

**Identified purpose:**
Audit AI-generated answers for unsupported claims, overconfident language, and weak evidence — producing a structured claim ledger that separates what the AI asserts from what it assumes, infers, or treats as hypothetical.

**Key signals:**
- Trigger pattern: "audit this answer for evidence quality", "check this AI response for unsupported claims", "review confidence vs evidence in this answer", "identify assumptions and weakly supported claims"
- Expected input: AI-generated text
- Expected output: A claim ledger categorizing each claim by type and evidence status, with overconfidence flags
- Frequency estimate: Repeated
- Workflow specificity: Custom — requires a taxonomy of claim types and evidence-grading logic

---

## Existing Skill Check

**Locally available skills:**
- `frontend-review` — unrelated
- `responsive-a11y-review` — unrelated

**Potential matches for this request:**
- None.

**Verdict:**
- [x] No existing skill matches → recommend creation

---

## Configuration Questions

No blockers. The skill works with sensible defaults.

1. **What domain is the AI answer about?** (optional — default: general) — Domain affects what counts as reasonable evidence.
2. **How strict should the evidence threshold be?** (optional — default: moderate) — Strict: demands citations or data. Moderate: accepts reasoned arguments. Relaxed: only flags contradictions.
3. **Should the skill also score confidence language?** (optional — default: yes) — Flags strong certainty markers.

---

## Skill Spec

**Name:** `ai-claim-audit`

**Trigger description:**
Activates when the user asks to audit, review, or check an AI answer for evidence quality, unsupported claims, or overconfident language.

**Workflow steps:**
1. **Ingest text** — accept input as inline text, file path, or conversation block
2. **Segment into claims** — parse into individual claim units (sentences or clauses that assert something)
3. **Classify claim type** — assign one of six categories:
   - `factual_claim` — asserts a verifiable fact (dates, statistics, definitions, events)
   - `reasoning_claim` — asserts a logical or causal relationship ("X leads to Y")
   - `assumption` — takes something for granted without justification
   - `inference` — draws a conclusion from premises
   - `opinion` — subjective statement, not verifiable
   - `hypothetical_or_rhetorical` — "what if", "imagine", rhetorical questions — flag separately, do not grade
4. **Grade evidence status** — assign one of five statuses:
   - `supported_in_text` — the text provides direct evidence, quoted source, data, concrete example, or explicit reasoning that supports the claim
   - `weak_support` — the text gives some reasoning or example, but it is incomplete, indirect, or not enough for the strength of the claim
   - `needs_evidence` — the claim may be plausible, but the text provides no citation, data, example, source, or explicit support
   - `unsupported` — the claim is presented as established or certain, but the text provides neither evidence nor reasoning, or the claim uses broad/absolute language without support
   - `not_applicable` — used for opinions, hypotheticals, rhetorical questions, or subjective preferences
5. **Flag overconfidence** — scan for strong certainty markers (e.g. "definitely", "always", "proven", "undoubtedly", "it is certain that") and cross-reference against evidence status. Flag only when strong language is paired with `weak_support`, `needs_evidence`, or `unsupported`
6. **Compile claim ledger** — produce a structured report

**Input contract:**
- The AI answer text (inline, paste, or file path)
- Optional: domain, evidence threshold, enable/disable confidence scoring

**Output contract:**
- `ai-claim-audit-ledger.md` — table with columns: claim text, claim type, evidence status, confidence language, overconfidence flag, recommendation
- Summary section: total claims per type, unsupported/weak count, overconfidence count, risk level

**Key behaviors:**
- Claim type and evidence status are separate dimensions — never conflated
- Never marks a claim as "verified" — only assesses whether evidence is present in the text
- Overconfidence flag requires both strong language AND weak evidence
- Domain and threshold only affect evidence grading strictness, not claim classification
- Hypotheticals and rhetorical questions are identified but not graded for evidence

**Edge cases:**
- Empty input → "nothing to audit"
- No factual claims (pure opinion/persuasion) → ledger lists all as opinion, notes "persuasive text, no factual claims"
- All claims fully supported → summary notes "all claims supported in text"

**Do-not behaviors:**
- Do not verify claims against external sources
- Do not mark claims as "true" or "false"
- Do not rewrite or modify the input text
- Do not apply domain-specific knowledge not configured by the user
- Do not treat hypotheticals or rhetorical questions as evidence-gradable claims
- Do not flag overconfidence for appropriately hedged language ("may", "suggests", "could")

---

## Generated File Plan

### `.opencode/skills/ai-claim-audit/SKILL.md`
Full skill file with 6-step workflow, claim type taxonomy, evidence grading rubric, confidence detection patterns, and ledger output format.

### `.opencode/skills/ai-claim-audit/README.md`
Installation instructions, usage prompts, and example workflow walkthrough.

### `.opencode/skills/ai-claim-audit/templates/ledger.md`
Template for the claim ledger report output.

---

## Skill Quality Audit

**Skill:** `ai-claim-audit`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Metadata present | PASS | Name, description, compatibility defined in spec |
| Purpose clear | PASS | "Audit AI-generated answers for unsupported claims, overconfident language, and weak evidence" |
| Workflow complete | PASS | 6 steps: ingest → segment → classify type → grade evidence → flag overconfidence → compile ledger |
| Output formats defined | PASS | Claim ledger (`ai-claim-audit-ledger.md`) with 6 columns plus summary section |
| Do-not rules present | PASS | No external verification, no true/false, no text modification, no unconfigured domain knowledge, no hypothetical-grading |
| Trigger clarity | PASS | "Audit this answer for evidence quality", "check for unsupported claims", "review confidence vs evidence" — all text-internal |
| No assumptions as facts | PASS | Claim type and evidence status are structurally separated; inference ≠ opinion ≠ factual_claim |
| Safety constraints | PASS | Read-only; no network calls; no text modification; no external verification |
| Naming convention followed | PASS | `ai-claim-audit` — lowercase, hyphenated, noun-first, max 4 words |

**Overall:** PASS

**Fixes applied:** None needed

---

## Usage Instructions

**Install:** Place the skill folder under `.opencode/skills/ai-claim-audit/`.

**Verify:** Run: *"Audit this AI answer for evidence quality"* — confirm the skill produces a claim ledger.

**Files created:**
- `.opencode/skills/ai-claim-audit/SKILL.md`
- `.opencode/skills/ai-claim-audit/README.md`
- `.opencode/skills/ai-claim-audit/templates/ledger.md`
