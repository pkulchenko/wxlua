/////////////////////////////////////////////////////////////////////////////
// Purpose:     A console to help debug/use wxLua
// Author:      J Winwood
// Created:     14/11/2001
// Modifications: Enhanced console window functionality
// RCS-ID:      $Id: lconsole.cpp,v 1.20 2009/09/27 05:35:20 jrl1 Exp $
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#include "wx/wxprec.h"

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#ifndef WX_PRECOMP
    #include "wx/wx.h"
#endif

//#if defined(__WXGTK__) || defined(__WXMOTIF__) || defined(__WXMAC__)
    #include "art/wxlua.xpm"
//#endif

#include "wx/splitter.h"
#include "wx/toolbar.h"
#include "wx/filename.h"

#include "wxlua/include/wxlua.h"
#include "lconsole.h"

#include "../../../art/new.xpm"
#include "../../../art/save.xpm"
#include "../../../art/copy.xpm"

// ----------------------------------------------------------------------------
// wxLuaConsole
// ----------------------------------------------------------------------------

BEGIN_EVENT_TABLE(wxLuaConsole, wxFrame)
    EVT_CLOSE(wxLuaConsole::OnCloseWindow)
    EVT_MENU(wxID_ANY, wxLuaConsole::OnMenu)
END_EVENT_TABLE()

wxLuaConsole::wxLuaConsole(wxLuaConsoleWrapper* consoleWrapper,
                           wxWindow* parent, wxWindowID id, const wxString& title,
                           const wxPoint& pos, const wxSize& size,
                           long style, const wxString& name)
             :wxFrame(parent, id, title, pos, size, style, name),
              m_wrapper(consoleWrapper), m_exit_when_closed(false)
{
    m_savePath = wxGetCwd();

    SetIcon(wxICON(LUA));

    wxToolBar* tb = CreateToolBar();

    tb->AddTool(wxID_NEW,    wxT("Clear window"), wxBitmap(new_xpm),  wxT("Clear console window"), wxITEM_NORMAL);
    tb->AddTool(wxID_SAVEAS, wxT("Save output"),  wxBitmap(save_xpm), wxT("Save contents to file"), wxITEM_NORMAL);
    tb->AddTool(wxID_COPY,   wxT("Copy text"),    wxBitmap(copy_xpm), wxT("Copy contents to clipboard"), wxITEM_NORMAL);

    tb->Realize();

    m_splitter = new wxSplitterWindow(this, wxID_ANY,
                                      wxDefaultPosition, wxDefaultSize,
                                      wxSP_3DSASH);
    m_textCtrl = new wxTextCtrl(m_splitter, wxID_ANY, wxEmptyString,
                                wxDefaultPosition, wxDefaultSize,
                                wxTE_MULTILINE | wxTE_READONLY | wxTE_RICH | wxTE_DONTWRAP);
    m_textCtrl->SetFont(wxFont(10, wxTELETYPE, wxNORMAL, wxNORMAL));

    m_debugListBox = new wxListBox(m_splitter, wxID_ANY,
                                   wxDefaultPosition, wxDefaultSize,
                                   0, NULL, wxLB_SINGLE);
    m_debugListBox->Show(false);

    // listbox is shown only when used
    m_splitter->Initialize(m_textCtrl);
}

void wxLuaConsole::OnCloseWindow(wxCloseEvent&)
{
    // Must NULL the console so nobody will try to still use it.
    // Using EVT_DESTROY in the app causes a segfault if this is deleted
    // in wxApp::OnExit() and though this is ugly, it works.
    if (m_wrapper)
        m_wrapper->SetConsole(NULL);

    Destroy();
    if (m_exit_when_closed)
        wxExit();
}

void wxLuaConsole::OnMenu(wxCommandEvent& event)
{   
    switch (event.GetId())
    {
        case wxID_NEW :
        {
            m_textCtrl->Clear();
            break;
        }
        case wxID_SAVEAS :
        {
            wxString filename = wxFileSelector(wxT("Select file to save output to"), 
                                               m_savePath,
                                               m_saveFilename, 
                                               wxT("txt"),
                                               wxT("Text files (*.txt)|*.txt|All files|*.*"), 
                                               wxFD_SAVE|wxFD_OVERWRITE_PROMPT,
                                               this);

            if (!filename.IsEmpty())
            {
                wxFileName fn(filename);
                m_savePath = fn.GetPath();
                m_saveFilename = fn.GetFullName();

                m_textCtrl->SaveFile(filename);
            }
            break;
        }
        case wxID_COPY :
        {
            m_textCtrl->Copy();
            break;
        }
    }
}

void wxLuaConsole::AppendText(const wxString& msg)
{
    m_textCtrl->AppendText(msg + wxT("\n"));
}
void wxLuaConsole::AppendTextWithAttr(const wxString& msg, const wxTextAttr& attr)
{
    wxTextAttr oldAttr = m_textCtrl->GetDefaultStyle();

    m_textCtrl->SetDefaultStyle(attr);
    m_textCtrl->AppendText(msg + wxT("\n"));

    m_textCtrl->SetDefaultStyle(oldAttr);
}

void wxLuaConsole::DisplayStack(const wxLuaState& wxlState)
{
    wxCHECK_RET(wxlState.Ok(), wxT("Invalid wxLuaState"));
    int       nIndex    = 0;
    lua_Debug luaDebug;
    wxString  buffer;

    m_debugListBox->Clear();
    lua_State* L = wxlState.GetLuaState();

    while (lua_getstack(L, nIndex, &luaDebug) != 0)
    {
        buffer.Empty();
        if (lua_getinfo(L, "Sln", &luaDebug))
        {
            int lineNumber = luaDebug.currentline;
            if (lineNumber == -1)
            {
                if (luaDebug.name != NULL)
                    buffer.Printf(wxT("function %s"),
                                  lua2wx(luaDebug.name).c_str());
                else
                    buffer.Printf(wxT("{global}"));
            }
            else
            {
                if (luaDebug.name != NULL)
                    buffer.Printf(wxT("function %s line %d"),
                                  lua2wx(luaDebug.name).c_str(),
                                  lineNumber);
                else
                    buffer.Printf(wxT("{global} line %d"),
                                  lineNumber);
            }

            // skip over ourselves on the stack
            if (nIndex > 0)
                m_debugListBox->Append(buffer, (void *) nIndex);
        }
        nIndex++;
    }

    // only show the listbox if it has anything in it
    if (m_debugListBox->GetCount() && !m_splitter->IsSplit())
    {
        m_splitter->SplitHorizontally( m_textCtrl, m_debugListBox, 150);
        m_splitter->SetMinimumPaneSize(50);
    }
}

// ---------------------------------------------------------------------------
// wxLuaConsoleWrapper
// ---------------------------------------------------------------------------

wxLuaConsole* wxLuaConsoleWrapper::GetConsole()
{
    wxCHECK_MSG(m_luaConsole != NULL, NULL, wxT("Member wxLuaConsole is NULL!"));
    return m_luaConsole;
}


