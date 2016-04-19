// Package util contains utility functions
package util

import (
	"database/sql"
	"log"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

// check for valid sqlite3 database and read max id
func Checkdb(db *sql.DB) int32 {
	var cnt int32 = 0

	rows, err := db.Query("SELECT MAX(id) FROM keyfile")
	if err != nil {
		log.Print(err)
		log.Fatal(os.Args[2] + " is not valide TAP database")
	}
	defer rows.Close()

	for rows.Next() {
		rows.Scan(&cnt)
	}

	return int32(cnt)
}
