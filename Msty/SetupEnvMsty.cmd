@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\MstyStudio
SET APPDATA=%CURRENTDIR%Users\MstyStudio\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\MstyStudio\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO You may need to register local LLM providers (like e.g.: Ollama, Llama.cpp) as a remote LLM in Msty
ECHO For tools you might need: Node, Python3
ECHO.
@REM Start GUI in separate process
@Start "MstyStudio" cmd.exe /K ".\MstyStudio\MstyStudio"

