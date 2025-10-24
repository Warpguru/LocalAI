@ECHO OFF
SET CURRENTDIRECTORY=%~dp0
SET PYTHON=%CD:~0,2%\Python\3.13.3
SET PYCHARM=%CD:~0,2%\PyCharm

REM Either have directories in python313._pth or in PYTHONPATH environment variable
REM See: https://michlstechblog.info/blog/python-install-python-with-pip-on-windows-by-the-embeddable-zip-file/
REN %PYTHON%\python313._pth python313._pth.original
SET PATH=%PYTHON%;%PYTHON%\Scripts;%PYCHARM%\bin;%PATH%
SET PYTHONPATH=%PYTHON%;%PYTHON%\DLLs;%PYTHON%\lib;%PYTHON%\lib\plat-win;%PYTHON%\lib\site-packages
