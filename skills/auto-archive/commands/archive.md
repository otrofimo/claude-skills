---
description: Archive the current session with keywords and summary for future LLM discoverability. Auto-triggered at 60% context window or invoke manually.
argument-hint: "[--reason=<description>]"
---

# Archive Skill

You are performing a session archive. This preserves the current session's work
as a searchable, structured record before context quality degrades.

## When This Runs

- **Auto-triggered**: The auto-archive hook detected high context window usage
  and injected a suggestion to run this command.
- **Manual**: The user explicitly ran `/archive` to preserve their work.

## Archive Process

Follow these steps exactly:

### Step 1: Determine Archive Location

Check for the `CLAUDE_ARCHIVE_DIR` environment variable:

```bash
echo "${CLAUDE_ARCHIVE_DIR:-}"
```

- If `CLAUDE_ARCHIVE_DIR` is set and non-empty, use that directory.
- If not set, use `<project_root>/archives/` where project_root is the
  current working directory.

### Step 2: Generate Session Metadata

Analyze the current conversation to extract:

1. **Session title**: A short, descriptive slug (lowercase, hyphens, max 50 chars).
   Example: `refactor-auth-module`, `fix-payment-webhook`, `add-dark-mode`
2. **Keywords**: 8-15 relevant terms for search/grep discoverability. Include:
   - Technologies used (languages, frameworks, libraries)
   - Concepts (refactoring, bugfix, feature, migration, etc.)
   - Domain terms specific to the work done
   - File types or architectural components touched
3. **Summary**: 2-3 sentence overview of what was accomplished
4. **Key decisions**: Bullet list of important choices made and their rationale
5. **Files modified**: List of files that were created, edited, or deleted
6. **Open items**: Any unfinished work, TODOs, or follow-up tasks

### Step 3: Parse Arguments

Parse the `$ARGUMENTS` variable:

1. If `--reason=<text>` is present, use it as additional context for the summary
2. Everything else is treated as a description hint

### Step 4: Create Archive Directory

Create the session directory using today's date and the session title:

```
<archive_root>/<YYYY-MM-DD>-<session-title>/
```

If the directory already exists (re-archive of same topic on same day), append
a numeric suffix: `<YYYY-MM-DD>-<session-title>-2/`

Use `mkdir -p` to create the full path including the archive root if needed.

### Step 5: Write INDEX.md

Create `INDEX.md` in the session archive directory. This is the "pin file" —
designed for rapid LLM scanning and grep discoverability.

Use this exact format:

```markdown
---
session_id: <session_id if available>
date: <YYYY-MM-DD>
topic: <session-title-slug>
trigger: <auto|manual>
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
- `<path>` - <what changed>
...

## Open Items
- [ ] <unfinished task or follow-up>
- [ ] <unfinished task or follow-up>
...
```

### Step 6: Write session.md

Create `session.md` in the session archive directory with a detailed record:

```markdown
# Session Archive: <Title>

> Archived on <date> | Trigger: <auto|manual>

## Overview
<expanded summary, 1-2 paragraphs>

## Detailed Work Log

### <Topic/Phase 1>
<description of what was done, why, and the outcome>

### <Topic/Phase 2>
<description of what was done, why, and the outcome>

...

## Code Snippets

Include any important code patterns, configurations, or solutions that were
developed during this session. These should be self-contained enough to be
useful if referenced later.

## Lessons Learned
- <insight gained during the session>
- <pitfall encountered and how it was resolved>

## References
- <any URLs, documentation, or resources consulted>
```

### Step 7: Update CATALOG.md

Check if `CATALOG.md` exists in the archive root directory.

**If CATALOG.md does not exist** (first-time setup), create it:

```markdown
# Session Archive Catalog

> Auto-maintained by the auto-archive skill. Do not edit manually.

| Date | Session | Keywords | Trigger |
|------|---------|----------|---------|
| <date> | [<Title>](./<dir-name>/INDEX.md) | <top 5 keywords> | <trigger> |
```

**If CATALOG.md exists**, add a new row to the TOP of the Sessions table
(newest first) and do not remove any existing rows.

### Step 8: Clean Up Flag Files

Remove any auto-archive flag files for the current session:

```bash
rm -f "${TMPDIR:-/tmp}/claude-archive-flag-${SESSION_ID}"
rm -f "${TMPDIR:-/tmp}/claude-archive-notified-${SESSION_ID}"
```

This resets the auto-archive trigger so it can fire again if the user
continues working in the same session.

### Step 9: Confirm and Clear

After writing all files, output a summary:

```
Archive complete:
  Location: <archive_directory_path>
  Files: INDEX.md, session.md
  Catalog: Updated CATALOG.md (<N> total sessions)

Starting fresh session. To recover context from this archive, grep the archives directory.
```

Then immediately run `/clear` to reset the session. The entire point of
archiving is to preserve work so the context can be safely cleared before
quality degrades. The new session starts clean — future sessions can discover
this archive by grepping INDEX.md keyword files in the archives directory.

## Important Notes

- **Always clear after archiving** — archive exists so you can confidently
  start fresh. Archiving without clearing defeats the purpose.
- **Be thorough with keywords** — these are the primary discovery mechanism
  for future LLM sessions using grep.
- **Keep INDEX.md concise** — it's a "pin file" for rapid scanning, not a
  full record. Details go in session.md.
- **Handle re-archives gracefully** — if archiving the same session twice,
  create a new directory with a numeric suffix rather than overwriting.
- **Create directories as needed** — use `mkdir -p` for the archive directory.
  The archives root may not exist on first use.
