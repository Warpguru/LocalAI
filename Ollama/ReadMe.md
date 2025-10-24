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
SET CURRENTDIRECTORY=%~dp0
SET OLLAMA_ORIGINS=*
SET OLLAMA_HOST=0.0.0.0
SET OLLAMA_MODELS=%CURRENTDIRECTORY%Ollama\Models
SET USERPROFILE=%CURRENTDIRECTORY%\Users\Ollama
SET APPDATA=%CURRENTDIRECTORYECTORY%Users\Ollama\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIRECTORY%Users\Ollama\AppData\Local
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

## Modelfile

To use a model in **GGUF** format it has to be imported into **Ollama** by the means of a **Modelfile**.
The **Modelfile** includes configuration that **Ollama** requires in addition to the model weights in the **GGUF** file, e.g.
to use <b>*GPT-OSS-20B*</b> in **GGUF** format with **Ollama** the **Modelfile** <b>*Modelfile.gpt-oss-20b-GGUF*</b> is
provided as an example:

```Modelfile.gpt-oss-20b-GGUF
# Import GPTOSS-20B downloaded with LMStudio
FROM ..\LMStudio\Users\.lmstudio\models\lmstudio-community\gpt-oss-20b-GGUF\gpt-oss-20b-MXFP4.gguf

# Template: Here the chat_template from the GGUF file needs to be added, otherwise the LLM won't understand you.
#           HuggingFace provides this: https://huggingface.co/openai/gpt-oss-20b/tree/03fd454aae9be5799e9531726db7f6d0673675cb
#           However, the format at HuggingFace is Jinja2 template format (also called "Harmony") while Ollama expects Go template format
#
#           Ollama provides this: https://ollama.com/library/gpt-oss:20b/blobs/51468a0fd901
#           However, that means one really can't convert a chat_template from GGUF format files to Ollama modelfile format
TEMPLATE """
...
# Create Ollama LLM by (this makes a copy):
#   .\ollama\ollama create gpt-oss-20b-GGUF -f .\Modelfile.gpt-oss-20b-GGUF
# Show hash
#   .\ollama\ollama show gpt-oss-20b-GGUF --modelfile
# Replace copy with original GGUF symlink
#   rm .\Ollama\Models\blobs\sha256-65d06d31a3977d553cb3af137b5c26b5f1e9297a6aaa29ae7caa98788cde53ab
#   mklink .\Ollama\Models\blobs\sha256-65d06d31a3977d553cb3af137b5c26b5f1e9297a6aaa29ae7caa98788cde53ab ..\LMStudio\Users\.lmstudio\models\lmstudio-community\gpt-oss-20b-GGUF\gpt-oss-20b-MXFP4.gguf 
```

When importing the model weights from a **GGUF** file using a **Modelfile** to **Ollama**, **Ollama** will also make an exact copy of
the model weights in the <b>*.\Ollama\Models\blobs*</b> directory.
As this is a waste of disk space it can be deleted and **mklink** can be used to replace it with a link to the original file
as documented in the example **Modelfile** above. 

## GUI

### Ollama

**Ollama** also includes a simple **GUI** which can be used for basic interaction with **LLM**s:

```
.\Ollama\ollama app.exe
```

### Others

Of course other **GUI**s can be used also like e.g. **[Msty](https://msty.ai/)**.
