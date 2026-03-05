#!/bin/bash
# rotate.sh — Send /clear to the current tmux pane after archive completes
#
# Launched as a background process by handover-detector.sh after archive
# completion is detected. Waits briefly for the agent to stop, then sends
# /clear via tmux send-keys.
#
# If not running inside tmux, this script does nothing (graceful fallback).
#
# Usage: Called internally — not meant to be run directly.
#   nohup bash rotate.sh <pane_id> &

set -euo pipefail

PANE_ID="${1:-${TMUX_PANE:-}}"

# --- Guard: must be inside tmux ---
if [ -z "$PANE_ID" ]; then
  exit 0
fi

# Verify tmux is available
if ! command -v tmux &>/dev/null; then
  exit 0
fi

# Verify the pane actually exists
if ! tmux has-session 2>/dev/null; then
  exit 0
fi

# --- Wait for agent to fully stop ---
# The PostToolUse hook that launched us returned decision:block which halts
# the agent's turn. Give it a moment to settle.
sleep 3

# --- Send /clear ---
tmux send-keys -t "$PANE_ID" "/clear" Enter

exit 0
