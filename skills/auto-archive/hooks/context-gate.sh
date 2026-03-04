#!/bin/bash
# context-gate.sh — PreToolUse hook for automatic context rotation
#
# Monitors transcript size and blocks tool calls when context pressure is high,
# forcing the agent to write a structured HANDOVER.md before continuing.
#
# Two-stage gate:
#   Stage 1 (no handover): Block action tools, allow file I/O, demand handover
#   Stage 2 (handover written): Allow all tools so /archive can run
#
# Environment variables:
#   CLAUDE_ARCHIVE_THRESHOLD_WARN   - bytes for 50% warning (default: 300000)
#   CLAUDE_ARCHIVE_THRESHOLD_ROTATE - bytes for 65% rotation (default: 400000)

set -euo pipefail

INPUT=$(cat)

# --- Extract fields from hook payload ---
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || echo "")
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

# Exit silently if we can't identify the session or transcript
[ -z "$SESSION_ID" ] && exit 0
[ -z "$TRANSCRIPT_PATH" ] && exit 0
[ ! -f "$TRANSCRIPT_PATH" ] && exit 0

# --- Configurable thresholds ---
THRESHOLD_WARN="${CLAUDE_ARCHIVE_THRESHOLD_WARN:-300000}"
THRESHOLD_ROTATE="${CLAUDE_ARCHIVE_THRESHOLD_ROTATE:-400000}"

# --- Check transcript size (cross-platform) ---
FILE_SIZE=$(stat -f%z "$TRANSCRIPT_PATH" 2>/dev/null \
         || stat -c%s "$TRANSCRIPT_PATH" 2>/dev/null \
         || echo 0)

# Below warning threshold — allow everything silently
[ "$FILE_SIZE" -lt "$THRESHOLD_WARN" ] && exit 0

# --- Flag/state management ---
FLAG_DIR="${TMPDIR:-/tmp}"
HANDOVER_FLAG="${FLAG_DIR}/claude-handover-written-${SESSION_ID}"
PROJECT_ROOT="${CWD:-.}"

# Check if handover has been written
handover_exists() {
  [ -f "$HANDOVER_FLAG" ] && return 0
  [ -f "${PROJECT_ROOT}/HANDOVER.md" ] && return 0
  return 1
}

# --- Between WARN and ROTATE: soft warning ---
if [ "$FILE_SIZE" -lt "$THRESHOLD_ROTATE" ]; then
  cat <<'WARN_JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "[CONTEXT PRESSURE] Context window is above 50%. Consider wrapping up your current task soon. You can run /archive at any time to save your work and start fresh."
  }
}
WARN_JSON
  exit 0
fi

# --- Above ROTATE threshold ---

# Always allow file I/O tools through (prevents deadlock during handover/archive)
case "$TOOL_NAME" in
  Read|Write|Edit|Glob|Grep)
    if ! handover_exists; then
      # File I/O allowed, but add context reminding agent to write handover
      cat <<ALLOW_JSON
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "[CONTEXT ROTATION] Context window is above 65%. After this operation, you MUST write HANDOVER.md at the project root before doing anything else."
  }
}
ALLOW_JSON
    fi
    exit 0
    ;;
esac

# For non-file-I/O tools: check handover state
if handover_exists; then
  # Stage 2: Handover exists — allow all tools so /archive can complete
  exit 0
fi

# Stage 1: No handover yet — BLOCK the tool call and demand handover
cat <<BLOCK_JSON
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "CONTEXT ROTATION REQUIRED — context window is above 65%. You MUST write a handover document before any other action.\n\nWrite the file HANDOVER.md in the project root with this exact structure:\n\n---\nsession_id: ${SESSION_ID}\ndate: $(date '+%Y-%m-%d %H:%M')\ntrigger: auto-rotation\nstatus: handover\n---\n\n# Context Rotation Handover\n\n## Current Task\n<What you were working on — be specific about the goal and current state>\n\n## Progress\n- [x] <Completed items with brief details>\n- [ ] <Remaining items>\n\n## Key Context\n<Critical decisions, architectural patterns, constraints, or state the next session MUST know to continue effectively>\n\n## Modified Files\n- \`<path>\` — <what changed and why>\n\n## Next Steps\n1. <Immediate next action — be precise>\n2. <Following action>\n\n## Open Issues\n- <Any blockers, concerns, or edge cases to watch for>\n\nAfter writing HANDOVER.md, run /archive to save the archive catalog and clear the session."
  }
}
BLOCK_JSON

exit 0
