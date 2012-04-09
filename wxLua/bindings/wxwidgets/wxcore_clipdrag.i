// ===========================================================================
// Purpose:     wxClipboard and drag & drop and their wxDataFormat
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

// ---------------------------------------------------------------------------
// wxClipboard

%if wxLUA_USE_wxClipboard && wxUSE_CLIPBOARD

%include "wx/clipbrd.h"

%class wxClipboard, wxObject
    !%wxchkver_2_6 %define_pointer wxTheClipboard
    %wxchkver_2_6 static wxClipboard *Get()

    // No constructor, use global clipboard from static Get() function only

    bool AddData( %ungc wxDataObject *data )
    void Clear()
    void Close()
    bool Flush()
    bool GetData( wxDataObject& data )
    bool IsOpened() const
    bool IsSupported( const wxDataFormat& format )
    bool Open()
    bool SetData( %ungc wxDataObject *data )
    void UsePrimarySelection( bool primary = true )
%endclass

// ---------------------------------------------------------------------------
// wxClipboardLocker

%class %delete wxClipboardLocker
    // NOTE: ALWAYS delete() this when done since Lua's gc may not delete it soon enough
    wxClipboardLocker(wxClipboard *clipboard = NULL)

    %operator bool operator!() const
%endclass

// ---------------------------------------------------------------------------
// wxClipboardTextEvent

%if %wxchkver_2_8

%include "wx/event.h"

%class %delete wxClipboardTextEvent, wxCommandEvent
    %define_event wxEVT_COMMAND_TEXT_COPY   // EVT_TEXT_COPY(winid, func)
    %define_event wxEVT_COMMAND_TEXT_CUT    // EVT_TEXT_CUT(winid, func)
    %define_event wxEVT_COMMAND_TEXT_PASTE  // EVT_TEXT_PASTE(winid, func)

    wxClipboardTextEvent(wxEventType type = wxEVT_NULL, wxWindowID winid = 0)

%endclass

%endif //%wxchkver_2_8

%endif //wxLUA_USE_wxClipboard && wxUSE_CLIPBOARD

// ---------------------------------------------------------------------------
// wxDataFormat

%if wxLUA_USE_wxDataObject && wxUSE_DATAOBJ

%include "wx/dataobj.h"

%enum wxDataFormatId
    wxDF_INVALID
    wxDF_TEXT
    wxDF_BITMAP
    wxDF_METAFILE
    wxDF_SYLK
    wxDF_DIF
    wxDF_TIFF
    wxDF_OEMTEXT
    wxDF_DIB
    wxDF_PALETTE
    wxDF_PENDATA
    wxDF_RIFF
    wxDF_WAVE
    wxDF_UNICODETEXT
    wxDF_ENHMETAFILE
    wxDF_FILENAME
    wxDF_LOCALE
    wxDF_PRIVATE
    wxDF_HTML
    wxDF_MAX
%endenum

%class %delete wxDataFormat
    %define_object wxFormatInvalid

    wxDataFormat(wxDataFormatId format = wxDF_INVALID)
    wxDataFormat(const wxString &format)

    wxString GetId() const
    int GetType() const // returns wxDataFormatId, but it's just an int and msw differs
    void SetId(const wxString &format)
    void SetType(wxDataFormatId format)

    %operator bool operator==(const wxDataFormat& format) const
%endclass

// ---------------------------------------------------------------------------
// wxDataObject

%enum wxDataObject::Direction
    Get
    Set
%endenum

%class wxDataObject
    //wxDataObject() this is a base class, use simplified derived classes

    // %override [Lua table of wxDataFormat objects] wxDataObject::GetAllFormats(wxDataObject::Direction dir = wxDataObject)
    // C++ Func: virtual void GetAllFormats(wxDataFormat *formats, wxDataObject::Direction dir = wxDataObject::Get) const
    virtual void GetAllFormats(wxDataObject::Direction dir = wxDataObject::Get) const

    // %override [bool, Lua string] wxDataObject::GetDataHere(const wxDataFormat& format)
    // C++ Func: virtual bool GetDataHere(const wxDataFormat& format, void *buf) const
    virtual bool GetDataHere(const wxDataFormat& format) const

    virtual int GetDataSize(const wxDataFormat& format) const
    virtual int GetFormatCount(wxDataObject::Direction dir = wxDataObject::Get) const
    virtual wxDataFormat GetPreferredFormat(wxDataObject::Direction dir = wxDataObject::Get) const

    // %override bool wxDataObject::SetData(const wxDataFormat& format, Lua string)
    // C++ Func: virtual bool SetData(const wxDataFormat& format, int len, const void *buf)
    virtual bool SetData(const wxDataFormat& format, const wxString& str)

%endclass

// ---------------------------------------------------------------------------
// wxDataObjectSimple

%class %delete wxDataObjectSimple, wxDataObject
    wxDataObjectSimple(const wxDataFormat& format = wxFormatInvalid)

    const wxDataFormat& GetFormat() const
    void SetFormat(const wxDataFormat& format)

    // This must be overridden in wxLuaDataObjectSimple, this function returns 0.
    virtual size_t GetDataSize() const

    // This must be overridden in wxLuaDataObjectSimple, this function returns false.
    virtual bool GetDataHere() const

    // This must be overridden in wxLuaDataObjectSimple, this function returns false.
    virtual bool SetData(const wxString& str)

%endclass

// ---------------------------------------------------------------------------
// wxLuaDataObjectSimple

%class %delete wxLuaDataObjectSimple, wxDataObjectSimple
    wxLuaDataObjectSimple(const wxDataFormat& format = wxFormatInvalid)

    // The functions below are all virtual functions that you MUST override in Lua
    // for this class to work.

    // Override this function to return the size of the data for GetDataHere().
    //virtual size_t GetDataSize() const

    // Create a Lua function that returns a [bool, Lua string (of exact length GetDataSize())].
    // %override [bool, Lua string] wxLuaDataObjectSimple::GetDataHere()
    // C++ Func: virtual bool GetDataHere(void *buf) const
    //virtual bool GetDataHere() const

    // Create a Lua function that takes a Lua string as the input data.
    // %override bool wxLuaDataObjectSimple::SetData(Lua string)
    // C++ Func: virtual bool SetData(size_t len, const void *buf)
    //virtual bool SetData(const wxString& str)

%endclass

// ---------------------------------------------------------------------------
// wxDataObjectComposite

%class %delete wxDataObjectComposite, wxDataObject
    wxDataObjectComposite()

    void Add(%ungc wxDataObjectSimple *dataObject, bool preferred = false)
    %wxchkver_2_8 wxDataFormat GetReceivedFormat() const
%endclass

// ---------------------------------------------------------------------------
// wxFileDataObject

%class %delete wxFileDataObject, wxDataObjectSimple
    wxFileDataObject()

    virtual void AddFile(const wxString& file)
    wxArrayString GetFilenames() const
%endclass

// ---------------------------------------------------------------------------
// wxTextDataObject

%class %delete wxTextDataObject, wxDataObjectSimple
    wxTextDataObject(const wxString& text = "")

    virtual size_t GetTextLength() const
    virtual wxString GetText() const
    virtual void SetText(const wxString& text)
%endclass

// ---------------------------------------------------------------------------
// wxBitmapDataObject

%class %delete wxBitmapDataObject, wxDataObjectSimple
    wxBitmapDataObject(const wxBitmap& bitmap = wxNullBitmap)

    virtual wxBitmap GetBitmap() const
    virtual void SetBitmap(const wxBitmap& bitmap)
%endclass

// ---------------------------------------------------------------------------
// wxCustomDataObject - FIXME implement this?

//%class wxCustomDataObject, wxDataObjectSimple
//    wxCustomDataObject(const wxDataFormat& format = wxFormatInvalid)
//
//    virtual void *Alloc(size_t size)
//    virtual void Free()
//    virtual size_t GetSize() const
//    virtual void *GetData() const
//    virtual void SetData(size_t size, const void *data)
//    virtual void TakeData( size_t size, void *data)
//%endclass

// ---------------------------------------------------------------------------
// wxURLDataObject - is simply wxTextDataObject with a different name

%if %wxchkver_2_8

%class %delete wxURLDataObject, wxTextDataObject
    wxURLDataObject(const wxString& url = "")

    wxString GetURL() const
    void SetURL(const wxString& url)
%endclass

%endif //%wxchkver_2_8

%endif //wxLUA_USE_wxDataObject && wxUSE_DATAOBJ

// ---------------------------------------------------------------------------
// wxDropTarget

%if wxLUA_USE_wxDragDrop && wxUSE_DRAG_AND_DROP

%include "wx/dnd.h"

%enum
    wxDrag_CopyOnly
    wxDrag_AllowMove
    wxDrag_DefaultMove
%endenum

%enum wxDragResult
    wxDragError
    wxDragNone
    wxDragCopy
    wxDragMove
    wxDragLink
    wxDragCancel
%endenum

%function bool wxIsDragResultOk(wxDragResult res)

%class wxDropTarget // FIXME implement virtual

    //wxDropTarget(wxDataObject* data = NULL) pure virtual functions in MSW
    virtual bool GetData()
    //wxDragResult GetDefaultAction()
    //virtual wxDragResult OnData(wxCoord x, wxCoord y, wxDragResult def)
    //virtual bool OnDrop(wxCoord x, wxCoord y)
    //virtual wxDragResult OnEnter(wxCoord x, wxCoord y, wxDragResult def)
    //virtual wxDragResult OnDragOver(wxCoord x, wxCoord y, wxDragResult def)
    //virtual void OnLeave()
    //void SetDataObject(wxDataObject* data)
    //void SetDefaultAction(wxDragResult action)
%endclass

// ---------------------------------------------------------------------------
// wxFileDropTarget

//%class wxFileDropTarget, wxDropTarget // FIXME implement virtual
//    wxFileDropTarget()
//    virtual wxDragResult OnData(wxCoord x, wxCoord y, wxDragResult def)
//    virtual bool OnDrop(long x, long y, const void *data, size_t size)
//    virtual bool OnDropFiles(wxCoord x, wxCoord y,const wxArrayString& filenames)
//%endclass

// ---------------------------------------------------------------------------
// wxTextDropTarget

//%class wxTextDropTarget, wxDropTarget // FIXME implement virtual
//    wxTextDropTarget()
//    virtual bool OnDropText(wxCoord x, wxCoord y, const wxString& text)
//    virtual wxDragResult OnData(wxCoord x, wxCoord y, wxDragResult def)
//%endclass

// ---------------------------------------------------------------------------
// wxDropSource

%class %delete wxDropSource // FIXME implement virtual
    %win|%mac wxDropSource(wxWindow* win = NULL, const wxCursor& cursorCopy = wxNullCursor, const wxCursor& cursorMove = wxNullCursor, const wxCursor& cursorStop = wxNullCursor)
    %gtk wxDropSource(wxWindow* win = NULL, const wxIcon& iconCopy = wxNullIcon, const wxIcon& iconMove = wxNullIcon, const wxIcon& iconStop = wxNullIcon)
    %win wxDropSource(wxDataObject& data, wxWindow* win = NULL, const wxCursor& cursorCopy = wxNullCursor, const wxCursor& cursorMove = wxNullCursor, const wxCursor& cursorStop = wxNullCursor)
    %gtk wxDropSource(wxDataObject& data, wxWindow* win = NULL, const wxIcon& iconCopy = wxNullIcon, const wxIcon& iconMove = wxNullIcon, const wxIcon& iconStop = wxNullIcon)

    void SetData(wxDataObject& data)
    virtual wxDragResult DoDragDrop(int flags = wxDrag_CopyOnly)
    wxDataObject* GetDataObject()
    virtual bool GiveFeedback(wxDragResult effect)
    void SetCursor(wxDragResult res, const wxCursor& cursor)
%endclass

// ---------------------------------------------------------------------------
// wxDropFilesEvent

%include "wx/event.h"

%class %delete wxDropFilesEvent, wxEvent
    %define_event wxEVT_DROP_FILES  // EVT_DROP_FILES(func)

    // wxDropFilesEvent(WXTYPE id = 0, int noFiles = 0, wxString* files = NULL) only handle this event

    // %override [Lua table of strings] wxDropFilesEvent::GetFiles()
    // C++ Func: wxString* GetFiles() const
    wxString* GetFiles() const

    int GetNumberOfFiles() const
    wxPoint GetPosition() const
%endclass

%endif //wxLUA_USE_wxDragDrop && wxUSE_DRAG_AND_DROP

// ---------------------------------------------------------------------------
// wxMetafile

%if wxLUA_USE_wxMetafile && wxUSE_METAFILE && (%msw|%mac|%os2)

%include "wx/metafile.h"

//%function bool wxMakeMetafilePlaceable(const wxString& filename, int minX, int minY, int maxX, int maxY, float scale = 1.0)

%class %delete wxMetafile, wxObject
    wxMetafile(const wxString& filename = "")

    bool Ok()
    bool Play(wxDC *dc)
    bool SetClipboard(int width = 0, int height = 0)
%endclass

// ---------------------------------------------------------------------------
// wxMetafileDC
%class %delete wxMetafileDC, wxDC
    wxMetafileDC(const wxString& filename = "")

    %win %gc wxMetafile* Close()
%endclass

%endif

%endif //wxLUA_USE_wxMetafile && wxUSE_METAFILE && (%msw|%mac|%os2)
