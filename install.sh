#!/usr/bin/env bash
set -euo pipefail

SKILLFORGE_URL="${SKILLFORGE_URL:-https://github.com/schizo16/opencode-skillforge.git}"
TARGET_DIR="${1:-.opencode/skills}"
TEMP_DIR=$(mktemp -d)

# Cleanup temp directory on any exit
cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Check git availability
if ! command -v git &>/dev/null; then
  echo "Error: git is required but not installed or not in PATH."
  exit 1
fi

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

# Check for existing installation
if [ -d "$TARGET_DIR/skillforge" ]; then
  echo "Error: $TARGET_DIR/skillforge already exists. Remove it first or install manually."
  exit 1
fi

# Clone to temp directory
echo "Cloning SkillForge from $SKILLFORGE_URL ..."
git clone --depth 1 "$SKILLFORGE_URL" "$TEMP_DIR"

# Verify source path exists
if [ ! -d "$TEMP_DIR/.opencode/skills/skillforge" ]; then
  echo "Error: SkillForge skill not found at .opencode/skills/skillforge in the cloned repository."
  exit 1
fi

# Copy only the skillforge skill
cp -r "$TEMP_DIR/.opencode/skills/skillforge" "$TARGET_DIR/skillforge"

echo "Done. SkillForge installed to $TARGET_DIR/skillforge/"
echo ""
echo "To verify, run in OpenCode:"
echo "  Use the SkillForge skill. Make a skill that reviews frontend code. Do not create files yet."
echo "Expected output: Skill Intent Analysis, Existing Skill Check, Blocking/Configuration Questions"
