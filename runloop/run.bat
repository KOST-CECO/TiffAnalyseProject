@ECHO OFF
SETLOCAL

CLS
COPY /Y "tap - Kopie.db" tap.db

@ECHO ON
CALL runloop.exe tap.db

CALL sqlite3.exe tap.db -batch "select * from sysindex;" ".exit"

EXIT /B