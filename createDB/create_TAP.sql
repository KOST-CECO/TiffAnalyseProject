
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
	toolname VARCHAR(30) NOT NULL,			-- Name des registrierten Analyseprogramms in Kurzform
	prgfile VARCHAR(255) NOT NULL,			-- Pfad und Dateiname zum Analyseprogramms
	prgparam VARCHAR(255) NOT NULL,			-- Parameter des Analyseprogramms mit Wildcards %file% und %log%
	tmplog VARCHAR(255) DEFAULT '' NOT NULL,	-- Tempor‰re Logdatei: ersetzt Wildcards  %log% beim Ausf¸hren des Analyseprogramms, fehlen meint keine Log Datei schreiben
	logfile VARCHAR(255) DEFAULT '' NOT NULL,	-- Pfad und Dateiname der mit diesem Analyseprogramms verbunden Logdatei: Ist kein Logfile definiert wird in BLOB "logout" gespeichert
	sysfile VARCHAR(255) DEFAULT '' NOT NULL,	-- Pfad und Dateiname der mit diesem Analyseprogramms verbunden Ausgabedatei: Ist kein Sysfile definiert wird in BLOB "sysout" gespeichert
	PRIMARY KEY (toolname)
);

-- Tabellenstruktur f¸r Tabelle logrotate --------------------------------------
CREATE TABLE logrotate (
	logcounter INTEGER DEFAULT 0 NOT NULL,	-- Z‰hler f¸r "logfile" bzw. "sysfile" beginnend mit 1
	maxexecute INTEGER DEFAULT 10000,	-- Maximal Verarbeitungsschritte pro "logfile" bzw. "sysfile"
	actexecute INTEGER DEFAULT 0,		-- Aktueller Verarbeitungsschritt
	PRIMARY KEY (logcounter)
);

-- Tabellenstruktur f¸r Tabelle namefile ---------------------------------------
CREATE TABLE namefile (
	id INTEGER NOT NULL,			-- Referenz zu "keyfile"
	serverame VARCHAR(30) DEFAULT NULL,	-- Name des NAS Servers oder des zugeordneten Laufwerkbuchstabens
	filepath VARCHAR(255) DEFAULT NULL,	-- Dateipfad
	filename VARCHAR(255) DEFAULT NULL,	-- Dateiname mit Dateiextension
	PRIMARY KEY (id),
	UNIQUE (filepath, filename)
);

-- Tabellenstruktur f¸r Tabelle keyfile ----------------------------------------
CREATE TABLE keyfile (
	id INTEGER NOT NULL,			-- Referenz
	md5 VARCHAR(32),			-- MD5 Hashwert
	creationtime DATETIME DEFAULT NULL,	-- Entstehungszeitpunkt der Datei laut Dateisystem
	filesize LONG DEFAULT NULL,		-- Dateigrˆsse in Byte
	pdate DATETIME DEFAULT NULL,		-- Zeitpunkt f¸r den Abschluss der Analyse
	loccounter INTEGER DEFAULT 1,		-- Z‰hler f¸r "logfile" bzw. "sysfile" Logrotation beginnend mit 1
	mimetype VARCHAR(255) DEFAULT NULL,	-- Internet Media Type, auch MIME-Type aufgrund der Magic Number
	PRIMARY KEY (md5),
	FOREIGN KEY(id) REFERENCES namefile(id),
	FOREIGN KEY(loccounter) REFERENCES logrotate(loccounter)
);

-- Tabellenstruktur f¸r Tabelle status -----------------------------------------
CREATE TABLE status (
	md5 VARCHAR(32) NOT NULL,		-- MD5 SchlÅssel der TIFF Datei
	toolname VARCHAR(30) NOT NULL,		-- Name des registrierten Analyseprogramms in Kurzform
	retval VARCHAR(255) DEFAULT NULL,	-- RÅckgabe Wert des Tools (Exit Status 0 = erfolgreicher Abschluss)  http://www.hiteksoftware.com/knowledge/articles/049.htm
	PRIMARY KEY (md5, toolname),
	FOREIGN KEY(md5) REFERENCES keyfile(md5),
	FOREIGN KEY(toolname) REFERENCES analysetool(toolname)
);

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
