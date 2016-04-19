// Package util contains utility functions
package main

import (
	"crypto/md5"
	"fmt"
	"io"
	"os"
)

func main() {
	if b, err := ComputeMd5("main.go"); err != nil {
		fmt.Printf("Err: %v", err)
	} else {
		fmt.Printf("main.go md5 checksum is: %x", b)
	}
}

// compute md5 of file
// http://dev.pawelsz.eu/2014/11/google-golang-compute-md5-of-file.html
func ComputeMd5(filePath string) ([]byte, error) {
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
