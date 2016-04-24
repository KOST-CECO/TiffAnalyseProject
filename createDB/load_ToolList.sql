
-- mySQL  Settings
-- USE tap;

-- SQLITE System Settings
.header on
.mode column

-- Foreign key constraints are disabled by default
-- Use the foreign_keys pragma to turn them on
-- PRAGMA foreign_keys = 1; 

-- Tabellenstruktur für Tabelle analysetool ------------------------------------
DELETE FROM analysetool;

INSERT INTO analysetool (toolname, prgfile, prgparam, logfile, sysfile) VALUES (
	'exif', 
	'C:\\Tools\\exiftool10.1\\exiftool(-k).exe', 
	'%file%', 
	'', 
	'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\exif_sys'
);

INSERT INTO analysetool (toolname, prgfile, prgparam, logfile, sysfile) VALUES (
	'file', 
	'c:\\Tools\\PCUnixUtils\\GnuWin32\\bin\\file.exe', 
	'-b -i %file%', 
	'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\file_log', 
	''
);

SELECT * FROM analysetool;
