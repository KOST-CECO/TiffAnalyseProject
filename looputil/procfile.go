// Package loop contains utility functions
package looputil

import (
	"fmt"
	"os"
)

// Read all files in a Folder and recurse through subsequent folders
func Procfile(dir string, file os.FileInfo) {

	/*
		stmt, err := tx.Prepare("INSERT INTO namefile (id, serverame, filepath, filename) VALUES (?, ?, ?, ?)")
		if err != nil {
			log.Fatal(err)
		}
		defer stmt.Close()
		_, err = stmt.Exec(KeyCounter, "c:\\", dir, file.Name())
		if err != nil {
			log.Fatal(err)
		}
	*/

	fmt.Println(dir + file.Name())
}
