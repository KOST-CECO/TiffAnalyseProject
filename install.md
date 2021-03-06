﻿# -------------------------------------------------------------
# Anleitung zu GIT 
# -------------------------------------------------------------
# GIT: Settings für Kommandozeile
git config -l
git config user.name mkaiser56
git config user.email m.kaiser@access.ch
git config core.editor notepad
git config http.proxy proxy.edi.admin.ch:8080

git config --global user.name mkaiser56
git config --global user.email m.kaiser@access.ch
git config --global core.editor nedit
git config --global diff.tool tkdiff
git config --global merge.tool tkdiff
git config --global --add difftool.prompt false

# git config --global push.default matching
git config --global push.default simple

SET TERM=xterm

# Neues Arbeitsverzeichnis anlegen
git clone https://github.com/KOST-CECO/TiffAnalyseProject.git TiffAnalyseProject
cd TiffAnalyseProject

# Repository überprüfen
gitk
git status
git add
git commit -a
git push

# file .gitignore
Thumbs.db
*.lnk
*.exe

# Revisions Tags setzen
git tag v1.4
git tag
git show v1.4
git push origin --tags

# -------------------------------------------------------------
# LINUX Tools installieren (in dieser Reihenfolge)
# -------------------------------------------------------------
# sqlite3 
sudo apt-get install sqlite3
sudo apt-get install libsqlite3-dev

# GCC 
sudo apt-get install gcc (gcc is already the newest version)
sudo apt-get install gcc-4.8 (unable to locate package)

# go-sqlite3 
https://github.com/mattn/go-sqlite3/blob/master/README.md 
cd $GOPATH/src
go get github.com/mattn/go-sqlite3
go install github.com/mattn/go-sqlite3

# Tools Installieren
sudo apt-get install jhove
sudo apt-get install exif
sudo apt-get install libimage-exiftool-perl
sudo apt-get install exiv2

# checkit_tiff kompilieren
sudo apt-get install cmake
sudo apt-get install g++
sudo apt-get install libtiff4-dev
sudo apt-get install libpcre3 libpcre3-dev
sudo apt-get update
mkdir build
cd build
cmake ../src/
make

