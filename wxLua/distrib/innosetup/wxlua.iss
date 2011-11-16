; -- wxLua InnoSetup --
; Author: Francesco Montorsi
; Date: 20/2/2006
; $Id: wxlua.iss,v 1.2 2006/12/24 20:52:19 frm Exp $

; should be the same version of:
; 1) build\autoconf\configure.ac
; 2) WXLUA_RELEASE variable in build/bakefiles/wxluabase.bkl
#define VERSION          "2.8.0.0"

; before compiling this script with Inno Setup Compiler compile wxLua
; with the following options:
;   BUILD=debug SHARED=1 WX_SHARED=1


[Setup]

; version-related
VersionInfoVersion={#VERSION}
AppVerName=wxLua {#VERSION}
OutputBaseFilename=wxLua-{#VERSION}-setup

; compiler-related
SourceDir=..\..
OutputDir=..\..\..
Compression=lzma/fast
SolidCompression=yes

; installer-related
AppName=wxLua
ChangesAssociations=yes
DefaultDirName={pf}\wxLua
DefaultGroupName=wxLua
AllowNoIcons=yes
LicenseFile=docs\licence.txt
ShowLanguageDialog=yes

; cosmetic
WindowShowCaption=true
WindowStartMaximized=false
FlatComponentsList=true
WindowResizable=false
ShowTasksTreeLines=false
SetupIconFile=art\wxlua.ico

AppPublisherURL=http://wxlua.sourceforge.net/
AppSupportURL=http://wxlua.sourceforge.net/
AppUpdatesURL=http://wxlua.sourceforge.net/
VersionInfoCopyright=Copyright (C) 2006 wxLua developers.
AppCopyright=Copyright (C) 2006 by wxLua developers


[Components]
Name: main; Description: Main Files; Types: full compact custom; Flags: fixed
Name: help; Description: Help Files; Types: full compact
Name: sources; Description: Source Files; Types: full


[Files]

; main component
Source: art\*; DestDir: {app}\art; Components: main
Source: bin\*.exe; DestDir: {app}\bin; Components: main
Source: bin\*.dll; DestDir: {app}\bin; Components: main

; help component
Source: docs\*; DestDir: {app}\docs; Flags: recursesubdirs; Components: help
Source: samples\*; DestDir: {app}\samples; Flags: recursesubdirs; Components: help

; sources component
Source: bindings\*; DestDir: {app}\bindings; Flags: recursesubdirs; Components: sources
Source: util\*; DestDir: {app}\util; Flags: recursesubdirs; Components: sources

; be careful with these dirs (as they could contain a lot of temp stuff)
Source: apps\*; Excludes: build\msw\vc*,build\msw\bcc*; DestDir: {app}\apps; Flags: recursesubdirs; Components: sources
Source: modules\*; Excludes: build\msw\vc*,build\msw\bcc*; DestDir: {app}\modules; Flags: recursesubdirs; Components: sources
Source: build\*; Excludes: \msw\vc*,\msw\bcc*; DestDir: {app}\build; Flags: recursesubdirs; Components: sources
Source: lib\*; Excludes: *.lib*,*.dll*; DestDir: {app}\lib; Components: sources



[Messages]
BeveledLabel=wxLua


[UninstallDelete]


[Tasks]
Name: startmenu; Description: Create icons in Start menu; GroupDescription: Additional icons:; Components: main
Name: desktopicon; Description: Create a &desktop icon; GroupDescription: Additional icons:; Components: main
Name: quicklaunchicon; Description: Create a &Quick Launch icon; GroupDescription: Additional icons:; Components: main; Flags: unchecked
Name: associateopen; Description: Associate OPEN action for .lua files with wxLua interpreter; GroupDescription: Other tasks:; Components: main
Name: associateedit; Description: Associate EDIT action for .lua files with wxLuaEditor; GroupDescription: Other tasks:; Components: main
Name: updatepath; Description: Add lua and wxLua command-line program's folder to the PATH; GroupDescription: Other tasks:; Components: main

[Icons]
Name: {group}\wxLua; Filename: {app}\bin\wxlua.exe; WorkingDir: {app}; Components: main; Tasks: startmenu
Name: {group}\wxLuaEditor; Filename: {app}\bin\wxluaedit.exe; WorkingDir: {app}; Components: main; Tasks: startmenu
Name: {group}\wxLua doxygen docs; Filename: {app}\docs\doxygen\html\index.html; Components: help; Tasks: startmenu
Name: {group}\wxLua docs; Filename: {app}\docs; Components: help; Tasks: startmenu
Name: {group}\Uninstall; Filename: {uninstallexe}; Components: main; Tasks: startmenu

Name: {userdesktop}\wxLuaEditor; Filename: {app}\bin\wxluaedit.exe; WorkingDir: {app}; Components: main; Tasks: desktopicon
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\wxLua; Filename: {app}\bin\wxluaedit.exe; Tasks: quicklaunchicon

[Registry]

; create .lua filetype and associate an icon to it
Root: HKCR; Subkey: .lua; ValueType: string; ValueName: ; ValueData: wxLuaFile; Flags: uninsdeletevalue; Tasks: associateedit or associateopen
Root: HKCR; Subkey: wxLuaFile; ValueType: string; ValueName: ; ValueData: wxLua File; Flags: uninsdeletekey; Tasks: associateedit or associateopen
Root: HKCR; Subkey: wxLuaFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\art\wxlua.ico,0; Tasks: associateedit or associateopen

; associate the EDIT action for .lua extensions with the wxLuaEditor program
Root: HKCR; Subkey: wxLuaFile\shell\edit\command; ValueType: string; ValueName: ; ValueData: """{app}\bin\wxluaedit.exe"" ""%1"""; Tasks: associateedit

; associate the OPEN action for .lua extensions with the wxLua interpreter
Root: HKCR; Subkey: wxLuaFile\shell\open\command; ValueType: string; ValueName: ; ValueData: """{app}\bin\wxlua.exe"" ""%1"""; Tasks: associateopen





; UPDATE PATH stuff
; =================


[Code]

#include "modifypath.iss"

procedure CurStepChanged(CurStep: TSetupStep);
begin
  case CurStep of
    ssPostInstall:
      begin

        if IsTaskSelected('updatepath') then
          // if logged in as the admin we can add the path to all users
          if IsAdminLoggedOn then
            ModifyPath('{app}\bin', pmAddToEnd, psAllUsers)
          else
            ModifyPath('{app}\bin', pmAddToEnd, psCurrentUser)

      end
  end
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  case CurUninstallStep of
    usPostUninstall:
      begin
        if IsAdminLoggedOn then
          ModifyPath('{app}\bin', pmRemove, psAllUsers)
        else
          ModifyPath('{app}\bin', pmRemove, psCurrentUser)
      end
  end
end;





