/////////////////////////////////////////////////////////////////////////////
// Purpose:     Interface to a console to help debug wxLua
// Author:      Francis Irving
// Created:     16/01/2002
// Copyright:   (c) 2002 Creature Labs. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#ifndef WX_LUA_CONSOLE_H
#define WX_LUA_CONSOLE_H

#include "wx/frame.h"
#include "wxlua/include/wxlua.h"

class WXDLLIMPEXP_FWD_CORE wxSplitterWindow;
class WXDLLIMPEXP_FWD_CORE wxTextCtrl;
class WXDLLIMPEXP_FWD_CORE wxListBox;

class wxLuaConsoleWrapper;

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

    // Display a message in the console with optional attribute to display it with.
    void AppendText(const wxString& msg);
    void AppendTextWithAttr(const wxString& msg, const wxTextAttr& attr);

    // Remove lines so there are only max_lines.
    bool CheckMaxLines();

    // Display the stack in a wxListBox, but only if there are any items in it
    void DisplayStack(const wxLuaState& wxlState);
    // Perhaps an error has occurred, when this window is closed wxExit
    //   will be called to close the app.
    void SetExitWhenClosed(bool do_exit) { m_exit_when_closed = m_exit_when_closed || do_exit; }

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

    bool Ok() const { return m_luaConsole != NULL; }

    wxLuaConsole* GetConsole(); // this will assert if console is NULL, check with Ok()
    void SetConsole(wxLuaConsole* c) { m_luaConsole = c; }

protected:
    wxLuaConsole* m_luaConsole;
};


#endif // WX_LUA_CONSOLE_H
