package main

import (
	//"bytes"
	"database/sql"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
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
	_ = util.Regtools(TapDb)

	// run analysis over all files in NAMEFILE
	analyseAllFile(TapDb)

	// close all files
	// defer tl.Sys.Close()
	// defer tl.log.Close()

}

// read all files in NAMEFILE, create KEYFILE and start analysing
func analyseAllFile(db *sql.DB) {

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
			// end of NAMEFILE
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
		md5string := fmt.Sprintf("%x", md5)

		stmt1, err := tx.Prepare("INSERT INTO keyfile (md5, creationtime, filesize) VALUES (?, ?, ?)")
		if err != nil {
			log.Fatal(err)
		}
		defer stmt1.Close()
		_, err = stmt1.Exec(md5string, file.ModTime(), file.Size())
		if err != nil {
			// same file occurse twice in collection
			// log.Print(err)
		} else {
			// start analysing file
			analyseFile(tx, md5string, path+name)
		}

		stmt2, err := tx.Prepare("UPDATE namefile SET md5 = ? WHERE id = ?")
		if err != nil {
			log.Fatal(err)
		}
		defer stmt2.Close()

		_, err = stmt2.Exec(md5string, id)
		if err != nil {
			log.Fatal(err)
		}

		// end transaction -----------------------------------------------------
		tx.Commit()
	}
}

// read a file and start analysing it
func analyseFile(tx *sql.Tx, md5 string, file string) {
	fmt.Println("----file: " + file)
	var tl util.ToolList
	var exitStatus string = "exit status 0" // default exit status

	for _, tl = range util.Tools {
		par := strings.Replace(tl.Prgparam, "%file%", file, -1)
		par = strings.Replace(par, "%log%", tl.Tmplog, -1)
		params := strings.Fields(par)

		// run command
		out, err := exec.Command(tl.Prgfile, params...).CombinedOutput()
		if err != nil {
			exitStatus = fmt.Sprint(err)
			//log.Fatal(err)
		} else {
			exitStatus = "exit status 0"
		}

		// write STATUS
		stmt1, err := tx.Prepare("INSERT INTO status(md5, toolname, retval) VALUES (?, ?, ?)")
		if err != nil {
			log.Fatal(err)
		}
		defer stmt1.Close()
		_, err = stmt1.Exec(md5, tl.Toolname, exitStatus)
		if err != nil {
			log.Fatal(err)
		}

		// write SYSINDEX
		stmt2, err := tx.Prepare("INSERT INTO sysindex(md5, toolname, sysoffset, sysout) VALUES (?, ?, ?, ?)")
		if err != nil {
			log.Fatal(err)
		}
		defer stmt2.Close()
		if tl.Sysfile == "" {
			_, err = stmt2.Exec(md5, tl.Toolname, 0, fmt.Sprintf("%s", out))
		} else {
			fi, err := tl.Sys.Stat()
			if err != nil {
				log.Fatal(err)
			}
			_, err = stmt2.Exec(md5, tl.Toolname, fi.Size(), tl.Sysfile)
			if _, err = tl.Sys.WriteString(fmt.Sprintf("%s", out)); err != nil {
				log.Fatal(err)
			}
		}
		if err != nil {
			log.Fatal(err)
		}

	}
}
