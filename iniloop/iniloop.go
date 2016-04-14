package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/KOST-CECO/TiffAnalyseProject/looputil"
	_ "github.com/mattn/go-sqlite3"
)

var keyCounter int32 = 0 // holds the latest id used in namefile and keyfile

func main() {
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

	// check for valid sqlite3 database
	db, err := sql.Open("sqlite3", os.Args[2])
	if err != nil {
		log.Fatal(os.Args[2] + " is not a sqlite3 database")
	}
	defer db.Close()
	rows, err := db.Query("SELECT MAX(id) FROM keyfile")
	if err != nil {
		log.Print(err)
		log.Fatal(os.Args[2] + " is not valide TAP database")
	}
	defer rows.Close()
	for rows.Next() {
		rows.Scan(&keyCounter)
		fmt.Println(keyCounter)
	}

	// run folder walk
	path, err := filepath.Abs(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	looputil.Doloop(path + string(os.PathSeparator))
	os.Exit(0)

}
