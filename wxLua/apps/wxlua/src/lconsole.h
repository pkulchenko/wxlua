/////////////////////////////////////////////////////////////////////////////
// Purpose:     Interface to a console to help debug wxLua
// Author:      Francis Irving
// Created:     16/01/2002
// Copyright:   (c) 2002 Creature Labs. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#ifndef WX_LUA_CONSOLE_H
#define WX_LUA_CONSOLE_H

#include <wx/frame.h>

#include "wxlua/include/wxlua.h"

class WXDLLIMPEXP_FWD_CORE wxSplitterWindow;
class WXDLLIMPEXP_FWD_CORE wxTextCtrl;
class WXDLLIMPEXP_FWD_CORE wxListBox;

class wxLuaConsoleWrapper;

enum wxLuaConsole_WindowIds
{
    ID_WXLUACONSOLE_SCROLLBACK_LINES = wxID_HIGHEST + 10
};

// ----------------------------------------------------------------------------
// wxLuaConsole - define a console class to display print statements
// ----------------------------------------------------------------------------

class wxLuaConsole : public wxFrame
{
public:
    wxLuaConsole(wxLuaConsoleWrapper* consoleWrapper,
                 wxWindow* parent, wxWindowID id,
                 const wxString& title = wxT("wxLua console"),
                 const wxPoint& pos = wxDefaultPosition,
                 const wxSize& size = wxSize(300, 400),
                 long style = wxDEFAULT_FRAME_STYLE,
                 const wxString& name = wxT("wxLuaConsole"));

    /// Display a message in the console.
    void AppendText(const wxString& msg);
    /// Display a message in the console with optional wxTextCtrl attribute to display it with.
    void AppendTextWithAttr(const wxString& msg, const wxTextAttr& attr);

    // Remove lines so there are only max_lines, returns false if nothing is changed.
    bool SetMaxLines(int max_lines = 500);
    // Get the maximum number of lines to show in the textcontrol before removing the earliest ones.
    int  GetMaxLines() const { return m_max_lines; }

    // Display the stack in a wxListBox, but only if there are any items in it.
    // This only works while Lua is running.
    void DisplayStack(const wxLuaState& wxlState);

    // Set if wxExit() will be called with this dialog is closed to exit the app.
    // Use this when an error has occurred so the program doesn't continue.
    void SetExitWhenClosed(bool do_exit) { m_exit_when_closed = do_exit; }
    // Get whether the program will exit when this dialog is closed.
    bool GetExitWhenClosed() const       { return m_exit_when_closed; }

protected:
    void OnCloseWindow(wxCloseEvent& event);
    void OnMenu(wxCommandEvent& event);

    wxLuaConsoleWrapper *m_wrapper;
    wxSplitterWindow    *m_splitter;
    wxTextCtrl          *m_textCtrl;
    wxListBox           *m_debugListBox;
    bool                 m_exit_when_closed;
    int                  m_max_lines;
    wxString             m_saveFilename;
    wxString             m_savePath;

private:
    DECLARE_EVENT_TABLE()
};

// ----------------------------------------------------------------------------
// wxLuaConsoleWrapper - A smart pointer like wrapper for the wxLuaConsole
//
// Create one as a member of the wxApp or whereever it will exist longer than
// the wxLuaConsole it wraps and the wxLuaConsole will NULL the pointer to
// it when closed. See wxLuaConsole::OnCloseWindow(wxCloseEvent&) as to why
// we simply can't catch the close event elsewhere.
// ----------------------------------------------------------------------------

class wxLuaConsoleWrapper
{
public:

    wxLuaConsoleWrapper(wxLuaConsole* c = NULL) : m_luaConsole(c) {}

    bool IsOk() const { return m_luaConsole != NULL; }

    wxLuaConsole* GetConsole(); // this will assert if console is NULL, check with Ok()
    void SetConsole(wxLuaConsole* c) { m_luaConsole = c; }

protected:
    wxLuaConsole* m_luaConsole;
};


#endif // WX_LUA_CONSOLE_H
