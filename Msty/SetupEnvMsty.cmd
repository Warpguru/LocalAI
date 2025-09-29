@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\MstyStudio
IF NOT EXIST "%USERPROFILE%" MKDIR "%USERPROFILE%" >NUL

@REM Start GUI in separate process
ECHO.
Start "MstyStudio" .\MstyStudio\MstyStudio
ECHO You may need to register local LLM providers (like e.g.: Ollama, Llama.cpp) as a remote LLM in Msty
