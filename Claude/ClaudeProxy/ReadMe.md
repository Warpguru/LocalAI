# Claude Code Proxy

ClaudeProxy.py is just a basic PoC and does not work with HTTP/2 streaming, which is the de-facto standard usecase of LLMs, LiteLLM may be a solution: 
https://medium.com/@luongnv89/setting-up-claude-code-locally-with-a-powerful-open-source-model-a-step-by-step-guide-for-mac-84cf9ab7302f

**Claude Code** does not support the standard of the **OpenAI API** interface, so <b>*ClaudeProxy.py*</b> is
provided here for a translation layer (**Note!** Streaming does not work yet).

---

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

---
