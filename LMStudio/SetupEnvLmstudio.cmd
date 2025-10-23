@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\LMStudio
SET APPDATA=%CURRENTDIR%Users\LMStudio\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\LMStudio\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO %USERPROFILE%\.lmstudio > %USERPROFILE%\.lmstudio-home-pointer
ECHO Ensure that configuration .\Users\LMStudio\AppData\Roaming\LM Studio\settings.json points to the correct folder for local LLMs: "downloadsFolder": ".\\Users\\LMStudio\\.lmstudio\\models"
ECHO.
ECHO Put downloaded models (e.g. from HuggingFace) into: .\Users\LMStudio\.lmstudio\models\lmstudio-community
ECHO.
Start "LM Studio" cmd.exe /K ".\LMStudio\LM Studio"
