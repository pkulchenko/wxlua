// ===========================================================================
// Purpose:     enums, defines from wx/defs.h and other places
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

%include "wx/defs.h"
%include "wx/utils.h"

// This list of global functions is taken from the wxWindow's manual

// ---------------------------------------------------------------------------
// Application initialization and termination

%function void wxInitAllImageHandlers()
%function bool wxSafeYield(wxWindow* win = NULL, bool onlyIfNeeded = false)
%function bool wxYield()
%function void wxWakeUpIdle()

// ---------------------------------------------------------------------------
// wxProcess

%if wxLUA_USE_wxProcess

%enum
    wxEXEC_ASYNC
    wxEXEC_SYNC
    wxEXEC_NOHIDE
    wxEXEC_MAKE_GROUP_LEADER
    wxEXEC_NODISABLE
%endenum

%enum
    wxPROCESS_DEFAULT
    wxPROCESS_REDIRECT
%endenum

%enum wxSignal
    wxSIGNONE
    wxSIGHUP
    wxSIGINT
    wxSIGQUIT
    wxSIGILL
    wxSIGTRAP
    wxSIGABRT
    wxSIGEMT
    wxSIGFPE
    wxSIGKILL
    wxSIGBUS
    wxSIGSEGV
    wxSIGSYS
    wxSIGPIPE
    wxSIGALRM
    wxSIGTERM
%endenum

%enum wxKillError
    wxKILL_OK
    wxKILL_BAD_SIGNAL
    wxKILL_ACCESS_DENIED
    wxKILL_NO_PROCESS
    wxKILL_ERROR
%endenum

%enum wxKillFlags
    wxKILL_NOCHILDREN
    wxKILL_CHILDREN
%endenum

%class %delete wxProcess, wxEvtHandler
    wxProcess(wxEvtHandler *parent = NULL, int nId = wxID_ANY)
    //wxProcess(int flags)

    void Detach()
    static wxKillError Kill(int pid, wxSignal sig = wxSIGTERM, int flags = wxKILL_NOCHILDREN)
    static bool Exists(int pid)
    //virtual void OnTerminate(int pid, int status) just handle the event instead
    static wxProcess *Open(const wxString& cmd, int flags = wxEXEC_ASYNC)
    void Redirect()
    bool IsRedirected()

%if wxUSE_STREAMS
    void CloseOutput()
    wxInputStream *GetErrorStream() const
    wxInputStream *GetInputStream() const
    wxOutputStream *GetOutputStream() const
    bool IsErrorAvailable() const
    bool IsInputAvailable() const
    bool IsInputOpened() const
    void SetPipeStreams(wxInputStream *outStream, wxOutputStream *inStream, wxInputStream *errStream)
%endif // wxUSE_STREAMS

%endclass

%endif //wxLUA_USE_wxProcess

// ---------------------------------------------------------------------------
// Process control functions

!%wxchkver_2_6 %function long wxExecute(const wxString& command, bool sync = false, wxProcess *callback = NULL)
%wxchkver_2_6 %function long wxExecute(const wxString& command, int flags = wxEXEC_ASYNC, wxProcess *process = NULL)
// %override [long, Lua table of output strings] wxExecuteStdout(const wxString& command, int flags = 0)
%function %rename wxExecuteStdout long wxExecute(const wxString& command, wxArrayString& output, int flags = 0)
// %override [long, Lua table of output strings, Lua table of error strings] wxExecuteStdoutStderr(const wxString& command, int flags = 0)
%function %rename wxExecuteStdoutStderr long wxExecute(const wxString& command, wxArrayString& output, wxArrayString& errors, int flags = 0)
%function void wxExit()

// %override [int, wxKillError rc] wxKill(long pid, wxSignal sig = wxSIGTERM, int flags = 0)
// C++ Func: int wxKill(long pid, wxSignal sig = wxSIGTERM, wxKillError *rc = NULL, int flags = 0)
%function int wxKill(long pid, wxSignal sig = wxSIGTERM, int flags = 0)
%function unsigned long wxGetProcessId()
%function bool wxShell(const wxString& command = "")


%enum wxShutdownFlags
    wxSHUTDOWN_POWEROFF
    wxSHUTDOWN_REBOOT
%endenum

%function bool wxShutdown(wxShutdownFlags flags)

// ---------------------------------------------------------------------------
// File functions - see file.i

// ---------------------------------------------------------------------------
// Network, user, and OS functions - see wxbase_base.i

// ---------------------------------------------------------------------------
// String functions - nothing useful here

// ---------------------------------------------------------------------------
// Dialog functions - see dialogs.i

//%function void wxBeginBusyCursor(wxCursor *cursor = wxLua_wxHOURGLASS_CURSOR)
//%function void wxBell()
//%function void wxEndBusyCursor()
//%function bool wxIsBusy()

// ---------------------------------------------------------------------------
// Math functions - nothing useful here

// ---------------------------------------------------------------------------
// GDI functions

// %override [int x, int y, int width, int height] wxClientDisplayRect()
// void wxClientDisplayRect(int *x, int *y, int *width, int *height)
%function void wxClientDisplayRect()

%function wxRect wxGetClientDisplayRect()
%function bool wxColourDisplay()
%function int wxDisplayDepth()
// %override [int width, int height] wxDisplaySize()
// void wxDisplaySize(int *width, int *height)
%function void wxDisplaySize()

%function wxSize wxGetDisplaySize()
// %override [int width, int height] wxDisplaySizeMM()
// void wxDisplaySizeMM(int *width, int *height)
%function void wxDisplaySizeMM()

%function wxSize wxGetDisplaySizeMM()

%function void wxSetCursor(const wxCursor &cursor)
// %function wxIconOrCursor wxDROP_ICON(wxString name)

// ---------------------------------------------------------------------------
// Printer settings - are marked obsolete

// ---------------------------------------------------------------------------
// Clipboard functions - are marked obsolete

// ---------------------------------------------------------------------------
// Miscellaneous functions

%function bool wxGetKeyState(wxKeyCode key)
%function long wxNewId()
%function void wxRegisterId(long id)
%function void wxEnableTopLevelWindows(bool enable = true)
%function int wxFindMenuItemId(wxFrame *frame, const wxString& menuString, const wxString& itemString)
%function wxWindow* wxFindWindowByLabel(const wxString& label, wxWindow *parent=NULL)
%function wxWindow* wxFindWindowByName(const wxString& name, wxWindow *parent=NULL)
%function wxWindow* wxFindWindowAtPoint(const wxPoint& pt)
%function wxWindow* wxFindWindowAtPointer(wxPoint& pt)
%wxchkver_2_8_4 %function wxWindow* wxGetActiveWindow()
// wxBatteryState wxGetBatteryState()
// X only %function wxString wxGetDisplayName()
// X only %function void wxSetDisplayName(const wxString& displayName)
// wxPowerType wxGetPowerType()
%function wxPoint wxGetMousePosition()

%if %wxchkver_2_8
// This is in wxWidgets 2.6 docs, but it's only in >=2.7
%class %delete wxMouseState
    wxMouseState()

    wxCoord     GetX()
    wxCoord     GetY()
    bool        LeftDown()
    bool        MiddleDown()
    bool        RightDown()
    bool        ControlDown()
    bool        ShiftDown()
    bool        AltDown()
    bool        MetaDown()
    bool        CmdDown()
    void        SetX(wxCoord x)
    void        SetY(wxCoord y)
    void        SetLeftDown(bool down)
    void        SetMiddleDown(bool down)
    void        SetRightDown(bool down)
    void        SetControlDown(bool down)
    void        SetShiftDown(bool down)
    void        SetAltDown(bool down)
    void        SetMetaDown(bool down)
%endclass

%function wxMouseState wxGetMouseState()
%endif

// %function bool wxGetResource(const wxString& section, const wxString& entry, const wxString& *value, const wxString& file = "")
// %function bool wxWriteResource(const wxString& section, const wxString& entry, const wxString& value, const wxString& file = "")
// wxString  wxGetStockLabel(wxWindowID id, bool withCodes = true, wxString accelerator = wxEmptyString)
%function wxWindow* wxGetTopLevelParent(wxWindow *win)
%function bool wxLaunchDefaultBrowser(const wxString& sUrl)
//%win %function wxString wxLoadUserResource(const wxString& resourceName, const wxString& resourceType="TEXT")
%function void wxPostEvent(wxEvtHandler *dest, wxEvent& event)

// ---------------------------------------------------------------------------
// Byte order macros - nothing useful

// ---------------------------------------------------------------------------
// RTTI functions - nothing useful, see wxObject:DynamicCast

// ---------------------------------------------------------------------------
// Log functions - FIXME maybe useful?

// ---------------------------------------------------------------------------
// Time functions - see datetime.i

// ---------------------------------------------------------------------------
// Debugging macros and functions - nothing useful

// ---------------------------------------------------------------------------
// Environmental access functions - see wxbase_base.i

// ---------------------------------------------------------------------------
// wxWidgets window IDs - copied from wx/defs.h

%if wxLUA_USE_wxID_XXX

%define wxID_NONE
%define wxID_SEPARATOR
%define wxID_ANY
%define wxID_LOWEST

%define wxID_OPEN
%define wxID_CLOSE
%define wxID_NEW
%define wxID_SAVE
%define wxID_SAVEAS
%define wxID_REVERT
%define wxID_EXIT
%define wxID_UNDO
%define wxID_REDO
%define wxID_HELP
%define wxID_PRINT
%define wxID_PRINT_SETUP
%wxchkver_2_8 %define wxID_PAGE_SETUP
%define wxID_PREVIEW
%define wxID_ABOUT
%define wxID_HELP_CONTENTS
%wxchkver_2_8 %define wxID_HELP_INDEX
%wxchkver_2_8 %define wxID_HELP_SEARCH
%define wxID_HELP_COMMANDS
%define wxID_HELP_PROCEDURES
%define wxID_HELP_CONTEXT
%define wxID_CLOSE_ALL
%define wxID_PREFERENCES

%wxchkver_2_8 %define wxID_EDIT
%define wxID_CUT
%define wxID_COPY
%define wxID_PASTE
%define wxID_CLEAR
%define wxID_FIND
%define wxID_DUPLICATE
%define wxID_SELECTALL
%define wxID_DELETE
%define wxID_REPLACE
%define wxID_REPLACE_ALL
%define wxID_PROPERTIES

%define wxID_VIEW_DETAILS
%define wxID_VIEW_LARGEICONS
%define wxID_VIEW_SMALLICONS
%define wxID_VIEW_LIST
%define wxID_VIEW_SORTDATE
%define wxID_VIEW_SORTNAME
%define wxID_VIEW_SORTSIZE
%define wxID_VIEW_SORTTYPE

%wxchkver_2_8 %define wxID_FILE
%define wxID_FILE1
%define wxID_FILE2
%define wxID_FILE3
%define wxID_FILE4
%define wxID_FILE5
%define wxID_FILE6
%define wxID_FILE7
%define wxID_FILE8
%define wxID_FILE9

%define wxID_OK
%define wxID_CANCEL
%define wxID_APPLY
%define wxID_YES
%define wxID_NO
%define wxID_STATIC
%define wxID_FORWARD
%define wxID_BACKWARD
%define wxID_DEFAULT
%define wxID_MORE
%define wxID_SETUP
%define wxID_RESET
%define wxID_CONTEXT_HELP
%define wxID_YESTOALL
%define wxID_NOTOALL
%define wxID_ABORT
%define wxID_RETRY
%define wxID_IGNORE
%define wxID_ADD
%define wxID_REMOVE

%define wxID_UP
%define wxID_DOWN
%define wxID_HOME
%define wxID_REFRESH
%define wxID_STOP
%define wxID_INDEX

%define wxID_BOLD
%define wxID_ITALIC
%define wxID_JUSTIFY_CENTER
%define wxID_JUSTIFY_FILL
%define wxID_JUSTIFY_RIGHT
%define wxID_JUSTIFY_LEFT
%define wxID_UNDERLINE
%define wxID_INDENT
%define wxID_UNINDENT
%define wxID_ZOOM_100
%define wxID_ZOOM_FIT
%define wxID_ZOOM_IN
%define wxID_ZOOM_OUT
%define wxID_UNDELETE
%define wxID_REVERT_TO_SAVED

%define wxID_SYSTEM_MENU
%define wxID_CLOSE_FRAME
%define wxID_MOVE_FRAME
%define wxID_RESIZE_FRAME
%define wxID_MAXIMIZE_FRAME
%define wxID_ICONIZE_FRAME
%define wxID_RESTORE_FRAME

// %define wxID_FILEDLGG - probably not useful

%define wxID_HIGHEST

%endif //wxLUA_USE_wxID_XXX

// ---------------------------------------------------------------------------
// Generic defines and enums

%define wxBACKINGSTORE
%define wxBACKWARD
%define wxCANCEL
%define wxCENTER
%define wxCENTER_FRAME
%define wxCENTER_ON_SCREEN
%define wxCENTRE
%define wxCENTRE_ON_SCREEN
%define wxCOLOURED
//%define wxED_BUTTONS_BOTTOM  // for wxExtDialog? not used?
//%define wxED_BUTTONS_RIGHT
//%define wxED_CLIENT_MARGIN
//%define wxED_STATIC_LINE
%define wxFIXED_LENGTH
%define wxFORWARD
%define wxHELP
%define wxMORE
%define wxNO
%define wxNO_BORDER
%define wxNO_DEFAULT
%define wxOK
// %define wxPASSWORD %wxcompat_2_6 use wxTE_PASSWORD
// %define wxPROCESS_ENTER %wxcompat_2_6 use wxTE_PROCESS_ENTER
%define wxRESET
// %define wxRESIZE_BOX %wxcompat_2_6 use wxMAXIMIZE_BOX
%define wxRETAINED
%define wxSETUP
%define wxSIZE_ALLOW_MINUS_ONE
%define wxSIZE_AUTO
%define wxSIZE_AUTO_HEIGHT
%define wxSIZE_AUTO_WIDTH
%define wxSIZE_NO_ADJUSTMENTS
%define wxSIZE_USE_EXISTING
//%define wxUSER_COLOURS deprecated use wxNO_3D %wxcompat_2_6
%define wxYES
%define wxYES_DEFAULT
%define wxYES_NO

%enum wxOrientation
    wxHORIZONTAL
    wxVERTICAL
    wxBOTH
%endenum

%enum wxDirection
    wxLEFT
    wxRIGHT
    wxUP
    wxDOWN
    wxTOP
    wxBOTTOM
    wxNORTH
    wxSOUTH
    wxWEST
    wxEAST
    wxALL
%endenum

%enum wxAlignment
    wxALIGN_NOT
    wxALIGN_CENTER_HORIZONTAL
    wxALIGN_CENTRE_HORIZONTAL
    wxALIGN_LEFT
    wxALIGN_TOP
    wxALIGN_RIGHT
    wxALIGN_BOTTOM
    wxALIGN_CENTER_VERTICAL
    wxALIGN_CENTRE_VERTICAL
    wxALIGN_CENTER
    wxALIGN_CENTRE
    wxALIGN_MASK
%endenum

%enum wxStretch
    wxSTRETCH_NOT
    wxSHRINK
    wxGROW
    wxEXPAND
    wxSHAPED
    wxTILE

    wxADJUST_MINSIZE // deprecated after 2.4 and takes the value of 0

    %wxchkver_2_8_8 wxFIXED_MINSIZE
    %wxchkver_2_8_8 wxRESERVE_SPACE_EVEN_IF_HIDDEN
%endenum

%enum wxBorder
    wxBORDER_DEFAULT
    wxBORDER_NONE
    wxBORDER_STATIC
    wxBORDER_SIMPLE
    wxBORDER_RAISED
    wxBORDER_SUNKEN
    wxBORDER_DOUBLE
    wxBORDER_MASK
%endenum

%enum wxBackgroundStyle
    wxBG_STYLE_SYSTEM
    wxBG_STYLE_COLOUR
    wxBG_STYLE_CUSTOM
%endenum

%enum wxKeyModifier
    wxMOD_NONE
    wxMOD_ALT
    wxMOD_CONTROL
    wxMOD_ALTGR
    wxMOD_SHIFT
    wxMOD_META
    wxMOD_WIN
    wxMOD_CMD
    wxMOD_ALL
%endenum

// ---------------------------------------------------------------------------
// wxBusyCursor

%if wxLUA_USE_wxBusyCursor

%include "wx/utils.h"

%class %delete wxBusyCursor
    // NOTE: ALWAYS delete() this when done since Lua's gc may not delete it soon enough
    wxBusyCursor(wxCursor* cursor = wxHOURGLASS_CURSOR)
%endclass

// ---------------------------------------------------------------------------
// wxBusyCursorSuspender - we don't wrap this since Lua's garbage collector doesn't
// automatically collect items when they go out of scope so you would have to
// delete() this anyway which is just as easy as wxBegin/EndBusyCursor

//%class %delete wxBusyCursorSuspender
    // NOTE: ALWAYS delete() this when done since Lua's gc may not delete it soon enough
//    wxBusyCursorSuspender()

//%endclass

%endif //wxLUA_USE_wxBusyCursor

// ---------------------------------------------------------------------------
// wxBusyInfo

%if wxLUA_USE_wxBusyInfo && wxUSE_BUSYINFO

%include "wx/busyinfo.h"

%class %delete wxBusyInfo, wxObject
    // NOTE: ALWAYS delete() this when done since Lua's gc may not delete it soon enough
    wxBusyInfo(const wxString& message, wxWindow *parent = NULL)
%endclass

%endif //wxLUA_USE_wxBusyInfo && wxUSE_BUSYINFO

// ---------------------------------------------------------------------------
// wxTimer

%if wxLUA_USE_wxTimer && wxUSE_TIMER

%include "wx/timer.h"

%define wxTIMER_CONTINUOUS
%define wxTIMER_ONE_SHOT

%class %delete wxTimer, wxEvtHandler
    wxTimer(wxEvtHandler *owner, int id = -1)

    int      GetInterval() const
    bool     IsOneShot() const
    bool     IsRunning() const
    void     Notify()
    void     SetOwner(wxEvtHandler *owner, int id = -1)
    bool     Start(int milliseconds = -1, bool oneShot = false)
    void     Stop()
%endclass

// ---------------------------------------------------------------------------
// wxTimerEvent

%include "wx/timer.h"

%class %delete wxTimerEvent, wxEvent
    %define_event wxEVT_TIMER // EVT_TIMER(id, fn)

    int GetInterval() const
%endclass

%endif //wxLUA_USE_wxTimer && wxUSE_TIMER
