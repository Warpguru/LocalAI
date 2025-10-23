# MstyStudio

## Installation

To create a portable installation of **[MstyStudio](https://msty.ai/)**:

1. Install **MstyStudio** with the downloaded installer.
2. Copy the **Msty** program and configuration to this repository folder (replace <b>*User*</b> with your username):

   ```
   XCOPY X:\Users\<User>\AppData\Local\Programs\MstyStudio .\MstyStudio\ /s /e /v
   XCOPY X:\Users\<User>\AppData\Roaming\MstyStudio .\Users\MstyStudio\AppData\Roaming\MstyStudio\ /s /e /v
   ```
3. Deinstall **MstyStudio** again

## Usage

Initialize the portable **MstyStudio** environment and launch it with <b>*SetupEnvMsty.cmd*</b>:

```SetupEnvMsty.cmd
@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\MstyStudio
SET APPDATA=%CURRENTDIR%Users\MstyStudio\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\MstyStudio\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

@REM Start GUI in separate process
ECHO.
Start "MstyStudio" .\MstyStudio\MstyStudio
ECHO You may need to register local LLM providers (like e.g.: Ollama, Llama.cpp) as a remote LLM in Msty
```

After installing **MstyStudio** your local **LLM** providers need to be added as <b>*Remote Model Providers*</b>.
When adding a **LLM** provider to the <b>*Model hub*</b> consider the providers:

  - For **Ollama** add an <b>*Ollama*</b> provider entry e.g. <b>*Ollama@localhost*</b> with the Url <b>*http://127.0.0.1:11434/*</b>.
  - For **Llama.cpp** add an <b>*Open AI compatible*</b> provider entry e.g. <b>*Llama.cpp@localhost*</b> with the Url <b>*http://127.0.0.1:10000/*</b>

## Proxy

Instead of specifying the **OpenAI API** compatible **LLM** provider e.g. **Ollama**, you can specify a reverse proxy that forward the requests while also logging them.

### JavaForwarder

For example, after starting **[JavaForwarder](https://github.com/Warpguru/JavaForwarder)** with:

```
java -DDUMP=True -DDUMP_WIDTH=32 -jar JavaForwarder.jar 127.0.0.1 <port> 8888
```

where <b>*port*</b> is the port of your **LLM** provider's **OpenAI API** interface (e.g. <b>*10000*</b> for **Llama.cpp** or
<b>*11434*</b>* for **Ollama**) and adding another <b>*Remote Model Providers*</b> to **MstyStudio**, e.g. <b>*Ollama@JavaForwarder*</b> 
with the default Url <b>*http://127.0.0.1:8888/*</b>.
The communication between **MstyStudio** and the **LLM** exposed by **Ollama** will be logged in the command prompt **JavaForwarder** was started from.

### Fiddler

Alternatively you can add another <b>*Remote Model Providers*</b> to **MstyStudio**, e.g. <b>*Ollama@Fiddler*</b> with the default Url <b>*http://localhost:8888/*</b> (<b>*localhost*</b> must match the hostname or IP address used in the rules editor as shown below).
**Fiddler** will now log the communication between **MstyStudio** and the **LLM** exposed by e.g. **Ollama**, which can be verified best by switching the viewer to format the body to **Json** format.

In order for **[Fiddler](https://www.telerik.com/fiddler)** to reverse proxy the request invoke the rules editor from <b>*Rules*</b>→<b>*Customize Rules...*</b> and add as the first lines to the <b>*OnBeforeRequest*</b> handler:

**Note!** If the **LLM** provider is on a remote host change <b>*localhost*</b> to the remote hosts hostname accordingly. 

#### Ollama

```
// Forward traffic to Ollama server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:11434"; 
```

#### Llama.cpp

```
// Forward traffic to Llama.cpp server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:10000"; 
```

#### LM Studio

```
// Forward traffic to LMStudio llama.cpp server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:1234"; 
```
