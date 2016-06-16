#!/bin/sh

# get script directory
cd `dirname $0`
SCRIPTDIR=`pwd`
cd - > /dev/null

# clean DB ------------------------------------------------------------------

if [ $# -ne 1 ]
then
	echo "Database name is missing"
	echo "usage: $0 path/dbname.db"
	exit -1
fi

if ! [ -f $1 ]
then
	echo "Database $1 is missing"
	exit -1
fi

if ! [ -f ${SCRIPTDIR}/clean_TAP.sql ]
then
	echo "script ${SCRIPTDIR}/clean_TAP.sql is missing"
	exit -1
fi

echo
echo "Attention: all result output is removed form database - stop with CTRL-C"
read -n1 -r -p "Press any key to continue..." key

sqlite3 -batch -init ${SCRIPTDIR}/clean_TAP.sql $1 ".exit"
sqlite3 $1 -batch "update namefile set md5=NULL;" ".exit" 

echo
echo "SQLite DB $1 cleaned"
