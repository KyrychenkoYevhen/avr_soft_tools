@echo off

setlocal

set UNITS_PATH=..\..\..\compiler\FPC2\units32a
set FPC_COMMAND="..\..\..\compiler\FPC2\ppc386.exe" -Twin32 -Fu"%UNITS_PATH%" -FU"..\code\units32a" -WR

echo Compiling project maker DLL's for Delphi package

%FPC_COMMAND% make_exe.dpr
%FPC_COMMAND% make_com.dpr
%FPC_COMMAND% make_console.dpr
%FPC_COMMAND% make_cpl.dpr
%FPC_COMMAND% make_dll.dpr
%FPC_COMMAND% make_hiasm.dpr
%FPC_COMMAND% make_service.dpr
%FPC_COMMAND% make_ntsvc.dpr

pause