# Microsoft Developer Studio Project File - Name="modules_mod_lua" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104
# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=mod_lua - Win32 Debug Multilib
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "modules_mod_lua.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "modules_mod_lua.mak" CFG="mod_lua - Win32 Debug Multilib"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mod_lua - Win32 Release Unicode DLL Monolithic" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_lua - Win32 Release Unicode DLL Multilib" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_lua - Win32 Release Unicode Monolithic" (based on "Win32 (x86) Static Library")
!MESSAGE "mod_lua - Win32 Release Unicode Multilib" (based on "Win32 (x86) Static Library")
!MESSAGE "mod_lua - Win32 Release DLL Monolithic" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_lua - Win32 Release DLL Multilib" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_lua - Win32 Release Monolithic" (based on "Win32 (x86) Static Library")
!MESSAGE "mod_lua - Win32 Release Multilib" (based on "Win32 (x86) Static Library")
!MESSAGE "mod_lua - Win32 Debug Unicode DLL Monolithic" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_lua - Win32 Debug Unicode DLL Multilib" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_lua - Win32 Debug Unicode Monolithic" (based on "Win32 (x86) Static Library")
!MESSAGE "mod_lua - Win32 Debug Unicode Multilib" (based on "Win32 (x86) Static Library")
!MESSAGE "mod_lua - Win32 Debug DLL Monolithic" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_lua - Win32 Debug DLL Multilib" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_lua - Win32 Debug Monolithic" (based on "Win32 (x86) Static Library")
!MESSAGE "mod_lua - Win32 Debug Multilib" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "mod_lua - Win32 Release Unicode DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswu_dll\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswu_dll\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d LUA_BUILD_AS_DLL
# ADD RSC /l 0x409 /d LUA_BUILD_AS_DLL
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"
# ADD LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Release Unicode DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswu_dll\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswu_dll\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d LUA_BUILD_AS_DLL
# ADD RSC /l 0x409 /d LUA_BUILD_AS_DLL
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"
# ADD LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Release Unicode Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_lib"
# PROP BASE Intermediate_Dir "vcmswu\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_lib"
# PROP Intermediate_Dir "vcmswu\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"
# ADD LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Release Unicode Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_lib"
# PROP BASE Intermediate_Dir "vcmswu\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_lib"
# PROP Intermediate_Dir "vcmswu\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"
# ADD LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Release DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmsw_dll\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmsw_dll\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d LUA_BUILD_AS_DLL
# ADD RSC /l 0x409 /d LUA_BUILD_AS_DLL
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"
# ADD LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Release DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmsw_dll\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmsw_dll\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d LUA_BUILD_AS_DLL
# ADD RSC /l 0x409 /d LUA_BUILD_AS_DLL
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"
# ADD LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Release Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_lib"
# PROP BASE Intermediate_Dir "vcmsw\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_lib"
# PROP Intermediate_Dir "vcmsw\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"
# ADD LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Release Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_lib"
# PROP BASE Intermediate_Dir "vcmsw\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_lib"
# PROP Intermediate_Dir "vcmsw\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /O2 /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"
# ADD LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Debug Unicode DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswud_dll\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswud_dll\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d LUA_BUILD_AS_DLL
# ADD RSC /l 0x409 /d "_DEBUG" /d LUA_BUILD_AS_DLL
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /debug /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"
# ADD LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /debug /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Debug Unicode DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswud_dll\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswud_dll\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d LUA_BUILD_AS_DLL
# ADD RSC /l 0x409 /d "_DEBUG" /d LUA_BUILD_AS_DLL
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /debug /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"
# ADD LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /debug /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Debug Unicode Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_lib"
# PROP BASE Intermediate_Dir "vcmswud\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_lib"
# PROP Intermediate_Dir "vcmswud\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"
# ADD LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Debug Unicode Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_lib"
# PROP BASE Intermediate_Dir "vcmswud\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_lib"
# PROP Intermediate_Dir "vcmswud\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"
# ADD LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Debug DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswd_dll\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswd_dll\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d LUA_BUILD_AS_DLL
# ADD RSC /l 0x409 /d "_DEBUG" /d LUA_BUILD_AS_DLL
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /debug /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"
# ADD LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /debug /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Debug DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswd_dll\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswd_dll\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_dll\lua5.1.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "_DEBUG" /D "LUA_BUILD_AS_DLL" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d LUA_BUILD_AS_DLL
# ADD RSC /l 0x409 /d "_DEBUG" /d LUA_BUILD_AS_DLL
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /debug /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"
# ADD LINK32 /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\lua5.1.dll" /implib:"..\..\..\lib\vc_dll\lua5.1.lib" /debug /pdb:"..\..\..\lib\vc_dll\lua5.1.pdb"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Debug Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_lib"
# PROP BASE Intermediate_Dir "vcmswd\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_lib"
# PROP Intermediate_Dir "vcmswd\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"
# ADD LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"

!ELSEIF  "$(CFG)" == "mod_lua - Win32 Debug Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_lib"
# PROP BASE Intermediate_Dir "vcmswd\mod_lua"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_lib"
# PROP Intermediate_Dir "vcmswd\mod_lua"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /Od /Gm /Zi /Fd..\..\..\lib\vc_lib\lua5.1.pdb /D "WIN32" /D "_LIB" /D "_DEBUG" /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"
# ADD LIB32 /nologo /out:"..\..\..\lib\vc_lib\lua5.1.lib"

!ENDIF

# Begin Target

# Name "mod_lua - Win32 Release Unicode DLL Monolithic"
# Name "mod_lua - Win32 Release Unicode DLL Multilib"
# Name "mod_lua - Win32 Release Unicode Monolithic"
# Name "mod_lua - Win32 Release Unicode Multilib"
# Name "mod_lua - Win32 Release DLL Monolithic"
# Name "mod_lua - Win32 Release DLL Multilib"
# Name "mod_lua - Win32 Release Monolithic"
# Name "mod_lua - Win32 Release Multilib"
# Name "mod_lua - Win32 Debug Unicode DLL Monolithic"
# Name "mod_lua - Win32 Debug Unicode DLL Multilib"
# Name "mod_lua - Win32 Debug Unicode Monolithic"
# Name "mod_lua - Win32 Debug Unicode Multilib"
# Name "mod_lua - Win32 Debug DLL Monolithic"
# Name "mod_lua - Win32 Debug DLL Multilib"
# Name "mod_lua - Win32 Debug Monolithic"
# Name "mod_lua - Win32 Debug Multilib"
# Begin Group "Source Files"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\lua\src\lapi.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lauxlib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lbaselib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lcode.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\ldblib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\ldebug.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\ldo.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\ldump.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lfunc.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lgc.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\linit.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\liolib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\llex.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lmathlib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lmem.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\loadlib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lobject.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lopcodes.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\loslib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lparser.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lstate.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lstring.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lstrlib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\ltable.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\ltablib.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\ltm.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lundump.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lvm.c
# End Source File
# Begin Source File

SOURCE=..\..\lua\src\lzio.c
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\lua\include\lauxlib.h
# End Source File
# Begin Source File

SOURCE=..\..\lua\include\lua.h
# End Source File
# Begin Source File

SOURCE=..\..\lua\include\luaconf.h
# End Source File
# Begin Source File

SOURCE=..\..\lua\include\lualib.h
# End Source File
# End Group
# End Target
# End Project

