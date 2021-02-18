@echo off

setlocal

set UNITS_PATH=..\..\..\compiler\FPC2\units32
set FPC_COMMAND="..\..\..\compiler\FPC2\ppc386.exe" -Twin32 -Fu"%UNITS_PATH%" -FU"..\code\units32" -WR

echo "Make element drawing DLL's for Delphi package"

%FPC_COMMAND% GProgressBar.dpr
%FPC_COMMAND% Grapher.dpr
%FPC_COMMAND% ImgBtn.dpr
%FPC_COMMAND% LayoutSpacer.dpr
%FPC_COMMAND% LED.dpr
%FPC_COMMAND% LedLadder.dpr
%FPC_COMMAND% LedNumber.dpr
%FPC_COMMAND% VisualShape.dpr

pause