package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	//"os/exec"
	"path/filepath"

	"github.com/KOST-CECO/TiffAnalyseProject/util"
	_ "github.com/mattn/go-sqlite3"
)

// global type and variable definitions
type ToolList struct {
	toolname string
	prgfile  string
	prgparam string
	logfile  string
	log      *os.File
	sysfile  string
	sys      *os.File
}

var Tools map[string]ToolList

var KeyCounter int32 = 0 // holds the latest id used in namefile and keyfile

// read prog arguments, test database and start analysing
func main() {

	// read initial parameter from command line
	if len(os.Args) != 2 {
		fmt.Println("usage: " + os.Args[0] + " [options] database")
		os.Exit(-1)
	}

	// check for valid file
	fi, fierr := os.Stat(os.Args[1])
	if fierr != nil {
		log.Fatal(os.Args[1] + " is not a valid database name")
	}
	if !fi.Mode().IsRegular() {
		log.Fatal(os.Args[1] + " is not a database file")
	}

	// open sqlite3 database
	TapDb, err := sql.Open("sqlite3", os.Args[1])
	if err != nil {
		log.Fatal(os.Args[1] + " is not a sqlite3 database")
	}
	defer TapDb.Close()

	// check for valid sqlite3 database and read max id
	KeyCounter = util.Checkdb(TapDb)

	// check registert tools for validation
	toolcnt := Regtools(TapDb)

	fmt.Println(toolcnt)
	fmt.Println(Tools)
}

// read and register list of analyse tools
func Regtools(db *sql.DB) int {
	var cnt int = 0
	var tl ToolList
	Tools = make(map[string]ToolList)

	rows, err := db.Query("SELECT toolname, prgfile, prgparam, logfile, sysfile FROM analysetool")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		cnt++
		rows.Scan(&tl.toolname, &tl.prgfile, &tl.prgparam, &tl.logfile, &tl.sysfile)

		// check for valid program file
		tl.prgfile, err = filepath.Abs(tl.prgfile)
		if err != nil {
			log.Fatal(err)
		}
		_, err := os.Stat(tl.prgfile)
		if err != nil {
			log.Fatal(tl.toolname + " prgfile not found: " + tl.prgfile)
		}

		// open log file
		tl.log = nil
		if tl.logfile != "" {
			tl.logfile, err = filepath.Abs(tl.logfile)
			if err != nil {
				log.Fatal(err)
			}
			tl.log, err = os.OpenFile(tl.logfile, os.O_APPEND|os.O_CREATE, 0600)
			if err != nil {
				log.Fatal(err)
			}
			defer tl.log.Close()
		}

		// open sys file
		tl.sys = nil
		if tl.sysfile != "" {
			tl.sysfile, err = filepath.Abs(tl.sysfile)
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
