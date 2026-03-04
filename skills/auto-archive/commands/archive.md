---
description: Archive the current session with structured handover for continuity and keyword-indexed catalog for long-term discoverability. Auto-triggered at 65% context window or invoke manually.
argument-hint: "[--reason=<description>]"
---

# Archive Skill

You are performing a session archive with context rotation. This preserves the
current session's work in two forms:

1. **HANDOVER.md** — Structured handover for seamless session continuity
2. **Archive catalog** — Keyword-indexed record for long-term discoverability

## When This Runs

- **Auto-triggered**: The context-gate hook blocked tool calls at 65% context
  usage and forced you to write HANDOVER.md. You were then told to run `/archive`.
- **Manual**: The user explicitly ran `/archive` to preserve their work.

## Archive Process

Follow these steps exactly:

### Step 1: Determine Archive Location

Check for the `CLAUDE_ARCHIVE_DIR` environment variable:

- If `CLAUDE_ARCHIVE_DIR` is set and non-empty, use that directory.
- If not set, use `<project_root>/archives/` where project_root is the
  current working directory.

### Step 2: Check for Existing Handover

Look for `HANDOVER.md` in the project root.

**If HANDOVER.md exists** (auto-rotation path):
- Read its content — this becomes the basis for the archive
- Extract metadata (task, progress, files, decisions) from the handover
- Do NOT re-analyze the entire conversation (context is already high)

**If HANDOVER.md does NOT exist** (manual archive path):
- Generate a handover document by analyzing the current conversation
- Write `HANDOVER.md` to the project root with this structure:

```markdown
---
session_id: <session_id if available>
date: <YYYY-MM-DD HH:MM>
trigger: manual
status: handover
---

# Context Rotation Handover

## Current Task
<What you were working on — be specific>

## Progress
- [x] <Completed items>
- [ ] <Remaining items>

## Key Context
<Critical decisions, patterns, or state the next session needs>

## Modified Files
- `<path>` — <what changed and why>

## Next Steps
1. <Immediate next action>
2. <Following action>

## Open Issues
- <Any blockers or concerns>
```

### Step 3: Generate Session Metadata

From the conversation (or from HANDOVER.md if it exists), extract:

1. **Session title**: Short descriptive slug (lowercase, hyphens, max 50 chars).
   Example: `refactor-auth-module`, `fix-payment-webhook`
2. **Keywords**: 8-15 relevant terms for grep discoverability. Include:
   - Technologies (languages, frameworks, libraries)
   - Concepts (refactoring, bugfix, feature, migration)
   - Domain terms specific to the work
   - Architectural components touched
3. **Summary**: 2-3 sentence overview of what was accomplished
4. **Key decisions**: Bullet list of important choices and rationale
5. **Files modified**: List of files created, edited, or deleted
6. **Open items**: Unfinished work or follow-up tasks
7. **Rotation**: Whether this archive was triggered by auto-rotation

### Step 4: Parse Arguments

Parse the `$ARGUMENTS` variable:

1. If `--reason=<text>` is present, use it as additional context for the summary
2. Everything else is treated as a description hint

### Step 5: Create Archive Directory

Create the session directory using today's date and the session title:

```
<archive_root>/<YYYY-MM-DD>-<session-title>/
```

If the directory already exists, append a numeric suffix:
`<YYYY-MM-DD>-<session-title>-2/`

Use the Write tool to create files — directory creation is handled automatically.

### Step 6: Write INDEX.md

Create `INDEX.md` in the session archive directory. This is the "pin file" —
designed for rapid LLM scanning and grep discoverability.

Use this exact format:

```markdown
---
session_id: <session_id if available>
date: <YYYY-MM-DD>
topic: <session-title-slug>
trigger: <auto-rotation|manual>
rotation: <true|false>
status: archived
---

# Session: <Human-Readable Title>

## Keywords
<comma-separated keyword list, 8-15 terms, wrapped at 80 chars>

## Summary
<2-3 sentence summary of what was accomplished>

## Key Decisions
- <decision 1 with brief rationale>
- <decision 2 with brief rationale>
...

## Files Modified
- `<path>` - <what changed>
...

## Open Items
- [ ] <unfinished task or follow-up>
...
```

### Step 7: Write session.md

Create `session.md` in the session archive directory with a detailed record:

```markdown
# Session Archive: <Title>

> Archived on <date> | Trigger: <auto-rotation|manual>

## Overview
<expanded summary, 1-2 paragraphs>

## Detailed Work Log

### <Topic/Phase 1>
<description of what was done, why, and the outcome>

### <Topic/Phase 2>
<description of what was done, why, and the outcome>

## Code Snippets

Include any important code patterns, configurations, or solutions that were
developed during this session.

## Lessons Learned
- <insight gained during the session>
- <pitfall encountered and how it was resolved>

## References
- <any URLs, documentation, or resources consulted>
```

### Step 8: Move HANDOVER.md to Archive

If `HANDOVER.md` exists in the project root:
- Copy its contents into `<archive_dir>/HANDOVER.md` for the permanent record
- Delete the original from the project root (it has served its purpose)

### Step 9: Update CATALOG.md

Check if `CATALOG.md` exists in the archive root directory.

**If CATALOG.md does not exist**, create it:

```markdown
# Session Archive Catalog

> Auto-maintained by the auto-archive skill. Do not edit manually.

| Date | Session | Keywords | Trigger | Rotation |
|------|---------|----------|---------|----------|
| <date> | [<Title>](./<dir-name>/INDEX.md) | <top 5 keywords> | <trigger> | <yes/no> |
```

**If CATALOG.md exists**, add a new row to the TOP of the table (newest first).

### Step 10: Clean Up

Remove old flag files for the current session (rotation lock is managed
by the hooks, do not touch it here):

```bash
rm -f "${TMPDIR:-/tmp}/claude-archive-flag-${SESSION_ID}" 2>/dev/null
rm -f "${TMPDIR:-/tmp}/claude-archive-notified-${SESSION_ID}" 2>/dev/null
```

Output the confirmation:

```
Session archived to <archive_directory_path>
Handover preserved for session recovery.
```

**Do not attempt to invoke `/clear`** — you cannot. The PostToolUse hook
will detect that CATALOG.md was written (archive complete) and handle
the rotation automatically:

- **Inside tmux**: The hook launches `rotate.sh` which sends `/clear`
  via `tmux send-keys`. Fully automated.
- **Outside tmux**: The hook tells the user to type `/clear` manually.

Either way, the SessionStart hook will inject the handover content into
the fresh session so work resumes seamlessly. Your job ends here — stop
after outputting the confirmation message.

## Important Notes

- **You cannot run /clear** — the hooks handle it. Stop after archiving.
- **Be thorough with keywords** — these are the primary discovery mechanism
  for future LLM sessions using grep.
- **Keep INDEX.md concise** — it's a "pin file" for rapid scanning, not a
  full record. Details go in session.md.
- **Reuse HANDOVER.md when present** — if auto-rotation already forced a
  handover, don't re-analyze the conversation. Extract from the handover.
- **Handle re-archives gracefully** — if archiving the same session twice,
  create a new directory with a numeric suffix rather than overwriting.
