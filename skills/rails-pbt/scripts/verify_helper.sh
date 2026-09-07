#!/usr/bin/env bash
# Verifies assets/pbt_rails.rb against a pinned pbt release without needing rubygems or a Rails app.
# Re-run this before changing the `~> 0.7` constraint in SKILL.md.
set -euo pipefail
PBT_TAG="${PBT_TAG:-v0.7.0}"
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
git clone -q --depth 1 --branch "$PBT_TAG" https://github.com/ohbarye/pbt.git "$TMP/pbt"
PBT_SRC="$TMP/pbt" ruby "$HERE/verify_helper.rb"
