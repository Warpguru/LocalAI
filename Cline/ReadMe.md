# Cline

[Cline](https://cline.bot/) currently exists in multiple flavours: the **[Desktop](https://cline.bot/ide)** (plugins for various IDEs),
**[Cline Desktop](https://cline.bot/desktop)** and **[Cline CLI](https://cline.bot/cli)**.

This tutorial guides you through setting up the IDE and CLI in a portable way — meaning the installation can be placed on a portable storage device and swapped between PCs without any reinstallation required.

---

## Installlation

To use the portable installation, the environment needs to be set up first.
Open a **Command Prompt** and execute the following scripts:

1. `SetupEnvNode.cmd`
2. `SetupEnvBob.cmd` (ignore the instructions how to launch **Cline** until you have installed both flavours)

### Cline Desktop

**Cline Desktop** is a graphical shell to interface with many supported LLM harnesses such as **Ollama**, **Codex**, ...

1. Download latest version of **[Cline Desktop](https://cline.bot/ide)** (e.g. `Cline_0.0.28_x64-setup.exe`).
2. Install **Cline Desktop** into the default directory selected by the installer: `.\Users\Cline\AppData\Local\Cline`.
3. Launch **Cline Desktop**: `Cline-App` (which will execute `".\Users\Cline\AppData\Local\Cline\Cline-App.exe"`).
4. Select or configure your LLM harnes.

### Cline Shell

The **Cline CLI** is the **CLI** version resembling other terminal-native coding agents such as `Claude Code` or `Codex`.
It runs on a **Node** server (requires version >=22.15).

1. Install **Cline CLI** to **Node**: `npm i -g cline`.
2. Launch **Cline CLI**: `Cline`
3. Configure your LLM harness

---
