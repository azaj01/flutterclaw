---
name: web-search
description: Search the web for current information and fetch web pages
emoji: 🔍
---

# Web Search

Use the `web_search` and `web_fetch` tools to find current information.

## When to use
- User asks about current events, news, or recent information
- User needs real-time data (weather, stock prices, sports scores)
- User asks "what is X" and you're not confident in your training data
- User asks you to look something up

## How to use
1. Use `web_search` with a clear, specific query
2. Review the results and summarize the most relevant information
3. If you need more detail from a specific result, use `web_fetch` with its URL
4. Always cite your sources with URLs when providing web-sourced information

## Tips
- Be specific in queries: "Flutter 3.x release date 2026" not just "Flutter"
- If first search doesn't help, try rephrasing
- Combine multiple searches for complex questions
- Use `web_fetch` to get the full content of a promising search result
