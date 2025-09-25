# Commandline tools

## Gemini Cli

### Installation

Installation assumes that **[Node](https://nodejs.org/)** is installed and accessible:

```
npm install -g @google/gemini-cli
```

### Usage

Initialized **Node** environment by:

```
\Development\SetupEnvNode.cmd
Gemini
```

### Customization

#### GEMINI_SYSTEM_MD

The <b>*GEMINI_SYSTEM_MD*</b> environment variable is the key to chieving advanced customization. It instructs the **Gemini CLI** to source its core behavioral instructions from an external file rather than its hardcoded defaults.

The feature is enabled by setting the <b>*GEMINI_SYSTEM_MD*</b> environment variable within the shell. When the variable is set to true or 1, the CLI searches for a file named <b>*system.md*</b> within a <b>*.gemini*</b> directory at the project's root. This approach is recommended for project-specific configurations.

Setting the variable to any other string value directs the CLI to treat that string as an absolute path to a custom markdown file.

It is critical to note that the content of the specified file does not amend but completely replaces the default system prompt. This offers significant control but requires careful implementation.

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

## Llxprt Cli

**Llxprt Cli** is a fork of **Gemini Cli** that supports **OpenAI API** compatible providers.
It can be useful if you run **LLM**s locally when you don't want **Google** to see your data.

### Installation

Installation assumes that **[Node](https://nodejs.org/)** is installed and accessible:

```
npm install -g @vybestack/llxprt-code
```

### Usage

Initialized **Node** environment by:

```
\\Development\\SetupEnvNode.cmd
Llxprt
```

Use with local **OpenAI** compatible API:

```
/provider openai
/baseurl http://<server>:<port>/v1/
/model <model>
```

E.g. when running **LMStudio** locally, which provides an **OpenAI API** compatible **LLM**, the configuration will look like:

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
java -DDUMP=True -DDUMP_WIDTH=32 -jar JavaForwarder.jar 127.0.0.1 1234 8888
```

and changing the **Llxprt** configuration to:

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
