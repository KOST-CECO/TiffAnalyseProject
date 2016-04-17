package main

import (
	"database/sql"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"

	_ "github.com/mattn/go-sqlite3"
)

// global variable definitions
var KeyCounter int32 = 0 // holds the latest id used in namefile and keyfile

func main() {
	// for test purpose only
	cmd := exec.Command("C:/Tools/PCUnixUtils/cp.exe", "tab_backup.db", "tap.db")
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}

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
	TapDb, err := sql.Open("sqlite3", os.Args[2])
	if err != nil {
		log.Fatal(os.Args[2] + " is not a sqlite3 database")
	}
	defer TapDb.Close()

	rows, err := TapDb.Query("SELECT MAX(id) FROM keyfile")
	if err != nil {
		log.Print(err)
		log.Fatal(os.Args[2] + " is not valide TAP database")
	}
	defer rows.Close()
	for rows.Next() {
		rows.Scan(&KeyCounter)
		fmt.Println(KeyCounter)
	}

	// run folder walk
	path, err := filepath.Abs(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	procloop(path+string(os.PathSeparator), TapDb)
	os.Exit(0)
}

// read all files in actual folder and recurse through subsequent folders
func procloop(dir string, TapDb *sql.DB) {
	files, _ := ioutil.ReadDir(dir)

	for _, f := range files {
		// ignore hidden files and folder
		if (f.Name()[0:1]) != "." {
			if f.IsDir() {
				// subsequent folder detected
				procloop(dir+f.Name()+string(os.PathSeparator), TapDb)
			} else {
				// process file
				// fmt.Println(dir + f.Name())
				procfile(dir, f, TapDb)
			}

		}

	}
}

// write FileInfo in database namefile and keyfile
func procfile(dir string, file os.FileInfo, TapDb *sql.DB) {
	KeyCounter = KeyCounter + 1

	tx, err := TapDb.Begin()
	if err != nil {
		log.Fatal(err)
	}

	stmt1, err := tx.Prepare("INSERT INTO namefile (id, serverame, filepath, filename) VALUES (?, ?, ?, ?)")
	if err != nil {
		log.Fatal(err)
	}
	defer stmt1.Close()

	_, err = stmt1.Exec(KeyCounter, filepath.VolumeName(dir), dir, file.Name())
	if err != nil {
		log.Fatal(err)
	}

	// compute md5 of file
	// http://dev.pawelsz.eu/2014/11/google-golang-compute-md5-of-file.html
	// https://www.socketloop.com/tutorials/how-to-generate-checksum-for-file-in-go
	stmt2, err := tx.Prepare("INSERT INTO keyfile (id, creationtime, filesize) VALUES (?, ?, ?)")
	if err != nil {
		log.Fatal(err)
	}
	defer stmt2.Close()

	_, err = stmt2.Exec(KeyCounter, file.ModTime(), file.Size())
	if err != nil {
		log.Fatal(err)
	}

	tx.Commit()

	fmt.Println(dir + file.Name())
}
