package main

import (
	"database/sql"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	// "os/exec"
	"path/filepath"

	"github.com/KOST-CECO/TiffAnalyseProject/util"
	_ "github.com/mattn/go-sqlite3"
)

// global variable definitions
var KeyCounter int32 = 0 // holds the latest id used in namefile and keyfile

// !!! inilp: version without tranactions !!!
// read prog arguments, test database and start directory walk
func main() {
	/* copy empty tap db for test purpose only
	cmd := exec.Command("C:/Tools/PCUnixUtils/cp.exe", "tap_backup.db", "tap.db")
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	} */

	// read initial parameter from command line
	if len(os.Args) != 3 {
		fmt.Println("usage: " + os.Args[0] + " [options] folder database")
		os.Exit(-1)
	}

	// check for valid folder
	fo, foerr := os.Stat(os.Args[1])
	if foerr != nil {
		log.Fatal(os.Args[1] + " is not a valid folder name")
	}
	if !fo.IsDir() {
		log.Fatal(os.Args[1] + " is not a folder")
	}

	// check for valid file
	fi, fierr := os.Stat(os.Args[2])
	if fierr != nil {
		log.Fatal(os.Args[2] + " is not a valid database name")
	}
	if !fi.Mode().IsRegular() {
		log.Fatal(os.Args[2] + " is not a database file")
	}

	// open sqlite3 database
	TapDb, err := sql.Open("sqlite3", os.Args[2])
	if err != nil {
		log.Fatal(os.Args[2] + " is not a sqlite3 database")
	}
	defer TapDb.Close()

	// set PRAGMA for fast insert
	_, err = TapDb.Exec("PRAGMA foreign_keys = 0;")
	if err != nil {
		log.Fatal(err)
	}
	_, err = TapDb.Exec("PRAGMA synchronous = 0;")
	if err != nil {
		log.Fatal(err)
	}
	_, err = TapDb.Exec("PRAGMA journal_mode = 0;")
	if err != nil {
		log.Fatal(err)
	}

	stmt, err := TapDb.Prepare("INSERT INTO namefile (id, serverame, filepath, filename) VALUES (?, ?, ?, ?)")
	if err != nil {
		log.Fatal(err)
	}
	defer stmt.Close()

	// check for valid sqlite3 database and read max id
	KeyCounter = util.Checkdb(TapDb)

	// run folder walk
	path, err := filepath.Abs(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	procloop(path+string(os.PathSeparator), stmt)
	os.Exit(0)
}

// read all files in actual folder and recurse through subsequent folders
func procloop(dir string, stmt *sql.Stmt) {
	files, _ := ioutil.ReadDir(dir)

	for _, f := range files {
		// ignore hidden files and folder
		if (f.Name()[0:1]) != "." {
			if f.IsDir() {
				// subsequent folder detected
				procloop(dir+f.Name()+string(os.PathSeparator), stmt)
			} else {
				// process file
				// fmt.Println(dir + f.Name())
				procfile(dir, f, stmt)
			}
		}
	}
}

// write FileInfo in database namefile
func procfile(dir string, file os.FileInfo, stmt *sql.Stmt) {
	id := KeyCounter + 1

	// start transaction

	_, err := stmt.Exec(id, filepath.VolumeName(dir), dir, file.Name())
	if err != nil {
		log.Println("allready entered: " + dir + file.Name())
		return
	}

	// end transaction
	KeyCounter = KeyCounter + 1

	log.Println(dir + file.Name())
}
