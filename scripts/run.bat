@ECHO OFF
SETLOCAL

CLS
DEL  /Q log\*

DEL tap.db
CALL create_TAP_win.bat tap.db
ECHO.

iniloop.exe "testSET" tap.db

ECHO.

CALL runloop.exe tap.db

ECHO.

REM CALL sqlite3.exe tap.db -batch "select * from sysindex;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select * from keyfile;" ".exit"
REM CALL sqlite3.exe tap.db -batch ".header on" ".mode column" "select * from namefile;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select * from logrotate;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select logout from logindex;" ".exit"
REM CALL sqlite3.exe tap.db -batch "select sysout from sysindex where toolname like 'exif';" ".exit"

EXIT /B
