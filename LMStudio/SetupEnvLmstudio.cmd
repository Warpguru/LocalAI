@ECHO OFF
SET CURRENTDIR=%~dp0
SET OLLAMA_MODELS=%CURRENTDIR%Models

SET USERPROFILE=%CURRENTDIR%Users
SET LOCALAPPDATA=%CURRENTDIR%Users\AppData\Local
ECHO %USERPROFILE%\.lmstudio > %CURRENTDIR%Users\.lmstudio-home-pointer
ECHO Ensure that configuration .\Users\AppData\Roaming\LM Studio\settings.json points to the correct folder for local LLMs: "downloadsFolder": ".\\Users\\.lmstudio\\models"

