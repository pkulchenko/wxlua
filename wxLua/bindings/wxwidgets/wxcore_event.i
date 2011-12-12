// ===========================================================================
// Purpose:     wxEvent and other generic event classes and types
//              events specific to a single control are with that control
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================


// ---------------------------------------------------------------------------
// wxEvtHandler

%class %delete wxEvtHandler, wxObject
    wxEvtHandler()

    void AddPendingEvent(wxEvent& event)

    // NOTE: Connect used to be called ConnectEvent in wxLua which is not the name of any C++ function.

    // %override wxEvtHandler::Connect(int id, int lastId, wxEventType eventType, Lua function)
    // %override wxEvtHandler::Connect(int id, wxEventType eventType, Lua function)
    // %override wxEvtHandler::Connect(wxEventType eventType, Lua function)
    // The function type above is determined at runtime depending on the inputs.
    // C++ Func: void Connect(int id, int lastId, wxEventType eventType, wxObjectEventFunction function, wxObject* userData = NULL, wxEvtHandler* eventSink = NULL)
    // Note: wxLua uses the userdata and the event sink and so they're not available
    void Connect(int id, int lastId, wxEventType eventType, LuaFunction func)

    // %override bool Disconnect(int winid, int lastId, wxEventType eventType)
    // %override bool Disconnect(int winid, wxEventType eventType)
    // %override bool Disconnect(wxEventType eventType)
    // The function type above is determined at runtime depending on the inputs.
    // C++ Func: bool Disconnect(int id, int lastId = wxID_ANY, wxEventType eventType = wxEVT_NULL, wxObjectEventFunction function = NULL, wxObject* userData = NULL, wxEvtHandler* eventSink = NULL)
    // Note: wxLua uses the userdata and the event sink and so they're not available
    bool Disconnect(int id, int lastId, wxEventType eventType)

    voidptr_long GetClientData() // C++ returns (void *) You get a number here
    wxClientData* GetClientObject() const
    bool GetEvtHandlerEnabled()
    wxEvtHandler* GetNextHandler()
    wxEvtHandler* GetPreviousHandler()
    virtual bool ProcessEvent(wxEvent& event)
    //virtual bool SearchEventTable(wxEventTable& table, wxEvent& event)
    void SetClientData(voidptr_long number) // C++ is (void *clientData) You can put a number here
    void SetClientObject(wxClientData* data)
    void SetEvtHandlerEnabled(bool enabled)
    void SetNextHandler(wxEvtHandler* handler)
    void SetPreviousHandler(wxEvtHandler* handler)
%endclass

// ---------------------------------------------------------------------------
// wxEvent

%include "wx/event.h"

%enum Propagation_state
    wxEVENT_PROPAGATE_NONE // don't propagate it at all
    wxEVENT_PROPAGATE_MAX  // propagate it until it is processed
%endenum

%class %delete wxEvent, wxObject
    // wxEvent(int id = 0, wxEventType eventType = wxEVT_NULL) virtual base class

    wxObject* GetEventObject()
    wxEventType GetEventType()
    int GetId()
    bool GetSkipped()
    long GetTimestamp()
    bool IsCommandEvent() const
    void ResumePropagation(int propagationLevel)
    void SetEventObject(wxObject* object)
    void SetEventType(wxEventType type)
    void SetId(int id)
    void SetTimestamp(long timeStamp)
    bool ShouldPropagate() const
    void Skip(bool skip = true)
    int StopPropagation()
%endclass

// ---------------------------------------------------------------------------
// wxPropagationDisabler

%include "wx/event.h"

%class %delete wxPropagationDisabler
    // NOTE: ALWAYS delete() this when done since Lua's gc may not delete it soon enough
    wxPropagationDisabler(wxEvent& event)

%endclass

// ---------------------------------------------------------------------------
// wxPropagateOnce

%include "wx/event.h"

%class %delete wxPropagateOnce
    // NOTE: ALWAYS delete() this when done since Lua's gc may not delete it soon enough
    wxPropagateOnce(wxEvent& event)

%endclass

// ---------------------------------------------------------------------------
// wxCommandEvent

%include "wx/event.h"
%wxchkver_2_4 %include "wx/tglbtn.h"  // for wxEVT_COMMAND_TOGGLEBUTTON_CLICKED

%class %delete wxCommandEvent, wxEvent

    %define_event wxEVT_NULL // dummy placeholder nobody sends this event

    %define_event wxEVT_COMMAND_ENTER               // EVT_COMMAND_ENTER(winid, func)
    %define_event wxEVT_COMMAND_KILL_FOCUS          // EVT_COMMAND_KILL_FOCUS(winid, func)
    %define_event wxEVT_COMMAND_LEFT_CLICK          // EVT_COMMAND_LEFT_CLICK(winid, func)
    %define_event wxEVT_COMMAND_LEFT_DCLICK         // EVT_COMMAND_LEFT_DCLICK(winid, func)
    %define_event wxEVT_COMMAND_RIGHT_CLICK         // EVT_COMMAND_RIGHT_CLICK(winid, func)
    %define_event wxEVT_COMMAND_RIGHT_DCLICK        // EVT_COMMAND_RIGHT_DCLICK(winid, func)
    //%define_event wxEVT_COMMAND_SCROLLBAR_UPDATED // EVT_SCROLLBAR(winid, func) obsolete use wxEVT_SCROLL...
    %define_event wxEVT_COMMAND_SET_FOCUS           // EVT_COMMAND_SET_FOCUS(winid, func)
    //%define_event wxEVT_COMMAND_VLBOX_SELECTED    // EVT_VLBOX(winid, func) unused?

    %define_event wxEVT_COMMAND_MENU_SELECTED   // EVT_MENU(winid, func) EVT_MENU_RANGE(id1, id2, func)

    %define_event wxEVT_COMMAND_TOOL_CLICKED    // EVT_TOOL(winid, func) EVT_TOOL_RANGE(id1, id2, func)
    %define_event wxEVT_COMMAND_TOOL_ENTER      // EVT_TOOL_ENTER(winid, func)
    %define_event wxEVT_COMMAND_TOOL_RCLICKED   // EVT_TOOL_RCLICKED(winid, func) EVT_TOOL_RCLICKED_RANGE(id1, id2, func)

    %define_event wxEVT_COMMAND_TEXT_ENTER      // EVT_TEXT_ENTER(id, fn)
    %define_event wxEVT_COMMAND_TEXT_UPDATED    // EVT_TEXT(id, fn)
    %define_event wxEVT_COMMAND_TEXT_MAXLEN     // EVT_TEXT_MAXLEN(id, fn)
    !%wxchkver_2_8_0 %define_event wxEVT_COMMAND_TEXT_URL        // EVT_TEXT_URL(id, fn)

    %define_event wxEVT_COMMAND_SPINCTRL_UPDATED        // EVT_SPINCTRL(id, fn)
    %define_event wxEVT_COMMAND_SLIDER_UPDATED          // EVT_SLIDER(winid, func)
    %define_event wxEVT_COMMAND_RADIOBUTTON_SELECTED    // EVT_RADIOBUTTON(winid, func)
    %define_event wxEVT_COMMAND_RADIOBOX_SELECTED       // EVT_RADIOBOX(winid, func)
    %define_event wxEVT_COMMAND_CHECKLISTBOX_TOGGLED    // EVT_CHECKLISTBOX(winid, func)
    %define_event wxEVT_COMMAND_LISTBOX_DOUBLECLICKED   // EVT_LISTBOX_DCLICK(winid, func)
    %define_event wxEVT_COMMAND_LISTBOX_SELECTED        // EVT_LISTBOX(winid, func)
    %define_event wxEVT_COMMAND_COMBOBOX_SELECTED       // EVT_COMBOBOX(winid, func)
    %define_event wxEVT_COMMAND_CHOICE_SELECTED         // EVT_CHOICE(winid, func)
    %define_event wxEVT_COMMAND_CHECKBOX_CLICKED        // EVT_CHECKBOX(winid, func)
    %define_event wxEVT_COMMAND_BUTTON_CLICKED          // EVT_BUTTON(winid, func)
    %wxchkver_2_4 %define_event wxEVT_COMMAND_TOGGLEBUTTON_CLICKED // EVT_TOGGLEBUTTON(id, fn)

    wxCommandEvent(wxEventType commandEventType = wxEVT_NULL, int id = 0)

    voidptr_long GetClientData() // C++ returns (void *) You get a number here
    wxClientData* GetClientObject()
    %rename GetStringClientObject wxStringClientData* GetClientObject()
    long GetExtraLong()
    int GetInt()
    int GetSelection()
    wxString GetString()
    bool IsChecked() const
    bool IsSelection()
    void SetClientData(voidptr_long number) // C++ is (void *clientData) You can put a number here
    void SetExtraLong(int extraLong)
    void SetInt(int intCommand)
    void SetString(const wxString &string)
%endclass

// ---------------------------------------------------------------------------
// wxNotifyEvent

%include "wx/event.h"

%class %delete wxNotifyEvent, wxCommandEvent
    wxNotifyEvent(wxEventType eventType = wxEVT_NULL, int id = 0)

    void Allow()
    bool IsAllowed() const
    void Veto()
%endclass

// ---------------------------------------------------------------------------
// wxActivateEvent

%include "wx/event.h"

%class %delete wxActivateEvent, wxEvent
    %define_event wxEVT_ACTIVATE        // EVT_ACTIVATE(func)
    %define_event wxEVT_ACTIVATE_APP    // EVT_ACTIVATE_APP(func)
    %define_event wxEVT_HIBERNATE       // EVT_HIBERNATE(func)

    wxActivateEvent(wxEventType eventType = wxEVT_NULL, bool active = true, int id = 0)

    bool GetActive() const
%endclass

// ---------------------------------------------------------------------------
// wxCloseEvent

%include "wx/event.h"

%class %delete wxCloseEvent, wxEvent
    %define_event wxEVT_CLOSE_WINDOW        // EVT_CLOSE(func)
    %define_event wxEVT_QUERY_END_SESSION   // EVT_QUERY_END_SESSION(func)
    %define_event wxEVT_END_SESSION         // EVT_END_SESSION(func)

    wxCloseEvent(wxEventType commandEventType = wxEVT_NULL, int id = 0)

    bool CanVeto()
    bool GetLoggingOff() const
    void SetCanVeto(bool canVeto)
    void SetLoggingOff(bool loggingOff) const
    void Veto(bool veto = true)
%endclass

// ---------------------------------------------------------------------------
// wxDialUpEvent - TODO - the rest of wxDialUp is missing, anyone care?

//%if !%mac
//%include "wx/dialup.h"

//%class %delete wxDialUpEvent, wxCommandEvent
//    %define_event wxEVT_DIALUP_CONNECTED      // EVT_DIALUP_CONNECTED(func)
//    %define_event wxEVT_DIALUP_DISCONNECTED   // EVT_DIALUP_DISCONNECTED(func)

//    wxDialUpEvent(bool isConnected, bool isOwnEvent)
//    bool IsConnectedEvent() const
//    bool IsOwnEvent() const
//%endclass
//%endif

// ---------------------------------------------------------------------------
// wxEraseEvent

%include "wx/event.h"

%class %delete wxEraseEvent, wxEvent
    %define_event wxEVT_ERASE_BACKGROUND // EVT_ERASE_BACKGROUND(func)

    wxEraseEvent(int id = 0, wxDC* dc = NULL)

    wxDC* GetDC() const
%endclass

// ---------------------------------------------------------------------------
// wxFocusEvent

%include "wx/event.h"

%class %delete wxFocusEvent, wxEvent
    %define_event wxEVT_SET_FOCUS   // EVT_SET_FOCUS(func)
    %define_event wxEVT_KILL_FOCUS  // EVT_KILL_FOCUS(func)

    wxFocusEvent(wxEventType eventType = wxEVT_NULL, int id = 0)

    wxWindow* GetWindow()
    void SetWindow(wxWindow *win)
%endclass

// ---------------------------------------------------------------------------
// wxChildFocusEvent

%include "wx/event.h"

%class %delete wxChildFocusEvent, wxCommandEvent
    %define_event wxEVT_CHILD_FOCUS // EVT_CHILD_FOCUS(func)

    wxChildFocusEvent(wxWindow *win = NULL)

    wxWindow *GetWindow() const
%endclass

// ---------------------------------------------------------------------------
// wxQueryNewPaletteEvent

%include "wx/event.h"

%class %delete wxQueryNewPaletteEvent, wxEvent
    %define_event wxEVT_QUERY_NEW_PALETTE // EVT_QUERY_NEW_PALETTE(func)

    wxQueryNewPaletteEvent(wxWindowID winid = 0)

    void SetPaletteRealized(bool realized)
    bool GetPaletteRealized() const
%endclass

// ---------------------------------------------------------------------------
// wxPaletteChangedEvent

%include "wx/event.h"

%class %delete wxPaletteChangedEvent, wxEvent
    %define_event wxEVT_PALETTE_CHANGED // EVT_PALETTE_CHANGED(func)

    wxPaletteChangedEvent(wxWindowID winid = 0)

    void SetChangedWindow(wxWindow* win)
    wxWindow* GetChangedWindow() const
%endclass

// ---------------------------------------------------------------------------
// wxKeyEvent

%enum wxKeyCode
    WXK_ADD
    WXK_ALT
    WXK_BACK
    WXK_CANCEL
    WXK_CAPITAL
    WXK_CLEAR
    WXK_CONTROL
    WXK_DECIMAL
    WXK_DELETE
    WXK_DIVIDE
    WXK_DOWN
    WXK_END
    WXK_ESCAPE
    WXK_EXECUTE
    WXK_F1
    WXK_F10
    WXK_F11
    WXK_F12
    WXK_F13
    WXK_F14
    WXK_F15
    WXK_F16
    WXK_F17
    WXK_F18
    WXK_F19
    WXK_F2
    WXK_F20
    WXK_F21
    WXK_F22
    WXK_F23
    WXK_F24
    WXK_F3
    WXK_F4
    WXK_F5
    WXK_F6
    WXK_F7
    WXK_F8
    WXK_F9
    WXK_HELP
    WXK_HOME
    WXK_INSERT
    WXK_LBUTTON
    WXK_LEFT
    WXK_MBUTTON
    WXK_MENU
    WXK_MULTIPLY
    //WXK_NEXT = WXK_PAGEDOWN since 2.6
    WXK_NUMLOCK
    WXK_NUMPAD_ADD
    WXK_NUMPAD_BEGIN
    WXK_NUMPAD_DECIMAL
    WXK_NUMPAD_DELETE
    WXK_NUMPAD_DIVIDE
    WXK_NUMPAD_DOWN
    WXK_NUMPAD_END
    WXK_NUMPAD_ENTER
    WXK_NUMPAD_EQUAL
    WXK_NUMPAD_F1
    WXK_NUMPAD_F2
    WXK_NUMPAD_F3
    WXK_NUMPAD_F4
    WXK_NUMPAD_HOME
    WXK_NUMPAD_INSERT
    WXK_NUMPAD_LEFT
    WXK_NUMPAD_MULTIPLY
    // WXK_NUMPAD_NEXT = WXK_NUMPAD_PAGEDOWN since 2.6
    WXK_NUMPAD_PAGEDOWN
    WXK_NUMPAD_PAGEUP
    // WXK_NUMPAD_PRIOR = WXK_NUMPAD_PAGEUP since 2.6
    WXK_NUMPAD_RIGHT
    WXK_NUMPAD_SEPARATOR
    WXK_NUMPAD_SPACE
    WXK_NUMPAD_SUBTRACT
    WXK_NUMPAD_TAB
    WXK_NUMPAD_UP
    WXK_NUMPAD0
    WXK_NUMPAD1
    WXK_NUMPAD2
    WXK_NUMPAD3
    WXK_NUMPAD4
    WXK_NUMPAD5
    WXK_NUMPAD6
    WXK_NUMPAD7
    WXK_NUMPAD8
    WXK_NUMPAD9
    WXK_PAGEDOWN
    WXK_PAGEUP
    WXK_PAUSE
    WXK_PRINT
    // WXK_PRIOR = WXK_PAGEUP since 2.6
    WXK_RBUTTON
    WXK_RETURN
    WXK_RIGHT
    WXK_SCROLL
    WXK_SELECT
    WXK_SEPARATOR
    WXK_SHIFT
    WXK_SNAPSHOT
    WXK_SPACE
    WXK_START
    WXK_SUBTRACT
    WXK_TAB
    WXK_UP
%endenum

%include "wx/event.h"

%class %delete wxKeyEvent, wxEvent
    %define_event wxEVT_KEY_DOWN            // EVT_KEY_DOWN(func)
    %define_event wxEVT_KEY_UP              // EVT_KEY_UP(func)
    %define_event wxEVT_CHAR                // EVT_CHAR(func)
    %define_event wxEVT_CHAR_HOOK           // EVT_CHAR_HOOK(func)
    wxUSE_HOTKEY %define_event wxEVT_HOTKEY // EVT_HOTKEY(winid, func)

    wxKeyEvent(wxEventType keyEventType)

    bool AltDown() const
    bool CmdDown() const
    bool ControlDown() const
    int GetKeyCode() const
    %wxchkver_2_8 int GetModifiers() const
    wxPoint GetPosition() const

    // %override [long x, long y] wxKeyEvent::GetPositionXY()
    // C++ Func: void GetPosition(long *x, long *y) const
    %rename GetPositionXY void GetPosition() const

    //wxUint32 GetRawKeyCode() const
    //wxUint32 GetRawKeyFlags() const
    //wxChar GetUnicodeKey() const
    long GetX()
    long GetY() const
    bool HasModifiers() const
    bool MetaDown() const
    bool ShiftDown() const
%endclass

// ---------------------------------------------------------------------------
// wxNavigationKeyEvent

%include "wx/event.h"

%enum wxNavigationKeyEvent::dummy
    IsBackward
    IsForward
    WinChange
    FromTab
%endenum

%class %delete wxNavigationKeyEvent, wxEvent
    %define_event wxEVT_NAVIGATION_KEY // EVT_NAVIGATION_KEY(func)

    wxNavigationKeyEvent()

    bool GetDirection() const
    void SetDirection(bool bForward)
    bool IsWindowChange() const
    void SetWindowChange(bool bIs)
    bool IsFromTab() const
    void SetFromTab(bool bIs)
    wxWindow* GetCurrentFocus() const
    void SetCurrentFocus(wxWindow *win)
    void SetFlags(long flags)
%endclass

// ---------------------------------------------------------------------------
// wxIdleEvent

%include "wx/event.h"

%enum wxIdleMode
    wxIDLE_PROCESS_ALL
    wxIDLE_PROCESS_SPECIFIED
%endenum

%class %delete wxIdleEvent, wxEvent
    %define_event wxEVT_IDLE // EVT_IDLE(func)

    wxIdleEvent()

    !%wxchkver_2_9_2 static bool CanSend(wxWindow* window)
    static wxIdleMode GetMode()
    void RequestMore(bool needMore = true)
    bool MoreRequested() const
    static void SetMode(wxIdleMode mode)
%endclass

// ---------------------------------------------------------------------------
// wxInitDialogEvent - for dialogs and panels

%include "wx/event.h"

%class %delete wxInitDialogEvent, wxEvent
    %define_event wxEVT_INIT_DIALOG // EVT_INIT_DIALOG(func)

    wxInitDialogEvent(int id = 0)
%endclass

// ---------------------------------------------------------------------------
// wxContextMenuEvent

%class %delete wxContextMenuEvent, wxCommandEvent
    %define_event wxEVT_CONTEXT_MENU    // EVT_CONTEXT_MENU(func) EVT_COMMAND_CONTEXT_MENU(winid, func)

    wxContextMenuEvent(wxEventType type = wxEVT_NULL, wxWindowID winid = 0, const wxPoint& pt = wxDefaultPosition)
    //wxContextMenuEvent(const wxContextMenuEvent& event)

    wxPoint GetPosition() const
    void SetPosition(const wxPoint& pos)
%endclass

// ---------------------------------------------------------------------------
// wxMouseEvent

%include "wx/event.h"

%enum
    wxMOUSE_BTN_ANY
    wxMOUSE_BTN_NONE
    wxMOUSE_BTN_LEFT
    wxMOUSE_BTN_MIDDLE
    wxMOUSE_BTN_RIGHT
%endenum

%class %delete wxMouseEvent, wxEvent
    %define_event wxEVT_ENTER_WINDOW    // EVT_ENTER_WINDOW(func)
    %define_event wxEVT_LEAVE_WINDOW    // EVT_LEAVE_WINDOW(func)
    %define_event wxEVT_LEFT_DCLICK     // EVT_LEFT_DCLICK(func)
    %define_event wxEVT_LEFT_DOWN       // EVT_LEFT_DOWN(func)
    %define_event wxEVT_LEFT_UP         // EVT_LEFT_UP(func)
    %define_event wxEVT_MIDDLE_DCLICK   // EVT_MIDDLE_DCLICK(func)
    %define_event wxEVT_MIDDLE_DOWN     // EVT_MIDDLE_DOWN(func)
    %define_event wxEVT_MIDDLE_UP       // EVT_MIDDLE_UP(func)
    %define_event wxEVT_MOTION          // EVT_MOTION(func)
    %define_event wxEVT_MOUSEWHEEL      // EVT_MOUSEWHEEL(func)
    %define_event wxEVT_RIGHT_DCLICK    // EVT_RIGHT_DCLICK(func)
    %define_event wxEVT_RIGHT_DOWN      // EVT_RIGHT_DOWN(func)
    %define_event wxEVT_RIGHT_UP        // EVT_RIGHT_UP(func)

    //%define_event wxEVT_NC_ENTER_WINDOW // FIXME - these are not used in wxWidgets
    //%define_event wxEVT_NC_LEAVE_WINDOW
    //%define_event wxEVT_NC_LEFT_DCLICK
    //%define_event wxEVT_NC_LEFT_DOWN
    //%define_event wxEVT_NC_LEFT_UP
    //%define_event wxEVT_NC_MIDDLE_DCLICK
    //%define_event wxEVT_NC_MIDDLE_DOWN
    //%define_event wxEVT_NC_MIDDLE_UP
    //%define_event wxEVT_NC_MOTION
    //%define_event wxEVT_NC_RIGHT_DCLICK
    //%define_event wxEVT_NC_RIGHT_DOWN
    //%define_event wxEVT_NC_RIGHT_UP

    wxMouseEvent(wxEventType mouseEventType = wxEVT_NULL)

    bool AltDown()
    bool Button(int button)
    bool ButtonDClick(int but = wxMOUSE_BTN_ANY)
    bool ButtonDown(int but = wxMOUSE_BTN_ANY)
    bool ButtonUp(int but = wxMOUSE_BTN_ANY)
    bool CmdDown() const
    bool ControlDown()
    bool Dragging()
    bool Entering()
    wxPoint GetPosition() const

    // %override [long x, long y] wxMouseEvent::GetPositionXY()
    // C++ Func: void GetPosition(wxCoord* x, wxCoord* y) const
    %rename GetPositionXY void GetPosition() const

    wxPoint GetLogicalPosition(const wxDC& dc) const
    int GetLinesPerAction() const
    int GetWheelRotation() const
    int GetWheelDelta() const
    long GetX() const
    long GetY()
    bool IsButton() const
    bool Leaving() const
    bool LeftDClick() const
    bool LeftDown() const
    bool LeftIsDown() const
    bool LeftUp() const
    bool MetaDown() const
    bool MiddleDClick() const
    bool MiddleDown() const
    bool MiddleIsDown() const
    bool MiddleUp() const
    bool Moving() const
    bool RightDClick() const
    bool RightDown() const
    bool RightIsDown() const
    bool RightUp() const
    bool ShiftDown() const
%endclass

// ---------------------------------------------------------------------------
// wxMouseCaptureChangedEvent

%include "wx/event.h"

%class %delete wxMouseCaptureChangedEvent, wxEvent
    %define_event wxEVT_MOUSE_CAPTURE_CHANGED // EVT_MOUSE_CAPTURE_CHANGED(func)

    wxMouseCaptureChangedEvent(wxWindowID winid = 0, wxWindow* gainedCapture = NULL)

    wxWindow* GetCapturedWindow() const
%endclass

// ---------------------------------------------------------------------------
// wxMouseCaptureLostEvent

%if %wxchkver_2_8

%include "wx/event.h"

%class %delete wxMouseCaptureLostEvent, wxEvent
    %define_event wxEVT_MOUSE_CAPTURE_LOST // EVT_MOUSE_CAPTURE_LOST(func)

    wxMouseCaptureLostEvent(wxWindowID winid = 0)

%endclass

%endif //%wxchkver_2_8

// ---------------------------------------------------------------------------
// wxMoveEvent

%include "wx/event.h"

%class %delete wxMoveEvent, wxEvent
    %define_event wxEVT_MOVE                    // EVT_MOVE(func)
    %wxchkver_2_6 %define_event wxEVT_MOVING    // EVT_MOVING(func)

    wxMoveEvent(const wxPoint& pt, int id = 0)

    wxPoint GetPosition() const
%endclass

// ---------------------------------------------------------------------------
// wxPaintEvent -
//
// Note: You must ALWAYS create a wxPaintDC for the window and delete() when
// done to have the exposed area marked as painted, otherwise you'll continue
// to get endless paint events.
// Tip: local dc = wx.wxPaintDC(event:GetEventObject():DynamicCast("wxWindow"))
//      do stuff with dc...
//      dc:delete()  -- Absolutely necessary since the garbage collector may
//                   -- not immediatelly run.

%include "wx/event.h"

%class %delete wxPaintEvent, wxEvent
    %define_event wxEVT_PAINT // EVT_PAINT(func)

    wxPaintEvent(int id = 0)
%endclass

// ---------------------------------------------------------------------------
// wxNcPaintEvent - this is not sent from anything in wxWidgets

//%include "wx/event.h"

//%class %delete class wxNcPaintEvent, wxEvent
//    %define_event wxEVT_NC_PAINT // EVT_NC_PAINT(func)
//    wxNcPaintEvent(int winid = 0)
//%endclass

// ---------------------------------------------------------------------------
// wxProcessEvent

%include "wx/process.h"

%class %delete wxProcessEvent, wxEvent
    %define_event wxEVT_END_PROCESS // EVT_END_PROCESS(id, func)

    !%wxchkver_2_6 wxProcessEvent(int id = 0, int pid = 0)
    %wxchkver_2_6 wxProcessEvent(int nId = 0, int pid = 0, int exitcode = 0)
    int GetPid() const
    %wxchkver_2_6 int GetExitCode()
%endclass

// ---------------------------------------------------------------------------
// wxScrollEvent - for independent scrollbars and sliders

%include "wx/event.h"

%class %delete wxScrollEvent, wxCommandEvent
    %define_event wxEVT_SCROLL_TOP          // EVT_SCROLL_TOP(func)
    %define_event wxEVT_SCROLL_BOTTOM       // EVT_SCROLL_BOTTOM(func)
    %define_event wxEVT_SCROLL_LINEUP       // EVT_SCROLL_LINEUP(func)
    %define_event wxEVT_SCROLL_LINEDOWN     // EVT_SCROLL_LINEDOWN(func)
    %define_event wxEVT_SCROLL_PAGEUP       // EVT_SCROLL_PAGEUP(func)
    %define_event wxEVT_SCROLL_PAGEDOWN     // EVT_SCROLL_PAGEDOWN(func)
    %define_event wxEVT_SCROLL_THUMBTRACK   // EVT_SCROLL_THUMBTRACK(func)
    %define_event wxEVT_SCROLL_THUMBRELEASE // EVT_SCROLL_THUMBRELEASE(func)
    %wxcompat_2_6 %define_event wxEVT_SCROLL_ENDSCROLL // EVT_SCROLL_ENDSCROLL(func) FIXME called wxEVT_SCROLL_CHANGED in 2.8
    %wxchkver_2_8 %define_event wxEVT_SCROLL_CHANGED   // EVT_SCROLL_CHANGED(func)

    wxScrollEvent(wxEventType commandType = wxEVT_NULL, int id = 0, int pos = 0, int orientation = 0)

    int GetOrientation() const
    int GetPosition() const
%endclass

// ---------------------------------------------------------------------------
// wxScrollWinEvent - for wxScrolledWindows only

%include "wx/event.h"

%class %delete wxScrollWinEvent, wxEvent
    %define_event wxEVT_SCROLLWIN_BOTTOM        // EVT_SCROLLWIN_BOTTOM(func)
    %define_event wxEVT_SCROLLWIN_LINEDOWN      // EVT_SCROLLWIN_LINEDOWN(func)
    %define_event wxEVT_SCROLLWIN_LINEUP        // EVT_SCROLLWIN_LINEUP(func)
    %define_event wxEVT_SCROLLWIN_PAGEDOWN      // EVT_SCROLLWIN_PAGEDOWN(func)
    %define_event wxEVT_SCROLLWIN_PAGEUP        // EVT_SCROLLWIN_PAGEUP(func)
    %define_event wxEVT_SCROLLWIN_THUMBRELEASE  // EVT_SCROLLWIN_THUMBRELEASE(func)
    %define_event wxEVT_SCROLLWIN_THUMBTRACK    // EVT_SCROLLWIN_THUMBTRACK(func)
    %define_event wxEVT_SCROLLWIN_TOP           // EVT_SCROLLWIN_TOP(func)

    wxScrollWinEvent(wxEventType commandType = wxEVT_NULL, int pos = 0, int orientation = 0)

    int GetOrientation() const
    int GetPosition() const
%endclass

// ---------------------------------------------------------------------------
// wxSizeEvent

%include "wx/event.h"

%class %delete wxSizeEvent, wxEvent
    %define_event wxEVT_SIZE                    // EVT_SIZE(func)
    %wxchkver_2_6 %define_event wxEVT_SIZING    // EVT_SIZING(func)

    wxSizeEvent(const wxSize& sz, int id = 0)

    wxSize GetSize() const
%endclass

// ---------------------------------------------------------------------------
// wxShowEvent

%include "wx/event.h"

%class %delete wxShowEvent, wxEvent
    %define_event wxEVT_SHOW // EVT_SHOW(func)

    wxShowEvent(int winid = 0, bool show = false)

    void SetShow(bool show)
    bool GetShow() const
%endclass

// ---------------------------------------------------------------------------
// wxIconizeEvent

%include "wx/event.h"

%class %delete wxIconizeEvent, wxEvent
    %define_event wxEVT_ICONIZE // EVT_ICONIZE(func)

    wxIconizeEvent(int winid = 0, bool iconized = true)

    bool Iconized() const
%endclass

// ---------------------------------------------------------------------------
// wxMaximizeEvent

%include "wx/event.h"

%class %delete wxMaximizeEvent, wxEvent
    %define_event wxEVT_MAXIMIZE // EVT_MAXIMIZE(func)

    wxMaximizeEvent(int winid = 0)

%endclass

// ---------------------------------------------------------------------------
// wxWindowCreateEvent

%include "wx/event.h"

%class %delete wxWindowCreateEvent, wxEvent
    %define_event wxEVT_CREATE // EVT_WINDOW_CREATE(func)

    wxWindowCreateEvent(wxWindow *win = NULL)

    wxWindow *GetWindow() const
%endclass

// ---------------------------------------------------------------------------
// wxWindowDestroyEvent

%include "wx/event.h"

%class %delete wxWindowDestroyEvent, wxEvent
    %define_event wxEVT_DESTROY // EVT_WINDOW_DESTROY(func)

    wxWindowDestroyEvent(wxWindow *win = NULL)

    wxWindow *GetWindow() const
%endclass

// ---------------------------------------------------------------------------
// wxSysColourChangedEvent

%include "wx/event.h"

%class %delete wxSysColourChangedEvent, wxEvent
    %define_event wxEVT_SYS_COLOUR_CHANGED // EVT_SYS_COLOUR_CHANGED(func)

    wxSysColourChangedEvent()
%endclass

// ---------------------------------------------------------------------------
// wxDisplayChangedEvent

%include "wx/event.h"

%class %delete wxDisplayChangedEvent, wxEvent
    %define_event wxEVT_DISPLAY_CHANGED // EVT_DISPLAY_CHANGED(func)

    wxDisplayChangedEvent()
%endclass


// ---------------------------------------------------------------------------
// wxPowerEvent

%if %wxchkver_2_8

%include "wx/power.h"

%enum wxPowerType
    wxPOWER_SOCKET
    wxPOWER_BATTERY
    wxPOWER_UNKNOWN
%endenum

%enum wxBatteryState
    wxBATTERY_NORMAL_STATE     // system is fully usable
    wxBATTERY_LOW_STATE        // start to worry
    wxBATTERY_CRITICAL_STATE   // save quickly
    wxBATTERY_SHUTDOWN_STATE   // too late
    wxBATTERY_UNKNOWN_STATE
%endenum

%function wxPowerType wxGetPowerType()
%function wxBatteryState wxGetBatteryState()

%if wxHAS_POWER_EVENTS

%class %delete wxPowerEvent, wxEvent
    %define_event wxEVT_POWER_SUSPENDING        // EVT_POWER_SUSPENDING(func)
    %define_event wxEVT_POWER_SUSPENDED         // EVT_POWER_SUSPENDED(func)
    %define_event wxEVT_POWER_SUSPEND_CANCEL    // EVT_POWER_SUSPEND_CANCEL(func)
    %define_event wxEVT_POWER_RESUME            // EVT_POWER_RESUME(func)

    wxPowerEvent(wxEventType evtType)

    void Veto()
    bool IsVetoed() const
%endclass

%endif // wxHAS_POWER_EVENTS

%endif // %wxchkver_2_8


// ---------------------------------------------------------------------------
// wxSetCursorEvent

%include "wx/event.h"

%class %delete wxSetCursorEvent, wxEvent
    %define_event wxEVT_SET_CURSOR // EVT_SET_CURSOR(func)

    wxSetCursorEvent(wxCoord x = 0, wxCoord y = 0)

    wxCoord GetX() const
    wxCoord GetY() const
    void SetCursor(const wxCursor& cursor)
    wxCursor GetCursor() const
    bool HasCursor() const

%endclass

// ---------------------------------------------------------------------------
// wxUpdateUIEvent

%include "wx/event.h"

%enum wxUpdateUIMode
    wxUPDATE_UI_PROCESS_ALL
    wxUPDATE_UI_PROCESS_SPECIFIED
%endenum

%class %delete wxUpdateUIEvent, wxCommandEvent
    %define_event wxEVT_UPDATE_UI // EVT_UPDATE_UI(winid, func) EVT_UPDATE_UI_RANGE(id1, id2, func)

    wxUpdateUIEvent(wxWindowID commandId = wxID_ANY)

    static bool CanUpdate(wxWindow* window)
    void Check(bool check)
    void Enable(bool enable)
    bool GetChecked() const
    bool GetEnabled() const
    %wxchkver_2_8 bool GetShown() const
    bool GetSetChecked() const
    bool GetSetEnabled() const
    %wxchkver_2_8 bool GetSetShown() const
    bool GetSetText() const
    wxString GetText() const
    static wxUpdateUIMode GetMode()
    static long GetUpdateInterval()
    static void ResetUpdateTime()
    static void SetMode(wxUpdateUIMode mode)
    void SetText(const wxString& text)
    static void SetUpdateInterval(long updateInterval)
    %wxchkver_2_8 void Show(bool show)
%endclass

// ---------------------------------------------------------------------------
// wxHelpEvent

%include "wx/event.h"

%if %wxchkver_2_8
%enum wxHelpEvent::Origin
    Origin_Unknown    // unrecognized event source
    Origin_Keyboard   // event generated from F1 key press
    Origin_HelpButton // event from [?] button on the title bar (Windows)
%endenum
%endif //%wxchkver_2_8

%class %delete wxHelpEvent, wxCommandEvent
    %define_event wxEVT_HELP            // EVT_HELP(winid, func) EVT_HELP_RANGE(id1, id2, func)
    %define_event wxEVT_DETAILED_HELP   // EVT_DETAILED_HELP(winid, func) EVT_DETAILED_HELP_RANGE(id1, id2, func)

    !%wxchkver_2_8 wxHelpEvent(wxEventType type = wxEVT_NULL, wxWindowID id = 0, const wxPoint& pt = wxDefaultPosition)
    %wxchkver_2_8 wxHelpEvent(wxEventType type = wxEVT_NULL, wxWindowID id = 0, const wxPoint& pt = wxDefaultPosition, wxHelpEvent::Origin origin = wxHelpEvent::Origin_Unknown)

    wxString GetLink()
    %wxchkver_2_8 wxHelpEvent::Origin GetOrigin() const
    wxPoint  GetPosition()
    wxString GetTarget()
    void SetLink(const wxString& link)
    %wxchkver_2_8 void SetOrigin(wxHelpEvent::Origin origin)
    void SetPosition(const wxPoint& pos)
    void SetTarget(const wxString& target)
%endclass
