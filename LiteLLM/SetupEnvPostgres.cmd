@SET CURRENTDIRECTORY=%~dp0
@Set POSTGRES=D:\Development\Postgres

@Set PATH=%POSTGRES%\bin;%POSTGRES%\pgAdmin 4\runtime;%POSTGRES%\lib\pgxs\src\test\isolation;%POSTGRES%\lib\pgxs\src\test\regress;%POSTGRES%\pgAdmin 4\python;%POSTGRES%\pgAdmin 4\python\Lib\site-packages\distlib;%POSTGRES%\pgAdmin 4\python\Lib\site-packages\pip\_vendor\distlib;%POSTGRES%\pgAdmin 4\python\Lib\site-packages\setuptools;%POSTGRES%\pgAdmin 4\python\Lib\site-packages\winpty;%PATH%

REM One-time setup
REM initdb -D D:\Development\PostgresData --username=postgres --auth=trust
REM Start database on port 5432
Start "PGCtl" cmd /c "pg_ctl start -D D:\Development\PostgresData"
START "PGAdmin4" cmd /c "pgadmin4"
