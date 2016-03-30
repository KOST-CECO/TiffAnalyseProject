
-- mySQL  Settings
-- USE tap;

-- SQLITE System Settings
-- .header on
-- .mode column

-- Foreign key constraints are disabled by default
-- Use the foreign_keys pragma to turn them on
PRAGMA foreign_keys = 1; 

-- Tabellen in der richtigen Reihenfolge lˆschen
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS logindex;
DROP TABLE IF EXISTS sysindex;
DROP TABLE IF EXISTS keyfile;
DROP TABLE IF EXISTS logrotate;
DROP TABLE IF EXISTS namefile;

DROP TABLE IF EXISTS analysetool;

-- Tabellenstruktur f¸r Tabelle analysetool ------------------------------------
CREATE TABLE analysetool (
	toolname VARCHAR(30) NOT NULL,		-- Name des registrierten Analyseprograms in Kurzform
	prgname VARCHAR(255) NOT NULL,		-- Pfad und Dateiname zum Analyseprograms
	logfile VARCHAR(255) DEFAULT NULL,	-- Pfad und Dateiname der mit diesem Analyseprograms verbunden Logdatei: Ist kein Logfile definiert wird in BLOB "logout" gespeichert
	sysfile VARCHAR(255) DEFAULT NULL,	-- Pfad und Dateiname der mit diesem Analyseprograms verbunden Ausgabedatei: Ist kein Sysfile definiert wird in BLOB "sysout" gespeichert
	logconcat BOOLEAN DEFAULT TRUE NOT NULL,-- Ja(1) bedeutet, dass  das Programm die Logdatei fortsetzen kann, Nein(0) es wir jeweils ein neues Log geschreiben und vom LOOP Programm an "logfile" angeh‰ngt
	PRIMARY KEY (toolname)
);
INSERT INTO analysetool (toolname, prgname, logfile, sysfile, logconcat) VALUES
('exif', 'C:\\Tools\\exiftool10.1\\exiftool(-k).exe', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\exif_log', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\exif_sys', 0),
('file', 'c:\\Tools\\PCUnixUtils\\GnuWin32\\bin\\file.exe', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\file_log', NULL, 1);

-- Tabellenstruktur f¸r Tabelle logrotate --------------------------------------
CREATE TABLE logrotate (
	loccounter INTEGER DEFAULT 1 NOT NULL,	-- Z‰hler f¸r "logfile" bzw. "sysfile" beginnend mit 1
	maxexecute INTEGER DEFAULT NULL,	-- Maximal Verarbeitungsschritte pro "logfile" bzw. "sysfile"
	actexecute INTEGER DEFAULT NULL,	-- Aktueller Verarbeitungsschritt
	PRIMARY KEY (loccounter)
);
INSERT INTO logrotate (loccounter, maxexecute, actexecute) VALUES 
(1, 0, 0);

-- Tabellenstruktur f¸r Tabelle namefile ---------------------------------------
CREATE TABLE namefile (
	id INTEGER NOT NULL,			-- Referenz zu "keyfile"
	serverame VARCHAR(30) DEFAULT NULL,	-- Name des NAS Servers oder des zugeordneten Laufwerkbuchstabens
	filepath VARCHAR(255) DEFAULT NULL,	-- Dateipfad
	filename VARCHAR(255) DEFAULT NULL,	-- Dateiname mit Dateiextension
	PRIMARY KEY (id),
	UNIQUE (filepath, filename)
);
INSERT INTO namefile (id, serverame, filepath, filename) VALUES 
(1, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\airplane', '4.2.05.tiff'),
(2, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\airplane', '7.1.02.tiff'),
(3, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\ship', 'boat.512.tiff');

-- Tabellenstruktur f¸r Tabelle keyfile ----------------------------------------
CREATE TABLE keyfile (
	id INTEGER NOT NULL,		-- Referenz
	md5 VARCHAR(32) NOT NULL,		-- MD5 Hashwert
	creationtime DATETIME DEFAULT NULL,	-- Entstehungszeitpunkt der Datei laut Dateisystem
	filesize LONG DEFAULT NULL,		-- Dateigrˆsse in Byte
	pdate DATETIME DEFAULT NULL,		-- Zeitpunkt f¸r den Abschluss der Analyse
	loccounter INTEGER DEFAULT 0,		-- Z‰hler f¸r "logfile" bzw. "sysfile" Logrotation beginnend mit 1
	PRIMARY KEY (md5),
	FOREIGN KEY(id) REFERENCES namefile(id),
	FOREIGN KEY(loccounter) REFERENCES logrotate(loccounter)
);
INSERT INTO keyfile (id, md5, creationtime, filesize, pdate, loccounter) VALUES
(1, '2651dbe60819160e42294dec9dbaed45', '1997-09-26 00:00:00', 786572, NULL, 1),
(2, '2fca7e211c648e7d53e78727764e3bfb', '1997-09-26 00:00:00', 262278, NULL, 1),
(3, 'f96911025037311c28974e1815f7bb5e', '1997-09-26 00:00:00', 262278, NULL, 1);

-- Tabellenstruktur f¸r Tabelle status -----------------------------------------
CREATE TABLE status (
	md5 VARCHAR(32) NOT NULL,		-- MD5 SchlÅssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Name des registrierten Analyseprograms in Kurzform
	retval VARCHAR(255) DEFAULT NULL,	-- RÅckgabe Wert des Tools (Exit Status 0 = erfolgreicher Abschluss)  http://www.hiteksoftware.com/knowledge/articles/049.htm
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);
INSERT INTO status (md5, toolname, retval) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 0),
('2651dbe60819160e42294dec9dbaed45', 'file', 1),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 0),
('2fca7e211c648e7d53e78727764e3bfb', 'file', 0),
('f96911025037311c28974e1815f7bb5e', 'exif', 0),
('f96911025037311c28974e1815f7bb5e', 'file', 3);

-- Tabellenstruktur f¸r Tabelle logindex ---------------------------------------
CREATE TABLE logindex (
	md5 VARCHAR(32) NOT NULL,		-- MD5 SchlÅssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Kurzname des Tools
	logoffset INTEGER DEFAULT NULL,		-- Offset in die Ausgabedatei logfile
	logout BLOB,				-- vollst‰ndige LOG Ausgabe des Analysetools
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);
INSERT INTO logindex (md5, toolname, logoffset, logout) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 1, NULL),
('2651dbe60819160e42294dec9dbaed45', 'file', 1, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 210, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'file', 32, NULL),
('f96911025037311c28974e1815f7bb5e', 'exif', 400, NULL),
('f96911025037311c28974e1815f7bb5e', 'file', 66, NULL);

-- Tabellenstruktur f¸r Tabelle sysindex ---------------------------------------
CREATE TABLE sysindex (
	md5 VARCHAR(32) NOT NULL,		-- MD5 SchlÅssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Kurzname des Tools
	sysoffset INTEGER DEFAULT NULL,		-- Offset in die Ausgabedatei "outfile"
	sysout BLOB ,				-- vollst‰ndige SystemOut Ausgabe des Analysetools
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);
INSERT INTO sysindex (md5, toolname, sysoffset, sysout) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 1, NULL),
('2651dbe60819160e42294dec9dbaed45', 'file', NULL, 'TIFF image data, big-endian'),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 22, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'file', NULL, 'TIFF image data, big-endian'),
('f96911025037311c28974e1815f7bb5e', 'exif', 81, NULL),
('f96911025037311c28974e1815f7bb5e', 'file', NULL, 'TIFF image data, big-endian');

