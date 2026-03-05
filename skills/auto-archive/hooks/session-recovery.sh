#!/bin/bash
# session-recovery.sh — SessionStart hook for context rotation recovery
#
# On new/cleared sessions, looks for a recent HANDOVER.md and injects its
# content so the agent can seamlessly resume work from where it left off.
#
# Only activates on source: "clear" (post-rotation) or "startup" (new session)
# Ignores source: "compact" (auto-compaction) and "resume" (session resume)
#
# Environment variables:
#   CLAUDE_HANDOVER_MAX_AGE - seconds before handover is stale (default: 300)

set -euo pipefail

INPUT=$(cat)

# --- Extract fields from hook payload ---
SOURCE=$(echo "$INPUT" | jq -r '.source // empty' 2>/dev/null || echo "")
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")

# Only activate on clear or startup
case "$SOURCE" in
  clear|startup) ;;
  *) exit 0 ;;
esac

PROJECT_ROOT="${CWD:-.}"
MAX_AGE="${CLAUDE_HANDOVER_MAX_AGE:-300}"
FLAG_DIR="${TMPDIR:-/tmp}"

# --- Find the handover document ---
HANDOVER_PATH=""

# Check 1: Flag file from handover-detector (contains path)
for flag in "${FLAG_DIR}"/claude-handover-written-*; do
  [ -f "$flag" ] || continue
  CANDIDATE=$(cat "$flag" 2>/dev/null || echo "")
  if [ -n "$CANDIDATE" ] && [ -f "$CANDIDATE" ]; then
    HANDOVER_PATH="$CANDIDATE"
    break
  fi
done

# Check 2: HANDOVER.md in project root
if [ -z "$HANDOVER_PATH" ] && [ -f "${PROJECT_ROOT}/HANDOVER.md" ]; then
  HANDOVER_PATH="${PROJECT_ROOT}/HANDOVER.md"
fi

# No handover found
[ -z "$HANDOVER_PATH" ] && exit 0

# --- Check age (cross-platform) ---
NOW=$(date +%s)
FILE_MTIME=$(stat -f%m "$HANDOVER_PATH" 2>/dev/null \
          || stat -c%Y "$HANDOVER_PATH" 2>/dev/null \
          || echo 0)
AGE=$((NOW - FILE_MTIME))

if [ "$AGE" -gt "$MAX_AGE" ]; then
  # Handover is stale — clean up and exit
  rm -f "${FLAG_DIR}"/claude-handover-written-*
  exit 0
fi

# --- Inject handover content ---
HANDOVER_CONTENT=$(cat "$HANDOVER_PATH")

cat <<EOF
[CONTEXT ROTATION RECOVERY] A previous session handed over work to you. Here is the handover document:

---

${HANDOVER_CONTENT}

---

Continue from where the previous session left off. Review the handover above and resume the task described in "Next Steps". The handover document is located at: ${HANDOVER_PATH}
EOF

# Clean up flag files and rotation locks
rm -f "${FLAG_DIR}"/claude-handover-written-*
rm -rf "${FLAG_DIR}"/claude-rotation-lock-*

exit 0
