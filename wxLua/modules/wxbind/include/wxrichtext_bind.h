// ---------------------------------------------------------------------------
// wxrichtext.h - headers and wxLua types for wxLua binding
//
// This file was generated by genwxbind.lua 
// Any changes made to this file will be lost when the file is regenerated
// ---------------------------------------------------------------------------

#ifndef __HOOK_WXLUA_wxrichtext_H__
#define __HOOK_WXLUA_wxrichtext_H__

#include "wxbind/include/wxbinddefs.h"
#include "wxluasetup.h"
#include "wxbind/include/wxcore_bind.h"
#include "wxbind/include/wxxml_bind.h"

#include "wxlua/wxlstate.h"
#include "wxlua/wxlbind.h"

// ---------------------------------------------------------------------------
// Check if the version of binding generator used to create this is older than
//   the current version of the bindings.
//   See 'bindings/genwxbind.lua' and 'modules/wxlua/wxldefs.h'
#if WXLUA_BINDING_VERSION > 44
#   error "The WXLUA_BINDING_VERSION in the bindings is too old, regenerate bindings."
#endif //WXLUA_BINDING_VERSION > 44
// ---------------------------------------------------------------------------

// binding class
class WXDLLIMPEXP_BINDWXRICHTEXT wxLuaBinding_wxrichtext : public wxLuaBinding
{
public:
    wxLuaBinding_wxrichtext();


private:
    DECLARE_DYNAMIC_CLASS(wxLuaBinding_wxrichtext)
};


// initialize wxLuaBinding_wxrichtext for all wxLuaStates
extern WXDLLIMPEXP_BINDWXRICHTEXT wxLuaBinding* wxLuaBinding_wxrichtext_init();

// ---------------------------------------------------------------------------
// Includes
// ---------------------------------------------------------------------------

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT)
    #include "wx/richtext/richtextformatdlg.h"
    #include "wx/richtext/richtexthtml.h"
    #include "wx/richtext/richtextimagedlg.h"
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT)

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_XML)
    #include "wx/richtext/richtextxml.h"
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_XML)

#if wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT
    #include "wx/richtext/richtextbuffer.h"
    #include "wx/richtext/richtextctrl.h"
    #include "wx/richtext/richtextprint.h"
    #include "wx/richtext/richtextstyledlg.h"
    #include "wx/richtext/richtextstyles.h"
    #include "wx/richtext/richtextsymboldlg.h"
#endif // wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT

// ---------------------------------------------------------------------------
// Lua Tag Method Values and Tables for each Class
// ---------------------------------------------------------------------------

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT)
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextFormattingDialog;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextFormattingDialogFactory;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextHTMLHandler;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextObjectPropertiesDialog;
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT)

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxRICHTEXT_USE_PARTIAL_TEXT_EXTENTS && wxRICHTEXT_USE_OPTIMIZED_LINE_DRAWING)
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextLineList;
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxRICHTEXT_USE_PARTIAL_TEXT_EXTENTS && wxRICHTEXT_USE_OPTIMIZED_LINE_DRAWING)

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_COMBOCTRL) && (wxUSE_HTML)
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextStyleComboCtrl;
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_COMBOCTRL) && (wxUSE_HTML)

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_DATAOBJ)
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextBufferDataObject;
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_DATAOBJ)

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_DRAG_AND_DROP)
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextDropSource;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextDropTarget;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextEvent;
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_DRAG_AND_DROP)

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_HTML)
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextStyleListBox;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextStyleListCtrl;
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_HTML)

#if (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_XML)
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextXMLHandler;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextXMLHelper;
#endif // (wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT) && (wxUSE_XML)

#if wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextAction;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextAttr;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextAttrArray;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextBox;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextBoxStyleDefinition;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextBuffer;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextCell;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextCharacterStyleDefinition;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextCommand;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextCompositeObject;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextContextMenuPropertiesInfo;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextCtrl;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextDrawingContext;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextDrawingHandler;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextField;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextFieldType;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextFieldTypeHashMap;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextFieldTypeHashMap_iterator;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextFieldTypeStandard;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextFileHandler;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextFontTable;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextHeaderFooterData;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextImage;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextImageBlock;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextLine;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextListStyleDefinition;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextObject;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextObjectAddress;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextObjectList;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextObjectPtrArray;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextObjectPtrArrayArray;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextParagraph;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextParagraphLayoutBox;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextParagraphStyleDefinition;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextPlainText;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextPlainTextHandler;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextPrinting;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextPrintout;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextProperties;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextRange;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextRangeArray;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextRectArray;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextRenderer;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextSelection;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextStdRenderer;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextStyleDefinition;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextStyleOrganiserDialog;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextStyleSheet;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextTable;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextTableBlock;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxRichTextVariantArray;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxSymbolListCtrl;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxSymbolPickerDialog;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxTextAttrBorder;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxTextAttrBorders;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxTextAttrDimension;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxTextAttrDimensionConverter;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxTextAttrDimensions;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxTextAttrSize;
    extern WXDLLIMPEXP_DATA_BINDWXRICHTEXT(int) wxluatype_wxTextBoxAttr;
#endif // wxLUA_USE_wxRichText && wxCHECK_VERSION(3,0,0) && wxUSE_RICHTEXT



#endif // __HOOK_WXLUA_wxrichtext_H__

