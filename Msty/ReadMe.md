# MstyStudio

## Installation

To create a portable installation of **MstyStudio**:

1. Install **[MstyStudio](https://msty.ai/)** with the downloaded installer.
2. Copy the **Msty** program and configuration to this repository folder (replace <b>*User*</b> with your username):

   ```
   XCOPY X:\Users\<User>\AppData\Local\Programs\MstyStudio .\MstyStudio\ /s /e /v
   XCOPY X:\Users\<User>\AppData\Roaming\MstyStudio .\Users\MstyStudio\AppData\Roaming\MstyStudio\ /s /e /v
   ```
3. Deinstall **MstyStudio** again

## Usage

Initialize the portable **MstyStudio** environment and launch it with <b>*SetupEnvMsty.cmd*</b>:

```
@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\MstyStudio
IF NOT EXIST "%USERPROFILE%" MKDIR "%USERPROFILE%" >NUL

@REM Start GUI in separate process
ECHO.
Start "MstyStudio" .\MstyStudio\MstyStudio
ECHO You may need to register local LLM providers (like e.g.: Ollama, Llama.cpp) as a remote LLM in Msty
```

After installing **MstyStudio** your local **LLM** providers need to be added as <b>*Remote Model Providers*</b>.
To add e.g. **Ollama** as a local **LLM** provider add an entry e.g. <b>*Ollama@localhost*</b> with the default Url <b>*http://127.0.0.1:11434/*</b>.

## Proxy

Instead of specifying the **OpenAI API** compatible **LLM** provider e.g. **Ollama**, you can specify a reverse proxy that forward the requests while also logging them.

### JavaForwarder

For example, after starting **[JavaForwarder](https://github.com/Warpguru/JavaForwarder)** with:

```
java -DDUMP=True -DDUMP_WIDTH=32 -jar JavaForwarder.jar 127.0.0.1 11434 8888
```

and adding another <b>*Remote Model Providers*</b> to **MstyStudio**, e.g. <b>*Ollama@JavaForwarder*</b> with the default Url <b>*http://127.0.0.1:8888/*</b>.
The communication between **MstyStudio** and the **LLM** exposed by **Ollama** will be logged in the command prompt **JavaForwarder** was started from.

### Fiddler

Alternatively you can add the following rule to **[Fiddler](https://www.telerik.com/fiddler)** by invoking the editor for the <b>*OnBeforeRequest*</b> handler from <b>*Rules*</b> <b>*Customize Rules...*</b> to add as the first line:

```
// Forward traffic to Ollama server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:11434"; 
```

and adding another <b>*Remote Model Providers*</b> to **MstyStudio**, e.g. <b>*Ollama@Fiddler*</b> with the default Url <b>*http://127.0.0.1:8888/*</b>.
**Fiddler** will now log the communication between **MstyStudio** and the **LLM** exposed by **Ollama**, which can be verified best by switching the viewer to format the body to **Json** format.
