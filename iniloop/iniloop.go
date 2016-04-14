package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/KOST-CECO/TiffAnalyseProject/looputil"
)

func main() {
	// read initial parameter from command line
	if len(os.Args) != 2 {
		fmt.Println("usage: " + os.Args[0] + " [folder]")
		os.Exit(-1)
	}
	// check for valid folder
	fi, err := os.Stat(os.Args[1])
	switch {
	case err != nil:
		break
	case fi.IsDir():
		path := filepath.Clean(os.Args[1])
		looputil.Doloop(path + string(os.PathSeparator))
		os.Exit(0)
	}
	fmt.Println("error: " + os.Args[1] + " is not a valid folder name")
	os.Exit(-1)
}
