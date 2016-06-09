// Package util contains utility functions
package util

import (
	"fmt"
	"path/filepath"
	"strings"
)

// overwrite any occurence of file-name and file-path in log output
func Anonymize(logtxt []byte, file string) string {
	// remove any significant character from filename
	anonym := func(r rune) rune {
		switch {
		case r == '/':
			return '/'
		case r == '\\':
			return '\\'
		case r == '.':
			return '.'
		case r == ':':
			return ':'
		}
		return '*'
	}

	// change filesystem delimiter WIN -> LINUX and vice versa
	changefs := func(r rune) rune {
		switch {
		case r == '/':
			return '\\'
		case r == '\\':
			return '/'
		}
		return r
	}

	txt := fmt.Sprintf("%s", logtxt)
	filename := filepath.Base(file)
	path := filepath.Dir(file)

	for i := 0; i <= 1; i++ {
		txt = strings.Replace(txt, file, strings.Map(anonym, file), -1)
		txt = strings.Replace(txt, path, strings.Map(anonym, path), -1)
		txt = strings.Replace(txt, filename, strings.Map(anonym, filename), -1)

		file = strings.Map(changefs, file)
		path = strings.Map(changefs, path)
		filename = strings.Map(changefs, filename)
	}

	return txt

}
