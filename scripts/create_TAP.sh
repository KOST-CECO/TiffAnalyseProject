#!/bin/sh

# get script directory
cd `dirname $0`
SCRIPTDIR=`pwd`
cd - > /dev/null

# create DB ------------------------------------------------------------------

if [ $# -ne 1 ]
then
	echo "Database name is missing"
	echo "usage: $0 path/dbname.db"
	exit 1
fi

if [ -f $1 ]
then
	echo "Database $1 is allready created"
	exit 1
fi

if ! [ -f ${SCRIPTDIR}/create_TAP.sql ]
then
	echo "script ${SCRIPTDIR}/create_TAP.sql is missing"
	exit 1
fi

sqlite3 -batch -init ${SCRIPTDIR}/create_TAP.sql $1 ".exit"
echo
sqlite3 -batch -init ${SCRIPTDIR}/load_ToolList.sql $1 ".exit"
echo
echo "SQLite DB $1 is created"
exit 0
