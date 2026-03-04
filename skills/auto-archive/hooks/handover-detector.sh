#!/bin/bash
# handover-detector.sh — PostToolUse hook for context rotation
#
# Watches for Write/Edit operations targeting HANDOVER files.
# When detected, sets a flag and tells the agent to run /archive.
#
# Matched on: Write, Edit (configured in hooks.json matcher)

set -euo pipefail

INPUT=$(cat)

# --- Extract fields from hook payload ---
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# Exit silently if missing data
[ -z "$SESSION_ID" ] && exit 0
[ -z "$FILE_PATH" ] && exit 0

# --- Check if this is a handover document write ---
# Case-insensitive check for HANDOVER in the filename
BASENAME=$(basename "$FILE_PATH")
if echo "$BASENAME" | grep -qi "HANDOVER"; then
  FLAG_DIR="${TMPDIR:-/tmp}"
  HANDOVER_FLAG="${FLAG_DIR}/claude-handover-written-${SESSION_ID}"

  # Record the handover file path and timestamp
  echo "$FILE_PATH" > "$HANDOVER_FLAG"

  # Tell the agent to proceed with archiving
  cat <<'DETECT_JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "[HANDOVER COMPLETE] Handover document written successfully. Now run /archive to save the archive catalog and clear the session. The /archive command will preserve your work in the archive catalog and then clear the context window for a fresh start."
  }
}
DETECT_JSON
  exit 0
fi

# Not a handover file — pass through silently
exit 0
