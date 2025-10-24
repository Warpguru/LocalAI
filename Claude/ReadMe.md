# Claude Code

**Claude Code** by default requires a paid account, the minimal value is currently <b>*$5*</b>.
In order to use it for free, which still requires you to register at **Anthropic** e.g. with your **Google** account, 
some configuration changes need to be applied before running **Claude Code**.

Additionally **Claude Code** does not support the standard of the **OpenAI API** interface, so <b>*ClaudeProxy.py*</b> is
provided here for a translation layer (**Note!** Streaming does not work yet).

**You set the environment variable ANTHROPIC_BASE_URL to an OpenAI-compatible endpoint and ANTHROPIC_AUTH_TOKEN to the API token for the service.**

## Prerequisites

### Python3

To run <b>*ClaudeProxy.py*</b> a **[Python 3](https://www.python.org/downloads/windows/)** environment is required.
When available adapt and run <b>*SetupEnvPython3.cmd*</b>:

```SetupEnvPython3.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET PYTHON=%CD:~0,2%\Python\3.13.3
SET PYCHARM=%CD:~0,2%\PyCharm

REM Either have directories in python313._pth or in PYTHONPATH environment variable
REM See: https://michlstechblog.info/blog/python-install-python-with-pip-on-windows-by-the-embeddable-zip-file/
REN %PYTHON%\python313._pth python313._pth.original
SET PATH=%PYTHON%;%PYTHON%\Scripts;%PYCHARM%\bin;%PATH%
SET PYTHONPATH=%PYTHON%;%PYTHON%\DLLs;%PYTHON%\lib;%PYTHON%\lib\plat-win;%PYTHON%\lib\site-packages
```

### Bash

**Claude Code** insists in a **Unix** compatible environment which can be **[Git Bash](https://git-scm.com/downloads/win)**.
After the shell is available adjust the path to <b>*bash.exe*</b> in <b>*SetupEnvClaude*</b> accordingly:

```SetupEnvClaude.cmd
@ECHO OFF
SET CLAUDE_CODE_GIT_BASH_PATH=D:\Development\Git\bin\bash.exe
SET ANTHROPIC_API_KEY=dummy-key
SET ANTHROPIC_BASE_URL=http://localhost:8000
SET CURRENTDIRECTORY=%~dp0
SET USERPROFILE=%CURRENTDIRECTORY%Users\Claude
SET APPDATA=%CURRENTDIRECTORY%Users\Claude\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIRECTORY%Users\Claude\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO.
ECHO To launch Claude Code enter: Claude
```

### ClaudeProxy.py

The reverse proxy <b>*ClaudeProxy.py*</b> is provided as an interface between **Claude Code** and an **OpenAI API** compatible
**LLM**.
Assuming a **Python 3** environment is available, it's development environment was created by:

```
uv venv ClaudeProxy
.\Scripts\activate
uv pip install flask
```

Next you likely need to change the configuration of <b>*ClaudeProxy.py*</b> to specify the **Url** of an **LLM** that provides
an **OpenAI API** compatible interface: 

```
# Configuration
OPENAIAPI_BASE_URL = "http://localhost:8888"  # Use Ollama, Llama.cpp or Fiddler reverse proxy url
OPENAIAPI_MODEL = "gpt-oss:20b"  # Change to your model
```

Above example additionally routes the messages via **[Fiddler](https://www.telerik.com/fiddler)**, which is then configured to
route the messages to an **LLM** e.g. **Llama.cpp** at <b>*http://localhost:10000/*</b>. 

To start <b>*ClaudeProxy.py*</b> activate the virtual Python environment (if not done yet) and launch the reverse proxy:

```
cd .\ClaudeProxy
.\Scripts\Acitvate
Python ClaudeProxy.py

```

Running <b>*ClaudeProxy.py*</b> by <b>*Python ClaudeProxy.py*</b> it will provide the following Rest-WebServices to
validate the installation and connection to a **LLM**:

```
http://localhost:8000/health
http://localhost:8000/v1/models
```

To test the communication between <b>*ClaudeProxy.py*</b> and **OpenAI API** compatible **LLM** request a <b>*Hello World!*</b>
program to be composed by the **LLM**.
Without requesting the **LLM** to stream the answer:

```
curl -X POST http://localhost:8000/v1/messages -H "Content-Type: application/json" -d "{""model"":""claude-3-sonnet-20240229"",""messages"":[{""role"":""user"",""content"":""Write a simple hello world function in Python""}]}"
```

With requesting the **LLM** to stream the answer (**Note!** Streaming does not work yet):


```
curl -X POST http://localhost:8000/v1/messages -H "Content-Type: application/json" -d "{""model"":""claude-3-sonnet-20240229"",""messages"":[{""role"":""user"",""content"":""Write a simple hello world function in Python""}], ""stream"": ""true""}"
```

## Claude Code Cli

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

### Installation

Install **Gemini Cli** with the Node Package Manager:

```
npm install -g @anthropic-ai/claude-code
```

### Usage

Initialize **Node** environment and run **Claude Code Cli** by:

```
SetupEnvClaude.cmd
Claude
```
