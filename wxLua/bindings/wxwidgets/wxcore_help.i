// ===========================================================================
// Purpose:     wxHelpController and help related classes
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

// See wxhtml_html.i for wxHtmlHelp classes


// ---------------------------------------------------------------------------
// wxContextHelp

%if wxLUA_USE_wxHelpController && wxUSE_HELP

%include "wx/cshelp.h"

%class %delete wxContextHelp, wxObject
    wxContextHelp(wxWindow* win = NULL, bool beginHelp = true)

    bool BeginContextHelp(wxWindow* win)
    bool EndContextHelp()

    //bool EventLoop()
    //bool DispatchEvent(wxWindow* win, const wxPoint& pt)
    //void SetStatus(bool status)
%endclass

// ---------------------------------------------------------------------------
// wxContextHelpButton

%if wxLUA_USE_wxBitmapButton && wxUSE_BMPBUTTON

%include "wx/cshelp.h"

%class wxContextHelpButton, wxBitmapButton
    wxContextHelpButton(wxWindow* parent, wxWindowID id = wxID_CONTEXT_HELP, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxBU_AUTODRAW)

    //void OnContextHelp(wxCommandEvent& event)
%endclass

%endif //wxLUA_USE_wxBitmapButton && wxUSE_BMPBUTTON

// ---------------------------------------------------------------------------
// wxHelpProvider

%class %delete wxHelpProvider
    // No constructor see wxSimpleHelpProvider

    // Note that the wxHelpProviderModule will delete the set wxHelpProvider
    // so you do not have to delete() it when the program exits. However,
    // if you set a different wxHelpProvider you must delete() the previous one.
    static %gc wxHelpProvider *Set(%ungc wxHelpProvider *helpProvider)
    static wxHelpProvider *Get()
    virtual wxString GetHelp(const wxWindow *window) // pure virtual
    %wxchkver_2_8 virtual bool ShowHelpAtPoint(wxWindow *window, const wxPoint& pt, wxHelpEvent::Origin origin)
    virtual bool ShowHelp(wxWindow *window)
    virtual void AddHelp(wxWindow *window, const wxString& text)
    //virtual void AddHelp(wxWindowID id, const wxString& text)
    virtual void RemoveHelp(wxWindow* window)
%endclass

// ---------------------------------------------------------------------------
// wxSimpleHelpProvider

%class %delete wxSimpleHelpProvider, wxHelpProvider
    wxSimpleHelpProvider()

%endclass

// ---------------------------------------------------------------------------
// wxHelpControllerHelpProvider

%class %delete wxHelpControllerHelpProvider, wxSimpleHelpProvider
    wxHelpControllerHelpProvider(wxHelpController* hc = NULL)

    // The wxHelpController you set must exist for the life of this.
    // And this will not delete() it when done.
    void SetHelpController(wxHelpController* hc)
    wxHelpController* GetHelpController() const
%endclass

%endif //wxLUA_USE_wxHelpController && wxUSE_HELP


// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// wxHelpControllerBase and derived help controller classes

%if wxLUA_USE_wxHelpController && wxUSE_HELP

%include "wx/help.h"

%define wxHELP_NETSCAPE  // Flags for SetViewer

%enum wxHelpSearchMode
    wxHELP_SEARCH_INDEX
    wxHELP_SEARCH_ALL
%endenum

%class %delete wxHelpControllerBase, wxObject
    //wxHelpControllerBase() - base class no constructor

    virtual void Initialize(const wxString& file)
    // virtual void Initialize(const wxString& file, int server) - marked obsolete
    virtual bool DisplayBlock(long blockNo)
    virtual bool DisplayContents()
    virtual bool DisplayContextPopup(int contextId)
    virtual bool DisplaySection(int sectionNo)
    virtual bool DisplaySection(const wxString &section)
    virtual bool DisplayTextPopup(const wxString& text, const wxPoint& pos)

    // %override [wxFrame*, wxSize* size = NULL, wxPoint* pos = NULL, bool *newFrameEachTime = NULL] wxHelpControllerBase::GetFrameParameters()
    // C++ Func: virtual wxFrame* GetFrameParameters(wxSize* size = NULL, wxPoint* pos = NULL, bool *newFrameEachTime = NULL)
    virtual wxFrame* GetFrameParameters()

    %wxchkver_2_8 virtual wxWindow* GetParentWindow() const
    virtual bool KeywordSearch(const wxString& keyWord, wxHelpSearchMode mode = wxHELP_SEARCH_ALL)
    virtual bool LoadFile(const wxString& file = "")
    //virtual bool OnQuit()
    virtual void SetFrameParameters(const wxString& title, const wxSize& size, const wxPoint& pos = wxDefaultPosition, bool newFrameEachTime = false)
    %wxchkver_2_8 virtual void SetParentWindow(wxWindow* win)
    virtual void SetViewer(const wxString& viewer, long flags)
    virtual bool Quit()
%endclass

// ---------------------------------------------------------------------------
// wxHelpController - wxWidgets #defines it appropriately per platform

%class %delete wxHelpController, wxHelpControllerBase
    wxHelpController()
    //%wxchkver_2_8 wxHelpController(wxWindow* parentWindow = NULL) wxHTMLHelpController takes different params

%endclass

// ---------------------------------------------------------------------------
// wxWinHelpController

%if %msw

%include "wx/helpwin.h"

%class %delete wxWinHelpController, wxHelpControllerBase
    wxWinHelpController()
%endclass

%endif //%msw

// ---------------------------------------------------------------------------
// wxCHMHelpController

//%class %delete wxCHMHelpController, wxHelpControllerBase
//%include "wx/msw/helpchm.h"
//wxCHMHelpController()
//%endclass

// ---------------------------------------------------------------------------
// wxBestHelpController

%if %msw

%include "wx/msw/helpbest.h"

%class %delete wxBestHelpController, wxHelpControllerBase
    wxBestHelpController(wxWindow* parentWindow = NULL, int style = wxHF_DEFAULT_STYLE)
%endclass

%endif //%msw

// ---------------------------------------------------------------------------
// wxExtHelpController

%if !%win

%include "wx/generic/helpext.h"

%class %delete wxExtHelpController, wxHelpControllerBase
    wxExtHelpController()
%endclass

%endif //!%win

%endif //wxLUA_USE_wxHelpController && wxUSE_HELP
