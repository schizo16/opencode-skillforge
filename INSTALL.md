# Install SkillForge

Install the SkillForge OpenCode skill into your project.

---

> **Security note:** Review remote install scripts before piping them into a shell.

## Quick Install

### macOS / Linux

```bash
curl -sSL https://raw.githubusercontent.com/schizo16/skillforge/main/install.sh | bash
```

### Windows PowerShell

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; iex (Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/schizo16/skillforge/main/install.ps1')
```

> **Note:** This installs the SkillForge skill only. Generated example skills such as responsive-a11y-review and ai-claim-audit are not installed; they are examples created by SkillForge.

---

## Manual Install

1. Clone the repository:

```bash
git clone https://github.com/schizo16/skillforge.git /tmp/skillforge
```

2. Copy the skill folder into your project:

```bash
# POSIX (macOS/Linux)
cp -r /tmp/skillforge/.opencode/skills/skillforge .opencode/skills/skillforge
```

```powershell
# Windows PowerShell
Copy-Item -Recurse -Path /tmp/skillforge/.opencode/skills/skillforge -Destination .opencode/skills/skillforge
```

3. Clean up:

```bash
rm -rf /tmp/skillforge
```

---

## Verify

1. **Confirm install** — check that `.opencode/skills/skillforge/SKILL.md` exists in your project.

2. **Test the workflow** — run this prompt in OpenCode:

   > *"Use the SkillForge skill. Make a skill that reviews frontend code. Do not create files yet."*

   Expected first output:

   - Skill Intent Analysis
   - Existing Skill Check
   - Blocking / Configuration Questions

   The agent should **not** immediately generate skill files. If it produces a spec or files, SkillForge is not active.

---

## Uninstall

Remove the skill folder:

```bash
rm -rf .opencode/skills/skillforge
```

```powershell
Remove-Item -Recurse -Path .opencode/skills/skillforge
```
