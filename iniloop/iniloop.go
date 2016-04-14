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

func main() {
	// read initial parameter from command line
	if len(os.Args) != 3 {
		fmt.Println("usage: " + os.Args[0] + " [options] folder database")
		os.Exit(-1)
	}

	// check for valid folder
	fo, foerr := os.Stat(os.Args[1])
	if foerr != nil {
		log.Fatal("err: " + os.Args[1] + " is not a valid folder name")
	}
	if !fo.IsDir() {
		log.Fatal("err: " + os.Args[1] + " is not a folder")
	}

	// check for valid file
	fi, fierr := os.Stat(os.Args[2])
	if fierr != nil {
		log.Fatal("err: " + os.Args[2] + " is not a valid file name")
	}
	if !fi.Mode().IsRegular() {
		log.Fatal("err: " + os.Args[2] + " is not a file")
	}

	// check for valid sqlite3 database
	db, err := sql.Open("sqlite3", os.Args[2])
	if err != nil {
		log.Fatal("err: " + os.Args[2] + " is not a sqlite3 database")
	}
	defer db.Close()

	// run folder walk
	path := filepath.Clean(os.Args[1])
	looputil.Doloop(path + string(os.PathSeparator))
	os.Exit(0)

}
