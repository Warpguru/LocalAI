# Commandline tools

## Gemini Cli

### Prerequisites

In order to use **Gemini Cli** as a portable application the batch script <b>*SetupEnvGeminiCli.cmd*</b> sets the required
virtualization of the environment:

```SetupEnvGeminiCli.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET USERPROFILE=%CURRENTDIRECTORY%Users\GeminiCli
SET APPDATA=%CURRENTDIRECTORY%Users\GeminiCli\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\GeminiCli\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO .
ECHO To launch Gemini Cli enter: Gemini
```

The installation of **Gemini Cli** requires that **[Node](https://nodejs.org/)** is installed and accessible.
This repository does not include any **Node** instance, thus download e.g. version <b>*22.15.1*</b> of 
[Node](https://nodejs.org/dist/v22.15.1/node-v22.15.1-win-x64.zip) and unpack it into a directory e.g. <b>*D:\Node\22.15.1\*</b>.

To run **Node** adapt the following template batch script <b>*SetupEnvNode.cmd*</b> accordingly:

```
@SET CURRENTDIRECTORY=%~dp0
@Set NODE=D:\Node\22.15.1

@Set PATH=%NODE%;%PATH%
```

### Installation

Install **Gemini Cli** with the Node Package Manager:

```
npm install -g @google/gemini-cli
```

### Usage

If not done already initialize **Gemini Cli** and **Node** environments and then run **Gemini Cli** by:

```
SetupEnvGeminiCli.cmd
SetupEnvNode.cmd
Gemini
```

### Customization

#### GEMINI_SYSTEM_MD

The <b>*GEMINI_SYSTEM_MD*</b> environment variable is the key to chieving advanced customization. It instructs the **Gemini CLI** to source its core behavioral instructions from an external file rather than its hardcoded defaults.

The feature is enabled by setting the <b>*GEMINI_SYSTEM_MD*</b> environment variable within the shell. When the variable is set to true or 1, the CLI searches for a file named <b>*system.md*</b> within a <b>*.gemini*</b> directory at the project's root. This approach is recommended for project-specific configurations.

Setting the variable to any other string value directs the CLI to treat that string as an absolute path to a custom markdown file.

It is critical to note that the content of the specified file does not amend but completely replaces the default system prompt.
This offers significant control but requires careful implementation.

When a custom prompt is active, the CLI footer displays:

```
|⌐■_■|
```

#### GEMINI.md

To replace the system prompt create a file named b>*Gemini.md*</b> at the project's root directory containing the instructions (e.g. <b>*You always answer as Donald Trump would do!*</b> to get some interesting responses).

When a custom <b>*Gemini.md*</b> is present (an custom system prompt is active), the CLI footer displays:

```
|⌐■_■| Using: 1 GEMINI.md file
```
