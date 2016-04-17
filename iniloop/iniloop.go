package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/KOST-CECO/TiffAnalyseProject/looputil"
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

	// check for valid sqlite3 database and open database
	looputil.CheckDb(os.Args[2])

	// run folder walk
	path, err := filepath.Abs(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	looputil.Procloop(path + string(os.PathSeparator))
	os.Exit(0)

}
