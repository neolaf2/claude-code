#!/bin/bash
# NeoCLI KSTAR Loop Stop Hook
# Enforces completion of all KSTAR stages before allowing session exit
#
# Exit codes:
#   0 - Allow exit (no active loop or loop complete)
#   Output JSON with decision: "block" to prevent exit

set -euo pipefail

KSTAR_STATE_FILE=".claude/neocli-kstar.local.md"

# Read hook input from stdin (contains transcript_path, etc.)
HOOK_INPUT=$(cat)

# No state file - no active loop, allow exit
if [[ ! -f "$KSTAR_STATE_FILE" ]]; then
  exit 0
fi

# Parse YAML frontmatter
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$KSTAR_STATE_FILE")

# Extract fields
ACTIVE=$(echo "$FRONTMATTER" | grep '^active:' | sed 's/active: *//' | tr -d '[:space:]')
CURRENT_STAGE=$(echo "$FRONTMATTER" | grep '^current_stage:' | sed 's/current_stage: *//' | tr -d '[:space:]')
EXPERIENCE_ID=$(echo "$FRONTMATTER" | grep '^experience_id:' | sed 's/experience_id: *//' | tr -d '"[:space:]')

# Not active - allow exit
if [[ "$ACTIVE" != "true" ]]; then
  exit 0
fi

# Validate stage is numeric
if ! [[ "$CURRENT_STAGE" =~ ^[0-9]+$ ]]; then
  echo '{"systemMessage": "⚠️ KSTAR state file corrupted. Run /kstar:status to diagnose."}'
  exit 0
fi

# Stage names for display
declare -a STAGE_NAMES=("" "Situation" "Task" "Plan" "Execute" "Compare" "Record" "Learn")

# Check if all stages complete (stage 7 = Learn, final)
if [[ "$CURRENT_STAGE" -ge 7 ]]; then
  # Mark loop as complete
  if command -v sed &> /dev/null; then
    sed -i.bak 's/^active: true/active: false/' "$KSTAR_STATE_FILE" 2>/dev/null || true
    rm -f "${KSTAR_STATE_FILE}.bak" 2>/dev/null || true
  fi

  # Allow exit with completion message
  echo '{"systemMessage": "✅ KSTAR loop complete. Experience ready to store with /kstar:store"}'
  exit 0
fi

# Loop incomplete - determine what's needed
NEXT_STAGE=$((CURRENT_STAGE + 1))
NEXT_STAGE_NAME="${STAGE_NAMES[$NEXT_STAGE]:-Unknown}"
CURRENT_STAGE_NAME="${STAGE_NAMES[$CURRENT_STAGE]:-Unknown}"

# Build continuation message
CONTINUE_MSG="Continue KSTAR loop (${EXPERIENCE_ID:0:8}...). "
CONTINUE_MSG+="Currently at Stage ${CURRENT_STAGE}/7 (${CURRENT_STAGE_NAME}). "
CONTINUE_MSG+="Complete Stage ${NEXT_STAGE} (${NEXT_STAGE_NAME}) to proceed."

# Build system message
SYSTEM_MSG="🔄 KSTAR Loop Active - Stage ${CURRENT_STAGE}/7: ${CURRENT_STAGE_NAME}\n"
SYSTEM_MSG+="Next: ${NEXT_STAGE_NAME}\n"
SYSTEM_MSG+="Use /kstar:status for details or complete remaining stages."

# Return block decision with continuation prompt
jq -n \
  --arg reason "$CONTINUE_MSG" \
  --arg sysMsg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $reason,
    "systemMessage": $sysMsg
  }'

exit 0
