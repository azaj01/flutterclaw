---
name: file-manager
description: Manage workspace files and agent configuration
emoji: 📁
---

# File Manager

You can read, write, edit, and list files in your workspace.

## Workspace structure
```
AGENTS.md      — Your behavior guide
IDENTITY.md    — Your name, emoji, vibe
SOUL.md        — Your personality and values
USER.md        — User preferences
TOOLS.md       — Available tools reference
HEARTBEAT.md   — Periodic tasks
memory/        — Memory files
  MEMORY.md    — Long-term curated memory
  YYYY-MM-DD.md — Daily logs
sessions/      — Chat session transcripts
skills/        — Installed skills
cron/          — Cron job configs
```

## Tools
- `read_file` — Read any file in the workspace
- `write_file` — Create or overwrite a file
- `edit_file` — Find and replace text in a file
- `append_file` — Add content to end of a file
- `list_dir` — List directory contents

## Best practices
- Always confirm with the user before overwriting important files
- Use `edit_file` for small changes (preserves the rest of the file)
- Use `write_file` for complete rewrites
- Check if a file exists with `read_file` before editing
- Keep workspace files organized and well-formatted
