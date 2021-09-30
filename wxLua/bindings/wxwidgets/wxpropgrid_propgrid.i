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

enum wxPG_WINDOW_STYLES
{
    wxPG_AUTO_SORT,
    wxPG_HIDE_CATEGORIES,
    wxPG_ALPHABETIC_MODE,
    wxPG_BOLD_MODIFIED,
    wxPG_SPLITTER_AUTO_CENTER,
    wxPG_TOOLTIPS,
    wxPG_HIDE_MARGIN,
    wxPG_STATIC_SPLITTER,
    wxPG_STATIC_LAYOUT,
    wxPG_LIMITED_EDITING,
    wxPG_TOOLBAR,
    wxPG_DESCRIPTION,
    wxPG_NO_INTERNAL_BORDER,
    wxPG_WINDOW_STYLE_MASK
};

enum wxPG_EX_WINDOW_STYLES
{
    wxPG_EX_INIT_NOCAT,
    wxPG_EX_NO_FLAT_TOOLBAR,
    wxPG_EX_MODE_BUTTONS,
    wxPG_EX_HELP_AS_TOOLTIPS,
    wxPG_EX_NATIVE_DOUBLE_BUFFERING,
    wxPG_EX_AUTO_UNSPECIFIED_VALUES,
    wxPG_EX_WRITEONLY_BUILTIN_ATTRIBUTES,
    wxPG_EX_HIDE_PAGE_BUTTONS,
    wxPG_EX_MULTIPLE_SELECTION,
    wxPG_EX_ENABLE_TLP_TRACKING,
    wxPG_EX_NO_TOOLBAR_DIVIDER,
    wxPG_EX_TOOLBAR_SEPARATOR,
    wxPG_EX_ALWAYS_ALLOW_FOCUS,
    wxPG_EX_WINDOW_PG_STYLE_MASK,
    wxPG_EX_WINDOW_PGMAN_STYLE_MASK,
    wxPG_EX_WINDOW_STYLE_MASK
};


#define wxPG_DEFAULT_STYLE

#define wxPGMAN_DEFAULT_STYLE


enum wxPG_VALIDATION_FAILURE_BEHAVIOR_FLAGS
{
    wxPG_VFB_STAY_IN_PROPERTY,
    wxPG_VFB_BEEP,
    wxPG_VFB_MARK_CELL,
    wxPG_VFB_SHOW_MESSAGE,
    wxPG_VFB_SHOW_MESSAGEBOX,
    wxPG_VFB_SHOW_MESSAGE_ON_STATUSBAR,
    wxPG_VFB_DEFAULT
};


class wxPGValidationInfo
{
    unsigned char GetFailureBehavior();
    const wxString& GetFailureMessage() const;
    wxVariant& GetValue();
    void SetFailureBehavior(unsigned char failureBehavior);
    void SetFailureMessage(const wxString& message);
};


enum wxPG_KEYBOARD_ACTIONS
{
    wxPG_ACTION_INVALID = 0,
    wxPG_ACTION_NEXT_PROPERTY,
    wxPG_ACTION_PREV_PROPERTY,
    wxPG_ACTION_EXPAND_PROPERTY,
    wxPG_ACTION_COLLAPSE_PROPERTY,
    wxPG_ACTION_CANCEL_EDIT,
    wxPG_ACTION_EDIT,
    wxPG_ACTION_PRESS_BUTTON,
    wxPG_ACTION_MAX
};


class wxPropertyGrid : public wxScrolled<wxControl>, public wxPropertyGridInterface
{
    wxPropertyGrid();
    wxPropertyGrid( wxWindow *parent, wxWindowID id = wxID_ANY, const wxPoint& pos = wxDefaultPosition,
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
    const wxPGCell& GetUnspecifiedValueAppearance() const;
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

    static wxPGEditor* RegisterEditorClass( %ungc wxPGEditor* editor, bool noDefCheck = false );
    static wxPGEditor* DoRegisterEditorClass( %ungc wxPGEditor* editor, const wxString& name, bool noDefCheck = false );

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
    void SetUnspecifiedValueAppearance( const wxPGCell& cell );
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


class %delete wxPropertyGridPage : public wxEvtHandler, public wxPropertyGridInterface, public wxPropertyGridPageState
{
    wxPropertyGridPage();

    virtual void Clear();
    wxSize FitColumns();
    inline int GetIndex() const;
    wxPGProperty* GetRoot() const;
    int GetSplitterPosition( int col = 0 ) const;
    wxPropertyGridPageState* GetStatePtr();
    const wxPropertyGridPageState* GetStatePtr() const;
    int GetToolId() const;
    virtual void Init();
    virtual bool IsHandlingAllEvents() const;
    virtual void OnShow();
    virtual void RefreshProperty( wxPGProperty* p );
    void SetSplitterPosition( int splitterPos, int col = 0 );
};


class %delete wxPropertyGridManager : public wxPanel, public wxPropertyGridInterface
{
public:
    wxPropertyGridManager();

    %ungc wxPropertyGridManager( wxWindow *parent, wxWindowID id = wxID_ANY,
                                 const wxPoint& pos = wxDefaultPosition,
                                 const wxSize& size = wxDefaultSize,
                                 long style = wxPGMAN_DEFAULT_STYLE,
                                 const wxString& name = wxPropertyGridManagerNameStr );


    %ungc wxPropertyGridPage* AddPage( const wxString& label = wxEmptyString,
                                       const wxBitmap& bmp = wxPG_NULL_BITMAP,
                                       wxPropertyGridPage* pageObj = NULL );

    virtual void Clear();
    void ClearPage( int page );
    bool CommitChangesFromEditor( wxUint32 flags = 0 );
    %ungc bool Create( wxWindow *parent, wxWindowID id = wxID_ANY,
                       const wxPoint& pos = wxDefaultPosition,
                       const wxSize& size = wxDefaultSize,
                       long style = wxPGMAN_DEFAULT_STYLE,
                       const wxString& name = wxPropertyGridManagerNameStr );
    bool EnableCategories( bool enable );
    bool EnsureVisible( wxPGPropArg id );
    int GetColumnCount( int page = -1 ) const;
    int GetDescBoxHeight() const;
    wxPropertyGrid* GetGrid();
    /* virtual wxPGVIterator GetVIterator( int flags ) const; */
    wxPropertyGridPage* GetCurrentPage() const;
    wxPropertyGridPage* GetPage( unsigned int ind ) const;
    wxPropertyGridPage* GetPage( const wxString& name ) const;
    int GetPageByName( const wxString& name ) const;
    int GetPageByState( const wxPropertyGridPageState* pstate ) const;
    size_t GetPageCount() const;
    const wxString& GetPageName( int index ) const;
    wxPGProperty* GetPageRoot( int index ) const;
    int GetSelectedPage() const;
    wxPGProperty* GetSelectedProperty() const;
    wxPGProperty* GetSelection() const;
    wxToolBar* GetToolBar() const;
    virtual wxPropertyGridPage* InsertPage( int index, const wxString& label,
                                            const wxBitmap& bmp = wxNullBitmap,
                                            %ungc wxPropertyGridPage* pageObj = NULL );
    bool IsAnyModified() const;
    bool IsFrozen() const;
    bool IsPageModified( size_t index ) const;
    virtual bool IsPropertySelected( wxPGPropArg id ) const;
    virtual bool RemovePage( int page );
    void SelectPage( int index );
    void SelectPage( const wxString& label );
    void SelectPage( wxPropertyGridPage* page );
    bool SelectProperty( wxPGPropArg id, bool focus = false );
    void SetColumnCount( int colCount, int page = -1 );
    void SetColumnTitle( int idx, const wxString& title );
    void SetDescription( const wxString& label, const wxString& content );
    void SetDescBoxHeight( int ht, bool refresh = true );
    void SetSplitterLeft( bool subProps = false, bool allPages = true );
    void SetPageSplitterLeft(int page, bool subProps = false);
    void SetPageSplitterPosition( int page, int pos, int column = 0 );
    void SetSplitterPosition( int pos, int column = 0 );
    void ShowHeader(bool show = true);
};

#include "wx/propgrid/editors.h"

class %delete wxPGWindowList
{
public:
    wxPGWindowList(wxWindow* primary, wxWindow* secondary = NULL);

    void SetSecondary(wxWindow* secondary);

    wxWindow* GetPrimary() const;
    wxWindow* GetSecondary() const;
};


class %delete wxPGEditor : public wxObject
{
    wxPGEditor();

    virtual wxString GetName() const;
    virtual wxPGWindowList CreateControls(wxPropertyGrid* propgrid,
                                          wxPGProperty* property,
                                          const wxPoint& pos,
                                          const wxSize& size) const = 0;
    virtual void UpdateControl( wxPGProperty* property, wxWindow* ctrl ) const = 0;
    virtual void DrawValue( wxDC& dc, const wxRect& rect, wxPGProperty* property, const wxString& text ) const;
    virtual bool OnEvent( wxPropertyGrid* propgrid, wxPGProperty* property,
        wxWindow* wnd_primary, wxEvent& event ) const = 0;
    virtual bool GetValueFromControl( wxVariant& variant,
                                      wxPGProperty* property,
                                      wxWindow* ctrl ) const;
    virtual void SetControlAppearance( wxPropertyGrid* pg,
                                       wxPGProperty* property,
                                       wxWindow* ctrl,
                                       const wxPGCell& appearance,
                                       const wxPGCell& oldAppearance,
                                       bool unspecified ) const;
    virtual void SetValueToUnspecified( wxPGProperty* property, wxWindow* ctrl ) const;
    virtual void SetControlStringValue( wxPGProperty* property, wxWindow* ctrl, const wxString& txt ) const;
    virtual void SetControlIntValue( wxPGProperty* property, wxWindow* ctrl, int value ) const;
    virtual int InsertItem( wxWindow* ctrl, const wxString& label, int index ) const;
    virtual void DeleteItem( wxWindow* ctrl, int index ) const;
    virtual void SetItems(wxWindow* ctrl,  const wxArrayString& labels) const;
    virtual void OnFocus( wxPGProperty* property, wxWindow* wnd ) const;
    virtual bool CanContainCustomImage() const;

    /* void*               m_clientData; */
};

class %delete wxPGTextCtrlEditor : public wxPGEditor
{
    wxPGTextCtrlEditor();

    virtual wxPGWindowList CreateControls(wxPropertyGrid* propgrid,
                                          wxPGProperty* property,
                                          const wxPoint& pos,
                                          const wxSize& size) const;
    virtual void UpdateControl( wxPGProperty* property,
                                wxWindow* ctrl ) const;
    virtual bool OnEvent( wxPropertyGrid* propgrid,
                          wxPGProperty* property,
                          wxWindow* primaryCtrl,
                          wxEvent& event ) const;
    virtual bool GetValueFromControl( wxVariant& variant,
                                      wxPGProperty* property,
                                      wxWindow* ctrl ) const;

    virtual wxString GetName() const;

    //virtual wxPGCellRenderer* GetCellRenderer() const;
    virtual void SetControlStringValue( wxPGProperty* property,
                                        wxWindow* ctrl,
                                        const wxString& txt ) const;
    virtual void OnFocus( wxPGProperty* property, wxWindow* wnd ) const;

    static bool OnTextCtrlEvent( wxPropertyGrid* propgrid,
                                 wxPGProperty* property,
                                 wxWindow* ctrl,
                                 wxEvent& event );

    static bool GetTextCtrlValueFromControl( wxVariant& variant,
                                             wxPGProperty* property,
                                             wxWindow* ctrl );

};


class %delete wxPGChoiceEditor : public wxPGEditor
{
    wxPGChoiceEditor();

    virtual wxPGWindowList CreateControls(wxPropertyGrid* propgrid,
                                          wxPGProperty* property,
                                          const wxPoint& pos,
                                          const wxSize& size) const;
    virtual void UpdateControl( wxPGProperty* property,
                                wxWindow* ctrl ) const;
    virtual bool OnEvent( wxPropertyGrid* propgrid,
                          wxPGProperty* property,
                          wxWindow* primaryCtrl,
                          wxEvent& event ) const;
    virtual bool GetValueFromControl( wxVariant& variant,
                                      wxPGProperty* property,
                                      wxWindow* ctrl ) const;
    virtual void SetValueToUnspecified( wxPGProperty* property,
                                        wxWindow* ctrl ) const;
    virtual wxString GetName() const;

    virtual void SetControlIntValue( wxPGProperty* property,
                                     wxWindow* ctrl,
                                     int value ) const;
    virtual void SetControlStringValue( wxPGProperty* property,
                                        wxWindow* ctrl,
                                        const wxString& txt ) const;

    virtual int InsertItem( wxWindow* ctrl,
                            const wxString& label,
                            int index ) const;
    virtual void DeleteItem( wxWindow* ctrl, int index ) const;
    virtual void SetItems(wxWindow* ctrl, const wxArrayString& labels) const;

    virtual bool CanContainCustomImage() const;

    wxWindow* CreateControlsBase( wxPropertyGrid* propgrid,
                                  wxPGProperty* property,
                                  const wxPoint& pos,
                                  const wxSize& sz,
                                  long extraStyle ) const;

};


class %delete wxPGComboBoxEditor : public wxPGChoiceEditor
{
    wxPGComboBoxEditor();

    virtual wxPGWindowList CreateControls(wxPropertyGrid* propgrid,
                                          wxPGProperty* property,
                                          const wxPoint& pos,
                                          const wxSize& size) const;

    virtual wxString GetName() const;

    virtual void UpdateControl( wxPGProperty* property, wxWindow* ctrl ) const;

    virtual bool OnEvent( wxPropertyGrid* propgrid, wxPGProperty* property,
        wxWindow* ctrl, wxEvent& event ) const;

    virtual bool GetValueFromControl( wxVariant& variant,
                                      wxPGProperty* property,
                                      wxWindow* ctrl ) const;

    virtual void OnFocus( wxPGProperty* property, wxWindow* wnd ) const;

};


class %delete wxPGChoiceAndButtonEditor : public wxPGChoiceEditor
{
    wxPGChoiceAndButtonEditor();
    virtual wxString GetName() const;

    virtual wxPGWindowList CreateControls(wxPropertyGrid* propgrid,
                                          wxPGProperty* property,
                                          const wxPoint& pos,
                                          const wxSize& size) const;
};

class %delete wxPGTextCtrlAndButtonEditor : public wxPGTextCtrlEditor
{
    wxPGTextCtrlAndButtonEditor();
    virtual wxString GetName() const;

    virtual wxPGWindowList CreateControls(wxPropertyGrid* propgrid,
                                          wxPGProperty* property,
                                          const wxPoint& pos,
                                          const wxSize& size) const;
};


#if wxPG_INCLUDE_CHECKBOX

class %delete wxPGCheckBoxEditor : public wxPGEditor
{
    wxPGCheckBoxEditor();

    virtual wxString GetName() const;
    virtual wxPGWindowList CreateControls(wxPropertyGrid* propgrid,
                                          wxPGProperty* property,
                                          const wxPoint& pos,
                                          const wxSize& size) const;
    virtual void UpdateControl( wxPGProperty* property,
                                wxWindow* ctrl ) const;
    virtual bool OnEvent( wxPropertyGrid* propgrid,
                          wxPGProperty* property,
                          wxWindow* primaryCtrl,
                          wxEvent& event ) const;
    virtual bool GetValueFromControl( wxVariant& variant,
                                      wxPGProperty* property,
                                      wxWindow* ctrl ) const;
    virtual void SetValueToUnspecified( wxPGProperty* property,
                                        wxWindow* ctrl ) const;

    virtual void DrawValue( wxDC& dc,
                            const wxRect& rect,
                            wxPGProperty* property,
                            const wxString& text ) const;
    //virtual wxPGCellRenderer* GetCellRenderer() const;

    virtual void SetControlIntValue( wxPGProperty* property,
                                     wxWindow* ctrl,
                                     int value ) const;
};

#endif


class %delete wxPGEditorDialogAdapter : public wxObject
{
    wxPGEditorDialogAdapter();

    bool ShowDialog( wxPropertyGrid* propGrid, wxPGProperty* property );

    virtual bool DoShowDialog( wxPropertyGrid* propGrid,
                               wxPGProperty* property ) = 0;

    void SetValue( const wxVariant& value );

    wxVariant& GetValue();
    /* void*               m_clientData; */

};


class %delete wxPGMultiButton : public wxWindow
{
    wxPGMultiButton( wxPropertyGrid* pg, const wxSize& sz );

    wxWindow* GetButton( unsigned int i );
    const wxWindow* GetButton( unsigned int i ) const;

    int GetButtonId( unsigned int i ) const;

    unsigned int GetCount() const;

    void Add( const wxString& label, int id = -2 );
#if wxUSE_BMPBUTTON
    void Add( const wxBitmap& bitmap, int id = -2 );
#endif

    wxSize GetPrimarySize() const;

    void Finalize( wxPropertyGrid* propGrid, const wxPoint& pos );
};


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


enum wxPGNumericValidationConstants
{
    wxPG_PROPERTY_VALIDATION_ERROR_MESSAGE,
    wxPG_PROPERTY_VALIDATION_SATURATE,
    wxPG_PROPERTY_VALIDATION_WRAP
};


enum wxNumericPropertyValidator::NumericType
{
    Signed,
    Unsigned,
    Float
};

class wxNumericPropertyValidator : public wxTextValidator
{
    wxNumericPropertyValidator( wxNumericPropertyValidator::NumericType numericType, int base = 10 );
    virtual bool Validate(wxWindow* parent);
};


class wxNumericProperty : public wxPGProperty
{
    virtual bool DoSetAttribute(const wxString& name, wxVariant& value);
    virtual wxVariant AddSpinStepValue(long stepScale) const;
    bool UseSpinMotion() const;
};

class wxIntProperty : public wxNumericProperty
{
    wxIntProperty( const wxString& label = wxPG_LABEL,
                   const wxString& name = wxPG_LABEL,
                   long value = 0 );

    wxIntProperty( const wxString& label,
                   const wxString& name,
                   const wxLongLong& value );
    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int argFlags = 0 ) const;
    virtual bool ValidateValue( wxVariant& value,
                                wxPGValidationInfo& validationInfo ) const;
    virtual bool IntToValue( wxVariant& variant,
                             int number,
                             int argFlags = 0 ) const;
    static wxValidator* GetClassValidator();
    virtual wxValidator* DoGetValidator() const;
    virtual wxVariant AddSpinStepValue(long stepScale) const;
};


class wxUIntProperty : public wxNumericProperty
{
    wxUIntProperty( const wxString& label = wxPG_LABEL,
                    const wxString& name = wxPG_LABEL,
                    unsigned long value = 0 );
    wxUIntProperty( const wxString& label,
                    const wxString& name,
                    const wxULongLong& value );
    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int argFlags = 0 ) const;
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );
    virtual bool ValidateValue( wxVariant& value,
                                wxPGValidationInfo& validationInfo ) const;
    virtual wxValidator* DoGetValidator () const;
    virtual bool IntToValue( wxVariant& variant,
                             int number,
                             int argFlags = 0 ) const;
    virtual wxVariant AddSpinStepValue(long stepScale) const;
};



class wxFloatProperty : public wxNumericProperty
{
    wxFloatProperty( const wxString& label = wxPG_LABEL,
                     const wxString& name = wxPG_LABEL,
                     double value = 0.0 );

    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int argFlags = 0 ) const;
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );
    virtual bool ValidateValue( wxVariant& value,
                                wxPGValidationInfo& validationInfo ) const;

    static wxValidator* GetClassValidator();
    virtual wxValidator* DoGetValidator () const;
    virtual wxVariant AddSpinStepValue(long stepScale) const;
};


class wxBoolProperty : public wxPGProperty
{
    wxBoolProperty( const wxString& label = wxPG_LABEL,
                    const wxString& name = wxPG_LABEL,
                    bool value = false );

    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int argFlags = 0 ) const;
    virtual bool IntToValue( wxVariant& variant,
                             int number, int argFlags = 0 ) const;
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );
};


#define wxPG_PROP_STATIC_CHOICES


class wxEnumProperty : public wxPGProperty
{
    /* wxEnumProperty( const wxString& label = wxPG_LABEL, */
    /*                 const wxString& name = wxPG_LABEL, */
    /*                 const wxChar* const* labels = NULL, */
    /*                 const long* values = NULL, */
    /*                 int value = 0 ); */

    wxEnumProperty( const wxString& label,
                    const wxString& name,
                    wxPGChoices& choices,
                    int value = 0 );

    /* wxEnumProperty( const wxString& label, */
    /*                 const wxString& name, */
    /*                 const wxChar* const* labels, */
    /*                 const long* values, */
    /*                 wxPGChoices* choicesCache, */
    /*                 int value = 0 ); */

    wxEnumProperty( const wxString& label,
                    const wxString& name,
                    const wxArrayString& labels,
                    const wxArrayInt& values = wxLuaSmartwxArrayInt(),
                    int value = 0 );

    size_t GetItemCount() const;

    virtual void OnSetValue();
    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int argFlags = 0 ) const;
    virtual bool ValidateValue( wxVariant& value,
                                wxPGValidationInfo& validationInfo ) const;

    virtual bool IntToValue( wxVariant& variant,
                             int number,
                             int argFlags = 0 ) const;

    virtual int GetIndexForValue( int value ) const;

    virtual int GetChoiceSelection() const;
};


class wxEditEnumProperty : public wxEnumProperty
{
    /* wxEditEnumProperty( const wxString& label, */
    /*                     const wxString& name, */
    /*                     const wxChar* const* labels, */
    /*                     const long* values, */
    /*                     const wxString& value ); */

    wxEditEnumProperty( const wxString& label = wxPG_LABEL,
                        const wxString& name = wxPG_LABEL,
                        const wxArrayString& labels = wxLuaNullSmartwxArrayString,
                        const wxArrayInt& values = wxLuaSmartwxArrayInt(),
                        const wxString& value = wxEmptyString );

    wxEditEnumProperty( const wxString& label,
                        const wxString& name,
                        wxPGChoices& choices,
                        const wxString& value = wxEmptyString );

    /* wxEditEnumProperty( const wxString& label, */
    /*                     const wxString& name, */
    /*                     const wxChar* const* labels, */
    /*                     const long* values, */
    /*                     wxPGChoices* choicesCache, */
    /*                     const wxString& value ); */

};


class wxFlagsProperty : public wxPGProperty
{
    /* wxFlagsProperty( const wxString& label, */
    /*                  const wxString& name, */
    /*                  const wxChar* const* labels, */
    /*                  const long* values = NULL, */
    /*                  long value = 0 ); */

    wxFlagsProperty( const wxString& label,
                     const wxString& name,
                     wxPGChoices& choices,
                     long value = 0 );

    wxFlagsProperty( const wxString& label = wxPG_LABEL,
                     const wxString& name = wxPG_LABEL,
                     const wxArrayString& labels = wxLuaNullSmartwxArrayString,
                     const wxArrayInt& values = wxLuaSmartwxArrayInt(),
                     int value = 0 );

    virtual void OnSetValue();
    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int flags ) const;
    virtual wxVariant ChildChanged( wxVariant& thisValue,
                                    int childIndex,
                                    wxVariant& childValue ) const;
    virtual void RefreshChildren();
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );

    virtual int GetChoiceSelection() const;

    // helpers
    size_t GetItemCount() const;
    const wxString& GetLabel( size_t ind ) const;
};


class wxEditorDialogProperty : public wxPGProperty
{
    virtual wxPGEditorDialogAdapter* GetEditorDialog() const;
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );
};


#define wxPG_PROP_SHOW_FULL_FILENAME


class wxFileProperty : public wxEditorDialogProperty
{
    wxFileProperty( const wxString& label = wxPG_LABEL,
                    const wxString& name = wxPG_LABEL,
                    const wxString& value = wxEmptyString );

    virtual void OnSetValue();
    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int argFlags = 0 ) const;
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );

    static wxValidator* GetClassValidator();
    virtual wxValidator* DoGetValidator() const;

    wxFileName GetFileName() const;
};


#define wxPG_PROP_ACTIVE_BTN

class wxLongStringProperty : public wxEditorDialogProperty
{
    wxLongStringProperty( const wxString& label = wxPG_LABEL,
                          const wxString& name = wxPG_LABEL,
                          const wxString& value = wxEmptyString );

    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int argFlags = 0 ) const;
};


class wxDirProperty : public wxEditorDialogProperty
{
    wxDirProperty( const wxString& label = wxPG_LABEL,
                   const wxString& name = wxPG_LABEL,
                   const wxString& value = wxEmptyString );

    virtual wxString ValueToString(wxVariant& value, int argFlags = 0) const;
    virtual bool StringToValue(wxVariant& variant, const wxString& text,
                               int argFlags = 0) const;
    virtual wxValidator* DoGetValidator() const;
};


#define wxPG_PROP_USE_CHECKBOX
#define wxPG_PROP_USE_DCC    


enum wxArrayStringProperty::ConversionFlags
{
    Escape          = 0x01,
    QuoteStrings    = 0x02
};

class wxArrayStringProperty : public wxEditorDialogProperty
{
    wxArrayStringProperty( const wxString& label = wxPG_LABEL,
                           const wxString& name = wxPG_LABEL,
                           const wxArrayString& value = wxLuaNullSmartwxArrayString );

    virtual void OnSetValue();
    virtual wxString ValueToString( wxVariant& value, int argFlags = 0 ) const;
    virtual bool StringToValue( wxVariant& variant,
                                const wxString& text,
                                int argFlags = 0 ) const;
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );

    virtual void ConvertArrayToString(const wxArrayString& arr,
                                      wxString* pString,
                                      const wxUniChar& delimiter) const;

    virtual bool OnCustomStringEdit( wxWindow* parent, wxString& value );

    virtual wxPGArrayEditorDialog* CreateEditorDialog();

    static void ArrayStringToString( wxString& dst, const wxArrayString& src,
                                     wxUniChar delimiter, int flags );
};


#define wxAEDIALOG_STYLE

class wxPGArrayEditorDialog : public wxDialog
{
    // abstract class
    /* wxPGArrayEditorDialog(); */

    void Init();

    bool Create( wxWindow *parent,
                 const wxString& message,
                 const wxString& caption,
                 long style = wxAEDIALOG_STYLE,
                 const wxPoint& pos = wxDefaultPosition,
                 const wxSize& sz = wxDefaultSize );

    void EnableCustomNewAction();
    void SetNewButtonText(const wxString& text);
    virtual void SetDialogValue( const wxVariant& value );
    virtual wxVariant GetDialogValue() const;
    virtual wxValidator* GetTextCtrlValidator() const;
    bool IsModified() const;
    int GetSelection() const;
};


class wxPGArrayStringEditorDialog : public wxPGArrayEditorDialog
{
    wxPGArrayStringEditorDialog();

    void Init();

    virtual void SetDialogValue( const wxVariant& value );
    virtual wxVariant GetDialogValue() const;

    void SetCustomButton( const wxString& custBtText,
                          wxArrayStringProperty* pcc );

    virtual bool OnCustomNewAction(wxString* resString);
};



#include "wx/propgrid/propgridpagestate.h"


class %delete wxPropertyGridHitTestResult
{
    wxPropertyGridHitTestResult();

    int GetColumn() const;
    wxPGProperty* GetProperty() const;
    int GetSplitter() const;
    int GetSplitterHitOffset() const;
};


enum wxPG_ITERATOR_FLAGS
{
    wxPG_ITERATE_PROPERTIES,
    wxPG_ITERATE_HIDDEN,
    wxPG_ITERATE_FIXED_CHILDREN,
    wxPG_ITERATE_CATEGORIES,
    wxPG_ITERATE_ALL_PARENTS,
    wxPG_ITERATE_ALL_PARENTS_RECURSIVELY,
    wxPG_ITERATOR_FLAGS_ALL,
    wxPG_ITERATOR_MASK_OP_ITEM,

    wxPG_ITERATOR_MASK_OP_PARENT,
    wxPG_ITERATE_VISIBLE,
    wxPG_ITERATE_ALL,
    wxPG_ITERATE_NORMAL,
    wxPG_ITERATE_DEFAULT
};


class %delete wxPropertyGridIteratorBase
{
    wxPropertyGridIteratorBase();

    void Assign( const wxPropertyGridIteratorBase& it );

    bool AtEnd() const;

    wxPGProperty* GetProperty() const;

    void Init( wxPropertyGridPageState* state,
               int flags,
               wxPGProperty* property,
               int dir = 1 );

    void Init( wxPropertyGridPageState* state,
               int flags,
               int startPos = wxTOP,
               int dir = 0 );

    void Next( bool iterateChildren = true );

    void Prev();

    void SetBaseParent( wxPGProperty* baseParent );
};


class %delete wxPropertyGridConstIterator : public wxPropertyGridIteratorBase
{
    /* wxPropertyGridConstIterator( const wxPropertyGridIterator& other ); */

    /* const wxPropertyGridConstIterator& operator=( const wxPropertyGridIterator& it ); */

    wxPropertyGridConstIterator();
    wxPropertyGridConstIterator( const wxPropertyGridPageState* state,
                                 int flags = wxPG_ITERATE_DEFAULT,
                                 const wxPGProperty* property = NULL, int dir = 1 );
    wxPropertyGridConstIterator( wxPropertyGridPageState* state,
                                 int flags, int startPos, int dir = 0 );
    wxPropertyGridConstIterator( const wxPropertyGridConstIterator& it );
};


class %delete wxPGVIteratorBase : public wxObjectRefData
{
    wxPGVIteratorBase();
    virtual void Next() = 0;
};


class %delete wxPGVIterator
{
    wxPGVIterator();
    wxPGVIterator( wxPGVIteratorBase* obj );
    void UnRef();
    wxPGVIterator( const wxPGVIterator& it );
    const wxPGVIterator& operator=( const wxPGVIterator& it );
    void Next();
    bool AtEnd() const;
    wxPGProperty* GetProperty() const;
};


class %delete wxPropertyGridPageState
{
    wxPropertyGridPageState();
    virtual ~wxPropertyGridPageState();
    void CheckColumnWidths( int widthChange = 0 );
    virtual void DoDelete( wxPGProperty* item, bool doDelete = true );
    wxSize DoFitColumns( bool allowGridResize = false );
    wxPGProperty* DoGetItemAtY( int y ) const;
    virtual wxPGProperty* DoInsert( wxPGProperty* parent,
                                    int index,
                                    wxPGProperty* property );
    virtual void DoSetSplitterPosition( int pos,
                                        int splitterColumn = 0,
                                        int flags = 0 );

    bool EnableCategories( bool enable );
    void EnsureVirtualHeight();
    unsigned int GetVirtualHeight() const;
    unsigned int GetVirtualHeight();
    inline unsigned int GetActualVirtualHeight() const;
    unsigned int GetColumnCount() const;
    int GetColumnMinWidth( int column ) const;
    int GetColumnWidth( unsigned int column ) const;
    wxPropertyGrid* GetGrid() const;
    wxPGProperty* GetLastItem( int flags = wxPG_ITERATE_DEFAULT );
    const wxPGProperty* GetLastItem( int flags = wxPG_ITERATE_DEFAULT ) const;
    wxPGProperty* GetSelection() const;
    void DoSetSelection( wxPGProperty* prop );
    bool DoClearSelection();
    void DoRemoveFromSelection( wxPGProperty* prop );
    void DoSetColumnProportion( unsigned int column, int proportion );
    int DoGetColumnProportion( unsigned int column ) const;
    void ResetColumnSizes( int setSplitterFlags );
    wxPropertyCategory* GetPropertyCategory( const wxPGProperty* p ) const;
    wxVariant DoGetPropertyValues( const wxString& listname,
                                   wxPGProperty* baseparent,
                                   long flags ) const;
    wxPGProperty* DoGetRoot() const;
    void DoSetPropertyName( wxPGProperty* p, const wxString& newName );
    int GetVirtualWidth() const;
    int GetColumnFitWidth(wxClientDC& dc,
                          wxPGProperty* pwc,
                          unsigned int col,
                          bool subProps) const;
    int GetColumnFullWidth(wxClientDC &dc, wxPGProperty *p, unsigned int col);
    wxPropertyGridHitTestResult HitTest( const wxPoint& pt ) const;
    inline bool IsDisplayed() const;
    bool IsInNonCatMode() const;
    void DoLimitPropertyEditing( wxPGProperty* p, bool limit = true );
    bool DoSelectProperty( wxPGProperty* p, unsigned int flags = 0 );
    void OnClientWidthChange( int newWidth,
                              int widthChange,
                              bool fromOnResize = false );
    void RecalculateVirtualHeight();
    void SetColumnCount( int colCount );
    void PropagateColSizeDec( int column, int decrease, int dir );
    bool DoHideProperty( wxPGProperty* p, bool hide, int flags = wxPG_RECURSE );
    bool DoSetPropertyValueString( wxPGProperty* p, const wxString& value );
    bool DoSetPropertyValue( wxPGProperty* p, wxVariant& value );
    bool DoSetPropertyValueWxObjectPtr( wxPGProperty* p, wxObject* value );
    /* void DoSetPropertyValues( const wxVariantList& list, */
    /*                           wxPGProperty* default_category ); */
    void SetSplitterLeft( bool subProps = false );
    void SetVirtualWidth( int width );
    void DoSortChildren( wxPGProperty* p, int flags = 0 );
    void DoSort( int flags = 0 );
    bool PrepareAfterItemsAdded();
    void VirtualHeightChanged();
    wxPGProperty* DoAppend( wxPGProperty* property );
    wxPGProperty* BaseGetPropertyByName( const wxString& name ) const;
    void DoClear();
    bool DoIsPropertySelected( wxPGProperty* prop ) const;
    bool DoCollapse( wxPGProperty* p );
    bool DoExpand( wxPGProperty* p );
    void CalculateFontAndBitmapStuff( int vspacing );
};


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

#define wxPG_INVALID_VALUE


enum wxPG_GETPROPERTYVALUES_FLAGS
{
    wxPG_DONT_RECURSE,
    wxPG_KEEP_STRUCTURE,
    wxPG_RECURSE,
    wxPG_INC_ATTRIBUTES,
    wxPG_RECURSE_STARTS,
    wxPG_FORCE,
    wxPG_SORT_TOP_LEVEL_ONLY
};


enum wxPG_MISC_ARG_FLAGS
{
    wxPG_FULL_VALUE,
    wxPG_REPORT_ERROR,
    wxPG_PROPERTY_SPECIFIC,
    wxPG_EDITABLE_VALUE,
    wxPG_COMPOSITE_FRAGMENT,
    wxPG_UNEDITABLE_COMPOSITE_FRAGMENT,
    wxPG_VALUE_IS_CURRENT,
    wxPG_PROGRAMMATIC_VALUE
};


enum wxPG_SETVALUE_FLAGS
{
    wxPG_SETVAL_REFRESH_EDITOR,
    wxPG_SETVAL_AGGREGATED,
    wxPG_SETVAL_FROM_PARENT,
    wxPG_SETVAL_BY_USER
};

#define wxPG_BASE_OCT
#define wxPG_BASE_DEC
#define wxPG_BASE_HEX
#define wxPG_BASE_HEXL

#define wxPG_PREFIX_NONE
#define wxPG_PREFIX_0x
#define wxPG_PREFIX_DOLLAR_SIGN


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

class wxPropertyGridInterface
{
    %ungc wxPGProperty* Append( %ungc wxPGProperty* property );
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
    const wxPGAttributeStorage& GetPropertyAttributes( wxPGPropArg id ) const;
    wxColour GetPropertyBackgroundColour( wxPGPropArg id ) const;
    wxPropertyCategory* GetPropertyCategory( wxPGPropArg id ) const;
    void* GetPropertyClientData( wxPGPropArg id ) const;
    wxPGProperty* GetPropertyByLabel( const wxString& label ) const;
    wxPGProperty* GetPropertyByName( const wxString& name ) const;
    wxPGProperty* GetPropertyByName( const wxString& name,
                                     const wxString& subname ) const;
    const wxPGEditor* GetPropertyEditor( wxPGPropArg id ) const;
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
    virtual void RefreshGrid( wxPropertyGridPageState* state = NULL );
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
    void SetPropertyEditor( wxPGPropArg id, const wxPGEditor* editor );
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
    void SetPropertyValue( wxPGPropArg id, long value );
    void SetPropertyValue( wxPGPropArg id, int value );
    void SetPropertyValue( wxPGPropArg id, double value );
    void SetPropertyValue( wxPGPropArg id, bool value );
    /* void SetPropertyValue( wxPGPropArg id, const wchar_t* value ); */
    /* void SetPropertyValue( wxPGPropArg id, const char* value ); */
    void SetPropertyValue( wxPGPropArg id, const wxString& value );
    void SetPropertyValue( wxPGPropArg id, const wxArrayString& value );
    void SetPropertyValue( wxPGPropArg id, const wxDateTime& value );
    /* void SetPropertyValue( wxPGPropArg id, wxObject* value ); */
    void SetPropertyValue( wxPGPropArg id, wxObject& value );
    /* void SetPropertyValue( wxPGPropArg id, wxLongLong_t value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxLongLong value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxULongLong_t value ); */
    /* void SetPropertyValue( wxPGPropArg id, wxULongLong value ); */
    void SetPropertyValue( wxPGPropArg id, const wxArrayInt& value );
    void SetPropertyValueString( wxPGPropArg id, const wxString& value );
    void SetPropertyValue( wxPGPropArg id, wxVariant value );
    void SetPropVal( wxPGPropArg id, wxVariant& value );
    void SetValidationFailureBehavior( int vfbFlags );
    void Sort( int flags = 0 );
    void SortChildren( wxPGPropArg id, int flags = 0 );
    static wxPGEditor* GetEditorByName( const wxString& editorName );
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


enum wxPGPropertyFlags
{
    wxPG_PROP_MODIFIED,
    wxPG_PROP_DISABLED,
    wxPG_PROP_HIDDEN,
    wxPG_PROP_CUSTOMIMAGE,
    wxPG_PROP_NOEDITOR,
    wxPG_PROP_COLLAPSED,
    wxPG_PROP_INVALID_VALUE,
    wxPG_PROP_WAS_MODIFIED,
    wxPG_PROP_AGGREGATE,
    wxPG_PROP_CHILDREN_ARE_COPIES,
    wxPG_PROP_PROPERTY,
    wxPG_PROP_CATEGORY,
    wxPG_PROP_MISC_PARENT,
    wxPG_PROP_READONLY,
    wxPG_PROP_COMPOSED_VALUE,
    wxPG_PROP_USES_COMMON_VALUE,
    wxPG_PROP_AUTO_UNSPECIFIED,
    wxPG_PROP_CLASS_SPECIFIC_1,
    wxPG_PROP_CLASS_SPECIFIC_2,
    wxPG_PROP_BEING_DELETED,
    wxPG_PROP_CLASS_SPECIFIC_3
};


#define wxPG_PROP_MAX

#define wxPG_PROP_PARENTAL_FLAGS

#define wxPG_STRING_STORED_FLAGS 


class %delete wxPGProperty : public wxObject
{
    virtual void OnSetValue();
    virtual wxVariant DoGetValue() const;
    virtual bool ValidateValue( wxVariant& value, wxPGValidationInfo& validationInfo ) const;
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
    virtual const wxPGEditor* DoGetEditorClass() const;
    virtual wxValidator* DoGetValidator () const;
    /* virtual void OnCustomPaint( wxDC& dc, const wxRect& rect, wxPGPaintData& paintdata ); */
    virtual wxPGCellRenderer* GetCellRenderer( int column ) const;
    virtual int GetChoiceSelection() const;
    virtual void RefreshChildren();
    virtual bool DoSetAttribute( const wxString& name, wxVariant& value );
    virtual wxVariant DoGetAttribute( const wxString& name ) const;
    virtual wxPGEditorDialogAdapter* GetEditorDialog() const;
    virtual void OnValidationFailure( wxVariant& pendingValue );
    int AddChoice( const wxString& label, int value = wxPG_INVALID_VALUE );
    %wxcompat_1_4 void AddChild( wxPGProperty* prop );
    void AddPrivateChild( wxPGProperty* prop );
    void AdaptListToValue( wxVariant& list, wxVariant* value ) const;
    wxPGProperty* AppendChild( wxPGProperty* childProperty );
    bool AreAllChildrenSpecified( wxVariant* pendingList = NULL ) const;
    bool AreChildrenComponents() const;
    void ChangeFlag( wxPGPropertyFlags flag, bool set );
    void DeleteChildren();
    void DeleteChoice( int index );
    void Enable( bool enable = true );
    void EnableCommonValue( bool enable = true );
    wxString GenerateComposedValue() const;
    const wxString& GetLabel() const;
    wxVariant GetAttribute( const wxString& name ) const;
    wxString GetAttribute( const wxString& name, const wxString& defVal ) const;
    long GetAttributeAsLong( const wxString& name, long defVal ) const;
    double GetAttributeAsDouble( const wxString& name, double defVal ) const;
    const wxPGAttributeStorage& GetAttributes() const;
    wxVariant GetAttributesAsList() const;
    const wxPGEditor* GetColumnEditor( int column ) const;
    const wxString& GetBaseName() const;
    const wxPGCell& GetCell( unsigned int column ) const;
    wxPGCell& GetCell( unsigned int column );
    wxPGCell& GetOrCreateCell( unsigned int column );
    unsigned int GetChildCount() const;
    int GetChildrenHeight( int lh, int iMax = -1 ) const;
    const wxPGChoices& GetChoices() const;
    void* GetClientData() const;
    wxClientData *GetClientObject() const;
    wxVariant GetDefaultValue() const;
    int GetCommonValue() const;

    unsigned int GetDepth() const;
    int GetDisplayedCommonValueCount() const;
    wxString GetDisplayedString() const;
    const wxPGEditor* GetEditorClass() const;
    inline wxString GetHintText() const;
    wxPropertyGrid* GetGrid() const;
    wxPropertyGrid* GetGridIfDisplayed() const;
    const wxString& GetHelpString() const;
    wxString GetFlagsAsString( wxUint32 flagsMask ) const;
    unsigned int GetIndexInParent() const;
    const wxPGProperty* GetLastVisibleSubItem() const;
    wxPGProperty* GetMainParent() const;
    int GetMaxLength() const;
    wxString GetName() const;
    wxPGProperty* GetParent() const;
    wxPGProperty* GetPropertyByName( const wxString& name ) const;
    wxValidator* GetValidator() const;
    wxVariant GetValue() const;
    wxBitmap* GetValueImage() const;
    virtual wxString GetValueAsString( int argFlags = 0 ) const;
    %wxcompat_1_4 wxString GetValueString( int argFlags = 0 ) const;
    wxString GetValueType() const;
    int GetY() const;
    int GetImageOffset( int imageWidth ) const;
    wxPGProperty* GetItemAtY( unsigned int y ) const;
    bool HasFlag(wxPGPropertyFlags flag) const;
    bool HasFlag(wxUint32 flag) const;
    bool HasFlagsExact(wxUint32 flags) const;
    bool HasVisibleChildren() const;
    bool Hide( bool hide, int flags = wxPG_RECURSE );
    int Index( const wxPGProperty* p ) const;
    wxPGProperty* InsertChild( int index, wxPGProperty* childProperty );
    int InsertChoice( const wxString& label, int index, int value = wxPG_INVALID_VALUE );
    bool IsCategory() const;
    bool IsEnabled() const;
    bool IsExpanded() const;
    bool IsRoot() const;
    bool IsSubProperty() const;

    bool IsSomeParent( wxPGProperty* candidateParent ) const;
    bool IsTextEditable() const;
    bool IsValueUnspecified() const;
    bool IsVisible() const;
    wxPGProperty* Item( unsigned int i ) const;
    wxPGProperty* Last() const;
    bool RecreateEditor();
    void RefreshEditor();
    void SetAttribute( const wxString& name, wxVariant value );

    void SetAttributes( const wxPGAttributeStorage& attributes );
    void SetAutoUnspecified( bool enable = true );
    void SetBackgroundColour( const wxColour& colour,
                              int flags = wxPG_RECURSE );
    void SetEditor( const wxPGEditor* editor );
    void SetEditor( const wxString& editorName );
    void SetCell( int column, const wxPGCell& cell );
    void SetCommonValue( int commonValue );
    bool SetChoices( wxPGChoices& choices );
    void SetClientData( void* clientData );
    void SetClientObject(wxClientData* clientObject);
    void SetChoiceSelection( int newValue );
    void SetDefaultValue( wxVariant& value );

    void SetExpanded( bool expanded );
    void SetFlagsFromString( const wxString& str );
    void SetFlagRecursively( wxPGPropertyFlags flag, bool set );
    void SetHelpString( const wxString& helpString );
    void SetLabel( const wxString& label );
    bool SetMaxLength( int maxLen );
    void SetModifiedStatus( bool modified );
    void SetName( const wxString& newName );
    void SetParentalType( int flag );
    void SetTextColour( const wxColour& colour,
                        int flags = wxPG_RECURSE );
    void SetDefaultColours(int flags = wxPG_RECURSE);
    void SetValidator( const wxValidator& validator );
    void SetValue( wxVariant value, wxVariant* pList = NULL,
                   int flags = wxPG_SETVAL_REFRESH_EDITOR );
    void SetValueImage( wxBitmap& bmp );
    void SetValueInEvent( wxVariant value ) const;
    void SetValueToUnspecified();
    void SetWasModified( bool set = true );
    wxPGProperty* UpdateParentValues();
    bool UsesAutoUnspecified() const;
    /* void*                       m_clientData; */
};

enum wxPGCellRenderer::Flags
{
    Selected,
    ChoicePopup,
    Control,
    Disabled,
    DontUseCellFgCol,
    DontUseCellBgCol,
    DontUseCellColours
};

class %delete wxPGCellRenderer : public wxObjectRefData
{
    wxPGCellRenderer();

    virtual bool Render( wxDC& dc,
                         const wxRect& rect,
                         const wxPropertyGrid* propertyGrid,
                         wxPGProperty* property,
                         int column,
                         int item,
                         int flags ) const = 0;

    virtual wxSize GetImageSize( const wxPGProperty* property,
                                 int column,
                                 int item ) const;
    virtual void DrawCaptionSelectionRect(wxDC& dc,
                                          int x, int y, int w, int h) const;
    void DrawText( wxDC& dc,
                   const wxRect& rect,
                   int imageWidth,
                   const wxString& text ) const;
    /* void DrawEditorValue( wxDC& dc, const wxRect& rect, */
    /*                       int xOffset, const wxString& text, */
    /*                       wxPGProperty* property, */
    /*                       const wxPGEditor* editor ) const; */
    int PreDrawCell( wxDC& dc,
                     const wxRect& rect,
                     const wxPGCell& cell,
                     int flags ) const;
    void PostDrawCell( wxDC& dc,
                       const wxPropertyGrid* propGrid,
                       const wxPGCell& cell,
                       int flags ) const;
};


class %delete wxPGDefaultRenderer : public wxPGCellRenderer
{
    virtual bool Render( wxDC& dc,
                         const wxRect& rect,
                         const wxPropertyGrid* propertyGrid,
                         wxPGProperty* property,
                         int column,
                         int item,
                         int flags ) const;

    virtual wxSize GetImageSize( const wxPGProperty* property,
                                 int column,
                                 int item ) const;
};


class wxPGCellData : public wxObjectRefData
{
    wxPGCellData();

    void SetText( const wxString& text );
    void SetBitmap( const wxBitmap& bitmap );
    void SetFgCol( const wxColour& col );
    void SetBgCol( const wxColour& col );
    void SetFont( const wxFont& font );
};


class %delete wxPGCell : public wxObject
{
    wxPGCell();
    wxPGCell(const wxPGCell& other);
    wxPGCell( const wxString& text,
              const wxBitmap& bitmap = wxNullBitmap,
              const wxColour& fgCol = wxNullColour,
              const wxColour& bgCol = wxNullColour );

    wxPGCellData* GetData();
    const wxPGCellData* GetData() const;

    bool HasText() const;
    void SetEmptyData();
    void MergeFrom( const wxPGCell& srcCell );

    void SetText( const wxString& text );
    void SetBitmap( const wxBitmap& bitmap );
    void SetFgCol( const wxColour& col );

    void SetFont( const wxFont& font );
    void SetBgCol( const wxColour& col );

    const wxString& GetText() const;
    const wxBitmap& GetBitmap() const;
    const wxColour& GetFgCol() const;

    const wxFont& GetFont() const;

    const wxColour& GetBgCol() const;

    wxPGCell& operator=( const wxPGCell& other );
};

class wxPGAttributeStorage
{
    wxPGAttributeStorage();

    void Set( const wxString& name, const wxVariant& value );
    unsigned int GetCount() const;
    wxVariant FindValue( const wxString& name ) const;

    /* typedef wxPGHashMapS2P::const_iterator const_iterator; */
    /* const_iterator StartIteration() const; */
    /* bool GetNext( const_iterator& it, wxVariant& variant ) const; */
};


class wxPGChoiceEntry : public wxPGCell
{
public:
    wxPGChoiceEntry();
    wxPGChoiceEntry(const wxPGChoiceEntry& other);
    wxPGChoiceEntry( const wxString& label,
                     int value = wxPG_INVALID_VALUE );

    void SetValue( int value );
    int GetValue() const;

    wxPGChoiceEntry& operator=( const wxPGChoiceEntry& other );
};


class wxPGChoicesData : public wxObjectRefData
{
    // Constructor sets m_refCount to 1.
    wxPGChoicesData();

    void CopyDataFrom( wxPGChoicesData* data );

    wxPGChoiceEntry& Insert( int index, const wxPGChoiceEntry& item );

    // Delete all entries
    void Clear();

    unsigned int GetCount() const;

    const wxPGChoiceEntry& Item( unsigned int i ) const;
    wxPGChoiceEntry& Item( unsigned int i );
};



class %delete wxPGChoices
{
    /* #define_pointer wxPGChoicesEmptyData */

    wxPGChoices();
    wxPGChoices( const wxPGChoices& a );
    /* wxPGChoices(size_t count, const wxString** labels, const long* values = NULL); */
    /* wxPGChoices( const wxChar** labels, const long* values = NULL ); */
    wxPGChoices( const wxArrayString& labels, const wxArrayInt& values = wxLuaSmartwxArrayInt() );
    wxPGChoices( %ungc wxPGChoicesData* data );

    /* void Add(size_t count, const wxString* labels, const long* values = NULL); */
    /* void Add( const wxChar** labels, const long* values = NULL ); */
    void Add( const wxArrayString& arr, const wxArrayInt& arrint );
    wxPGChoiceEntry& Add( const wxString& label, int value = wxPG_INVALID_VALUE );
    wxPGChoiceEntry& Add( const wxString& label, const wxBitmap& bitmap,
                          int value = wxPG_INVALID_VALUE );
    wxPGChoiceEntry& Add( const wxPGChoiceEntry& entry );
    wxPGChoiceEntry& AddAsSorted( const wxString& label, int value = wxPG_INVALID_VALUE );
    void Assign( const wxPGChoices& a );
    void AssignData( wxPGChoicesData* data );
    void Clear();
    wxPGChoices Copy() const;
    void EnsureData();
    void* GetId() const;
    const wxString& GetLabel( unsigned int ind ) const;
    unsigned int GetCount() const;
    int GetValue( unsigned int ind ) const;
    wxArrayInt GetValuesForStrings( const wxArrayString& strings ) const;
    wxArrayInt GetIndicesForStrings( const wxArrayString& strings,
                                     wxArrayString* unmatched = NULL ) const;
    int Index( const wxString& label ) const;
    int Index( int val ) const;
    wxPGChoiceEntry& Insert( const wxString& label, int index, int value = wxPG_INVALID_VALUE );
    wxPGChoiceEntry& Insert( const wxPGChoiceEntry& entry, int index );
    bool IsOk() const;
    const wxPGChoiceEntry& Item( unsigned int i ) const;
    wxPGChoiceEntry& Item( unsigned int i );
    void RemoveAt(size_t nIndex, size_t count = 1);
    /* void Set(size_t count, const wxString* labels, const long* values = NULL); */
    /* void Set( const wxChar** labels, const long* values = NULL ); */
    void Set( const wxArrayString& labels, const wxArrayInt& values = wxLuaSmartwxArrayInt() );
    void AllocExclusive();
    wxPGChoicesData* GetData();
    wxPGChoicesData* GetDataPtr() const;
    wxPGChoicesData* ExtractData();
    wxArrayString GetLabels() const;

    void operator= (const wxPGChoices& a);

    wxPGChoiceEntry& operator[](unsigned int i);
    const wxPGChoiceEntry& operator[](unsigned int i) const;
};

class %delete wxPGRootProperty : public wxPGProperty
{
    wxPGRootProperty( const wxString& name /* = wxS("<Root>") */ );

    virtual bool StringToValue( wxVariant&, const wxString&, int ) const;
};

class %delete wxPropertyCategory : public wxPGProperty
{
    wxPropertyCategory();
    wxPropertyCategory( const wxString& label,
                        const wxString& name = wxPG_LABEL );

    int GetTextExtent( const wxWindow* wnd, const wxFont& font ) const;

    virtual wxString ValueToString( wxVariant& value, int argFlags ) const;
    virtual wxString GetValueAsString( int argFlags = 0 ) const;
};

#endif //wxLUA_USE_wxPropertyGrid && %wxchkver_2_9 && wxUSE_PROPGRID
