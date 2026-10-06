# Claude Code

**Claude Code** by default requires a paid account, the minimal value is currently <b>*$5*</b>.
In order to use it for free, which still requires you to register at **Anthropic** e.g. with your **Google** account, 
some configuration changes need to be applied before running **Claude Code**.

Additionally **Claude Code** does not support the standard of the **OpenAI API** interface!

---

## Prerequisites

### Node

The installation of **Claude Code** requires that **[Node](https://nodejs.org/)** is installed and accessible.
This repository does not include any **Node** instance, thus download e.g. version <b>*22.15.1*</b> of 
[Node](https://nodejs.org/dist/v22.15.1/node-v22.15.1-win-x64.zip) and unpack it into a directory e.g. <b>*D:\Node\22.15.1\*</b>.

To run **Node** adapt the following template batch script <b>*SetupEnvNode.cmd*</b> accordingly:

```SetupEnvNode.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET NODE=%CD:~0,2%\Node\22.15.1

SET PATH=%NODE%;%PATH%
```

### Bash

**Claude Code** insists in a **Unix** compatible environment which can be **[Git Bash](https://git-scm.com/downloads/win)**.
After the shell is available adjust the path to <b>*bash.exe*</b> in <b>*SetupEnvClaude*</b> accordingly:

### SetupEnvClaude.cmd

```SetupEnvClaude.cmd
@ECHO OFF
SET CLAUDE_CODE_GIT_BASH_PATH=D:\Development\Git\bin\bash.exe
SET ANTHROPIC_BASE_URL=https://api.nextgen-beta.ica.ibm.com/ica
SET ANTHROPIC_API_KEY=<your private API key>
SET ANTHROPIC_AUTH_TOKEN=<your ICA API key>
SET ANTHROPIC_MODEL=claude-sonnet-5
SET ANTHROPIC_DEFAULT_OPUS_MODEL=claude-sonnet-5
SET ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-4-6
SET ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5
SET CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6
SET CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
SET CURRENTDIRECTORY=%~dp0
SET USERPROFILE=%CURRENTDIRECTORY%Users\Claude
SET APPDATA=%CURRENTDIRECTORY%Users\Claude\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIRECTORY%Users\Claude\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO.
ECHO To launch Claude Code enter: Claude
```

---

## Claude Code CLI

### Installation

Install **Claude Code Cli** from a Windows command prompt:

```
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

### Usage

Initialize **Node** environment and run **Claude Code Cli** by:

```
SetupEnvClaude.cmd
Claude
```

**Note!** When also launching **VS Code** from that environment, the credentials and chats from **Claude Code CLI** are shared with the **Claude Code for VS Code** plugin.

### Update

```
Claude --version
Claude update
```

---

## ICA

### API-key

To use **Claude Code** via [ICA 2.0 Gateway](https://ibm.ent.box.com/s/lyocuot1r6xqfr7g978ear17du46nhrs) create an API keys on [ICA](https://nextgen-beta.ica.ibm.com/ica/settings/apikey) and use the `claude-code` API key (`sk-...`).
