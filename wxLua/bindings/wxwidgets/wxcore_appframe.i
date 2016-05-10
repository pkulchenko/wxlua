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

class wxAppConsole : public wxEvtHandler
{
    // void HandleEvent(wxEvtHandler* handler, wxEventFunction func, wxEvent& event) const;
    // bool OnCmdLineError(wxCmdLineParser& parser);
    // bool OnCmdLineHelp(wxCmdLineParser& parser);
    // bool OnCmdLineParsed(wxCmdLineParser& parser);
    // void OnInitCmdLine(wxCmdLineParser& parser);
    // wxAppTraits* GetTraits(); // no wxAppTraits support
    // void OnAssertFailure(const wxChar *file, int line, const wxChar *func, const wxChar *cond, const wxChar *msg); // not supported
};

class wxApp : public wxAppConsole
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
    // %win bool ProcessMessage(WXMSG* msg);
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
    %wxchkver_3_1_1 bool SetShape(const wxRegion& region);
    // bool SetShape(const wxGraphicsPath& path); // skip for too many dependencies on wxGraphicsPath
};

class wxTopLevelWindow : public wxNonOwnedWindow
{
    %wxchkver_3_1_1 wxTopLevelWindow();
    %wxchkver_3_1_1 wxTopLevelWindow(wxWindow *parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = wxFrameNameStr);
    %wxchkver_3_1_1 bool Create(wxWindow *parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = wxFrameNameStr);
    bool CanSetTransparent();
    %wxchkver_3_1_1 void CenterOnScreen(int direction = wxBOTH);
    %wxchkver_3_1_1 void CentreOnScreen(int direction = wxBOTH);
    bool EnableCloseButton(bool enable = true);
    %wxchkver_3_1_1 bool EnableMaximizeButton(bool enable = true);
    %wxchkver_3_1_1 bool EnableMinimizeButton(bool enable = true);
    %wxchkver_2_8 wxWindow* GetDefaultItem() const;
    %wxchkver_3_1_1 static wxSize GetDefaultSize();
    wxIcon GetIcon() const;
    %wxchkver_3_1_1 const wxIconBundle& GetIcons() const;
    wxString GetTitle() const;
    void Iconize(bool iconize);
    bool IsActive() const;
    bool IsAlwaysMaximized() const;
    bool IsFullScreen() const;
    bool IsIconized() const;
    bool IsMaximized() const;
    // bool IsUsingNativeDecorations() const; // skip wxUniv method
    %wxchkver_3_1_1 bool Layout();
    void Maximize(bool maximize);
    %wxchkver_3_1_1 && %win wxMenu *MSWGetSystemMenu() const;
    void RequestUserAttention(int flags = wxUSER_ATTENTION_INFO);
    %wxchkver_3_1_1 void Restore();
    %wxchkver_2_8 wxWindow* SetDefaultItem(wxWindow *win);
    %wxchkver_2_8 wxWindow* SetTmpDefaultItem(wxWindow *win);
    %wxchkver_2_8 wxWindow* GetTmpDefaultItem() const;
    void SetIcon(const wxIcon& icon);
    void SetIcons(const wxIconBundle& icons);
    void SetMaxSize(const wxSize& size);
    void SetMinSize(const wxSize& size);
    void SetSizeHints(int minW, int minH, int maxW=-1, int maxH=-1, int incW=-1, int incH=-1);
    void SetSizeHints(const wxSize& minSize, const wxSize& maxSize=wxDefaultSize, const wxSize& incSize=wxDefaultSize);
    virtual void SetTitle(const wxString& title);
    %wxchkver_3_1_1 bool SetTransparent(wxByte alpha);
    // virtual bool ShouldPreventAppExit() const; // must be overridden
    %wxchkver_3_1_1 && %mac void OSXSetModified(bool modified);
    %wxchkver_3_1_1 && %mac bool OSXIsModified() const;
    %wxchkver_3_1_1 void SetRepresentedFilename(const wxString& filename);
    %wxchkver_3_1_1 void ShowWithoutActivating();
    %wxchkver_3_1_1 bool EnableFullScreenView(bool enable = true);
    bool ShowFullScreen(bool show, long style = wxFULLSCREEN_ALL);
    // void UseNativeDecorations(bool native = true); // skip wxUniv method
    // static void UseNativeDecorationsByDefault(bool native = true); // skip wxUniv method
    !%wxchkver_3_1_1 bool SetShape(const wxRegion& region);
    !%wxchkver_3_1_1 virtual bool SetTransparent(int alpha);
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
    %wxchkver_3_1_1 void Centre(int direction = wxBOTH);
    bool Create(wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxFrame");
    virtual wxStatusBar* CreateStatusBar(int number = 1, long style = 0, wxWindowID id = wxID_ANY, const wxString& name = "wxStatusBar");
    %wxchkver_3_1_1 wxToolBar* CreateToolBar(long style = wxTB_DEFAULT_STYLE, wxWindowID id = wxID_ANY, const wxString& name = wxToolBarNameStr);
    %wxchkver_3_1_1 void DoGiveHelp(const wxString& text, bool show);
    wxPoint GetClientAreaOrigin() const;
    wxMenuBar* GetMenuBar() const;
    wxStatusBar* GetStatusBar() const;
    int GetStatusBarPane();
    wxToolBar* GetToolBar() const;
    %wxchkver_3_1_1 wxStatusBar* OnCreateStatusBar(int number, long style, wxWindowID id, const wxString& name);
    %wxchkver_3_1_1 wxToolBar* OnCreateToolBar(long style, wxWindowID id, const wxString& name);
    %wxchkver_2_4 void ProcessCommand(int id);
    void SetMenuBar(wxMenuBar* menuBar);
    void SetStatusBar(wxStatusBar* statusBar);
    void SetStatusBarPane(int n);
    virtual void SetStatusText(const wxString& text, int number = 0);
    void SetToolBar(wxToolBar* toolBar);
    // wxTaskBarButton* MSWGetTaskBarButton(); // skip for too many dependencies on wxTaskBarButton
    %wxchkver_3_1_1 void PushStatusText(const wxString &text, int number = 0);
    %wxchkver_3_1_1 void PopStatusText(int number = 0);
    !%wxchkver_3_1_1 virtual wxToolBar* CreateToolBar(long style = wxNO_BORDER|wxTB_HORIZONTAL, wxWindowID id = wxID_ANY, const wxString& name = "wxToolBar");
    !%wxchkver_3_1_1 void SendSizeEvent();
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
