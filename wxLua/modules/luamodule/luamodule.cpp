/////////////////////////////////////////////////////////////////////////////
// Purpose:     wxLuaModuleApp - code to allow wxLua to be used as a module using require"wx"
// Author:      John Labenski, J Winwood
// Created:     14/11/2001
// Copyright:   (c) 2012 John Labenski, 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

//#include <wx/wxprec.h>

#ifndef WX_PRECOMP
    //#include <wx/wx.h>
#endif

// This is a method of enabling v6 of comctrl32 controls w/o a manifest.
// However, it doesn't seem possible to enable them from a DLL even by calling
// InitCommonControls(), InitCommonControlsEx(), or the EnableVisualStyles() hack.
//#pragma comment(lib,"comctl32.lib")
//#pragma comment(linker,"\"/manifestdependency:type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")

#include <wx/app.h>
#include <wx/frame.h>
#include <wx/msgdlg.h>
#include <wx/image.h>       // for wxInitAllImageHandlers

#if defined(__WXMSW__)
    #include <wx/msw/private.h> // for wxSetInstance
#endif

#include "wxlua/wxlstate.h"
#include "luamoduledefs.h"

extern "C"
{
    // force C linkage w/o name mangling
    WXDLLIMPEXP_LUAMODULE int luaopen_wx(lua_State *L);

#ifdef __WXMSW__
    BOOL APIENTRY DllMain( HANDLE hModule, DWORD ul_reason_for_call, LPVOID );
#endif //__WXMSW__
}

static wxLuaState s_wxlState; // This is our wxLuaState for the module

// Declare the binding initialization functions as extern so we don't have to
//  #include the binding header for simplicity.
#include "wxbind/include/wxbinddefs.h"
WXLUA_DECLARE_BIND_ALL

// ----------------------------------------------------------------------------
// Remember the hInstance for this DLL so we can set wxSetInstance() and
// be able to load cursors from the embedded resources in <wx/msw/wx.rc>
// wxWidgets uses GetModuleHandle(NULL) which returns the handle to the calling
// EXE app which is not what we want, we want *this* instance.
// ----------------------------------------------------------------------------

#ifdef __WXMSW__

static HINSTANCE wxLuaModule_hDll = NULL;

BOOL APIENTRY DllMain( HANDLE hModule, DWORD ul_reason_for_call, LPVOID )
{
   switch (ul_reason_for_call)
   {
      case DLL_PROCESS_ATTACH : wxLuaModule_hDll = (HINSTANCE)hModule; break;
      case DLL_PROCESS_DETACH : wxLuaModule_hDll = NULL;
      default : break;
   }

   return TRUE;
}

#endif // __WXMSW__


#ifdef _MSC_VER
    // warning C4275: non dll-interface class 'wxApp' used as base for dll-interface class 'wxLuaModuleApp'
    // This file is built into a DLL, but we can link to a static wxWidgets and 
    // we don't want or need to export their functions, only luaopen_wx().
    #pragma warning( disable : 4275 )

    // warning C4251: 'wxLuaModuleApp::ms_classInfo': class 'wxClassInfo' needs to have dll-interface to be used by clients of class wxLuaModuleApp.
    // Same reasoning as disabling C4275.
    #pragma warning( disable : 4251 )
#endif // _MSC_VER

// ----------------------------------------------------------------------------
// wxLuaModuleApp
// ----------------------------------------------------------------------------

class WXDLLIMPEXP_LUAMODULE wxLuaModuleApp : public wxApp
{
public:
    wxLuaModuleApp() : wxApp() {}

    // Override the base class virtual functions
    virtual bool OnInit();
    virtual int  OnExit();
    virtual int  MainLoop();

    void OnLuaPrint( wxLuaEvent &event );
    void OnLuaError( wxLuaEvent &event );

private:
    DECLARE_ABSTRACT_CLASS(wxLuaModuleApp)
    DECLARE_EVENT_TABLE()
};

// ----------------------------------------------------------------------------
// wxLuaModuleApp
// ----------------------------------------------------------------------------

IMPLEMENT_ABSTRACT_CLASS(wxLuaModuleApp, wxApp);
IMPLEMENT_APP_NO_MAIN(wxLuaModuleApp)

BEGIN_EVENT_TABLE(wxLuaModuleApp, wxApp)
    EVT_LUA_PRINT       (wxID_ANY, wxLuaModuleApp::OnLuaPrint)
    EVT_LUA_ERROR       (wxID_ANY, wxLuaModuleApp::OnLuaError)
    //EVT_LUA_DEBUG_HOOK  (wxID_ANY, wxLuaModuleApp::OnLua)
END_EVENT_TABLE()

bool wxLuaModuleApp::OnInit()
{
#ifdef __WXMSW__
    HMODULE h_comctl32 = ::LoadLibrary(_T("comctl32.dll"));
    //wxPrintf(wxT("comctl32.dll = %p \n"), (void*)h); fflush(stdout);
    //wxCHECK_MSG(0 && h != NULL, true, wxT("Error loading comctl32.dll, you can try to continue..."));
    if (h_comctl32 == NULL)
        wxPrintf(wxT("wxLuaModule - Error loading comctl32.dll, trying to continue...\n"));
#endif

    //wxPrintf(wxT("wxLuaModuleApp::OnInit wxLuaState.IsOk()=%d \n"), (int)s_wxlState.IsOk()); fflush(stdout);
    return wxApp::OnInit();
}

int wxLuaModuleApp::OnExit()
{
    // This is never called... it is here for completeness.
    //wxPrintf(wxT("wxLuaModuleApp::OnExit wxLuaState.IsOk()=%d \n"), (int)s_wxlState.IsOk()); fflush(stdout);
    return wxApp::OnExit();
}

int wxLuaModuleApp::MainLoop()
{
    // only run the mainloop if there are any toplevel windows otherwise
    // they cannot exit it and they won't be able to do anything anyway.
    int  run_main = 0;
    bool have_windows = (wxTopLevelWindows.GetCount() != 0);
    if (have_windows && !IsMainLoopRunning())
        run_main = wxApp::MainLoop();

    return run_main;
}

void wxLuaModuleApp::OnLuaPrint( wxLuaEvent &event )
{
    wxPrintf(wxT("%s\n"), event.GetString().c_str()); fflush(stdout);
}

void wxLuaModuleApp::OnLuaError( wxLuaEvent &event )
{
    // Note that we don't get this error normally since lua.exe installed
    // their error handler before calling pcall(), however we might get this
    // event if pcall() is called in Lua code.
    wxPrintf(wxT("wxLua Runtime Error:\n%s\n"), event.GetString().c_str()); fflush(stdout);

    int ret = wxMessageBox(event.GetString(), wxT("wxLua Runtime Error"), wxOK|wxCANCEL|wxICON_ERROR);
    if (ret == wxCANCEL)
        wxExit();
}

// ----------------------------------------------------------------------------
// luaopen_wx the C function for require to call
// ----------------------------------------------------------------------------

wxLuaModuleApp* app = NULL;

int luaopen_wx(lua_State *L)
{
    // only initialize the wxLuaState once, allows require to be called more than once
    if (!s_wxlState.Ok())
    {
        int argc = 0;
        wxChar **argv = NULL;

#ifdef __WXMSW__
        // Set the HINSTANCE to *this* DLL's instance, not the caller app's HINSTANCE.
        // NOTE: If wxGetInstance() is NULL then wxEntryStart() calls DoCommonPreInit() 
        //       which calls wxSetInstance(::GetModuleHandle(NULL));
        wxSetInstance(wxLuaModule_hDll);

        // This has been a problem in the past, help people debug it...
        // The problem will be that cursors/icons probably won't be loaded from 
        // the resources and an assert will be given.
        if (wxLuaModule_hDll == NULL)
        {
            wxPrintf(wxT("wxLuaModule - Error getting HINSTANCE, DllMain() wasn't called! trying to continue...\n")); 
            // Don't exit... it may still work...
        }
#endif // __WXMSW__

        if (!wxEntryStart(argc, argv))
        {
            wxPrintf(wxT("wxLuaModule - Error calling wxEntryStart(argc, argv), aborting.\n"));
            return 0;
        }

        if (!wxTheApp || !wxTheApp->CallOnInit())
        {
            wxPrintf(wxT("wxLuaModule - Error calling wxTheApp->CallOnInit(), aborting.\n"));
            return 0;
        }

        wxTheApp->SetExitOnFrameDelete(true);
        wxInitAllImageHandlers();

        WXLUA_IMPLEMENT_BIND_ALL
        s_wxlState.Create(L, wxLUASTATE_SETSTATE|wxLUASTATE_OPENBINDINGS|wxLUASTATE_STATICSTATE);
        // Since we are run from a console we will let Lua do the printing.
        // We don't have to worry about the message not showing up in MSW as they don't for GUI apps with a WinMain().
        s_wxlState.SetEventHandler((wxEvtHandler*)wxTheApp);

        //s_wxlState.sm_wxAppMainLoop_will_run = true;
    }

    lua_getglobal(L, "wx"); // push global wx table on the stack
    return 1;
}
