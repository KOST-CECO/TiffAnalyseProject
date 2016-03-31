package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
	// read initial parameter from command line
	if len(os.Args) == 2 {
		fi, err := os.Stat(os.Args[1])
		if (err != nil) && fi.IsDir() {
			doloop(fi.Name() + "/")
		} else {
			fmt.Println("error: " + os.Args[1] + " is not a valid folder name")
		}
	} else {
		fmt.Println("usage: " + os.Args[0] + " [folder]")
	}
}

func doloop(dir string) {
	files, _ := ioutil.ReadDir(dir)

	for _, f := range files {
		// ignore hidden files and folder
		if (f.Name()[0:1]) != "." {
			if f.IsDir() {
				doloop(dir + f.Name() + "/")
			} else {
				fmt.Println(dir + f.Name())
			}

		}

	}
}
