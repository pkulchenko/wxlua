// ===========================================================================
// Purpose:     wxGrid and related classes (Updated using grid.h NOT docs)
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

%if wxLUA_USE_wxGrid && wxUSE_GRID

%include "wx/grid.h"
%include "wx/generic/gridctrl.h"

%define WXGRID_DEFAULT_NUMBER_ROWS
%define WXGRID_DEFAULT_NUMBER_COLS
%define WXGRID_DEFAULT_ROW_HEIGHT
%define WXGRID_DEFAULT_COL_WIDTH
%define WXGRID_DEFAULT_COL_LABEL_HEIGHT
%define WXGRID_DEFAULT_ROW_LABEL_WIDTH
%define WXGRID_LABEL_EDGE_ZONE
%define WXGRID_MIN_ROW_HEIGHT
%define WXGRID_MIN_COL_WIDTH
%define WXGRID_DEFAULT_SCROLLBAR_WIDTH

%define_string wxGRID_VALUE_STRING
%define_string wxGRID_VALUE_BOOL
%define_string wxGRID_VALUE_NUMBER
%define_string wxGRID_VALUE_FLOAT
%define_string wxGRID_VALUE_CHOICE
%define_string wxGRID_VALUE_TEXT
%define_string wxGRID_VALUE_LONG

%define_string wxGRID_VALUE_CHOICEINT
%define_string wxGRID_VALUE_DATETIME

%wxchkver_2_8_8 %define wxGRID_AUTOSIZE

// ---------------------------------------------------------------------------
// wxGridCellWorker

%class %delete wxGridCellWorker, wxClientDataContainer
    // wxGridCellWorker() - base class only

    void IncRef()
    void DecRef()

%if !defined(WXUSINGDLL)
    // Getting the value of the ref count is only possible in non-dll wxWidgets library.
    //int GetRef() const // wxLua added function to help track if it needs to be refed
%endif

    virtual void SetParameters(const wxString& params)
%endclass

// ---------------------------------------------------------------------------
// wxGridCellRenderer

%class %delete wxGridCellRenderer, wxGridCellWorker
    //wxGridCellRenderer() - no constructor abstract class

    //virtual void Draw(wxGrid& grid, wxGridCellAttr& attr, wxDC& dc, const wxRect& rect, int row, int col, bool isSelected)
    virtual wxSize GetBestSize(wxGrid& grid, wxGridCellAttr& attr, wxDC& dc, int row, int col)
%endclass

// ---------------------------------------------------------------------------
// wxGridCellStringRenderer

%class %delete wxGridCellStringRenderer, wxGridCellRenderer
    wxGridCellStringRenderer()

%endclass

// ---------------------------------------------------------------------------
// wxGridCellNumberRenderer

%class %delete wxGridCellNumberRenderer, wxGridCellStringRenderer
    wxGridCellNumberRenderer()
%endclass

// ---------------------------------------------------------------------------
// wxGridCellFloatRenderer

%class %delete wxGridCellFloatRenderer, wxGridCellStringRenderer
    wxGridCellFloatRenderer(int width = -1, int precision = -1)

    int GetWidth() const
    void SetWidth(int width)
    int GetPrecision() const
    void SetPrecision(int precision)
%endclass

// ---------------------------------------------------------------------------
// wxGridCellBoolRenderer

%class %delete wxGridCellBoolRenderer, wxGridCellRenderer
    wxGridCellBoolRenderer()
%endclass

// ---------------------------------------------------------------------------
// wxGridCellDateTimeRenderer

%class %delete wxGridCellDateTimeRenderer, wxGridCellStringRenderer
    wxGridCellDateTimeRenderer(const wxString& outformat = wxDefaultDateTimeFormat, const wxString& informat = wxDefaultDateTimeFormat)
%endclass

// ---------------------------------------------------------------------------
// wxGridCellEnumRenderer

%class %delete wxGridCellEnumRenderer, wxGridCellStringRenderer
    wxGridCellEnumRenderer( const wxString& choices = "" )
%endclass

// ---------------------------------------------------------------------------
// wxGridCellAutoWrapStringRenderer

%class %delete wxGridCellAutoWrapStringRenderer, wxGridCellStringRenderer
    wxGridCellAutoWrapStringRenderer()
%endclass

// ---------------------------------------------------------------------------
// wxGridCellEditor

%class %delete wxGridCellEditor, wxGridCellWorker
    // wxGridCellEditor() - no constructor abstract class

    bool IsCreated()
    wxControl* GetControl()
    // wxLua Note: This will delete the control
    void SetControl(%ungc wxControl* control)
    wxGridCellAttr* GetCellAttr()
    // wxLua Note: the attr must exist for the life of this object and it doesn't take ownership
    void SetCellAttr(wxGridCellAttr* attr)

    //virtual void Create(wxWindow* parent, wxWindowID id, wxEvtHandler* evtHandler)
    virtual void BeginEdit(int row, int col, wxGrid* grid)
    virtual bool EndEdit(int row, int col, wxGrid* grid)
    virtual void Reset()
    //virtual wxGridCellEditor *Clone() const
    virtual void SetSize(const wxRect& rect)
    virtual void Show(bool show, wxGridCellAttr *attr = NULL)
    virtual void PaintBackground(const wxRect& rectCell, wxGridCellAttr *attr)
    virtual bool IsAcceptedKey(wxKeyEvent& event)
    virtual void StartingKey(wxKeyEvent& event)
    virtual void StartingClick()
    virtual void HandleReturn(wxKeyEvent& event)
    virtual void Destroy()
%endclass

// ---------------------------------------------------------------------------
// wxGridCellTextEditor

%class %delete wxGridCellTextEditor, wxGridCellEditor
    wxGridCellTextEditor()
%endclass

// ---------------------------------------------------------------------------
// wxGridCellNumberEditor

%class %delete wxGridCellNumberEditor, wxGridCellTextEditor
    wxGridCellNumberEditor(int min = -1, int max = -1)
%endclass

// ---------------------------------------------------------------------------
// wxGridCellFloatEditor

%class %delete wxGridCellFloatEditor, wxGridCellTextEditor
    wxGridCellFloatEditor(int width = -1, int precision = -1)
%endclass

// ---------------------------------------------------------------------------
// wxGridCellBoolEditor

%class %delete wxGridCellBoolEditor, wxGridCellEditor
    wxGridCellBoolEditor()
%endclass

// ---------------------------------------------------------------------------
// wxGridCellChoiceEditor

%class %delete wxGridCellChoiceEditor, wxGridCellEditor
    wxGridCellChoiceEditor(const wxArrayString& choices, bool allowOthers = false)
%endclass

// ---------------------------------------------------------------------------
// wxGridCellEnumEditor

%class %delete wxGridCellEnumEditor, wxGridCellChoiceEditor
    wxGridCellEnumEditor( const wxString& choices = "" )
%endclass

// ---------------------------------------------------------------------------
// wxGridCellAutoWrapStringEditor

%class %delete wxGridCellAutoWrapStringEditor, wxGridCellTextEditor
    wxGridCellAutoWrapStringEditor()
%endclass

// ---------------------------------------------------------------------------
// wxGridCellAttr

%enum wxGridCellAttr::wxAttrKind
    Any
    Default
    Cell
    Row
    Col
    Merged
%endenum

%class %delete wxGridCellAttr, wxClientDataContainer
    wxGridCellAttr()
    wxGridCellAttr(const wxColour& colText, const wxColour& colBack, const wxFont& font, int hAlign, int vAlign)

    void MergeWith(wxGridCellAttr *mergefrom)
    void IncRef()
    void DecRef()
    void SetTextColour(const wxColour& colText)
    void SetBackgroundColour(const wxColour& colBack)
    void SetFont(const wxFont& font)
    void SetAlignment(int hAlign, int vAlign)
    void SetSize(int num_rows, int num_cols)
    void SetOverflow(bool allow = true)
    void SetReadOnly(bool isReadOnly = true)
    // wxLua Note: the renderer must exist for the life of this object and it doesn't take ownership, but it does call DecRef()
    void SetRenderer(wxGridCellRenderer *renderer)
    // wxLua Note: the editor must exist for the life of this object and it doesn't take ownership, but it does call DecRef()
    void SetEditor(wxGridCellEditor* editor)
    void SetKind(wxGridCellAttr::wxAttrKind kind)
    bool HasTextColour() const
    bool HasBackgroundColour() const
    bool HasFont() const
    bool HasAlignment() const
    bool HasRenderer() const
    bool HasEditor() const
    bool HasReadWriteMode() const
    bool HasOverflowMode() const
    bool HasSize() const
    wxColour GetTextColour() const
    wxColour GetBackgroundColour() const
    wxFont GetFont() const

    // %override [int horiz, int vert] wxGridCellAttr::GetAlignment() const
    // C++ Func: void GetAlignment(int *horz, int *vert) const
    void GetAlignment() const

    // %override [int num_rows, int num_cols] wxGridCellAttr::GetSize() const
    // C++ Func: void GetSize(int *num_rows, int *num_cols) const
    void GetSize() const

    bool GetOverflow() const
    wxGridCellRenderer *GetRenderer(wxGrid* grid, int row, int col) const
    wxGridCellEditor *GetEditor(wxGrid* grid, int row, int col) const
    bool IsReadOnly() const
    wxGridCellAttr::wxAttrKind GetKind()
    // wxLua Note: the attr must exist for the life of this object and it doesn't take ownership
    void SetDefAttr(wxGridCellAttr* defAttr)
%endclass

// ---------------------------------------------------------------------------
// wxGridCellAttrProvider

%class %delete wxGridCellAttrProvider, wxClientDataContainer
    wxGridCellAttrProvider()

    // wxLua Note: You must call DecRef() on the returned attr.
    wxGridCellAttr *GetAttr(int row, int col, wxGridCellAttr::wxAttrKind  kind) const
    void SetAttr(%ungc wxGridCellAttr *attr, int row, int col)
    void SetRowAttr(%ungc wxGridCellAttr *attr, int row)
    void SetColAttr(%ungc wxGridCellAttr *attr, int col)
    void UpdateAttrRows( size_t pos, int numRows )
    void UpdateAttrCols( size_t pos, int numCols )
%endclass

// ---------------------------------------------------------------------------
// wxGridTableBase

%class wxGridTableBase, wxObject //, wxClientDataContainer
    // no constructor pure virtual base class

    virtual int GetNumberRows()
    virtual int GetNumberCols()
    virtual bool IsEmptyCell( int row, int col )
    virtual wxString GetValue( int row, int col )
    virtual void SetValue( int row, int col, const wxString& value )
    virtual wxString GetTypeName( int row, int col )
    virtual bool CanGetValueAs( int row, int col, const wxString& typeName )
    virtual bool CanSetValueAs( int row, int col, const wxString& typeName )
    virtual bool GetValueAsBool( int row, int col )
    virtual long GetValueAsLong( int row, int col )
    virtual double GetValueAsDouble( int row, int col )
    virtual void SetValueAsBool( int row, int col, bool value )
    virtual void SetValueAsLong( int row, int col, long value )
    virtual void SetValueAsDouble( int row, int col, double value )
    //virtual void* GetValueAsCustom( int row, int col, const wxString& typeName )
    //virtual void  SetValueAsCustom( int row, int col, const wxString& typeName, void* value )
    virtual void SetView( wxGrid *grid )
    virtual wxGrid * GetView() const
    virtual void Clear()
    virtual bool InsertRows( size_t pos = 0, size_t numRows = 1 )
    virtual bool AppendRows( size_t numRows = 1 )
    virtual bool DeleteRows( size_t pos = 0, size_t numRows = 1 )
    virtual bool InsertCols( size_t pos = 0, size_t numCols = 1 )
    virtual bool AppendCols( size_t numCols = 1 )
    virtual bool DeleteCols( size_t pos = 0, size_t numCols = 1 )
    virtual wxString GetRowLabelValue( int row )
    virtual wxString GetColLabelValue( int col )
    virtual void SetRowLabelValue( int row, const wxString& value )
    virtual void SetColLabelValue( int col, const wxString& value )

    void SetAttrProvider(wxGridCellAttrProvider *attrProvider)
    wxGridCellAttrProvider *GetAttrProvider() const
    virtual bool CanHaveAttributes()
    virtual wxGridCellAttr* GetAttr( int row, int col, wxGridCellAttr::wxAttrKind  kind)

    void SetAttr(%ungc wxGridCellAttr* attr, int row, int col)
    void SetRowAttr(%ungc wxGridCellAttr *attr, int row)
    void SetColAttr(%ungc wxGridCellAttr *attr, int col)
%endclass

// ---------------------------------------------------------------------------
// wxLuaGridTableBase

%include "wxbind/include/wxadv_wxladv.h"

%class %delete wxLuaGridTableBase, wxGridTableBase
    // %override - the C++ function takes the wxLuaState as the first param
    wxLuaGridTableBase()

    // The functions below are all virtual functions that you override in Lua.

    // You must override these functions in a derived table class
    //
    //virtual int GetNumberRows();
    //virtual int GetNumberCols();
    //virtual bool IsEmptyCell( int row, int col );
    //virtual wxString GetValue( int row, int col );
    //virtual void SetValue( int row, int col, const wxString& value );
    //
    // Data type determination and value access
    //virtual wxString GetTypeName( int row, int col );
    //virtual bool CanGetValueAs( int row, int col, const wxString& typeName );
    //virtual bool CanSetValueAs( int row, int col, const wxString& typeName );
    //
    //virtual long GetValueAsLong( int row, int col );
    //virtual double GetValueAsDouble( int row, int col );
    //virtual bool GetValueAsBool( int row, int col );
    //
    //virtual void SetValueAsLong( int row, int col, long value );
    //virtual void SetValueAsDouble( int row, int col, double value );
    //virtual void SetValueAsBool( int row, int col, bool value );
    //
    // For user defined types
    //virtual void* GetValueAsCustom( int row, int col, const wxString& typeName );
    //virtual void  SetValueAsCustom( int row, int col, const wxString& typeName, void* value );
    //
    // Overriding these is optional
    //
    //virtual void SetView( wxGrid *grid ) { m_view = grid; }
    //virtual wxGrid * GetView() const { return m_view; }
    //
    //virtual void Clear() {}
    //virtual bool InsertRows( size_t pos = 0, size_t numRows = 1 );
    //virtual bool AppendRows( size_t numRows = 1 );
    //virtual bool DeleteRows( size_t pos = 0, size_t numRows = 1 );
    //virtual bool InsertCols( size_t pos = 0, size_t numCols = 1 );
    //virtual bool AppendCols( size_t numCols = 1 );
    //virtual bool DeleteCols( size_t pos = 0, size_t numCols = 1 );
    //
    //virtual wxString GetRowLabelValue( int row );
    //virtual wxString GetColLabelValue( int col );
    //virtual void SetRowLabelValue( int WXUNUSED(row), const wxString& ) {}
    //virtual void SetColLabelValue( int WXUNUSED(col), const wxString& ) {}
    //
    // Attribute handling
    //
    // give us the attr provider to use - we take ownership of the pointer
    //void SetAttrProvider(wxGridCellAttrProvider *attrProvider);
    //
    // get the currently used attr provider (may be NULL)
    //wxGridCellAttrProvider *GetAttrProvider() const { return m_attrProvider; }
    //
    // Does this table allow attributes?  Default implementation creates
    // a wxGridCellAttrProvider if necessary.
    //virtual bool CanHaveAttributes();
    //
    // by default forwarded to wxGridCellAttrProvider if any. May be
    // overridden to handle attributes directly in the table.
    //virtual wxGridCellAttr *GetAttr( int row, int col,
    //                                 wxGridCellAttr::wxAttrKind  kind );
    //
    // these functions take ownership of the pointer
    //virtual void SetAttr(wxGridCellAttr* attr, int row, int col);
    //virtual void SetRowAttr(wxGridCellAttr *attr, int row);
    //virtual void SetColAttr(wxGridCellAttr *attr, int col);
%endclass

// ---------------------------------------------------------------------------
// wxGridStringTable

%class %delete wxGridStringTable, wxGridTableBase
    wxGridStringTable( int numRows=0, int numCols=0 )
%endclass

// ---------------------------------------------------------------------------
// wxGridTableMessage

%enum wxGridTableRequest
    wxGRIDTABLE_REQUEST_VIEW_GET_VALUES
    wxGRIDTABLE_REQUEST_VIEW_SEND_VALUES
    wxGRIDTABLE_NOTIFY_ROWS_INSERTED
    wxGRIDTABLE_NOTIFY_ROWS_APPENDED
    wxGRIDTABLE_NOTIFY_ROWS_DELETED
    wxGRIDTABLE_NOTIFY_COLS_INSERTED
    wxGRIDTABLE_NOTIFY_COLS_APPENDED
    wxGRIDTABLE_NOTIFY_COLS_DELETED
%endenum


%class %delete wxGridTableMessage
    wxGridTableMessage( wxGridTableBase *table, int id, int comInt1 = -1, int comInt2 = -1 )

    void SetTableObject( wxGridTableBase *table )
    wxGridTableBase * GetTableObject() const
    void SetId( int id )
    int  GetId()
    void SetCommandInt( int comInt1 )
    int  GetCommandInt()
    void SetCommandInt2( int comInt2 )
    int  GetCommandInt2()
%endclass

// ---------------------------------------------------------------------------
// wxGridCellCoords

%class %delete wxGridCellCoords
    %define_object wxGridNoCellCoords

    wxGridCellCoords( int r = -1, int c = -1 )

    int GetRow() const
    void SetRow( int n )
    int GetCol() const
    void SetCol( int n )
    void Set(int row, int col)

    %operator wxGridCellCoords& operator=( const wxGridCellCoords& other )
    %operator bool operator==( const wxGridCellCoords& other ) const
    %operator bool operator!() const
%endclass

// ---------------------------------------------------------------------------
// wxGridCellCoordsArray

%include "wx/dynarray.h"

%class %delete wxGridCellCoordsArray
    wxGridCellCoordsArray()
    wxGridCellCoordsArray(const wxGridCellCoordsArray& array)

    void Add( const wxGridCellCoords& c )
    void Alloc(size_t count)
    void Clear()
    int  GetCount() const
    bool IsEmpty() const
    void Insert( const wxGridCellCoords& c, int n, int copies = 1 )
    wxGridCellCoords Item( int n )
    void RemoveAt(size_t index)
    void Shrink()

    %operator wxGridCellCoords operator[](size_t nIndex)

%endclass

// ---------------------------------------------------------------------------
// wxGrid

%enum wxGrid::wxGridSelectionModes
    wxGridSelectCells
    wxGridSelectRows
    wxGridSelectColumns
%endenum

%class wxGrid, wxScrolledWindow
    wxGrid( wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxWANTS_CHARS, const wxString &name = "wxGrid" )

    bool    CreateGrid( int numRows, int numCols, wxGrid::wxGridSelectionModes selmode = wxGrid::wxGridSelectCells )

    void    SetSelectionMode(wxGrid::wxGridSelectionModes selmode)
    wxGrid::wxGridSelectionModes GetSelectionMode() const
    int     GetNumberRows()
    int     GetNumberCols()

    //wxArrayInt CalcRowLabelsExposed( const wxRegion& reg )
    //wxArrayInt CalcColLabelsExposed( const wxRegion& reg )
    //wxGridCellCoordsArray CalcCellsExposed( const wxRegion& reg )
    //void ProcessRowLabelMouseEvent( wxMouseEvent& event );
    //void ProcessColLabelMouseEvent( wxMouseEvent& event );
    //void ProcessCornerLabelMouseEvent( wxMouseEvent& event );
    //void ProcessGridCellMouseEvent( wxMouseEvent& event );
    bool ProcessTableMessage( wxGridTableMessage& msg )
    //void DoEndDragResizeRow();
    //void DoEndDragResizeCol();

    wxGridTableBase * GetTable() const

    // %override so that takeOwnership releases the table from garbage collection by Lua
    bool    SetTable( wxGridTableBase * table, bool takeOwnership = false, wxGrid::wxGridSelectionModes selmode = wxGrid::wxGridSelectCells )

    void    ClearGrid()
    bool    InsertRows( int pos = 0, int numRows = 1, bool updateLabels=true )
    bool    AppendRows( int numRows = 1, bool updateLabels=true )
    bool    DeleteRows( int pos = 0, int numRows = 1, bool updateLabels=true )
    bool    InsertCols( int pos = 0, int numCols = 1, bool updateLabels=true )
    bool    AppendCols( int numCols = 1, bool updateLabels=true )
    bool    DeleteCols( int pos = 0, int numCols = 1, bool updateLabels=true )

    //void DrawGridCellArea( wxDC& dc , const wxGridCellCoordsArray& cells );
    //void DrawGridSpace( wxDC& dc );
    //void DrawCellBorder( wxDC& dc, const wxGridCellCoords& );
    //void DrawAllGridLines( wxDC& dc, const wxRegion& reg );
    //void DrawCell( wxDC& dc, const wxGridCellCoords& );
    //void DrawHighlight(wxDC& dc, const wxGridCellCoordsArray& cells);
    //virtual void DrawCellHighlight( wxDC& dc, const wxGridCellAttr *attr );
    //virtual void DrawRowLabels( wxDC& dc, const wxArrayInt& rows );
    //virtual void DrawRowLabel( wxDC& dc, int row );
    //virtual void DrawColLabels( wxDC& dc, const wxArrayInt& cols );
    //virtual void DrawColLabel( wxDC& dc, int col );
    void DrawTextRectangle( wxDC& dc, const wxString&, const wxRect&, int horizontalAlignment = wxALIGN_LEFT, int verticalAlignment = wxALIGN_TOP, int textOrientation = wxHORIZONTAL )
    //void DrawTextRectangle( wxDC& dc, const wxArrayString& lines, const wxRect&, int horizontalAlignment = wxALIGN_LEFT, int verticalAlignment = wxALIGN_TOP, int textOrientation = wxHORIZONTAL )
    void StringToLines( const wxString& value, wxArrayString& lines )

    // %override [long width, long height] wxGrid::GetTextBoxSize(wxDC& dc, const wxArrayString& lines)
    // C++ Func: void GetTextBoxSize( wxDC& dc, const wxArrayString& lines, long *width, long *height )
    void GetTextBoxSize( wxDC& dc, const wxArrayString& lines )

    void    BeginBatch()
    void    EndBatch()
    int     GetBatchCount()
    void    ForceRefresh()

    bool    IsEditable()
    void    EnableEditing( bool edit )
    void    EnableCellEditControl( bool enable = true )
    void    DisableCellEditControl()
    bool    CanEnableCellControl() const
    bool    IsCellEditControlEnabled() const
    bool    IsCellEditControlShown() const
    bool    IsCurrentCellReadOnly() const
    void    ShowCellEditControl()
    void    HideCellEditControl()
    void    SaveEditControlValue()

    void    XYToCell( int x, int y, wxGridCellCoords& coords)
    int     XToCol( int x )
    int     YToRow( int y )
    int     XToEdgeOfCol( int x )
    int     YToEdgeOfRow( int y )
    wxRect  CellToRect( int row, int col )
    //wxRect CellToRect( const wxGridCellCoords& coords )
    int     GetGridCursorRow()
    int     GetGridCursorCol()
    bool    IsVisible( int row, int col, bool wholeCellVisible = true )
    //bool  IsVisible( const wxGridCellCoords& coords, bool wholeCellVisible = true )
    void    MakeCellVisible( int row, int col )
    //void  MakeCellVisible( const wxGridCellCoords& coords )

    void    SetGridCursor( int row, int col )
    bool    MoveCursorUp( bool expandSelection )
    bool    MoveCursorDown( bool expandSelection )
    bool    MoveCursorLeft( bool expandSelection )
    bool    MoveCursorRight( bool expandSelection )
    bool    MovePageDown()
    bool    MovePageUp()
    bool    MoveCursorUpBlock( bool expandSelection )
    bool    MoveCursorDownBlock( bool expandSelection )
    bool    MoveCursorLeftBlock( bool expandSelection )
    bool    MoveCursorRightBlock( bool expandSelection )

    int     GetDefaultRowLabelSize()
    int     GetRowLabelSize()
    int     GetDefaultColLabelSize()
    int     GetColLabelSize()
    wxColour GetLabelBackgroundColour()
    wxColour GetLabelTextColour()
    wxFont  GetLabelFont()

    // %override [int horiz, int vert] wxGrid::GetRowLabelAlignment()
    // C++ Func: void GetRowLabelAlignment( int *horiz, int *vert )
    void    GetRowLabelAlignment( int *horz, int *vert )
    // %override [int horiz, int vert] wxGrid::GetColLabelAlignment()
    // C++ Func: void GetColLabelAlignment( int *horiz, int *vert )
    void    GetColLabelAlignment( int *horz, int *vert )

    int     GetColLabelTextOrientation()
    wxString GetRowLabelValue( int row )
    wxString GetColLabelValue( int col )
    wxColour GetGridLineColour()
    wxColour GetCellHighlightColour()
    int     GetCellHighlightPenWidth()
    int     GetCellHighlightROPenWidth()
    void    SetRowLabelSize( int width )
    void    SetColLabelSize( int height )
    void    SetLabelBackgroundColour( const wxColour& backColour )
    void    SetLabelTextColour( const wxColour& textColour)
    void    SetLabelFont( const wxFont& labelFont)
    void    SetRowLabelAlignment( int horiz, int vert )
    void    SetColLabelAlignment( int horiz, int vert )
    void    SetRowLabelValue( int row, const wxString& value )
    void    SetColLabelValue( int col, const wxString& value)
    void    SetGridLineColour( const wxColour& lineColour)
    void    SetCellHighlightColour( const wxColour& highlightColour)
    void    SetCellHighlightPenWidth(int width)
    void    SetCellHighlightROPenWidth(int width)

    void    EnableDragRowSize( bool enable = true )
    void    DisableDragRowSize()
    bool    CanDragRowSize()
    void    EnableDragColSize( bool enable = true )
    void    DisableDragColSize()
    bool    CanDragColSize()
    void    EnableDragGridSize(bool enable = true)
    void    DisableDragGridSize()
    bool    CanDragGridSize()
    void    EnableDragCell( bool enable = true )
    void    DisableDragCell()
    bool    CanDragCell()

    void    SetAttr(int row, int col, %ungc wxGridCellAttr *attr)
    void    SetRowAttr(int row, %ungc wxGridCellAttr *attr)
    void    SetColAttr(int col, %ungc wxGridCellAttr *attr)
    wxGridCellAttr *GetOrCreateCellAttr(int row, int col) const

    void    SetColFormatBool(int col)
    void    SetColFormatNumber(int col)
    void    SetColFormatFloat(int col, int width = -1, int precision = -1)
    void    SetColFormatCustom(int col, const wxString& typeName)

    void    EnableGridLines( bool enable = true )
    bool    GridLinesEnabled()

    int      GetDefaultRowSize()
    int      GetRowSize( int row )
    int      GetDefaultColSize()
    int      GetColSize( int col )
    wxColour GetDefaultCellBackgroundColour()
    wxColour GetCellBackgroundColour( int row, int col )
    wxColour GetDefaultCellTextColour()
    wxColour GetCellTextColour( int row, int col )
    wxFont   GetDefaultCellFont()
    wxFont   GetCellFont( int row, int col )
    void     GetDefaultCellAlignment( int *horiz, int *vert )

    // %override [int horiz, int vert] wxGrid::GetCellAlignment( int row, int col )
    // C++ Func: void GetCellAlignment( int row, int col, int *horiz, int *vert )
    void     GetCellAlignment( int row, int col )

    bool     GetDefaultCellOverflow()
    bool     GetCellOverflow( int row, int col )

    // %override [int num_rows, int num_cols] wxGrid::GetCellSize( int row, int col )
    // C++ Func: void GetCellSize( int row, int col, int *num_rows, int *num_cols )
    void     GetCellSize( int row, int col )

    void    SetDefaultRowSize( int height, bool resizeExistingRows = false )
    void    SetRowSize( int row, int height )
    void    SetDefaultColSize( int width, bool resizeExistingCols = false )
    void    SetColSize( int col, int width )
    void    AutoSize()
    void    AutoSizeRow( int row, bool setAsMin = true )
    void    AutoSizeColumn( int col, bool setAsMin = true )
    void    AutoSizeRows( bool setAsMin = true )
    void    AutoSizeColumns( bool setAsMin = true )
    void    AutoSizeRowLabelSize( int row )
    void    AutoSizeColLabelSize( int col )

    void    SetColMinimalWidth( int col, int width )
    void    SetRowMinimalHeight( int row, int width )
    void    SetColMinimalAcceptableWidth( int width )
    void    SetRowMinimalAcceptableHeight( int width )
    int     GetColMinimalAcceptableWidth() const
    int     GetRowMinimalAcceptableHeight() const

    void    SetDefaultCellBackgroundColour( const wxColour& backColour)
    void    SetCellBackgroundColour( int row, int col, const wxColour& backColour)
    void    SetDefaultCellTextColour( const wxColour& textColour)
    void    SetCellTextColour( int row, int col, const wxColour& textColour)
    void    SetDefaultCellFont( const wxFont& cellFont)
    void    SetCellFont( int row, int col, const wxFont& cellFont)
    void    SetDefaultCellAlignment( int horiz, int vert )
    void    SetCellAlignment( int row, int col, int horiz, int vert )
    void    SetDefaultCellOverflow( bool allow )
    void    SetCellOverflow( int row, int col, bool allow )
    void    SetCellSize( int row, int col, int num_rows, int num_cols )

    void    SetDefaultRenderer(%ungc wxGridCellRenderer *renderer)
    void    SetCellRenderer(int row, int col, %ungc wxGridCellRenderer *renderer)
    wxGridCellRenderer* GetDefaultRenderer() const
    wxGridCellRenderer* GetCellRenderer(int row, int col)

    void    SetDefaultEditor(%ungc wxGridCellEditor *editor)
    void    SetCellEditor(int row, int col, %ungc wxGridCellEditor *editor)
    wxGridCellEditor* GetDefaultEditor() const
    wxGridCellEditor* GetCellEditor(int row, int col)

    wxString GetCellValue( int row, int col )
    // wxString GetCellValue( const wxGridCellCoords& coords )
    void SetCellValue( int row, int col, const wxString& s )
    // void SetCellValue( const wxGridCellCoords& coords, const wxString& s )

    bool    IsReadOnly(int row, int col) const
    void    SetReadOnly(int row, int col, bool isReadOnly = true)

    void    SelectRow( int row, bool addToSelected = false )
    void    SelectCol( int col, bool addToSelected = false )
    void    SelectBlock( int topRow, int leftCol, int bottomRow, int rightCol, bool addToSelected = false )
    // void SelectBlock( const wxGridCellCoords& topLeft, const wxGridCellCoords& bottomRight)
    void    SelectAll()
    bool    IsSelection()
    void DeselectRow( int row )
    void DeselectCol( int col )
    void DeselectCell( int row, int col )
    void    ClearSelection()
    bool    IsInSelection( int row, int col )
    // bool IsInSelection( const wxGridCellCoords& coords )

    wxGridCellCoordsArray GetSelectedCells() const
    wxGridCellCoordsArray GetSelectionBlockTopLeft() const
    wxGridCellCoordsArray GetSelectionBlockBottomRight() const
    wxArrayInt GetSelectedRows() const
    wxArrayInt GetSelectedCols() const

    wxRect  BlockToDeviceRect( const wxGridCellCoords& topLeft, const wxGridCellCoords& bottomRight )

    wxColour GetSelectionBackground() const
    wxColour GetSelectionForeground() const
    void    SetSelectionBackground(const wxColour& c)
    void    SetSelectionForeground(const wxColour& c)

    void    RegisterDataType(const wxString& typeName, %ungc wxGridCellRenderer* renderer, %ungc wxGridCellEditor* editor)
    wxGridCellEditor* GetDefaultEditorForCell(int row, int col) const
    //wxGridCellEditor* GetDefaultEditorForCell(const wxGridCellCoords& coords) const
    wxGridCellRenderer* GetDefaultRendererForCell(int row, int col) const
    wxGridCellEditor* GetDefaultEditorForType(const wxString& typeName) const
    wxGridCellRenderer* GetDefaultRendererForType(const wxString& typeName) const
    void SetMargins(int extraWidth, int extraHeight)

    wxWindow* GetGridWindow()
    wxWindow* GetGridRowLabelWindow()
    wxWindow* GetGridColLabelWindow()
    wxWindow* GetGridCornerLabelWindow()

    //void SetScrollLineX(int x)
    //void SetScrollLineY(int y)
    //int GetScrollLineX() const
    //int GetScrollLineY() const
    //int GetScrollX(int x) const
    //int GetScrollY(int y) const
%endclass

// ---------------------------------------------------------------------------
// wxGridEvent

%class %delete wxGridEvent, wxNotifyEvent
    %define_event wxEVT_GRID_CELL_LEFT_CLICK    // EVT_GRID_CELL_LEFT_CLICK(fn)  // FIXME! wxEVT_CMD_GRID_XXX in > 2.6
    %define_event wxEVT_GRID_CELL_RIGHT_CLICK   // EVT_GRID_CELL_RIGHT_CLICK(fn)
    %define_event wxEVT_GRID_CELL_LEFT_DCLICK   // EVT_GRID_CELL_LEFT_DCLICK(fn)
    %define_event wxEVT_GRID_CELL_RIGHT_DCLICK  // EVT_GRID_CELL_RIGHT_DCLICK(fn)
    %define_event wxEVT_GRID_LABEL_LEFT_CLICK   // EVT_GRID_LABEL_LEFT_CLICK(fn)
    %define_event wxEVT_GRID_LABEL_RIGHT_CLICK  // EVT_GRID_LABEL_RIGHT_CLICK(fn)
    %define_event wxEVT_GRID_LABEL_LEFT_DCLICK  // EVT_GRID_LABEL_LEFT_DCLICK(fn)
    %define_event wxEVT_GRID_LABEL_RIGHT_DCLICK // EVT_GRID_LABEL_RIGHT_DCLICK(fn)
    %define_event wxEVT_GRID_CELL_CHANGE        // EVT_GRID_CELL_CHANGE(fn)
    %define_event wxEVT_GRID_SELECT_CELL        // EVT_GRID_SELECT_CELL(fn)
    %define_event wxEVT_GRID_EDITOR_SHOWN       // EVT_GRID_EDITOR_SHOWN(fn)
    %define_event wxEVT_GRID_EDITOR_HIDDEN      // EVT_GRID_EDITOR_HIDDEN(fn)
    %define_event wxEVT_GRID_CELL_BEGIN_DRAG    // EVT_GRID_CELL_BEGIN_DRAG(fn)

    wxGridEvent(int id, wxEventType type, wxObject* obj, int row = -1, int col = -1, int x = -1, int y = -1, bool sel = true, bool control = false, bool shift = false, bool alt = false, bool meta = false)

    virtual int GetRow()
    virtual int GetCol()
    wxPoint     GetPosition()
    bool        Selecting()
    bool        ControlDown()
    bool        MetaDown()
    bool        ShiftDown()
    bool        AltDown()
%endclass

// ---------------------------------------------------------------------------
// wxGridSizeEvent

%class %delete wxGridSizeEvent, wxNotifyEvent
    %define_event wxEVT_GRID_ROW_SIZE           // EVT_GRID_CMD_ROW_SIZE(id, fn)
    %define_event wxEVT_GRID_COL_SIZE           // EVT_GRID_CMD_COL_SIZE(id, fn)

    wxGridSizeEvent(int id, wxEventType type, wxObject* obj, int rowOrCol = -1, int x = -1, int y = -1, bool control = false, bool shift = false, bool alt = false, bool meta = false)

    int         GetRowOrCol()
    wxPoint     GetPosition()
    bool        ShiftDown()
    bool        ControlDown()
    bool        AltDown()
    bool        MetaDown()
%endclass

// ---------------------------------------------------------------------------
// wxGridRangeSelectEvent

%class %delete wxGridRangeSelectEvent, wxNotifyEvent
    %define_event wxEVT_GRID_RANGE_SELECT       // EVT_GRID_CMD_RANGE_SELECT(id, fn)

    wxGridRangeSelectEvent(int id, wxEventType type, wxObject* obj, const wxGridCellCoords& topLeft, const wxGridCellCoords& bottomRight, bool sel = true, bool control = false, bool shift = false, bool alt = false, bool meta = false)

    wxGridCellCoords GetTopLeftCoords()
    wxGridCellCoords GetBottomRightCoords()
    int         GetTopRow()
    int         GetBottomRow()
    int         GetLeftCol()
    int         GetRightCol()
    bool        Selecting()
    bool        ControlDown()
    bool        ShiftDown()
    bool        MetaDown()
    bool        AltDown()
%endclass

// ---------------------------------------------------------------------------
// wxGridEditorCreatedEvent

%class %delete wxGridEditorCreatedEvent, wxCommandEvent
    %define_event wxEVT_GRID_EDITOR_CREATED     // EVT_GRID_EDITOR_CREATED(fn)

    wxGridEditorCreatedEvent(int id, wxEventType type, wxObject* obj, int row, int col, wxControl* ctrl)

    int GetRow()
    int GetCol()
    wxControl* GetControl()
    void SetRow(int row)
    void SetCol(int col)
    void SetControl(wxControl * ctrl)
%endclass

%endif //wxLUA_USE_wxGrid && wxUSE_GRID
