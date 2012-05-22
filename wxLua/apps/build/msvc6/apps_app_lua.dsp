# Microsoft Developer Studio Project File - Name="apps_app_lua" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=app_lua - Win32 Debug Multilib
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "apps_app_lua.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "apps_app_lua.mak" CFG="app_lua - Win32 Debug Multilib"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "app_lua - Win32 Release Unicode DLL Monolithic" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Release Unicode DLL Multilib" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Release Unicode Monolithic" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Release Unicode Multilib" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Release DLL Monolithic" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Release DLL Multilib" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Release Monolithic" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Release Multilib" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Debug Unicode DLL Monolithic" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Debug Unicode DLL Multilib" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Debug Unicode Monolithic" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Debug Unicode Multilib" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Debug DLL Monolithic" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Debug DLL Multilib" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Debug Monolithic" (based on "Win32 (x86) Console Application")
!MESSAGE "app_lua - Win32 Debug Multilib" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "app_lua - Win32 Release Unicode DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\bin\vc_dll"
# PROP BASE Intermediate_Dir "vcmswu_dll\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\bin\vc_dll"
# PROP Intermediate_Dir "vcmswu_dll\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_dll\lua.pdb"
# ADD LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_dll\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Release Unicode DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\bin\vc_dll"
# PROP BASE Intermediate_Dir "vcmswu_dll\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\bin\vc_dll"
# PROP Intermediate_Dir "vcmswu_dll\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_dll\lua.pdb"
# ADD LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_dll\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Release Unicode Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\bin\vc_lib"
# PROP BASE Intermediate_Dir "vcmswu\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\bin\vc_lib"
# PROP Intermediate_Dir "vcmswu\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "_UNICODE" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "_UNICODE" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD BASE RSC /l 0x409 /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
# ADD RSC /l 0x409 /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_lib\lua.pdb"
# ADD LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_lib\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Release Unicode Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\bin\vc_lib"
# PROP BASE Intermediate_Dir "vcmswu\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\bin\vc_lib"
# PROP Intermediate_Dir "vcmswu\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "_UNICODE" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "_UNICODE" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD BASE RSC /l 0x409 /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
# ADD RSC /l 0x409 /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_lib\lua.pdb"
# ADD LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_lib\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Release DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\bin\vc_dll"
# PROP BASE Intermediate_Dir "vcmsw_dll\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\bin\vc_dll"
# PROP Intermediate_Dir "vcmsw_dll\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_dll\lua.pdb"
# ADD LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_dll\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Release DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\bin\vc_dll"
# PROP BASE Intermediate_Dir "vcmsw_dll\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\bin\vc_dll"
# PROP Intermediate_Dir "vcmsw_dll\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_dll\lua.pdb"
# ADD LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_dll\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Release Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\bin\vc_lib"
# PROP BASE Intermediate_Dir "vcmsw\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\bin\vc_lib"
# PROP Intermediate_Dir "vcmsw\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD BASE RSC /l 0x409 /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
# ADD RSC /l 0x409 /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_lib\lua.pdb"
# ADD LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_lib\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Release Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\bin\vc_lib"
# PROP BASE Intermediate_Dir "vcmsw\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\bin\vc_lib"
# PROP Intermediate_Dir "vcmsw\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "__WXMSW__" /D "_CONSOLE" /c
# ADD BASE RSC /l 0x409 /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
# ADD RSC /l 0x409 /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d _CONSOLE
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_lib\lua.pdb"
# ADD LINK32 wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /pdb:"..\..\..\bin\vc_lib\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Debug Unicode DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\bin\vc_dll"
# PROP BASE Intermediate_Dir "vcmswud_dll\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\bin\vc_dll"
# PROP Intermediate_Dir "vcmswud_dll\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_dll\lua.pdb"
# ADD LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_dll\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Debug Unicode DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\bin\vc_dll"
# PROP BASE Intermediate_Dir "vcmswud_dll\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\bin\vc_dll"
# PROP Intermediate_Dir "vcmswud_dll\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_dll\lua.pdb"
# ADD LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_dll\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Debug Unicode Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\bin\vc_lib"
# PROP BASE Intermediate_Dir "vcmswud\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\bin\vc_lib"
# PROP Intermediate_Dir "vcmswud\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409 /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
# ADD RSC /l 0x409 /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_lib\lua.pdb"
# ADD LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_lib\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Debug Unicode Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\bin\vc_lib"
# PROP BASE Intermediate_Dir "vcmswud\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\bin\vc_lib"
# PROP Intermediate_Dir "vcmswud\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409 /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
# ADD RSC /l 0x409 /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_lib\lua.pdb"
# ADD LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_lib\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Debug DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\bin\vc_dll"
# PROP BASE Intermediate_Dir "vcmswd_dll\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\bin\vc_dll"
# PROP Intermediate_Dir "vcmswd_dll\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_dll\lua.pdb"
# ADD LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_dll\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Debug DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\bin\vc_dll"
# PROP BASE Intermediate_Dir "vcmswd_dll\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\bin\vc_dll"
# PROP Intermediate_Dir "vcmswd_dll\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_dll\lua.pdb /D "WIN32" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_dll\lua.pdb"
# ADD LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_dll\lua.exe" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_dll\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Debug Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\bin\vc_lib"
# PROP BASE Intermediate_Dir "vcmswd\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\bin\vc_lib"
# PROP Intermediate_Dir "vcmswd\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409 /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
# ADD RSC /l 0x409 /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_lib\lua.pdb"
# ADD LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_lib\lua.pdb"

!ELSEIF  "$(CFG)" == "app_lua - Win32 Debug Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\bin\vc_lib"
# PROP BASE Intermediate_Dir "vcmswd\app_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\bin\vc_lib"
# PROP Intermediate_Dir "vcmswd\app_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_lib\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /Zi /Fd..\..\..\bin\vc_lib\lua.pdb /D "WIN32" /D "__WXDEBUG__" /D "__WXMSW__" /D "_CONSOLE" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409 /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
# ADD RSC /l 0x409 /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_lib\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /d "_CONSOLE" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_lib\lua.pdb"
# ADD LINK32 wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib lua5.1.lib /nologo /machine:i386 /out:"..\..\..\bin\vc_lib\lua.exe" /libpath:"$(WXWIN)\lib\vc_lib" /libpath:"..\..\..\lib\vc_lib" /libpath:"..\..\..\modules\lua\lib" /subsystem:console /debug /pdb:"..\..\..\bin\vc_lib\lua.pdb"

!ENDIF

# Begin Target

# Name "app_lua - Win32 Release Unicode DLL Monolithic"
# Name "app_lua - Win32 Release Unicode DLL Multilib"
# Name "app_lua - Win32 Release Unicode Monolithic"
# Name "app_lua - Win32 Release Unicode Multilib"
# Name "app_lua - Win32 Release DLL Monolithic"
# Name "app_lua - Win32 Release DLL Multilib"
# Name "app_lua - Win32 Release Monolithic"
# Name "app_lua - Win32 Release Multilib"
# Name "app_lua - Win32 Debug Unicode DLL Monolithic"
# Name "app_lua - Win32 Debug Unicode DLL Multilib"
# Name "app_lua - Win32 Debug Unicode Monolithic"
# Name "app_lua - Win32 Debug Unicode Multilib"
# Name "app_lua - Win32 Debug DLL Monolithic"
# Name "app_lua - Win32 Debug DLL Multilib"
# Name "app_lua - Win32 Debug Monolithic"
# Name "app_lua - Win32 Debug Multilib"
# Begin Group "Source Files"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\modules\lua\src\lua.c
# End Source File
# End Group
# End Target
# End Project

