# LM Studio

## Installation

To create a portable installation of **LM Studio**:

1. Install **[LM Studio](https://lmstudio.ai/)** with the downloaded installer.
2. Copy the **LM Studio** program and configuration to this repository folder (replace <b>*User*</b> with your username):

   ```
   XCOPY "X:\Users\<User>\AppData\Local\Programs\LM Studio" .\LMStudio\ /s /e /v
   XCOPY "X:\Users\<User>\AppData\Roaming\LM Studio" ".\Users\AppData\Roaming\LM Studio\" /s /e /v
   XCOPY "X:\Users\<User>\.lmstudio" ".\Users\.lmstudio\" /s /e /v
   ```
3. Deinstall **LM Studio** again

## Usage

Initialize the portable **LM Studio** environment and launch it with <b>*SetupEnvLmstudio.cmd*</b>:

```
@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users
SET LOCALAPPDATA=%CURRENTDIR%Users\AppData\Local
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO %USERPROFILE%\.lmstudio > %CURRENTDIR%Users\.lmstudio-home-pointer
ECHO Ensure that configuration .\Users\AppData\Roaming\LM Studio\settings.json points to the correct folder for local LLMs: "downloadsFolder": ".\\Users\\.lmstudio\\models"
ECHO.
Start "LM Studio" cmd.exe /K ".\LMStudio\LM Studio"
```

After installing **LM Studio** at least one **LLM** needs to be downloaded e.g. from <b>*[LM Studio Models](https://lmstudio.ai/models)*</b>.
