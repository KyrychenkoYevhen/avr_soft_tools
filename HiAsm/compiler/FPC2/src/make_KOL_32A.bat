@echo off

setlocal

set OUTPUT_PATH=..\units32a
set FPC_COMMAND=..\ppc386.exe -Twin32 -FU%OUTPUT_PATH%


%FPC_COMMAND% packages\KOL\kol.pas
%FPC_COMMAND% packages\KOL\KOLadd.pas
%FPC_COMMAND% packages\KOL\KOLGRushControls3.pas
%FPC_COMMAND% packages\KOL\Mmx.pas
%FPC_COMMAND% packages\other\MMSystem.pas
REM pasjpeg ����������� ��� ������������� KOL, ������� ������������� �����
%FPC_COMMAND% packages\pasjpeg\buildpasjpeg.pp
%FPC_COMMAND% packages\KOL\JpegObjFPC.pas

:pause