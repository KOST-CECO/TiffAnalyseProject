@ECHO OFF
SETLOCAL

REM settings -------------------------------------------------------------------

REM create DB ------------------------------------------------------------------
IF [%1]==[] (
	ECHO Database name is missing
	ECHO usage: %0 path/dbname.db
	EXIT /B
)
IF NOT EXIST %1 (
	ECHO Database '%1' is missing
	EXIT /B
)

IF NOT EXIST %~dp0/clean_TAP.sql (
	ECHO script 'create_TAP.sql' is missing
	EXIT /B
)

ECHO.
ECHO Attention: all result output is removed form database - stop with CTRL-C
PAUSE

SQLITE3 -batch -init %~dp0/clean_TAP.sql %1 ".exit"
SQLITE3 %1 -batch "update namefile set md5=NULL;" ".exit" 

ECHO.
ECHO SQLite DB '%1' cleaned
