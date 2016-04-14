@ECHO OFF
SETLOCAL

REM settings -------------------------------------------------------------------

REM create DB ------------------------------------------------------------------
IF [%1]==[] (
	ECHO Database name is missing
	ECHO usage: %0 path/dbname.db
	EXIT /B
)
IF EXIST %1 (
	ECHO Database '%1' is allready created
	EXIT /B
)

IF NOT EXIST ./create_TAP.sql (
	ECHO script 'create_TAP.sql' is missing
	EXIT /B
)

SQLITE3 -batch -init create_TAP.sql %1 ".exit"

ECHO SQLite DB '%1' created
