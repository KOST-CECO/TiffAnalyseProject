@ECHO OFF
SETLOCAL

"C:/Software/Windows Resource Kits/Tools/timeit.exe" -f timeit.dat -k md5sum md5sum.exe Q:/KOST/_testdaten/TIFF/Workshop_TIFF-JPEG2000/AA-IV-1754.tif
ECHO.
"C:/Software/Windows Resource Kits/Tools/timeit.exe" -f timeit.dat -k checksum checksum\checksum.exe
ECHO.
"C:/Software/Windows Resource Kits/Tools/timeit.exe" -f timeit.dat -k computeMd5 computeMd5\computeMd5.exe
ECHO.
EXIT /B
