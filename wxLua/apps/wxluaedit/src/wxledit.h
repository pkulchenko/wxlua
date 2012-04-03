/////////////////////////////////////////////////////////////////////////////
// Name:        wxledit.h
// Purpose:     A shell, editor and IDE widget for wxLua
// Author:      John Labenski
// Modified by:
// Created:     11/05/2002
// Copyright:   (c) John Labenski
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#ifndef _WX_LUAEDITOR_H_
#define _WX_LUAEDITOR_H_

#include "wxlua/include/wxlstate.h"

class WXDLLIMPEXP_FWD_CORE wxMenu;
class WXDLLIMPEXP_FWD_CORE wxKeyEvent;
class WXDLLIMPEXP_FWD_CORE wxNotebook;
class WXDLLIMPEXP_FWD_CORE wxSplitterWindow;
class WXDLLIMPEXP_FWD_CORE wxToolBar;
class WXDLLIMPEXP_FWD_WXLUA wxLuaState;
class WXDLLIMPEXP_FWD_WXLUA wxLuaEvent;
class wxLuaIDE;

// Note: If you get a compilation error on the next two lines you need to
//   specify the #include path to the wxStEdit project that's part of wxCode.
#include "wx/stedit/stedit.h"
#include "wx/stedit/steshell.h"

// For non-Unix systems (i.e. when building without a configure script),
// we use the following macro to do a compile-time check of wxLuaEdit version
#if !defined(wxCHECK_STE_VERSION)
    #error "wxStEdit version is too old, need at least version 1.2.5"
#endif
#if !wxCHECK_STE_VERSION(1, 6, 0)
    #error "wxStEdit version is too old, need at least version 1.6.0"
#endif

//-----------------------------------------------------------------------------

enum
{
    // buttons
    ID_WXLUAIDE_LOAD_LUA = ID_STE__LAST + 1,
    ID_WXLUAIDE_SAVEAS_LUA,
    ID_WXLUAIDE_RUN_LUA,
    ID_WXLUAIDE_BREAK_LUA,
    ID_WXLUAIDE_SHOW_STACK,

    ID_WXLUAIDE_TOGGLE_BREAKPOINT,

    // windows
    ID_WXLUAIDE_EDITOR_NOTEBOOK,
    ID_WXLUAIDE_MSG_NOTEBOOK,
    ID_WXLUAIDE_SHELL,
    ID_WXLUAIDE_OUTPUT_WIN,

    ID_WXLUAIDE__LAST
};

//-----------------------------------------------------------------------------
// Events for the wxLuaShell and wxLuaIDE when a wxLua interpreter is
// being created. You may intercept this event to adjust or run strings
// to finish creating the wxLua interpreter.
//
// EVT_LUASHELL_wxLUA_CREATION(id, wxLuaEvent& fn)
// EVT_LUAIDE_wxLUA_CREATION(id, wxLuaEvent& fn)
//-----------------------------------------------------------------------------

BEGIN_DECLARE_EVENT_TYPES()
    DECLARE_LOCAL_EVENT_TYPE(wxEVT_LUASHELL_wxLUA_CREATION, 7000)
    DECLARE_LOCAL_EVENT_TYPE(wxEVT_LUAIDE_wxLUA_CREATION,   7001)
END_DECLARE_EVENT_TYPES()

#define EVT_LUASHELL_wxLUA_CREATION(id, fn) wx__DECLARE_WXLUAEVT(wxEVT_LUASHELL_wxLUA_CREATION, id, fn)
#define EVT_LUAIDE_wxLUA_CREATION(id, fn)   wx__DECLARE_WXLUAEVT(wxEVT_LUAIDE_wxLUA_CREATION,   id, fn)

//-----------------------------------------------------------------------------
// wxLuaShell - a basic console type interactive interpreter widget
//-----------------------------------------------------------------------------

class wxLuaShell : public wxSTEditorShell
{
public :
    wxLuaShell() : wxSTEditorShell() { Init(); }

    wxLuaShell(wxWindow *parent, wxWindowID id,
               const wxPoint& pos = wxDefaultPosition,
               const wxSize& size = wxDefaultSize,
               long style = 0,
               const wxString& name = wxT("wxLuaShell")) : wxSTEditorShell()
    {
        Init();
        Create(parent, id, pos, size, style, name);
    }

    bool Create(wxWindow *parent, wxWindowID id,
                const wxPoint& pos = wxDefaultPosition,
                const wxSize& size = wxDefaultSize,
                long style = 0,
                const wxString& name = wxT("wxLuaShell"));

    virtual ~wxLuaShell();

    // Get the interpreter this shell uses
    wxLuaState GetwxLuaState() const { return m_wxlState; }
    // Set this shell to use another interpreter, will close it if !is_static
    virtual void SetwxLuaState(const wxLuaState& wxlState, bool is_static);
    // RecreatewxLuaState - Used to create/recreate local interpreter
    //   Can be subclassed to use your own interpreter derived from a wxLuaState.
    //
    // Using a customized wxLuaState by handling wxEVT_LUASHELL_wxLUA_CREATION event:
    //   The RecreatewxLuaState function sends a wxLuaEvent with this control's id
    //   in GetId(), *this as the GetEventObject(), and the preferred window ID
    //   for the new wxLuaState in event.GetExtraLong() (typically wxID_ANY) and
    //   the current wxLuaState in GetwxLuaState().
    //
    //   Your wxEVT_LUASHELL_wxLUA_CREATION event handler can set the new wxLuaState
    //   by calling event.SetwxLuaState(wxLuaState(...))
    //   and event.SetInt(1 for static interpreter or 0 for not static), where
    //   static means that the wxLuaShell will not close the wxLuaState on exit.
    //   You'll probably want to set the new wxLuaState's eventhandler and id
    //   to that of this window so this can handle the events.
    //
    //   If the event is skipped or not handled the RecreatewxLuaState function
    //   will call SetLuaIntpreter(event.GetLuaInterpreter(), event.GetInt() == 1)
    //   if the event's wxLuaState is valid. You can Skip(false) the event to
    //   not have the wxLuaState recreated at all.
    virtual bool RecreatewxLuaState(wxEvtHandler *wxlStateEvtHandler, int win_id);

    // Run a string, append the string to the editor control if append_text
    bool RunString(const wxString& string, bool append_text = false);

    // implementation
    void OnSTEEvent(wxSTEditorEvent& event);
    void OnLua(wxLuaEvent& event);

    virtual void UpdateItems(wxMenu *menu, wxMenuBar *menuBar, wxToolBar *toolBar);

protected:
    wxLuaState m_wxlState;
    bool m_wxlstate_static;

private:
    void Init();
    DECLARE_EVENT_TABLE();
    DECLARE_ABSTRACT_CLASS(wxLuaShell);
};

//-----------------------------------------------------------------------------
// wxLuaEditor - a notebook page for editing a lua program
//-----------------------------------------------------------------------------

class wxLuaEditor : public wxSTEditor
{
public :
    wxLuaEditor() : wxSTEditor() { Init(); }

    wxLuaEditor(wxWindow *parent, wxWindowID id,
                const wxPoint& pos = wxDefaultPosition,
                const wxSize& size = wxDefaultSize,
                long style = 0,
                const wxString& name = wxT("wxLuaEditor")) : wxSTEditor()
    {
        Init();
        Create(parent, id, pos, size, style, name);
    }

    bool Create(wxWindow *parent, wxWindowID id,
                const wxPoint& pos = wxDefaultPosition,
                const wxSize& size = wxDefaultSize,
                long style = 0,
                const wxString& name = wxT("wxLuaEditor"));

    virtual ~wxLuaEditor() {}

    wxLuaIDE* GetwxLuaIDE() const { return m_wxluaIDE; }
    void SetwxLuaIDE(wxLuaIDE* wxluaIDE) { m_wxluaIDE = wxluaIDE; }

    enum mark_Type
    {
        marginError = STE_MARGIN_MARKER,
        marginBreak = STE_MARGIN_MARKER,

        markerError = STE_MARKER__MAX,
        markerBreak
    };

    void ClearBreakpoints();
    bool HasBreakpoint(int line); // if line = -1 means has any breakpoints
    void AddBreakpoint(int line);
    void DeleteBreakpoint(int line);

    // implementation
    void OnMenu(wxCommandEvent& event);
    virtual bool HandleMenuEvent(wxCommandEvent& event);

    void OnMarginClick( wxStyledTextEvent &event );

    virtual void UpdateItems(wxMenu *menu, wxMenuBar *menuBar, wxToolBar *toolBar);

protected:
    wxLuaIDE* m_wxluaIDE;

private:
    void Init();
    DECLARE_EVENT_TABLE();
    DECLARE_ABSTRACT_CLASS(wxLuaEditor);
};

//-----------------------------------------------------------------------------
// wxLuaIDE - toolbar at the top for open/save/run/stop lua programs
//            notebook with editors for editing lua programs
//            notebook with a console and an output window for above editors
//-----------------------------------------------------------------------------

enum wxLuaIDE_Styles
{
    WXLUAIDE_TB_FILE = 0x0001, // Add Open/Save items in PopulateToolBar
    WXLUAIDE_TB_LUA  = 0x0002, // Add Run/Stop/Stack Dlg in PopulateToolBar
    WXLUAIDE_TOOLBAR = WXLUAIDE_TB_FILE|WXLUAIDE_TB_LUA,
    WXLUAIDE_DEFAULT = WXLUAIDE_TOOLBAR
};

class wxLuaIDE : public wxWindow
{
public:
    wxLuaIDE() : wxWindow() { Init(); }
    wxLuaIDE( wxWindow *parent, wxWindowID id,
              const wxPoint& pos = wxDefaultPosition,
              const wxSize& size = wxDefaultSize,
              long style = 0,
              long options = WXLUAIDE_DEFAULT,
              const wxString& name = wxT("wxLuaIDE")) : wxWindow()
    {
        Init();
        Create(parent, id, pos, size, style, options, name);
    }

    bool Create( wxWindow *parent, wxWindowID id,
                 const wxPoint& pos = wxDefaultPosition,
                 const wxSize& size = wxDefaultSize,
                 long style = 0,
                 long options = WXLUAIDE_DEFAULT,
                 const wxString& name = wxT("wxLuaIDE"));

    virtual ~wxLuaIDE();

    // Get the interpreter this shell uses
    wxLuaState GetwxLuaState() const { return m_wxlState; }
    // Set this shell to use another interpreter, will delete it if !is_static
    //   note shell has built in function
    void SetwxLuaState(const wxLuaState& wxlState, bool is_static);
    // Used to create/recreate local interpreter
    //   Can be subclassed to use your own interpreter derived from a wxLuaState
    //   or a new interpreter can be set by catching the EVT_LUAIDE_wxLUA_CREATION
    //   wxLuaEvent that's sent with this control's id and *this as the GetEventObject
    //   the preferred window ID is in event.GetExtraLong()
    //   if you call event.SetLuaInterpreter(wxLuaState(...))
    //   and event.SetInt(1 for static interpreter or 0 for not static)
    //   then SetLuaIntpreter(event.GetLuaInterpreter(), event.GetInt() == 1)
    //   is called. You'll probably want to set the lua interpreter's eventhandler
    //   to this as well as it's win id
    virtual bool RecreatewxLuaState(wxEvtHandler *wxlStateEvtHandler, int win_id);

    // Direct the string output of the wxLuaEvent to the given wxLuaShell
    virtual void OutputLuaEvent(wxLuaEvent &event, wxLuaShell *outputWin);

    // Write the string to the given shell and make it visible if it's in the
    //   GetMsgNotebook.
    virtual void WriteMessage(wxLuaShell *outputWin, const wxString& str);

    // Get or adjust the child windows of this control
    wxSplitterWindow *GetSplitterWin() const { return m_splitter; }
    wxSTEditorNotebook *GetEditorNotebook() const { return m_editorNotebook; }
    wxSTEditorNotebook *GetMsgNotebook() const { return m_msgNotebook; }
    wxLuaShell *GetLuaOutputWin() const { return m_luaOutput; }
    wxLuaShell *GetLuaShellWin() const { return m_luaShell; }

    // doesn't take ownership of the menubar, updates it when focused
    void SetMenuBar(wxMenuBar *menuBar);
    wxMenuBar* GetMenuBar() const { return m_editorOptions.GetMenuBar(); } // may be NULL
    // doesn't take ownership of the toolbar, updates it when focused
    void SetToolBar(wxToolBar *toolbar);
    wxToolBar *GetToolBar() const { return m_editorOptions.GetToolBar(); } // may be NULL
    // add our own tools to the toolbar, see WXLUAIDE_TB_FILE, WXLUAIDE_TB_LUA
    void PopulateToolBar(wxToolBar *toolBar, long options = WXLUAIDE_TOOLBAR) const;
    // create a "new" wxMenu to add to the menubar and popupmenu
    wxMenu* CreatewxLuaMenu() const;

    // implementation
    void OnMenu(wxCommandEvent &event);
    virtual bool HandleMenuEvent(wxCommandEvent& event);
    void OnLua(wxLuaEvent &event);
    void OnSize(wxSizeEvent& event);
    void OnCreateEditor(wxCommandEvent &event);

protected:

    wxLuaState m_wxlState;
    bool m_wxlstate_static;

    wxSplitterWindow   *m_splitter;       // left/right splitter sidebar/notebook
    wxSTEditorNotebook *m_editorNotebook;
    wxSTEditorNotebook *m_msgNotebook;    // bottom
    wxLuaShell         *m_luaOutput;      // output of the editor program + shell
    wxLuaShell         *m_luaShell;       // user interactive shell
    wxToolBar          *m_toolBar;        // a toolbar that is a child of this
    wxSTEditorOptions   m_editorOptions;
    wxSTEditorOptions   m_shellOptions;

    long m_options;

    wxSTERecursionGuardFlag m_rGuard_OnMenu;
    wxSTERecursionGuardFlag m_rGuard_HandleMenuEvent;

private:
    bool m_show_stack;
    void Init();

    DECLARE_EVENT_TABLE();
    DECLARE_DYNAMIC_CLASS(wxLuaIDE);
};

#endif  // _WX_LUAEDITOR_H_
