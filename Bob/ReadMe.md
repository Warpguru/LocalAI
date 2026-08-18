# IBM Bob

[IBM Bob](https://bob.ibm.com/) currently exists in two flavours: the **Bob IDE**, a **VSCode**-based graphical development environment, and the **Bob Shell**, a **CLI** (command-line interface) based tool.

This tutorial guides you through setting up both flavours in a portable way — meaning the installation can be placed on a portable storage device and swapped between PCs without any reinstallation required.

---

## Installation

To use the portable installation, the environment needs to be set up first.
Open a **Command Prompt** and execute the following scripts:

1. `SetupEnvNode.cmd`
2. `SetupEnvBob.cmd` (ignore the instructions how to launch **Bob** until you have installed both flavours)

### Bob IDE

The **Bob IDE** is the **VSCode** based graphical interactive development environment with some modifications resembling typical IDEs.

1. Download latest version of **[Bob IDE](https://bob.ibm.com/download)** (e.g. `IBM-BobUserSetup-x64-1.126.0+bob2.0.3.exe`).
2. Install **Bob IDE** into the default directory selected by the installer: `.\Users\Bob\AppData\Local\Programs\IBM Bob`. Deselect the option `Add to PATH (requires shell restart)`.
3. Launch Bob IDE: `BobIDE` (which will execute `".\users\Bob\\AppData\Local\Programs\IBM Bob\IBM Bob.exe"`).
4. You probably will need to authenticate before **Bob** can be used.

### Bob Shell

The **Bob Shell** is the **CLI** version resembling other terminal-native coding agents such as `Claude Code` or `Codex`.
It runs on a **Node** server (requires version >=22.15).

1. Check the latest version `x.y.z` (e.g. `2.0.1`) available from: `https://s3.us-south.cloud-object-storage.appdomain.cloud/bob-shell/bobshell2-version.txt`.
2. Download **Bob Shell**: `https://s3.us-south.cloud-object-storage.appdomain.cloud/bob-shell/bobshell-x.y.z.tgz`
3. Download **Bob Shell** checksum: `https://s3.us-south.cloud-object-storage.appdomain.cloud/bob-shell/bobshell-x.y.z.tgz.sha256`
4. Install **Bob Shell** into Node: `npm install -g bobshell-x.y.z.tgz`
5. Select one method to authenticate **Bob Shell**:
    - API key: Define the environment variable: `SET BOB_API_KEY=<apikey>` before launching **Bob Shell**.
    - SSO: Run `bob chat` and follow the login prompt in your browser.
6. Check the version: `bob --version`

#### Usage

```
bob [options] [command] [prompt...]

Options:
  -v, --version              Show current version number
  -p, --prompt <prompt>      Prompt to send to the agent
  -r, --resume [task-id]     Open the resume picker, or resume a specific task id
  --list-tasks [limit]       List available tasks (optional: number or 'all', default 20)
  --show-license             Show full paths to license files for review
  --accept-license           Accept the IBM license agreement and continue
  -h, --help                 display help for command

Commands:
  chat [options]             Launch the interactive terminal UI client
  run [options] [prompt...]  Execute a single task in headless mode
  mcp                        Manage MCP server configurations
```

#### Run a single task

```bash
bob run "What are the top-level directories in this workspace?"
```

#### Launch interactive chat

```bash
bob chat
```

#### Resume the latest task

```bash
bob --resume latest
```

#### Configuration

Defaults are stored in `./users/bob/.bob/settings/settings.json`. 
CLI arguments override these values.

---

## Administration

To administer your account, visit the [Administration](https://bob.ibm.com/admin/) page, where you can:
* view details about your **Subscription**
* review usage details with **Bobalytics**
* manage (create and delete) your **API keys**

---