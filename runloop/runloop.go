package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	//"os/exec"

	"github.com/KOST-CECO/TiffAnalyseProject/util"
	_ "github.com/mattn/go-sqlite3"
)

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
	toolcnt := util.Regtools(TapDb)

	fmt.Println(toolcnt)
	fmt.Println(util.Tools)
}
