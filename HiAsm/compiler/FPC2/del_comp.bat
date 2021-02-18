@echo off
:echo FPCx32 and FPCx64 compilers will be deleted from 'hiasm.db'.
:echo Press any key to continue.
:pause
@echo on
..\..\Plug\sqlite3.exe ..\..\Int\hiasm.db <del_comp.sql