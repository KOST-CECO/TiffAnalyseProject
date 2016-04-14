// Package loop contains utility functions
package looputil

import (
	"fmt"
	"io/ioutil"
	"os"
)

// Recursion through a folder tree
func Doloop(dir string) {
	files, _ := ioutil.ReadDir(dir)

	for _, f := range files {
		// ignore hidden files and folder
		if (f.Name()[0:1]) != "." {
			if f.IsDir() {
				Doloop(dir + f.Name() + string(os.PathSeparator))
			} else {
				fmt.Println(dir + f.Name())
			}

		}

	}
}
