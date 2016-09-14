-- Horizontale Auswertung der Ausgaben verschiedener Tools 

.output exiftool&exiv2.html
.mode asci
SELECT "<!DOCTYPE html><HTML><head><style> table { font-family: arial, sans-serif; border-collapse: collapse; width: 100%; } td, th { border: 1px solid #dddddd; text-align: left; padding: 8px; } tr:nth-child(even) { background-color: #dddddd; }</style></head>
<BODY><PRE><TABLE>";

.mode html
SELECT
--    sys1.md5,
    sys1.toolname,
    sys1.sysout,
--    sys2.md5,
    sys2.toolname,
    sys2.sysout
FROM
    (SELECT md5, toolname, sysout from sysindex WHERE toolname="exif") sys1
INNER JOIN
    (SELECT md5, toolname, sysout from sysindex WHERE toolname="exiv2") sys2
ON
    sys1.md5 = sys2.md5;

.mode ascii
SELECT "</TABLE></PRE></BODY></HTML>";

.exit
