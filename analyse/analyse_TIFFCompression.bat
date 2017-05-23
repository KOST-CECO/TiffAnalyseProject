@ECHO off
SETLOCAL

SET UNIX_HOME=C:\Tools\PCUnixUtils
SET PERL_HOME=C:\Tools\Perl
SET PATH=%UNIX_HOME%;%PERL_HOME%\bin;%PATH%

REM ----------------------------------------------------------------------------
IF [%1]==[] (
	ECHO log path is missing
	ECHO usage: %0 path
	EXIT /B
)

IF NOT EXIST %1 (
	ECHO invalid path: %1
	ECHO usage: %0 path
	EXIT /B
)

SET OUT=c:\tmp\dummy.log
rm -f %OUT%

FOR /F "tokens=*" %%G IN ('dir /b %1\tiffhist*.log') DO (
	REM ECHO %%G
	CAT %1\%%G >> %OUT%
)
ECHO.
ECHO %1
ECHO Total TIFF Files
grep "259$Compression" %OUT% | wc -l
ECHO.

ECHO Compression:1 none
grep "259$Compression:1" %OUT% | wc -l
ECHO Compression:2 CCIT 1D
grep "259$Compression:2" %OUT% | wc -l
ECHO Compression:3 Fax Group 3
grep "259$Compression:3" %OUT% | wc -l
ECHO Compression:4 Fax Group 4
grep "259$Compression:4" %OUT% | wc -l
ECHO Compression:5 LZW
grep "259$Compression:5" %OUT% | wc -l
ECHO Compression:6 old JPEG
grep "259$Compression:6" %OUT% | wc -l
ECHO Compression:7 JPEG
grep "259$Compression:7" %OUT% | wc -l
ECHO Compression:8 Adobe Deflate
grep "259$Compression:8" %OUT% | wc -l
ECHO Compression:9 JBIG bw
grep "259$Compression:9" %OUT% | wc -l
ECHO Compression:10 JBIG color
grep "259$Compression:10" %OUT% | wc -l
ECHO Compression:32773 PackBits
grep "259$Compression:32773" %OUT% | wc -l
ECHO other Compression Tags
grep -v "259\$Compression\:[0-9]" c:\tmp\dummy.log | grep -v "259$Compression:32773" | grep "259Compression:" | wc -l
ECHO.

rm %OUT%
