@echo off
echo "make dump Elements.sql from Elements.db"
..\..\plug\sqlite3.exe Elements.db .dump > Elements.sql