# IBM Consulting Advantage (ICA) API Quickstart Guide

This document provides a quick reference for connecting tools, IDE extensions (e.g., Cline, OpenCode, Codex), and CLI harnesses (e.g., Claude Code) to the IBM Consulting Advantage (ICA) API endpoints.

> **Status:** Current as of today (April 2025).

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

| Model ID | API | Mode | Max Input Tokens | Max Output Tokens | Notes |
|---|---|---|---|---|---|
| `claude-sonnet-5` | Anthropic | chat | 1,000,000 | 128,000 | Anthropic Claude Sonnet |
| `claude-sonnet-4-6` | Anthropic | chat | 1,000,000 | 128,000 | Anthropic Claude Sonnet |
| `claude-opus-5` | Anthropic | chat | 1,000,000 | 128,000 | Anthropic Claude Opus |
| `claude-opus-4-8` | Anthropic | chat | 1,000,000 | 128,000 | Anthropic Claude Opus |
| `claude-opus-4-6` | Anthropic | chat | 1,000,000 | 128,000 | Anthropic Claude Opus |
| `claude-haiku-4-5` | Anthropic | chat | 200,000 | 64,000 | Anthropic Claude Haiku |
| `gpt-5.6-terra` | OpenAI | chat | 922,000 | 128,000 | OpenAI GPT |
| `gpt-5.6-sol` | OpenAI | chat | 922,000 | 128,000 | OpenAI GPT |
| `gpt-5.6-luna` | OpenAI | chat | 922,000 | 128,000 | OpenAI GPT |
| `gpt-5.4` | OpenAI | chat | 1,050,000 | 128,000 | OpenAI GPT |
| `gpt-5.1` | OpenAI | chat | 272,000 | 128,000 | OpenAI GPT |
| `gpt-5.1-chat-gus` | OpenAI | chat | — | — | OpenAI GPT |
| `gpt-5.4-gus` | OpenAI | chat | — | — | OpenAI GPT |
| `gpt-5.6-luna-dzus` | OpenAI | chat | — | — | OpenAI GPT |
| `gpt-5.6-terra-dzus` | OpenAI | chat | — | — | OpenAI GPT |
| `gemini-3.7-flash` | OpenAI | chat | 1,048,576 | 65,536 | Google Gemini |
| `gemini-3.6-flash` | OpenAI | chat | 1,048,576 | 65,536 | Google Gemini |
| `gemini-3.5-flash` | OpenAI | chat | 1,048,576 | 65,535 | Google Gemini |
| `gemini-2.5-flash` | OpenAI | chat | 1,048,576 | 65,535 | Google Gemini |
| `gemini-2.5-flash-image` | OpenAI | image_generation | 32,768 | 32,768 | Multimodal / Image Gen |
| `watsonx-granite-3-8-b` | OpenAI | chat | — | — | IBM Granite |
| `ibm/granite-4-h-small` | OpenAI | chat | 20,480 | 20,480 | IBM Granite |
| `meta-llama/llama-3-3-70b-instruct` | OpenAI | chat | — | — | Meta LLaMA |
| `meta-llama/llama-4-maverick-17b-128e-instruct-fp8` | OpenAI | chat | — | — | Meta LLaMA |
| `gemma-4-26b-a4b-it` | OpenAI | chat | — | — | Google Gemma |
| `mistral-medium-2505` | OpenAI | chat | — | — | Mistral AI |
| `cross-encoder/ms-marco-minilm-l-12-v2` | OpenAI | embedding/ranking | — | — | Cross-encoder Model |
| `intfloat/multilingual-e5-large` | OpenAI | embedding | — | — | Embedding Model |
| `TMF-llama3.1-8b:251028_no_sys_prompt` | OpenAI | specialized | — | — | Domain-specific LLaMA |
| `BIAN-llama3.1-8b:260213_pad_free_assistant_only` | OpenAI | specialized | — | — | Domain-specific LLaMA |

---

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

### 5.3 Claude Code CLI — Anthropic API
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
