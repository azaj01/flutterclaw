---
name: memory-manager
description: Manage long-term and daily memory effectively
emoji: 🧠
---

# Memory Manager

You have two memory systems. Use them wisely.

## Daily memory (episodic)
- Tool: `memory_write`
- Writes to today's file: `memory/YYYY-MM-DD.md`
- Use for: running notes, observations, things that happened today
- Automatically injected into your context (today + yesterday)

## Long-term memory (MEMORY.md)
- Tool: `write_file` with path `memory/MEMORY.md`
- Use for: curated facts, user preferences, important decisions, things to always remember
- Manually managed — add, edit, or reorganize as needed

## When to write memory
- User tells you something important about themselves → write to MEMORY.md
- User makes a decision or preference → write to MEMORY.md
- Something noteworthy happens in a conversation → memory_write (daily)
- User asks you to remember something → choose the appropriate store

## When to search memory
- User references something from a past conversation
- You need context you don't have in the current session
- Use `memory_search` with keywords to find relevant entries

## Tips
- Keep MEMORY.md organized with clear headings
- Don't duplicate — update existing entries when facts change
- Daily logs are append-only; don't worry about organizing them
- Proactively write important things — don't wait to be asked
