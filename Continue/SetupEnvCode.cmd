@ECHO OFF
SET CURRENTDIR=%~dp0
SET PATH=D:\VSCode;%PATH%
SET USERPROFILE=%CURRENTDIR%Users\Continue
SET APPDATA=%CURRENTDIR%Users\Continue\AppData\Roaming
IF NOT EXIST %APPDATA% MKDIR %APPDATA% >NUL

ECHO.
ECHO Start VisualStudio Code (supporting Continue.dev once extension is installed) by executing: VSCode
