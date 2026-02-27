# Auto-Archive — Session Preservation

Automatically archive sessions when the context window reaches 60% usage, or invoke manually at any time. Archives are keyword-indexed for discoverability by future LLM sessions.

## Usage

```
/archive                         # Archive current session
/archive --reason="description"  # Archive with a reason annotation
```

The skill also runs automatically — a background hook monitors transcript size and prompts you to archive when the context window exceeds the threshold.

## How It Works

1. **Context monitoring** — A `Stop` hook checks transcript size after each turn. When it exceeds the threshold (~60% of the context window), a flag is set.
2. **Notification** — On your next prompt, a `UserPromptSubmit` hook detects the flag and injects an archive reminder.
3. **Archive** — Running `/archive` extracts metadata from the conversation (title, keywords, summary, decisions, files modified, open items) and writes structured files.
4. **Clear** — After archiving, the session is cleared so you start fresh with full context available.

## Archive Structure

Each archive creates a date-stamped directory:

```
archives/
├── CATALOG.md                              # Index of all archived sessions
└── 2025-06-15-refactor-auth-module/
    ├── INDEX.md                            # Pin file — keywords, summary, decisions
    └── session.md                          # Detailed work log, code snippets, lessons
```

- **INDEX.md** — Concise, grep-friendly pin file with YAML frontmatter, keywords, and key decisions. Designed for rapid LLM scanning.
- **session.md** — Full narrative record with detailed work log, code snippets, and lessons learned.
- **CATALOG.md** — Table of all sessions (newest first) with dates, titles, and top keywords.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `CLAUDE_ARCHIVE_DIR` | `<project_root>/archives/` | Where archives are stored |
| `CLAUDE_ARCHIVE_THRESHOLD` | `400000` (~400KB) | Transcript size in bytes that triggers the auto-archive prompt |

## Example

After a long refactoring session, the context window hits 60%:

```
[AUTO-ARCHIVE] Context window is above 60%. Before doing anything else, run /archive now.
```

Running `/archive` produces:

```
archives/2025-06-15-refactor-auth-module/
├── INDEX.md    (keywords: typescript, auth, refactoring, jwt, middleware, ...)
└── session.md  (detailed log of all changes, decisions, and lessons)
```

Future sessions can discover this work by scanning `INDEX.md` files in the archives directory.
