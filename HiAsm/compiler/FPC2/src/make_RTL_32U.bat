@echo off

setlocal

set UNITS_PATH=.\packages\*
set UNITS_PATH=.\objpas;.\objpas\*;.\inc;.\win;%UNITS_PATH%;.\win32

set INC_PATH=.\inc;.\objpas;.\objpas\*;.\win;.\win\wininc;.\i386;.\win32

set OUTPUT_PATH=..\units32u

set FPC_COMMAND=..\ppc386.exe -Twin32 -Mdelphiunicode -FU%OUTPUT_PATH% -Fu%UNITS_PATH% -Fi%INC_PATH%


REM Некоторые модули FPC требуют другого синтаксиса Паскаля и ассемблера
REM (в отличие от установленных для исп. в HiAsm -Mdelphi и -Rintel)

%FPC_COMMAND% win32\system.pp -Ratt -CPPACKSET=0
%FPC_COMMAND% inc\uuchar.pp -Mobjfpc
%FPC_COMMAND% win32\classes.pp -Ratt
%FPC_COMMAND% packages\rtl-extra\winsock.pp
%FPC_COMMAND% packages\winunits-base\comobj.pp
%FPC_COMMAND% packages\winunits-base\shellapi.pp
%FPC_COMMAND% packages\winunits-base\wininet.pp -dFPC_OS_UNICODE

%FPC_COMMAND% win\messages.pp
%FPC_COMMAND% packages\winunits-base\richedit.pp

%FPC_COMMAND% packages\paszlib\paszlib.pas -Mobjfpc

REM Нигде явно не используются, но нужны для компиляции приложения
%FPC_COMMAND% inc\fpintres.pp -Mobjfpc
%FPC_COMMAND% win32\sysinitpas.pp -Mobjfpc



:pause