package main

import (
	"crypto/md5"
	"fmt"
	"io"
	"math"
	"os"
)

const filechunk = 8192 // we settle for 8KB

// Generate checksum for a file in Go
// https://www.socketloop.com/tutorials/how-to-generate-checksum-for-file-in-go
func main() {

	file, err := os.Open("Q:/KOST/_testdaten/TIFF/Workshop_TIFF-JPEG2000/AA-IV-1754.tif")

	if err != nil {
		panic(err.Error())
	}

	defer file.Close()

	// calculate the file size
	info, _ := file.Stat()

	filesize := info.Size()

	blocks := uint64(math.Ceil(float64(filesize) / float64(filechunk)))

	hash := md5.New()

	for i := uint64(0); i < blocks; i++ {
		blocksize := int(math.Min(filechunk, float64(filesize-int64(i*filechunk))))
		buf := make([]byte, blocksize)

		file.Read(buf)
		io.WriteString(hash, string(buf)) // append into the hash
	}

	fmt.Printf("%s checksum is %x\n", file.Name(), hash.Sum(nil))

}
