@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users
SET LOCALAPPDATA=%CURRENTDIR%Users\AppData\Local
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO %USERPROFILE%\.lmstudio > %CURRENTDIR%Users\.lmstudio-home-pointer
ECHO Ensure that configuration .\Users\AppData\Roaming\LM Studio\settings.json points to the correct folder for local LLMs: "downloadsFolder": ".\\Users\\.lmstudio\\models"
ECHO.
Start "LM Studio" cmd.exe /K ".\LMStudio\LM Studio"
