@echo off
echo Make codegen.dll for Delphi pack"
..\..\compiler\delphi\dcc32.exe -U..\..\compiler\delphi CodeGen.dpr
:copy ..\FTCG\CodeGen.dpr FTCG_CodeGen.dpr
:copy ..\FTCG\errors.pas errors.pas
..\..\compiler\delphi\dcc32.exe -U..\..\compiler\delphi FTCG_CodeGen.dpr
pause