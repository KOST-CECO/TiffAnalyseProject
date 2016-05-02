// Package util contains utility functions
package util

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

// start logrotation returns logcounter
func Logrotate(db *sql.DB) (int, int32) {
	var logcounter int = 0
	var maxexecute int32 = 10000

	rows, err := db.Query("SELECT MAX(logcounter) FROM logrotate")
	if err != nil {
		log.Print(err)
	}
	defer rows.Close()

	for rows.Next() {
		rows.Scan(&logcounter)
	}

	if logcounter == 0 {
		// initialise logrotation
		_, err = db.Exec("INSERT INTO logrotate (logcounter) VALUES (1)")
		if err != nil {
			log.Fatal(err)
		}
		logcounter = 1
		maxexecute = 10000 //default

	} else {
		// read last logrotation entry
		rows, err := db.Query("SELECT MAX(logcounter), maxexecute FROM logrotate")
		if err != nil {
			log.Print(err)
		}
		defer rows.Close()

		for rows.Next() {
			rows.Scan(&logcounter, &maxexecute)
		}
	}

	return int(logcounter), int32(maxexecute)
}
