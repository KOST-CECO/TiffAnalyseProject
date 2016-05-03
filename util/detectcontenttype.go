// Package util contains utility functions
package util

import (
	"net/http"
	"os"
)

func Detectcontenttype(path string) (string, error) {

	file, err := os.Open(path)
	if err != nil {
		return "undefined", err
	}
	defer file.Close()

	// Only the first 512 bytes are used to sniff the content type.
	buffer := make([]byte, 512)
	_, err = file.Read(buffer)
	if err != nil {
		return "undefined", err
	}

	// Reset the read pointer if necessary.
	file.Seek(0, 0)

	// Always returns a valid content-type and "application/octet-stream" if no others seemed to match.
	contentType := http.DetectContentType(buffer)

	return contentType, nil
}
