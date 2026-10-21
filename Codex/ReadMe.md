# Codex

## Installation

To use the portable installation, the environment needs to be set up first.
Open a **Command Prompt** and:

1. Adjust the `OPENAI_API_KEY` in `SetupEnvCodex.cmd`
2. Execute: `SetupEnvCodex.cmd`

### Codex CLI

To install or update the **Codex CLI**:

1. Run the command: `powershell -ExecutionPolicy ByPass -c "irm https://chatgpt.com/codex/install.ps1 | iex"`
2. Despite the virtualized (portable) installation the installer modifies your environment, however you can safely remove the 
**Codex** related environment variables again.
3. To overwrite the default API provider create the configuration file: `%USERPROFILE%\.codex\config.toml`:
    ```
    model = "gpt-advantage-assist"  
    model_provider = "ica"

    [model_providers.ica]
    name = "ICA Global Instance"
    base_url = "https://api.servicesessentials.ibm.com/v1"
    wire_api = "responses"
    env_key = "OPENAI_API_KEY"
    ```

### Usage

On the first launch:

* Select `3. Provide your own API key`
  - `API key`: `sk-******`
* Select `2. Use non-admin sandbox (higher risk if prompt injected)`

---
