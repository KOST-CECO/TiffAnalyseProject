/* Hello World program */

/* http://stackoverflow.com/questions/1217943/where-are-include-files-stored-ubuntu-linux-gcc
For the specific purpose of seeing where #include "goo" and #include <zap> will search on your system, I recommend:

$ touch a.c
$ gcc -v -E a.c
 ...
#include "..." search starts here:
#include <...> search starts here:
 /usr/local/include
 /usr/lib/gcc/i686-apple-darwin9/4.0.1/include
 /usr/include
 /System/Library/Frameworks (framework directory)
 /Library/Frameworks (framework directory)
End of search list.
# 1 "a.c"

This is one way to see the search lists for included files, including (if any) directories into which #include "..." will look 
but #include <...> won't. This specific list I'm showing is actually on Mac OS X (aka Darwin) 
but the commands I recommend will show you the search lists (as well as interesting configuration details that I've replaced with ... here;-) 
on any system on which gcc runs properly.
*/

#include<stdio.h>

main()
{
    printf("Hello World");


}
