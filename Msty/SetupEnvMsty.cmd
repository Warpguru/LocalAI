@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET USERPROFILE=%CURRENTDIRECTORY%Users\MstyStudio
SET APPDATA=%CURRENTDIRECTORY%Users\MstyStudio\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIRECTORY%Users\MstyStudio\AppData\Local
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO You may need to register local LLM providers (like e.g.: Ollama, Llama.cpp) as a remote LLM in Msty
ECHO For tools you might need: Node, Python3
ECHO.
@REM Start GUI in separate process
@Start "MstyStudio" cmd.exe /K ".\MstyStudio\MstyStudio"

