# Microsoft Developer Studio Project File - Name="modules_mod_luamodule_mono" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=mod_luamodule_mono - Win32 Debug DLL Multilib
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "modules_mod_luamodule_mono.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "modules_mod_luamodule_mono.mak" CFG="mod_luamodule_mono - Win32 Debug DLL Multilib"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mod_luamodule_mono - Win32 Release Unicode DLL Monolithic" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_luamodule_mono - Win32 Release Unicode DLL Multilib" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_luamodule_mono - Win32 Release DLL Monolithic" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_luamodule_mono - Win32 Release DLL Multilib" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_luamodule_mono - Win32 Debug Unicode DLL Monolithic" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_luamodule_mono - Win32 Debug Unicode DLL Multilib" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_luamodule_mono - Win32 Debug DLL Monolithic" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_luamodule_mono - Win32 Debug DLL Multilib" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "mod_luamodule_mono - Win32 Release Unicode DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswu_dll\mod_luamodule_mono"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswu_dll\mod_luamodule_mono"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswu_dll\wxprec_mod_luamodule_mono.pch" /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswu_dll\wxprec_mod_luamodule_mono.pch" /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d WXMAKINGDLL_WXLUA
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d WXMAKINGDLL_WXLUA
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 lua5.1.lib wxmsw28u_stc.lib wxmsw28u.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /pdb:"..\..\..\lib\vc_dll\wx.pdb"
# ADD LINK32 lua5.1.lib wxmsw28u_stc.lib wxmsw28u.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /pdb:"..\..\..\lib\vc_dll\wx.pdb"

!ELSEIF  "$(CFG)" == "mod_luamodule_mono - Win32 Release Unicode DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswu_dll\mod_luamodule_mono"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswu_dll\mod_luamodule_mono"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswu_dll\wxprec_mod_luamodule_mono.pch" /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswu" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswu_dll\wxprec_mod_luamodule_mono.pch" /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d WXMAKINGDLL_WXLUA
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswu" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d WXMAKINGDLL_WXLUA
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 lua5.1.lib wxmsw28u_stc.lib wxmsw28u_xrc.lib wxmsw28u_html.lib wxmsw28u_gl.lib wxmsw28u_aui.lib wxmsw28u_media.lib wxmsw28u_adv.lib wxbase28u_net.lib wxbase28u_xml.lib wxmsw28u_core.lib wxbase28u.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /pdb:"..\..\..\lib\vc_dll\wx.pdb"
# ADD LINK32 lua5.1.lib wxmsw28u_stc.lib wxmsw28u_xrc.lib wxmsw28u_html.lib wxmsw28u_gl.lib wxmsw28u_aui.lib wxmsw28u_media.lib wxmsw28u_adv.lib wxbase28u_net.lib wxbase28u_xml.lib wxmsw28u_core.lib wxbase28u.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregexu.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /pdb:"..\..\..\lib\vc_dll\wx.pdb"

!ELSEIF  "$(CFG)" == "mod_luamodule_mono - Win32 Release DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmsw_dll\mod_luamodule_mono"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmsw_dll\mod_luamodule_mono"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmsw_dll\wxprec_mod_luamodule_mono.pch" /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmsw_dll\wxprec_mod_luamodule_mono.pch" /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d WXMAKINGDLL_WXLUA
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d WXMAKINGDLL_WXLUA
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 lua5.1.lib wxmsw28_stc.lib wxmsw28.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /pdb:"..\..\..\lib\vc_dll\wx.pdb"
# ADD LINK32 lua5.1.lib wxmsw28_stc.lib wxmsw28.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /pdb:"..\..\..\lib\vc_dll\wx.pdb"

!ELSEIF  "$(CFG)" == "mod_luamodule_mono - Win32 Release DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmsw_dll\mod_luamodule_mono"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmsw_dll\mod_luamodule_mono"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmsw_dll\wxprec_mod_luamodule_mono.pch" /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /c
# ADD CPP /nologo /FD /MD /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\msw" /I "$(WXWIN)\include" /O2 /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmsw_dll\wxprec_mod_luamodule_mono.pch" /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d WXMAKINGDLL_WXLUA
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\msw" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d WXMAKINGDLL_WXLUA
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 lua5.1.lib wxmsw28_stc.lib wxmsw28_xrc.lib wxmsw28_html.lib wxmsw28_gl.lib wxmsw28_aui.lib wxmsw28_media.lib wxmsw28_adv.lib wxbase28_net.lib wxbase28_xml.lib wxmsw28_core.lib wxbase28.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /pdb:"..\..\..\lib\vc_dll\wx.pdb"
# ADD LINK32 lua5.1.lib wxmsw28_stc.lib wxmsw28_xrc.lib wxmsw28_html.lib wxmsw28_gl.lib wxmsw28_aui.lib wxmsw28_media.lib wxmsw28_adv.lib wxbase28_net.lib wxbase28_xml.lib wxmsw28_core.lib wxbase28.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /pdb:"..\..\..\lib\vc_dll\wx.pdb"

!ELSEIF  "$(CFG)" == "mod_luamodule_mono - Win32 Debug Unicode DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswud_dll\mod_luamodule_mono"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswud_dll\mod_luamodule_mono"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswud_dll\wxprec_mod_luamodule_mono.pch" /Zi /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswud_dll\wxprec_mod_luamodule_mono.pch" /Zi /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d "WXMAKINGDLL_WXLUA" /d _DEBUG
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d "WXMAKINGDLL_WXLUA" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 lua5.1.lib wxmsw28ud_stc.lib wxmsw28ud.lib wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /debug /pdb:"..\..\..\lib\vc_dll\wx.pdb"
# ADD LINK32 lua5.1.lib wxmsw28ud_stc.lib wxmsw28ud.lib wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /debug /pdb:"..\..\..\lib\vc_dll\wx.pdb"

!ELSEIF  "$(CFG)" == "mod_luamodule_mono - Win32 Debug Unicode DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswud_dll\mod_luamodule_mono"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswud_dll\mod_luamodule_mono"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswud_dll\wxprec_mod_luamodule_mono.pch" /Zi /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswud" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswud_dll\wxprec_mod_luamodule_mono.pch" /Zi /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "_UNICODE" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d "WXMAKINGDLL_WXLUA" /d _DEBUG
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "_UNICODE" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswud" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d "WXMAKINGDLL_WXLUA" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 lua5.1.lib wxmsw28ud_stc.lib wxmsw28ud_xrc.lib wxmsw28ud_html.lib wxmsw28ud_gl.lib wxmsw28ud_aui.lib wxmsw28ud_media.lib wxmsw28ud_adv.lib wxbase28ud_net.lib wxbase28ud_xml.lib wxmsw28ud_core.lib wxbase28ud.lib wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /debug /pdb:"..\..\..\lib\vc_dll\wx.pdb"
# ADD LINK32 lua5.1.lib wxmsw28ud_stc.lib wxmsw28ud_xrc.lib wxmsw28ud_html.lib wxmsw28ud_gl.lib wxmsw28ud_aui.lib wxmsw28ud_media.lib wxmsw28ud_adv.lib wxbase28ud_net.lib wxbase28ud_xml.lib wxmsw28ud_core.lib wxbase28ud.lib wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexud.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /debug /pdb:"..\..\..\lib\vc_dll\wx.pdb"

!ELSEIF  "$(CFG)" == "mod_luamodule_mono - Win32 Debug DLL Monolithic"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswd_dll\mod_luamodule_mono"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswd_dll\mod_luamodule_mono"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswd_dll\wxprec_mod_luamodule_mono.pch" /Zi /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswd_dll\wxprec_mod_luamodule_mono.pch" /Zi /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d "WXMAKINGDLL_WXLUA" /d _DEBUG
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d "WXMAKINGDLL_WXLUA" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 lua5.1.lib wxmsw28d_stc.lib wxmsw28d.lib wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /debug /pdb:"..\..\..\lib\vc_dll\wx.pdb"
# ADD LINK32 lua5.1.lib wxmsw28d_stc.lib wxmsw28d.lib wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /debug /pdb:"..\..\..\lib\vc_dll\wx.pdb"

!ELSEIF  "$(CFG)" == "mod_luamodule_mono - Win32 Debug DLL Multilib"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "..\..\..\lib\vc_dll"
# PROP BASE Intermediate_Dir "vcmswd_dll\mod_luamodule_mono"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "..\..\..\lib\vc_dll"
# PROP Intermediate_Dir "vcmswd_dll\mod_luamodule_mono"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswd_dll\wxprec_mod_luamodule_mono.pch" /Zi /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /c
# ADD CPP /nologo /FD /MDd /W1 /GR /EHsc /I "$(WXWIN)\lib\vc_dll\mswd" /I "$(WXWIN)\include" /Od /Gm /I "..\..\..\modules" /I ".\..\..\.." /I "..\..\..\modules\lua\include" /I "..\..\..\modules\wxbind\setup" /I "$(WXWIN)\contrib\include" /Yu"wx/wxprec.h" /Fp"vcmswd_dll\wxprec_mod_luamodule_mono.pch" /Zi /Fd..\..\..\lib\vc_dll\wx.pdb /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /c
# ADD BASE MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "WIN32" /D "_USRDLL" /D "DLL_EXPORTS" /D "WXUSINGDLL" /D "__WXDEBUG__" /D "__WXMSW__" /D "WXMAKINGDLL_LUAMODULE" /D "WXMAKINGDLL_WXBINDADV" /D "WXMAKINGDLL_WXBINDAUI" /D "WXMAKINGDLL_WXBINDBASE" /D "WXMAKINGDLL_WXBINDCORE" /D "WXMAKINGDLL_WXBINDGL" /D "WXMAKINGDLL_WXBINDHTML" /D "WXMAKINGDLL_WXBINDMEDIA" /D "WXMAKINGDLL_WXBINDNET" /D "WXMAKINGDLL_WXBINDRICHTEXT" /D "WXMAKINGDLL_WXBINDSTC" /D "WXMAKINGDLL_WXBINDXML" /D "WXMAKINGDLL_WXBINDXRC" /D "WXMAKINGDLL_WXLUADEBUG" /D "WXMAKINGDLL_WXLUASOCKET" /D "WXMAKINGDLL_WXLUA" /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "WXUSINGDLL" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d "WXMAKINGDLL_WXLUA" /d _DEBUG
# ADD RSC /l 0x409 /d "WXUSINGDLL" /d "__WXDEBUG__" /d "__WXMSW__" /i "$(WXWIN)\lib\vc_dll\mswd" /i "$(WXWIN)\include" /i "..\..\..\modules" /i ".\..\..\.." /i "..\..\..\modules\lua\include" /i "..\..\..\modules\wxbind\setup" /i "$(WXWIN)\contrib\include" /d "WXMAKINGDLL_LUAMODULE" /d "WXMAKINGDLL_WXBINDADV" /d "WXMAKINGDLL_WXBINDAUI" /d "WXMAKINGDLL_WXBINDBASE" /d "WXMAKINGDLL_WXBINDCORE" /d "WXMAKINGDLL_WXBINDGL" /d "WXMAKINGDLL_WXBINDHTML" /d "WXMAKINGDLL_WXBINDMEDIA" /d "WXMAKINGDLL_WXBINDNET" /d "WXMAKINGDLL_WXBINDRICHTEXT" /d "WXMAKINGDLL_WXBINDSTC" /d "WXMAKINGDLL_WXBINDXML" /d "WXMAKINGDLL_WXBINDXRC" /d "WXMAKINGDLL_WXLUADEBUG" /d "WXMAKINGDLL_WXLUASOCKET" /d "WXMAKINGDLL_WXLUA" /d _DEBUG
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 lua5.1.lib wxmsw28d_stc.lib wxmsw28d_xrc.lib wxmsw28d_html.lib wxmsw28d_gl.lib wxmsw28d_aui.lib wxmsw28d_media.lib wxmsw28d_adv.lib wxbase28d_net.lib wxbase28d_xml.lib wxmsw28d_core.lib wxbase28d.lib wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /debug /pdb:"..\..\..\lib\vc_dll\wx.pdb"
# ADD LINK32 lua5.1.lib wxmsw28d_stc.lib wxmsw28d_xrc.lib wxmsw28d_html.lib wxmsw28d_gl.lib wxmsw28d_aui.lib wxmsw28d_media.lib wxmsw28d_adv.lib wxbase28d_net.lib wxbase28d_xml.lib wxmsw28d_core.lib wxbase28d.lib wxtiffd.lib wxjpegd.lib wxpngd.lib wxzlibd.lib wxregexd.lib wxexpatd.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib winmm.lib shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib advapi32.lib wsock32.lib odbc32.lib oleacc.lib /nologo /dll /machine:i386 /out:"..\..\..\lib\vc_dll\wx.dll" /libpath:"$(WXWIN)\lib\vc_dll" /libpath:"..\..\..\lib\vc_dll" /libpath:"..\..\..\modules\lua\lib" /debug /pdb:"..\..\..\lib\vc_dll\wx.pdb"

!ENDIF

# Begin Target

# Name "mod_luamodule_mono - Win32 Release Unicode DLL Monolithic"
# Name "mod_luamodule_mono - Win32 Release Unicode DLL Multilib"
# Name "mod_luamodule_mono - Win32 Release DLL Monolithic"
# Name "mod_luamodule_mono - Win32 Release DLL Multilib"
# Name "mod_luamodule_mono - Win32 Debug Unicode DLL Monolithic"
# Name "mod_luamodule_mono - Win32 Debug Unicode DLL Multilib"
# Name "mod_luamodule_mono - Win32 Debug DLL Monolithic"
# Name "mod_luamodule_mono - Win32 Debug DLL Multilib"
# Begin Group "Source Files"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\wxbind\src\dummy.cpp
# ADD BASE CPP /Yc"wx/wxprec.h"
# ADD CPP /Yc"wx/wxprec.h"
# End Source File
# Begin Source File

SOURCE=..\..\luamodule\src\luamodule.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxadv_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxadv_wxladv.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxaui_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxbase_base.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxbase_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxbase_config.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxbase_data.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxbase_datetime.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxbase_file.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_appframe.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_clipdrag.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_controls.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_core.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_defsutils.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_dialogs.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_event.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_gdi.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_geometry.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_help.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_image.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_mdi.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_menutool.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_picker.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_print.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_sizer.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_windows.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxcore_wxlcore.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxgl_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxhtml_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxhtml_wxlhtml.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxlua\src\wxlbind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxlua\src\wxlcallb.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxluadebug\src\wxldebug.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxluasocket\src\wxldserv.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxluasocket\src\wxldtarg.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxluasocket\src\wxlsock.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxluadebug\src\wxlstack.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxlua\src\wxlstate.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxlua\src\wxlua_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxluasocket\src\wxluasocket_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxmedia_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxnet_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxrichtext_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxstc_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxxml_bind.cpp
# End Source File
# Begin Source File

SOURCE=..\..\wxbind\src\wxxrc_bind.cpp
# End Source File
# End Group
# End Target
# End Project

