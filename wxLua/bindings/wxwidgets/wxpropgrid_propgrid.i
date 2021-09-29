// ===========================================================================
// Purpose:     wxPropertyGrid library
// Author:      John Labenski
// Created:     05/01/2013
// Copyright:   (c) 2013 John Labenski. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.9.5
// ===========================================================================

// NOTE: This file is mostly copied from wxWidget's include/propgrid/*.h headers
// to make updating it easier.

#if wxLUA_USE_wxPropertyGrid && %wxchkver_2_9 && wxUSE_PROPGRID

#include "wx/propgrid/propgrid.h"

class %delete wxPropertyGrid : public wxPropertyGridInterface
{
    wxPropertyGrid();
    %ungc wxPropertyGrid( wxWindow *parent, wxWindowID id = wxID_ANY, const wxPoint& pos = wxDefaultPosition,
                          const wxSize& size = wxDefaultSize, long style = wxPG_DEFAULT_STYLE,
                          const wxString& name = wxPropertyGridNameStr );

    void AddActionTrigger( int action, int keycode, int modifiers = 0 );
    bool AddToSelection( wxPGPropArg id );
    static void AutoGetTranslation( bool enable );
    void BeginLabelEdit( unsigned int colIndex = 0 );
    bool ChangePropertyValue( wxPGPropArg id, wxVariant newValue );
    void CenterSplitter( bool enableAutoResizing = false );
    virtual void Clear();
    void ClearActionTriggers( int action );

    virtual bool CommitChangesFromEditor( wxUint32 flags = 0 );

    %ungc bool Create( wxWindow *parent, wxWindowID id = wxID_ANY,
                const wxPoint& pos = wxDefaultPosition,
                const wxSize& size = wxDefaultSize,
                long style = wxPG_DEFAULT_STYLE,
                const wxString& name = wxPropertyGridNameStr );

    void DedicateKey( int keycode );
    bool EnableCategories( bool enable );
    void EndLabelEdit( bool commit = true );
    bool EnsureVisible( wxPGPropArg id );
    wxSize FitColumns();
    wxTextCtrl* GetLabelEditor() const;
    wxWindow* GetPanel();
    wxColour GetCaptionBackgroundColour() const;
    wxFont& GetCaptionFont();
    wxColour GetCaptionForegroundColour() const;
    wxColour GetCellBackgroundColour() const;
    wxColour GetCellDisabledTextColour() const;
    wxColour GetCellTextColour() const;
    unsigned int GetColumnCount() const;
    wxColour GetEmptySpaceColour() const;
    int GetFontHeight() const;
    wxPropertyGrid* GetGrid();
    wxRect GetImageRect( wxPGProperty* property, int item ) const;
    wxSize GetImageSize( wxPGProperty* property = NULL, int item = -1 ) const;
    wxPGProperty* GetLastItem( int flags = wxPG_ITERATE_DEFAULT );
    wxColour GetLineColour() const;
    wxColour GetMarginColour() const;
    int GetMarginWidth() const;
    wxPGProperty* GetRoot() const;
    int GetRowHeight() const;
    wxPGProperty* GetSelectedProperty() const;
    wxPGProperty* GetSelection() const;
    wxColour GetSelectionBackgroundColour() const;
    wxColour GetSelectionForegroundColour() const;
    /* wxPGSortCallback GetSortFunction() const; */
    int GetSplitterPosition( unsigned int splitterIndex = 0 ) const;
    wxTextCtrl* GetEditorTextCtrl() const;
    /* const wxPGCell& GetUnspecifiedValueAppearance() const; */
    wxString GetUnspecifiedValueText( int argFlags = 0 ) const;
    int GetVerticalSpacing() const;
    /* wxPropertyGridHitTestResult HitTest( const wxPoint& pt ) const; */
    bool IsAnyModified() const;
    bool IsEditorFocused() const;
    bool IsFrozen() const;
    void MakeColumnEditable( unsigned int column, bool editable = true );
    void OnTLPChanging( wxWindow* newTLP );
    void RefreshEditor();
    virtual void RefreshProperty( wxPGProperty* p );

    /* static wxPGEditor* RegisterEditorClass( wxPGEditor* editor, bool noDefCheck = false ); */
    /* static wxPGEditor* DoRegisterEditorClass( wxPGEditor* editor, const wxString& name, bool noDefCheck = false ); */

    void ResetColours();
    void ResetColumnSizes( bool enableAutoResizing = false );
    bool RemoveFromSelection( wxPGPropArg id );
    bool SelectProperty( wxPGPropArg id, bool focus = false );
    void SetCaptionBackgroundColour(const wxColour& col);
    void SetCaptionTextColour(const wxColour& col);
    void SetCellBackgroundColour(const wxColour& col);
    void SetCellDisabledTextColour(const wxColour& col);
    void SetCellTextColour(const wxColour& col);
    void SetColumnCount( int colCount );
    void SetCurrentCategory( wxPGPropArg id );
    void SetEmptySpaceColour(const wxColour& col);
    void SetLineColour(const wxColour& col);
    void SetMarginColour(const wxColour& col);
    /* void SetSelection( const wxArrayPGProperty& newSelection ); */
    void SetSelectionBackgroundColour(const wxColour& col);
    void SetSelectionTextColour(const wxColour& col);

    /* void SetSortFunction( wxPGSortCallback sortFunction ); */
    void SetSplitterPosition( int newxpos, int col = 0 );
    void SetSplitterLeft( bool privateChildrenToo = false );
    /* void SetUnspecifiedValueAppearance( const wxPGCell& cell ); */
    void SetVerticalSpacing( int vspacing );
    void SetVirtualWidth( int width );
    void SetupTextCtrlValue( const wxString& text );
    bool UnfocusEditor();
    void DrawItemAndValueRelated( wxPGProperty* p );

    virtual void DoShowPropertyError( wxPGProperty* property, const wxString& msg );
    virtual void DoHidePropertyError( wxPGProperty* property );
    virtual wxStatusBar* GetStatusBar();
    virtual bool DoOnValidationFailure( wxPGProperty* property, wxVariant& invalidValue );
    virtual void DoOnValidationFailureReset( wxPGProperty* property );

    void EditorsValueWasModified();
    void EditorsValueWasNotModified();
    wxVariant GetUncommittedPropertyValue();
    bool IsEditorsValueModified() const;
    void ShowPropertyError( wxPGPropArg id, const wxString& msg );
    void ValueChangeInEvent( wxVariant variant );
    bool WasValueChangedInEvent() const;
};

class %delete wxPropertyGridEvent : public wxCommandEvent
{
    %wxEventType wxEVT_PG_SELECTED
    %wxEventType wxEVT_PG_CHANGING
    %wxEventType wxEVT_PG_CHANGED
    %wxEventType wxEVT_PG_HIGHLIGHTED
    %wxEventType wxEVT_PG_RIGHT_CLICK
    %wxEventType wxEVT_PG_PAGE_CHANGED
    %wxEventType wxEVT_PG_ITEM_COLLAPSED
    %wxEventType wxEVT_PG_ITEM_EXPANDED
    %wxEventType wxEVT_PG_DOUBLE_CLICK
    %wxEventType wxEVT_PG_LABEL_EDIT_BEGIN
    %wxEventType wxEVT_PG_LABEL_EDIT_ENDING
    %wxEventType wxEVT_PG_COL_BEGIN_DRAG
    %wxEventType wxEVT_PG_COL_DRAGGING
    %wxEventType wxEVT_PG_COL_END_DRAG

    wxPropertyGridEvent(wxEventType commandType=0, int id=0);
    wxPropertyGridEvent(const wxPropertyGridEvent& event);
    bool CanVeto() const;
    unsigned int GetColumn() const;
    %gc wxPGProperty* GetMainParent() const;
    %gc wxPGProperty* GetProperty() const;
    unsigned char GetValidationFailureBehavior() const;
    wxString GetPropertyName() const;
    wxVariant GetPropertyValue() const;
    wxVariant GetValue() const;
    void SetCanVeto( bool canVeto );
    void SetProperty( wxPGProperty* p );
    void SetValidationFailureBehavior( unsigned char flags );
    void SetValidationFailureMessage( const wxString& message );
    void Veto( bool veto = true );
    bool WasVetoed() const;
};


#include "wx/propgrid/manager.h"
#include "wx/propgrid/editors.h"
#include "wx/propgrid/advprops.h"
#include "wx/propgrid/props.h"

#define wxPG_PROP_PASSWORD
class %delete wxStringProperty : public wxPGProperty
{
    wxStringProperty( const wxString& label = wxPG_LABEL,
                      const wxString& name = wxPG_LABEL,
                      const wxString& value = wxEmptyString );

    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant, const wxString& text, int argFlags = 0 ) const;
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );
    virtual void OnSetValue();
};

#include "wx/propgrid/propgridpagestate.h"

#include "wx/propgrid/propgridiface.h"

class %delete wxPGPropArgCls
{
    wxPGPropArgCls( const wxPGProperty* property );
    wxPGPropArgCls( const wxString& str );
    wxPGPropArgCls( const wxPGPropArgCls& id );
    /* wxPGPropArgCls( wxString* str, bool WXUNUSED(deallocPtr) ) */

    wxPGProperty* GetPtr() const;
    wxPGPropArgCls( const char* str );
    wxPGPropArgCls( const wchar_t* str );
    // This constructor is required for NULL.
    wxPGPropArgCls( int );
    wxPGProperty* GetPtr( wxPropertyGridInterface* iface ) const;
    wxPGProperty* GetPtr( const wxPropertyGridInterface* iface ) const;
    wxPGProperty* GetPtr0() const;
    bool HasName() const;
    const wxString& GetName();
};

typedef const wxPGPropArgCls& wxPGPropArg;

enum wxPG_PROPERTYVALUES_FLAGS
{
    wxPG_DONT_RECURSE,
    wxPG_KEEP_STRUCTURE,
    wxPG_RECURSE,
    wxPG_INC_ATTRIBUTES,
    wxPG_RECURSE_STARTS,
    wxPG_FORCE,
    wxPG_SORT_TOP_LEVEL_ONLY
};

#define_string wxPG_LABEL

enum wxPropertyGridInterface::EditableStateFlags
{
    SelectionState,
    ExpandedState,
    ScrollPosState,
    PageState,
    SplitterPosState,
    DescBoxState,
    AllStates
};

class %delete wxPropertyGridInterface
{
    wxPGProperty* Append( wxPGProperty* property );
    wxPGProperty* AppendIn( wxPGPropArg id, wxPGProperty* newProperty );
    void BeginAddChildren( wxPGPropArg id );
    virtual void Clear() = 0;
    bool ClearSelection( bool validation = false);
    void ClearModifiedStatus();
    bool Collapse( wxPGPropArg id );
    bool CollapseAll();
    bool ChangePropertyValue( wxPGPropArg id, wxVariant newValue );
    void DeleteProperty( wxPGPropArg id );
    bool DisableProperty( wxPGPropArg id );
    bool EditorValidate();
    bool EnableProperty( wxPGPropArg id, bool enable = true );
    void EndAddChildren( wxPGPropArg id );
    bool Expand( wxPGPropArg id );
    bool ExpandAll( bool expand = true );
    int GetColumnProportion( unsigned int column ) const;
    wxPGProperty* GetFirstChild( wxPGPropArg id );

    /* wxPropertyGridIterator GetIterator( int flags = wxPG_ITERATE_DEFAULT, wxPGProperty* firstProp = NULL ); */
    /* wxPropertyGridConstIterator GetIterator( int flags = wxPG_ITERATE_DEFAULT, wxPGProperty* firstProp = NULL ) const; */

    /* wxPropertyGridIterator GetIterator( int flags, int startPos ); */
    /* wxPropertyGridConstIterator GetIterator( int flags, int startPos ) const; */

    wxPGProperty* GetFirst( int flags = wxPG_ITERATE_ALL );
    const wxPGProperty* GetFirst( int flags = wxPG_ITERATE_ALL ) const;

    wxPGProperty* GetProperty( const wxString& name ) const;
    /* void GetPropertiesWithFlag( wxArrayPGProperty* targetArr, */
    /*                             wxPGProperty::FlagType flags, */
    /*                             bool inverse = false, */
    /*                             int iterFlags = (wxPG_ITERATE_PROPERTIES|wxPG_ITERATE_HIDDEN|wxPG_ITERATE_CATEGORIES) ) const; */
    wxVariant GetPropertyAttribute( wxPGPropArg id, const wxString& attrName ) const;
    /* const wxPGAttributeStorage& GetPropertyAttributes( wxPGPropArg id ) const; */
    wxColour GetPropertyBackgroundColour( wxPGPropArg id ) const;
    /* wxPropertyCategory* GetPropertyCategory( wxPGPropArg id ) const; */
    void* GetPropertyClientData( wxPGPropArg id ) const;
    wxPGProperty* GetPropertyByLabel( const wxString& label ) const;
    wxPGProperty* GetPropertyByName( const wxString& name ) const;
    wxPGProperty* GetPropertyByName( const wxString& name,
                                     const wxString& subname ) const;
    /* const wxPGEditor* GetPropertyEditor( wxPGPropArg id ) const; */
    wxString GetPropertyHelpString( wxPGPropArg id ) const;
    wxBitmap* GetPropertyImage( wxPGPropArg id ) const;
    const wxString& GetPropertyLabel( wxPGPropArg id );
    wxString GetPropertyName( wxPGProperty* property );
    wxPGProperty* GetPropertyParent( wxPGPropArg id );
    wxColour GetPropertyTextColour( wxPGPropArg id ) const;
    wxValidator* GetPropertyValidator( wxPGPropArg id );
    wxVariant GetPropertyValue( wxPGPropArg id );
    wxArrayInt GetPropertyValueAsArrayInt( wxPGPropArg id ) const;
    wxArrayString GetPropertyValueAsArrayString( wxPGPropArg id ) const;
    bool GetPropertyValueAsBool( wxPGPropArg id ) const;
    wxDateTime GetPropertyValueAsDateTime( wxPGPropArg id ) const;
    double GetPropertyValueAsDouble( wxPGPropArg id ) const;
    int GetPropertyValueAsInt( wxPGPropArg id ) const;
    long GetPropertyValueAsLong( wxPGPropArg id ) const;
    wxLongLong GetPropertyValueAsLongLong( wxPGPropArg id ) const;
    wxString GetPropertyValueAsString( wxPGPropArg id ) const;
    unsigned long GetPropertyValueAsULong( wxPGPropArg id ) const;
    wxULongLong GetPropertyValueAsULongLong( wxPGPropArg id ) const;
    wxVariant GetPropertyValues( const wxString& listname = wxEmptyString,
                                 wxPGProperty* baseparent = NULL, long flags = 0 ) const;
    /* const wxArrayPGProperty& GetSelectedProperties() const; */
    wxPGProperty* GetSelection() const;
    /* virtual wxPGVIterator GetVIterator( int flags ) const; */
    bool HideProperty( wxPGPropArg id, bool hide = true, int flags = wxPG_RECURSE );
    static void InitAllTypeHandlers();
    wxPGProperty* Insert( wxPGPropArg priorThis, wxPGProperty* newProperty );
    wxPGProperty* Insert( wxPGPropArg parent, int index, wxPGProperty* newProperty );
    bool IsPropertyCategory( wxPGPropArg id ) const;
    bool IsPropertyEnabled( wxPGPropArg id ) const;
    bool IsPropertyExpanded( wxPGPropArg id ) const;
    bool IsPropertyModified( wxPGPropArg id ) const;
    bool IsPropertySelected( wxPGPropArg id ) const;
    bool IsPropertyShown( wxPGPropArg id ) const;
    bool IsPropertyValueUnspecified( wxPGPropArg id ) const;
    void LimitPropertyEditing( wxPGPropArg id, bool limit = true );
    /* virtual void RefreshGrid( wxPropertyGridPageState* state = NULL ); */
    static void RegisterAdditionalEditors();
    wxPGProperty* RemoveProperty( wxPGPropArg id );
    wxPGProperty* ReplaceProperty( wxPGPropArg id, wxPGProperty* property );

    bool RestoreEditableState( const wxString& src,
                               int restoreStates = wxPropertyGridInterface::EditableStateFlags::AllStates );
    wxString SaveEditableState( int includedStates = wxPropertyGridInterface::EditableStateFlags::AllStates ) const;
    static void SetBoolChoices( const wxString& trueChoice,
                                const wxString& falseChoice );
    bool SetColumnProportion( unsigned int column, int proportion );
    void SetPropertyAttribute( wxPGPropArg id, const wxString& attrName,
                               wxVariant value, long argFlags = 0 );
    void SetPropertyAttributeAll( const wxString& attrName, wxVariant value );
    void SetPropertyBackgroundColour( wxPGPropArg id,
                                      const wxColour& colour,
                                      int flags = wxPG_RECURSE );
    void SetPropertyCell( wxPGPropArg id,
                          int column,
                          const wxString& text = wxEmptyString,
                          const wxBitmap& bitmap = wxNullBitmap,
                          const wxColour& fgCol = wxNullColour,
                          const wxColour& bgCol = wxNullColour );
    void SetPropertyClientData( wxPGPropArg id, void* clientData );
    void SetPropertyColoursToDefault(wxPGPropArg id, int flags = wxPG_DONT_RECURSE);
    /* void SetPropertyEditor( wxPGPropArg id, const wxPGEditor* editor ); */
    void SetPropertyEditor( wxPGPropArg id, const wxString& editorName );
    void SetPropertyLabel( wxPGPropArg id, const wxString& newproplabel );
    void SetPropertyName( wxPGPropArg id, const wxString& newName );
    void SetPropertyReadOnly( wxPGPropArg id, bool set = true,
                              int flags = wxPG_RECURSE );
    void SetPropertyValueUnspecified( wxPGPropArg id );
    /* void SetPropertyValues( const wxVariantList& list, */
    /*                         wxPGPropArg defaultCategory = wxNullProperty ); */
    /* void SetPropertyValues( const wxVariant& list, */
    /*                         wxPGPropArg defaultCategory = wxNullProperty ); */
    void SetPropertyHelpString( wxPGPropArg id, const wxString& helpString );
    void SetPropertyImage( wxPGPropArg id, wxBitmap& bmp );
    bool SetPropertyMaxLength( wxPGPropArg id, int maxLen );

    void SetPropertyTextColour( wxPGPropArg id,
                                const wxColour& colour,
                                int flags = wxPG_RECURSE );
    void SetPropertyValidator( wxPGPropArg id, const wxValidator& validator );
    /* void SetPropertyValue( wxPGPropArg id, long value ); */
    /* void SetPropertyValue( wxPGPropArg id, int value ); */
    /* void SetPropertyValue( wxPGPropArg id, double value ); */
    /* void SetPropertyValue( wxPGPropArg id, bool value ); */
    /* void SetPropertyValue( wxPGPropArg id, const wchar_t* value ); */
    /* void SetPropertyValue( wxPGPropArg id, const char* value ); */
    /* void SetPropertyValue( wxPGPropArg id, const wxString& value ); */
    /* void SetPropertyValue( wxPGPropArg id, const wxArrayString& value ); */
    /* void SetPropertyValue( wxPGPropArg id, const wxDateTime& value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxObject* value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxObject& value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxLongLong_t value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxLongLong value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxULongLong_t value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxULongLong value ); */
    /* void SetPropertyValue( wxPGPropArg id, const wxArrayInt& value ); */
    void SetPropertyValueString( wxPGPropArg id, const wxString& value );
    void SetPropertyValue( wxPGPropArg id, wxVariant value );
    void SetPropVal( wxPGPropArg id, wxVariant& value );
    void SetValidationFailureBehavior( int vfbFlags );
    void Sort( int flags = 0 );
    void SortChildren( wxPGPropArg id, int flags = 0 );
    /* static wxPGEditor* GetEditorByName( const wxString& editorName ); */
    wxPGProperty* GetPropertyByNameA( const wxString& name ) const;
    virtual void RefreshProperty( wxPGProperty* p ) = 0;
};


#include "wx/propgrid/propgriddefs.h"


#include "wx/propgrid/property.h"

// struct wxPGPaintData
// {
//     const wxPropertyGrid* m_parent;
//     int m_choiceItem;
//     int m_drawnWidth;
//     int m_drawnHeight;
// };

#define wxPG_CUSTOM_IMAGE_SPACINGY
#define wxPG_CAPRECTXMARGIN
#define wxPG_CAPRECTYMARGIN

class %delete wxPGProperty : public wxObject
{
    virtual void OnSetValue();
    virtual wxVariant DoGetValue() const;
    /* virtual bool ValidateValue( wxVariant& value, wxPGValidationInfo& validationInfo ) const; */
    virtual bool StringToValue( wxVariant& variant, const wxString& text, int argFlags = 0 ) const;
    virtual bool IntToValue( wxVariant& variant, int number, int argFlags = 0 ) const;
    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    bool SetValueFromString( const wxString& text, int flags = wxPG_PROGRAMMATIC_VALUE );
    bool SetValueFromInt( long value, int flags = 0 );
    virtual wxSize OnMeasureImage( int item = -1 ) const;
    virtual bool OnEvent( wxPropertyGrid* propgrid, wxWindow* wnd_primary, wxEvent& event );
    virtual wxVariant ChildChanged( wxVariant& thisValue,
                                    int childIndex,
                                    wxVariant& childValue ) const;
    /* virtual const wxPGEditor* DoGetEditorClass() const; */
    virtual wxValidator* DoGetValidator () const;
    /* virtual void OnCustomPaint( wxDC& dc, const wxRect& rect, wxPGPaintData& paintdata ); */
    /* virtual wxPGCellRenderer* GetCellRenderer( int column ) const; */
    virtual int GetChoiceSelection() const;
    virtual void RefreshChildren();
    /* virtual bool DoSetAttribute( const wxString& name, wxVariant& value ); */
    /* virtual wxVariant DoGetAttribute( const wxString& name ) const; */
    /* virtual wxPGEditorDialogAdapter* GetEditorDialog() const; */
    /* virtual void OnValidationFailure( wxVariant& pendingValue ); */
    /* int AddChoice( const wxString& label, int value = wxPG_INVALID_VALUE ); */
    /* void AddChild( wxPGProperty* prop ); */
    /* void AddPrivateChild( wxPGProperty* prop ); */
    /* void AdaptListToValue( wxVariant& list, wxVariant* value ) const; */
    /* wxPGProperty* AppendChild( wxPGProperty* childProperty ); */
    /* bool AreAllChildrenSpecified( wxVariant* pendingList = NULL ) const; */
    /* bool AreChildrenComponents() const; */
    /* void ChangeFlag( wxPGPropertyFlags flag, bool set ); */
    /* void DeleteChildren(); */
    /* void DeleteChoice( int index ); */
    /* void Enable( bool enable = true ); */
    /* void EnableCommonValue( bool enable = true ); */
    /* wxString GenerateComposedValue() const; */
    /* const wxString& GetLabel() const; */
    /* wxVariant GetAttribute( const wxString& name ) const; */
    /* wxString GetAttribute( const wxString& name, const wxString& defVal ) const; */
    /* long GetAttributeAsLong( const wxString& name, long defVal ) const; */
    /* double GetAttributeAsDouble( const wxString& name, double defVal ) const; */
    /* const wxPGAttributeStorage& GetAttributes() const; */
    /* wxVariant GetAttributesAsList() const; */
    /* const wxPGEditor* GetColumnEditor( int column ) const; */
    /* const wxString& GetBaseName() const; */
    /* const wxPGCell& GetCell( unsigned int column ) const; */
    /* wxPGCell& GetCell( unsigned int column ); */
    /* wxPGCell& GetOrCreateCell( unsigned int column ); */
    /* unsigned int GetChildCount() const; */
    /* int GetChildrenHeight( int lh, int iMax = -1 ) const; */
    /* const wxPGChoices& GetChoices() const; */
    /* void* GetClientData() const; */
    /* wxClientData *GetClientObject() const; */
    /* wxVariant GetDefaultValue() const; */
    /* int GetCommonValue() const; */

    /* unsigned int GetDepth() const; */
    /* int GetDisplayedCommonValueCount() const; */
    /* wxString GetDisplayedString() const; */
    /* const wxPGEditor* GetEditorClass() const; */
    /* inline wxString GetHintText() const; */
    /* wxPropertyGrid* GetGrid() const; */
    /* wxPropertyGrid* GetGridIfDisplayed() const; */
    /* const wxString& GetHelpString() const; */
    /* wxString GetFlagsAsString( FlagType flagsMask ) const; */
    /* unsigned int GetIndexInParent() const; */
    /* const wxPGProperty* GetLastVisibleSubItem() const; */
    /* wxPGProperty* GetMainParent() const; */
    /* int GetMaxLength() const; */
    /* wxString GetName() const; */
    /* wxPGProperty* GetParent() const; */
    /* wxPGProperty* GetPropertyByName( const wxString& name ) const; */
    /* wxValidator* GetValidator() const; */
    /* wxVariant GetValue() const; */
    /* wxBitmap* GetValueImage() const; */
    /* virtual wxString GetValueAsString( int argFlags = 0 ) const; */
    /* wxString GetValueString( int argFlags = 0 ) const; */
    /* wxString GetValueType() const; */
    /* int GetY() const; */
    /* int GetImageOffset( int imageWidth ) const; */
    /* wxPGProperty* GetItemAtY( unsigned int y ) const; */
    /* bool HasFlag(wxPGPropertyFlags flag) const; */
    /* bool HasFlag(FlagType flag) const; */
    /* bool HasFlagsExact(FlagType flags) const; */
    /* bool HasVisibleChildren() const; */
    /* bool Hide( bool hide, int flags = wxPG_RECURSE ); */
    /* int Index( const wxPGProperty* p ) const; */
    /* wxPGProperty* InsertChild( int index, wxPGProperty* childProperty ); */
    /* int InsertChoice( const wxString& label, int index, int value = wxPG_INVALID_VALUE ); */
    bool IsCategory() const;
    bool IsEnabled() const;
    bool IsExpanded() const;
    bool IsRoot() const;
    bool IsSubProperty() const;

    bool IsSomeParent( wxPGProperty* candidateParent ) const;
    bool IsTextEditable() const;
    bool IsValueUnspecified() const;
    bool IsVisible() const;
    /* wxPGProperty* Item( unsigned int i ) const; */
    /* wxPGProperty* Last() const; */
    /* bool RecreateEditor(); */
    /* void RefreshEditor(); */
    /* void SetAttribute( const wxString& name, wxVariant value ); */

    /* void SetAttributes( const wxPGAttributeStorage& attributes ); */
    /* void SetAutoUnspecified( bool enable = true ); */
    /* void SetBackgroundColour( const wxColour& colour, */
    /*                           int flags = wxPG_RECURSE ); */
    /* void SetEditor( const wxPGEditor* editor ); */
    /* void SetEditor( const wxString& editorName ); */
    /* void SetCell( int column, const wxPGCell& cell ); */
    /* void SetCommonValue( int commonValue ); */
    /* bool SetChoices( wxPGChoices& choices ); */
    /* void SetClientData( void* clientData ); */
    /* void SetClientObject(wxClientData* clientObject); */
    /* void SetChoiceSelection( int newValue ); */
    /* void SetDefaultValue( wxVariant& value ); */

    /* void SetExpanded( bool expanded ); */
    /* void SetFlagsFromString( const wxString& str ); */
    /* void SetFlagRecursively( wxPGPropertyFlags flag, bool set ); */
    /* void SetHelpString( const wxString& helpString ); */
    /* void SetLabel( const wxString& label ); */
    /* bool SetMaxLength( int maxLen ); */
    /* void SetModifiedStatus( bool modified ); */
    /* void SetName( const wxString& newName ); */
    /* void SetParentalType( int flag ); */
    /* void SetTextColour( const wxColour& colour, */
    /*                     int flags = wxPG_RECURSE ); */
    /* void SetDefaultColours(int flags = wxPG_RECURSE); */
    /* void SetValidator( const wxValidator& validator ); */
    /* void SetValue( wxVariant value, wxVariant* pList = NULL, */
    /*                int flags = wxPG_SETVAL_REFRESH_EDITOR ); */
    /* void SetValueImage( wxBitmap& bmp ); */
    /* void SetValueInEvent( wxVariant value ) const; */
    /* void SetValueToUnspecified(); */
    /* void SetWasModified( bool set = true ); */
    /* wxPGProperty* UpdateParentValues(); */
    /* bool UsesAutoUnspecified() const; */
    /* void*                       m_clientData; */
};

#endif //wxLUA_USE_wxPropertyGrid && %wxchkver_2_9 && wxUSE_PROPGRID
