@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Users\Llama
SET APPDATA=%CURRENTDIR%Users\Llama\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\Llama\AppData\Local
IF NOT EXIST %APPDATA% MKDIR %APPDATA% >NUL
IF NOT EXIST %LOCALAPPDATA% MKDIR %LOCALAPPDATA% >NUL
IF NOT EXIST %USERPROFILE%Llama.cpp\models MKDIR %USERPROFILE%Llama.cpp\models >NUL

ECHO If either Llama.cpp or an LLM has not been downloaded yet, refer to ReadMe.md on how to proceed.
ECHO.
ECHO Then select a LLM and serve it with Llamap.cpp by execution the corresponding batch, e.g. Server.Mistral7b.cmd.
ECHO Available LLM servers:
@DIR /B Server.*.cmd
