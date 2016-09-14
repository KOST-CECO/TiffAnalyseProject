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

sqlite3 $1 -batch "DELETE FROM analysetool;"

sqlite3 $1 -batch "INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'tiffhist',
	'./tiffhist',
	'%file% %log%',
	'log/tiffhist_tmp',
	'log/tiffhist_out',
	''
);"

echo "Registert Tools:"
echo "----------------"
sqlite3 $1 -header -column -batch "SELECT * FROM analysetool;"

exit 0
