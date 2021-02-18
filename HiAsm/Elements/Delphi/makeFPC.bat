@echo off

setlocal

set UNITS_PATH=..\..\compiler\FPC2\units32a
set FPC_COMMAND="..\..\compiler\FPC2\ppc386.exe" -Twin32 -Fu"%UNITS_PATH%" -FU"code\units32a" -WR

echo Compiling Codegen.dll for Delphi package

%FPC_COMMAND% CodeGen.dpr

REM copy ..\FTCG\CodeGen.dpr FTCG_CodeGen.dpr
REM copy ..\FTCG\errors.pas errors.pas
%FPC_COMMAND% FTCG_CodeGen.dpr


pause