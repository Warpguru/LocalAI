@ECHO OFF
SET CURRENTDIR=%~dp0
SET PATH=X:\VSCode;%PATH%
SET USERPROFILE=%CURRENTDIR%Users\Continue
SET APPDATA=%CURRENTDIR%Users\Continue\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIR%Users\Continue\AppData\Local
IF NOT EXIST %APPDATA% MKDIR %APPDATA% >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO.
ECHO Start VisualStudio Code (supporting Continue.dev once extension is installed) by executing: VSCode
