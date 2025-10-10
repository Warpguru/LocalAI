# Continue.dev

## Prerequisites

**Continue.dev** is available as an extension to **[VisualStudio Code](https://code.visualstudio.com/download)** and as
a commandline application
(or alternatively to **[IntelliJ](https://plugins.jetbrains.com/plugin/22707-continue)**).

### VSCode

In order to run **VS Code** with a configuration specific for **Continue.dev** run <b>*SetupEnvCode.cmd*</b> to initialize with a
portable **VS Code** environment (adjust the path to appropriately, the configuration is stored locally in the <b>*.\Users\*</b>
directory):

```SetupEnvCode.cmd
@ECHO OFF
SET CURRENTDIR=%~dp0
SET PATH=X:\VSCode;%PATH%
SET USERPROFILE=%CURRENTDIR%Users\Continue
SET APPDATA=%CURRENTDIR%Users\Continue\AppData\Roaming
IF NOT EXIST %APPDATA% MKDIR %APPDATA% >NUL

ECHO.
ECHO Start VisualStudio Code (supporting Continue.dev once extension is installed) by executing: VSCode
```

This portable **VS Code** configuration allows you to install e.g. the **Continue.dev** extension so that it is available
only when running **VS Code** in this environment.
One can play with this extension without being in danger to mess up **VS Code**.
By deleting the directory <b>*.\Users\*</b> one can restart by zero again.
To launch the portable version of **VS Code** run <b>*VSCode.cmd*</b>:

```VSCode.cmd
@START "VS Code (Continue.dev)" cmd /c Code
```

### Python3

The built-in <b>*Tools*</b> of **Continue.dev** (e.g. to read or write files) are based on **Python** (likely to be cross-platform
compatible).
In order to use the **Agent** mode successfully with a **LLM** a **Python** environment must be available within **VS Code**. 

### Node

**Continue Cli** requires that **[Node](https://nodejs.org/)** is installed and accessible.
This repository does not include any **Node** instance, thus download e.g. version <b>*22.15.1*</b> of 
[Node](https://nodejs.org/dist/v22.15.1/node-v22.15.1-win-x64.zip) and unpack it into a directory e.g. <b>*D:\Node\22.15.1\*</b>.

To run **Node** adapt the following template batch script <b>*SetupEnvNode.cmd*</b> accordingly:

```
@SET CURRENTDIRECTORY=%~dp0
@Set NODE=D:\Node\22.15.1

@Set PATH=%NODE%;%PATH%
```

## Continue.dev

### Installation

To install tne **Continue.dev** extension into **VS Code**:

1. Launch **VS Code**
2. Open <b>*Extensions*</b> search for <b>*Continue*</b>
3. Install <b>*Continue - open-source AI code agent*</b> (e.g. at the time of writing this version <b>*1.2.8*</b>).

### Configuration

Once the **Continue.dev** extension is installed, your local **OpenAI API** compatible **LLM** needs to be configured,
the initial configuration can be created by:

1. Select the <b>*Continue.dev*</b> icon
2. Select <b>*Or, configure your own models*</b> as a local **LLM** will be used, not one from the cloud providers
3. Select <b>*Local*</b>
4. Select <b>*Skip and select manually*</b> which will open the configuration file <b>*config.yaml*</b> located in the 
portable **VS Code** configuration at <b>*.\Users\Continue\.continue\config.yaml*</b>
5. Copy one of the configuration templates below and <b>*Save*</b> the changes to become effective (this will cause **VS Code**
to communicate with the **LLM** using the **OpenAI API** interface, if not the configuration is incorrect)

To use **LLM** provided by **Ollama** the following configuration can be used (the url at <b>*apiBase*</b> sends the messages
between **VS Code** and **Ollama** over **Fiddler** as the reverse proxy (see below for more details about proxies):

```yaml
name: Local Agent
version: 1.0.0
schema: v1
models:
 - title: Ollama
   name: Autodetect
   provider: ollama
   apiBase: http://localhost:8888
   model: AUTODETECT
   roles:
     - apply
     - autocomplete
     - chat
     - edit
     - embed
     - rerank
```

To use **Llama.cpp** switch to (**Note!** that <b>*Autodetect*</b> is not supported for this **LLM** provider):

```yaml
name: Local Agent
version: 1.0.0
schema: v1
models:
 - title: llama-server
   name: .\Models\gpt-oss-20b\gpt-oss-20b-MXFP4.gguf
   provider: openai
   apiBase: http://localhost:8888
   model: .\Models\gpt-oss-20b\gpt-oss-20b-MXFP4.gguf
   roles:
     - apply
     - autocomplete
     - chat
     - edit
     - embed
     - rerank
```

**Hint!** The value in the **provider** key is the name of a **Python** package that implements it.
Though **Continue.dev** officially supports **Llama.cpp** you must not use the provider <b>*llama.cpp*</b> (as sometimes
suggested) but <b>*openai*</b>.

You can anytime access <b>*config.yaml*</b> also by:

1. Select the <b>*Continue.dev*</b> icon
2. Open <b>*Settings*</b> by clicking its icon
3. Select the <b>*Agents*</b> icon in the icon menubar
4. On <b>*Local Agent*</b> click <b>*Settings*</b>

## Continue Cli

At the time of writing **[Continue Cli](https://docs.continue.dev/guides/cli)** is in beta and it shares its configuration with
**Continue.dev** (so at least when you want to start with an existing configuration **Continue.dev** must be run and configured before).

### Installation

Install **Continue Cli** with the Node Package Manager:

```
npm install -g @google/gemini-cli
```

**Continue Cli** can be run in interactive mode (similar to **Gemini Cli** or **Llxpert Cli**:

```
cn
```

or in headless mode:

```
cn -p "Generate a conventional commit name for the current git changes"
```

### Configuration

**Continue Cli** can use the same configuration as **Continue.dev**, which is typically persisted in <b>*.\Users\Continue\.continue\config.yaml*</b>.
However **Continue Cli** by default uses **LLM** available on the **[Continue Hub](https://hub.continue.dev/)**, for which you can
register by logging in with your e.g. **Google** account.

When **Continue Cli** has been started in interactive mode, by default it uses **LLM**s available on the **Continue Hub**
with a limited amount of free tokens.
So you might invoke the <b>*/config*</b> command and switch from <b>*[Personal] Default Assistant*</b> to <b>*[Personal] Local config.yaml*</b>
and press enter:

```
Select Configuration            
                                                                                                                                                                           
  ➤ [Personal] Local config.yaml
    [Personal] Default Assistant ✔
    Create new assistant (opens web)
    
  ↑/↓ to navigate, Enter to select, Esc to cancel  
```

**Continue Cli** will show e.g. the following details about the selected **LLM** (which can be changed with the <b>*/model*</b> command:

```
 Agent: Local Agent
 Model: .\Models\gpt-oss-20b\gpt-oss-20b-MXFP4.gguf
```

**Local Agent** and the mentioned **LLM** were the ones configured in **Continue.dev** about when using **Llama.cpp** as the **LLM** provider.

## Proxy

Instead of specifying the **OpenAI API** compatible **LLM** in the <b>*apiBase*</b> key, you can specify a reverse proxy that forwards
the requests while also logging them (as shown in the examples above).

### JavaForwarder

For example, after starting **[JavaForwarder](https://github.com/Warpguru/JavaForwarder)** with:

```
java -DDUMP=True -DDUMP_WIDTH=32 -jar JavaForwarder.jar 127.0.0.1 <port> 8888
```

where <b>*port*</b> is the port of your **LLM** provider's **OpenAI API** interface (e.g. <b>*10000*</b> for **Llama.cpp** or
<b>*11434*</b> for **Ollama**) and changing the **Continue.dev** configuration to:

```yaml
   apiBase: http://localhost:8888
```

the communication between **Continue.dev** or **Continue Cli** and the **LLM** will be logged in the command prompt **JavaForwarder** was started from.

### Fiddler

Alternatively you can add the following rule to **[Fiddler](https://www.telerik.com/fiddler)** by invoking the editor for the <b>*OnBeforeRequest*</b> handler from <b>*Rules*</b> <b>*Customize Rules...*</b> to add as the first line:

```
// Forward traffic to LMStudio llama.cpp server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:1234"; 
if (oSession.host.toLowerCase() == "127.0.0.1:8888") oSession.host = "localhost:1234"; 
```

and changing the **Continue.dev** configuration to (which can also be used by **Continue Cli**):

```yaml
   apiBase: http://localhost:8888
```

**Fiddler** will now log the communication between **Continue.dev** or **Continue Cli** and the **LLM**, 
which can be verified best by switching the viewer to format the body to **Json** format.
