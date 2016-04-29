
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

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'exif',
	'C:\\Tools\\exiftool10.1\\exiftool(-k).exe',
	' -a -u -g1 %file% > %log%',
	'..\\log\\exif.log',
	'..\\log\\exif',
	'..\\log\\exif_sys'
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'exiv2',
	'C:\\Tools\\exiv2-0.25\\exiv2.exe',
	' -pa %file%',
	'',
	'',
	'..\\log\\exiv2_sys'
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'file',
	'c:\\Tools\\PCUnixUtils\\GnuWin32\\bin\\file.exe',
	'-b -i %file%',
	'',
	'',
	''
);

SELECT * FROM analysetool;
