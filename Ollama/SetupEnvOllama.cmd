@ECHO OFF
SET CURRENTDIR=%~dp0
SET OLLAMA_MODELS=%CURRENTDIR%Models
SET OLLAMA_ORIGINS=*
SET OLLAMA_HOST=0.0.0.0
SET USERPROFILE=%CURRENTDIR%Users\Ollama
SET LOCALAPPDATA=%CURRENTDIR%Users\Ollama\data\AppData\Local
Echo Running with Models in: %OLLAMA_MODELS%
START "Ollama Service" ollama serve
timeout 5
ollama list

