# Auto-Archive — Context Rotation & Session Preservation

Automatically rotates context when the window reaches 65% usage using a 3-hook pipeline inspired by [VNX orchestration](https://vincentvandeth.nl/blog/context-rot-claude-code-automatic-rotation). Blocks tool calls, forces a structured handover document, archives for long-term discoverability, and recovers seamlessly on session restart.

**Inside tmux**: Fully automated — `/clear` is sent via `tmux send-keys`.
**Outside tmux**: Almost fully automated — the user types `/clear` as the one manual step.

## Usage

```
/archive                         # Archive current session
/archive --reason="description"  # Archive with a reason annotation
```

The skill also runs automatically — a PreToolUse hook blocks tool calls at 65% context and forces the agent to write a handover before archiving.

## How It Works

### The 3-Hook Pipeline + Rotation Script

```
Normal work → Context hits 65% → PreToolUse BLOCKS tools
  → Agent writes HANDOVER.md (file I/O still allowed)
  → PostToolUse detects handover, tells agent to run /archive
  → /archive writes INDEX.md + session.md + CATALOG.md
  → PostToolUse detects CATALOG.md write (archive complete)
  → Acquires atomic rotation lock
  → [tmux] launches rotate.sh → sends /clear via send-keys
  → [no tmux] tells user to type /clear
  → SessionStart hook fires on fresh session
  → Detects recent HANDOVER.md, injects context
  → Agent resumes from handover's "Next Steps"
```

### The 4 Components

1. **Context gate** (`PreToolUse` → `context-gate.sh`) — Monitors transcript size on every tool call. At 50%, logs a soft warning. At 65%, blocks all tools except file I/O (Read, Write, Edit, Glob, Grep) and demands the agent write `HANDOVER.md`. This is a hard gate — the agent cannot do anything else until it complies. If a rotation lock exists (rotation in progress), all tools pass through.

2. **Handover detector** (`PostToolUse` → `handover-detector.sh`) — Two-stage detection:
   - **Stage 1**: Watches for Write/Edit targeting files with "HANDOVER" in the name. Sets a flag and tells the agent to run `/archive`.
   - **Stage 2**: Watches for CATALOG.md writes (signals archive completion). Acquires an atomic rotation lock, then either launches `rotate.sh` (tmux) or tells the user to type `/clear` (no tmux).

3. **Rotation script** (`rotate.sh`) — Background process launched by the handover detector. Waits 3 seconds for the agent to stop, then sends `/clear` + Enter to the current tmux pane via `send-keys`. Exits silently if not inside tmux.

4. **Session recovery** (`SessionStart` → `session-recovery.sh`) — On fresh sessions after `/clear`, looks for a recent `HANDOVER.md` (< 5 minutes old) and injects its content as context. Cleans up flag files and rotation locks. The new session picks up exactly where the old one left off.

### Why 65%?

Claude Code's built-in auto-compaction fires at ~80%. Rotating at 65% gives 15 points of headroom to complete the handover + archive + clear cycle before auto-compaction races and wins. If auto-compaction fires first, nuanced context is lost.

### Atomic Locking

The handover detector uses `mkdir`-based atomic locking (POSIX-guaranteed atomic) to prevent double-rotation when hooks fire in rapid succession. Locks have a 300-second TTL for stale detection.

### Dual-Purpose Output

Unlike simple handover-only approaches, this skill produces:

- **HANDOVER.md** — Structured document for immediate session continuity
- **INDEX.md** — Grep-friendly pin file with YAML frontmatter and keywords for long-term discoverability
- **session.md** — Detailed narrative record with work log, code snippets, and lessons learned
- **CATALOG.md** — Master index of all archived sessions

## Archive Structure

```
project-root/
├── HANDOVER.md                          # Temporary — written during rotation, moved to archive
└── archives/
    ├── CATALOG.md                       # Index of all archived sessions
    └── 2025-06-15-refactor-auth-module/
        ├── INDEX.md                     # Pin file — keywords, summary, decisions
        ├── session.md                   # Detailed work log
        └── HANDOVER.md                  # Preserved handover from rotation
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `CLAUDE_ARCHIVE_DIR` | `<project_root>/archives/` | Where archives are stored |
| `CLAUDE_ARCHIVE_THRESHOLD_WARN` | `300000` (~300KB) | Transcript size for 50% soft warning |
| `CLAUDE_ARCHIVE_THRESHOLD_ROTATE` | `400000` (~400KB) | Transcript size for 65% hard rotation |
| `CLAUDE_HANDOVER_MAX_AGE` | `300` (5 min) | Seconds before a handover is considered stale |

## Handover Document Format

The handover is a structured markdown document written at the project root:

```markdown
---
session_id: abc123
date: 2025-06-15 14:30
trigger: auto-rotation
status: handover
---

# Context Rotation Handover

## Current Task
Refactoring the authentication module to use JWT tokens...

## Progress
- [x] Extracted token validation into middleware
- [x] Added refresh token rotation
- [ ] Update API tests for new auth flow

## Key Context
Using RS256 signing. Refresh tokens stored in httpOnly cookies...

## Modified Files
- `src/auth/middleware.ts` — new JWT validation middleware
- `src/auth/tokens.ts` — refresh token rotation logic

## Next Steps
1. Update API integration tests in tests/auth/
2. Add token revocation endpoint

## Open Issues
- Need to decide on refresh token TTL (currently 7 days)
```

## tmux vs Non-tmux Behavior

| Step | tmux | No tmux |
|------|------|---------|
| Context pressure detection | Automatic | Automatic |
| Handover writing | Forced by hook | Forced by hook |
| Archive catalog | Automatic | Automatic |
| `/clear` | Automated via `send-keys` | User types it manually |
| Session recovery | Automatic | Automatic |

## Example

After working on a feature, context reaches 65%:

```
[CONTEXT ROTATION REQUIRED] Context window is above 65%.
You MUST write a handover document before any other action...
```

The agent writes `HANDOVER.md`, then runs `/archive`:

```
archives/2025-06-15-refactor-auth-module/
├── INDEX.md     (keywords: typescript, auth, jwt, middleware, refactoring, ...)
├── session.md   (detailed log of all changes, decisions, and lessons)
└── HANDOVER.md  (preserved handover for the record)
```

In tmux, `/clear` fires automatically. Outside tmux:

```
[ROTATION] Archive complete. Type /clear now to reset the context window.
```

After `/clear`, the new session starts with:

```
[CONTEXT ROTATION RECOVERY] A previous session handed over work to you...
```

The agent reads the handover and resumes from "Next Steps".
