
@ECHO OFF
ECHO This builds wxLua using VC6's nmake.exe
ECHO Usage: nmake_wxLua.bat [BUILD_TYPE] [RELEASE_DIR]
ECHO   BUILD_TYPE  = release_lib, debug_lib, release_dll, debug_dll, clean, skip
ECHO   RELEASE_DIR = directory name to create and copy the appropriate files
ECHO                 into for creating a release.
ECHO You can only build one at a time since the EXEs replace each other,
ECHO   be sure to run "nmake_wxLua.bat clean" between builds.
ECHO To create a release, first run with the desired build, verify success,
ECHO   then run again with "skip RELEASE_DIR" to have the files copied.
ECHO.
PAUSE

REM -------------------------------------------------------------------------

@ECHO ON
REM CALL "C:\Program Files\Microsoft Visual Studio\VC98\Bin\VCVARS32.BAT"
rem CALL "C:\Program Files\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86
@ECHO OFF

ECHO.
REM -------------------------------------------------------------------------

IF %1 == clean (
  ECHO "== CLEAN ============================================================="
  nmake -f makefile.vc BUILD=release SHARED=0 WX_SHARED=0 USE_WXBINDRICHTEXT=1 USE_WXLUAEDITAPP=1 clean
  nmake -f makefile.vc BUILD=debug   SHARED=0 WX_SHARED=0 USE_WXBINDRICHTEXT=1 USE_WXLUAEDITAPP=1 clean
  nmake -f makefile.vc BUILD=release SHARED=1 WX_SHARED=1 USE_WXBINDRICHTEXT=1 USE_WXLUAEDITAPP=1 MONOLITHIC=1 WX_MONOLITHIC=1 MONOLITHIC_LUAMODULE=1 clean
  nmake -f makefile.vc BUILD=debug   SHARED=1 WX_SHARED=1 USE_WXBINDRICHTEXT=1 USE_WXLUAEDITAPP=1 MONOLITHIC=1 WX_MONOLITHIC=1 MONOLITHIC_LUAMODULE=1 clean
) ELSE IF %1 == release_lib (
  ECHO "== RELEASE LIB ======================================================="
  nmake -f makefile.vc BUILD=release UNICODE=0 SHARED=0 WX_SHARED=0 USE_WXBINDRICHTEXT=1 USE_WXLUAEDITAPP=1 
) ELSE IF %1 == debug_lib (
  ECHO "== DEBUG LIB ========================================================="
  nmake -f makefile.vc BUILD=debug SHARED=0 WX_SHARED=0 USE_WXBINDRICHTEXT=1 USE_WXLUAEDITAPP=1 
) ELSE IF %1 == release_dll (
  ECHO "== RELEASE DLL ======================================================="
  nmake -f makefile.vc BUILD=release SHARED=1 WX_SHARED=1 USE_WXBINDRICHTEXT=1 USE_WXLUAEDITAPP=1 MONOLITHIC=1 WX_MONOLITHIC=1 MONOLITHIC_LUAMODULE=1
) ELSE IF %1 == debug_dll (
  ECHO "== DEBUG DLL ========================================================="
  nmake -f makefile.vc BUILD=debug SHARED=1 WX_SHARED=1 USE_WXBINDRICHTEXT=1 USE_WXLUAEDITAPP=1 MONOLITHIC=1 WX_MONOLITHIC=1 MONOLITHIC_LUAMODULE=1 
) ELSE IF %1 == skip (
  ECHO SKIPPING BUILD
) ELSE (
  ECHO UNKNOWN OPTION - NOTHING DONE.
)

ECHO.
REM -------------------------------------------------------------------------

IF [%2] == [] (
  ECHO NOT CREATING RELEASE_DIR
) ELSE (
  ECHO "== CREATING RELEASE INTO DIRECTORY %2"
  mkdir %2
  mkdir %2\bin
  mkdir %2\docs
  mkdir %2\samples
  mkdir %2\samples\image
  mkdir %2\apps
  mkdir %2\apps\wxluafreeze
  mkdir %2\apps\wxluacan

  REM Set this for 64 bit build, unset it for 32 bit
  echo %LIB% | find "dll"

  if %errorlevel% equ 1 (
    copy /Y ..\..\bin\vc_lib\*.exe %2\bin
  ) else (
    copy /Y ..\..\bin\vc_dll\*.exe %2\bin
    copy /Y ..\..\lib\vc_dll\*.dll %2\bin
  )
 
  copy /Y ..\..\docs\*.* %2\docs
  
  copy /Y ..\..\samples\*.*       %2\samples
  copy /Y ..\..\samples\image\*.* %2\samples\image

  copy /Y ..\..\apps\wxluafreeze\src\readme.txt      %2\apps\wxluafreeze
  copy /Y ..\..\apps\wxluafreeze\src\wxluafreeze.lua %2\apps\wxluafreeze
  copy /Y ..\..\apps\wxluacan\scripts\incircles.lua  %2\apps\wxluacan
  
  ECHO.
  ECHO If creating a DLL release, don't forget to copy the wxWidgets DLLS
  ECHO and the wxStEdit DLL.
)
