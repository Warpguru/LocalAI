# LiteLLM

**LiteLLM** is a kind of swiss army knife when working with **LLM**s.
Of special interest is the feature to unite different **LLM**s under an umbrella that provides a single unifying **OpenAI API**
compatible interface.
That is, you can configure multiple <b>*Model*</b>s where each model is served from a different **LLM** provider.
Be it a cloud providers such as **Anthropic**, **OpenAI** or **xAI**, or local providers such as **Ollama** or **Llama.cpp**.

Not covered here, but additionally you can define timely, usage and performance limits for different models and persons
(such as members of your family).
Also activity logging is included.
And everything is persisted in a **Postgres** database.
All of that is administered centrally via a browser based configuration.

Typically **LiteLLM** is deployed in a **Docker** container, which however is not subject of this project.
This project shows how install and to run **LiteLLM** as a portable application.

## Prerequisites

### Postgres

**LiteLLM** persists configuration data in a **[Postgres](https://www.enterprisedb.com/)** database, by default in the schema <b>*litellm*</b>.
Setting up **Postgres** is beyond the scope of this document.
It is assumed that **Postgres** is unzipped from **[postgresql-18.0-2-windows-x64-binaries.zip](https://www.enterprisedb.com/download-postgresql-binaries)**
and run as a portable application with an initial setup of an empty database:

```SetupEnvPostgres.cmd
@SET CURRENTDIRECTORY=%~dp0
@SET POSTGRES=D:\Development\Postgres

@SET PATH=%POSTGRES%\bin;%POSTGRES%\pgAdmin 4\runtime;%POSTGRES%\lib\pgxs\src\test\isolation;%POSTGRES%\lib\pgxs\src\test\regress;%POSTGRES%\pgAdmin 4\python;%POSTGRES%\pgAdmin 4\python\Lib\site-packages\distlib;%POSTGRES%\pgAdmin 4\python\Lib\site-packages\pip\_vendor\distlib;%POSTGRES%\pgAdmin 4\python\Lib\site-packages\setuptools;%POSTGRES%\pgAdmin 4\python\Lib\site-packages\winpty;%PATH%

REM One-time setup
initdb -D D:\Development\PostgresData --username=postgres --auth=trust
REM Start database on port 5432
Start "PGCtl" cmd /c "pg_ctl start -D D:\Development\PostgresData"
START "PGAdmin4" cmd /c "pgadmin4"
```

**LiteLLM** requires that **Postgres** is up and running and servicing the url <b>*postgres://postgres:trust@127.0.0.1:5432/*</b>.

### Python3

To run <b>*ClaudeProxy.py*</b> a **[Python 3](https://www.python.org/downloads/windows/)** environment is required.
When available adapt and run <b>*SetupEnvPython3.cmd*</b>:

```SetupEnvPython3.cmd
@SET CURRENTDIRECTORY=%~dp0
@SET PYTHON=D:\Python\3.13.3
@SET PYCHARM=D:\Python\PyCharm

@REM Either have directories in python313._pth or in PYTHONPATH environment variable
@REM See: https://michlstechblog.info/blog/python-install-python-with-pip-on-windows-by-the-embeddable-zip-file/
@REN %PYTHON%\python313._pth python313._pth.original
@SET PATH=%PYTHON%;%PYTHON%\Scripts;%PYCHARM%\bin;%PATH%
@SET PYTHONPATH=%PYTHON%;%PYTHON%\DLLs;%PYTHON%\lib;%PYTHON%\lib\plat-win;%PYTHON%\lib\site-packages
```

### LiteLLM

Running **LiteLLM** as a portable application from the current directory requires a configured environment:

```SetupEnvLiteLLM.cmd
@SET CURRENTDIRECTORY=%~dp0
@SET USERPROFILE=%CURRENTDIRECTORY%Users\LiteLLM
@SET APPDATA=%CURRENTDIRECTORY%Users\LiteLLM\AppData\Roaming
@IF NOT EXIST %APPDATA% MKDIR %APPDATA% >NUL

@SET LITELLM_PROXY_URL=http://localhost:4000
@SET LITELLM_PROXY_API_KEY=sk-1234
@SET LITELLM_SALT_KEY=sk-1234
@SET DATABASE_URL=postgres://postgres:trust@127.0.0.1:5432/litellm
@SET PORT=4000
@SET STORE_MODEL_IN_DB=True
```

This setup is for educational purposes only, thus the credentials are visible in plain text.

## Installation

Open a command prompt and start be calling <b>*SetupEnvLiteLLM.cmd*</b> and <b>*SetupEnvPython3.cmd*</b>.
Then **LiteLLM** will be installed into a virtual **Python** environment in the subdirectory <b>*LiteLLM-Proxy*</b> with the following
commands:

```
uv init LiteLLM-Proxy
cd LiteLLM-Proxy
uv sync
.venv\scripts\activate
uv add prisma
uv add litellm\[proxy]

prisma init
prisma generate
python -m prisma generate --schema .\.venv\Lib\site-packages\litellm\proxy\schema.prisma
python -m prisma migrate deploy --schema .\.venv\Lib\site-packages\litellm\proxy\schema.prisma
```

**Note!** **LiteLLM** ships with limited **Python3** and **Node** runtime environments.
The steps outlined above ensure that the virtual **Python** environment (in directory <b>*.\vdev\*</b>) is not mixed up
with the environment included in the installation of **LiteLLM**.

As part of this repository a sample <b>*config.yaml*</b> file is included:

```config.yaml
model_list:
  - model_name: "Ollama Qwen2.5-coder:latest"             
    litellm_params:
      model: "ollama/qwen2.5-coder:latest"
      api_base: "http://localhost:11434"
  - model_name: "Ollama Llama3.2:3b"
    litellm_params:
      model: "ollama/llama3.2:3b"
      api_base: "http://localhost:11434"
  - model_name: "Fiddler Gpt-oss-20b"
    litellm_params:
      model: "openai/.\\Models\\gpt-oss-20b\\gpt-oss-20b-MXFP4.gguf"
      api_key: "dummy"
      api_base: "http://localhost:8888"
```

This is only for a quick starter as an alternative to a manual configuration from the **LiteLLM**s <b>*Admin panel*</b>. 
The sample configuration defines 2 **LLM**s provided by **Ollama** and 1 **LLM** provided by **Llama.cpp** - however all requests
are routed over **Fiddler** as the reverse proxy (see below for more details about proxies).

## Usage

Launch **LiteLLM** by:

```
cls & .venv\Scripts\litellm.exe --config ../config.yaml --detailed_debug
```

Initially it makes sense that **LiteLLM** is more verbose, finally the argument <b>*--detailed_debug*</b> can be left out.

After half a minute **LiteLLM** will write that it is up and running and showing its **[OpenAPI](http://localhost:4000/)** (Swagger)
documentation.
The **OpenAPI** also includes a link to the **[Admin Panel](http://localhost:4000/ui/)*</b> from where **LiteLLM** can be
managed (the configuration changes will be persisted in the referenced **Postgres** database).

### Models

By default only the **LLM**s specified in <b>*config.yaml*</b> are available and shown in the 
<b>*[Models + Endpoints](http://localhost:4000/ui/?page=models)*</b> page.
There not only the configuration of the specified models can be viewed, but also additional **LLM**s can be added
from the <b>*Add Model*</b> tab.

For example to add the <b>*mistral:latest*</b> **LLM** served by **Ollama** this configuration is required minimally:

| Label | Value  |
|---|---|
| Provider | Ollama |
| LiteLLM Model Name(s) | ollama/mistral:latest |
| API Base | http://localhost:11434/ |

Test the configuration by selecting <b>*Test Model*</b> and persist it with <b>*Add Model*</b>.

**Note!** The point of **LiteLLM** provides an abstraction that maps an external model name such as <b>*mistral:latest*</b> to a **LLM**
routed to a specific provider e.g. <b>*ollama/mistral:latest*</b> that understands the minor implementation differences
between **Ollama** and the standard **OpenAI API** specification.

**LiteLLM**'s [OpenAPI](http://localhost:4000/#/model%20management/model_list_v1_models_get) page allows to retrieve the
configures **LLM**s via a standart **OpenAI API** call:

```
curl -X 'GET' \
  'http://localhost:4000/v1/models?return_wildcard_routes=false&include_model_access_groups=false&only_model_access_groups=false&include_metadata=false' \
  -H 'accept: application/json' \
  -H 'x-litellm-api-key: sk-1234'
```

which might return e.g.:

```
{
  "data": [
    {
      "id": "Ollama Qwen2.5-coder:latest",
      "object": "model",
      "created": 1677610602,
      "owned_by": "openai"
    },
    {
      "id": "Ollama Llama3.2:3b",
      "object": "model",
      "created": 1677610602,
      "owned_by": "openai"
    },
    {
      "id": "Fiddler Gpt-oss-20b",
      "object": "model",
      "created": 1677610602,
      "owned_by": "openai"
    },
    {
      "id": "granite3.3:8b",
      "object": "model",
      "created": 1677610602,
      "owned_by": "openai"
    },
    {
      "id": "mistral:latest",
      "object": "model",
      "created": 1677610602,
      "owned_by": "openai"
    }
  ],
  "object": "list"
}
```
  