-- phpMyAdmin SQL Dump
-- version 2.10.3
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Erstellungszeit: 24. März 2016 um 10:35
-- Server Version: 5.0.45
-- PHP-Version: 5.2.3

-- 
-- Datenbank: `tap`
-- 

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `analysetool`
-- 

DROP TABLE IF EXISTS `analysetool`;
CREATE TABLE IF NOT EXISTS "analysetool" (
  "toolname" varchar(255) collate latin1_general_ci NOT NULL,
  "prgname" varchar(255) collate latin1_general_ci default NULL,
  "logfile" varchar(255) collate latin1_general_ci default NULL,
  "sysfile" varchar(255) collate latin1_general_ci default NULL,
  "logconcat" bit(1) NOT NULL,
  PRIMARY KEY  ("toolname")
);

-- 
-- Daten für Tabelle `analysetool`
-- 

INSERT INTO `analysetool` (`toolname`, `prgname`, `logfile`, `sysfile`, `logconcat`) VALUES 
('exif', 'C:\\Tools\\exiftool10.1\\exiftool(-k).exe', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\exif_log', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\exif_sys', '\0'),
('file', 'c:\\Tools\\PCUnixUtils\\GnuWin32\\bin\\file.exe', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\file_log', NULL, '');

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `keyfile`
-- 

DROP TABLE IF EXISTS `keyfile`;
CREATE TABLE IF NOT EXISTS "keyfile" (
  "id" int(11) default NULL,
  "md5" varchar(32) collate latin1_general_ci NOT NULL,
  "creationtime" datetime default NULL,
  "filesize" int(11) default NULL,
  "pdate" datetime default NULL,
  "loccounter" int(11) default NULL,
  PRIMARY KEY  ("md5"),
  UNIQUE KEY "namefilekeyfile" ("id"),
  UNIQUE KEY "primarykey" ("id"),
  KEY "logrotatekeyfile" ("loccounter")
);

-- 
-- Daten für Tabelle `keyfile`
-- 

INSERT INTO `keyfile` (`id`, `md5`, `creationtime`, `filesize`, `pdate`, `loccounter`) VALUES 
(1, '2651dbe60819160e42294dec9dbaed45', '1997-09-26 00:00:00', 786572, NULL, 1),
(2, '2fca7e211c648e7d53e78727764e3bfb', '1997-09-26 00:00:00', 262278, NULL, 1),
(3, 'f96911025037311c28974e1815f7bb5e', '1997-09-26 00:00:00', 262278, NULL, 1);

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `logindex`
-- 

DROP TABLE IF EXISTS `logindex`;
CREATE TABLE IF NOT EXISTS "logindex" (
  "md5" varchar(32) collate latin1_general_ci NOT NULL,
  "toolname" varchar(255) collate latin1_general_ci NOT NULL,
  "logoffset" int(11) default NULL,
  "logout" longtext collate latin1_general_ci,
  PRIMARY KEY  ("md5","toolname"),
  KEY "analysetoollogindex" ("toolname")
);

-- 
-- Daten für Tabelle `logindex`
-- 

INSERT INTO `logindex` (`md5`, `toolname`, `logoffset`, `logout`) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 1, NULL),
('2651dbe60819160e42294dec9dbaed45', 'file', 1, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 210, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'file', 32, NULL),
('f96911025037311c28974e1815f7bb5e', 'exif', 400, NULL),
('f96911025037311c28974e1815f7bb5e', 'file', 66, NULL);

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `logrotate`
-- 

DROP TABLE IF EXISTS `logrotate`;
CREATE TABLE IF NOT EXISTS "logrotate" (
  "loccounter" int(11) NOT NULL,
  "maxexecute" int(11) default NULL,
  "actexecute" int(11) default NULL,
  PRIMARY KEY  ("loccounter")
);

-- 
-- Daten für Tabelle `logrotate`
-- 

INSERT INTO `logrotate` (`loccounter`, `maxexecute`, `actexecute`) VALUES 
(1, 0, 0);

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `namefile`
-- 

DROP TABLE IF EXISTS `namefile`;
CREATE TABLE IF NOT EXISTS "namefile" (
  "id" int(11) NOT NULL,
  "serverame" varchar(255) collate latin1_general_ci default NULL,
  "filepath" varchar(255) collate latin1_general_ci default NULL,
  "filename" varchar(255) collate latin1_general_ci default NULL,
  PRIMARY KEY  ("id"),
  UNIQUE KEY "filekey" ("filepath","filename")
);

-- 
-- Daten für Tabelle `namefile`
-- 

INSERT INTO `namefile` (`id`, `serverame`, `filepath`, `filename`) VALUES 
(1, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\airplane', '4.2.05.tiff'),
(2, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\airplane', '7.1.02.tiff'),
(3, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\ship', 'boat.512.tiff');

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `status`
-- 

DROP TABLE IF EXISTS `status`;
CREATE TABLE IF NOT EXISTS "status" (
  "md5" varchar(32) collate latin1_general_ci NOT NULL,
  "toolname" varchar(255) collate latin1_general_ci NOT NULL,
  "retval" smallint(6) default NULL,
  PRIMARY KEY  ("md5","toolname"),
  KEY "analysetoolstatus" ("toolname")
);

-- 
-- Daten für Tabelle `status`
-- 

INSERT INTO `status` (`md5`, `toolname`, `retval`) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 0),
('2651dbe60819160e42294dec9dbaed45', 'file', 1),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 0),
('2fca7e211c648e7d53e78727764e3bfb', 'file', 0),
('f96911025037311c28974e1815f7bb5e', 'exif', 0),
('f96911025037311c28974e1815f7bb5e', 'file', 3);


-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `sysindex`
-- 

DROP TABLE IF EXISTS `sysindex`;
CREATE TABLE IF NOT EXISTS "sysindex" (
  "md5" varchar(32) collate latin1_general_ci NOT NULL,
  "toolname" varchar(255) collate latin1_general_ci NOT NULL,
  "sysoffset" int(11) default NULL,
  "sysout" longtext collate latin1_general_ci,
  PRIMARY KEY  ("md5","toolname"),
  KEY "analysetoolsysindex" ("toolname")
);

-- 
-- Daten für Tabelle `sysindex`
-- 

INSERT INTO `sysindex` (`md5`, `toolname`, `sysoffset`, `sysout`) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 1, NULL),
('2651dbe60819160e42294dec9dbaed45', 'file', NULL, 'TIFF image data, big-endian'),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 22, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'file', NULL, 'TIFF image data, big-endian'),
('f96911025037311c28974e1815f7bb5e', 'exif', 81, NULL),
('f96911025037311c28974e1815f7bb5e', 'file', NULL, 'TIFF image data, big-endian');

