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

	// run analysis over all files in NAMEFILE
	analyseFile(TapDb)

	fmt.Println(toolcnt)
	fmt.Println(util.Tools)

}

// read all files in NAMEFILE, create KEYFILE and start analysing
func analyseFile(db *sql.DB) {

	for {
		var id int32 = 0
		var path, name string

		// read a file entry form NAMEFILE
		rows, err := db.Query("SELECT MIN(id), filepath, filename FROM namefile WHERE md5 IS NULL")
		if err != nil {
			log.Fatal(err)
		}
		defer rows.Close()
		for rows.Next() {
			rows.Scan(&id, &path, &name)
		}
		file, err := os.Stat(path + name)
		if err != nil {
			// log.Print(err)
			return
		}

		// start transaction ---------------------------------------------------
		tx, err := db.Begin()
		if err != nil {
			log.Fatal(err)
		}

		// compute MD5 for file entry
		md5, err := util.ComputeMd5(path + name)

		stmt1, err := tx.Prepare("INSERT INTO keyfile (md5, creationtime, filesize) VALUES (?, ?, ?)")
		if err != nil {
			log.Fatal(err)
		}
		defer stmt1.Close()
		_, err = stmt1.Exec(fmt.Sprintf("%x", md5), file.ModTime(), file.Size())
		if err != nil {
			// log.Print(err)
		}

		stmt2, err := tx.Prepare("UPDATE namefile SET md5 = ? WHERE id = ?")
		if err != nil {
			log.Fatal(err)
		}
		defer stmt2.Close()

		_, err = stmt2.Exec(fmt.Sprintf("%x", md5), id)
		if err != nil {
			log.Fatal(err)
		}

		// end transaction -----------------------------------------------------
		KeyCounter = KeyCounter + 1
		tx.Commit()

		fmt.Println(id)
	}
}
