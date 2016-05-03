@ECHO OFF
SETLOCAL

CLS
DEL  /Q ..\log\*

DEL tap.db
CALL ..\createDB\create_TAP.bat tap.db
CALL ..\iniloop\iniloop.exe ..\testSET tap.db

ECHO.

@ECHO ON
CALL runloop.exe tap.db

REM CALL sqlite3.exe tap.db -batch "select * from sysindex;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select * from keyfile;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select * from logrotate;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select logout from logindex;" ".exit"

EXIT /B
