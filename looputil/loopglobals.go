// Package loop contains utility functions
package looputil

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

// global variable definitions
var (
	KeyCounter int32   = 0 // holds the latest id used in namefile and keyfile
	TapDb      *sql.DB     // database handle
)

// check for valid sqlite3 database and open database
func CheckDb(dbname string) {
	TapDb, err := sql.Open("sqlite3", dbname)
	if err != nil {
		log.Fatal(dbname + " is not a sqlite3 database")
	}
	//defer TapDb.Close()

	rows, err := TapDb.Query("SELECT MAX(id) FROM keyfile")
	if err != nil {
		log.Print(err)
		log.Fatal(dbname + " is not valide TAP database")
	}
	defer rows.Close()
	for rows.Next() {
		rows.Scan(&KeyCounter)
		fmt.Println(KeyCounter)
	}

	tx, err := TapDb.Begin()
	if err != nil {
		log.Fatal(err)
	}
	tx.Commit()

}
