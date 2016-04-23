// Package util contains utility functions
package main

import (
	"fmt"

	"github.com/KOST-CECO/TiffAnalyseProject/util"
)

func main() {
	if b, err := util.ComputeMd5("computeMd5.go"); err != nil {
		fmt.Printf("Err: %v", err)
	} else {
		fmt.Printf("AA-IV-1754.tif md5 checksum is: %x", b)
	}
}
