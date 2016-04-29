// Package util contains utility functions
package util

import (
	"database/sql"
	"log"
	"os"
	"path/filepath"
	"strconv"

	_ "github.com/mattn/go-sqlite3"
)

// global type and variable definitions
type ToolList struct {
	Toolname string
	Prgfile  string
	Prgparam string
	Tmplog   string
	Logfile  string
	Log      *os.File
	Sysfile  string
	Sys      *os.File
}

var Tools map[string]ToolList

// read and register list of analyse tools
func Regtools(db *sql.DB) int {
	var cnt int = 0
	var tl ToolList
	Tools = make(map[string]ToolList)

	// start logrotation
	logcnt := Logrotate(db)

	rows, err := db.Query("SELECT Toolname, Prgfile, Prgparam, Tmplog, Logfile, Sysfile FROM analysetool")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		cnt++
		rows.Scan(&tl.Toolname, &tl.Prgfile, &tl.Prgparam, &tl.Tmplog, &tl.Logfile, &tl.Sysfile)

		// check for valid program file
		tl.Prgfile, err = filepath.Abs(tl.Prgfile)
		if err != nil {
			log.Fatal(err)
		}
		_, err := os.Stat(tl.Prgfile)
		if err != nil {
			log.Fatal(tl.Toolname + " Prgfile not found: " + tl.Prgfile)
		}

		// check temporary LOG file
		if tl.Tmplog != "" {
			tl.Tmplog, err = filepath.Abs(tl.Tmplog)
			if err != nil {
				log.Fatal(err)
			}
			lf, err := os.OpenFile(tl.Tmplog, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0600)
			if err != nil {
				log.Fatal(err)
			}
			lf.Close()
		}

		// open LOG file
		tl.Log = nil
		if tl.Logfile != "" {
			tl.Logfile, err = filepath.Abs(tl.Logfile + "." + strconv.Itoa(logcnt) + ".log")
			if err != nil {
				log.Fatal(err)
			}
			tl.Log, err = os.OpenFile(tl.Logfile, os.O_APPEND|os.O_CREATE, 0600)
			if err != nil {
				log.Fatal(err)
			}
			// defer tl.Log.Close()
		}

		// open SYS file
		tl.Sys = nil
		if tl.Sysfile != "" {
			tl.Sysfile, err = filepath.Abs(tl.Sysfile + "." + strconv.Itoa(logcnt) + ".log")
			if err != nil {
				log.Fatal(err)
			}
			tl.Sys, err = os.OpenFile(tl.Sysfile, os.O_APPEND|os.O_CREATE, 0600)
			if err != nil {
				log.Fatal(err)
			}
			// defer tl.Sys.Close()
		}

		Tools[tl.Toolname] = tl
	}

	return int(cnt)
}
