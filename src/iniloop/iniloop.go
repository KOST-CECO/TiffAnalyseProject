package main

import (
	"fmt"
	"io/ioutil"
)

func main() {
	doloop(("./"))
}

func doloop(dir string) {
	files, _ := ioutil.ReadDir(dir)

	for _, f := range files {
		if f.IsDir() {
			fmt.Println("DIR")
		} else {
			fmt.Println(f.Name())
		}

	}
}
