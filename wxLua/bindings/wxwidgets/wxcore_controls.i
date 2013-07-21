// ===========================================================================
// Purpose:     GUI controls like buttons, combos, etc
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

// FIXME - handle WX_DECLARE_CONTROL_CONTAINER ?

// ---------------------------------------------------------------------------
// wxButton

#if wxLUA_USE_wxButton && wxUSE_BUTTON

#include "wx/button.h"

#define wxBU_LEFT
#define wxBU_RIGHT
#define wxBU_TOP
#define wxBU_BOTTOM
#define wxBU_EXACTFIT
%wxchkver_2_6 #define wxBU_AUTODRAW

class wxButton : public wxControl
{
    wxButton( );
    wxButton(wxWindow *parent, wxWindowID id, const wxString& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxButton" );
    bool Create(wxWindow *parent, wxWindowID id, const wxString& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxButton" );

    static wxSize GetDefaultSize(); // static is ok, use on existing button
    void     SetDefault( );

    //wxString GetLabel() const;                 // in wxWindow
    //void     SetLabel(const wxString& label);  // in wxWindow
};

// ---------------------------------------------------------------------------
// wxBitmapButton

#if wxLUA_USE_wxBitmapButton && wxUSE_BMPBUTTON

#include "wx/bmpbuttn.h"

class wxBitmapButton : public wxButton
{
    wxBitmapButton( );
    wxBitmapButton( wxWindow* parent, wxWindowID id, const wxBitmap& bitmap, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxBU_AUTODRAW, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxBitmapButton" );
    bool Create(wxWindow* parent, wxWindowID id, const wxBitmap& bitmap, const wxPoint& pos, const wxSize& size = wxDefaultSize, long style = wxBU_AUTODRAW, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxBitmapButton" );

    wxBitmap GetBitmapDisabled() const;
    wxBitmap GetBitmapFocus() const;
    %wxchkver_2_8 wxBitmap GetBitmapHover() const;
    wxBitmap GetBitmapLabel() const;
    wxBitmap GetBitmapSelected() const;
    void     SetBitmapDisabled(const wxBitmap& bitmap );
    void     SetBitmapFocus(const wxBitmap& bitmap );
    %wxchkver_2_8 void SetBitmapHover(const wxBitmap& hover );
    void     SetBitmapLabel(const wxBitmap& bitmap );
    void     SetBitmapSelected(const wxBitmap& bitmap );
};

#endif //wxLUA_USE_wxBitmapButton && wxUSE_BMPBUTTON
#endif //wxLUA_USE_wxButton && wxUSE_BUTTON

// ---------------------------------------------------------------------------
// wxToggleButton

#if wxLUA_USE_wxToggleButton && wxUSE_TOGGLEBTN

#include "wx/tglbtn.h"

class wxToggleButton : public wxControl
{
    wxToggleButton( );
    wxToggleButton(wxWindow *parent, wxWindowID id, const wxString& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxToggleButton" );
    bool Create(wxWindow *parent, wxWindowID id, const wxString& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxToggleButton" );

    void SetValue(bool state );
    bool GetValue() const;

    //wxString GetLabel() const;                 // in wxWindow
    //void     SetLabel(const wxString& label);  // in wxWindow
};

#endif //wxLUA_USE_wxToggleButton && wxUSE_TOGGLEBTN

// ---------------------------------------------------------------------------
// wxCheckBox

#if wxLUA_USE_wxCheckBox && wxUSE_CHECKBOX

#include "wx/checkbox.h"

#define wxCHK_2STATE
#define wxCHK_3STATE
#define wxCHK_ALLOW_3RD_STATE_FOR_USER

enum wxCheckBoxState
{
    wxCHK_UNCHECKED,
    wxCHK_CHECKED,
    wxCHK_UNDETERMINED
};

class wxCheckBox : public wxControl
{
    wxCheckBox( );
    wxCheckBox(wxWindow* parent, wxWindowID id, const wxString& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& val = wxDefaultValidator, const wxString& name = "wxCheckBox" );
    bool Create(wxWindow* parent, wxWindowID id, const wxString& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& val = wxDefaultValidator, const wxString& name = "wxCheckBox" );

    bool GetValue() const;
    wxCheckBoxState Get3StateValue() const;
    bool Is3rdStateAllowedForUser() const;
    bool Is3State() const;
    bool IsChecked() const;
    void SetValue(const bool state );
    void Set3StateValue(const wxCheckBoxState state );
};

#endif //wxLUA_USE_wxCheckBox && wxUSE_CHECKBOX

// ---------------------------------------------------------------------------
// wxItemContainerImmutable

#if (wxLUA_USE_wxChoice|wxLUA_USE_wxComboBox|wxLUA_USE_wxListBox) && wxUSE_CONTROLS

#include "wx/ctrlsub.h"

class wxItemContainerImmutable
{
    // no constructor, used only as a base class

    virtual unsigned int GetCount() const;
    virtual bool IsEmpty() const;

    virtual wxString GetString(unsigned int n); // = 0;
    wxArrayString GetStrings() const;
    virtual void SetString(unsigned int n, const wxString& s); // = 0;

    virtual int FindString(const wxString& s, bool bCase = false) const;

    virtual void SetSelection(int n); //= 0;
    virtual int GetSelection() const; //= 0;

    bool SetStringSelection(const wxString& s );
    wxString GetStringSelection() const;

    void Select(int n );
};

// ---------------------------------------------------------------------------
// wxItemContainer

#include "wx/ctrlsub.h"

class wxItemContainer : public wxItemContainerImmutable
{
    // no constructor, used only as base class

    int Append(const wxString& item );
    int Append(const wxString&  item, voidptr_long number); // C++ is (void *clientData) You can put a number here
    int Append(const wxString& item, wxClientData *clientData );

    void AppendString( const wxString& item );

    void Append(const wxArrayString& strings);

    int Insert(const wxString& item, unsigned int pos );
    int Insert(const wxString&  item, unsigned int pos, voidptr_long number); // C++ is (void *clientData) You can put a number here
    int Insert(const wxString& item, unsigned int pos, wxClientData *clientData);

    virtual void Clear(); //= 0;
    virtual void Delete(unsigned int n); //= 0;


    void SetClientData(unsigned int n, voidptr_long number); // C++ is (void *clientData) You can put a number here
    voidptr_long GetClientData(unsigned int n) const; // C++ returns (void *) You get a number here

    void SetClientObject(unsigned int n, wxClientData* clientData );
    wxClientData* GetClientObject(unsigned int n) const;

    bool HasClientObjectData() const;
    bool HasClientUntypedData() const;
};

#endif

// ---------------------------------------------------------------------------
// wxControlWithItems

#include "wx/ctrlsub.h"

class wxControlWithItems : public wxControl, public wxItemContainer
{
    // no constructor, this is just a base class

    virtual bool ShouldInheritColours() const;
};

#endif //(wxLUA_USE_wxChoice|wxLUA_USE_wxComboBox|wxLUA_USE_wxListBox) && wxUSE_CONTROLS

// ---------------------------------------------------------------------------
// wxChoice

#if wxLUA_USE_wxChoice && wxUSE_CHOICE

#include "wx/choice.h"

class wxChoice : public wxControlWithItems
{
    wxChoice( );
    wxChoice(wxWindow *parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxChoice" );
    bool Create(wxWindow *parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxChoice" );

    int    GetCurrentSelection() const;
    //int  GetColumns() const;       // Motif only but returns 1 otherwise
    //void SetColumns(int n = 1 );

    void Command(wxCommandEvent& event );
};

#endif //wxLUA_USE_wxChoice && wxUSE_CHOICE

// ---------------------------------------------------------------------------
// wxComboBox

#if wxLUA_USE_wxComboBox && wxUSE_COMBOBOX

#include "wx/combobox.h"

#define wxCB_DROPDOWN
#define wxCB_READONLY
#define wxCB_SIMPLE
#define wxCB_SORT

class wxComboBox : public wxControl, public wxItemContainer
{
    wxComboBox( );
    wxComboBox(wxWindow* parent, wxWindowID id, const wxString& value = "", const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxComboBox" );
    bool Create(wxWindow* parent, wxWindowID id, const wxString& value = "", const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxComboBox" );

    bool     CanCopy() const;
    bool     CanCut() const;
    bool     CanPaste() const;
    bool     CanRedo() const;
    bool     CanUndo() const;
    void     Copy( );
    void     Cut( );
    %wxchkver_2_8 virtual int GetCurrentSelection() const;
    long     GetInsertionPoint() const;
    long     GetLastPosition() const;
    wxString GetValue() const;
    void     Paste( );
    void     Redo( );
    void     Replace(long from, long to, const wxString& text );
    void     Remove(long from, long to );
    void     SetInsertionPoint(long pos );
    void     SetInsertionPointEnd( );
    void     SetSelection(long from, long to );
    void     SetValue(const wxString& text );
    void     Undo( );
};

#endif //wxLUA_USE_wxComboBox && wxUSE_COMBOBOX

// ---------------------------------------------------------------------------
// wxGauge

#if wxLUA_USE_wxGauge && wxUSE_GAUGE

#include "wx/gauge.h"

#define wxGA_HORIZONTAL
%wxcompat_2_6 #define wxGA_PROGRESSBAR
#define wxGA_SMOOTH
#define wxGA_VERTICAL

class wxGauge : public wxControl
{
    wxGauge( );
    wxGauge(wxWindow* parent, wxWindowID id, int range, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxGA_HORIZONTAL, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxGauge" );
    bool Create(wxWindow* parent, wxWindowID id, int range, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxGA_HORIZONTAL, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxGauge" );

    int      GetBezelFace() const;
    int      GetRange() const;
    int      GetShadowWidth() const;
    int      GetValue() const;
    bool     IsVertical() const;
    %wxchkver_2_8 void Pulse( );
    void     SetBezelFace(int width );
    void     SetRange(int range );
    void     SetShadowWidth(int width );
    void     SetValue(int pos );
};

#endif //wxLUA_USE_wxGauge && wxUSE_GAUGE

// ---------------------------------------------------------------------------
// wxListBox

#if wxLUA_USE_wxListBox && wxUSE_LISTBOX

#include "wx/listbox.h"

#define wxLB_SINGLE
#define wxLB_MULTIPLE
#define wxLB_EXTENDED
#define wxLB_HSCROLL
#define wxLB_ALWAYS_SB
#define wxLB_NEEDED_SB
#define wxLB_SORT
#define wxLB_OWNERDRAW

class wxListBox : public wxControlWithItems
{
    wxListBox( );
    wxListBox(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxListBox" );
    bool Create(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxListBox" );

    void     Deselect(int n );

    // %override [Lua table of int selections] wxListBox::GetSelections( );
    // C++ Func: int GetSelections(wxArrayInt& selections) const;
    int GetSelections() const;

    %wxchkver_2_8 int HitTest(const wxPoint& point) const;
    //void     InsertItems(int nItems, const wxString items[], int pos );
    void     InsertItems(const wxArrayString& items, int pos );
    bool     IsSelected(int n) const;
    //void     Set(int n, const wxString* choices );
    void     Set(const wxArrayString& choices );
    void     SetFirstItem(int n );
    void     SetSelection(int n, bool select = true );
    void     SetStringSelection(const wxString& string, bool select = true );
};

// ---------------------------------------------------------------------------
// wxCheckListBox

#if wxLUA_USE_wxCheckListBox && wxUSE_CHECKLISTBOX

#include "wx/checklst.h"

class wxCheckListBox : public wxListBox
{
    wxCheckListBox( );
    wxCheckListBox(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxCheckListBox" );
    bool Create(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxCheckListBox" );

    void     Check(int item, bool check = true );
    bool     IsChecked(int item) const;
};

#endif //wxLUA_USE_wxCheckListBox && wxUSE_CHECKLISTBOX
#endif //wxLUA_USE_wxListBox && wxUSE_LISTBOX

// ---------------------------------------------------------------------------
// wxListCtrl

#if wxLUA_USE_wxListCtrl && wxUSE_LISTCTRL

#include "wx/listctrl.h"

#define wxLC_ALIGN_LEFT
#define wxLC_ALIGN_TOP
#define wxLC_AUTOARRANGE
#define wxLC_EDIT_LABELS
#define wxLC_HRULES
#define wxLC_ICON
#define wxLC_LIST
#define wxLC_NO_HEADER
#define wxLC_NO_SORT_HEADER
#define wxLC_REPORT
#define wxLC_SINGLE_SEL
#define wxLC_SMALL_ICON
#define wxLC_SORT_ASCENDING
#define wxLC_SORT_DESCENDING
//#define wxLC_USER_TEXT - deprecated - use wxLC_VIRTUAL
#define wxLC_VIRTUAL
#define wxLC_VRULES

#define wxLC_MASK_TYPE     //  (wxLC_ICON | wxLC_SMALL_ICON | wxLC_LIST | wxLC_REPORT );
#define wxLC_MASK_ALIGN    //  (wxLC_ALIGN_TOP | wxLC_ALIGN_LEFT );
#define wxLC_MASK_SORT     //  (wxLC_SORT_ASCENDING | wxLC_SORT_DESCENDING );

#define wxLIST_ALIGN_DEFAULT
#define wxLIST_ALIGN_LEFT
#define wxLIST_ALIGN_SNAP_TO_GRID
#define wxLIST_ALIGN_TOP
#define wxLIST_AUTOSIZE
#define wxLIST_AUTOSIZE_USEHEADER
#define wxLIST_FIND_DOWN
#define wxLIST_FIND_LEFT
#define wxLIST_FIND_RIGHT
#define wxLIST_FIND_UP
#define wxLIST_HITTEST_ABOVE
#define wxLIST_HITTEST_BELOW
#define wxLIST_HITTEST_NOWHERE
#define wxLIST_HITTEST_ONITEM
#define wxLIST_HITTEST_ONITEMICON
#define wxLIST_HITTEST_ONITEMLABEL
#define wxLIST_HITTEST_ONITEMRIGHT
#define wxLIST_HITTEST_ONITEMSTATEICON
#define wxLIST_HITTEST_TOLEFT
#define wxLIST_HITTEST_TORIGHT
#define wxLIST_MASK_DATA
#define wxLIST_MASK_FORMAT
#define wxLIST_MASK_IMAGE
#define wxLIST_MASK_STATE
#define wxLIST_MASK_TEXT
#define wxLIST_MASK_WIDTH
#define wxLIST_NEXT_ABOVE
#define wxLIST_NEXT_ALL
#define wxLIST_NEXT_BELOW
#define wxLIST_NEXT_LEFT
#define wxLIST_NEXT_RIGHT
#define wxLIST_RECT_BOUNDS
#define wxLIST_RECT_ICON
#define wxLIST_RECT_LABEL
#define wxLIST_SET_ITEM
#define wxLIST_STATE_CUT
#define wxLIST_STATE_DONTCARE
#define wxLIST_STATE_DROPHILITED
#define wxLIST_STATE_FOCUSED
#define wxLIST_STATE_SELECTED

%wxchkver_2_8 #define wxLIST_GETSUBITEMRECT_WHOLEITEM

class wxListCtrl : public wxControl
{
    wxListCtrl( );
    wxListCtrl(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxLC_ICON, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxListCtrl" );
    bool Create(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxLC_ICON, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxListCtrl" );

    bool     Arrange(int flag = wxLIST_ALIGN_DEFAULT );
    void     AssignImageList(%ungc wxImageList *imageList, int which );
    void     ClearAll( );
    bool     DeleteAllItems( );
    bool     DeleteColumn(int col );
    bool     DeleteItem(long item );
    void     EditLabel(long item );
    bool     EnsureVisible(long item );
    long     FindItem(long start, const wxString& str, const bool partial = false );
    long     FindItem(long start, long data );
    long     FindItem(long start, const wxPoint& pt, int direction );
    bool     GetColumn(int col, wxListItem& item) const;
    int      GetColumnCount() const;
    int      GetColumnWidth(int col) const;
    int      GetCountPerPage() const;
    %win|%wxchkver_2_8 wxTextCtrl* GetEditControl() const;
    wxImageList* GetImageList(int which) const;
    bool     GetItem(wxListItem& info) const;
    int      GetItemCount() const;
    long     GetItemData(long item) const;
    wxFont   GetItemFont(long item) const;
    bool     GetItemPosition(long item, wxPoint& pos) const;
    bool     GetItemRect(long item, wxRect& rect, int code = wxLIST_RECT_BOUNDS) const;
    !%wxchkver_2_6 int   GetItemSpacing(bool isSmall) const;
    %wxchkver_2_6 wxSize GetItemSpacing() const;
    int      GetItemState(long item, long stateMask) const;
    wxString GetItemText(long item) const;
    long     GetNextItem(long item, int geometry = wxLIST_NEXT_ALL, int state = wxLIST_STATE_DONTCARE) const;
    int      GetSelectedItemCount() const;
    wxColour GetTextColour() const;
    long     GetTopItem() const;
    wxRect   GetViewRect() const;

    // %override [long, int flags] wxListCtrl::HitTest(const wxPoint& point );
    // C++ Func: long HitTest(const wxPoint& point, int& flags );
    long     HitTest(const wxPoint& point );

    long     InsertColumn(long col, wxListItem& info );
    long     InsertColumn(long col, const wxString& heading, int format = wxLIST_FORMAT_LEFT, int width = -1 );
    long     InsertItem(wxListItem& info );
    long     InsertItem(long index, const wxString& label );
    long     InsertItem(long index, int imageIndex );
    long     InsertItem(long index, const wxString& label, int imageIndex );
    //virtual wxListItemAttr * OnGetItemAttr(long item) const;
    //virtual int OnGetItemImage(long item );
    //virtual wxString OnGetItemText(long item, long column) const;
    //void RefreshItem(long item );
    //void RefreshItems(long itemFrom, long itemTo );
    bool     ScrollList(int dx, int dy );
    //void     SetBackgroundColour(const wxColour& col) - see wxWindow
    bool     SetColumn(int col, wxListItem& item );
    bool     SetColumnWidth(int col, int width );
    void     SetImageList(wxImageList* imageList, int which );
    bool     SetItem(wxListItem& info );
    long     SetItem(long index, int col, const wxString& label, int imageId = -1 );
    void     SetItemBackgroundColour(long item, const wxColour& col );
    bool     SetItemColumnImage(long item, long column, int image );
    //void SetItemCount(long count );
    bool     SetItemData(long item, long data );
    bool     SetItemImage(long item, int image); // int selImage) selImage is deprecated and isn't used anyway
    bool     SetItemPosition(long item, const wxPoint& pos );
    bool     SetItemState(long item, long state, long stateMask );
    void     SetItemText(long item, const wxString& text );
    void     SetItemTextColour(long item, const wxColour& col );
    void     SetSingleStyle(long style, const bool add = true );
    void     SetTextColour(const wxColour& col );
    //void     SetWindowStyleFlag(long style) - see wxWindow

    // %override bool SortItems(Lua function(long item1, long item2, long data) returning int, long data );
    // C++ Func: bool SortItems(wxListCtrlCompare fnSortCallBack, long data );
    // Note: the data can only be a number, but you can create a table where the data is
    // an index of it if you need more information.
    // Also, the item1 and item2 are NOT the indexes in the wxListCtrl, but are the
    // client data associated with the item. see SetItemData(item, data) and again
    // you may want to make this "data" equal to an index in a table where you
    // store more information needed for sorting.
    // Your Lua function should return 1, 0, -1 for item1 > item2, item1 == item2, item1 < item2
    bool SortItems(LuaFunction fnSortCallBack, long data );
};

// ---------------------------------------------------------------------------
// wxListItemAttr - wxListCtrl

class %delete wxListItemAttr
{
    wxListItemAttr(const wxColour& colText = wxNullColour, const wxColour& colBack = wxNullColour, const wxFont& font = wxNullFont );

    %wxchkver_2_8 void AssignFrom(const wxListItemAttr& source );
    wxColour GetBackgroundColour( );
    wxFont GetFont( );
    wxColour GetTextColour( );
    bool HasBackgroundColour( );
    bool HasFont( );
    bool HasTextColour( );
    void SetBackgroundColour(const wxColour& colBack );
    void SetFont(const wxFont& font );
    void SetTextColour(const wxColour& colText );
};

// ---------------------------------------------------------------------------
// wxListItem - wxListCtrl

enum wxListColumnFormat
{
    wxLIST_FORMAT_LEFT,
    wxLIST_FORMAT_RIGHT,
    wxLIST_FORMAT_CENTRE,
    wxLIST_FORMAT_CENTER
};

class %delete wxListItem : public wxObject
{
    wxListItem( );
    wxListItem(const wxListItem& item );

    void     Clear( );
    void     ClearAttributes( );
    wxListColumnFormat GetAlign( );
    wxListItemAttr *GetAttributes( );
    wxColour GetBackgroundColour() const;
    int      GetColumn( );
    long     GetData( );
    wxFont   GetFont() const;
    long     GetId( );
    int      GetImage( );
    long     GetMask( );
    long     GetState( );
    wxString GetText( );
    wxColour GetTextColour() const;
    int      GetWidth( );
    bool     HasAttributes( );
    void     SetAlign(wxListColumnFormat align );
    void     SetBackgroundColour(const wxColour& colBack );
    void     SetColumn(int col );
    void     SetData(long data );
    void     SetFont(const wxFont& font );
    void     SetId(long id );
    void     SetImage(int image );
    void     SetMask(long mask );
    void     SetState(long state );
    void     SetStateMask(long stateMask );
    void     SetText(const wxString& text );
    void     SetTextColour(const wxColour& colText );
    void     SetWidth(int width );
};

// ---------------------------------------------------------------------------
// wxListEvent - wxListCtrl

class %delete wxListEvent : public wxNotifyEvent
{
    %wxEventType wxEVT_COMMAND_LIST_BEGIN_DRAG             // EVT_LIST_BEGIN_DRAG(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_BEGIN_RDRAG            // EVT_LIST_BEGIN_RDRAG(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_BEGIN_LABEL_EDIT       // EVT_LIST_BEGIN_LABEL_EDIT(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_COL_CLICK              // EVT_LIST_COL_CLICK(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_DELETE_ALL_ITEMS       // EVT_LIST_DELETE_ALL_ITEMS(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_DELETE_ITEM            // EVT_LIST_DELETE_ITEM(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_END_LABEL_EDIT         // EVT_LIST_END_LABEL_EDIT(id, fn );
    !%wxchkver_2_6 %wxEventType wxEVT_COMMAND_LIST_GET_INFO // EVT_LIST_GET_INFO(id, fn );
    !%wxchkver_2_6 %wxEventType wxEVT_COMMAND_LIST_SET_INFO // EVT_LIST_SET_INFO(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_INSERT_ITEM            // EVT_LIST_INSERT_ITEM(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_ITEM_ACTIVATED         // EVT_LIST_ITEM_ACTIVATED(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_ITEM_DESELECTED        // EVT_LIST_ITEM_DESELECTED(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_ITEM_MIDDLE_CLICK      // EVT_LIST_ITEM_MIDDLE_CLICK(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_ITEM_RIGHT_CLICK       // EVT_LIST_ITEM_RIGHT_CLICK(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_ITEM_SELECTED          // EVT_LIST_ITEM_SELECTED(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_KEY_DOWN               // EVT_LIST_KEY_DOWN(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_CACHE_HINT             // EVT_LIST_CACHE_HINT(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_COL_RIGHT_CLICK        // EVT_LIST_COL_RIGHT_CLICK(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_COL_BEGIN_DRAG         // EVT_LIST_COL_BEGIN_DRAG(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_COL_DRAGGING           // EVT_LIST_COL_DRAGGING(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_COL_END_DRAG           // EVT_LIST_COL_END_DRAG(id, fn );
    %wxEventType wxEVT_COMMAND_LIST_ITEM_FOCUSED           // EVT_LIST_ITEM_FOCUSED(id, fn );

    wxListEvent(wxEventType commandType = 0, int id = 0 );

    //long GetCacheFrom() const; // - only useful for virtual controls
    //long GetCacheTo() const;
    int GetKeyCode() const;
    long GetIndex() const;
    int GetColumn() const;
    wxPoint GetPoint() const;
    const wxString& GetLabel() const;
    const wxString& GetText() const;
    int GetImage() const;
    long GetData() const;
    long GetMask() const;
    const wxListItem& GetItem() const;
    bool IsEditCancelled() const;
};

// ---------------------------------------------------------------------------
// wxListView

class wxListView : public wxListCtrl
{
    wxListView( );
    wxListView(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxLC_ICON, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxListView" );
    bool Create(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxLC_ICON, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxListView" );

    void ClearColumnImage(int col );
    void Focus(long index );
    long GetFirstSelected() const;
    long GetFocusedItem() const;
    long GetNextSelected(long item) const;
    bool IsSelected(long index );
    void Select(long n, bool on = true );
    void SetColumnImage(int col, int image );
};

#endif //wxLUA_USE_wxListCtrl && wxUSE_LISTCTRL

// ---------------------------------------------------------------------------
// wxRadioBox

#if wxLUA_USE_wxRadioBox && wxUSE_RADIOBOX

#include "wx/radiobox.h"

#define wxRA_VERTICAL
#define wxRA_HORIZONTAL
#define wxRA_SPECIFY_COLS
#define wxRA_SPECIFY_ROWS
// #define wxRA_USE_CHECKBOX - only for palm os

class wxRadioBox : public wxControl
{
    wxRadioBox( );
    wxRadioBox(wxWindow* parent, wxWindowID id, const wxString& label, const wxPoint& point = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, int majorDimension = 0, long style = wxRA_SPECIFY_COLS, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxRadioBox" );
    bool Create(wxWindow* parent, wxWindowID id, const wxString& label, const wxPoint& point = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxArrayString& choices = wxLuaNullSmartwxArrayString, int majorDimension = 0, long style = wxRA_SPECIFY_COLS, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxRadioBox" );

    // these are marked deprecated in 2.6, use wxWindow::Get/SetLabel and Get/SetString below
    // wxString GetLabel() const; // - see wxWindow
    // void SetLabel(const wxString& label); // - see wxWindow
    // wxString GetLabel(int n) const;
    // void SetLabel(int n, const wxString& label );

    void Enable(bool enable );
    void Enable(int n, bool enable );
    int FindString(const wxString& string) const;
    int GetCount() const;
    int GetSelection() const;
    wxString GetStringSelection() const;
    wxString GetString(int n) const;
    void SetString(int n, const wxString &label );
    void SetSelection(int n );
    void SetStringSelection(const wxString& string );
    //bool Show(bool show = true); // see wxWindow
    bool Show(int item, bool show); // must specify both for overload
};

#endif //wxLUA_USE_wxRadioBox && wxUSE_RADIOBOX

// ---------------------------------------------------------------------------
// wxRadioButton

#if wxLUA_USE_wxRadioButton && wxUSE_RADIOBTN

#include "wx/radiobut.h"

#define wxRB_GROUP
#define wxRB_SINGLE
// #define wxRB_USE_CHECKBOX - only for palm os

class wxRadioButton : public wxControl
{
    wxRadioButton( );
    wxRadioButton(wxWindow* parent, wxWindowID id, const wxString& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxRadioButton" );
    bool Create(wxWindow* parent, wxWindowID id, const wxString& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxRadioButton" );

    bool GetValue() const;
    void SetValue(const bool value );
};

#endif //wxLUA_USE_wxRadioButton && wxUSE_RADIOBTN

// ---------------------------------------------------------------------------
// wxScrollBar

#if wxLUA_USE_wxScrollBar && wxUSE_SCROLLBAR

#include "wx/scrolbar.h"

#define wxSB_HORIZONTAL
#define wxSB_VERTICAL

class wxScrollBar : public wxControl
{
    wxScrollBar( );
    wxScrollBar(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSB_HORIZONTAL, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxScrollBar" );
    bool Create(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSB_HORIZONTAL, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxScrollBar" );

    int GetRange() const;
    int GetPageSize() const;
    int GetThumbPosition() const;
    int GetThumbSize() const;
    void SetThumbPosition(int viewStart );
    virtual void SetScrollbar(int position, int thumbSize, int range, int pageSize, const bool refresh = true );
};

#endif //wxLUA_USE_wxScrollBar && wxUSE_SCROLLBAR

// ---------------------------------------------------------------------------
// wxSlider

#if wxLUA_USE_wxSlider && wxUSE_SLIDER

#include "wx/slider.h"

#define wxSL_AUTOTICKS
#define wxSL_BOTH
#define wxSL_BOTTOM
#define wxSL_HORIZONTAL
#define wxSL_LABELS
#define wxSL_LEFT
// #define wxSL_NOTIFY_DRAG %wxcompat_2_6 obsolete
#define wxSL_RIGHT
#define wxSL_SELRANGE
#define wxSL_TOP
#define wxSL_VERTICAL

class wxSlider : public wxControl
{
    wxSlider( );
    wxSlider(wxWindow* parent, wxWindowID id, int value , int minValue, int maxValue, const wxPoint& point = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSL_HORIZONTAL, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxSlider" );
    bool Create(wxWindow* parent, wxWindowID id, int value , int minValue, int maxValue, const wxPoint& point = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSL_HORIZONTAL, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxSlider" );

    void ClearSel( );
    void ClearTicks( );
    int GetLineSize() const;
    int GetMax() const;
    int GetMin() const;
    int GetPageSize() const;
    int GetSelEnd() const;
    int GetSelStart() const;
    int GetThumbLength() const;
    int GetTickFreq() const;
    int GetValue() const;
    void SetLineSize(int lineSize );
    void SetPageSize(int pageSize );
    void SetRange(int minValue, int maxValue );
    void SetSelection(int startPos, int endPos );
    void SetThumbLength(int len );
    void SetTick(int tickPos );
    void SetTickFreq(int n, int pos );
    void SetValue(int value );
};

#endif //wxLUA_USE_wxSlider && wxUSE_SLIDER

// ---------------------------------------------------------------------------
// wxSpinButton

#if wxLUA_USE_wxSpinButton && wxUSE_SPINBTN

#include "wx/spinbutt.h"

#define wxSP_HORIZONTAL
#define wxSP_VERTICAL
#define wxSP_ARROW_KEYS
#define wxSP_WRAP

class wxSpinButton : public wxControl
{
    wxSpinButton( );
    wxSpinButton(wxWindow *parent, wxWindowID id = wxID_ANY, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSP_VERTICAL | wxSP_ARROW_KEYS, const wxString& name = "wxSpinButton" );
    bool Create(wxWindow *parent, wxWindowID id = wxID_ANY, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSP_VERTICAL | wxSP_ARROW_KEYS, const wxString& name = "wxSpinButton" );

    int GetMax() const;
    int GetMin() const;
    int GetValue() const;
    void SetRange(int min, int max );
    void SetValue(int value );
};

// ---------------------------------------------------------------------------
// wxSpinEvent - for wxSpinButton

#include "wx/spinbutt.h"
#include "wx/spinctrl.h"

class %delete wxSpinEvent : public wxNotifyEvent
{
    %wxEventType wxEVT_SCROLL_LINEUP     // EVT_SPIN_UP(winid, func );
    %wxEventType wxEVT_SCROLL_LINEDOWN   // EVT_SPIN_DOWN(winid, func );
    %wxEventType wxEVT_SCROLL_THUMBTRACK // EVT_SPIN(winid, func );
    //%wxEventType wxEVT_COMMAND_SPINCTRL_UPDATED - actually a wxCommandEvent is sent

    wxSpinEvent(wxEventType commandType = wxEVT_NULL, int id = 0 );

    int GetPosition() const;
    void SetPosition(int pos );
};

#endif //wxLUA_USE_wxSpinButton && wxUSE_SPINBTN

// ---------------------------------------------------------------------------
// wxSpinCtrl

#if wxLUA_USE_wxSpinCtrl && wxUSE_SPINCTRL

#include "wx/spinctrl.h"

//#define wxSP_ARROW_KEYS   see wxSpinButton
//#define wxSP_WRAP         see wxSpinButton

class wxSpinCtrl : public wxControl
{
    wxSpinCtrl( );
    wxSpinCtrl(wxWindow* parent, wxWindowID id = wxID_ANY, const wxString& value = wxEmptyString, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSP_ARROW_KEYS, int min = 0, int max = 100, int initial = 0, const wxString& name = "wxSpinCtrl" );
    bool Create(wxWindow* parent, wxWindowID id = wxID_ANY, const wxString& value = wxEmptyString, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSP_ARROW_KEYS, int min = 0, int max = 100, int initial = 0, const wxString& name = "wxSpinCtrl" );

    int GetMax() const;
    int GetMin() const;
    int GetValue() const;
    void SetRange(int minVal, int maxVal );
    void SetSelection(long from, long to );
    void SetValue(const wxString& text );
    void SetValue(int iValue );
};

#endif //wxLUA_USE_wxSpinCtrl && wxUSE_SPINCTRL

// ---------------------------------------------------------------------------
// wxTextCtrl

#if wxLUA_USE_wxTextCtrl && wxUSE_TEXTCTRL

#include "wx/textctrl.h"

#define wxTE_PROCESS_ENTER
#define wxTE_PROCESS_TAB
#define wxTE_MULTILINE
#define wxTE_PASSWORD
#define wxTE_READONLY
#define wxTE_RICH
#define wxTE_RICH2
#define wxTE_AUTO_URL
#define wxTE_NOHIDESEL
#define wxTE_LEFT
#define wxTE_CENTRE
#define wxTE_RIGHT
#define wxTE_DONTWRAP
// #define wxTE_LINEWRAP %wxcompat_2_6 obsolete use wxTE_CHARWRAP
#define wxTE_CHARWRAP
#define wxTE_WORDWRAP
#define wxTE_BESTWRAP
#define wxTE_CAPITALIZE
#define wxTE_AUTO_SCROLL
#define wxTE_NO_VSCROLL

enum wxTextCtrlHitTestResult
{
    wxTE_HT_UNKNOWN,
    wxTE_HT_BEFORE,
    wxTE_HT_ON_TEXT,
    wxTE_HT_BELOW,
    wxTE_HT_BEYOND
};

typedef long wxTextCoord
#define wxOutOfRangeTextCoord
#define wxInvalidTextCoord

class wxTextCtrl : public wxControl
{
    wxTextCtrl( );
    wxTextCtrl(wxWindow *parent, wxWindowID id, const wxString& value = "", const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxTextCtrl" );
    bool Create(wxWindow* parent, wxWindowID id, const wxString& value = "", const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxTextCtrl" );

    void AppendText(const wxString& text );
    virtual bool CanCopy( );
    virtual bool CanCut( );
    virtual bool CanPaste( );
    virtual bool CanRedo( );
    virtual bool CanUndo( );
    virtual void ChangeValue(const wxString& value );
    virtual void Clear( );
    virtual void Copy( );
    virtual void Cut( );
    void DiscardEdits( );
    bool EmulateKeyPress(const wxKeyEvent& event );
    const wxTextAttr&  GetDefaultStyle() const;
    virtual long GetInsertionPoint() const;
    virtual long GetLastPosition() const;
    int GetLineLength(long lineNo) const;
    wxString GetLineText(long lineNo) const;
    int GetNumberOfLines() const;
    virtual wxString GetRange(long from, long to) const;

    // %override [long from, long to] wxTextCtrl::GetSelection( );
    // C++ Func: virtual void GetSelection(long* from, long* to) const;
    virtual void GetSelection() const;

    virtual wxString GetStringSelection( );
    bool GetStyle(long position, wxTextAttr& style );
    wxString GetValue() const;

    // %override [wxTextCtrlHitTestResult, int col, int row] wxTextCtrl::HitTest(const wxPoint& pt );
    // C++ Func: wxTextCtrlHitTestResult HitTest(const wxPoint& pt, wxTextCoord *col, wxTextCoord *row) const;
    wxTextCtrlHitTestResult HitTest(const wxPoint& pt) const;

    // %override [wxTextCtrlHitTestResult, int pos] wxTextCtrl::HitTestPos(const wxPoint& pt );
    // C++ Func: wxTextCtrlHitTestResult HitTest(const wxPoint& pt, long *pos) const;
    %rename HitTestPos wxTextCtrlHitTestResult HitTest(const wxPoint& pt) const;

    bool IsEditable() const;
    bool IsModified() const;
    bool IsMultiLine() const;
    bool IsSingleLine() const;
    bool LoadFile(const wxString& filename );
    void MarkDirty( );
    //void OnDropFiles(wxDropFilesEvent& event );
    virtual void Paste( );

    // %override [bool, int x, int y] wxTextCtrl::PositionToXY(pos );
    // C++ Func: bool PositionToXY(long pos, long *x, long *y) const;
    bool PositionToXY(long pos) const;

    virtual void Redo( );
    virtual void Remove(long from, long to );
    virtual void Replace(long from, long to, const wxString& value );
    bool SaveFile(const wxString& filename );
    bool SetDefaultStyle(const wxTextAttr& style );
    virtual void SetEditable(bool editable );
    virtual void SetInsertionPoint(long pos );
    virtual void SetInsertionPointEnd( );
    virtual void SetMaxLength(unsigned long value );
    virtual void SetSelection(long from, long to );
    bool SetStyle(long start, long end, const wxTextAttr& style );
    virtual void SetValue(const wxString& value );
    void ShowPosition(long pos );
    virtual void Undo( );
    void WriteText(const wxString& text );
    long XYToPosition(long x, long y );
};

enum wxTextAttrAlignment
{
    wxTEXT_ALIGNMENT_DEFAULT,
    wxTEXT_ALIGNMENT_LEFT,
    wxTEXT_ALIGNMENT_CENTRE,
    wxTEXT_ALIGNMENT_CENTER,
    wxTEXT_ALIGNMENT_RIGHT,
    wxTEXT_ALIGNMENT_JUSTIFIED
};

#define wxTEXT_ATTR_TEXT_COLOUR
#define wxTEXT_ATTR_BACKGROUND_COLOUR
#define wxTEXT_ATTR_FONT_FACE
#define wxTEXT_ATTR_FONT_SIZE
#define wxTEXT_ATTR_FONT_WEIGHT
#define wxTEXT_ATTR_FONT_ITALIC
#define wxTEXT_ATTR_FONT_UNDERLINE
#define wxTEXT_ATTR_FONT
#define wxTEXT_ATTR_ALIGNMENT
#define wxTEXT_ATTR_LEFT_INDENT
#define wxTEXT_ATTR_RIGHT_INDENT
#define wxTEXT_ATTR_TABS

class %delete wxTextAttr
{
    //wxTextAttr( );
    wxTextAttr(const wxColour& colText = wxNullColour, const wxColour& colBack = wxNullColour, const wxFont& font = wxNullFont, wxTextAttrAlignment alignment = wxTEXT_ALIGNMENT_DEFAULT );

    wxTextAttrAlignment GetAlignment() const;
    wxColour GetBackgroundColour() const;
    long GetFlags() const;
    wxFont GetFont() const;
    long GetLeftIndent() const;
    long GetLeftSubIndent() const;
    long GetRightIndent() const;
    const wxArrayInt& GetTabs() const;
    wxColour GetTextColour() const;
    bool HasAlignment() const;
    bool HasBackgroundColour() const;
    bool HasFlag(long flag) const;
    bool HasFont() const;
    bool HasLeftIndent() const;
    bool HasRightIndent() const;
    bool HasTabs() const;
    bool HasTextColour() const;
    bool IsDefault() const;
    void SetAlignment(wxTextAttrAlignment alignment );
    void SetBackgroundColour(const wxColour& colBack );
    void SetFlags(long flags );
    void SetFont(const wxFont& font, long flags = wxTEXT_ATTR_FONT );
    void SetLeftIndent(int indent, int subIndent = 0 );
    void SetRightIndent(int indent );
    void SetTabs(const wxArrayInt& tabs );
    void SetTextColour(const wxColour& colText );
};

// ---------------------------------------------------------------------------
// wxTextUrlEvent

class %delete wxTextUrlEvent : public wxCommandEvent
{
    %wxchkver_2_8_0 %wxEventType wxEVT_COMMAND_TEXT_URL        // EVT_TEXT_URL(id, fn );

    wxTextUrlEvent(int winid, const wxMouseEvent& evtMouse, long start, long end );

    const wxMouseEvent& GetMouseEvent() const;
    long GetURLStart() const;
    long GetURLEnd() const;
};

#endif //wxLUA_USE_wxTextCtrl && wxUSE_TEXTCTRL

// ---------------------------------------------------------------------------
// wxTreeCtrl

#if wxLUA_USE_wxTreeCtrl && wxUSE_TREECTRL

#include "wx/treectrl.h"

#define wxTR_NO_BUTTONS
#define wxTR_HAS_BUTTONS
#define wxTR_TWIST_BUTTONS
#define wxTR_NO_LINES
#define wxTR_SINGLE
#define wxTR_MULTIPLE
#define wxTR_EXTENDED
#define wxTR_EDIT_LABELS
#define wxTR_LINES_AT_ROOT
#define wxTR_HIDE_ROOT
#define wxTR_ROW_LINES
#define wxTR_HAS_VARIABLE_ROW_HEIGHT
#define wxTR_FULL_ROW_HIGHLIGHT
#define wxTR_DEFAULT_STYLE

//#define wxTR_MAC_BUTTONS   both deprecated
//#define wxTR_AQUA_BUTTONS

enum wxTreeItemIcon
{
    wxTreeItemIcon_Normal,
    wxTreeItemIcon_Selected,
    wxTreeItemIcon_Expanded,
    wxTreeItemIcon_SelectedExpanded,
    wxTreeItemIcon_Max
};

#define wxTREE_HITTEST_ABOVE
#define wxTREE_HITTEST_BELOW
#define wxTREE_HITTEST_NOWHERE
#define wxTREE_HITTEST_ONITEMBUTTON
#define wxTREE_HITTEST_ONITEMICON
#define wxTREE_HITTEST_ONITEMINDENT
#define wxTREE_HITTEST_ONITEMLABEL
#define wxTREE_HITTEST_ONITEMRIGHT
#define wxTREE_HITTEST_ONITEMSTATEICON
#define wxTREE_HITTEST_TOLEFT
#define wxTREE_HITTEST_TORIGHT
#define wxTREE_HITTEST_ONITEMUPPERPART
#define wxTREE_HITTEST_ONITEMLOWERPART
#define wxTREE_HITTEST_ONITEM

%wxchkver_2_9 #define wxTREE_ITEMSTATE_NONE // not state (no display state image)
%wxchkver_2_9 #define wxTREE_ITEMSTATE_NEXT // cycle to the next state
%wxchkver_2_9 #define wxTREE_ITEMSTATE_PREV // cycle to the previous state

class wxTreeCtrl : public wxControl
{
    wxTreeCtrl( );
    wxTreeCtrl(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxTR_DEFAULT_STYLE, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxTreeCtrl" );
    bool Create(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxTR_HAS_BUTTONS, const wxValidator& validator = wxDefaultValidator, const wxString& name = "wxTreeCtrl" );

    wxTreeItemId AddRoot(const wxString& text, int image = -1, int selImage = -1, %ungc wxLuaTreeItemData* data = NULL );
    wxTreeItemId AppendItem(const wxTreeItemId& parent, const wxString& text, int image = -1, int selImage = -1, %ungc wxLuaTreeItemData* data = NULL );
    //void AssignButtonsImageList(wxImageList* imageList );
    void AssignImageList(%ungc wxImageList* imageList );
    void AssignStateImageList(%ungc wxImageList* imageList );
    void Collapse(const wxTreeItemId& item );
    void CollapseAll( );
    void CollapseAllChildren(const wxTreeItemId& item );
    void CollapseAndReset(const wxTreeItemId& item );
    void Delete(const wxTreeItemId& item );
    void DeleteAllItems( );
    void DeleteChildren(const wxTreeItemId& item );
    void EditLabel(const wxTreeItemId& item );
    %win void EndEditLabel(const wxTreeItemId& item, bool discardChanges = false );
    void EnsureVisible(const wxTreeItemId& item );
    void Expand(const wxTreeItemId& item );
    void ExpandAll( );
    void ExpandAllChildren(const wxTreeItemId& item );
    bool GetBoundingRect(const wxTreeItemId& item, wxRect& rect, bool textOnly = false) const;
    //wxImageList* GetButtonsImageList() const;
    size_t GetChildrenCount(const wxTreeItemId& item, bool recursively = true) const;
    int GetCount() const;
    //wxTextCtrl* GetEditControl() const; // MSW only

    // %override [wxTreeItemId, wxTreeItemIdValue cookie] wxTreeCtrl::GetFirstChild(const wxTreeItemId& item );
    // C++ Func: wxTreeItemId GetFirstChild(const wxTreeItemId& item, wxTreeItemIdValue& cookie) const;
    wxTreeItemId GetFirstChild(const wxTreeItemId& item) const;

    wxTreeItemId GetFirstVisibleItem() const;
    wxImageList* GetImageList() const;
    int GetIndent() const;
    wxColour GetItemBackgroundColour(const wxTreeItemId& item) const;
    wxLuaTreeItemData* GetItemData(const wxTreeItemId& item) const;
    wxFont GetItemFont(const wxTreeItemId& item) const;
    int GetItemImage(const wxTreeItemId& item, wxTreeItemIcon which = wxTreeItemIcon_Normal) const;
    wxString GetItemText(const wxTreeItemId& item) const;
    wxColour GetItemTextColour(const wxTreeItemId& item) const;
    wxTreeItemId GetLastChild(const wxTreeItemId& item) const;

    // %override [wxTreeItemId, wxTreeItemIdValue cookie] wxTreeCtrl::GetNextChild(const wxTreeItemId& item, long cookie );
    // C++ Func: wxTreeItemId GetNextChild(const wxTreeItemId& item, wxTreeItemIdValue& cookie) const;
    wxTreeItemId GetNextChild(const wxTreeItemId& item, wxTreeItemIdValue& cookie) const;

    wxTreeItemId GetNextSibling(const wxTreeItemId& item) const;
    wxTreeItemId GetNextVisible(const wxTreeItemId& item) const;
    %wxchkver_2_4 wxTreeItemId GetItemParent(const wxTreeItemId& item) const;
    wxTreeItemId GetPrevSibling(const wxTreeItemId& item) const;
    wxTreeItemId GetPrevVisible(const wxTreeItemId& item) const;
    wxTreeItemId GetRootItem() const;
    bool GetQuickBestSize() const;
    //!%wxchkver_2_6|%wxcompat_2_4 int GetItemSelectedImage(const wxTreeItemId& item) const; // obsolete function
    wxTreeItemId GetSelection() const;

    // %override [size_t, Lua table of wxTreeItemIds] wxTreeCtrl::GetSelections( );
    // C++ Func: size_t GetSelections(wxArrayTreeItemIds& selection) const;
    size_t GetSelections() const;

    wxImageList* GetStateImageList() const;

    // %override [wxTreeItemId, int flags] wxTreeCtrl::HitTest(const wxPoint& point );
    // C++ Func: wxTreeItemId HitTest(const wxPoint& point, int& flags );
    wxTreeItemId HitTest(const wxPoint& point );

    wxTreeItemId InsertItem(const wxTreeItemId& parent, const wxTreeItemId& previous, const wxString& text, int image = -1, int selImage = -1, %ungc wxLuaTreeItemData* data = NULL );
    wxTreeItemId InsertItem(const wxTreeItemId& parent, size_t before, const wxString& text, int image = -1, int selImage = -1, %ungc wxLuaTreeItemData* data = NULL );
    bool IsBold(const wxTreeItemId& item) const;
    bool IsEmpty() const;
    bool IsExpanded(const wxTreeItemId& item) const;
    bool IsSelected(const wxTreeItemId& item) const;
    bool IsVisible(const wxTreeItemId& item) const;
    bool ItemHasChildren(const wxTreeItemId& item) const;
    //int OnCompareItems(const wxTreeItemId& item1, const wxTreeItemId& item2 );
    wxTreeItemId PrependItem(const wxTreeItemId& parent, const wxString& text, int image = -1, int selImage = -1, %ungc wxLuaTreeItemData* data = NULL );
    void ScrollTo(const wxTreeItemId& item );
    void SelectItem(const wxTreeItemId& item, bool select = true );
    //void SetButtonsImageList(wxImageList* imageList );
    void SetIndent(int indent );
    void SetImageList(wxImageList* imageList );
    void SetItemBackgroundColour(const wxTreeItemId& item, const wxColour& col );
    void SetItemBold(const wxTreeItemId& item, bool bold = true );
    void SetItemData(const wxTreeItemId& item, %ungc wxLuaTreeItemData* data );
    void SetItemDropHighlight(const wxTreeItemId& item, boolhighlight = true );
    void SetItemFont(const wxTreeItemId& item, const wxFont& font );
    void SetItemHasChildren(const wxTreeItemId& item, bool hasChildren = true );
    void SetItemImage(const wxTreeItemId& item, int image, wxTreeItemIcon which = wxTreeItemIcon_Normal );
    %wxchkver_2_9 void SetItemState(const wxTreeItemId& item, int state);
    void SetItemText(const wxTreeItemId& item, const wxString& text );
    void SetItemTextColour(const wxTreeItemId& item, const wxColour& col );
    void SetQuickBestSize(bool quickBestSize );
    void SetStateImageList(wxImageList* imageList );
    // void SetWindowStyle(long styles) - see wxWindow
    void SortChildren(const wxTreeItemId& item );
    void Toggle(const wxTreeItemId& item );
    void ToggleItemSelection(const wxTreeItemId& item );
    void Unselect( );
    void UnselectAll( );
    void UnselectItem(const wxTreeItemId& item );
};

// ---------------------------------------------------------------------------
// wxTreeItemAttr - wxTreeCtrl
// This is only used internally in wxWidgets with no public accessors to them.

/*
class %delete wxTreeItemAttr
{
    wxTreeItemAttr(const wxColour& colText = wxNullColour, const wxColour& colBack = wxNullColour, const wxFont& font = wxNullFont );

    wxColour GetBackgroundColour() const;
    wxFont   GetFont() const;
    wxColour GetTextColour() const;
    bool     HasBackgroundColour( );
    bool     HasFont( );
    bool     HasTextColour( );
    void     SetBackgroundColour(const wxColour& colBack );
    void     SetFont(const wxFont& font );
    void     SetTextColour(const wxColour& colText );
};
*/

// ---------------------------------------------------------------------------
// wxTreeItemIdValue - wxTreeCtrl

// FAKE typedef, actually typedef void* wxTreeItemIdValue
// Since we override the functions that use it we handle it as a pointer.
typedef double wxTreeItemIdValue

// ---------------------------------------------------------------------------
// wxTreeItemId - wxTreeCtrl

class %delete wxTreeItemId
{
    wxTreeItemId( );
    wxTreeItemId(const wxTreeItemId& id );

    bool IsOk( );
    wxTreeItemIdValue GetValue() const; // get a pointer to the internal data to use as a reference in a Lua table

    wxTreeItemId& operator=(const wxTreeItemId& otherId );
    bool operator==(const wxTreeItemId& otherId) const;
};

// ---------------------------------------------------------------------------
// wxArrayTreeItemIds - wxTreeCtrl
// This is only used by the function wxTreeCtrl::GetSelections(wxArrayTreeItemIds& arr );
//    which we have overridden to return a table. This is not necessary.
//
// Note: This is actually an array of the internal wxTreeItemIdValue data
//       which is a void* pointer. This is why we use long.
//       See wxLua's wxTreeItemId::GetValue() function

/*
class %delete wxArrayTreeItemIds
{
    wxArrayTreeItemIds( );
    wxArrayTreeItemIds(const wxArrayTreeItemIds& array );

    void Add(const wxTreeItemId& id );
    void Alloc(size_t nCount );
    void Clear( );
    void Empty( );
    int GetCount() const;
    int Index(wxTreeItemIdValue treeItemIdValue, bool bFromEnd = false );
    //void Insert(wxTreeItemId& str, int nIndex, size_t copies = 1 );
    bool IsEmpty( );
    wxTreeItemId Item(size_t nIndex) const;
    wxTreeItemId Last( );
    void Remove(wxTreeItemIdValue treeItemIdValue );
    void RemoveAt(size_t nIndex, size_t count = 1 );
    void Shrink( );
};
*/

// ---------------------------------------------------------------------------
// wxTreeItemData - wxTreeCtrl, see also wxLuaTreeItemData
//
// No %delete since the wxTreeCtrl will delete it when set as the data for an item.
// Only create a wxTreeItemData if you're going to attach it to a wxTreeCtrl item to avoid memory leaks.

class %delete wxTreeItemData : public wxClientData
{
    wxTreeItemData( );

    wxTreeItemId GetId( );
    void         SetId(const wxTreeItemId& id );
};

// ---------------------------------------------------------------------------
// wxLuaTreeItemData -
//
// No %delete since the wxTreeCtrl will delete it when set as the data for an item.
// Only create a wxLuaTreeItemData if you're going to attach it to a wxTreeCtrl item to avoid memory leaks.

#include "wxbind/include/wxcore_wxlcore.h"

class %delete wxLuaTreeItemData : public wxTreeItemData
{
    wxLuaTreeItemData( );

    // %override wxLuaTreeItemData(any );
    // C++ Func: wxLuaTreeItemData(wxLuaObject* obj );
    wxLuaTreeItemData(any );

    // %override any wxLuaTreeItemData::GetData() const;
    // C++ Func: wxLuaObject* GetData() const;
    any  GetData() const;
    // %override void wxLuaTreeItemData::SetData(any );
    // C++ Func: void SetData(wxLuaObject* obj );
    void SetData(any);
};


// ---------------------------------------------------------------------------
// wxTreeEvent - wxTreeCtrl

class %delete wxTreeEvent : public wxNotifyEvent
{
    %wxEventType wxEVT_COMMAND_TREE_BEGIN_DRAG        // EVT_TREE_BEGIN_DRAG(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_BEGIN_LABEL_EDIT  // EVT_TREE_BEGIN_LABEL_EDIT(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_BEGIN_RDRAG       // EVT_TREE_BEGIN_RDRAG(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_DELETE_ITEM       // EVT_TREE_DELETE_ITEM(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_END_DRAG          // EVT_TREE_END_DRAG(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_END_LABEL_EDIT    // EVT_TREE_END_LABEL_EDIT(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_GET_INFO          // EVT_TREE_GET_INFO(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_ACTIVATED    // EVT_TREE_ITEM_ACTIVATED(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_COLLAPSED    // EVT_TREE_ITEM_COLLAPSED(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_COLLAPSING   // EVT_TREE_ITEM_COLLAPSING(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_EXPANDED     // EVT_TREE_ITEM_EXPANDED(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_EXPANDING    // EVT_TREE_ITEM_EXPANDING(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_MIDDLE_CLICK // EVT_TREE_ITEM_MIDDLE_CLICK(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_RIGHT_CLICK  // EVT_TREE_ITEM_RIGHT_CLICK(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_KEY_DOWN          // EVT_TREE_KEY_DOWN(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_SEL_CHANGED       // EVT_TREE_SEL_CHANGED(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_SEL_CHANGING      // EVT_TREE_SEL_CHANGING(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_SET_INFO          // EVT_TREE_SET_INFO(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_MENU         // EVT_TREE_ITEM_MENU(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_STATE_IMAGE_CLICK // EVT_TREE_STATE_IMAGE_CLICK(id, fn );
    %wxEventType wxEVT_COMMAND_TREE_ITEM_GETTOOLTIP   // EVT_TREE_ITEM_GETTOOLTIP(id, fn );

    wxTreeEvent(wxEventType commandType = wxEVT_NULL, int id = 0 );

    int GetKeyCode() const;
    wxTreeItemId GetItem() const;
    wxKeyEvent GetKeyEvent() const;
    const wxString& GetLabel() const;
    wxTreeItemId GetOldItem() const;
    wxPoint GetPoint() const;
    bool IsEditCancelled() const;
    void SetToolTip(const wxString& tooltip );
};

#endif //wxLUA_USE_wxTreeCtrl && wxUSE_TREECTRL

// ---------------------------------------------------------------------------
// wxGenericDirCtrl

#if wxLUA_USE_wxGenericDirCtrl && wxUSE_DIRDLG

#include "wx/dirctrl.h"

enum
{
    wxDIRCTRL_DIR_ONLY,
    wxDIRCTRL_SELECT_FIRST,
    wxDIRCTRL_SHOW_FILTERS,
    wxDIRCTRL_3D_INTERNAL,
    wxDIRCTRL_EDIT_LABELS
};

%wxchkver_2_9_0 #define_string wxDirDialogDefaultFolderStr
!%wxchkver_2_9_0 #define_wxstring wxDirDialogDefaultFolderStr

class wxGenericDirCtrl : public wxControl
{
    wxGenericDirCtrl( );
    wxGenericDirCtrl(wxWindow *parent, const wxWindowID id = wxID_ANY, const wxString &dir = wxDirDialogDefaultFolderStr, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDIRCTRL_3D_INTERNAL|wxSUNKEN_BORDER, const wxString& filter = "", int defaultFilter = 0, const wxString& name = "wxGenericDirCtrl" );
    bool Create(wxWindow *parent, const wxWindowID id = wxID_ANY, const wxString &dir = wxDirDialogDefaultFolderStr, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxDIRCTRL_3D_INTERNAL|wxSUNKEN_BORDER, const wxString& filter = "", int defaultFilter = 0, const wxString& name = "wxGenericDirCtrl" );

    void CollapseTree( );
    bool ExpandPath(const wxString& path );
    wxString GetDefaultPath() const;
    wxString GetPath() const;
    wxString GetFilePath() const;
    wxString GetFilter() const;
    int GetFilterIndex() const;
    //wxDirFilterListCtrl* GetFilterListCtrl() const;
    wxTreeItemId GetRootId( );
    wxTreeCtrl* GetTreeCtrl() const;
    void ReCreateTree( );
    void SetDefaultPath(const wxString& path );
    void SetFilter(const wxString& filter );
    void SetFilterIndex(int n );
    void SetPath(const wxString& path );
    void ShowHidden( bool show );
    bool GetShowHidden( );

    //wxTreeItemId FindChild(wxTreeItemId parentId, const wxString& path, bool& done );
};

#endif //wxLUA_USE_wxGenericDirCtrl && wxUSE_DIRDLG
