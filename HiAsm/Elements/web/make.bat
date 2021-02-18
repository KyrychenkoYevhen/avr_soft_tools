@echo off
echo "make codegen dll for WEB packed"
copy ..\FTCG\CodeGen.dpr CodeGen.dpr
copy ..\FTCG\errors.pas errors.pas
..\..\compiler\delphi\dcc32.exe -U..\..\compiler\delphi CodeGen.dpr
pause