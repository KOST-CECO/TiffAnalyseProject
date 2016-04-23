// Package util contains utility functions
package util

import (
	"crypto/md5"
	"io"
	"os"
)

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
