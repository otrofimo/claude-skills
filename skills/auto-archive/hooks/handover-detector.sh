#!/bin/bash
# handover-detector.sh — PostToolUse hook for context rotation
#
# Two-stage detection:
#   1. HANDOVER.md written → tell agent to run /archive
#   2. CATALOG.md written (archive complete) → launch rotate.sh, halt agent
#
# Includes mkdir-based atomic locking to prevent double-rotation.
#
# Matched on: Write|Edit (configured in hooks.json matcher)

set -euo pipefail

INPUT=$(cat)

# --- Extract fields from hook payload ---
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# Exit silently if missing data
[ -z "$SESSION_ID" ] && exit 0
[ -z "$FILE_PATH" ] && exit 0

FLAG_DIR="${TMPDIR:-/tmp}"
HANDOVER_FLAG="${FLAG_DIR}/claude-handover-written-${SESSION_ID}"
LOCK_DIR="${FLAG_DIR}/claude-rotation-lock-${SESSION_ID}"
LOCK_TTL=300  # seconds before lock is considered stale

BASENAME=$(basename "$FILE_PATH")
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

# --- Atomic lock helpers ---
acquire_lock() {
  # mkdir is atomic on all POSIX systems
  if mkdir "$LOCK_DIR" 2>/dev/null; then
    echo "$$" > "${LOCK_DIR}/pid"
    echo "$(date +%s)" > "${LOCK_DIR}/ts"
    return 0
  fi

  # Check for stale lock
  if [ -f "${LOCK_DIR}/ts" ]; then
    LOCK_TS=$(cat "${LOCK_DIR}/ts" 2>/dev/null || echo 0)
    NOW=$(date +%s)
    AGE=$((NOW - LOCK_TS))
    if [ "$AGE" -gt "$LOCK_TTL" ]; then
      # Stale lock — reclaim it
      rm -rf "$LOCK_DIR"
      if mkdir "$LOCK_DIR" 2>/dev/null; then
        echo "$$" > "${LOCK_DIR}/pid"
        echo "$(date +%s)" > "${LOCK_DIR}/ts"
        return 0
      fi
    fi
  fi

  return 1
}

# --- Stage 1: Detect HANDOVER.md write ---
if echo "$BASENAME" | grep -qi "HANDOVER"; then
  # Record the handover file path
  echo "$FILE_PATH" > "$HANDOVER_FLAG"

  # Tell the agent to proceed with archiving
  cat <<'DETECT_JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "[HANDOVER COMPLETE] Handover document written successfully. Now run /archive to save the archive catalog and complete the rotation."
  }
}
DETECT_JSON
  exit 0
fi

# --- Stage 2: Detect CATALOG.md write (archive complete) ---
if echo "$BASENAME" | grep -qi "CATALOG"; then
  # Only trigger if we're in a rotation (handover flag exists)
  [ -f "$HANDOVER_FLAG" ] || exit 0

  # Acquire rotation lock — prevent double-rotation
  if ! acquire_lock; then
    # Another rotation is already in progress
    exit 0
  fi

  # Detect tmux and launch rotation script
  TMUX_PANE_ID="${TMUX_PANE:-}"

  if [ -n "$TMUX_PANE_ID" ] && command -v tmux &>/dev/null; then
    # Launch rotate.sh in background (detached from this process)
    nohup bash "${PLUGIN_ROOT}/hooks/rotate.sh" "$TMUX_PANE_ID" \
      >/dev/null 2>&1 &

    # Halt the agent — rotation script will handle /clear
    cat <<'HALT_JSON'
{
  "decision": "block",
  "reason": "[ROTATION] Archive complete. Sending /clear via tmux — the session will restart automatically with your handover context."
}
HALT_JSON
  else
    # No tmux — tell the user to type /clear manually
    cat <<'FALLBACK_JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "[ROTATION] Archive complete. Type /clear now to reset the context window. The SessionStart hook will automatically detect the handover and resume your work."
  }
}
FALLBACK_JSON
  fi

  exit 0
fi

# Not a handover or catalog file — pass through silently
exit 0
