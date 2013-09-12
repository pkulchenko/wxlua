@echo off

REM -------------------------------------------------------------------
REM This is a build file to automatically generate the distribution
REM zip files using MSVC 2008 32-bit.
REM It builds wxWidgets 2.8 unicode and ansi and Lua 5.1 and 5.2.
REM
REM USAGE: create-msvc2008-distrib.bat c:\path\to\wxWidgets-2.8 
REM -------------------------------------------------------------------

setlocal enabledelayedexpansion

set wxWidgets_ROOT_DIR=%1

IF "%VCINSTALLDIR%"=="" call "c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat"

call:MakeDist build-wx28-lua51  wxLua-2.8.12.3-Lua-5.1.5-MSW-Ansi    msw  2.8 %wxWidgets_ROOT_DIR% 5.1
call:MakeDist build-wx28-lua52  wxLua-2.8.12.3-Lua-5.2.2-MSW-Ansi    msw  2.8 %wxWidgets_ROOT_DIR% 5.2
call:MakeDist build-wx28u-lua51 wxLua-2.8.12.3-Lua-5.1.5-MSW-Unicode mswu 2.8 %wxWidgets_ROOT_DIR% 5.1
call:MakeDist build-wx28u-lua52 wxLua-2.8.12.3-Lua-5.2.2-MSW-Unicode mswu 2.8 %wxWidgets_ROOT_DIR% 5.2

goto:eof

REM -------------------------------------------------------------------------
REM Function to call cmake to generate the appropriate files

:MakeDist

    SET BUILD_DIR=%~1
    SET DIST_NAME=%~2
    SET wxWidgets_CONFIGURATION=%~3
    SET wxWidgets_VERSION=%~4
    SET wxWidgets_ROOT_DIR=%~5
    SET wxLua_LUA_LIBRARY_VERSION=%~6

    mkdir %BUILD_DIR%
    pushd %BUILD_DIR%
    cmake -DwxLua_LUA_LIBRARY_VERSION=%wxLua_LUA_LIBRARY_VERSION% -DwxWidgets_CONFIGURATION=%wxWidgets_CONFIGURATION% -DwxWidgets_VERSION=%wxWidgets_VERSION% -DwxWidgets_ROOT_DIR=%wxWidgets_ROOT_DIR% -DCMAKE_INSTALL_PREFIX=%CD%\install -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=FALSE ..\..\
    cmake -DwxLua_LUA_LIBRARY_VERSION=%wxLua_LUA_LIBRARY_VERSION% -DwxWidgets_CONFIGURATION=%wxWidgets_CONFIGURATION% -DwxWidgets_VERSION=%wxWidgets_VERSION% -DwxWidgets_ROOT_DIR=%wxWidgets_ROOT_DIR% -DCMAKE_INSTALL_PREFIX=%CD%\install -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=FALSE ..\..\
    popd

    REM EXIT /B

    devenv %BUILD_DIR%\wxLua.sln  /Build "MinSizeRel|Win32"

    REM Remove any old junk that may be in the install dir
    rmdir /S /Q %BUILD_DIR%\install

    devenv %BUILD_DIR%\wxLua.sln  /Build "MinSizeRel|Win32" /project INSTALL

    REM These aren't intersting for the binary users
    rmdir /S /Q %BUILD_DIR%\install\include
    rmdir /S /Q %BUILD_DIR%\install\lib
    rmdir /S /Q %BUILD_DIR%\install\share

    pushd %BUILD_DIR%
    rmdir /S /Q %DIST_NAME%
    del   /S /Q %DIST_NAME%.zip
    rename install %DIST_NAME%
    c:\cygwin\bin\zip -r %DIST_NAME%.zip %DIST_NAME%
    popd

    pushd %BUILD_DIR%\%DIST_NAME%\bin
        wxLuaEdit.exe
        lua.exe      ..\..\..\..\samples\controls.wx.lua
        wxLua.exe /c ..\..\..\..\samples\unittest.wx.lua
    popd

goto:eof

endlocal
