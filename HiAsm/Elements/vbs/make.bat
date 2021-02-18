@echo off
echo "make codegen dll for vbs pack"
copy ..\FTCG\CodeGen.dpr CodeGen.dpr
..\..\plug\patch.exe < codegen.dpr.diff
copy ..\FTCG\errors.pas errors.pas
..\..\compiler\delphi\dcc32.exe -U..\..\compiler\delphi CodeGen.dpr
pause