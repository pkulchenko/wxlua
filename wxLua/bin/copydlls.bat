@echo off
REM This little batch file can be used to copy 
REM the DLL in this folder, so that EXEs compiled
REM against shared builds of wxLua can find them.
REM Fix the directory name if you're using a different
REM compiler (e.g. vc_dll -> bcc_dll)

if "%1%" NEQ "" goto okay
goto usage

:okay
echo Copying all DLLs from ..\lib\%1%_dll directory
copy /Y ..\lib\%1%_dll\*.dll .
goto end

:usage
echo Call this script with the name of the compiler you used 
echo to build the DLLs (vc,bcc,mingw)...
goto end

:end
