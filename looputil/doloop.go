// Package loop contains utility functions
package looputil

import (
	"fmt"
	"io/ioutil"
	"os"
)

// Read all files in a Folder and recurse through subsequent folders
func Doloop(dir string) {
	files, _ := ioutil.ReadDir(dir)

	for _, f := range files {
		// ignore hidden files and folder
		if (f.Name()[0:1]) != "." {
			if f.IsDir() {
				// subsequent folder detected
				Doloop(dir + f.Name() + string(os.PathSeparator))
			} else {
				fmt.Println(dir + f.Name())
			}

		}

	}
}