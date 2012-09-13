//----------------------------------------------------------------------------
// Purpose:     wxluafreeze.cpp - runs embedded wxlua script by wxluafreeze.lua
// Author:      John Labenski
// Created:     04/02/2006
// RCS-ID:
// Copyright:   (c) 2012 John Labenski
// Licence:     wxWidgets licence
//----------------------------------------------------------------------------

//#if defined(__GNUG__) && !defined(NO_GCC_PRAGMA)
//    #pragma implementation "wxlua.h"
//#endif

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

//#include "wx/cmdline.h"
#include <wx/app.h>
#include <wx/image.h>
#include <wx/file.h>
#include <wx/filename.h>
#include "wxlua/wxlua.h"
#include "wxlua/wxlstate.h"

// implemented below
wxFileName wxFindAppFullName(const wxString& argv0, const wxString& cwd, const wxString& appVariableName);

// Declare the binding initialization functions
// Note : We could also do this "extern bool wxLuaBinding_XXX_init();" and
//        later call "wxLuaBinding_XXX_init();" to initialize it.
//        However we use the macros that include #if conditions to have a
//        better chance of determining what libs are available.
// Note : Make sure you link to the binding libraries.

#include "wxbind/include/wxbinddefs.h"
WXLUA_DECLARE_BIND_ALL

// unique identifier to return for missing script
const wxChar* LOADSCRIPT_MISSING = wxT("\\*{Missing Script>*\\");

// ---------------------------------------------------------------------------
// wxLuaFreezeApp
// ---------------------------------------------------------------------------

class wxLuaFreezeApp : public wxApp
{
public:
    // Override the base class virtual functions
    bool OnInit();
    int  OnExit();

    // load the script from the end of this file
    //  if only_check then return LOADSCRIPT_MISSING if no script else wxEmptyString
    wxString LoadScript(const wxString& filename, bool only_check = false);

    // Handle wxLua events
    void OnLua(wxLuaEvent &event);
    // Output print statements and errors
    void OutputPrint(const wxString& str);

    wxLuaState m_wxlState;
    wxString   m_fileName;

private:
    DECLARE_EVENT_TABLE();
};

DECLARE_APP(wxLuaFreezeApp)

// ---------------------------------------------------------------------------
// wxLuaFreezeApp
// ---------------------------------------------------------------------------
IMPLEMENT_APP(wxLuaFreezeApp)

BEGIN_EVENT_TABLE(wxLuaFreezeApp, wxApp)
    EVT_LUA_PRINT(wxID_ANY, wxLuaFreezeApp::OnLua)
    EVT_LUA_ERROR(wxID_ANY, wxLuaFreezeApp::OnLua)
END_EVENT_TABLE()

bool wxLuaFreezeApp::OnInit()
{
#ifdef __WXGTK__
    // this call is very important since otherwise scripts using the decimal
    // point '.' could not work with those locales which use a different symbol
    // (e.g. the comma) for the decimal point...
    // It doesn't work to put os.setlocale('c', 'numeric') in the Lua file that
    // you want to use decimal points in. That's because the file has been lexed
    // and compiler before the locale has changed, so the lexer - the part that
    // recognizes numbers - will use the old locale.
    setlocale(LC_NUMERIC, "C");
#endif

    // load all image handlers for the wxLua script to make things easy
    wxInitAllImageHandlers();

    // Initialize the wxLua bindings we want to use.
    // See notes for WXLUA_DECLARE_BIND_ALL above.
    WXLUA_IMPLEMENT_BIND_ALL

    // Find the full path this this executable
    wxFileName appFile = wxFindAppFullName(argv[0], wxGetCwd(), wxEmptyString);

    if (appFile.FileExists() == false)
    {
        m_fileName = argv[0]; // the filename of 'this' program
        //OutputPrint(wxString::Format(wxT("Unable to find the path for '%s'\n"), argv[0]));
    }
    else
        m_fileName = appFile.GetFullPath();


    // When this function returns wxApp:MainLoop() will be called by wxWidgets
    // and so we want the Lua code wx.wxGetApp:MainLoop() to not
    // prematurely start it.
    wxLuaState::sm_wxAppMainLoop_will_run = true;

    m_wxlState = wxLuaState(this, wxID_ANY);
    if (!m_wxlState.Ok())
        return false;

    // if no script attached try to run the program on the command line
    if (LoadScript(m_fileName, true) == LOADSCRIPT_MISSING)
    {
        if (argc > 1)
        {
            wxlua_pushargs(m_wxlState.GetLuaState(), argv, argc, 1);
            // just run it, lua gives a nice error message on failure
            m_wxlState.RunFile(argv[1]);
        }
        else
        {
            OutputPrint(wxString::Format(wxT("Expecting '<wxLuaFreeze:[script length]>' at end of '%s'.\n")
                                         wxT("Did you forget to run wxluafreeze.lua to attach your script?\n")
                                         wxT("You may also run wxLua programs by specifying them on the command line."),
                                         m_fileName.c_str()));
        }
    }
    else
    {
        // now load our script to run that should have been appended to this file
        //  by wxluafreeze.lua
        wxString script(LoadScript(m_fileName));
        if (!script.IsEmpty())
        {
            wxlua_pushargs(m_wxlState.GetLuaState(), argv, argc, 0);
            m_wxlState.RunString(script);
        }
    }

    // no matter what - try to see any toplevel windows exist, if not then
    // there's no way to exit so assume that the program is all done
    wxWindowList::compatibility_iterator node = wxTopLevelWindows.GetFirst();
    if (node)
        return true;

    return false;
}

int wxLuaFreezeApp::OnExit()
{
    if (m_wxlState.Ok())
        m_wxlState.CloseLuaState(true);

    return wxApp::OnExit();
}

wxString wxLuaFreezeApp::LoadScript(const wxString& filename, bool only_check)
{
    // lots of debugging to make sure that everything is ok
    wxFile f;

    if (!f.Open(filename, wxFile::read))
    {
        OutputPrint(wxString::Format(wxT("Unable to open this executable file '%s' in read-only mode.\n"), filename.c_str()));
        return wxEmptyString;
    }

    // end of file is : "<wxLuaFreeze:%010d>", script_len
    #define END_TAG_LEN 24

    if (f.Seek(-END_TAG_LEN, wxFromEnd) == wxInvalidOffset)
    {
        f.Close();
        OutputPrint(wxString::Format(wxT("Unable to seek to last %d bytes at end of '%s'.\n"), END_TAG_LEN, filename.c_str()));
        return wxEmptyString;
    }

    // do some sanity checking before reading the script length

    char tag_buf[END_TAG_LEN+2] = {0};
    memset(tag_buf, 0, sizeof(char)*(END_TAG_LEN+2));
    long script_len = 0;

    if (f.Read((void*)tag_buf, END_TAG_LEN) == wxInvalidOffset)
    {
        f.Close();
        OutputPrint(wxString::Format(wxT("Unable to read wxLuaFreeze tag info at end of '%s'.\n"), filename.c_str()));
        return wxEmptyString;
    }

    if (sscanf(tag_buf, "<wxLuaFreeze:%ld>", &script_len) != 1)
    {
        f.Close();

        // they only wanted to know if the script exists, assume it's valid
        if (only_check)
            return LOADSCRIPT_MISSING;

        OutputPrint(wxString::Format(wxT("Expecting '<wxLuaFreeze:[script length]>' at end of '%s'.\n")
                                     wxT("Did you forget to run wxluafreeze.lua to attach your script?\n"), filename.c_str()));
        return wxEmptyString;
    }
    else if (f.Seek(-END_TAG_LEN - script_len, wxFromEnd) == wxInvalidOffset)
    {
        f.Close();
        OutputPrint(wxString::Format(wxT("Unable to seek to beginning of wxLua script at end of '%s'.\n"), filename.c_str()));
        return wxEmptyString;
    }

    // size should be valid from Seek statement
    char *script = (char*)malloc(script_len+2);
    if (script)
    {
        memset(script, 0, sizeof(script_len+2));
        f.Read(script, script_len);
        script[script_len] = 0;
    }

    f.Close();

    // we finally have our script!
    wxString scriptStr(lua2wx(script));
    free(script);

    return scriptStr;
}

void wxLuaFreezeApp::OnLua(wxLuaEvent &event)
{
    OutputPrint(event.GetString());

    //if (event.GetEventType() == wxEVT_LUA_PRINT)
    //else if (event.GetEventType() == wxEVT_LUA_ERROR)
}

void wxLuaFreezeApp::OutputPrint(const wxString& str)
{
#ifdef __WXMSW__
    // in msw printf statements go nowhere
    wxMessageBox(str, wxFileName(m_fileName).GetName());
#else
    wxPrintf(wxT("%s\n"), str.c_str());
#endif // __WXMSW__
}

// --------------------------------------------------------------------------
// Find the absolute path where this application has been run from. (Julian Smart)
// argv0 is wxTheApp->argv[0]
// cwd is the current working directory (at startup)
// appVariableName is the name of a variable containing the directory for this app, e.g.
// MYAPPDIR. This is checked first.
// --------------------------------------------------------------------------

wxFileName wxFindAppFullName(const wxString& argv0, const wxString& cwd, const wxString& appVariableName)
{
    wxFileName fileName(argv0);
    wxString str;
    wxString path;

#if defined(__WXMSW__)
    if (!fileName.HasExt())
        fileName.SetExt(wxT("exe"));
#endif

    // Try appVariableName
    if (!appVariableName.IsEmpty())
        path = wxGetenv(appVariableName);

#if defined(__WXMAC__) && !defined(__DARWIN__)
    // On Mac, the current directory is the relevant one when
    // the application starts.
    if (path.IsEmpty())
        path = cwd;
#endif

    if (path.IsEmpty())
    {
        if (wxIsAbsolutePath(fileName.GetFullPath()))
            path = fileName.GetFullPath();
        else
        {
            // Is it a relative path?
            wxString currentDir(cwd);
            if (currentDir.Last() != wxFILE_SEP_PATH)
                currentDir += wxFILE_SEP_PATH;
            if (wxFileExists(currentDir + fileName.GetFullName()))
                path = currentDir;
        }
    }

    if (path.IsEmpty())
    {
        // OK, it's neither an absolute path nor a relative path.
        // Search PATH.
        wxPathList pathList;
        pathList.AddEnvList(wxT("PATH"));
        path = wxFileName(pathList.FindAbsoluteValidPath(fileName.GetFullName())).GetPath();
    }
    fileName.SetPath(path);
    return fileName;
}
