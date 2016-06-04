@ECHO OFF
SETLOCAL

CLS
DEL  /Q ..\log\*

DEL tap.db
CALL ..\createDB\create_TAP.bat tap.db

CALL ..\iniloop\iniloop.exe ..\testSET tap.db
REM CALL ..\iniloop\iniloop.exe Q:\KOST\_testdaten\TIFF tap.db
REM CALL ..\iniloop\iniloop.exe Q:\KOST\_testdaten tap.db

ECHO.

CALL runloop.exe tap.db

ECHO.

REM CALL sqlite3.exe tap.db -batch "select * from sysindex;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select * from keyfile;" ".exit"
CALL sqlite3.exe tap.db -batch ".header on" ".mode column" "select * from namefile;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select * from logrotate;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select logout from logindex;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select sysout from sysindex where toolname like 'exif';" ".exit"


EXIT /B
