@ECHO OFF
SET CURRENTDIR=%~dp0
SET OLLAMA_ORIGINS=*
SET OLLAMA_HOST=0.0.0.0
SET OLLAMA_MODELS=%CURRENTDIR%Ollama\Models
SET USERPROFILE=%CURRENTDIR%Ollama\Users\Ollama
IF NOT EXIST %USERPROFILE% DO MKDIR %USERPROFILE% >NUL
IF NOT EXIST %OLLAMA_MODELS% DO MKDIR %OLLAMA_MODELS% >NUL

ECHO If either Ollama or an LLM has not been downloaded yet, refer to ReadMe.md on how to proceed.
ECHO.
START "Ollama Service" .\Ollama\ollama serve
timeout 5
ECHO Running with Models in: %OLLAMA_MODELS%
.\Ollama\ollama list
