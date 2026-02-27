#!/bin/bash
# check-context.sh - Context window monitor for auto-archive
#
# Called by hooks with subcommand:
#   "check"  (from Stop hook, async)  - check transcript size, set flag if >60%
#   "notify" (from UserPromptSubmit)  - check flag, inject archive reminder
#
# Environment variables:
#   CLAUDE_ARCHIVE_THRESHOLD - transcript size threshold in bytes (default: 400000)

set -euo pipefail

SUBCOMMAND="${1:-}"
INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || echo "")

# Exit early if we can't identify the session
[ -z "$SESSION_ID" ] && exit 0

FLAG_DIR="${TMPDIR:-/tmp}"
FLAG_FILE="${FLAG_DIR}/claude-archive-flag-${SESSION_ID}"
# Sentinel to prevent duplicate notifications within a session
NOTIFIED_FILE="${FLAG_DIR}/claude-archive-notified-${SESSION_ID}"

# Configurable threshold (default: 400000 bytes ≈ 60% of 200k token context)
THRESHOLD="${CLAUDE_ARCHIVE_THRESHOLD:-400000}"

case "$SUBCOMMAND" in
  check)
    # Already flagged or notified? Skip.
    [ -f "$FLAG_FILE" ] && exit 0
    [ -f "$NOTIFIED_FILE" ] && exit 0
    [ -z "$TRANSCRIPT_PATH" ] && exit 0
    [ ! -f "$TRANSCRIPT_PATH" ] && exit 0

    # Cross-platform file size (macOS then Linux)
    FILE_SIZE=$(stat -f%z "$TRANSCRIPT_PATH" 2>/dev/null \
             || stat -c%s "$TRANSCRIPT_PATH" 2>/dev/null \
             || echo 0)

    if [ "$FILE_SIZE" -gt "$THRESHOLD" ]; then
      echo "{\"transcript_size\": $FILE_SIZE, \"threshold\": $THRESHOLD}" > "$FLAG_FILE"
    fi
    ;;
  notify)
    if [ -f "$FLAG_FILE" ] && [ ! -f "$NOTIFIED_FILE" ]; then
      # Mark as notified to prevent re-triggering
      touch "$NOTIFIED_FILE"
      rm -f "$FLAG_FILE"
      # stdout becomes context for Claude (UserPromptSubmit behavior)
      echo "[AUTO-ARCHIVE] Context window is above 60%. Before doing anything else, run /archive now."
    fi
    ;;
  *)
    echo "Usage: check-context.sh [check|notify]" >&2
    exit 1
    ;;
esac

exit 0
