// Package util contains utility functions
package util

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

// start logrotation returns logcounter and maxexecute for next logfile
func Logrotate(db *sql.DB) (lc int, mx int32) {

	rows, err := db.Query("SELECT MAX(logcounter), maxexecute FROM logrotate")
	if err != nil {
		log.Print(err)
	}
	defer rows.Close()

	for rows.Next() {
		rows.Scan(&lc, &mx)
	}

	if lc == 0 {
		mx = 10000 // default
	}

	// initialise logrotation
	stmt, err := db.Prepare("INSERT INTO logrotate (logcounter, maxexecute) VALUES (?, ?)")
	if err != nil {
		log.Fatal(err)
	}
	lc += 1
	_, err = stmt.Exec(lc, mx)
	if err != nil {
		log.Fatal(err)
	}

	return
}
