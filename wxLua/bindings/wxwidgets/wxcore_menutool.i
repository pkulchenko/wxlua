// ===========================================================================
// Purpose:     wxMenu and wxToolbar classes
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

// ---------------------------------------------------------------------------
// wxMenu

#if wxLUA_USE_wxMenu && wxUSE_MENUS

#include "wx/menu.h"

enum wxItemKind
{
   wxITEM_SEPARATOR
   wxITEM_NORMAL
   wxITEM_CHECK
   wxITEM_RADIO
   wxITEM_MAX
};

#define wxMB_DOCKABLE
#define wxMENU_TEAROFF

class %delete wxMenu : public wxEvtHandler
{
    wxMenu(const wxString& title = "", long style = 0 );

    // %override wxMenu* wxMenu({{wx.wxID_NEW, "&New\tCtrl-N", "New doc", [wx.wxITEM_NORMAL]}, {}, {item 2}}, const wxString& title = "", long style = "") - empty tables are separators
    // wxLua provides this function
    %override_name wxLua_wxCreateMenu_constructor wxMenu(LuaTable, const wxString& title = "", long style = 0 );

    wxMenuItem* Append(int id, const wxString& item, const wxString& helpString = "", wxItemKind kind = wxITEM_NORMAL );
    wxMenuItem* Append(int id, const wxString& item, %ungc wxMenu *subMenu, const wxString& helpString = "" );
    wxMenuItem* Append(%ungc wxMenuItem* menuItem );
    wxMenuItem* AppendCheckItem(int id, const wxString& item, const wxString& helpString = "" );
    wxMenuItem* AppendRadioItem(int id, const wxString& item, const wxString& helpString = "" );
    wxMenuItem* AppendSeparator( );
    void Break( );
    void Check(int id, bool check );
    void Delete(int id );
    void Delete(wxMenuItem *item );
    void Destroy(int id );
    void Destroy(wxMenuItem *item );
    void Enable(int id, bool enable );
    int FindItem(const wxString& itemString) const;

    // %override [wxMenuItem* menuItem, wxMenu* ownerMenu] wxMenu::FindItem(int id );
    // C++ Func: wxMenuItem* FindItem(int id, wxMenu **menu = NULL) const;
    %override_name wxLua_wxMenu_FindItemById wxMenuItem* FindItem(int id) const;

    wxMenuItem* FindItemByPosition(size_t position) const;
    wxString GetHelpString(int id) const;
    wxString GetLabel(int id) const;
    size_t GetMenuItemCount() const;
    wxMenuItemList& GetMenuItems() const;
    wxString GetTitle() const;
    wxMenuItem* Insert(size_t pos, int id, const wxString& item, const wxString& helpString = "", wxItemKind kind = wxITEM_NORMAL );
    wxMenuItem* Insert(size_t pos, %ungc wxMenuItem *item );
    wxMenuItem* InsertCheckItem(size_t pos, int id, const wxString& item, const wxString& helpString = "" );
    wxMenuItem* InsertRadioItem(size_t pos, int id, const wxString&  item, const wxString& helpString = "" );
    wxMenuItem* InsertSeparator(size_t pos );
    bool IsChecked(int id) const;
    bool IsEnabled(int id) const;
    wxMenuItem* Prepend(int id, const wxString& item, const wxString& helpString = "", wxItemKind kind = wxITEM_NORMAL );
    wxMenuItem* Prepend(%ungc wxMenuItem *item );
    wxMenuItem* PrependCheckItem(int id, const wxString&  item, const wxString& helpString = "" );
    wxMenuItem* PrependRadioItem(int id, const wxString&  item, const wxString& helpString = "" );
    wxMenuItem* PrependSeparator( );
    %gc wxMenuItem* Remove(wxMenuItem *item );
    %gc wxMenuItem* Remove(int id );
    void SetHelpString(int id, const wxString& helpString );
    void SetLabel(int id, const wxString& label );
    void SetTitle(const wxString& title );
    void UpdateUI(wxEvtHandler* source = NULL) const;
};

// ---------------------------------------------------------------------------
// wxMenuBar

class wxMenuBar : public wxWindow
{
    wxMenuBar(long style = 0 );
    // void wxMenuBar(int n, wxMenu* menus[], const wxString titles[] );

    bool Append(%ungc wxMenu *menu, const wxString& title );
    void Check(int id, bool check );
    void Enable(int id, bool enable );
    void EnableTop(int pos, bool enable );
    int FindMenu(const wxString& title) const;
    int FindMenuItem(const wxString& menuString, const wxString& itemString) const;
    wxMenuItem* FindItem(int id, wxMenu **menu = NULL) const;
    wxString GetHelpString(int id) const;
    wxString GetLabel(int id) const;
    wxString GetLabelTop(int pos) const;
    wxMenu* GetMenu(int menuIndex) const;
    int GetMenuCount() const;
    bool Insert(size_t pos, %ungc wxMenu *menu, const wxString& title );
    bool IsChecked(int id) const;
    bool IsEnabled(int id) const;
    void Refresh( );
    %gc wxMenu* Remove(size_t pos );
    %gc wxMenu* Replace(size_t pos, %ungc wxMenu *menu, const wxString& title );
    void SetHelpString(int id, const wxString& helpString );
    void SetLabel(int id, const wxString& label );
    void SetLabelTop(int pos, const wxString& label );

    %wxchkver_2_8 virtual void UpdateMenus( );
};

// ---------------------------------------------------------------------------
// wxMenuItem
//
// Note: this is almost always owned by a wxMenu, however you can get an
// unattached one from wxMenu::Remove() so that's why we gc collect it.


#include "wx/menuitem.h"

class %delete wxMenuItem : public wxObject
{
    %ungc_this wxMenuItem(wxMenu *parentMenu = NULL, int id = wxID_SEPARATOR, const wxString& text = "", const wxString& help = "", wxItemKind kind = wxITEM_NORMAL, wxMenu *subMenu = NULL );

    void Check(bool check );
    void Enable(bool enable );
    //%win wxColour GetBackgroundColour() const;
    //%win wxBitmap GetBitmap(bool checked = true) const;
    //%win wxFont GetFont() const;
    wxString GetHelp() const;
    int GetId() const;
    wxItemKind GetKind() const;
    wxString GetLabel() const;
    static wxString GetLabelFromText(const wxString& text );
    //%win int GetMarginWidth() const;
    wxMenu* GetMenu() const;
    // wxString GetName() const; - deprecated
    wxString GetText() const;
    wxMenu* GetSubMenu() const;
    //%win wxColour& GetTextColour() const;
    bool IsCheckable() const;
    bool IsChecked() const;
    bool IsEnabled() const;
    bool IsSeparator() const;
    bool IsSubMenu() const;
    //%win void SetBackgroundColour(const wxColour& colour) const;
    void SetBitmap(const wxBitmap& bmp );
    //%win void SetBitmaps(const wxBitmap& checked, const wxBitmap& unchecked = wxNullBitmap) const;
    //%win void SetFont(const wxFont& font) const;
    void SetHelp(const wxString& helpString) const;
    //%win void SetMarginWidth(int width) const;
    //void SetMenu(wxMenu* menu );
    void SetSubMenu(wxMenu* menu );
    void SetText(const wxString& text );
    // void SetName(const wxString& text) const; - deprecated
    %win void SetTextColour(const wxColour& colour) const;

    #if %wxchkver_2_8
        void SetItemLabel(const wxString& str );
        wxString GetItemLabel() const;
        wxString GetItemLabelText() const;

        static wxString GetLabelText(const wxString& label );
    #endif
};

// ---------------------------------------------------------------------------
// wxMenuItemList

class wxMenuItemList : public wxList
{
    // no constructor, you only get this back from wxMenu::GetMenuItems

    // Use the wxList methods, see also wxNode
};

// ---------------------------------------------------------------------------
// wxMenuEvent

#include "wx/event.h"

class %delete wxMenuEvent : public wxEvent
{
    %wxEventType wxEVT_MENU_HIGHLIGHT  // EVT_MENU_HIGHLIGHT(winid, func) EVT_MENU_HIGHLIGHT_ALL(func );
    %wxEventType wxEVT_MENU_OPEN       // EVT_MENU_OPEN(func );
    %wxEventType wxEVT_MENU_CLOSE      // EVT_MENU_CLOSE(func );

    wxMenuEvent(wxEventType type = wxEVT_NULL, int id = 0, wxMenu* menu = NULL );
    wxMenu* GetMenu() const;
    int GetMenuId() const;
    bool IsPopup() const;
};

#endif //wxLUA_USE_wxMenu && wxUSE_MENUS

// ---------------------------------------------------------------------------
// wxToolBarBase

#if wxLUA_USE_wxToolbar

#include "wx/tbarbase.h"

#define wxTB_FLAT
#define wxTB_DOCKABLE
#define wxTB_HORIZONTAL
#define wxTB_VERTICAL
#define wxTB_3DBUTTONS
#define wxTB_TEXT
#define wxTB_NOICONS
#define wxTB_NODIVIDER
#define wxTB_NOALIGN
#define wxTB_HORZ_LAYOUT
#define wxTB_HORZ_TEXT

class wxToolBarBase : public wxControl
{
    // no constructors base class

    wxToolBarToolBase* AddControl(wxControl *control );
    wxToolBarToolBase* AddSeparator( );
    wxToolBarToolBase* AddTool(int toolId, const wxString& label, const wxBitmap& bitmap1, const wxBitmap& bitmap2 = wxNullBitmap, wxItemKind kind = wxITEM_NORMAL, const wxString& shortHelpString = "", const wxString& longHelpString = "", wxObject* clientData = NULL );
    wxToolBarToolBase* AddTool(int toolId, const wxString& label, const wxBitmap& bitmap1, const wxString& shortHelpString = "", wxItemKind kind = wxITEM_NORMAL );
    //wxToolBarToolBase* AddTool(wxToolBarToolBase* tool );
    wxToolBarToolBase *AddCheckTool(int toolid, const wxString& label, const wxBitmap& bitmap, const wxBitmap& bmpDisabled = wxNullBitmap, const wxString& shortHelp = "", const wxString& longHelp = "", wxObject *data = NULL );
    wxToolBarToolBase *AddRadioTool(int toolid, const wxString& label, const wxBitmap& bitmap, const wxBitmap& bmpDisabled = wxNullBitmap, const wxString& shortHelp = "", const wxString& longHelp = "", wxObject *data = NULL );
    void ClearTools( );
    bool DeleteTool(int toolId );
    bool DeleteToolByPos(size_t pos );
    void EnableTool(int toolId, const bool enable );
    wxToolBarToolBase* FindById(int id );
    wxControl* FindControl(int id );
    wxToolBarToolBase *FindToolForPosition(wxCoord x, wxCoord y) const;
    int     GetMaxRows( );
    int     GetMaxCols( );
    wxSize  GetToolSize( );
    wxSize  GetToolBitmapSize( );
    wxObject* GetToolClientData(int toolId) const;
    bool    GetToolEnabled(int toolId) const;
    wxString GetToolLongHelp(int toolId) const;
    wxSize  GetToolMargins(); // GetMargins is deprecated
    int     GetToolPacking( );
    int     GetToolPos(int toolId) const;
    int     GetToolSeparation() const;
    wxString GetToolShortHelp(int toolId) const;
    bool    GetToolState(int id );
    wxToolBarToolBase* InsertControl(size_t pos, wxControl *control );
    wxToolBarToolBase* InsertSeparator(size_t pos );
    wxToolBarToolBase* InsertTool(size_t pos, int id, const wxBitmap& bitmap, const wxBitmap& pushedBitmap = wxNullBitmap, bool isToggle = false, wxObject *clientData = NULL, const wxString& shortHelpString = "", const wxString& longHelpString = "" );
    wxToolBarToolBase* InsertTool(size_t pos, int toolid, const wxString& label, const wxBitmap& bitmap, const wxBitmap& bmpDisabled = wxNullBitmap, wxItemKind kind = wxITEM_NORMAL, const wxString& shortHelp = "", const wxString& longHelp = "", wxObject *clientData = NULL );
    //wxToolBarToolBase * InsertTool(size_t pos, wxToolBarToolBase* tool );
    wxToolBarToolBase* RemoveTool(int id );
    bool    Realize( );
    void    SetMargins(int x, int y );
    void    SetMargins(const wxSize& size );
    void    SetToolBitmapSize(const wxSize& size );
    void    SetToolClientData(int id, wxObject* clientData );
    void    SetToolLongHelp(int toolId, const wxString& helpString );
    void    SetToolPacking(int packing );
    void    SetToolShortHelp(int id, const wxString& helpString );
    void    SetToolSeparation(int separation );
    void    SetToggle(int id, bool toggle );
    void    SetRows(int nRows );
    void    SetMaxRowsCols(int rows, int cols );
    void    ToggleTool(int toolId, const bool toggle );
};

// ---------------------------------------------------------------------------
// wxToolBar

#include "wx/toolbar.h"

class wxToolBar : public wxToolBarBase
{
    wxToolBar( );
    wxToolBar(wxWindow *parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxNO_BORDER | wxTB_HORIZONTAL, const wxString &name = "wxToolBar" );
    bool Create(wxWindow *parent,wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxNO_BORDER | wxTB_HORIZONTAL, const wxString &name = "wxToolBar" );
};

// ---------------------------------------------------------------------------
// wxToolBarSimple

#if !%wxchkver_2_6

#include "wx/tbarsmpl.h"

class wxToolBarSimple : public wxToolBarBase
{
    wxToolBarSimple( );
    wxToolBarSimple(wxWindow *parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxNO_BORDER | wxTB_HORIZONTAL, const wxString &name = wxToolBarNameStr );
    bool Create(wxWindow *parent,wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxNO_BORDER | wxTB_HORIZONTAL, const wxString &name = wxToolBarNameStr );
};

#endif // !%wxchkver_2_6

// ---------------------------------------------------------------------------
// wxToolBarToolBase

// these are unused
//#define wxTOOL_BOTTOM
//#define wxTOOL_LEFT
//#define wxTOOL_RIGHT
//#define wxTOOL_TOP

enum wxToolBarToolStyle
{
    wxTOOL_STYLE_BUTTON
    wxTOOL_STYLE_SEPARATOR
    wxTOOL_STYLE_CONTROL
};

class wxToolBarToolBase : public wxObject
{
    // no constructors

    int     GetId( );
    wxControl *GetControl( );
    wxToolBarBase *GetToolBar( );
    int     IsButton( );
    int     IsControl( );
    int     IsSeparator( );
    int     GetStyle( );
    wxItemKind GetKind() const;
    bool    IsEnabled( );
    bool    IsToggled( );
    bool    CanBeToggled( );
    wxBitmap GetNormalBitmap( );
    wxBitmap GetDisabledBitmap( );
    wxBitmap GetBitmap( );
    wxString GetLabel( );
    wxString GetShortHelp( );
    wxString GetLongHelp( );
    bool    Enable(bool enable );
    bool    Toggle(bool toggle );
    bool    SetToggle(bool toggle );
    bool    SetShortHelp(const wxString& help );
    bool    SetLongHelp(const wxString& help );
    void    SetNormalBitmap(const wxBitmap& bmp );
    void    SetDisabledBitmap(const wxBitmap& bmp );
    void    SetLabel(const wxString& label );
    void    Detach( );
    void    Attach(wxToolBarBase *tbar );
    wxObject *GetClientData( );
    void    SetClientData(wxObject* clientData );
};

// ---------------------------------------------------------------------------
// wxToolBarTool - This class doesn't exist!

//class wxToolBarTool : public wxToolBarToolBase
//{
//};

#endif //wxLUA_USE_wxToolbar


// ---------------------------------------------------------------------------
// wxAcceleratorTable

#if wxLUA_USE_wxAcceleratorTable && wxUSE_ACCEL

#include "wx/accel.h"

class %delete wxAcceleratorTable : public wxObject
{
    #define_object wxNullAcceleratorTable

    // %override wxAcceleratorTable(Lua table with this format );
    // { { wx.wxACCEL_NORMAL, string.byte('0'), ID_0 },
    //   { wx.wxACCEL_NORMAL, wx.VXK_NUMPAD0,   ID_0 } }
    // C++ Func: wxAcceleratorTable(int n, wxAcceleratorEntry* entries );
    wxAcceleratorTable(LuaTable accelTable );
    wxAcceleratorTable(const wxAcceleratorTable& accel );

    bool Ok() const;
    //%wxchkver_2_8 bool IsOk() const;

    // believe it or not, there aren't functions to add or remove wxAcceleratorEntries for MSW

    // operators are WXWIN_COMPATIBILITY_2_4
};

// ---------------------------------------------------------------------------
// wxAcceleratorEntry

%wxcompat_2_6 wxAcceleratorEntry* wxGetAccelFromString(const wxString& label); // deprecated in 2.8 use wxAcceleratorEntry::Create() or FromString( );

#include "wx/accel.h"

enum
{
    wxACCEL_NORMAL
    wxACCEL_ALT
    wxACCEL_CTRL
    wxACCEL_SHIFT
    %wxchkver_2_8 wxACCEL_CMD // Command key on OS X else wxACCEL_CTRL
};

class %delete wxAcceleratorEntry
{
    wxAcceleratorEntry(int flags = 0, int keyCode = 0, int cmd = 0, wxMenuItem *item = NULL );
    wxAcceleratorEntry(const wxAcceleratorEntry& entry );

    int GetCommand() const;
    int GetFlags() const;
    int GetKeyCode() const;
    void Set(int flags, int keyCode, int Cmd, wxMenuItem *item = NULL );

    #if %wxchkver_2_8
        static %gc wxAcceleratorEntry *Create(const wxString& str );
        bool IsOk() const;
        wxString ToString() const;
        bool FromString(const wxString& str );
        wxMenuItem *GetMenuItem() const;
    #endif // %wxchkver_2_8

    // these are probably not necessary
    //%operator wxAcceleratorEntry& operator=(const wxAcceleratorEntry& entry );
    //%operator bool operator==(const wxAcceleratorEntry& entry) const;
    //%operator bool operator!=(const wxAcceleratorEntry& entry) const;
};

#endif //wxLUA_USE_wxAcceleratorTable && wxUSE_ACCEL
