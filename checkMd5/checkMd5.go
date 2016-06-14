package main

import (
	"fmt"

	"github.com/KOST-CECO/TiffAnalyseProject/util"
)

func main() {
	md5, _ := util.ComputeMd5("checkMd5.go")
	fmt.Printf("%x", md5)
}
