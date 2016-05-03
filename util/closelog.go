// Package util contains utility functions
package util

// close all open log and sysfiles
func Closelog() {
	var tl ToolList

	for _, tl = range Tools {
		if tl.Logfile != "" {
			tl.Log.Close()
		}
		if tl.Sysfile != "" {
			tl.Sys.Close()
		}
	}
	return
}
