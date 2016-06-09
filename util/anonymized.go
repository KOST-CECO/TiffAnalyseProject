// Package util contains utility functions
package util

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
)

// overwrite any occurence of file-name and file-path in log output
func Anonymized(logtxt []byte, file string) {
	anonym := func(r rune) rune {
		switch {
		case r == os.PathSeparator:
			return os.PathSeparator
		case r == '.':
			return '.'
		case r == ':':
			return ':'
		}
		return '*'
	}

	filename := filepath.Base(file)
	path := filepath.Dir(file)
	txt := fmt.Sprintf("%s", logtxt)

	txt = strings.Replace(txt, file, strings.Map(anonym, file), -1)
	txt = strings.Replace(txt, path, strings.Map(anonym, path), -1)
	txt = strings.Replace(txt, filename, strings.Map(anonym, filename), -1)

	log.Println(txt)

}
