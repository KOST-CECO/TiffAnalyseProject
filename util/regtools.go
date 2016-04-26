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
	toolname string
	prgfile  string
	prgparam string
	tmplog   string
	logfile  string
	log      *os.File
	sysfile  string
	sys      *os.File
}

var Tools map[string]ToolList

// read and register list of analyse tools
func Regtools(db *sql.DB) int {
	var cnt int = 0
	var tl ToolList
	Tools = make(map[string]ToolList)

	// start logrotation
	logcnt := Logrotate(db)

	rows, err := db.Query("SELECT toolname, prgfile, prgparam, tmplog, logfile, sysfile FROM analysetool")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		cnt++
		rows.Scan(&tl.toolname, &tl.prgfile, &tl.prgparam, &tl.tmplog, &tl.logfile, &tl.sysfile)

		// check for valid program file
		tl.prgfile, err = filepath.Abs(tl.prgfile)
		if err != nil {
			log.Fatal(err)
		}
		_, err := os.Stat(tl.prgfile)
		if err != nil {
			log.Fatal(tl.toolname + " prgfile not found: " + tl.prgfile)
		}

		// check temporary LOG file
		if tl.tmplog != "" {
			tl.tmplog, err = filepath.Abs(tl.tmplog)
			if err != nil {
				log.Fatal(err)
			}
			lf, err := os.OpenFile(tl.tmplog, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0600)
			if err != nil {
				log.Fatal(err)
			}
			lf.Close()
		}

		// open LOG file
		tl.log = nil
		if tl.logfile != "" {
			tl.logfile, err = filepath.Abs(tl.logfile + "." + strconv.Itoa(logcnt) + ".log")
			if err != nil {
				log.Fatal(err)
			}
			tl.log, err = os.OpenFile(tl.logfile, os.O_APPEND|os.O_CREATE, 0600)
			if err != nil {
				log.Fatal(err)
			}
			defer tl.log.Close()
		}

		// open SYS file
		tl.sys = nil
		if tl.sysfile != "" {
			tl.sysfile, err = filepath.Abs(tl.sysfile + "." + strconv.Itoa(logcnt) + ".log")
			if err != nil {
				log.Fatal(err)
			}
			tl.sys, err = os.OpenFile(tl.sysfile, os.O_APPEND|os.O_CREATE, 0600)
			if err != nil {
				log.Fatal(err)
			}
			defer tl.sys.Close()
		}

		Tools[tl.toolname] = tl
	}

	return int(cnt)
}
