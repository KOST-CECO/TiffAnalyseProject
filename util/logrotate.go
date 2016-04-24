// Package util contains utility functions
package util

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

// start logrotation returns logcounter
func Logrotate(db *sql.DB) int {
	var cnt int = 0

	rows, err := db.Query("SELECT MAX(logcounter) FROM logrotate")
	if err != nil {
		log.Print(err)
	}
	defer rows.Close()

	for rows.Next() {
		rows.Scan(&cnt)
	}

	if cnt == 0 {
		// initialise logrotation
		_, err = db.Exec("INSERT INTO logrotate (logcounter) VALUES (1)")
		if err != nil {
			log.Fatal(err)
		}
		cnt = 1
	}

	return int(cnt)
}
