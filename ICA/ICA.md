# IBM Consulting Advantage (ICA) API Quickstart Guide

This document provides a quick reference for connecting tools, IDE extensions (e.g., Cline, OpenCode, Codex), and CLI harnesses (e.g., Claude Code) to the IBM Consulting Advantage (ICA) API endpoints.

> **Status:** Current as of today (October 2026).

---

## 1. Obtaining API Keys

API keys for supported harnesses and tools (such as **Cline**, **Claude Code**, **ICA-Edge**, **Opencode**, and **Codex**) can be generated on the internal intranet portal:

👉 **[https://servicesessentials.ibm.com/settings/apikey](https://servicesessentials.ibm.com/settings/apikey)**

> **Security Note:** Never commit API keys to version control. Pass them via environment variables (e.g., `set IBM_API_KEY=...` or `export IBM_API_KEY=...`) or your tool's secure credential storage.

---

## 2. API Endpoints Overview

| API Protocol | Base URL | Auth Header Format | Common Clients |
|---|---|---|---|
| **OpenAI** | `https://api.servicesessentials.ibm.com/v1` | `Authorization: Bearer <API_KEY>` | Cline, Codex, OpenCode, SDKs |
| **Anthropic** | `https://api.servicesessentials.ibm.com` | `x-api-key: <API_KEY>`<br>`anthropic-version: 2023-06-01` | Claude Code CLI, Anthropic SDK |

> **Note!** No intranet connection (VPN tunnel) is required to access and use either of the API URLs. They are reachable over the public internet with a valid API key.

---

## 3. Querying Available Models

### OpenAI Endpoint (`/v1/models`)

```bash
curl -s -X GET "https://api.servicesessentials.ibm.com/v1/models" \
  -H "Authorization: Bearer $IBM_API_KEY" \
  -H "Content-Type: application/json"
```

### Anthropic Endpoint (`/v1/models`)

```bash
curl -s -X GET "https://api.servicesessentials.ibm.com/v1/models" \
  -H "x-api-key: $IBM_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json"
```

### 3.1 Supported Models

*(Status as of today)*

#### OpenAI-Compatible LLMs

| Model ID | Provider | Max Input Tokens | Max Output Tokens |
|----------|----------|-----------------:|------------------:|
| `claude-opus-5-5` | Anthropic | 1,000,000 | 128,000 |
| `claude-sonnet-5-5` | Anthropic | 1,000,000 | 128,000 |
| `claude-sonnet-5` | Anthropic | 1,000,000 | 128,000 |
| `claude-sonnet-4-6` | Anthropic | 1,000,000 | 64,000 |
| `claude-haiku-5-5` | Anthropic | 1,000,000 | 128,000 |
| `claude-haiku-4-5` | Anthropic | 200,000 | 64,000 |
| `gpt-6.1-sol` | OpenAI | 922,000 | 128,000 |
| `gpt-6-luna` | OpenAI | 922,000 | 128,000 |
| `gpt-5.6-terra` | OpenAI | 922,000 | 128,000 |
| `gpt-5.6-sol` | OpenAI | 922,000 | 128,000 |
| `gpt-5.6-luna` | OpenAI | 922,000 | 128,000 |
| `gpt-5.4` | OpenAI | 1,050,000 | 128,000 |
| `gpt-5.1` | OpenAI | 272,000 | 128,000 |
| `gemini-3.7-flash` | Google | 1,048,576 | 65,536 |
| `gemini-3.6-flash` | Google | 1,048,576 | 65,536 |
| `gemini-3.5-flash` | Google | 1,048,576 | 65,536 |
| `gemma-4-26b-a4b-it` | Google | 262,144 | 32,768 |
| `meta-llama/llama-3-3-70b-instruct` | Meta | 131,072 | 131,072 |
| `meta-llama/llama-4-maverick-17b-128e-instruct-fp8` | Meta | 131,072 | 8,192 |
| `nvidia/llama-3.3-nemotron-super` | NVIDIA | 131,072 | 131,072 |
| `watsonx/mistralai/mistral-medium-2505` | Mistral AI | 128,000 | 128,000 |
| `ibm/granite-4-h-small` | IBM | 20,480 | 20,480 |
| `rits/zai-org/glm-5-3` | Z.ai | 1,048,576 | 1,048,576 |
| `nvidia/nemotron-3.5-lightning` | NVIDIA | — | — |
| `TMF-llama3.1-8b:251028_no_sys_prompt` | Custom Llama 3.1 | — | — |
| `BIAN-llama3.1-8b:260213_pad_free_assistant_only` | Custom Llama 3.1 | — | — |

#### Anthropic-Compatible LLMs

| Model ID | Provider | Max Input Tokens | Max Output Tokens |
|----------|----------|-----------------:|------------------:|
| `claude-opus-5-5` | Anthropic | 1,000,000 | 128,000 |
| `claude-sonnet-5-5` | Anthropic | 1,000,000 | 128,000 |
| `claude-sonnet-5` | Anthropic | 1,000,000 | 128,000 |
| `claude-sonnet-4-6` | Anthropic | 1,000,000 | 64,000 |
| `claude-haiku-5-5` | Anthropic | 1,000,000 | 128,000 |
| `claude-haiku-4-5` | Anthropic | 200,000 | 64,000 |
| `gpt-6.1-sol` | OpenAI | 922,000 | 128,000 |
| `gpt-6-luna` | OpenAI | 922,000 | 128,000 |
| `gpt-5.6-terra` | OpenAI | 922,000 | 128,000 |
| `gpt-5.6-sol` | OpenAI | 922,000 | 128,000 |
| `gpt-5.6-luna` | OpenAI | 922,000 | 128,000 |
| `gpt-5.4` | OpenAI | 1,050,000 | 128,000 |
| `gpt-5.1` | OpenAI | 272,000 | 128,000 |
| `gemini-3.7-flash` | Google | 1,048,576 | 65,536 |
| `gemini-3.6-flash` | Google | 1,048,576 | 65,536 |
| `gemini-3.5-flash` | Google | 1,048,576 | 65,536 |
| `gemma-4-26b-a4b-it` | Google | 262,144 | 32,768 |
| `meta-llama/llama-3-3-70b-instruct` | Meta | 131,072 | 131,072 |
| `meta-llama/llama-4-maverick-17b-128e-instruct-fp8` | Meta | 131,072 | 8,192 |
| `nvidia/llama-3.3-nemotron-super` | NVIDIA | 131,072 | 131,072 |
| `watsonx/mistralai/mistral-medium-2505` | Mistral AI | 128,000 | 128,000 |
| `ibm/granite-4-h-small` | IBM | 20,480 | 20,480 |
| `rits/zai-org/glm-5-3` | Z.ai | 1,048,576 | 1,048,576 |
| `nvidia/nemotron-3.5-lightning` | NVIDIA | — | — |
| `TMF-llama3.1-8b:251028_no_sys_prompt` | Custom Llama 3.1 | — | — |
| `BIAN-llama3.1-8b:260213_pad_free_assistant_only` | Custom Llama 3.1 | — | — |

## 4. AI Chat PoC Example (`ICA_Chat.cmd`)

The script [`ICA_Chat.cmd`](ICA_Chat.cmd) provides a quick proof-of-concept (PoC) demonstrating chat completion requests against both the OpenAI-compatible and Anthropic-native endpoints.

### OpenAI Chat Completions Example
- **Endpoint:** `POST https://api.servicesessentials.ibm.com/v1/chat/completions`
- **Model:** `gpt-5.6-terra`
- **Payload:**
  ```json
  {
    "model": "gpt-5.6-terra",
    "messages": [
      { "role": "user", "content": "Why is the sky blue? Explain in one brief sentence." }
    ]
  }
  ```

### Anthropic Messages Example
- **Endpoint:** `POST https://api.servicesessentials.ibm.com/v1/messages`
- **Model:** `claude-sonnet-5`
- **Payload:**
  ```json
  {
    "model": "claude-sonnet-5",
    "max_tokens": 150,
    "messages": [
      { "role": "user", "content": "Why is the sky blue? Explain in one brief sentence." }
    ]
  }
  ```

### Running the Chat Test on Windows
```cmd
set IBM_API_KEY=your_api_key_here
ICA_Chat.cmd
```

---

## 5. Tool Setup Examples

### 5.1 Cline (VSCode Extension) — OpenAI API Configuration Example

In VSCode, open the Cline settings panel (gear icon) and configure the fields as key:value pairs:

- **API Provider:** `OpenAI Compatible`
- **Base URL:** `https://api.servicesessentials.ibm.com/v1`
- **OpenAI Compatible API Key:** `<YOUR_CLINE_API_KEY>`
- **Model ID:** `gpt-5.4`
- **Set Azure API version:** *(unchecked)*
- **Use Azure Identity Authentication:** *(unchecked)*
- **Reasoning Effort:** `Medium` *(or as preferred)*
- **Use different models for Plan and Act modes:** *(optional / as preferred)*

> **Note:** Available models cannot be retrieved automatically in the VSCode extension and must be typed / pasted into the **Model ID** field manually from the list in Section 3.1.

### 5.2 Cline IDE — OpenAI Compatible Configuration Example

In the standalone Cline IDE, navigate to Settings / Providers and configure:

- **Provider:** `OpenAI Compatible`
- **API Key:** `<YOUR_CLINE_API_KEY>`
- **Base URL:** `https://api.servicesessentials.ibm.com/v1`
- **Models:** Add model IDs manually (e.g., `gpt-5.6-terra`, `gemini-3.6-flash`, `watsonx-granite-3-8-b`, etc.) by clicking the `+` button.

> **Note:** Available models cannot be retrieved automatically via the refresh button (the client does not send the authorization header during discovery, resulting in `401 Unauthorized`). Models must be added manually using the `+` button.

### 5.3 OpenCode — OpenAI API Configuration Example

In `opencode.json`, add the ICA provider block under `"providers"`. By omitting `"apiKey"` from `"options"`, `@ai-sdk/openai-compatible` will automatically use the standard `OPENAI_API_KEY` environment variable:

```json
    "ICA": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "IBM Consulting Advantage (ICA)",
      "options": {
        "baseURL": "https://api.servicesessentials.ibm.com/v1"
      },
      "models": {
        "gpt-5.6-terra": {
          "name": "GPT-5.6 Terra",
          "limit": {
            "context": 922000,
            "output": 128000
          }
        },
        "gpt-5.4": {
          "name": "GPT-5.4",
          "limit": {
            "context": 1050000,
            "output": 128000
          }
        },
        "gemini-3.7-flash": {
          "name": "Gemini 3.7 Flash",
          "limit": {
            "context": 1048576,
            "output": 65536
          }
        },
        "claude-sonnet-5": {
          "name": "Claude Sonnet 5",
          "limit": {
            "context": 1000000,
            "output": 128000
          }
        },
        "ibm/granite-4-h-small": {
          "name": "IBM Granite 4 H Small",
          "limit": {
            "context": 20480,
            "output": 20480
          }
        }
      }
    }
```

> **Note on API Key:** The `OPENAI_API_KEY` environment variable must be set **before** launching OpenCode (e.g., `set OPENAI_API_KEY=sk-...` on Windows or `export OPENAI_API_KEY=sk-...` on Linux/macOS). If not set beforehand, requests will fail with authorization errors until you run `/connect` inside OpenCode, select the `"IBM Consulting Advantage (ICA)"` harness, and provide the key interactively when prompted. Alternatively, you can specify `"apiKey": "<YOUR_API_KEY>"` directly within `"options"`.

### 5.4 Claude Code CLI — Anthropic API

1. Set the custom base URL and your dedicated Claude Code API key in your environment:
   - **Linux / macOS**:
     ```bash
     export ANTHROPIC_BASE_URL=https://api.servicesessentials.ibm.com
     export ANTHROPIC_API_KEY=<YOUR_CLAUDE_CODE_API_KEY>
     ```
   - **Windows (CMD)**:
     ```cmd
     set ANTHROPIC_BASE_URL=https://api.servicesessentials.ibm.com
     set ANTHROPIC_API_KEY=<YOUR_CLAUDE_CODE_API_KEY>
     ```
   - **Windows (PowerShell)**:
     ```powershell
     $env:ANTHROPIC_BASE_URL="https://api.servicesessentials.ibm.com"
     $env:ANTHROPIC_API_KEY="<YOUR_CLAUDE_CODE_API_KEY>"
     ```
2. Run Claude Code:
   ```bash
   claude
   ```

---

## 6. Windows Model Verification Script

Run [`ICA_Models.cmd`](ICA_Models.cmd) to verify model list endpoints from Windows CMD:

```cmd
set IBM_API_KEY=your_api_key_here
ICA_Models.cmd
```
