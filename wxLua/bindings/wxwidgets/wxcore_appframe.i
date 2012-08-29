// ===========================================================================
// Purpose:     wxApp and wxFrame
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================


// ---------------------------------------------------------------------------
// wxApp

%if wxLUA_USE_wxApp

%include "wx/app.h"

// %override wxApp* wxGetApp()
// C++ func: wxApp* wxGetApp() - use wxTheApp* since this requires IMPLEMENT_APP()
%function wxApp* wxGetApp()

%class wxApp, wxEvtHandler
    // wxApp() NO CONSTRUCTOR! the wxApp is created in C++, use wxGetApp()

    // These two are pushed into Lua by C++ at startup as table arg = { argv }
    // int wxApp::argc
    // wxChar** wxApp::argv

    //!%wxchkver_2_6|%wxcompat_2_4 virtual wxLog* CreateLogTarget()
    void Dispatch()
    void ExitMainLoop()
    // virtual int FilterEvent(wxEvent& event) too dangerous, use ConnectEvent
    wxString GetAppName() const
    //!%wxchkver_2_6&%win bool GetAuto3D() const
    wxString GetClassName() const
    bool GetExitOnFrameDelete() const
    // static wxAppConsole *GetInstance() FIXME
    wxWindow* GetTopWindow() const
    bool GetUseBestVisual() const
    wxString GetVendorName() const
    bool IsActive() const
    static bool IsMainLoopRunning()
    // bool Initialized() obsolete in wxWidgets

    // %override int wxApp::MainLoop()
    // C++ Func: int MainLoop()
    // Only calls it if (!IsMainLoopRuinning() && !wxLuaState::sm_wxAppMainLoop_will_run), returns 0 if not called.
    int MainLoop()

    // virtual int OnExit() nothing we can do here
    // virtual bool OnInit() nothing we can do here
    // virtual int OnRun() nothing we can do here
    bool Pending()
    // !%wxchkver_2_6 bool SendIdleEvents()
    %wxchkver_2_6 && !%wxchkver_2_9_2 bool SendIdleEvents(wxWindow* win, wxIdleEvent& event)
    void SetAppName(const wxString& name)
    //!%wxchkver_2_4&(%win|%mac) void SetAuto3D(const bool auto3D)
    void SetClassName(const wxString& name)
    void SetExitOnFrameDelete(bool flag)
    // static void SetInstance(wxAppConsole* app) nothing we can do here
    void SetTopWindow(wxWindow* window)
    void SetVendorName(const wxString& name)
    //virtual wxIcon GetStdIcon(int which) const
    void SetUseBestVisual(bool flag)
%endclass

%endif //wxLUA_USE_wxApp

// ---------------------------------------------------------------------------
// wxTopLevelWindow

%if wxLUA_USE_wxFrame|wxLUA_USE_wxDialog

%include "wx/toplevel.h"

%enum
    wxUSER_ATTENTION_INFO
    wxUSER_ATTENTION_ERROR
%endenum

%enum
    wxFULLSCREEN_NOMENUBAR
    wxFULLSCREEN_NOTOOLBAR
    wxFULLSCREEN_NOSTATUSBAR
    wxFULLSCREEN_NOBORDER
    wxFULLSCREEN_NOCAPTION
    wxFULLSCREEN_ALL
%endenum

%class wxTopLevelWindow, wxWindow
    // No constructors, virtual base class, use wxFrame or wxDialog

    bool CanSetTransparent()
    bool EnableCloseButton(bool enable = true)
    %wxchkver_2_8 wxWindow* GetDefaultItem() const
    wxIcon GetIcon() const
    //const wxIconBundle& GetIcons() const
    wxString GetTitle() const
    %wxchkver_2_8 wxWindow* GetTmpDefaultItem() const
    bool IsActive() const
    bool IsAlwaysMaximized() const
    void Iconize(bool iconize)
    bool IsFullScreen() const
    bool IsIconized() const
    bool IsMaximized() const
    void Maximize(bool maximize)
    void RequestUserAttention(int flags = wxUSER_ATTENTION_INFO)
    %wxchkver_2_8 wxWindow* SetDefaultItem(wxWindow *win)
    void SetIcon(const wxIcon& icon)
    void SetIcons(const wxIconBundle& icons)
    //void SetLeftMenu(int id = wxID_ANY, const wxString& label = wxEmptyString, wxMenu * subMenu = NULL) // for phones
    //void SetRightMenu(int id = wxID_ANY, const wxString& label = wxEmptyString, wxMenu * subMenu = NULL)
    void SetMaxSize(const wxSize& size)
    void SetMinSize(const wxSize& size)
    void SetSizeHints(int minW, int minH, int maxW=-1, int maxH=-1, int incW=-1, int incH=-1)
    void SetSizeHints(const wxSize& minSize, const wxSize& maxSize=wxDefaultSize, const wxSize& incSize=wxDefaultSize)
    bool SetShape(const wxRegion& region)
    virtual void SetTitle(const wxString& title)
    virtual bool SetTransparent(int alpha)
    //virtual bool ShouldPreventAppExit() const // must be overridden
    %wxchkver_2_8 wxWindow* SetTmpDefaultItem(wxWindow *win)
    bool ShowFullScreen(bool show, long style = wxFULLSCREEN_ALL)
%endclass

%endif //wxLUA_USE_wxFrame|wxLUA_USE_wxDialog

// ---------------------------------------------------------------------------
// wxFrame

%if wxLUA_USE_wxFrame

%include "wx/frame.h"

%define wxDEFAULT_FRAME_STYLE
%define wxICONIZE
%define wxCAPTION
%define wxMINIMIZE
%define wxMINIMIZE_BOX
%define wxMAXIMIZE
%define wxMAXIMIZE_BOX
%wxchkver_2_6 %define wxCLOSE_BOX
%define wxSTAY_ON_TOP
%define wxSYSTEM_MENU
//%define wxSIMPLE_BORDER see wxWindow defines
%define wxRESIZE_BORDER

%define wxFRAME_TOOL_WINDOW
%define wxFRAME_NO_TASKBAR
%define wxFRAME_FLOAT_ON_PARENT
%define wxFRAME_EX_CONTEXTHELP
%wxchkver_2_6 %define wxFRAME_SHAPED
%wxchkver_2_6 %define wxFRAME_EX_METAL
// %define wxTHICK_FRAME %wxcompat_2_6 use %wxchkver_2_6

%class wxFrame, wxTopLevelWindow
    wxFrame()
    wxFrame(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxFrame")
    bool Create(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxFrame")

    // void Centre(int direction = wxBOTH) - see wxWindow
    virtual wxStatusBar* CreateStatusBar(int number = 1, long style = 0, wxWindowID id = wxID_ANY, const wxString& name = "wxStatusBar")
    virtual wxToolBar* CreateToolBar(long style = wxNO_BORDER|wxTB_HORIZONTAL, wxWindowID id = wxID_ANY, const wxString& name = "wxToolBar")
    wxPoint GetClientAreaOrigin() const
    wxMenuBar* GetMenuBar() const
    wxStatusBar* GetStatusBar() const
    int GetStatusBarPane()
    wxToolBar* GetToolBar() const

    %wxchkver_2_4 void ProcessCommand(int id)
    //!%wxchkver_2_4 void Command(int id)

    void SendSizeEvent()
    void SetMenuBar(wxMenuBar* menuBar)
    void SetStatusBar(wxStatusBar* statusBar)
    void SetStatusBarPane(int n)
    virtual void SetStatusText(const wxString& text, int number = 0)

    // void wxFrame::SetStatusWidths(Lua table with number indexes and values)
    // C++ Func: virtual void SetStatusWidths(int n, int *widths)
    virtual void SetStatusWidths(IntArray_FromLuaTable intTable)

    void SetToolBar(wxToolBar* toolBar)
%endclass

// ---------------------------------------------------------------------------
// wxMiniFrame

%if wxLUA_USE_wxMiniFrame

%include "wx/minifram.h"

%define wxTINY_CAPTION_HORIZ
%define wxTINY_CAPTION_VERT

%class wxMiniFrame, wxFrame
    wxMiniFrame()
    wxMiniFrame(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxMiniFrame")
    bool Create(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxMiniFrame")

%endclass

%endif //wxLUA_USE_wxMiniFrame
%endif //wxLUA_USE_wxFrame

// ---------------------------------------------------------------------------
// wxStatusBar

%if wxLUA_USE_wxStatusBar && wxUSE_STATUSBAR

%include "wx/statusbr.h"

%define wxST_SIZEGRIP
%define wxSB_NORMAL
%define wxSB_FLAT
%define wxSB_RAISED

%class wxStatusBar, wxWindow
    wxStatusBar()
    wxStatusBar(wxWindow* parent, wxWindowID id, long style = wxST_SIZEGRIP, const wxString& name = "wxStatusBar")
    bool Create(wxWindow *parent, wxWindowID id, long style = wxST_SIZEGRIP, const wxString& name = "wxStatusBar")

    virtual bool GetFieldRect(int i, wxRect& rect) const
    int GetFieldsCount() const
    virtual wxString GetStatusText(int ir = 0) const
    void PopStatusText(int field = 0)
    void PushStatusText(const wxString& string, int field = 0)

    // %override void wxStatusBar::SetFieldsCount(either a single number or a Lua table with number indexes and values)
    // C++ Func: virtual void SetFieldsCount(int number = 1, int* widths = NULL)
    virtual void SetFieldsCount(LuaTable intTable)

    void SetMinHeight(int height)
    virtual void SetStatusText(const wxString& text, int i = 0)

    // void wxStatusBar::SetStatusWidths(Lua table with number indexes and values)
    // C++ Func: virtual void SetStatusWidths(int n, int *widths)
    virtual void SetStatusWidths(IntArray_FromLuaTable intTable)

    // void wxStatusBar::SetStatusStyles(Lua table with number indexes and values)
    // C++ Func: virtual void SetStatusStyles(int n, int *styles)
    virtual void SetStatusStyles(IntArray_FromLuaTable intTable)

%endclass

%endif //wxLUA_USE_wxStatusBar && wxUSE_STATUSBAR
