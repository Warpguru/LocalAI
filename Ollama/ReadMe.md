# Ollama

## Warning

The industry standard file format for **LLM**s is **[GGUF](https://github.com/ggml-org/ggml/blob/master/docs/gguf.md)**.
**Ollama** uses a different file format, which can be imported from a **GGUF** file, but currently no out-of-the-box tools exist to do that painlessly,
thus **Ollama** may not be the best choice for more advanced **AI** use cases.

## Installation

To create a portable installation of **Ollama**:

1. Install **[Ollama](https://ollama.com/download/OllamaSetup.exe)** with the downloaded installer.
**Ollama** automatically downloads updates which also can be run as an installer.
2. Copy the **Ollama** program and configuration to this repository folder (replace <b>*User*</b> with your username):

   ```
   XCOPY X:\Users\<User>\AppData\Local\Programs\Ollama .\Ollama\ /s /e /v
   XCOPY X:\Users\<User>\.ollama\id* .\Users\Ollama\.ollama /s /e /v 
   ```
   
3. Deinstall **Ollama** again

To transfer a downloaded model from one Ollama installation to another:

1. Locate <b>*.\Ollama\Models\manifests\registry.ollama.ai\library\<LLM>\*</b> where **<LLM>** is the name of the model and copy this entire directory
2. In that directory, open the <b>*<Version>*</b> file and format the **JSON** content, which will contain **sh256** digest entries
3. Locate <b>*.\Ollama\Models\blobs\*</b>, which contains files named <b>*sha256-<hex checksum>*</b>. Here, <b>*<hex checksum>*</b> corresponds to the sh256 digest entries. Copy these 5 files from this location.

## Usage

Initialize the portable **Ollama** environment and launch it with <b>*SetupEnvOllama.cmd*</b>:

```SetupEnvOllama.cmd
@ECHO OFF
SET CURRENTDIR=%~dp0
SET OLLAMA_ORIGINS=*
SET OLLAMA_HOST=0.0.0.0
SET OLLAMA_MODELS=%CURRENTDIR%Ollama\Models
SET USERPROFILE=%CURRENTDIR%\Users\Ollama
SET APPDATA=%CURRENTDIRECTORY%Users\Ollama\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\Ollama\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL
IF NOT EXIST "%OLLAMA_MODELS%" MKDIR "%OLLAMA_MODELS%" >NUL

ECHO If either Ollama or an LLM has not been downloaded yet, refer to ReadMe.md on how to proceed.
ECHO.
START "Ollama Service" .\Ollama\ollama serve
timeout 5
ECHO Running with Models in: %OLLAMA_MODELS%
.\Ollama\ollama list
```

After installing **Ollama** no **LLM** gets installed automatically so install it manually by:

```
.\Ollama\ollama pull <model>
```

where <b>*model*</b> is a **LLM** supported by **Ollama**, e.g. <b>*gpt-oss:latest*</b>.
What **LLM**s are available can be found on **[Ollama](https://ollama.com/library)**.

### Curl

Of course **Curl** can also be used to interact with a **LLM** installed to **Ollama** by performing **OpenAI API** calls:

```
curl -XPOST -H "Content-Type: application/json" http://<server>:11434/v1/chat/completions -d "{""model"": ""granite3.1-dense:8b"", ""messages"": [{""role"": ""user"", ""content"": ""How are you today?""}]}"
curl -XPOST -H "Content-Type: application/json" http://<server>:11434/v1/chat/completions -d "{""model"": ""mistral:latest"", ""messages"": [{""role"": ""user"", ""content"": ""How are you today?""}]}"
```

For the example above replace <b>*<server>*</b> with e.g. <b>*localhost*</b> if **Ollama** is running locally.
Assuming that the <b>*Granite3.1-dense:8b*</b> and <b>*Mistral:latest*</b> **LLM**s are installed you can use those calls
as a chat conversation start topic.

## GUI

### Ollama

**Ollama** also includes a simple **GUI** which can be used for basic interaction with **LLM**s:

```
.\Ollama\ollama app.exe
```

### Others

Of course other **GUI**s can be used also like e.g. **[Msty](https://msty.ai/)**.
