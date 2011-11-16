// ===========================================================================
// Purpose:     wxAUI library
// Author:      John Labenski
// Created:     07/03/2007
// Copyright:   (c) 2007 John Labenski. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.6
// ===========================================================================

// NOTE: This file is mostly copied from wxWidget's include/aui/*.h headers
// to make updating it easier.

%if wxLUA_USE_wxAUI && %wxchkver_2_8 && wxUSE_AUI

%include "wx/aui/aui.h"


// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

//%include "wx/aui/auibook.h" // already included by aui.h

%enum wxAuiNotebookOption
    wxAUI_NB_TOP
    wxAUI_NB_LEFT                 // not implemented yet
    wxAUI_NB_RIGHT                // not implemented yet
    wxAUI_NB_BOTTOM               // not implemented yet
    wxAUI_NB_TAB_SPLIT
    wxAUI_NB_TAB_MOVE
    wxAUI_NB_TAB_EXTERNAL_MOVE
    wxAUI_NB_TAB_FIXED_WIDTH
    wxAUI_NB_SCROLL_BUTTONS
    wxAUI_NB_WINDOWLIST_BUTTON
    wxAUI_NB_CLOSE_BUTTON
    wxAUI_NB_CLOSE_ON_ACTIVE_TAB
    wxAUI_NB_CLOSE_ON_ALL_TABS
    %wxchkver_2_8_6 wxAUI_NB_MIDDLE_CLICK_CLOSE

    wxAUI_NB_DEFAULT_STYLE //= wxAUI_NB_TOP|wxAUI_NB_TAB_SPLIT|wxAUI_NB_TAB_MOVE|wxAUI_NB_SCROLL_BUTTONS|wxAUI_NB_CLOSE_ON_ACTIVE_TAB|wxAUI_NB_MIDDLE_CLICK_CLOSE
%endenum


// ---------------------------------------------------------------------------
// wxAuiNotebookEvent

%class %delete wxAuiNotebookEvent, wxNotifyEvent
    %define_event wxEVT_COMMAND_AUINOTEBOOK_PAGE_CLOSE      // EVT_AUINOTEBOOK_PAGE_CLOSE(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_PAGE_CHANGED    // EVT_AUINOTEBOOK_PAGE_CHANGED(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_PAGE_CHANGING   // EVT_AUINOTEBOOK_PAGE_CHANGING(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_BUTTON          // EVT_AUINOTEBOOK_BUTTON(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_BEGIN_DRAG      // EVT_AUINOTEBOOK_BEGIN_DRAG(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_END_DRAG        // EVT_AUINOTEBOOK_END_DRAG(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_DRAG_MOTION     // EVT_AUINOTEBOOK_DRAG_MOTION(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_ALLOW_DND       // EVT_AUINOTEBOOK_ALLOW_DND(winid, fn)

%if %wxchkver_2_8_5
    %define_event wxEVT_COMMAND_AUINOTEBOOK_TAB_MIDDLE_DOWN // EVT_AUINOTEBOOK_TAB_MIDDLE_DOWN(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_TAB_MIDDLE_UP   // EVT_AUINOTEBOOK_TAB_MIDDLE_UP(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_TAB_RIGHT_DOWN  // EVT_AUINOTEBOOK_TAB_RIGHT_DOWN(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_TAB_RIGHT_UP    // EVT_AUINOTEBOOK_TAB_RIGHT_UP(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_PAGE_CLOSED     //
    %define_event wxEVT_COMMAND_AUINOTEBOOK_DRAG_DONE       // EVT_AUINOTEBOOK_DRAG_DONE(winid, fn)
    %define_event wxEVT_COMMAND_AUINOTEBOOK_BG_DCLICK       // EVT_AUINOTEBOOK_BG_DCLICK(winid, fn)
%endif //%wxchkver_2_8_5


    wxAuiNotebookEvent(wxEventType command_type = wxEVT_NULL, int win_id = 0)
    wxAuiNotebookEvent(const wxAuiNotebookEvent& c)

    void SetSelection(int s)
    int GetSelection() const

    void SetOldSelection(int s)
    int GetOldSelection() const

    void SetDragSource(wxAuiNotebook* s)
    wxAuiNotebook* GetDragSource() const
%endclass


// ---------------------------------------------------------------------------
// wxAuiNotebookPage

%class %delete wxAuiNotebookPage
    %member wxWindow* window;     // page's associated window
    %member wxString caption;     // caption displayed on the tab
    %member wxBitmap bitmap;      // tab's bitmap
    %member wxRect rect;          // tab's hit rectangle
    %member bool active;          // true if the page is currently active
%endclass


// ---------------------------------------------------------------------------
// wxAuiNotebookPageArray

%class %delete wxAuiNotebookPageArray
    wxAuiNotebookPageArray()
    wxAuiNotebookPageArray(const wxAuiNotebookPageArray& array)

    void Add(wxAuiNotebookPage* page)
    void Clear()
    int  GetCount() const
    void Insert(wxAuiNotebookPage* page, int nIndex)
    bool IsEmpty()
    wxAuiNotebookPage Item(size_t nIndex) const
    void RemoveAt(size_t nIndex)
%endclass


// ---------------------------------------------------------------------------
// wxAuiTabContainerButton

%class %delete wxAuiTabContainerButton
    %member int id;               // button's id
    %member int cur_state;        // current state (normal, hover, pressed, etc.)
    %member int location;         // buttons location (wxLEFT, wxRIGHT, or wxCENTER)
    %member wxBitmap bitmap;      // button's hover bitmap
    %member wxBitmap dis_bitmap;  // button's disabled bitmap
    %member wxRect rect;          // button's hit rectangle
%endclass

//WX_DECLARE_USER_EXPORTED_OBJARRAY(wxAuiTabContainerButton, wxAuiTabContainerButtonArray, WXDLLIMPEXP_AUI);


// ---------------------------------------------------------------------------
// wxAuiTabArt

%class %delete wxAuiTabArt
    // wxAuiTabArt() No constructor - base class

    %gc virtual wxAuiTabArt* Clone() //= 0;
    virtual void SetFlags(unsigned int flags) //= 0;
    virtual void SetSizingInfo(const wxSize& tab_ctrl_size, size_t tab_count) //= 0;
    virtual void SetNormalFont(const wxFont& font) //= 0;
    virtual void SetSelectedFont(const wxFont& font) //= 0;
    virtual void SetMeasuringFont(const wxFont& font) //= 0;

    virtual void DrawBackground( wxDC& dc, wxWindow* wnd, const wxRect& rect) //= 0;
    virtual void DrawTab(wxDC& dc, wxWindow* wnd, const wxAuiNotebookPage& pane, const wxRect& in_rect, int close_button_state, wxRect* out_tab_rect, wxRect* out_button_rect, int* x_extent) //= 0;
    virtual void DrawButton( wxDC& dc, wxWindow* wnd, const wxRect& in_rect, int bitmap_id, int button_state, int orientation, wxRect* out_rect) //= 0;
    virtual wxSize GetTabSize( wxDC& dc, wxWindow* wnd, const wxString& caption, const wxBitmap& bitmap, bool active, int close_button_state, int* x_extent) //= 0;
    virtual int ShowDropDown( wxWindow* wnd, const wxAuiNotebookPageArray& items, int active_idx) //= 0;
    virtual int GetIndentSize() //= 0;
    virtual int GetBestTabCtrlSize( wxWindow* wnd, const wxAuiNotebookPageArray& pages, const wxSize& required_bmp_size) //= 0;
%endclass


// ---------------------------------------------------------------------------
// wxAuiDefaultTabArt

%class %delete wxAuiDefaultTabArt, wxAuiTabArt
    wxAuiDefaultTabArt();

%endclass


// ---------------------------------------------------------------------------
// wxAuiSimpleTabArt

%class %delete wxAuiSimpleTabArt, wxAuiTabArt
    wxAuiSimpleTabArt();

%endclass

// ---------------------------------------------------------------------------
// wxAuiTabContainer

//%class %delete wxAuiTabContainer
//    wxAuiTabContainer();
//
//    All methods put into wxAuiTabCtrl since this isn't the base class of anything else
//
//%endclass


// ---------------------------------------------------------------------------
// wxAuiTabCtrl

%class wxAuiTabCtrl, wxControl //, wxAuiTabContainer

    wxAuiTabCtrl(wxWindow* parent,  wxWindowID id = wxID_ANY, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0);

    void SetArtProvider(%ungc wxAuiTabArt* art);
    wxAuiTabArt* GetArtProvider() const;

    void SetFlags(unsigned int flags);
    unsigned int GetFlags() const;

    bool AddPage(wxWindow* page, const wxAuiNotebookPage& info);
    bool InsertPage(wxWindow* page, const wxAuiNotebookPage& info, size_t idx);
    bool MovePage(wxWindow* page, size_t new_idx);
    bool RemovePage(wxWindow* page);
    bool SetActivePage(wxWindow* page);
    bool SetActivePage(size_t page);
    void SetNoneActive();
    int GetActivePage() const;
    bool TabHitTest(int x, int y, wxWindow** hit) const;
    bool ButtonHitTest(int x, int y, wxAuiTabContainerButton** hit) const;
    wxWindow* GetWindowFromIdx(size_t idx) const;
    int GetIdxFromWindow(wxWindow* page) const;
    size_t GetPageCount() const;
    wxAuiNotebookPage& GetPage(size_t idx);
    const wxAuiNotebookPage& GetPage(size_t idx) const;
    wxAuiNotebookPageArray& GetPages();
    void SetNormalFont(const wxFont& normal_font);
    void SetSelectedFont(const wxFont& selected_font);
    void SetMeasuringFont(const wxFont& measuring_font);
    void DoShowHide();
    void SetRect(const wxRect& rect);

    void RemoveButton(int id);
    void AddButton(int id, int location, const wxBitmap& normal_bitmap = wxNullBitmap, const wxBitmap& disabled_bitmap = wxNullBitmap);

    size_t GetTabOffset() const;
    void SetTabOffset(size_t offset);

    %wxchkver_2_8_6 bool IsTabVisible(int tabPage, int tabOffset, wxDC* dc, wxWindow* wnd);
    %wxchkver_2_8_6 void MakeTabVisible(int tabPage, wxWindow* win);

    %wxchkver_2_8_5 bool IsDragging() const
%endclass


// ---------------------------------------------------------------------------
// wxAuiNotebook

%class wxAuiNotebook, wxControl
    wxAuiNotebook();
    wxAuiNotebook(wxWindow* parent, wxWindowID id = wxID_ANY, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxAUI_NB_DEFAULT_STYLE);
    bool Create(wxWindow* parent, wxWindowID id = wxID_ANY, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0);

    void SetWindowStyleFlag(long style);
    void SetArtProvider(%ungc wxAuiTabArt* art);
    wxAuiTabArt* GetArtProvider() const;

    virtual void SetUniformBitmapSize(const wxSize& size);
    virtual void SetTabCtrlHeight(int height);

    bool AddPage(wxWindow* page, const wxString& caption, bool select = false, const wxBitmap& bitmap = wxNullBitmap);

    bool InsertPage(size_t page_idx, wxWindow* page, const wxString& caption, bool select = false, const wxBitmap& bitmap = wxNullBitmap);

    bool DeletePage(size_t page);
    bool RemovePage(size_t page);

    size_t GetPageCount() const;
    wxWindow* GetPage(size_t page_idx) const;
    int GetPageIndex(wxWindow* page_wnd) const;

    bool SetPageText(size_t page, const wxString& text);
    wxString GetPageText(size_t page_idx) const;

    bool SetPageBitmap(size_t page, const wxBitmap& bitmap);
    wxBitmap GetPageBitmap(size_t page_idx) const;

    size_t SetSelection(size_t new_page);
    int GetSelection() const;

    virtual void Split(size_t page, int direction);

%if %wxchkver_2_8_1 // (wxABI_VERSION >= 20801)
    const wxAuiManager& GetAuiManager() const
%endif

%if %wxchkver_2_8_5 //(wxABI_VERSION >= 20805)
	// Sets the normal font
	void SetNormalFont(const wxFont& font);

	// Sets the selected tab font
	void SetSelectedFont(const wxFont& font);

	// Sets the measuring font
	void SetMeasuringFont(const wxFont& font);

	// Sets the tab font
    virtual bool SetFont(const wxFont& font);

	// Gets the tab control height
    int GetTabCtrlHeight() const;

    // Gets the height of the notebook for a given page height
    int GetHeightForPageHeight(int pageHeight);

    // Advances the selection, generation page selection events
    void AdvanceSelection(bool forward = true);

    // Shows the window menu
    bool ShowWindowMenu();
%endif

%endclass


// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

//%include "wx/aui/dockart.h"

// ---------------------------------------------------------------------------
// wxAuiDockArt

%class %delete wxAuiDockArt
    // wxAuiDockArt() - No constructor - base class

    virtual int GetMetric(int id) //= 0;
    virtual void SetMetric(int id, int new_val) //= 0;
    virtual void SetFont(int id, const wxFont& font) //= 0;
    virtual wxFont GetFont(int id) //= 0;
    virtual wxColour GetColour(int id) //= 0;
    virtual void SetColour(int id, const wxColour& colour) //= 0;
    wxColour GetColor(int id)
    void SetColor(int id, const wxColour& color)

    virtual void DrawSash(wxDC& dc, wxWindow* window, int orientation, const wxRect& rect) //= 0;
    virtual void DrawBackground(wxDC& dc, wxWindow* window, int orientation, const wxRect& rect) //= 0;
    virtual void DrawCaption(wxDC& dc, wxWindow* window, const wxString& text, const wxRect& rect, wxAuiPaneInfo& pane) //= 0;
    virtual void DrawGripper(wxDC& dc, wxWindow* window, const wxRect& rect, wxAuiPaneInfo& pane) //= 0;
    virtual void DrawBorder(wxDC& dc, wxWindow* window, const wxRect& rect, wxAuiPaneInfo& pane) //= 0;
    virtual void DrawPaneButton(wxDC& dc, wxWindow* window, int button, int button_state, const wxRect& rect, wxAuiPaneInfo& pane) //= 0;
%endclass


// ---------------------------------------------------------------------------
// wxAuiDefaultDockArt

%class %delete wxAuiDefaultDockArt, wxAuiDockArt
    wxAuiDefaultDockArt();

%endclass


// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

//%include "wx/aui/floatpane.h"

// ---------------------------------------------------------------------------
// wxAuiFloatingFrame

%class wxAuiFloatingFrame, wxFrame // wxAuiFloatingFrameBaseClass
    wxAuiFloatingFrame(wxWindow* parent, wxAuiManager* owner_mgr, const wxAuiPaneInfo& pane, wxWindowID id = wxID_ANY, long style = wxRESIZE_BORDER|wxSYSTEM_MENU|wxCAPTION|wxFRAME_NO_TASKBAR | wxFRAME_FLOAT_ON_PARENT|wxCLIP_CHILDREN);

    void SetPaneWindow(const wxAuiPaneInfo& pane);
    wxAuiManager* GetOwnerManager() const;
%endclass


// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

//%include "wx/aui/framemanager.h"

%enum wxAuiManagerDock
    wxAUI_DOCK_NONE
    wxAUI_DOCK_TOP
    wxAUI_DOCK_RIGHT
    wxAUI_DOCK_BOTTOM
    wxAUI_DOCK_LEFT
    wxAUI_DOCK_CENTER
    wxAUI_DOCK_CENTRE //= wxAUI_DOCK_CENTER
%endenum

%enum wxAuiManagerOption
    wxAUI_MGR_ALLOW_FLOATING
    wxAUI_MGR_ALLOW_ACTIVE_PANE
    wxAUI_MGR_TRANSPARENT_DRAG
    wxAUI_MGR_TRANSPARENT_HINT
    wxAUI_MGR_VENETIAN_BLINDS_HINT
    wxAUI_MGR_RECTANGLE_HINT
    wxAUI_MGR_HINT_FADE
    wxAUI_MGR_NO_VENETIAN_BLINDS_FADE

    wxAUI_MGR_DEFAULT //= wxAUI_MGR_ALLOW_FLOATING | wxAUI_MGR_TRANSPARENT_HINT | wxAUI_MGR_HINT_FADE | wxAUI_MGR_NO_VENETIAN_BLINDS_FADE
%endenum

%enum wxAuiPaneDockArtSetting
    wxAUI_DOCKART_SASH_SIZE
    wxAUI_DOCKART_CAPTION_SIZE
    wxAUI_DOCKART_GRIPPER_SIZE
    wxAUI_DOCKART_PANE_BORDER_SIZE
    wxAUI_DOCKART_PANE_BUTTON_SIZE
    wxAUI_DOCKART_BACKGROUND_COLOUR
    wxAUI_DOCKART_SASH_COLOUR
    wxAUI_DOCKART_ACTIVE_CAPTION_COLOUR
    wxAUI_DOCKART_ACTIVE_CAPTION_GRADIENT_COLOUR
    wxAUI_DOCKART_INACTIVE_CAPTION_COLOUR
    wxAUI_DOCKART_INACTIVE_CAPTION_GRADIENT_COLOUR
    wxAUI_DOCKART_ACTIVE_CAPTION_TEXT_COLOUR
    wxAUI_DOCKART_INACTIVE_CAPTION_TEXT_COLOUR
    wxAUI_DOCKART_BORDER_COLOUR
    wxAUI_DOCKART_GRIPPER_COLOUR
    wxAUI_DOCKART_CAPTION_FONT
    wxAUI_DOCKART_GRADIENT_TYPE
%endenum

%enum wxAuiPaneDockArtGradients
    wxAUI_GRADIENT_NONE
    wxAUI_GRADIENT_VERTICAL
    wxAUI_GRADIENT_HORIZONTAL
%endenum

%enum wxAuiPaneButtonState
    wxAUI_BUTTON_STATE_NORMAL
    wxAUI_BUTTON_STATE_HOVER
    wxAUI_BUTTON_STATE_PRESSED
    wxAUI_BUTTON_STATE_DISABLED
    wxAUI_BUTTON_STATE_HIDDEN
    wxAUI_BUTTON_STATE_CHECKED
%endenum

%enum wxAuiButtonId
    wxAUI_BUTTON_CLOSE
    wxAUI_BUTTON_MAXIMIZE_RESTORE
    wxAUI_BUTTON_MINIMIZE
    wxAUI_BUTTON_PIN
    wxAUI_BUTTON_OPTIONS
    wxAUI_BUTTON_WINDOWLIST
    wxAUI_BUTTON_LEFT
    wxAUI_BUTTON_RIGHT
    wxAUI_BUTTON_UP
    wxAUI_BUTTON_DOWN
    wxAUI_BUTTON_CUSTOM1
    wxAUI_BUTTON_CUSTOM2
    wxAUI_BUTTON_CUSTOM3
%endenum

%enum wxAuiPaneInsertLevel
    wxAUI_INSERT_PANE
    wxAUI_INSERT_ROW
    wxAUI_INSERT_DOCK
%endenum


//WX_DECLARE_USER_EXPORTED_OBJARRAY(wxAuiDockInfo, wxAuiDockInfoArray, WXDLLIMPEXP_AUI);
//WX_DECLARE_USER_EXPORTED_OBJARRAY(wxAuiDockUIPart, wxAuiDockUIPartArray, WXDLLIMPEXP_AUI);
//WX_DECLARE_USER_EXPORTED_OBJARRAY(wxAuiPaneButton, wxAuiPaneButtonArray, WXDLLIMPEXP_AUI);
//WX_DECLARE_USER_EXPORTED_OBJARRAY(wxAuiPaneInfo, wxAuiPaneInfoArray, WXDLLIMPEXP_AUI);
//WX_DEFINE_USER_EXPORTED_ARRAY_PTR(wxAuiPaneInfo*, wxAuiPaneInfoPtrArray, class WXDLLIMPEXP_AUI);
//WX_DEFINE_USER_EXPORTED_ARRAY_PTR(wxAuiDockInfo*, wxAuiDockInfoPtrArray, class WXDLLIMPEXP_AUI);

// ---------------------------------------------------------------------------
// wxAuiPaneInfo

// NOTE: You can add and subtract flags from this list,
// but do not change the values of the flags, because
// they are stored in a binary integer format in the
// perspective string.  If you really need to change the
// values around, you'll have to ensure backwards-compatibility
// in the perspective loading code.
%enum wxAuiPaneInfo::wxAuiPaneState
    optionFloating
    optionHidden
    optionLeftDockable
    optionRightDockable
    optionTopDockable
    optionBottomDockable
    optionFloatable
    optionMovable
    optionResizable
    optionPaneBorder
    optionCaption
    optionGripper
    optionDestroyOnClose
    optionToolbar
    optionActive
    optionGripperTop
    optionMaximized

    buttonClose
    buttonMaximize
    buttonMinimize
    buttonPin

    buttonCustom1
    buttonCustom2
    buttonCustom3

    savedHiddenState       // used internally
    actionPane             // used internally
%endenum


%class %delete wxAuiPaneInfo
    %define_object wxAuiNullPaneInfo

    wxAuiPaneInfo()
    wxAuiPaneInfo(const wxAuiPaneInfo& c)

    %operator wxAuiPaneInfo& operator=(const wxAuiPaneInfo& c)

    // Write the safe parts of a newly loaded PaneInfo structure "source" into "this"
    // used on loading perspectives etc.
    void SafeSet(wxAuiPaneInfo source)

    bool IsOk() const
    bool IsFixed() const
    bool IsResizable() const
    bool IsShown() const
    bool IsFloating() const
    bool IsDocked() const
    bool IsToolbar() const
    bool IsTopDockable() const
    bool IsBottomDockable() const
    bool IsLeftDockable() const
    bool IsRightDockable() const
    bool IsFloatable() const
    bool IsMovable() const
    bool IsDestroyOnClose() const
    bool IsMaximized() const
    bool HasCaption() const
    bool HasGripper() const
    bool HasBorder() const
    bool HasCloseButton() const
    bool HasMaximizeButton() const
    bool HasMinimizeButton() const
    bool HasPinButton() const
    bool HasGripperTop() const

    wxAuiPaneInfo& Window(wxWindow* w)
    wxAuiPaneInfo& Name(const wxString& n)
    wxAuiPaneInfo& Caption(const wxString& c)
    wxAuiPaneInfo& Left()
    wxAuiPaneInfo& Right()
    wxAuiPaneInfo& Top()
    wxAuiPaneInfo& Bottom()
    wxAuiPaneInfo& Center()
    wxAuiPaneInfo& Centre()
    wxAuiPaneInfo& Direction(int direction)
    wxAuiPaneInfo& Layer(int layer)
    wxAuiPaneInfo& Row(int row)
    wxAuiPaneInfo& Position(int pos)
    wxAuiPaneInfo& BestSize(const wxSize& size)
    wxAuiPaneInfo& MinSize(const wxSize& size)
    wxAuiPaneInfo& MaxSize(const wxSize& size)
    wxAuiPaneInfo& BestSize(int x, int y)
    wxAuiPaneInfo& MinSize(int x, int y)
    wxAuiPaneInfo& MaxSize(int x, int y)
    wxAuiPaneInfo& FloatingPosition(const wxPoint& pos)
    wxAuiPaneInfo& FloatingPosition(int x, int y)
    wxAuiPaneInfo& FloatingSize(const wxSize& size)
    wxAuiPaneInfo& FloatingSize(int x, int y)
    wxAuiPaneInfo& Fixed()
    wxAuiPaneInfo& Resizable(bool resizable = true)
    wxAuiPaneInfo& Dock()
    wxAuiPaneInfo& Float()
    wxAuiPaneInfo& Hide()
    wxAuiPaneInfo& Show(bool show = true)
    wxAuiPaneInfo& CaptionVisible(bool visible = true)
    wxAuiPaneInfo& Maximize()
    wxAuiPaneInfo& Restore()
    wxAuiPaneInfo& PaneBorder(bool visible = true)
    wxAuiPaneInfo& Gripper(bool visible = true)
    wxAuiPaneInfo& GripperTop(bool attop = true)
    wxAuiPaneInfo& CloseButton(bool visible = true)
    wxAuiPaneInfo& MaximizeButton(bool visible = true)
    wxAuiPaneInfo& MinimizeButton(bool visible = true)
    wxAuiPaneInfo& PinButton(bool visible = true)
    wxAuiPaneInfo& DestroyOnClose(bool b = true)
    wxAuiPaneInfo& TopDockable(bool b = true)
    wxAuiPaneInfo& BottomDockable(bool b = true)
    wxAuiPaneInfo& LeftDockable(bool b = true)
    wxAuiPaneInfo& RightDockable(bool b = true)
    wxAuiPaneInfo& Floatable(bool b = true)
    wxAuiPaneInfo& Movable(bool b = true)

    wxAuiPaneInfo& Dockable(bool b = true)
    wxAuiPaneInfo& DefaultPane()

    wxAuiPaneInfo& CentrePane()
    wxAuiPaneInfo& CenterPane()

    wxAuiPaneInfo& ToolbarPane()
    wxAuiPaneInfo& SetFlag(unsigned int flag, bool option_state)
    bool HasFlag(unsigned int flag) const


    %member wxString name;        // name of the pane
    %member wxString caption;     // caption displayed on the window

    %member wxWindow* window;     // window that is in this pane
    %member wxFrame* frame;       // floating frame window that holds the pane
    %member unsigned int state;   // a combination of wxPaneState values

    %member int dock_direction;   // dock direction (top, bottom, left, right, center)
    %member int dock_layer;       // layer number (0 = innermost layer)
    %member int dock_row;         // row number on the docking bar (0 = first row)
    %member int dock_pos;         // position inside the row (0 = first position)

    %member wxSize best_size;     // size that the layout engine will prefer
    %member wxSize min_size;      // minimum size the pane window can tolerate
    %member wxSize max_size;      // maximum size the pane window can tolerate

    %member wxPoint floating_pos; // position while floating
    %member wxSize floating_size; // size while floating
    %member int dock_proportion;  // proportion while docked

    //%member wxAuiPaneButtonArray buttons; // buttons on the pane

    %member wxRect rect;              // current rectangle (populated by wxAUI)

%endclass


// ---------------------------------------------------------------------------
// wxAuiPaneInfoArray

%class %delete wxAuiPaneInfoArray
    wxAuiPaneInfoArray()
    wxAuiPaneInfoArray(const wxAuiPaneInfoArray& array)

    void Add(wxAuiPaneInfo pi)
    void Clear()
    int  GetCount() const
    //int  Index(wxAuiPaneInfo* page)
    void Insert(wxAuiPaneInfo pi, int nIndex)
    bool IsEmpty()
    wxAuiPaneInfo Item(size_t nIndex) const
    void RemoveAt(size_t nIndex)
%endclass


// ---------------------------------------------------------------------------
// wxAuiManager

%class %delete wxAuiManager, wxEvtHandler

    wxAuiManager(wxWindow* managed_wnd = NULL, unsigned int flags = wxAUI_MGR_DEFAULT);

    void UnInit();

    void SetFlags(unsigned int flags);
    unsigned int GetFlags() const;

    void SetManagedWindow(wxWindow* managed_wnd);
    wxWindow* GetManagedWindow() const;

    static wxAuiManager* GetManager(wxWindow* window);

    void SetArtProvider(%ungc wxAuiDockArt* art_provider);
    wxAuiDockArt* GetArtProvider() const;

    wxAuiPaneInfo& GetPane(wxWindow* window);
    wxAuiPaneInfo& GetPane(const wxString& name);
    wxAuiPaneInfoArray& GetAllPanes();

    bool AddPane(wxWindow* window, const wxAuiPaneInfo& pane_info);
    bool AddPane(wxWindow* window, const wxAuiPaneInfo& pane_info, const wxPoint& drop_pos);
    bool AddPane(wxWindow* window, int direction = wxLEFT, const wxString& caption = wxEmptyString);
    bool InsertPane(wxWindow* window, const wxAuiPaneInfo& insert_location, int insert_level = wxAUI_INSERT_PANE);
    bool DetachPane(wxWindow* window);

    void Update();

    wxString SavePaneInfo(wxAuiPaneInfo& pane);
    void LoadPaneInfo(wxString pane_part, wxAuiPaneInfo &pane);
    wxString SavePerspective();
    bool LoadPerspective(const wxString& perspective, bool update = true);

    void SetDockSizeConstraint(double width_pct, double height_pct);
    void GetDockSizeConstraint(double* width_pct, double* height_pct) const;

    void ClosePane(wxAuiPaneInfo& pane_info);
    void MaximizePane(wxAuiPaneInfo& pane_info);
    void RestorePane(wxAuiPaneInfo& pane_info);
    void RestoreMaximizedPane();

    virtual wxAuiFloatingFrame* CreateFloatingFrame(wxWindow* parent, const wxAuiPaneInfo& p);
    void StartPaneDrag( wxWindow* pane_window, const wxPoint& offset);
    wxRect CalculateHintRect( wxWindow* pane_window, const wxPoint& pt, const wxPoint& offset);
    void DrawHintRect( wxWindow* pane_window, const wxPoint& pt, const wxPoint& offset);

    virtual void ShowHint(const wxRect& rect);
    virtual void HideHint();

    // public events (which can be invoked externally)
    void OnRender(wxAuiManagerEvent& evt);
    void OnPaneButton(wxAuiManagerEvent& evt);
%endclass


// ---------------------------------------------------------------------------
// wxAuiManagerEvent

%class %delete wxAuiManagerEvent, wxEvent
    %define_event wxEVT_AUI_PANE_BUTTON     // EVT_AUI_PANE_BUTTON(func)
    %define_event wxEVT_AUI_PANE_CLOSE      // EVT_AUI_PANE_CLOSE(func)
    %define_event wxEVT_AUI_PANE_MAXIMIZE   // EVT_AUI_PANE_MAXIMIZE(func)
    %define_event wxEVT_AUI_PANE_RESTORE    // EVT_AUI_PANE_RESTORE(func)
    %define_event wxEVT_AUI_RENDER          // EVT_AUI_RENDER(func)
    %define_event wxEVT_AUI_FIND_MANAGER    // EVT_AUI_FIND_MANAGER(func)

    wxAuiManagerEvent(wxEventType type=wxEVT_NULL)
    wxAuiManagerEvent(const wxAuiManagerEvent& c)


    void SetManager(wxAuiManager* mgr)
    void SetPane(wxAuiPaneInfo* p)
    void SetButton(int b)
    void SetDC(wxDC* pdc)

    wxAuiManager* GetManager() const
    wxAuiPaneInfo* GetPane() const
    int GetButton() const
    wxDC* GetDC() const

    void Veto(bool veto = true)
    bool GetVeto() const
    void SetCanVeto(bool can_veto)
    bool CanVeto() const
%endclass


// ---------------------------------------------------------------------------
// wxAuiDockInfo

%class %delete wxAuiDockInfo
    %define_object wxAuiNullDockInfo

    wxAuiDockInfo()
    wxAuiDockInfo(const wxAuiDockInfo& c)

    %operator wxAuiDockInfo& operator=(const wxAuiDockInfo& c)

    bool IsOk() const
    bool IsHorizontal() const
    bool IsVertical() const


    //%member wxAuiPaneInfoPtrArray panes; // array of panes - FIXME
    %member wxRect rect;              // current rectangle
    %member int dock_direction;       // dock direction (top, bottom, left, right, center)
    %member int dock_layer;           // layer number (0 = innermost layer)
    %member int dock_row;             // row number on the docking bar (0 = first row)
    %member int size;                 // size of the dock
    %member int min_size;             // minimum size of a dock (0 if there is no min)
    %member bool resizable;           // flag indicating whether the dock is resizable
    %member bool toolbar;             // flag indicating dock contains only toolbars
    %member bool fixed;               // flag indicating that the dock operates on
                                      // absolute coordinates as opposed to proportional
    %member bool reserved1;

%endclass


// ---------------------------------------------------------------------------
// wxAuiDockUIPart

%enum wxAuiDockUIPart::dummy
    typeCaption,
    typeGripper,
    typeDock,
    typeDockSizer,
    typePane,
    typePaneSizer,
    typeBackground,
    typePaneBorder,
    typePaneButton
%endenum

%class %delete wxAuiDockUIPart

    %member int type;                // ui part type (see enum above)
    %member int orientation;         // orientation (either wxHORIZONTAL or wxVERTICAL)
    %member wxAuiDockInfo* dock;        // which dock the item is associated with
    %member wxAuiPaneInfo* pane;        // which pane the item is associated with
    %member wxAuiPaneButton* button;    // which pane button the item is associated with
    %member wxSizer* cont_sizer;     // the part's containing sizer
    %member wxSizerItem* sizer_item; // the sizer item of the part
    %member wxRect rect;             // client coord rectangle of the part itself
%endclass


// ---------------------------------------------------------------------------
// wxAuiPaneButton

%class %delete wxAuiPaneButton
    %member int button_id;        // id of the button (e.g. buttonClose)
%endclass


// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

//%include "wx/aui/tabmdi.h"

//-----------------------------------------------------------------------------
// wxAuiMDIParentFrame
//-----------------------------------------------------------------------------

%class wxAuiMDIParentFrame, wxFrame
    wxAuiMDIParentFrame()
    wxAuiMDIParentFrame(wxWindow *parent, wxWindowID winid, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE | wxVSCROLL | wxHSCROLL, const wxString& name = "wxAuiMDIParentFrame")

    bool Create(wxWindow *parent, wxWindowID winid, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE | wxVSCROLL | wxHSCROLL,const wxString& name = "wxAuiMDIParentFrame" )

    void SetArtProvider(%ungc wxAuiTabArt* provider);
    wxAuiTabArt* GetArtProvider();
    wxAuiNotebook* GetNotebook() const;

    wxMenu* GetWindowMenu() const
    void SetWindowMenu(wxMenu* pMenu);

    virtual void SetMenuBar(wxMenuBar *pMenuBar);

    void SetChildMenuBar(wxAuiMDIChildFrame *pChild);

    virtual bool ProcessEvent(wxEvent& event);

    wxAuiMDIChildFrame *GetActiveChild() const;
    void SetActiveChild(wxAuiMDIChildFrame* pChildFrame);

    wxAuiMDIClientWindow *GetClientWindow() const;
    virtual wxAuiMDIClientWindow *OnCreateClient();

    virtual void Cascade()      //{ /* Has no effect */ }
    virtual void Tile(wxOrientation orient = wxHORIZONTAL);
    virtual void ArrangeIcons() //{ /* Has no effect */ }
    virtual void ActivateNext();
    virtual void ActivatePrevious();

%endclass

//-----------------------------------------------------------------------------
// wxAuiMDIChildFrame
//-----------------------------------------------------------------------------

%class wxAuiMDIChildFrame, wxPanel
    wxAuiMDIChildFrame()
    wxAuiMDIChildFrame(wxAuiMDIParentFrame *parent, wxWindowID winid, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxAuiMDIChildFrame");

    bool Create(wxAuiMDIParentFrame *parent, wxWindowID winid, const wxString& title, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDEFAULT_FRAME_STYLE, const wxString& name = "wxAuiMDIChildFrame");

    virtual void SetMenuBar(wxMenuBar *menu_bar);
    virtual wxMenuBar *GetMenuBar() const;

    virtual void SetTitle(const wxString& title);
    virtual wxString GetTitle() const;

    virtual void SetIcons(const wxIconBundle& icons);
    virtual const wxIconBundle& GetIcons() const;

    virtual void SetIcon(const wxIcon& icon);
    virtual const wxIcon& GetIcon() const;

    virtual void Activate();
    virtual bool Destroy();

%if wxUSE_STATUSBAR
    // no status bars
    //virtual wxStatusBar* CreateStatusBar(int number = 1, long style = 1, wxWindowID winid = 1, const wxString& name = "") //{ return (wxStatusBar*)NULL; } - FIXME

    //virtual wxStatusBar *GetStatusBar() const { return (wxStatusBar*)NULL; }
    //virtual void SetStatusText( const wxString &WXUNUSED(text), int WXUNUSED(number)=0 ) {}
    //virtual void SetStatusWidths( int WXUNUSED(n), const int WXUNUSED(widths_field)[] ) {}
%endif //wxUSE_STATUSBAR

    // no size hints
    //virtual void DoSetSizeHints(int WXUNUSED(minW), int WXUNUSED(minH), int WXUNUSED(maxW) = wxDefaultCoord, int WXUNUSED(maxH) = wxDefaultCoord, int WXUNUSED(incW) = wxDefaultCoord, int WXUNUSED(incH) = wxDefaultCoord) {} - FIXME
%if wxUSE_TOOLBAR
    // no toolbar bars
    //virtual wxToolBar* CreateToolBar(long WXUNUSED(style), wxWindowID WXUNUSED(winid), const wxString& WXUNUSED(name)) { return (wxToolBar*)NULL; }
    //virtual wxToolBar *GetToolBar() const { return (wxToolBar*)NULL; }
%endif //wxUSE_TOOLBAR


    // no maximize etc
    //virtual void Maximize(bool WXUNUSED(maximize) = true) { /* Has no effect */ }
    //virtual void Restore() { /* Has no effect */ }
    //virtual void Iconize(bool WXUNUSED(iconize)  = true) { /* Has no effect */ }
    //virtual bool IsMaximized() const { return true; }
    //virtual bool IsIconized() const { return false; }
    //virtual bool ShowFullScreen(bool WXUNUSED(show), long WXUNUSED(style)) { return false; }
    //virtual bool IsFullScreen() const { return false; }

    //virtual bool IsTopLevel() const { return false; }

    //void OnMenuHighlight(wxMenuEvent& evt);
    //void OnActivate(wxActivateEvent& evt);
    //void OnCloseWindow(wxCloseEvent& evt);

    void SetMDIParentFrame(wxAuiMDIParentFrame* parent);
    wxAuiMDIParentFrame* GetMDIParentFrame() const;

    // This function needs to be called when a size change is confirmed,
    // we needed this function to prevent anybody from the outside
    // changing the panel... it messes the UI layout when we would allow it.
    void ApplyMDIChildFrameRect();
    void DoShow(bool show);

%endclass

//-----------------------------------------------------------------------------
// wxAuiMDIClientWindow
//-----------------------------------------------------------------------------

%class wxAuiMDIClientWindow, wxAuiNotebook
    wxAuiMDIClientWindow();
    wxAuiMDIClientWindow(wxAuiMDIParentFrame *parent, long style = 0);

    virtual bool CreateClient(wxAuiMDIParentFrame *parent, long style = wxVSCROLL | wxHSCROLL);

    virtual int SetSelection(size_t page);

%endclass

%endif // wxLUA_USE_wxAUI && %wxchkver_2_8 && wxUSE_AUI
