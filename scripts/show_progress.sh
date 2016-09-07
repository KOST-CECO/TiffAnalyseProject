#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Database name is missing"
	echo "usage: $0 path/dbname.db"
	exit 1
fi

if ! [ -f $1 ]
then
	echo "Database $1 is missing"
	exit 1
fi

echo
echo "Anzahl Records in insgesamt:"
sqlite3 $1 -batch "SELECT COUNT(*) FROM namefile;"

echo.
echo "Anzahl Records verarbeitet:"
sqlite3 $1 -batch "SELECT COUNT(*) FROM namefile WHERE md5 NOT NULL;"

echo.
echo "Anzahl Records zu verarbeiten:"
sqlite3 $1 -batch "SELECT COUNT(*) FROM namefile WHERE md5 IS NULL;"

echo.
exit 0
