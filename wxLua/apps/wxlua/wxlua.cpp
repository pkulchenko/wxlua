/////////////////////////////////////////////////////////////////////////////
// Purpose:     Standalone wxLua application
// Author:      John Labenski, Francis Irving, J. Winwood
// Created:     16/01/2002
// Copyright:   (c) 2012 John Labenski
// Copyright:   (c) 2002 Creature Labs. All rights reserved.
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#include <wx/wxprec.h>

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif

#ifdef __WXGTK__
    #include <locale.h>
#endif

#include <wx/cmdline.h>
#include <wx/fs_mem.h>
#include <wx/image.h>

#include "wxlua/wxlua.h"
#include "wxlua/debugger/wxldserv.h"
#include "wxlua.h"
#include "editor.h"

#include "art/wxlualogo.xpm"

extern "C"
{
    #include "lualib.h"
}

#ifndef wxICON_NONE
#define wxICON_NONE 0 // for 2.8 compat
#endif

#define ID_WXLUA_CONSOLE 100

// Declare the binding initialization functions
// Note : We could also do this "extern bool wxLuaBinding_XXX_init();" and
//        later call "wxLuaBinding_XXX_init();" to initialize it.
//        However we use the macros that include #if conditions to have a
//        better chance of determining what libs are available.
// Note : Make sure you link to the binding libraries.

#include "wxbind/include/wxbinddefs.h"
WXLUA_DECLARE_BIND_ALL

// ---------------------------------------------------------------------------
// wxCmdLineEntryDesc
// ---------------------------------------------------------------------------

static const wxCmdLineEntryDesc cmdLineDesc[] =
{
    { wxCMD_LINE_SWITCH, wxLuaT("h"), wxLuaT("help"),   wxLuaT("Help on command line switches."),
      wxCMD_LINE_VAL_NONE, wxCMD_LINE_PARAM_OPTIONAL|wxCMD_LINE_OPTION_HELP },

    { wxCMD_LINE_SWITCH, wxLuaT(""),  wxLuaT("nostdout"), wxLuaT("Do not print output to command line stdout."),
      wxCMD_LINE_VAL_NONE, wxCMD_LINE_PARAM_OPTIONAL },

#ifdef __WXMSW__
    { wxCMD_LINE_SWITCH, wxLuaT(""),  wxLuaT("dosstdout"), wxLuaT("Open a new DOS console and print output to it."),
      wxCMD_LINE_VAL_NONE, wxCMD_LINE_PARAM_OPTIONAL },
#endif // __WXMSW__

    { wxCMD_LINE_SWITCH, wxLuaT("m"), wxLuaT("msgdlg"), wxLuaT("Print output to message dialogs."),
      wxCMD_LINE_VAL_NONE, wxCMD_LINE_PARAM_OPTIONAL },

    { wxCMD_LINE_SWITCH, wxLuaT("c"), wxLuaT("console"), wxLuaT("Print output to a message console."),
      wxCMD_LINE_VAL_NONE, wxCMD_LINE_PARAM_OPTIONAL },

    // They can simply show the console that will keep the program alive
    //{ wxCMD_LINE_SWITCH, wxLuaT(""),  wxLuaT("noquit"), wxLuaT("Do not exit even if there are no top-level windows open."),
    //  wxCMD_LINE_VAL_NONE, wxCMD_LINE_PARAM_OPTIONAL },

    { wxCMD_LINE_OPTION, wxLuaT("e"), wxLuaT("execute"), wxLuaT("Execute a a quoted string as a program."),
      wxCMD_LINE_VAL_STRING, wxCMD_LINE_PARAM_OPTIONAL },

    { wxCMD_LINE_OPTION, wxLuaT("d"), wxLuaT("debuggee"), wxLuaT("Run as debuggee -d[host]:[port] (for internal use)"),
      wxCMD_LINE_VAL_STRING, wxCMD_LINE_PARAM_OPTIONAL },

    { wxCMD_LINE_OPTION, wxLuaT("o"),wxLuaT("open"), wxLuaT("Open file(s) to edit."),
      wxCMD_LINE_VAL_STRING, wxCMD_LINE_PARAM_OPTIONAL|wxCMD_LINE_PARAM_MULTIPLE },

    { wxCMD_LINE_OPTION, wxLuaT("r"), wxLuaT("run"), wxLuaT("Run a Lua program with command line args."),
      wxCMD_LINE_VAL_STRING, wxCMD_LINE_PARAM_OPTIONAL|wxCMD_LINE_PARAM_MULTIPLE},

    { wxCMD_LINE_PARAM,  wxLuaT(""),  wxLuaT(""),    wxLuaT("Run a Lua program with command line args."),
      wxCMD_LINE_VAL_STRING, wxCMD_LINE_PARAM_OPTIONAL|wxCMD_LINE_PARAM_MULTIPLE },

    { wxCMD_LINE_NONE }
};

// Find the index into the argv that matches name starting at arg start_n
// This is necessary since the wxCmdLineParser drops -- and all -X
//  params so we use this to make sure that the Lua program is at 0.
int FindFirstCmdParam(int start_n, const wxString& name,
                      int argc, wxChar** argv)
{
    for (int arg_n = start_n; arg_n < argc; arg_n++)
    {
        if (argv[arg_n] == name)
            return arg_n - 1;
    }

    return start_n; //oops? just return what was given.
}

// ---------------------------------------------------------------------------
// wxLuaStandaloneApp
// ---------------------------------------------------------------------------
IMPLEMENT_APP(wxLuaStandaloneApp)

BEGIN_EVENT_TABLE(wxLuaStandaloneApp, wxApp)
    EVT_LUA_PRINT       (wxID_ANY, wxLuaStandaloneApp::OnLua)
    EVT_LUA_ERROR       (wxID_ANY, wxLuaStandaloneApp::OnLua)
    //EVT_LUA_DEBUG_HOOK  (wxID_ANY, wxLuaStandaloneApp::OnLua)
END_EVENT_TABLE()

bool wxLuaStandaloneApp::OnInit()
{
    m_programName       = argv[0];  // The name of this program
    m_print_stdout      = true;
    m_dos_stdout        = false;
    m_print_msgdlg      = false;
    m_want_console      = false;
    m_wxlDebugTarget    = NULL;
    m_mem_bitmap_added  = false;

    int  arg_count = 0;     // counter for args used during parsing
    bool run_ok    = false; // has the Lua program executed ok
    bool dont_quit = false; // user specified -q switch to not quit

#if defined(__WXMSW__) && wxCHECK_VERSION(2, 3, 3)
    WSADATA wsaData;
    WORD wVersionRequested = MAKEWORD(1, 1);
    WSAStartup(wVersionRequested, &wsaData);
#endif // defined(__WXMSW__) && wxCHECK_VERSION(2, 3, 3)

    wxInitAllImageHandlers();
    wxFileSystem::AddHandler(new wxMemoryFSHandler);
    wxMemoryFSHandler::AddFile(wxT("wxLua"), wxBitmap(wxlualogo_xpm), wxBITMAP_TYPE_XPM);
    m_mem_bitmap_added = true;

#ifdef __WXGTK__
    // this call is very important since otherwise scripts using the decimal
    // point '.' could not work with those locales which use a different symbol
    // (e.g. the comma) for the decimal point...
    // It doesn't work to put os.setlocale('c', 'numeric') in the Lua file that
    // you want to use decimal points in. That's because the file has been lexed
    // and compiler before the locale has changed, so the lexer - the part that
    // recognises numbers - will use the old locale.
    setlocale(LC_NUMERIC, "C");
#endif

    // Initialize the wxLua bindings we want to use.
    // See notes for WXLUA_DECLARE_BIND_ALL above.
    WXLUA_IMPLEMENT_BIND_ALL

    // When this function returns wxApp:MainLoop() will be called by wxWidgets
    // and so we want the Lua code wx.wxGetApp:MainLoop() to not
    // prematurely start it.
    wxLuaState::sm_wxAppMainLoop_will_run = true;

    m_wxlState = wxLuaState(this, wxID_ANY);
    if (!m_wxlState.Ok())
        return false;

    wxCmdLineParser parser(cmdLineDesc, argc, argv);
    parser.SetLogo(wxString::Format(wxT("Welcome to %s\n")
                                    wxT("The editor is opened if no parameters are given.\n")
                                    wxT("Note: specify the parameters in the order shown and -d, -o, -r are exclusive.\n")
                                    wxT("To stop this program from processing command line args use '--'.\n"),
                                    wxLUA_VERSION_STRING));

    switch ( parser.Parse() )
    {
        case -1 :
        {
            // Help should be given by the wxCmdLineParser, exit program
            return false;
        }
        case 0:
        {
            // Don't quit the program even if no top level windows open
            //if (parser.Found(wxT("noquit")))
            //{
            //    arg_count++; // remove arg
            //    dont_quit = true;
            //}

            if (parser.Found(wxT("nostdout")))
            {
                arg_count++; // remove arg
                m_print_stdout = false;
            }

#ifdef __WXMSW__
            if (parser.Found(wxT("dosstdout")))
            {
                arg_count++; // remove arg
                m_dos_stdout = true;
            }

            wxlua_RedirectIOToDosConsole(m_dos_stdout, 500);
#endif // __WXMSW__

            if (parser.Found(wxT("msgdlg")))
            {
                arg_count++; // remove arg
                m_print_msgdlg = true;
            }

            // Check if we are to display the console
            if (parser.Found(wxT("console")))
            {
                arg_count++; // remove arg
                m_want_console = true;
                // Note: The wxLuaConsoleWrapper::m_luaConsole will be nulled when it closes in
                //       wxLuaConsole::OnCloseWindow.
                m_luaConsoleWrapper.SetConsole(new wxLuaConsole(&m_luaConsoleWrapper, NULL, ID_WXLUA_CONSOLE));
                m_luaConsoleWrapper.GetConsole()->Show(true);
            }

            // Check if we are to run some Lua code stat
            wxString luaCode;
            if (parser.Found(wxT("execute"), &luaCode))
            {
                arg_count++; // remove arg
                int rc = m_wxlState.RunString(luaCode, wxT("=(command line)"));
                run_ok = (rc == 0);
                if (rc != 0)
                {
                    DisplayMessage(wxlua_LUA_ERR_msg(rc), true, m_wxlState);
                    break;
                }
            }

            // Set up for debugging
            wxString debugString;
            if (parser.Found(wxT("debuggee"), &debugString))
            {
                // Note: wxLuaDebuggerServer::StartClient() runs
                //       wxExecute(m_programName -d[host]:[port], ...)

                wxString serverName(debugString.BeforeFirst(wxT(':')));

                if (serverName.IsEmpty())
                {
                    DisplayMessage(_("The wxLua debugger server host name is empty : wxLua -d[host]:[port]\n"), true);
                }
                else
                {
                    long portNumber = 0;
                    if (debugString.AfterFirst(wxT(':')).ToLong(&portNumber))
                    {
                        m_wxlDebugTarget = new wxLuaDebugTarget(m_wxlState, serverName, (int)portNumber);
                        if (m_wxlDebugTarget != NULL)
                        {
                            bool ok = m_wxlDebugTarget->Run();
                            //wxSafeShowMessage(wxT("Target"), wxString::Format(wxT("PID %ld TIME %s ok %d"), (long)wxGetProcessId(), wxT(__TIME__), int(ok)));
                            return ok;
                        }
                        else
                            DisplayMessage(_("The wxLua debug target cannot start.\n"), true);
                    }
                    else
                        DisplayMessage(_("The wxLua debugger server port is not a number : wxLua -d[host]:[port]\n"), true);
                }

                return (m_luaConsoleWrapper.IsOk()); // will exit app when console is closed
            }


            // See if a file has been specified to open or just start editor
            // if there are no parameters.
            wxString openFileName;
            bool open_file = parser.Found(wxT("open"), &openFileName);
            if (open_file) arg_count++; // remove arg

            if (open_file || (parser.GetParamCount() == 0))
            {
                if (openFileName.IsEmpty() && (parser.GetParamCount() > 0u))
                    openFileName = parser.GetParam(0);
                if (!openFileName.IsEmpty())
                    arg_count = FindFirstCmdParam(arg_count, openFileName, argc, argv);

                wxlua_pushargs(m_wxlState.GetLuaState(), argv, argc, arg_count);

                int rc = m_wxlState.RunBuffer((const char*)editor_wx_lua, editor_wx_lua_len, m_programName);
                run_ok = (rc == 0);
                if (rc != 0)
                {
                    DisplayMessage(wxlua_LUA_ERR_msg(rc), true, m_wxlState);
                }

                break;
            }

            // at least one parameter was specified, it must be a program to run.

            // See if we are to run the specified file with command-line arguments.
            // This is the default action if r is not specified.
            //if (parser.Found(wxT("r"), &value))
            {
                wxString runFileName;
                if (!parser.Found(wxT("run"), &runFileName) && (parser.GetParamCount() > 0u))
                    runFileName = parser.GetParam(0);
                if (!runFileName.IsEmpty())
                    arg_count = FindFirstCmdParam(arg_count, runFileName, argc, argv);

                arg_count++; // skip the program we're running
                wxlua_pushargs(m_wxlState.GetLuaState(), argv, argc, arg_count);

                int rc = m_wxlState.RunFile(runFileName);
                run_ok = (rc == 0);
                if (rc != 0)
                {
                    DisplayMessage(wxlua_LUA_ERR_msg(rc), true, m_wxlState);
                }

                break;
            }

            break;
        }
        default:
        {
            wxLogMessage(wxT("Unknown command line option, aborting."));
            return false;
        }
    }

    // check to see if there is a toplevel window open for the user to close, else exit
    if (run_ok && !dont_quit)
    {
        if (GetTopWindow() == NULL)
            run_ok = false;
    }

    return m_luaConsoleWrapper.IsOk() || run_ok;
}

int wxLuaStandaloneApp::OnExit()
{
    // If acting as a debuggee, we're done - disconnect from the debugger.
    if (m_wxlDebugTarget != NULL)
    {
        m_wxlDebugTarget->Stop();
        delete m_wxlDebugTarget;
        m_wxlDebugTarget = NULL;
    }

    m_wxlState.CloseLuaState(true);
    m_wxlState.Destroy();

    m_want_console = false; // no more messages

    if (m_luaConsoleWrapper.IsOk() && !m_luaConsoleWrapper.GetConsole()->IsBeingDeleted())
    {
        m_luaConsoleWrapper.GetConsole()->Destroy();
        m_luaConsoleWrapper.SetConsole(NULL);
    }

    if (m_mem_bitmap_added)
        wxMemoryFSHandler::RemoveFile(wxT("wxLua"));

    wxSafeYield();  // make sure windows get destroyed

    int ret = wxApp::OnExit();

#if defined(__WXMSW__) && wxCHECK_VERSION(2, 3, 3)
    WSACleanup ();
#endif // defined(__WXMSW__) && wxCHECK_VERSION(2, 3, 3)

    return ret;
}


void wxLuaStandaloneApp::DisplayMessage(const wxString &msg, bool is_error,
                                        const wxLuaState& wxlState)
{
    // If they closed the console, but specified they wanted it
    // on the command-line, recreate it.
    if (m_want_console && (!m_luaConsoleWrapper.IsOk()))
    {
        m_luaConsoleWrapper.SetConsole(new wxLuaConsole(&m_luaConsoleWrapper, NULL, ID_WXLUA_CONSOLE));
        m_luaConsoleWrapper.GetConsole()->Show(true);
    }

    if (!is_error)
    {
        if (m_print_stdout)
            wxPrintf(wxT("%s\n"), msg.c_str());

        if (m_luaConsoleWrapper.IsOk())
            m_luaConsoleWrapper.GetConsole()->AppendText(msg + wxT("\n"));

        if (m_print_msgdlg)
        {
            int ret = wxMessageBox(msg + wxT("\n\nPress cancel to ignore future print messages."), wxT("wxLua Print"), wxOK|wxCANCEL|wxCENTRE|wxICON_NONE);
            if (ret == wxCANCEL)
                m_print_msgdlg = false;
        }
    }
    else
    {
        //if (m_print_stdout) // always print errors, FIXME: to stderr or is stdout ok?
        wxPrintf(wxT("%s\n"), msg.c_str());

        if (m_luaConsoleWrapper.IsOk())
        {
            wxTextAttr attr(*wxRED);
            attr.SetFlags(wxTEXT_ATTR_TEXT_COLOUR);
            m_luaConsoleWrapper.GetConsole()->AppendTextWithAttr(msg + wxT("\n"), attr);
            m_luaConsoleWrapper.GetConsole()->SetExitWhenClosed(true);

            if (wxlState.Ok())
                m_luaConsoleWrapper.GetConsole()->DisplayStack(wxlState);
        }

        if (m_wxlDebugTarget != NULL)
            m_wxlDebugTarget->DisplayError(msg);

        if (m_print_msgdlg)
        {
            int ret = wxMessageBox(msg + wxT("\n\nPress cancel to ignore future error messages."), wxT("wxLua Print"), wxOK|wxCANCEL|wxCENTRE|wxICON_ERROR);
            if (ret == wxCANCEL)
                m_print_msgdlg = false;
        }
    }
}

void wxLuaStandaloneApp::OnLua( wxLuaEvent &event )
{
    DisplayMessage(event.GetString(), event.GetEventType() == wxEVT_LUA_ERROR,
                   event.GetwxLuaState());
}
