@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET USERPROFILE=%CURRENTDIRECTORY%Users\LMStudio
SET APPDATA=%CURRENTDIRECTORY%Users\LMStudio\AppData\Roaming
SET LOCALAPPDATA=%CURRENTDIRECTORY%Users\LMStudio\AppData\Local
SET PATH=%LOCALAPPDATA%\Programs\LM Studio;%PATH%
IF NOT EXIST "%APPDATA%" MKDIR "%APPDATA%" >NUL
IF NOT EXIST "%LOCALAPPDATA%" MKDIR "%LOCALAPPDATA%" >NUL
IF NOT EXIST "%USERPROFILE%\Documents" MKDIR "%USERPROFILE%\Documents" >NUL
IF NOT EXIST "%USERPROFILE%\Downloads" MKDIR "%USERPROFILE%\Downloads" >NUL

ECHO %USERPROFILE%\.lmstudio > %USERPROFILE%\.lmstudio-home-pointer
ECHO Ensure that configuration .\Users\LMStudio\AppData\Roaming\LM Studio\settings.json points to the correct folder for local LLMs: "downloadsFolder": ".\\Users\\LMStudio\\.lmstudio\\models"
ECHO.
ECHO Put downloaded models (e.g. from HuggingFace) into: .\Users\LMStudio\.lmstudio\models\lmstudio-community
ECHO.
ECHO Start LM Studio by: "LM Studio"
