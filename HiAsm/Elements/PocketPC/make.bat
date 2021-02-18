@echo off
echo "make codegen dll for PocketPC packed"
..\..\compiler\delphi\dcc32.exe -U..\..\compiler\delphi CodeGen.dpr
pause