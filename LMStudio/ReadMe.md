# LM Studio

## Installation

To create a portable installation of **[LM Studio](https://lmstudio.ai/)**:

1. Execute **SetupEnvLmstudio.cmd** to launch the portable environment.
2. Within that portable environment launch the downloaded **[LM Studio](https://lmstudio.ai/)** installer.
3. Optionally install the support of **OpenAI API** compatible harnesses by: `lms get gdmka/openai-compat-endpoint`

## Usage

Initialize the portable **LM Studio** environment and launch it with <b>*SetupEnvLmstudio.cmd*</b>:

```SetupEnvLmstudio.cmd
@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET USERPROFILE=%CURRENTDIRECTORY%Users\LMStudio
SET APPDATA=%CURRENTDIRECTORY%Users\LMStudio\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIRECTORY%Users\LMStudio\AppData\Local
SET PATH=%LOCALAPPDATA%\Programs\LM Studio;%PATH%
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL
IF NOT EXIST "%USERPROFILE%\Documents" MKDIR "%USERPROFILE%\Documents" >NUL
IF NOT EXIST "%USERPROFILE%\Downloads" MKDIR "%USERPROFILE%\Downloads" >NUL

ECHO %USERPROFILE%\.lmstudio > %USERPROFILE%\.lmstudio-home-pointer
ECHO Ensure that configuration .\Users\LMStudio\AppData\Roaming\LM Studio\settings.json points to the correct folder for local LLMs: "downloadsFolder": ".\\Users\\LMStudio\\.lmstudio\\models"
ECHO.
ECHO Put downloaded models (e.g. from HuggingFace) into: .\Users\LMStudio\.lmstudio\models\lmstudio-community
ECHO.
ECHO Start LM Studio by: "LM Studio"
```

After installing **LM Studio**:

* download at least one **LLM** e.g. from <b>*[LM Studio Models](https://lmstudio.ai/models)*</b> or from <b>*[HuggingFace](https://huggingface.co/models)*</b>.
* configure **LM Studio** to use a local model
* configure **LM Studio** to use an **OpenAI API** compatible model:
    * Your Generators: Select `gdmka/openai-compat-endpoint` which will open the right sidebar to configure your model   
    * Model: Insert the name of the LLM to use, e.g. `hf.co/JonathanColetti/Qwen3.8-27B-Uncensored-GGUF:Q4_K_M`
    * (Optional) Override Base URL: Insert the OpenAI API compatible harnish, e.g. `https://thomas-crawford-shoppers-authors.trycloudflare.com/v1`
