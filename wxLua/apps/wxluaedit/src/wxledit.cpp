/////////////////////////////////////////////////////////////////////////////
// Name:        wxledit.cpp
// Purpose:     Different editors, consoles for wxLua
// Author:      John Labenski
// Modified by:
// Created:     11/05/2002
// RCS-ID:
// Copyright:   (c) John Labenski
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

// For compilers that support precompilation, includes <wx/wx.h>.
#include <wx/wxprec.h>

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif // WX_PRECOMP

#include <wx/filename.h>
#include <wx/splitter.h>
#include <wx/confbase.h>

#include "wxledit.h"
#include "wxluadebug/include/wxlstack.h"
#include "wxluadebug/include/wxldebug.h"

#include "wx/stedit/stemenum.h"
#include "wx/stedit/steevent.h"

#include "art/wxlua.xpm"
#include "art/open.xpm"
#include "art/save.xpm"
#include "art/play.xpm"
#include "art/stop.xpm"

#define STC_DEF_MARGIN_WIDTH 16

DEFINE_LOCAL_EVENT_TYPE(wxEVT_LUASHELL_wxLUA_CREATION)
DEFINE_LOCAL_EVENT_TYPE(wxEVT_LUAIDE_wxLUA_CREATION)

//-----------------------------------------------------------------------------
// wxLuaShell
//-----------------------------------------------------------------------------
IMPLEMENT_ABSTRACT_CLASS(wxLuaShell, wxSTEditorShell)

BEGIN_EVENT_TABLE(wxLuaShell, wxSTEditorShell)
    EVT_STESHELL_ENTER ( wxID_ANY, wxLuaShell::OnSTEEvent )
    EVT_LUA_PRINT      ( wxID_ANY, wxLuaShell::OnLua )
    EVT_LUA_ERROR      ( wxID_ANY, wxLuaShell::OnLua )
END_EVENT_TABLE()

void wxLuaShell::Init()
{
    m_wxlstate_static = false;
}

bool wxLuaShell::Create(wxWindow *parent, wxWindowID id,
                        const wxPoint& pos, const wxSize& size,
                        long style, const wxString& name)
{
    if (!wxSTEditorShell::Create(parent, id, pos, size, style, name))
        return false;

    SetFileName(wxFileName(name), false);
    SetLanguage(wxFileName(wxT("a.lua"))); // use the lua lexer

    return true;
}

wxLuaShell::~wxLuaShell()
{
    if (m_wxlState.Ok() && !m_wxlstate_static)
    {
        m_wxlState.CloseLuaState(true); // force closing it since we're gone
    }
}

void wxLuaShell::SetwxLuaState(const wxLuaState& wxlState, bool is_static)
{
    if (m_wxlState.Ok() && !m_wxlstate_static)
    {
        // try to close it nicely first
        if (m_wxlState.IsRunning())
        {
            wxSafeYield();
            m_wxlState.DebugHookBreak();
        }

        m_wxlState.CloseLuaState(true); // force closing it since we own it
    }

    m_wxlState = wxlState;
    m_wxlstate_static = is_static;
}

bool wxLuaShell::RecreatewxLuaState(wxEvtHandler *wxlStateEvtHandler, int win_id)
{
    // ask if anyone else wants to create a new wxLuaState for us
    wxLuaEvent event(wxEVT_LUASHELL_wxLUA_CREATION, GetId(), m_wxlState);
    event.SetEventObject(this);
    event.SetInt(0);
    event.SetExtraLong(win_id);

    // return if handled, but not skipped.
    if (GetEventHandler()->ProcessEvent(event))
        return false;

    // Did they set a valid interpreter for the event and is it new?
    // If it's not different then assume they didn't change it so we'll create
    // a new one below. If they wanted to just adjust the current state they
    // should have called event.Skip(false)
    if (event.GetwxLuaState().Ok() && (event.GetwxLuaState() != m_wxlState))
    {
        SetwxLuaState(event.GetwxLuaState(), event.GetInt() == 1);
    }
    else
    {
        wxLuaState wxlState = wxLuaState(wxlStateEvtHandler, win_id);
        wxlState.SetLuaDebugHook( LUA_MASKCOUNT, 1000, 50, false );
        SetwxLuaState(wxlState, false);
    }

    return m_wxlState.Ok();
}

bool wxLuaShell::RunString(const wxString& string_, bool append_text)
{
    bool ret = false;

    wxString string(string_);

    if (string.Trim(true).Trim(false).IsEmpty())
        return ret;

    if (append_text)
    {
        if (!GetLine(GetLineCount()).IsEmpty())
            AppendText(wxT("\n"));

        AppendText(string);
    }

    AppendText(wxT("\n"));

    // restart the interpreter
    if (string == wxT("reset"))
    {
        if (m_wxlstate_static)
        {
            AppendText(wxT("Unable to reset lua, interpreter locked by another process.\n"));
        }
        else
        {
            if (RecreatewxLuaState(GetEventHandler(), GetId()))
            {
                AppendText(wxT("Successfully reset interpreter.\n"));
                ret = true;
            }
            else
                AppendText(wxT("Unable to reset interpreter.\n"));
        }
    }
    else if (m_wxlState.Ok())
    {
        // allow for syntax of "= 1+2+3" to print result
        if (string.Trim(true).Find(wxT('=')) == 0)
            string = wxT("return ") + string.AfterFirst('=');

        if (0 != m_wxlState.CompileString(string))
        {
            // try to see if we can return the value w/o error to print it
            if (0 == m_wxlState.CompileString(wxT("return ") + string))
                string = wxT("return ") + string;
        }

        int top1 = m_wxlState.lua_GetTop();
        ret = m_wxlState.RunString(string, wxT("wxLuaShell"), LUA_MULTRET) == 0;
        int top2 = m_wxlState.lua_GetTop();

        if (ret && (top2 > top1))
        {
            m_wxlState.lua_GetGlobal("tostring");

            if (!m_wxlState.lua_IsFunction(-1))
            {
                // This code is also used in wxlua_printFunction()
                AppendText(wxT("wxLua ERROR: Unable to print() without the tostring() function. Did you remove it?\n"));
                m_wxlState.lua_Pop(1);  // pop the nil or whatever replaced tostring()
                top2 = top1;    // don't let for loop run
            }

            for (int n = top1+1; n <= top2; n++)
            {
                m_wxlState.lua_PushValue(-1);  // push tostring function to be called
                m_wxlState.lua_PushValue(n);   // value to print
                m_wxlState.lua_Call(1, 1);     // run tostring function

                AppendText(m_wxlState.lua_TowxString(-1) + wxT("\n"));
                m_wxlState.lua_Pop(1);         // pop string from "tostring" function
            }
        }

        m_wxlState.lua_SetTop(top1);
    }
    else
        AppendText(wxT("The lua interpreter is not available - try running 'reset'.\n"));

    CheckPrompt(true);

    return ret;
}

void wxLuaShell::OnSTEEvent(wxSTEditorEvent& event)
{
    event.Skip();
    if (event.GetEventType() == wxEVT_STESHELL_ENTER)
    {
        // only bother to run it is it's not empty
        wxString str = event.GetString().Strip(wxString::both);
        if (!str.IsEmpty())
            RunString(str, false);
    }
}

void wxLuaShell::OnLua(wxLuaEvent &event)
{
    if (event.GetEventType() == wxEVT_LUA_PRINT)
    {
        AppendText(event.GetString() + wxT("\n"));
    }
    else if (event.GetEventType() == wxEVT_LUA_ERROR)
    {
        AppendText(wxT("\nError: ") + event.GetString() + wxT("\n"));
    }
}

void wxLuaShell::UpdateItems(wxMenu *menu, wxMenuBar *menuBar, wxToolBar *toolBar)
{
    bool is_running =  m_wxlState.Ok() && m_wxlState.IsRunning();

    wxSTEditorMenuManager::DoEnableItem(menu, menuBar, toolBar, ID_WXLUAIDE_RUN_LUA, !is_running);
    wxSTEditorMenuManager::DoEnableItem(menu, menuBar, toolBar, ID_WXLUAIDE_BREAK_LUA, is_running);
    wxSTEditorMenuManager::DoEnableItem(menu, menuBar, toolBar, ID_WXLUAIDE_SHOW_STACK, m_wxlState.Ok());

    wxSTEditor::UpdateItems(menu, menuBar, toolBar);
}

//-----------------------------------------------------------------------------
// wxLuaEditor
//-----------------------------------------------------------------------------
IMPLEMENT_ABSTRACT_CLASS(wxLuaEditor, wxSTEditor)

BEGIN_EVENT_TABLE(wxLuaEditor, wxSTEditor)
    EVT_STC_MARGINCLICK(wxID_ANY, wxLuaEditor::OnMarginClick)
    EVT_MENU(ID_WXLUAIDE_TOGGLE_BREAKPOINT, wxLuaEditor::OnMenu)
END_EVENT_TABLE()

void wxLuaEditor::Init()
{
    m_wxluaIDE = NULL;
}

bool wxLuaEditor::Create(wxWindow *parent, int id,
                         const wxPoint& pos, const wxSize& size,
                         long style, const wxString& name)
{
    if (!wxSTEditor::Create(parent, id, pos, size, style, name))
        return false;

    SetVisiblePolicy(wxSTC_VISIBLE_SLOP, 3);
    SetXCaretPolicy(wxSTC_CARET_SLOP, 10);
    SetYCaretPolicy(wxSTC_CARET_SLOP, 3);

    // click on margin to set breakpoint
    MarkerDefine(markerBreak, wxSTC_MARK_SMALLRECT,  *wxBLACK, *wxRED);
    MarkerDefine(markerError, wxSTC_MARK_SHORTARROW, *wxBLACK, *wxRED);

    SetMarginSensitive(marginBreak, true);
    SetMarginType(marginError, wxSTC_MARGIN_SYMBOL);
    SetMarginWidth(marginError, STC_DEF_MARGIN_WIDTH);
    //SetMarginMask(marginError, (1<<markerError)|(1<<markerBreak)|(1<<STE_BOOKMARK_MARKER));

    SetFileName(wxFileName(wxT("untitled.lua")));
    SetLanguage(wxFileName(wxT("untitled.lua")));
    return true;
}

void wxLuaEditor::OnMenu(wxCommandEvent& event)
{
    HandleMenuEvent(event);
}

bool wxLuaEditor::HandleMenuEvent(wxCommandEvent& event)
{
    int line = LineFromPosition(GetInsertionPoint());

    switch (event.GetId())
    {
        case ID_WXLUAIDE_TOGGLE_BREAKPOINT :
        {
            if (HasBreakpoint(line))
                DeleteBreakpoint(line);
            else
                AddBreakpoint(line);

            return true;
        }
    }

    return wxSTEditor::HandleMenuEvent(event);
}

void wxLuaEditor::OnMarginClick( wxStyledTextEvent &event )
{
    // unfortunately we can't get right or double clicks
    event.Skip();
    //int line = event.GetLine();   - not implemented
    //wxPrintf(wxT("Margin line %d %d %d %d %d\n"), line, event.GetLine(), MarkerGet(line), event.GetModifiers(), event.GetKey()); fflush(stdout);
}

bool wxLuaEditor::HasBreakpoint(int line)
{
    if (line < 0)
        return MarkerNext(markerBreak, 1<<markerBreak) >= 0;

    return (MarkerGet(line) & (1<<markerBreak)) != 0;
}
void wxLuaEditor::ClearBreakpoints()
{
    MarkerDeleteAll(markerBreak);
}
void wxLuaEditor::AddBreakpoint(int line)
{
    if ((line < 0) || (line > GetLineCount()) || HasBreakpoint(line))
        return;

    (void)MarkerAdd(line, markerBreak);
}
void wxLuaEditor::DeleteBreakpoint(int line)
{
    if (!HasBreakpoint(line))
        return;

    MarkerDelete(line, markerBreak);
}

void wxLuaEditor::UpdateItems(wxMenu *menu, wxMenuBar *menuBar, wxToolBar *toolBar)
{
    wxLuaState wxlState;
    if (GetwxLuaIDE())
        wxlState = GetwxLuaIDE()->GetwxLuaState();

    bool is_running =  wxlState.Ok() && wxlState.IsRunning();

    wxSTEditorMenuManager::DoEnableItem(menu, menuBar, toolBar, ID_WXLUAIDE_RUN_LUA, !is_running);
    wxSTEditorMenuManager::DoEnableItem(menu, menuBar, toolBar, ID_WXLUAIDE_BREAK_LUA, is_running);
    wxSTEditorMenuManager::DoEnableItem(menu, menuBar, toolBar, ID_WXLUAIDE_SHOW_STACK, wxlState.Ok() && !is_running);

    wxSTEditor::UpdateItems(menu, menuBar, toolBar);
}

//-----------------------------------------------------------------------------
// wxLuaIDE
//-----------------------------------------------------------------------------

IMPLEMENT_DYNAMIC_CLASS(wxLuaIDE, wxWindow);

BEGIN_EVENT_TABLE(wxLuaIDE, wxWindow)
    EVT_MENU                    (ID_WXLUAIDE_LOAD_LUA,   wxLuaIDE::OnMenu)
    EVT_MENU                    (ID_WXLUAIDE_SAVEAS_LUA, wxLuaIDE::OnMenu)
    EVT_MENU                    (ID_WXLUAIDE_RUN_LUA,    wxLuaIDE::OnMenu)
    EVT_MENU                    (ID_WXLUAIDE_BREAK_LUA,  wxLuaIDE::OnMenu)
    EVT_MENU                    (ID_WXLUAIDE_SHOW_STACK, wxLuaIDE::OnMenu)

    EVT_STSPLITTER_CREATE_EDITOR(wxID_ANY, wxLuaIDE::OnCreateEditor)
    EVT_SIZE                    (wxLuaIDE::OnSize)

    EVT_LUA_PRINT               (wxID_ANY, wxLuaIDE::OnLua)
    EVT_LUA_ERROR               (wxID_ANY, wxLuaIDE::OnLua)
    EVT_LUA_DEBUG_HOOK          (wxID_ANY, wxLuaIDE::OnLua)
END_EVENT_TABLE()

void wxLuaIDE::Init()
{
    m_wxlstate_static = false;

    m_splitter = NULL;
    m_editorNotebook = NULL;
    m_msgNotebook = NULL;
    m_luaOutput = NULL;
    m_luaShell = NULL;
    m_toolBar = NULL;

    m_options = 0;
    m_show_stack = false;
}

bool wxLuaIDE::Create( wxWindow *parent, int id,
                       const wxPoint& pos, const wxSize& size,
                       long style, long options, const wxString& name)
{
    m_options = options;

    if (!wxWindow::Create(parent, id, pos, size, style, name))
        return false;

    if ((m_options & WXLUAIDE_TOOLBAR) != 0)
    {
        m_toolBar = new wxToolBar(this, wxID_ANY, wxDefaultPosition, wxDefaultSize);
        PopulateToolBar(m_toolBar, m_options);
        wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_BREAK_LUA, false);
    }

    m_splitter = new wxSplitterWindow(this, wxID_ANY);

    // Create the editor notebook
    m_editorOptions = wxSTEditorOptions(STE_DEFAULT_OPTIONS);

    m_editorOptions.GetEditorPrefs().SetPrefBool(STE_PREF_VIEW_LINEMARGIN, true);
    m_editorOptions.GetEditorPrefs().SetPrefBool(STE_PREF_VIEW_MARKERMARGIN, true);
    m_editorOptions.SetToolBar(m_toolBar); // NULL is fine
    m_editorOptions.SetDefaultFileName(wxT("untitled.lua"));
    if (wxConfigBase::Get(false))
        m_editorOptions.LoadConfig(*wxConfigBase::Get(false));

    m_editorNotebook = new wxSTEditorNotebook(m_splitter, ID_WXLUAIDE_EDITOR_NOTEBOOK,
                        wxDefaultPosition, wxSize(200,100), wxCLIP_CHILDREN);
    m_editorNotebook->CreateOptions(m_editorOptions);
    m_editorNotebook->InsertEditorSplitter(-1, wxID_ANY, wxT("untitled.lua"), true);

    m_editorNotebook->GetEditor()->MarkerDefine(wxLuaEditor::markerBreak, wxSTC_MARK_SMALLRECT,  *wxBLACK, *wxRED);
    m_editorNotebook->GetEditor()->MarkerDefine(wxLuaEditor::markerError, wxSTC_MARK_SHORTARROW, *wxBLACK, *wxRED);

    wxMenu *wxluaMenu = CreatewxLuaMenu();
    m_editorOptions.GetEditorPopupMenu()->AppendSeparator();
    m_editorOptions.GetEditorPopupMenu()->Append(wxID_ANY, wxT("wxLua"), wxluaMenu);

    // -----------------------------------------------------------------------
    // Create the message notebook for shell and output window
    m_shellOptions.SetSplitterOptions(STS_NO_EDITOR);
    m_shellOptions.SetEditorStyles(m_editorOptions.GetEditorStyles());
    m_shellOptions.SetEditorLangs(m_editorOptions.GetEditorLangs());
    m_shellOptions.SetMenuManager(m_editorOptions.GetMenuManager(), true);
    m_shellOptions.SetEditorPopupMenu(wxSTEditorMenuManager(0, 0, STE_MENU_EDIT_CUTCOPYPASTE).CreateEditMenu(), false);
    m_shellOptions.SetToolBar(m_toolBar);
    m_msgNotebook = new wxSTEditorNotebook(m_splitter, ID_WXLUAIDE_MSG_NOTEBOOK,
                            wxDefaultPosition, wxDefaultSize, wxCLIP_CHILDREN);
    m_msgNotebook->CreateOptions(m_shellOptions);

    // -----------------------------------------------------------------------
    // Create the interactive lua shell
    wxSTEditorSplitter *steSplitter = new wxSTEditorSplitter(m_msgNotebook, wxID_ANY,
                                            wxDefaultPosition, wxDefaultSize, wxSP_3D);
    steSplitter->CreateOptions(m_shellOptions);

    m_luaShell = new wxLuaShell(steSplitter, ID_WXLUAIDE_SHELL, wxDefaultPosition,
                                wxDefaultSize, 0);
    m_luaShell->CreateOptions(m_shellOptions);
    m_luaShell->SetWrapMode(wxSTC_WRAP_WORD);
    m_luaShell->RecreatewxLuaState(m_luaShell->GetEventHandler(), m_luaShell->GetId());
    m_luaShell->CheckPrompt(true);
    steSplitter->Initialize(m_luaShell);
    m_msgNotebook->InsertEditorSplitter(-1, steSplitter, true);

    // -----------------------------------------------------------------------
    // Create the interactive lua shell for the output of the editor programs
    steSplitter = new wxSTEditorSplitter(m_msgNotebook, wxID_ANY,
                                    wxDefaultPosition, wxDefaultSize, wxSP_3D);
    steSplitter->CreateOptions(m_shellOptions);
    m_luaOutput = new wxLuaShell(steSplitter, ID_WXLUAIDE_OUTPUT_WIN,
                                    wxDefaultPosition, wxDefaultSize, 0);
    m_luaOutput->CreateOptions(m_shellOptions);
    steSplitter->Initialize(m_luaOutput);
    m_luaOutput->MarkerDeleteAll(wxLuaShell::markerPrompt);
    m_luaOutput->SetwxLuaState(m_wxlState, true);
    m_luaOutput->SetWrapMode(wxSTC_WRAP_NONE);
    m_luaOutput->SetFileName(wxFileName(wxT("Output")));


    m_msgNotebook->InsertEditorSplitter(-1, steSplitter, false);

    m_splitter->SetSashGravity(0.8); // let upper window grow more
    m_splitter->SetMinimumPaneSize(50);
    m_splitter->SplitHorizontally(m_editorNotebook, m_msgNotebook, GetClientSize().y/2);

    return true;
}

wxLuaIDE::~wxLuaIDE()
{
    if (m_wxlState.Ok())
        m_wxlState.CloseLuaState(true); // make sure all windows are destroyed

    m_wxlState.Destroy();
}

void wxLuaIDE::OnSize(wxSizeEvent& event)
{
    event.Skip();
    if (!m_splitter) return;

    wxSize clientSize(GetClientSize());
    int width  = clientSize.x;
    int height = clientSize.y;

    int h = 0;

    if (m_toolBar && (m_toolBar->GetParent() == this))
    {
        m_toolBar->SetSize(0, 1, width, -1); // y = 1 for wxGTK 2 at least
        h = m_toolBar->GetSize().y + 1;      // another +1 for bottom for wxGTK2
    }

    if (m_splitter)
    {
        m_splitter->SetSize(0, h, width, height-h);
        int sash = m_splitter->GetSashPosition();
        if ((sash < 50) || (sash > height - 50))
            m_splitter->SetSashPosition(wxMin(50, height/2));
    }
}

void wxLuaIDE::SetMenuBar(wxMenuBar *menuBar)
{
    m_shellOptions.SetMenuBar(menuBar);
    m_editorOptions.SetMenuBar(menuBar);

    if (menuBar && (menuBar->FindMenu(wxT("wxLua")) == wxNOT_FOUND))
    {
        wxMenu *wxluaMenu = CreatewxLuaMenu();
        int pos = menuBar->FindMenu(wxT("Help"));
        menuBar->Insert(pos, wxluaMenu, wxT("wx&Lua"));
    }

    if (!m_wxlState.Ok() || !m_wxlState.IsRunning())
        wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_BREAK_LUA, false);
}

void wxLuaIDE::SetToolBar(wxToolBar *toolBar)
{
    m_shellOptions.SetToolBar(toolBar);
    m_editorOptions.SetToolBar(toolBar);

    m_toolBar = toolBar;

    if (!m_wxlState.Ok() || !m_wxlState.IsRunning())
        wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_BREAK_LUA, false);
}

void wxLuaIDE::PopulateToolBar(wxToolBar *toolBar, long options) const
{
    bool add_sep = false;

    if ((options & WXLUAIDE_TB_FILE) != 0)
    {
        toolBar->AddTool( ID_WXLUAIDE_LOAD_LUA,   wxT("Open file"),  wxBitmap(open_xpm),   wxT("Open lua program") );
        toolBar->AddTool( ID_WXLUAIDE_SAVEAS_LUA, wxT("Save as..."), wxBitmap(save_xpm), wxT("Save lua program") );
        add_sep = true;
    }
    if ((options & WXLUAIDE_TB_LUA) != 0)
    {
        if (add_sep) toolBar->AddSeparator();

        toolBar->AddTool( ID_WXLUAIDE_RUN_LUA,    wxT("Run wxLua program"),  wxBitmap(play_xpm), wxT("Run the wxLua program in the current editor") );
        toolBar->AddTool( ID_WXLUAIDE_BREAK_LUA,  wxT("Stop wxLua program"), wxBitmap(stop_xpm), wxT("Stop the running wxLua program") );
        toolBar->AddSeparator();
        toolBar->AddTool( ID_WXLUAIDE_SHOW_STACK, wxT("Show stack tree"),    wxBitmap(LUA_xpm),  wxT("Show the lua stack tree") );
    }
    toolBar->Realize();
}

wxMenu* wxLuaIDE::CreatewxLuaMenu() const
{
    wxSTEditorMenuManager s;
    wxMenu *wxluaMenu = new wxMenu();
    wxluaMenu->Append(s.MenuItem(wxluaMenu, ID_WXLUAIDE_RUN_LUA,   wxT("&Run wxLua program\tCtrl+F5"),  wxT("Run the wxLua program in the current editor") , wxITEM_NORMAL, wxBitmap(play_xpm)));
    wxluaMenu->Append(s.MenuItem(wxluaMenu, ID_WXLUAIDE_BREAK_LUA, wxT("&Stop wxLua program\tShift+F5"), wxT("Stop the running wxLua program") , wxITEM_NORMAL, wxBitmap(stop_xpm)));
    wxluaMenu->AppendSeparator();
    wxluaMenu->Append(s.MenuItem(wxluaMenu, ID_WXLUAIDE_SHOW_STACK, wxT("Stack &tree"), wxT("Show the lua stack tree") , wxITEM_NORMAL, wxBitmap(LUA_xpm)));
    wxluaMenu->AppendSeparator();
    wxluaMenu->Append(ID_WXLUAIDE_TOGGLE_BREAKPOINT, wxT("Toggle &breakpoint\tF9"));
    return wxluaMenu;
}

void wxLuaIDE::SetwxLuaState(const wxLuaState& wxlState, bool is_static)
{
    if (m_wxlState.Ok() && !m_wxlstate_static)
    {
        // try to close it nicely first
        if (m_wxlState.IsRunning())
        {
            wxSafeYield();
            m_wxlState.DebugHookBreak();
        }

        m_wxlState.CloseLuaState(true); // force closing it since we own it
    }

    m_wxlState = wxlState;
    m_wxlstate_static = is_static;
}

bool wxLuaIDE::RecreatewxLuaState(wxEvtHandler *wxlStateEvtHandler, int win_id)
{
    // ask if anyone else wants to create a new wxLuaState for us
    wxLuaEvent event(wxEVT_LUAIDE_wxLUA_CREATION, GetId(), wxNullLuaState);
    event.SetEventObject(this);
    event.SetInt(0);
    event.SetExtraLong(win_id);

    // return if handled, but not skipped.
    if (GetEventHandler()->ProcessEvent(event))
        return false;

    // Did they set a valid interpreter for the event and is it new?
    // If it's not different then assume they didn't change it so we'll create
    // a new one below. If they wanted to just adjust the current state they
    // should have called event.Skip(false)
    if (event.GetwxLuaState().Ok())
    {
        SetwxLuaState(event.GetwxLuaState(), event.GetInt() == 1);
    }
    else
    {
        wxLuaState wxlState = wxLuaState(wxlStateEvtHandler, win_id);
        wxlState.SetLuaDebugHook( LUA_MASKCOUNT, 1000, 50, false );
        SetwxLuaState(wxlState, false);
    }

    return m_wxlState.Ok();
}

void wxLuaIDE::OnCreateEditor(wxCommandEvent &event)
{
    wxWindow *win = (wxWindow*)event.GetEventObject();
    wxLuaEditor *editor = new wxLuaEditor(win, event.GetInt(),
                                          wxDefaultPosition, wxDefaultSize, 0);
    editor->CreateOptions(m_editorOptions);
    editor->SetwxLuaIDE(this);
    event.SetEventObject(editor);
}

void wxLuaIDE::OnMenu(wxCommandEvent &event)
{
    //wxSTERecursionGuard guard(m_rGuard_OnMenu); can't have for BREAK
    //if (guard.IsInside()) return;

    if (!HandleMenuEvent(event))
        event.Skip();
}

bool wxLuaIDE::HandleMenuEvent(wxCommandEvent& event)
{
    //wxSTERecursionGuard guard(m_rGuard_HandleMenuEvent); can't have for BREAK
    //if (guard.IsInside()) return false;

    wxLuaEditor *editor = wxDynamicCast(m_editorNotebook->GetEditor(), wxLuaEditor);
    wxCHECK_MSG(editor, false, wxT("Invalid notebook page"));

    switch(event.GetId())
    {
        case ID_WXLUAIDE_LOAD_LUA :
        {
            wxFileName fn = editor->GetFileName();
            wxString filename, path;

            if (fn.IsOk())
            {
                path = fn.GetPath();
                filename = fn.GetFullName();
            }

            wxFileDialog dlg(this, wxT("Open file"), path, filename,
                             wxT("Lua (*.lua)|*.lua|Any file (*)|*"),
                             wxFD_OPEN|wxFD_FILE_MUST_EXIST);
            if (dlg.ShowModal() == wxID_OK)
            {
                filename = dlg.GetPath();

                if (!filename.IsEmpty())
                    editor->LoadFile(filename);
            }

            return true;
        }
        case ID_WXLUAIDE_SAVEAS_LUA :
        {
            editor->SaveFile(true);
            return true;
        }
        case ID_WXLUAIDE_RUN_LUA :
        {
            wxString program = editor->GetText();
            if (program.IsEmpty()) return true;

            if (m_wxlState.Ok())
            {
                if (m_wxlState.Ok())
                    m_wxlState.CloseLuaState(true);

                m_wxlState.Destroy(); // FIXME
                //wxCHECK_RET(m_wxlState.Destroy(), wxT("Can't destroy lua interpreter"));
            }

            // Fresh start!
            wxCHECK_MSG(RecreatewxLuaState(GetEventHandler(), editor->GetId()), true, wxT("Can't recreate lua interpreter"));

            wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_RUN_LUA, false);
            wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_BREAK_LUA, true);
            wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_SHOW_STACK, false);

            editor->MarkerDeleteAll(wxLuaEditor::markerError);
            wxString name = m_editorNotebook->GetPageText(m_editorNotebook->GetSelection());

            m_luaOutput->SetReadOnly(false);
            m_luaOutput->ClearAll();
            m_luaOutput->MarkerDeleteAll(wxLuaShell::markerPrompt);
            WriteMessage(m_luaOutput, wxT("Running lua script '") + name + wxT("' : ") + wxNow() + wxT("\n"));
            wxStopWatch stopWatch;
            //m_luaOutput->SetReadOnly(true);

            wxSafeYield(); // allow tools to adjust (sometimes necessary?)

            if (editor->GetFileName().IsOk())
            {
                wxFileName fn(editor->GetFileName());
                if (fn.FileExists())
                {
                    // ensure we have path of script added
                    // to LUA_PATH in case script calls require() with
                    // modules in same path as script
                    m_wxlState.AddLuaPath(fn);
                }
            }

            m_luaOutput->SetwxLuaState(m_wxlState, true);

            if (editor->HasBreakpoint(-1))
                m_wxlState.SetLuaDebugHook(LUA_MASKCALL|LUA_MASKRET|LUA_MASKLINE|LUA_MASKCOUNT, 1, 50, true);
            else
                m_wxlState.SetLuaDebugHook(LUA_MASKCALL|LUA_MASKRET|LUA_MASKLINE|LUA_MASKCOUNT, 1000, 100, false);

            m_luaOutput->SetReadOnly(true);
            editor->SetReadOnly(true);
            m_wxlState.RunString(program, name);
            editor->SetReadOnly(false);
            m_luaOutput->SetReadOnly(false);

            WriteMessage(m_luaOutput, wxT("End lua script : ") + wxNow() + wxT("\n"));
            WriteMessage(m_luaOutput, wxString::Format(wxT("Execution time : %.3lf(s)\n"), stopWatch.Time()/1000.0));

            m_luaOutput->CheckPrompt(true);

            wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_RUN_LUA, true);
            wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_BREAK_LUA, false);
            wxSTEditorMenuManager::DoEnableItem(NULL, GetMenuBar(), GetToolBar(), ID_WXLUAIDE_SHOW_STACK, true);

            return true;
        }
        case ID_WXLUAIDE_BREAK_LUA :
        {
            if (m_wxlState.Ok() && m_wxlState.IsRunning())
            {
                m_wxlState.DebugHookBreak(wxT("Interpreter stopped"));
            }
            else if (m_luaShell && m_luaShell->GetwxLuaState().Ok() && m_luaShell->GetwxLuaState().IsRunning())
            {
                m_luaShell->GetwxLuaState().DebugHookBreak(wxT("Interpreter stopped"));
            }

            return true;
        }
        case ID_WXLUAIDE_SHOW_STACK :
        {
            m_show_stack = true;
            // don't want recursive wxYields if some other interpreter is running
            bool err = true;

            wxLuaState  wxlState;
            wxLuaShell *luaShell  = NULL;

            if (m_msgNotebook->GetSelection() == 0)
            {
                wxlState = m_luaShell ? m_luaShell->GetwxLuaState() : wxNullLuaState;
                luaShell  = m_luaShell;
            }
            else
            {
                wxlState = m_wxlState;
                luaShell = m_luaOutput;
            }

            if (luaShell && wxlState.Ok())
            {
                int  hook_count = wxlState.GetLuaDebugHookCount();
                int  hook_yield = wxlState.GetLuaDebugHookYield();
                bool hook_send  = wxlState.GetLuaDebugHookSendEvt();
                int  hook_mask  = wxlState.GetLuaDebugHook();

                wxlState.SetLuaDebugHook(LUA_MASKCALL|LUA_MASKRET|LUA_MASKLINE|LUA_MASKCOUNT, 1, -1, true);
                wxlState.RunString(wxT("print(\"Showing stack\")"));
                wxlState.SetLuaDebugHook(hook_mask, hook_count, hook_yield, hook_send);
                luaShell->CheckPrompt(true);
                err = false;
            }

            if (err)
                wxMessageBox(wxT("Invalid lua interpreter."), wxT("Error showing stack"), wxOK, this);

            return true;

        }
        default : break;
    }

    return editor->HandleMenuEvent(event);
}

void wxLuaIDE::OnLua(wxLuaEvent &event)
{
    wxLuaShell *outEditor = NULL;

    if (event.GetwxLuaState() == m_luaShell->GetwxLuaState())
        outEditor = m_luaShell;
    else //if (event.GetwxLuaState() == m_wxlState) FIXME coroutines have own wxlStateRefData
        outEditor = m_luaOutput;

    OutputLuaEvent(event, outEditor);
}

void wxLuaIDE::OutputLuaEvent(wxLuaEvent &event, wxLuaShell *outEditor)
{
    // perhaps there was an error at startup, but editor isn't created yet
    if (outEditor == NULL)
        return;

    if (event.GetEventType() == wxEVT_LUA_DEBUG_HOOK)
    {
        if (m_show_stack)
        {
            wxLuaStackDialog StackDialog(event.GetwxLuaState(), this);
            StackDialog.ShowModal();
            m_show_stack = false;
        }
        else if (event.GetwxLuaState() == m_wxlState)
        {
            wxLuaEditor *editor = wxDynamicCast(m_editorNotebook->FindWindow(event.GetId()), wxLuaEditor);
            //wxCHECK_RET(editor, wxT("Invalid notebook page"));
            if (editor != NULL)
            {
                int line = event.GetLineNum();
                // The line is -1 within the require("wx") function
                if ((line >= 0) && editor->HasBreakpoint(line-1))
                    m_wxlState.DebugHookBreak(wxString::Format(wxT("Stopped at breakpoint, line: %d"), line));
            }
        }
    }
    else if (event.GetEventType() == wxEVT_LUA_PRINT)
    {
        WriteMessage(outEditor, event.GetString() + wxT("\n"));
    }
    else if (event.GetEventType() == wxEVT_LUA_ERROR)
    {
        WriteMessage(outEditor, wxT("\nError: ") + event.GetString() + wxT("\n"));

        int line = event.GetLineNum();

        // the user generated an error from running something in the shell
        if (event.GetString().Find(wxT("[string \"wxLuaShell\"]")) != wxNOT_FOUND)
            line = -1;

        // Put a marker where the error occurred
        if ((line >= 0) && (event.GetwxLuaState() == m_wxlState))
        {
            wxLuaEditor *editor = wxDynamicCast(m_editorNotebook->FindWindow(event.GetId()), wxLuaEditor);
            //wxCHECK_RET(editor, wxT("Invalid notebook page"));
            if (editor != NULL)
            {
                editor->MarkerDeleteAll(wxLuaEditor::markerError);
                editor->MarkerAdd(line-1, wxLuaEditor::markerError);
                editor->GotoLine(line-1);
                editor->EnsureCaretVisible();
            }
        }
    }
}

void wxLuaIDE::WriteMessage(wxLuaShell *outputWin, const wxString& str)
{
    wxCHECK_RET(outputWin, wxT("Invalid wxLuaShell to write message to."));

    // try to turn the message notebook page to show the message
    if (m_msgNotebook)
    {
        int sel = m_msgNotebook->GetSelection();
        if ((outputWin->GetId() == ID_WXLUAIDE_SHELL) && (sel != 0))
            m_msgNotebook->SetSelection(0);
        if ((outputWin->GetId() == ID_WXLUAIDE_OUTPUT_WIN) && (sel != 1))
            m_msgNotebook->SetSelection(1);
    }

/*
    if (m_msgNotebook)
    {
        // the parent of the wxLuaShell is probably a splitter
        wxWindow* win = outputWin;
        while (win->GetParent() && (win->GetParent() != m_msgNotebook))
            win = win->GetParent();

        int sel = m_msgNotebook->GetSelection();
        if (win && ((sel < 0) || (m_msgNotebook->GetPage(sel) != win)))
        {
            int n, count = m_msgNotebook->GetPageCount();

            for (n = 0; n < count; n++)
            {
                if ((n != sel) && (m_msgNotebook->GetPage(n) == win))
                {
                    m_msgNotebook->SetSelection(n);
                    break;
                }
            }
        }
    }
*/

    outputWin->AppendText(str);
}
