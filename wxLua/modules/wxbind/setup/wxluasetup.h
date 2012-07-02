/////////////////////////////////////////////////////////////////////////////
// Name:        wxluasetup.h
// Purpose:     Control what wxLua bindings for wxWidgets are built
// Author:      John Labenski
// Created:     1/10/2008
// Copyright:   (c) 2008 John Labenski
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////


#ifndef __WXLUA_SETUP__
#define __WXLUA_SETUP__


// Enable or disable single or small groups of classes, see bindings/*.i

// This file is separate from the wxbind includes to allow you to modify it
// or put a -Iother/path/to/wxluasetup/ to allow your own wxluasetup file
// to be included since wxLua only includes it as "#include "wxluasetup.h"
// without any path.

#define wxLUA_USE_Geometry                      1
#define wxLUA_USE_MDI                           1
#define wxLUA_USE_wxAboutDialog                 1
#define wxLUA_USE_wxAcceleratorTable            1
#define wxLUA_USE_wxAnimation                   1
#define wxLUA_USE_wxApp                         1
#define wxLUA_USE_wxArrayInt                    1
#define wxLUA_USE_wxArrayString                 1
#define wxLUA_USE_wxArtProvider                 1
#define wxLUA_USE_wxAUI                         1
#define wxLUA_USE_wxBitmap                      1
#define wxLUA_USE_wxBitmapComboBox              1
#define wxLUA_USE_wxBitmapButton                1
#define wxLUA_USE_wxBrushList                   1
#define wxLUA_USE_wxBusyCursor                  1
#define wxLUA_USE_wxBusyInfo                    1
#define wxLUA_USE_wxButton                      1
#define wxLUA_USE_wxCalendarCtrl                1
#define wxLUA_USE_wxCaret                       1
#define wxLUA_USE_wxCheckBox                    1
#define wxLUA_USE_wxCheckListBox                1
#define wxLUA_USE_wxChoice                      1
#define wxLUA_USE_wxClassInfo                   1
#define wxLUA_USE_wxClipboard                   1
#define wxLUA_USE_wxCollapsiblePane             1
#define wxLUA_USE_wxColourDialog                1
#define wxLUA_USE_wxColourPenBrush              1
#define wxLUA_USE_wxColourPickerCtrl            1
#define wxLUA_USE_wxComboBox                    1
#define wxLUA_USE_wxCommandProcessor            1
#define wxLUA_USE_wxConfig                      1
#define wxLUA_USE_wxCursor                      1
#define wxLUA_USE_wxCriticalSection             1
#define wxLUA_USE_wxCriticalSectionLocker       1
#define wxLUA_USE_wxDataObject                  1
#define wxLUA_USE_wxDatePickerCtrl              1
#define wxLUA_USE_wxDateSpan                    1
#define wxLUA_USE_wxDateTime                    1
#define wxLUA_USE_wxDateTimeHolidayAuthority    1
#define wxLUA_USE_wxDC                          1
#define wxLUA_USE_wxDialog                      1
#define wxLUA_USE_wxDir                         1
#define wxLUA_USE_wxDirDialog                   1
#define wxLUA_USE_wxDirPickerCtrl               1
#define wxLUA_USE_wxDisplay                     1
#define wxLUA_USE_wxDragDrop                    1
#define wxLUA_USE_wxDynamicLibrary              1
#define wxLUA_USE_wxFile                        1
#define wxLUA_USE_wxFileDialog                  1
#define wxLUA_USE_wxFileHistory                 1
#define wxLUA_USE_wxFileName                    1
#define wxLUA_USE_wxFilePickerCtrl              1
#define wxLUA_USE_wxFindReplaceDialog           1
#define wxLUA_USE_wxFont                        1
#define wxLUA_USE_wxFontDialog                  1
#define wxLUA_USE_wxFontEnumerator              1
#define wxLUA_USE_wxFontList                    1
#define wxLUA_USE_wxFontMapper                  1
#define wxLUA_USE_wxFontPickerCtrl              1
#define wxLUA_USE_wxFrame                       1
#define wxLUA_USE_wxGauge                       1
#define wxLUA_USE_wxGenericDirCtrl              1
#define wxLUA_USE_wxGenericValidator            1
#define wxLUA_USE_wxGLCanvas                    1 // must link to lib, also wxUSE_GLCANVAS
#define wxLUA_USE_wxGrid                        1
#define wxLUA_USE_wxHashTable                   1
#define wxLUA_USE_wxHelpController              1
#define wxLUA_USE_wxHTML                        1
#define wxLUA_USE_wxHtmlHelpController          1
#define wxLUA_USE_wxHyperlinkCtrl               1
#define wxLUA_USE_wxIcon                        1
#define wxLUA_USE_wxID_XXX                      1
#define wxLUA_USE_wxImage                       1
#define wxLUA_USE_wxImageList                   1
#define wxLUA_USE_wxJoystick                    1
#define wxLUA_USE_wxLayoutConstraints           1
#define wxLUA_USE_wxList                        1
#define wxLUA_USE_wxListBox                     1
#define wxLUA_USE_wxListCtrl                    1
#define wxLUA_USE_wxLog                         1
#define wxLUA_USE_wxLogWindow                   1
#define wxLUA_USE_wxLuaHtmlWindow               1
#define wxLUA_USE_wxLuaPrintout                 1
#define wxLUA_USE_wxMask                        1
#define wxLUA_USE_wxMediaCtrl                   1 // must link to lib, also wxUSE_MEDIACTRL
#define wxLUA_USE_wxMenu                        1
#define wxLUA_USE_wxMessageDialog               1
#define wxLUA_USE_wxMetafile                    1
#define wxLUA_USE_wxMiniFrame                   1
#define wxLUA_USE_wxMultiChoiceDialog           1
#define wxLUA_USE_wxNotebook                    1
#define wxLUA_USE_wxObject                      1
#define wxLUA_USE_wxPicker                      1
#define wxLUA_USE_wxPalette                     1
#define wxLUA_USE_wxPenList                     1
#define wxLUA_USE_wxPointSizeRect               1
#define wxLUA_USE_wxPopupWindow                 1
#define wxLUA_USE_wxPopupTransientWindow        1
#define wxLUA_USE_wxPrint                       1
#define wxLUA_USE_wxProcess                     1
#define wxLUA_USE_wxProgressDialog              1
#define wxLUA_USE_wxRadioBox                    1
#define wxLUA_USE_wxRadioButton                 1
#define wxLUA_USE_wxRegEx                       1
#define wxLUA_USE_wxRegion                      1
#define wxLUA_USE_wxRenderer                    1
#define wxLUA_USE_wxRichText                    0 // NOT FINISHED or WORKING
#define wxLUA_USE_wxSashWindow                  1
#define wxLUA_USE_wxScrollBar                   1
#define wxLUA_USE_wxScrolledWindow              1
#define wxLUA_USE_wxSingleChoiceDialog          1
#define wxLUA_USE_wxSizer                       1
#define wxLUA_USE_wxSlider                      1
#define wxLUA_USE_wxSocket                      1
#define wxLUA_USE_wxSpinButton                  1
#define wxLUA_USE_wxSpinCtrl                    1
#define wxLUA_USE_wxSplashScreen                1
#define wxLUA_USE_wxSplitterWindow              1
#define wxLUA_USE_wxStandardPaths               1
#define wxLUA_USE_wxStaticBitmap                1
#define wxLUA_USE_wxStaticBox                   1
#define wxLUA_USE_wxStaticLine                  1
#define wxLUA_USE_wxStaticText                  1
#define wxLUA_USE_wxStatusBar                   1
#define wxLUA_USE_wxStopWatch                   1
#define wxLUA_USE_wxStringList                  1
#define wxLUA_USE_wxSystemOptions               1
#define wxLUA_USE_wxSystemSettings              1
#define wxLUA_USE_wxTabCtrl                     0 // deprecated MSW only control
#define wxLUA_USE_wxTaskBarIcon                 1
#define wxLUA_USE_wxTextCtrl                    1
#define wxLUA_USE_wxTextEntryDialog             1
#define wxLUA_USE_wxTextValidator               1
#define wxLUA_USE_wxTimer                       1
#define wxLUA_USE_wxTimeSpan                    1
#define wxLUA_USE_wxToggleButton                1
#define wxLUA_USE_wxToolbar                     1
#define wxLUA_USE_wxToolbook                    1
#define wxLUA_USE_wxTooltip                     1
#define wxLUA_USE_wxTreebook                    1
#define wxLUA_USE_wxTreeCtrl                    1
#define wxLUA_USE_wxValidator                   1
#define wxLUA_USE_wxWave                        1
#define wxLUA_USE_wxWindowList                  1
#define wxLUA_USE_wxWizard                      1
#define wxLUA_USE_wxXML                         1
#define wxLUA_USE_wxXRC                         1

#endif // __WXLUA_SETUP__
