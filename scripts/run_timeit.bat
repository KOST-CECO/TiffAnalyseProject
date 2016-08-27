@ECHO OFF
SETLOCAL

CLS
DEL  /Q log\*

DEL tap.db
CALL create_TAP.bat tap.db
ECHO.
"C:\Tools\Windows Resource Kits\Tools\timeit.exe" -f timeit.dat -k iniloop iniloop.exe "C:\Tools" tap.db 2> NUL

DEL tap.db
CALL create_TAP.bat tap.db
ECHO.
"C:\Tools\Windows Resource Kits\Tools\timeit.exe" -f timeit.dat -k iniloop_uc iniloop_uc.exe "C:\Tools" tap.db 2> NUL

DEL tap.db
CALL create_TAP.bat tap.db
ECHO.
"C:\Tools\Windows Resource Kits\Tools\timeit.exe" -f timeit.dat -k iniloop_ts iniloop_ts.exe "C:\Tools" tap.db 2> NUL

ECHO.
"C:\Tools\Windows Resource Kits\Tools\timeit.exe" -f timeit.dat 

EXIT /B

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
