@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET PATH=%CD:~0,2%\VSCode;%PATH%
SET USERPROFILE=%CURRENTDIRECTORY%Users\Continue
SET APPDATA=%CURRENTDIRECTORY%Users\Continue\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIRECTORY%Users\Continue\AppData\Local
IF NOT EXIST %APPDATA% MKDIR %APPDATA% >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL

ECHO.
ECHO Start VisualStudio Code (supporting Continue.dev once extension is installed) by executing: VSCode
