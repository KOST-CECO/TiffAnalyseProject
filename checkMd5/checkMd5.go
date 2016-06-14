package main

import (
	"crypto/md5"
	"fmt"
	"io"
	"os"
)

func main() {
	md5, _ := computeMd5("checkMd5.go")
	fmt.Printf("%x", md5)
}

// compute md5 of file
// http://dev.pawelsz.eu/2014/11/google-golang-compute-md5-of-file.html
func computeMd5(filePath string) ([]byte, error) {
	var result []byte
	file, err := os.Open(filePath)
	if err != nil {
		return result, err
	}
	defer file.Close()

	hash := md5.New()
	if _, err := io.Copy(hash, file); err != nil {
		return result, err
	}

	return hash.Sum(result), nil
}
