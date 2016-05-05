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

#if wxLUA_USE_wxApp

#include "wx/app.h"

wxApp* wxGetApp(); // %override wxApp* wxGetApp();

class wxApp : public wxEvtHandler
{
    void Dispatch();
    void ExitMainLoop();
    wxString GetAppName() const;
    wxString GetClassName() const;
    bool GetExitOnFrameDelete() const;
    wxWindow* GetTopWindow() const;
    bool GetUseBestVisual() const;
    wxString GetVendorName() const;
    bool IsActive() const;
    static bool IsMainLoopRunning();

    int MainLoop(); // %override int wxApp::MainLoop();

    bool Pending();
    %wxchkver_2_6 && !%wxchkver_2_9_2 bool SendIdleEvents(wxWindow* win, wxIdleEvent& event);
    void SetAppName(const wxString& name);
    void SetClassName(const wxString& name);
    void SetExitOnFrameDelete(bool flag);
    void SetTopWindow(wxWindow* window);
    void SetVendorName(const wxString& name);
    void SetUseBestVisual(bool flag);
};

#endif //wxLUA_USE_wxApp

// ---------------------------------------------------------------------------
// wxTopLevelWindow

#if wxLUA_USE_wxFrame|wxLUA_USE_wxDialog

#include "wx/toplevel.h"

enum
{
    wxUSER_ATTENTION_INFO,
    wxUSER_ATTENTION_ERROR
};

enum
{
    wxFULLSCREEN_NOMENUBAR,
    wxFULLSCREEN_NOTOOLBAR,
    wxFULLSCREEN_NOSTATUSBAR,
    wxFULLSCREEN_NOBORDER,
    wxFULLSCREEN_NOCAPTION,
    wxFULLSCREEN_ALL
};

class wxNonOwnedWindow : public wxWindow
{
    // bool SetShape(const wxGraphicsPath& path); // skip for too many dependencies on wxGraphicsPath
};

class wxTopLevelWindow : public wxNonOwnedWindow
{
    bool CanSetTransparent();
    bool EnableCloseButton(bool enable = true);
    %wxchkver_2_8 wxWindow* GetDefaultItem() const;
    wxIcon GetIcon() const;
    wxString GetTitle() const;
    %wxchkver_2_8 wxWindow* GetTmpDefaultItem() const;
    bool IsActive() const;
    bool IsAlwaysMaximized() const;
    void Iconize(bool iconize);
    bool IsFullScreen() const;
    bool IsIconized() const;
    bool IsMaximized() const;
    void Maximize(bool maximize);
    void RequestUserAttention(int flags = wxUSER_ATTENTION_INFO);
    %wxchkver_2_8 wxWindow* SetDefaultItem(wxWindow *win);
    void SetIcon(const wxIcon& icon);
    void SetIcons(const wxIconBundle& icons);
    void SetMaxSize(const wxSize& size);
    void SetMinSize(const wxSize& size);
    void SetSizeHints(int minW, int minH, int maxW=-1, int maxH=-1, int incW=-1, int incH=-1);
    void SetSizeHints(const wxSize& minSize, const wxSize& maxSize=wxDefaultSize, const wxSize& incSize=wxDefaultSize);
    bool SetShape(const wxRegion& region);
    virtual void SetTitle(const wxString& title);
    virtual bool SetTransparent(int alpha);
    // virtual bool ShouldPreventAppExit() const; // must be overridden
    // static void UseNativeDecorationsByDefault(bool native = true); // skip wxUniv method
    // void UseNativeDecorations(bool native = true); // skip wxUniv method
    // bool IsUsingNativeDecorations() const; // skip wxUniv method
    %wxchkver_2_8 wxWindow* SetTmpDefaultItem(wxWindow *win);
    bool ShowFullScreen(bool show, long style = wxFULLSCREEN_ALL);
};

#endif //wxLUA_USE_wxFrame|wxLUA_USE_wxDialog

// ---------------------------------------------------------------------------
// wxFrame

#if wxLUA_USE_wxFrame

#include "wx/frame.h"

#define wxDEFAULT_FRAME_STYLE
#define wxICONIZE
#define wxCAPTION
#define wxMINIMIZE
#define wxMINIMIZE_BOX
#define wxMAXIMIZE
#define wxMAXIMIZE_BOX
%wxchkver_2_6 #define wxCLOSE_BOX
#define wxSTAY_ON_TOP
#define wxSYSTEM_MENU
//#define wxSIMPLE_BORDER see wxWindow defines
#define wxRESIZE_BORDER

#define wxFRAME_TOOL_WINDOW
#define wxFRAME_NO_TASKBAR
#define wxFRAME_FLOAT_ON_PARENT
#define wxFRAME_EX_CONTEXTHELP
%wxchkver_2_6 #define wxFRAME_SHAPED
%wxchkver_2_6 #define wxFRAME_EX_METAL

class wxFrame : public wxTopLevelWindow
{
    wxFrame();
    wxFrame(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxFrame");
    bool Create(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxFrame");

    virtual wxStatusBar* CreateStatusBar(int number = 1, long style = 0, wxWindowID id = wxID_ANY, const wxString& name = "wxStatusBar");
    virtual wxToolBar* CreateToolBar(long style = wxNO_BORDER|wxTB_HORIZONTAL, wxWindowID id = wxID_ANY, const wxString& name = "wxToolBar");
    wxPoint GetClientAreaOrigin() const;
    wxMenuBar* GetMenuBar() const;
    wxStatusBar* GetStatusBar() const;
    int GetStatusBarPane();
    wxToolBar* GetToolBar() const;

    %wxchkver_2_4 void ProcessCommand(int id);

    void SendSizeEvent();
    void SetMenuBar(wxMenuBar* menuBar);
    void SetStatusBar(wxStatusBar* statusBar);
    void SetStatusBarPane(int n);
    virtual void SetStatusText(const wxString& text, int number = 0);

    virtual void SetStatusWidths(IntArray_FromLuaTable intTable); // %override parameters

    void SetToolBar(wxToolBar* toolBar);
    // wxTaskBarButton* MSWGetTaskBarButton(); // skip for too many dependencies on wxTaskBarButton
};

// ---------------------------------------------------------------------------
// wxMiniFrame

#if wxLUA_USE_wxMiniFrame

#include "wx/minifram.h"

#define wxTINY_CAPTION_HORIZ
#define wxTINY_CAPTION_VERT

class wxMiniFrame : public wxFrame
{
    wxMiniFrame();
    wxMiniFrame(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxMiniFrame");
    bool Create(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxMiniFrame");
};

#endif //wxLUA_USE_wxMiniFrame
#endif //wxLUA_USE_wxFrame

// ---------------------------------------------------------------------------
// wxStatusBar

#if wxLUA_USE_wxStatusBar && wxUSE_STATUSBAR

#include "wx/statusbr.h"

#define wxST_SIZEGRIP
#define wxSB_NORMAL
#define wxSB_FLAT
#define wxSB_RAISED

class wxStatusBar : public wxWindow
{
    wxStatusBar();
    wxStatusBar(wxWindow* parent, wxWindowID id, long style = wxST_SIZEGRIP, const wxString& name = "wxStatusBar");
    bool Create(wxWindow *parent, wxWindowID id, long style = wxST_SIZEGRIP, const wxString& name = "wxStatusBar");

    virtual bool GetFieldRect(int i, wxRect& rect) const;
    int GetFieldsCount() const;
    virtual wxString GetStatusText(int ir = 0) const;
    void PopStatusText(int field = 0);
    void PushStatusText(const wxString& string, int field = 0);

    // %override void wxStatusBar::SetFieldsCount(either a single number or a Lua table with number indexes and values);
    // C++ Func: virtual void SetFieldsCount(int number = 1, int* widths = NULL);
    virtual void SetFieldsCount(LuaTable intTable);

    void SetMinHeight(int height);
    virtual void SetStatusText(const wxString& text, int i = 0);

    // void wxStatusBar::SetStatusWidths(Lua table with number indexes and values);
    // C++ Func: virtual void SetStatusWidths(int n, int *widths);
    virtual void SetStatusWidths(IntArray_FromLuaTable intTable);

    // void wxStatusBar::SetStatusStyles(Lua table with number indexes and values);
    // C++ Func: virtual void SetStatusStyles(int n, int *styles);
    virtual void SetStatusStyles(IntArray_FromLuaTable intTable);
};

#endif //wxLUA_USE_wxStatusBar && wxUSE_STATUSBAR
