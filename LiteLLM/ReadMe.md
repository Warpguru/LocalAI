# LiteLLM

**LiteLLM** is a versatile Swiss Army knife for working with Large Language Models (**LLM**s).
Its standout feature is the ability to unify multiple LLMs under a single, **OpenAI API**-compatible interface.
This allows you to configure various models, each served by a different LLM provider, whether cloud-based (e.g., 
**Anthropic**, **OpenAI** or **xAI**) or local (e.g., **Ollama** or **Llama.cpp**).

Additionally, **LiteLLM** supports features not covered here, such as setting time, usage, and performance limits for different
models and users (e.g., family members).
It also includes activity logging and stores all data in a **Postgres** database.
These features are managed centrally through a browser-based configuration interface.
While **LiteLLM** is typically deployed in a **Docker** container, this project focuses on installing and running LiteLLM as a portable application.


## Prerequisites

### Postgres

**LiteLLM** stores configuration data in a **PostgreSQL** database, using the <b>*litellm*</b> schema by default.
Setting up **PostgreSQL** is outside the scope of this document.
This guide assumes that **PostgreSQL** has been extracted from  **[postgresql-18.0-2-windows-x64-binaries.zip](https://www.enterprisedb.com/download-postgresql-binaries)** and is running as a portable application with an empty database initialized:

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

### Watsonx.AI

To use **LiteLLM** with  **[Watsonx.AI](https://cloud.ibm.com/watsonx/overview)** as a large language model (**LLM**) provider,
you need to set up the following environment by running the <b>*SetupEnvWatsonx.cmd*</b> script:

```SetupEnvWatsonx.cmd
@ECHO Setting Watsonx url
@SET WATSONX_URL=https://eu-de.ml.cloud.ibm.com

@ECHO Setting Apikey
@SET WATSONX_APIKEY=f_aAD-O-49bGrGvuQdu36LNKKBCfreIt4tX6qxB0UEW5
@REM IAM Token derived from Apikey
@REM curl -X POST https://iam.cloud.ibm.com/identity/token -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey="f_aAD-O-49bGrGvuQdu36LNKKBCfreIt4tX6qxB0UEW5"

@ECHO Setting IAM Token
@SET WATSONX_TOKEN=eyJraWQiOiIyMDE5MDcyNCIsImFsZyI6IlJTMjU2In0.eyJpYW1faWQiOiJJQk1pZC0wNjAwMDBQRU5HIiwiaWQiOiJJQk1pZC0wNjAwMDBQRU5HIiwicmVhbG1pZCI6IklCTWlkIiwianRpIjoiZDA4Y2ZkMzgtNDhhMy00YjIxLTkyM2UtYTc0NzE3NzQwYjE4IiwiaWRlbnRpZmllciI6IjA2MDAwMFBFTkciLCJnaXZlbl9uYW1lIjoiUm9tYW4iLCJmYW1pbHlfbmFtZSI6IlN0YW5nbCIsIm5hbWUiOiJSb21hbiBTdGFuZ2wiLCJlbWFpbCI6InJvbWFuX3N0YW5nbEBhdC5pYm0uY29tIiwic3ViIjoiUm9tYW5fU3RhbmdsQGF0LmlibS5jb20iLCJhdXRobiI6eyJzdWIiOiJSb21hbl9TdGFuZ2xAYXQuaWJtLmNvbSIsImlhbV9pZCI6IklCTWlkLTA2MDAwMFBFTkciLCJuYW1lIjoiUm9tYW4gU3RhbmdsIiwiZ2l2ZW5fbmFtZSI6IlJvbWFuIiwiZmFtaWx5X25hbWUiOiJTdGFuZ2wiLCJlbWFpbCI6InJvbWFuX3N0YW5nbEBhdC5pYm0uY29tIn0sImFjY291bnQiOnsidmFsaWQiOnRydWUsImJzcyI6IjQ0ODZkMjk5ZTNlYjdkMDg4MGRhZGU0ODFkNmMxZTg3IiwiZnJvemVuIjp0cnVlfSwiaWF0IjoxNzYwOTU1NTM1LCJleHAiOjE3NjA5NTkxMzUsImlzcyI6Imh0dHBzOi8vaWFtLmNsb3VkLmlibS5jb20vaWRlbnRpdHkiLCJncmFudF90eXBlIjoidXJuOmlibTpwYXJhbXM6b2F1dGg6Z3JhbnQtdHlwZTphcGlrZXkiLCJzY29wZSI6ImlibSBvcGVuaWQiLCJjbGllbnRfaWQiOiJkZWZhdWx0IiwiYWNyIjoxLCJhbXIiOlsicHdkIl19.h6iv_UxAd3MVpsdxNo69lu9i3ldG0izRC-YtpC0hl4rbeXfpipRjwNpIZH2C6LgJX7eY7o22-o_pbHaXgcQvpWqcUbZDJ8Qvgzu2ph76LAMBDs1ixT2vb1jxfscWIOuts8zSHrv-eD1k3vv7O3x7uL9tQNXAKS4OOvtMIcktkIJMrokAt4zpuozmJQgwB-4cAh6adFCC6rum-sVpDiSUA5Q7GZlSodfGgjM78J4ux1hQIhGu29P2MtPQHv5lGlm-cVb1YNyC00WtAUtgnxoXMCWCTjnqcxNqq3OOW_u9lkSvi58YPpW2-YkOkeRma3sycpluTcCe816enyOKts_S-Q

@ECHO Setting Watsonx project id
@SET WATSONX_PROJECT_ID=1316f520-6022-4f08-9eae-b53d8707e44f

@ECHO Show supported models
@curl -X GET "https://eu-de.ml.cloud.ibm.com/ml/v1/foundation_model_specs?version=2024-10-10&filters=function_text_chat"
```

Configuring **[Watsonx.AI](https://cloud.ibm.com/watsonx/overview)** can be complex, like solving a puzzle with multiple steps.
Follow the instructions below carefully to avoid errors:

#### Region

This guide uses a **Watsonx.AI Runtime** instance in Germany: <b>*https://eu-de.ml.cloud.ibm.com*</b>.
**Important!** The **region** you select for the **Watsonx.AI Runtime** must match the region of your project to avoid error messages.

#### Apikey

To create an **API key**:

1. Log in to the **[Watsonx](https://cloud.ibm.com/watsonx/overview)** overview page and click <b>*Launch*</b> to access the **Watsonx.AI** platform.
2. Ensure <b>*Frankfurt*</b> is selected as the region in the top-right corner.
3. From the top-left hamburger menu, select **Access (IAM)** to open the **IBM Cloud Identity and Access Management** page.
4. In the updated hamburger menu, select **API Keys**, then click <b>*Create +*</b> to generate an **API key**.
**Note!** The **API key** is shown only once. If you lose it, delete it and create a new one.

```
f_aAD-O-49bGrGvuQdu36LNKKBCfreIt4tX6qxB0UEW5
```

#### IAM Token

To use **LiteLLM** with **Watsonx.AI**, you need an **IAM Token** derived from the API key.
This token acts as a **bearer token** for accessing **Watsonx.AI** services.
Use the following **Curl** command to generate it:

```curl
curl -X POST https://iam.cloud.ibm.com/identity/token -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey="f_aAD-O-49bGrGvuQdu36LNKKBCfreIt4tX6qxB0UEW5"
```

A successful response will include the **IAM Token**:

```
eyJraWQiOiIyMDE5MDcyNCIsImFsZyI6IlJTMjU2In0.eyJpYW1faWQiOiJJQk1pZC0wNjAwMDBQRU5HIiwiaWQiOiJJQk1pZC0wNjAwMDBQRU5HIiwicmVhbG1pZCI6IklCTWlkIiwianRpIjoiZDA4Y2ZkMzgtNDhhMy00YjIxLTkyM2UtYTc0NzE3NzQwYjE4IiwiaWRlbnRpZmllciI6IjA2MDAwMFBFTkciLCJnaXZlbl9uYW1lIjoiUm9tYW4iLCJmYW1pbHlfbmFtZSI6IlN0YW5nbCIsIm5hbWUiOiJSb21hbiBTdGFuZ2wiLCJlbWFpbCI6InJvbWFuX3N0YW5nbEBhdC5pYm0uY29tIiwic3ViIjoiUm9tYW5fU3RhbmdsQGF0LmlibS5jb20iLCJhdXRobiI6eyJzdWIiOiJSb21hbl9TdGFuZ2xAYXQuaWJtLmNvbSIsImlhbV9pZCI6IklCTWlkLTA2MDAwMFBFTkciLCJuYW1lIjoiUm9tYW4gU3RhbmdsIiwiZ2l2ZW5fbmFtZSI6IlJvbWFuIiwiZmFtaWx5X25hbWUiOiJTdGFuZ2wiLCJlbWFpbCI6InJvbWFuX3N0YW5nbEBhdC5pYm0uY29tIn0sImFjY291bnQiOnsidmFsaWQiOnRydWUsImJzcyI6IjQ0ODZkMjk5ZTNlYjdkMDg4MGRhZGU0ODFkNmMxZTg3IiwiZnJvemVuIjp0cnVlfSwiaWF0IjoxNzYwOTU1NTM1LCJleHAiOjE3NjA5NTkxMzUsImlzcyI6Imh0dHBzOi8vaWFtLmNsb3VkLmlibS5jb20vaWRlbnRpdHkiLCJncmFudF90eXBlIjoidXJuOmlibTpwYXJhbXM6b2F1dGg6Z3JhbnQtdHlwZTphcGlrZXkiLCJzY29wZSI6ImlibSBvcGVuaWQiLCJjbGllbnRfaWQiOiJkZWZhdWx0IiwiYWNyIjoxLCJhbXIiOlsicHdkIl19.h6iv_UxAd3MVpsdxNo69lu9i3ldG0izRC-YtpC0hl4rbeXfpipRjwNpIZH2C6LgJX7eY7o22-o_pbHaXgcQvpWqcUbZDJ8Qvgzu2ph76LAMBDs1ixT2vb1jxfscWIOuts8zSHrv-eD1k3vv7O3x7uL9tQNXAKS4OOvtMIcktkIJMrokAt4zpuozmJQgwB-4cAh6adFCC6rum-sVpDiSUA5Q7GZlSodfGgjM78J4ux1hQIhGu29P2MtPQHv5lGlm-cVb1YNyC00WtAUtgnxoXMCWCTjnqcxNqq3OOW_u9lkSvi58YPpW2-YkOkeRma3sycpluTcCe816enyOKts_S-Q
```

**Important!** The **IAM Token** expires after about one hour.
You may need to generate a new one when it expires.
Some tools, like **Jupyter notebooks**, automatically create a new token during initialization via an API call.

#### Project

From **[Watsonx](https://eu-de.dataplatform.cloud.ibm.com/wx/home?context=wx)** a project needs to be created in the region
of your choice.
From the hamburger menu at the top left corner select <b>*View all projects*</b> to view all your **Projects**.
Select <b>*New project +*</b> to create a new project and copy the **Project Id** from the <b>*Manage*</b> tab:


1. From the **[Watsonx](https://eu-de.dataplatform.cloud.ibm.com/wx/home?context=wx)** platform, create a project in your chosen **region**.
2. From the top-left hamburger menu, select <b>*View all projects*</b>.
3. Click <b>*New project +*</b> to create a project, then copy the **Project ID** from the <b>*Manage*</b> tab:

```
1316f520-6022-4f08-9eae-b53d8707e44f
```

#### Watsonx.AI

To avoid errors like <b>*"project_id 1316f520-6022-4f08-9eae-b53d8707e44f is not associated with a WML instance"*</b>,
you must assign a **Watsonx.AI Runtime** to your project.
Note that <b>*WML*</b> (<b>*Watson Machine Learning*</b>) is the former name for **Watsonx.AI Runtime**.

1. In the **Manage** tab of your project, select **Services & integrations**, then click <b>*Associate service +*</b>.
2. In the **Associate service** popup, ensure the <b>*Frankfurt*</b> region is selected.
3. Click <b>*New service +*</b>, select **Watsonx.AI Runtime**, and click <b>*Create*</b> to set up the instance.

#### Troubleshooting

Diagnosing issues with **LiteLLM** can be difficult.
Use the following **Curl** command to verify your configuration and ensure the **IAM Token** is still valid:

```curl
curl -L "https://eu-de.ml.cloud.ibm.com/ml/v1/text/generation?version=2023-05-02" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer eyJraWQiOiIyMDE5MDcyNCIsImFsZyI6IlJTMjU2In0.eyJpYW1faWQiOiJJQk1pZC0wNjAwMDBQRU5HIiwiaWQiOiJJQk1pZC0wNjAwMDBQRU5HIiwicmVhbG1pZCI6IklCTWlkIiwianRpIjoiZDA4Y2ZkMzgtNDhhMy00YjIxLTkyM2UtYTc0NzE3NzQwYjE4IiwiaWRlbnRpZmllciI6IjA2MDAwMFBFTkciLCJnaXZlbl9uYW1lIjoiUm9tYW4iLCJmYW1pbHlfbmFtZSI6IlN0YW5nbCIsIm5hbWUiOiJSb21hbiBTdGFuZ2wiLCJlbWFpbCI6InJvbWFuX3N0YW5nbEBhdC5pYm0uY29tIiwic3ViIjoiUm9tYW5fU3RhbmdsQGF0LmlibS5jb20iLCJhdXRobiI6eyJzdWIiOiJSb21hbl9TdGFuZ2xAYXQuaWJtLmNvbSIsImlhbV9pZCI6IklCTWlkLTA2MDAwMFBFTkciLCJuYW1lIjoiUm9tYW4gU3RhbmdsIiwiZ2l2ZW5fbmFtZSI6IlJvbWFuIiwiZmFtaWx5X25hbWUiOiJTdGFuZ2wiLCJlbWFpbCI6InJvbWFuX3N0YW5nbEBhdC5pYm0uY29tIn0sImFjY291bnQiOnsidmFsaWQiOnRydWUsImJzcyI6IjQ0ODZkMjk5ZTNlYjdkMDg4MGRhZGU0ODFkNmMxZTg3IiwiZnJvemVuIjp0cnVlfSwiaWF0IjoxNzYwOTU1NTM1LCJleHAiOjE3NjA5NTkxMzUsImlzcyI6Imh0dHBzOi8vaWFtLmNsb3VkLmlibS5jb20vaWRlbnRpdHkiLCJncmFudF90eXBlIjoidXJuOmlibTpwYXJhbXM6b2F1dGg6Z3JhbnQtdHlwZTphcGlrZXkiLCJzY29wZSI6ImlibSBvcGVuaWQiLCJjbGllbnRfaWQiOiJkZWZhdWx0IiwiYWNyIjoxLCJhbXIiOlsicHdkIl19.h6iv_UxAd3MVpsdxNo69lu9i3ldG0izRC-YtpC0hl4rbeXfpipRjwNpIZH2C6LgJX7eY7o22-o_pbHaXgcQvpWqcUbZDJ8Qvgzu2ph76LAMBDs1ixT2vb1jxfscWIOuts8zSHrv-eD1k3vv7O3x7uL9tQNXAKS4OOvtMIcktkIJMrokAt4zpuozmJQgwB-4cAh6adFCC6rum-sVpDiSUA5Q7GZlSodfGgjM78J4ux1hQIhGu29P2MtPQHv5lGlm-cVb1YNyC00WtAUtgnxoXMCWCTjnqcxNqq3OOW_u9lkSvi58YPpW2-YkOkeRma3sycpluTcCe816enyOKts_S-Q" -d "{ \"model_id\": \"meta-llama/llama-3-3-70b-instruct\", \"input\": \"What is the capital of Arkansas?:\", \"parameters\": { \"max_new_tokens\": 100, \"time_limit\": 1000 }, \"project_id\": \"1316f520-6022-4f08-9eae-b53d8707e44f\"}"
```

**Hint!** If you really execute above call unmodified to your configuration you'll waste your time ;-).

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
# See: https://docs.litellm.ai/docs/proxy/config_settings
litellm_settings:
    set_verbose: True
    json_logs: True

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
  - model_name: "Watsonx.AI"
    litellm_params:
      # all params accepted by litellm.completion()
      model: watsonx/meta-llama/llama-3-3-70b-instruct
      api_key: "os.environ/WATSONX_TOKEN" # does os.getenv("WATSONX_TOKEN")
```

This is only for a quick starter as an alternative to a manual configuration from the **LiteLLM**s <b>*Admin panel*</b>. 
The sample configuration defines 2 **LLM**s provided by **Ollama**, 1 **LLM** provided by **Llama.cpp** (however all requests
are routed over **Fiddler** as the reverse proxy (see below for more details about proxies)) and a model provided by
**Watsonx.AI**.

## Usage

Launch **LiteLLM** by:

```
cls & .venv\Scripts\litellm.exe --config ../config.yaml --debug --detailed_debug
```

Initially it makes sense that **LiteLLM** is more verbose (which might be useful to log the Rest-WebService calls to the console), 
finally the arguments <b>*--debug*</b> and <b>*--detailed_debug*</b> can be left out.

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
  