@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET PYTHON=D:\Python\3.11.9

REM A full Python environment is required (not just the embedded one) and PYTHONPATH must not be set (which would overwrite sys.path)!
REM Download: https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.zip
SET PATH=%PYTHON%;%PYTHON%\Scripts;%PYCHARM%\bin;%PATH%
REM SET PYTHONPATH=%PYTHON%;%PYTHON%\DLLs;%PYTHON%\lib;%PYTHON%\lib\plat-win;%PYTHON%\lib\site-packages
