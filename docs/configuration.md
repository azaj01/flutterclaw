# Configuration

FlutterClaw is configured via a single JSON file.

**Config file path:** `{app_documents}/flutterclaw/config.json`

On Android this is typically under app-specific storage; on iOS, in the app's Documents directory.

---

## Example config.json

```json
{
  "agents": {
    "defaults": {
      "model_name": "gpt-4o",
      "max_tokens": 8192,
      "temperature": 0.7,
      "max_tool_iterations": 20
    }
  },
  "model_list": [
    {
      "model_name": "gpt-4o",
      "model": "openai/gpt-4o",
      "api_key": "sk-your-key"
    }
  ],
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allow_from": ["YOUR_USER_ID"]
    },
    "discord": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allow_from": ["YOUR_USER_ID"]
    }
  }
}
```

## Sections

- **agents.defaults** — Default model, max tokens, temperature, and max tool iterations for new agents.
- **model_list** — List of LLM entries: `model_name`, `model` (provider path), and `api_key` (or equivalent for each provider).
- **channels** — Channel adapters (e.g. `telegram`, `discord`) with `enabled`, `token`, and `allow_from` (user allowlist) or other provider-specific options.

API keys are stored securely in the platform keychain; the config file may reference them or they may be set via the app UI.
