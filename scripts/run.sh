#!/bin/sh

rm tap.db
rm log/*

./create_TAP.sh tap.db
echo
./iniloop testSET/ tap.db 
echo
./runloop tap.db
echo
sqlite3 -batch -init show_TAP.sql tap.db ".exit"

