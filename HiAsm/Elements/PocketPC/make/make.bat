@echo off
echo "make project maker dll for PocketPC packed"
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi\ make_exe.dpr
..\..\..\compiler\delphi\dcc32.exe -U..\..\..\compiler\delphi\ make_service.dpr

pause