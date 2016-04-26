
-- mySQL  Settings
-- USE tap;

-- SQLITE System Settings
-- .header on
-- .mode column

-- Foreign key constraints are disabled by default
-- Use the foreign_keys pragma to turn them on

-- Tabellenstruktur für Tabelle analysetool ------------------------------------
INSERT INTO analysetool (toolname, prgfile, prgparam, tmplog, logfile, sysfile) VALUES 
('exif', 'C:\\Tools\\exiftool10.1\\exiftool(-k).exe', '%file%', '', '', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\exif_sys'),
('file', 'c:\\Tools\\PCUnixUtils\\GnuWin32\\bin\\file.exe', '-b -i %file%', '..\\log\\file.log', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\file_log', '');

-- Tabellenstruktur für Tabelle logrotate --------------------------------------
INSERT INTO logrotate (logcounter) VALUES (0);

-- Tabellenstruktur für Tabelle namefile ---------------------------------------
INSERT INTO namefile (id, serverame, filepath, filename) VALUES 
(1, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\airplane', '4.2.05.tiff'),
(2, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\airplane', '7.1.02.tiff'),
(3, 'BAR-Archiv', 'Q:\\KOST\\workbench\\tmp_TIFF-Analyse\\testSET\\ship', 'boat.512.tiff');

-- Tabellenstruktur für Tabelle keyfile ----------------------------------------
INSERT INTO keyfile (id, md5, creationtime, filesize, pdate, loccounter, mimetype) VALUES
(1, '2651dbe60819160e42294dec9dbaed45', '1997-09-26 00:00:00', 786572, NULL, 1, 'TIFF image data, big-endian'),
(2, '2fca7e211c648e7d53e78727764e3bfb', '1997-09-26 00:00:00', 262278, NULL, 1, 'TIFF image data, big-endian'),
(3, 'f96911025037311c28974e1815f7bb5e', '1997-09-26 00:00:00', 262278, NULL, 1, 'TIFF image data, big-endian');

-- Tabellenstruktur für Tabelle status -----------------------------------------
INSERT INTO status (md5, toolname, retval) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 0),
('2651dbe60819160e42294dec9dbaed45', 'file', 1),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 0),
('2fca7e211c648e7d53e78727764e3bfb', 'file', 0),
('f96911025037311c28974e1815f7bb5e', 'exif', 0),
('f96911025037311c28974e1815f7bb5e', 'file', 3);

-- Tabellenstruktur für Tabelle logindex ---------------------------------------
INSERT INTO logindex (md5, toolname, logoffset, logout) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 1, NULL),
('2651dbe60819160e42294dec9dbaed45', 'file', 1, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 210, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'file', 32, NULL),
('f96911025037311c28974e1815f7bb5e', 'exif', 400, NULL),
('f96911025037311c28974e1815f7bb5e', 'file', 66, NULL);

-- Tabellenstruktur für Tabelle sysindex ---------------------------------------
INSERT INTO sysindex (md5, toolname, sysoffset, sysout) VALUES 
('2651dbe60819160e42294dec9dbaed45', 'exif', 1, NULL),
('2651dbe60819160e42294dec9dbaed45', 'file', NULL, 'TIFF image data, big-endian'),
('2fca7e211c648e7d53e78727764e3bfb', 'exif', 22, NULL),
('2fca7e211c648e7d53e78727764e3bfb', 'file', NULL, 'TIFF image data, big-endian'),
('f96911025037311c28974e1815f7bb5e', 'exif', 81, NULL),
('f96911025037311c28974e1815f7bb5e', 'file', NULL, 'TIFF image data, big-endian');

