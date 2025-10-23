# Llama.cpp

## Installation

### Llama.cpp

To install **[Llama.cpp](https://github.com/ggml-org/llama.cpp/releases)** download the version that supports **CUDA** 
(which automatically include <b>*CPU*</b> support), e.g. **[llama-b6823-bin-win-cuda-12.4-x64.zip](https://github.com/ggml-org/llama.cpp/releases/download/b6823/llama-b6823-bin-win-cuda-12.4-x64.zip)**.
To use hardware acceleration with **NVidia** **GPU**s also download the **[CUDA](https://developer.nvidia.com/cuda-toolkit)** runtime
**[cudart-llama-bin-win-cuda-12.4-x64.zip](https://github.com/ggml-org/llama.cpp/releases/download/b6823/cudart-llama-bin-win-cuda-12.4-x64.zip)**
Unpack the archives into the subdirectory <b>*./Llamap.cpp/*</b>.

**Llama.cpp** contains multiple programs, the most important for running an **LLM** are:

- <b>*llama-server*</b>: This will start an **OpenAI API** compatible server that can be used by any client supporting that API.
- <b>*llama-cli*</b>: This load the specified **LLM** and directly execute a chat, e.g. <b>*./Llamap.cpp/llama-cli --model "./Llamap.cpp/models/Mistral 7B Instruct v0.3/Mistral-7B-Instruct-v0.3-Q4_K_M.gguf" --ctx-size 32768 --n-gpu-layers 40 --jinja -p "Why is the sky blue?"*</b>. 

Use the batch script <b>*SetupEnvLlama.cmd*</b> to allow **Llama.cpp** running in a portable way (and create the required directories):

```SetupEnvLlama.cmd
@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\Llama
SET APPDATA=%CURRENTDIR%Users\Llama\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\Llama\AppData\Local
IF NOT EXIST %APPDATA% MKDIR %APPDATA% >NUL
IF NOT EXIST %LOCALAPPDATA% MKDIR %LOCALAPPDATA% >NUL
IF NOT EXIST %CURRENTDIR%\Models MKDIR %CURRENTDIR%\Models >NUL

ECHO If either Llama.cpp or an LLM has not been downloaded yet, refer to ReadMe.md on how to proceed.
ECHO.
ECHO Then select a LLM and serve it with Llamap.cpp by execution the corresponding batch, e.g. Server.Mistral7b.cmd.
ECHO Available LLM servers:
@DIR /B Server.*.cmd
```

You also need to download at least one **LLM** in <b>*GGUF*</b> format.

### LLM

From **HuggingFace** download a model in <b>*GGUF*</b> format into the <b>*./Llamap.cpp/Models*</b> subdirectory, e.g. **Mistral 7B Instruct v0.3** in <b>*4 Bit quantization*</b>, that is **[Q4_K_M](https://huggingface.co/lmstudio-community/Mistral-7B-Instruct-v0.3-GGUF/resolve/main/Mistral-7B-Instruct-v0.3-Q4_K_M.gguf?download=true)**.

- Download this model into the directory <b>*./Llama.cpp&models/Mistral 7B Instruct v0.3*</b>
- Create the batch script <b>*Server.Mistral7b.cmd*</b> to run it with **Llama.cpp**:

```
@ECHO OFF
START "Llama.cpp Mistral 7B" ./Llama.cpp/llama-server --model "./Llama.cpp/models/Mistral 7B Instruct v0.3/Mistral-7B-Instruct-v0.3-Q4_K_M.gguf" --port 10000 --ctx-size 32768 --n-gpu-layers 40 --jinja
ECHO Please be patient for Llama.cpp to initialize ...
timeout 30
START http://127.0.0.1:10000
```

You might want to fine-tune the parameters in both the batch script and in the **[GUI](http://127.0.0.1:10000)** that will open once **Llama.cpp** is initialized

<b>*Hint!*</b> The flag <b>*--jinja*</b> seems to be required for build-in template support or simple role-based formatting when using Jinja template for chat completions (which AFAIK recent **LLM**s for models like CodeLlama, Qwen, or DeepSeek that use advanced Jinja features (e.g., loops, conditionals, or filters) require for tool calling).
A message like <b>*tools param requires --jinja flag*</b> in the **LLM**s response clearly hints that running the model requires this flag.
It's also required for full **OpenAI API** compatibility in <b>*llama-server*</b>.

## Usage

Execute one of the server batch script, e.g. <b>*Server.Mistral7b.cmd*</b>, a basic browser based user interface will be opened.
Alternatively you can use the **OpenAI API** compatible interface at <b>*http://127.0.0.1:10000/v1*</b>. 

## Proxy

You can run a reverse proxy between the **Llama.cpp** server and the client that forward the requests while also logging them.

#### JavaForwarder

For example, after starting **[JavaForwarder](https://github.com/Warpguru/JavaForwarder)** with:

```
java -DDUMP=True -DDUMP_WIDTH=32 -jar JavaForwarder.jar 127.0.0.1 10000 8888
```

and the calling **Llama.cpp**'s **OpenAI API** compatible interface at:

```
http://127.0.0.1:8888/v1/
```

the communication between the client (e.g. **Msty**, **Llxprt**) and the **LLM** exposed by **Llama.cpp** will be logged in the command prompt **JavaForwarder** was started from.

#### Fiddler

Alternatively you can add the following rule to **[Fiddler](https://www.telerik.com/fiddler)** by invoking the editor for the <b>*OnBeforeRequest*</b> handler from <b>*Rules*</b> <b>*Customize Rules...*</b> to add as the first line:

```
// Forward traffic to LMStudio llama.cpp server
if (oSession.host.toLowerCase() == "localhost:8888") oSession.host = "localhost:10000"; 
```

and the calling **Llama.cpp**'s **OpenAI API** compatible interface at:

```
http://127.0.0.1:8888/v1/
```

**Fiddler** will now log the communication between the client (e.g. **Msty**, **Llxprt**) and the **LLM** exposed by **Llama.cpp**, which can be verified best by switching the viewer to format the body to **Json** format.
