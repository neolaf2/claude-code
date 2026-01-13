#!/bin/bash
# NeoCLI Session Start Hook
# Loads KSTAR loop state and notifies user of active loops
#
# This hook runs at session start to:
# 1. Check for active KSTAR loops
# 2. Display status reminder if loop in progress
# 3. Search for relevant past experiences (if context available)

set -euo pipefail

KSTAR_STATE_FILE=".claude/neocli-kstar.local.md"

# No state file - nothing to report
if [[ ! -f "$KSTAR_STATE_FILE" ]]; then
  exit 0
fi

# Parse YAML frontmatter
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$KSTAR_STATE_FILE")

# Extract fields
ACTIVE=$(echo "$FRONTMATTER" | grep '^active:' | sed 's/active: *//' | tr -d '[:space:]')
CURRENT_STAGE=$(echo "$FRONTMATTER" | grep '^current_stage:' | sed 's/current_stage: *//' | tr -d '[:space:]')
EXPERIENCE_ID=$(echo "$FRONTMATTER" | grep '^experience_id:' | sed 's/experience_id: *//' | tr -d '"[:space:]')
STARTED_AT=$(echo "$FRONTMATTER" | grep '^started_at:' | sed 's/started_at: *//' | tr -d '"')

# Not active - nothing to report
if [[ "$ACTIVE" != "true" ]]; then
  exit 0
fi

# Stage names
declare -a STAGE_NAMES=("" "Situation" "Task" "Plan" "Execute" "Compare" "Record" "Learn")
CURRENT_STAGE_NAME="${STAGE_NAMES[$CURRENT_STAGE]:-Unknown}"

# Calculate duration if possible
DURATION_MSG=""
if [[ -n "$STARTED_AT" ]] && command -v date &> /dev/null; then
  # Try to parse and calculate duration
  if START_TS=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${STARTED_AT%Z}" +%s 2>/dev/null || date -d "$STARTED_AT" +%s 2>/dev/null); then
    NOW_TS=$(date +%s)
    DIFF=$((NOW_TS - START_TS))
    if [[ $DIFF -lt 3600 ]]; then
      DURATION_MSG=" (${DIFF}s ago)"
    elif [[ $DIFF -lt 86400 ]]; then
      HOURS=$((DIFF / 3600))
      DURATION_MSG=" (${HOURS}h ago)"
    else
      DAYS=$((DIFF / 86400))
      DURATION_MSG=" (${DAYS}d ago)"
    fi
  fi
fi

# Build status message
MSG="📋 Active KSTAR Loop Detected\n"
MSG+="━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
MSG+="🔑 ID: ${EXPERIENCE_ID:0:8}...${DURATION_MSG}\n"
MSG+="📍 Stage: ${CURRENT_STAGE}/7 - ${CURRENT_STAGE_NAME}\n"
MSG+="\n"
MSG+="Commands:\n"
MSG+="  /kstar:status  - View full status\n"
MSG+="  /kstar:store   - Save and complete loop"

# Output as JSON for hook system
jq -n --arg msg "$MSG" '{"systemMessage": $msg}'

exit 0
