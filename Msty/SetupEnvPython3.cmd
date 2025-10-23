@SET CURRENTDIRECTORY=%~dp0
@Set PYTHON=D:\Python\3.13.3
@set PYCHARM=D:\Python\PyCharm

@REM Either have directories in python313._pth or in PYTHONPATH environment variable
@REM See: https://michlstechblog.info/blog/python-install-python-with-pip-on-windows-by-the-embeddable-zip-file/
@Ren %PYTHON%\python313._pth python313._pth.original
@Set PATH=%PYTHON%;%PYTHON%\Scripts;%PYCHARM%\bin;%PATH%
@Set PYTHONPATH=%PYTHON%;%PYTHON%\DLLs;%PYTHON%\lib;%PYTHON%\lib\plat-win;%PYTHON%\lib\site-packages
