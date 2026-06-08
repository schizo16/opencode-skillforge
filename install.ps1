param(
  [string]$TargetDir = ".opencode\skills",
  [string]$RepoUrl = "https://github.com/schizo16/skillforge.git"
)

$ErrorActionPreference = "Stop"
$TempDir = Join-Path $env:TEMP "skillforge-install-$(Get-Random)"
$SkillPath = Join-Path $TargetDir "skillforge"

# Check git availability
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "git is required but not installed or not in PATH."
  exit 1
}

try {
  # Ensure target directory exists
  New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

  # Check for existing installation
  if (Test-Path $SkillPath) {
    Write-Error "$SkillPath already exists. Remove it first or install manually."
    exit 1
  }

  # Clone to temp directory
  Write-Host "Cloning SkillForge from $RepoUrl ..."
  & git clone --depth 1 $RepoUrl $TempDir
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to clone repository: $RepoUrl"
  }

  # Verify source path exists
  $SourcePath = Join-Path $TempDir ".opencode\skills\skillforge"
  if (-not (Test-Path $SourcePath)) {
    Write-Error "SkillForge skill not found at .opencode/skills/skillforge in the cloned repository."
    exit 1
  }

  # Copy only the skillforge skill
  Copy-Item -Recurse -Path $SourcePath -Destination $SkillPath

  Write-Host "Done. SkillForge installed to $SkillPath"
  Write-Host ""
  Write-Host "To verify, run in OpenCode:"
  Write-Host "  Use the SkillForge skill. Make a skill that reviews frontend code. Do not create files yet."
  Write-Host "Expected output: Skill Intent Analysis, Existing Skill Check, Blocking/Configuration Questions"
} finally {
  # Clean up temp directory on any exit
  if (Test-Path $TempDir) {
    Remove-Item -Recurse -Path $TempDir -Force -ErrorAction SilentlyContinue
  }
}
