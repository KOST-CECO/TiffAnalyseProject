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

-- Testsettings für Logrotation
-- INSERT INTO logrotate (logcounter, maxexecute) VALUES (1, 100000);

DELETE FROM analysetool;

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'file',
	'/usr/bin/file',
	'-b -i %file%',
	'',
	'',
	''
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'jhove',
	'/usr/bin/jhove',
	'%file% -o %log%',
	'log/jhove_tmp',
	'log/jhove_out',
	''
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'tiffhist',
	'./tiffhist',
	'%file% %log%',
	'log/tiffhist_tmp',
	'log/tiffhist_out',
	''
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'checkit_tiff',
	'./checkit_tiff',
	'-c %file% cit_tiff_baseline_minimal.cfg',
	'',
	'',
	'log/checkit_tiff_sys'
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'exif',
	'/usr/bin/exiftool',
	'-a -u -g1 %file%',
	'',
	'',
	''
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'exiv2',
	'/usr/bin/exiv2',
	'-pa %file%',
	'',
	'',
	''
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'ImageMagick',
	'/usr/bin/identify.im6',
	'-verbose %file%',
	'',
	'',
	'log/imagemagick_sys'
);

INSERT INTO analysetool (toolname,prgfile,prgparam,tmplog,logfile,sysfile) VALUES (
	'dpf-manager',
	'dpf-manager-wrapper.sh',
	'%file% %log%',
	'log/dpf-manager_tmp',
	'log/dpf-manager_out',
	''
);


SELECT * FROM analysetool;
