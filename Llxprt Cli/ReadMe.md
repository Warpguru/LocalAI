# Commandline tools

## Llxprt Cli

**Llxprt Cli** is a fork of **Gemini Cli** that supports **OpenAI API** compatible providers.
It can be useful if you run **LLM**s locally when you don't want **Google** to see your data or when you want to easily
trace the communication with tools like **[Fiddler](https://www.telerik.com/fiddler)**between a client and the **LLM**.

### Prerequisites

In order to use **Llxprt Cli** as a portable application the batch script <b>*SetupEnvLlxprtCli.cmd*</b> sets the required
virtualization of the environment:

```SetupEnvLlxprtCli.cmd
@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\LlxprtCli
SET APPDATA=%CURRENTDIR%Users\LlxprtCli\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\LlxprtCli\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO .
ECHO To launch Llxprt Cli enter: Llxprt
```

The installation of **Llxprt Cli** requires that **[Node](https://nodejs.org/)** is installed and accessible.
This repository does not include any **Node** instance, thus download e.g. version <b>*22.15.1*</b> of 
[Node](https://nodejs.org/dist/v22.15.1/node-v22.15.1-win-x64.zip) and unpack it into a directory e.g. <b>*D:\Node\22.15.1\*</b>.

To run **Node** adapt the following template batch script <b>*SetupEnvNode.cmd*</b> accordingly:

```
@SET CURRENTDIRECTORY=%~dp0
@Set NODE=D:\Node\22.15.1

@Set PATH=%NODE%;%PATH%
```

### Installation

Install **Llxprt Cli** with the Node Package Manager:

```
npm install -g @vybestack/llxprt-code
```

### Usage

If not done already initialize **Llxprt Cli** and **Node** environments and then run **Llxprt Cli** by:

```
SetupEnvLlxprtCli.cmd
SetupEnvNode.cmd
Llxprt
```

Switch to use a local **OpenAI API** compatible provider (such as <b>*Llama.cpp*</b>):

```
/provider openai
/baseurl http://<server>:<port>/v1/
/model <model>
```

E.g. when running **LMStudio** locally, which provides an **OpenAI API** compatible interface to e.g. the <b>*openai/gpt-oss-20b*</b> **LLM**, 
the configuration will look like:

```
/provider openai
/baseurl http://localhost:1234/v1/
/model openai/gpt-oss-20b
```

When you don't know the exact name of the model just invoke the <b>*/model*</b> command to manually select one of the **LLM**s supported by your **OpenAI API** compatible provider.

### Customization

#### GEMINI_SYSTEM_MD

The <b>*GEMINI_SYSTEM_MD*</b> environment variable is the key to chieving advanced customization. It instructs the **Llxprt CLI** to source its core behavioral instructions from an external file rather than its hardcoded defaults.

Doesn't seem to do anything.

When a custom prompt is active, the CLI footer displays:

```
|⌐■_■|
```

#### LLXPRT.md

Doesn't seem to do anything.

When a custom <b>*Llxprt.md*</b> is present (an custom system prompt is active), the CLI footer displays:

```
|⌐■_■| Using: 1 LLXPRT.md file
```

### Proxy

Instead of specifying the **OpenAI API** compatible **LLM** in the <b>*/baseurl*</b> command, you can specify a reverse proxy that forward the requests while also logging them.

#### JavaForwarder

For example, after starting **[JavaForwarder](https://github.com/Warpguru/JavaForwarder)** with:

```
java -DDUMP=True -DDUMP_WIDTH=32 -jar JavaForwarder.jar 127.0.0.1 <port> 8888
```

where <b>*port*</b> is the port of your **LLM** provider's **OpenAI API** interface (e.g. <b>*10000*</b> for **Llama.cpp** or
<b>*11434*</b>* for **Ollama**) and changing the **Llxprt** configuration to:

```
/baseurl http://127.0.0.1:8888/v1/
```

the communication between **Llxprt** and the **LLM** exposed by **LMStudio** will be logged in the command prompt **JavaForwarder** was started from.

#### Fiddler

Alternatively you can add the following rule to **[Fiddler](https://www.telerik.com/fiddler)** by invoking the editor for the <b>*OnBeforeRequest*</b> handler from <b>*Rules*</b> <b>*Customize Rules...*</b> to add as the first line:

```
// Forward traffic to LMStudio llama.cpp server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:1234"; 
```

and changing the **Llxprt** configuration to:

```
/baseurl http://localhost:8888/v1/
```

**Fiddler** will now log the communication between **Llxprt** and the **LLM** exposed by **LMStudio**, which can be verified best by switching the viewer to format the body to **Json** format.
