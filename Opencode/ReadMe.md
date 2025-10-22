# Commandline tools

## Opencode

After you install it, **Opencode** ships with a set of default large language models (LLMs) that are ready to use right away.
It also supports any **OpenAI API** compatible LLM provider, whether commercial or open source, including models that run locally
on your machine.

The tool comes with two built-in modes, <b>*Build*</b> and <b>*Plan*</b>.
These can be replaced or extended with custom modes, which is especially useful if you want to supply your own **system message**s.
One thing to keep in mind is that the default modes include heavy **system message**s that invoke various tools.
This can quickly consume thousands of tokens, potentially slowing down or even breaking local **LLM**s — particularly as there 
are differences in how *Ollama** and **Llama.cpp** handle **Go** and **Jinja2** template formats. 

### Prerequisites

The installation of **Opencode** requires that **[Node](https://nodejs.org/)** is installed and accessible.
This repository does not include any **Node** instance, thus download e.g. version <b>*22.15.1*</b> of 
[Node](https://nodejs.org/dist/v22.15.1/node-v22.15.1-win-x64.zip) and unpack it into a directory e.g. <b>*D:\Node\22.15.1\*</b>.

To run **Node** adapt the following template batch script <b>*SetupEnvNode.cmd*</b> accordingly:

```SetupEnvNode.cmd
@SET CURRENTDIRECTORY=%~dp0
@Set NODE=D:\Node\22.15.1

@Set PATH=%NODE%;%PATH%
```

In order to use **Opencode** as a portable application the batch script <b>*SetupEnvOpencode.cmd*</b> sets the required
virtualization of the environment:

```SetupEnvOpencode.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET USERPROFILE=%CURRENTDIRECTORY%Users\Opencode
SET APPDATA=%CURRENTDIRECTORY%Users\Opencode\AppData\Roaming
IF NOT EXIST %APPDATA% MKDIR %APPDATA% >NUL

ECHO.
ECHO To launch Opencode enter: Opencode
```

### Installation

Install **[Opencode Cli](https://opencode.ai/)** with the Node Package Manager:

```
npm i -g opencode-ai
```

### Configuration

To use a local **LLM** such as **Llama.cpp** servicing <b>*Gpt-Oss-20b*</> put the following configuration in your current directory:

```opencode.json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "OpenAI API (local)",
      "options": {
        "baseURL": "http://localhost:10000/v1"
      },
      "models": {
        "gpt-oss-20b": {
          "name": ".\\Models\\gpt-oss-20b\\gpt-oss-20b-MXFP4.gguf",
          "options": {
            "timeout": 300000
          }
        }
      }
    }
  }
}
```

### Usage

Initialize **Node** and **Opencode** environments and run **Opencode Cli** by:

```
SetupEnvOpencode.cmd
SetupEnvNode.cmd
Opencode
```

### Customization

