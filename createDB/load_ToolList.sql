
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
	'Jhove',
	'c:\Tools\jhove\jhove.bat',
	'%file% -o %log%',
	'..\\log\\jhove.log',
	'..\\log\\jhove_log',
	''
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'exif',
	'C:\\Tools\\exiftool10.1\\exiftool(-k).exe',
	' -a -u -g1 %file% > %log%',
	'..\\log\\ef.log',
	'..\\log\\exif_log',
	''
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'ImageMagick',
	'C:\\Tools\\ImageMagick-6.9.1-Q16\\identify.exe',
	' -verbose %file%',
	'..\\log\\im.log',
	'..\\log\\imagemagick_log',
	'..\\log\\imagemagick_sys'
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'exiv2',
	'C:\\Tools\\exiv2-0.25\\exiv2.exe',
	' -pa %file%',
	'..\\log\\ev2.log',
	'',
	'..\\log\\exiv2_sys'
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'file',
	'C:\\Tools\\PCUnixUtils\\GnuWin32\\bin\\file.exe',
	'-b -i %file%',
	'',
	'..\\log\\file_log',
	''
);

SELECT * FROM analysetool;
