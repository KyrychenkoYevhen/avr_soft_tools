@echo off

setlocal

set OUTPUT_PATH=..\units64u
set FPC_COMMAND=..\ppcrossx64.exe -Twin64 -Mdelphiunicode -FU%OUTPUT_PATH%


%FPC_COMMAND% packages\KOL\kol.pas
%FPC_COMMAND% packages\KOL\KOLadd.pas
%FPC_COMMAND% packages\KOL\KOLGRushControls3.pas
%FPC_COMMAND% packages\KOL\Mmx.pas
%FPC_COMMAND% packages\other\MMSystem.pas
REM pasjpeg подправлена для использования KOL, поэтому компилируется после
%FPC_COMMAND% packages\pasjpeg\buildpasjpeg.pp
%FPC_COMMAND% packages\KOL\JpegObjFPC.pas

:pause