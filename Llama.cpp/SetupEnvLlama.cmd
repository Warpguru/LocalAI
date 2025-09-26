@ECHO OFF
SET CURRENTDIR=%~dp0
SET USERPROFILE=%CURRENTDIR%Llama.cpp\Users\Llama
SET LOCALAPPDATA=%CURRENTDIR%Llama.cpp\Users\Llama\data\AppData\Local
IF NOT EXIST %USERPROFILE% DO MKDIR %USERPROFILE% >NUL
IF NOT EXIST %USERPROFILE% DO MKDIR %LOCALAPPDATA% >NUL
IF NOT EXIST %USERPROFILE%Llama.cpp\models DO MKDIR %USERPROFILE%Llama.cpp\models >NUL

ECHO If either Llama.cpp or an LLM has not been downloaded yet, refer to ReadMe.md on how to proceed.
ECHO.
ECHO Then select a LLM and serve it with Llamap.cpp by execution the corresponding batch, e.g. Server.Mistral7b.cmd.
ECHO Available LLM servers:
@DIR /B Server.*.cmd
