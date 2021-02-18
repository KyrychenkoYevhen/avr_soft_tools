@echo off

setlocal

set UNITS_PATH=.\packages\*
set UNITS_PATH=.\objpas;.\objpas\*;.\inc;.\win;%UNITS_PATH%;.\win64

set INC_PATH=.\inc;.\objpas;.\objpas\*;.\win;.\win\wininc;.\x86_64;.\win64

set OUTPUT_PATH=..\units64a

set FPC_COMMAND=..\ppcrossx64.exe -Twin64 -FU%OUTPUT_PATH% -Fu%UNITS_PATH% -Fi%INC_PATH%


REM Некоторые модули FPC требуют другого синтаксиса Паскаля и ассемблера
REM (в отличие от установленных для исп. в HiAsm -Mdelphi и -Rintel)

%FPC_COMMAND% win64\system.pp -Ratt -CPPACKSET=0
%FPC_COMMAND% packages\rtl-extra\winsock.pp -Mobjfpc
%FPC_COMMAND% packages\winunits-base\comobj.pp -Mobjfpc
%FPC_COMMAND% packages\winunits-base\shellapi.pp
%FPC_COMMAND% packages\winunits-base\wininet.pp

%FPC_COMMAND% win\messages.pp
%FPC_COMMAND% packages\winunits-base\richedit.pp

%FPC_COMMAND% packages\paszlib\paszlib.pas -Mobjfpc

REM Нигде явно не используются, но нужны для компиляции приложения
%FPC_COMMAND% inc\fpintres.pp -Mobjfpc
%FPC_COMMAND% win64\sysinit.pp -Mobjfpc

:pause