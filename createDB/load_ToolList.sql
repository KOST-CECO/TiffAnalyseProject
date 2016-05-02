-- SQLITE System Settings
.header on
.mode column

/* Tabellenstruktur für Tabelle analysetool ------------------------------------
	toolname 	Name des registrierten Analyseprogramms in Kurzform
	prgfile 	Pfad und Dateiname zum Analyseprogramms
	prgparam 	Parameter des Analyseprogramms mit Wildcards %file% und %log%
	tmplog 		Temporäre Logdatei: ersetzt Wildcards  %log% beim Ausführen des Analyseprogramms, Fehlen meint keine Log Datei schreiben
	logfile 	Pfad und Dateiname der mit diesem Analyseprogramms verbunden Logdatei: Ist kein Logfile definiert wird in LOB "logout" gespeichert
	sysfile 	Pfad und Dateiname der mit diesem Analyseprogramms verbunden Ausgabedatei: Ist kein Sysfile definiert wird in LOB "sysout" gespeichert
*/

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
