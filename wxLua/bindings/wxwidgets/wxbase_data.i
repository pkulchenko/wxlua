// ===========================================================================
// Purpose:     data classes, wxObject, arrays, lists, hash
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

// ---------------------------------------------------------------------------
// wxString - A stub class for people who absolutely need wxStrings
//
// wxLua uses Lua strings for almost everything and any function that takes
// a wxString can take a Lua string. All functions that return a wxString
// actually return Lua string unless otherwise noted.

%class %delete wxString
    wxString(const wxString& str = "")

    wxString GetData() const

    wxString AfterFirst(wxChar ch) const
    wxString AfterLast(wxChar ch) const
    wxString BeforeFirst(wxChar ch) const
    wxString BeforeLast(wxChar ch) const

    size_t Len() const

    const wxCharBuffer ToUTF8() const
    static wxString FromUTF8(const char* s)

%endclass

// ---------------------------------------------------------------------------
// wxStringTokenizer

%include "wx/tokenzr.h"

%enum wxStringTokenizerMode
    wxTOKEN_INVALID         // set by def ctor until SetString() is called
    wxTOKEN_DEFAULT         // strtok() for whitespace delims, RET_EMPTY else
    wxTOKEN_RET_EMPTY       // return empty token in the middle of the string
    wxTOKEN_RET_EMPTY_ALL   // return trailing empty tokens too
    wxTOKEN_RET_DELIMS      // return the delim with token (implies RET_EMPTY)
    wxTOKEN_STRTOK          // behave exactly like strtok(3)
%endenum

%class %delete wxStringTokenizer, wxObject
    wxStringTokenizer()
    wxStringTokenizer(const wxString& str, const wxString& delims = wxDEFAULT_DELIMITERS, wxStringTokenizerMode mode = wxTOKEN_DEFAULT);

    void SetString(const wxString& str, const wxString& delims = wxDEFAULT_DELIMITERS, wxStringTokenizerMode mode = wxTOKEN_DEFAULT);

    void Reinit(const wxString& str);
    size_t CountTokens() const;
    bool HasMoreTokens() const;
    wxString GetNextToken();
    //wxChar GetLastDelimiter() const

    wxString GetString() const
    size_t GetPosition() const

    wxStringTokenizerMode GetMode() const
    bool AllowEmpty() const
%endclass

// ---------------------------------------------------------------------------
// wxClientData
//
// No %delete since the container will delete it and you should only create one
// of these if you plan on attaching it to a container to avoid a memory leak.

//%enum wxClientDataType - used internally so we don't need it
//    wxClientData_None
//    wxClientData_Object
//    wxClientData_Void
//%endenum

%class wxClientData
    // declare this as a datatype, but there is nothing we can do with this as
    // it must be derived, see wxStringClientData
%endclass

// ---------------------------------------------------------------------------
// wxStringClientData
//
// No %delete since the container will delete it and you should only create one
// of these if you plan on attaching it to a container to avoid a memory leak.

%class wxStringClientData, wxClientData
    wxStringClientData(const wxString& data = "")

    wxString GetData() const
    void SetData(const wxString& data)
%endclass

// ---------------------------------------------------------------------------
// wxClientDataContainer

%class wxClientDataContainer
    wxClientDataContainer()

    void SetClientObject( wxClientData *data )
    wxClientData *GetClientObject() const

    void SetClientData( voidptr_long data ) // C++ is (void *clientData) You can put a number here
    // C++ Func: void *GetClientData() const
    voidptr_long GetClientData() const // C++ returns (void *) You get a number here
%endclass

// ---------------------------------------------------------------------------
// wxObject

%if wxLUA_USE_wxObject

%include "wx/object.h"

%function wxObject* wxCreateDynamicObject(const wxString& className)

%class %delete wxObject
    wxObject()

    //void Dump(ostream& stream)

    // %override [new class type] wxObject::DynamicCast() converts the wxObject
    //    to an object of type classname
    void *DynamicCast(const wxString &classname)

    wxClassInfo* GetClassInfo()
    wxObjectRefData* GetRefData() const
    bool  IsKindOf(wxClassInfo *info)
    bool IsSameAs(const wxObject& o) const
    void  Ref(const wxObject& clone)
    void  SetRefData(wxObjectRefData* data)
    void  UnRef()

    //%operator wxObject& operator=(const wxObject& other)
%endclass

%class wxObjectRefData // no %delete since this should be from a wxObject
    int GetRefCount() const
%endclass

%endif //wxLUA_USE_wxObject

// ---------------------------------------------------------------------------
// wxClassInfo

%if wxLUA_USE_wxClassInfo

%include "wx/object.h"

%class wxClassInfo // no %delete since we're always getting a static instance
    // %override wxClassInfo() constructor creates an instance using wxClassInfo::FindClass
    wxClassInfo(const wxString &name)

    wxObject* CreateObject()
    static wxClassInfo* FindClass(const wxString &name)
    wxString GetBaseClassName1() const
    wxString GetBaseClassName2() const
    const wxClassInfo  *GetBaseClass1() const
    const wxClassInfo  *GetBaseClass2() const
    wxString GetClassName() const
    int GetSize() const
    bool IsDynamic()
    bool IsKindOf(wxClassInfo* info)

    static const wxClassInfo  *GetFirst()
    const wxClassInfo         *GetNext() const

%endclass

%endif //wxLUA_USE_wxClassInfo


// ---------------------------------------------------------------------------
// wxList

%if wxLUA_USE_wxList && !wxUSE_STL

%include "wx/list.h"

%enum wxKeyType
    wxKEY_NONE
    wxKEY_INTEGER
    wxKEY_STRING
%endenum

%class %delete wxList, wxObject
    wxList()

    wxNode *Append(wxObject *object)
    wxNode *Append(long key, wxObject *object)
    wxNode *Append(const wxString& key, wxObject *object)
    void Clear()
    void DeleteContents(bool destroy)
    bool DeleteNode(wxNode *pNode)
    bool DeleteObject(wxObject *pObject)
    wxNode* Find(wxObject* pObject)
    wxNode *Find(long key)
    wxNode *Find(const wxString &key)
    int     GetCount() const
    wxNode *GetFirst()
    wxNode *GetLast()
    int     IndexOf(wxObject* pObject)
    wxNode *Insert(wxObject *pObject)
    wxNode *Insert(size_t position, wxObject *pObject)
    wxNode *Insert(wxNode *pNode, wxObject *pObject)
    bool    IsEmpty() const
    wxNode *Item(int iIndex) const
    wxNode *Member(wxObject *pObject)
%endclass

// ---------------------------------------------------------------------------
// wxNode - wxList

%class wxNode // no %delete since we get this from a wxList
    // no constructor, just use this from a wxList

    wxObject *GetData()
    wxNode *GetNext()
    wxNode *GetPrevious()
    void SetData(wxObject *data)
    //int IndexOf() - unfortunately a protected member of wxNodeBase

    // To convert wxObject* GetData() to another type use wxObject::DynamicCast
    // See wxMenuItemList, wxWindowList

    // Example: How to use a wxWindowList
    // frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "Test");
    // win = wx.wxWindow(frame, wx.wxID_ANY)
    // frame:Show(true)
    // wlist = frame:GetChildren()
    // wlist:Item(0):GetData():DynamicCast("wxWindow"):SetBackgroundColour(wx.wxRED)

    // Example: How to use a wxMenuItemList
    // local fileMenu = wx.wxMenu()
    // fileMenu:Append(wx.wxID_EXIT, "E&xit", "Quit the program")
    // mList = fileMenu:GetMenuItems()
    // print(mList:GetCount(), mList:GetFirst():GetData():DynamicCast("wxMenuItem"):GetLabel())

%endclass

%endif //wxLUA_USE_wxList && !wxUSE_STL

// ---------------------------------------------------------------------------
// wxArray - Can't implement this since it's not really a class.
//           Here's the list of generic functions.

//%class wxArray
//    // no constructor since this class doesn't exist
//    void Add(T &item, size_t copies = 1)
//    void Alloc(size_t count)
//    void Clear()
//    void Empty()
//    int  GetCount() const
//    void Insert(T &item, size_t n, size_t copies = 1)
//    bool IsEmpty() const
//    void RemoveAt(size_t index, size_t count = 1)
//    void Shrink()
//%endclass

// ---------------------------------------------------------------------------
// wxArrayInt
//
// NOTE: Any function that takes a "const wxArrayInt& arr" or "wxArrayInt arr"
//       can take a Lua table of integers with numeric indexes

%if wxLUA_USE_wxArrayInt

%include "wx/dynarray.h"

%class %delete wxArrayInt
    wxArrayInt()
    wxArrayInt(const wxArrayInt& array)

    // %override [Lua table] wxArrayInt::ToLuaTable() const
    // returns a table array of the integers
    int ToLuaTable() const

    void Add( int num )
    void Alloc(size_t count)
    void Clear()
    void Empty()
    int  GetCount() const
    bool IsEmpty() const
    int  Index(int n, bool searchFromEnd = false)
    void Insert( int num, int n, int copies = 1 )
    int  Item( int n )
    void Remove(int n)
    void RemoveAt(size_t index)
    void Shrink()

    %operator int operator[](size_t nIndex)

%endclass

%endif //wxLUA_USE_wxArrayInt

// ---------------------------------------------------------------------------
// wxArrayString
//
// NOTE: Any function that takes a "const wxArrayString& arr" or "wxArrayString arr"
//       can take a Lua table of strings with numeric indexes

%if wxLUA_USE_wxArrayString

%include "wx/arrstr.h"

%class %delete wxArrayString
    wxArrayString()
    wxArrayString(const wxArrayString& array)

    // %override [Lua table] wxArrayString::ToLuaTable() const
    // returns a table array of the strings
    int ToLuaTable() const

    size_t Add(const wxString& str, size_t copies = 1)
    void Alloc(size_t nCount)
    void Clear()
    void Empty()
    int  GetCount() const
    int  Index(const wxString &sz, bool bCase = true, bool bFromEnd = false)
    void Insert(const wxString& str, int nIndex, size_t copies = 1)
    bool IsEmpty()
    wxString Item(size_t nIndex) const
    wxString Last()
    void Remove(const wxString &sz)
    void RemoveAt(size_t nIndex, size_t count = 1)
    void Shrink()
    void Sort(bool reverseOrder = false)

    %operator wxString& operator[](size_t nIndex)

%endclass

// ---------------------------------------------------------------------------
// wxSortedArrayString
//
// NOTE: Any function that takes a "const wxSortedArrayString& arr" or "wxSortedArrayString arr"
//       can take a Lua table of strings with numeric indexes
//
// Note: We cheat by saying that it's derived from a wxArrayString to not
//       have to duplicate it's methods. The binder doesn't know any better.

%class %delete wxSortedArrayString, wxArrayString
    wxSortedArrayString()
    wxSortedArrayString(const wxArrayString& src) // have to have this constructor since they're not actually derived
    wxSortedArrayString(const wxSortedArrayString& src)

%endclass

%endif //wxLUA_USE_wxArrayString

// ---------------------------------------------------------------------------
// wxStringList - is deprecated in wxWidgets since 2.2

//%if wxLUA_USE_wxStringList
//%include "wx/list.h"
//%class wxStringList, wxList
//    wxStringList()
//    wxNode *Add(const wxString& s)
//    void Clear()
//    void Delete(const wxString& s)
//    bool Member(const wxString& s)
//    void Sort()
//%endclass
//%endif wxLUA_USE_wxStringList

// ---------------------------------------------------------------------------
// wxHashTable - Lua tables are hashtables

//%if wxLUA_USE_wxHashTable

//%include "wx/hash.h"

//%if %wxchkver_2_6
//%class wxHashTable::Node
//%endclass
//%endif

//%class wxHashTable, wxObject
//    !%wxchkver_2_6 wxHashTable(unsigned int key_type, int size = 1000)
//    %wxchkver_2_6 wxHashTable(wxKeyType key_type, int size = 1000)
//    void BeginFind()
//    void Clear()
//    wxObject * Delete(long key)
//    void DeleteContents(bool flag)
//    wxObject * Get(long key)
//    wxObject * Get(const wxString &key)
//    long MakeKey(const wxString& string)
//    !%wxchkver_2_6 wxNode * Next()
//    %wxchkver_2_6 wxHashTable::Node * Next()
//    void Put(long key, wxObject *object)
//    void Put(const wxString& key, wxObject *object)
//    int GetCount() const
//%endclass

//%endif wxLUA_USE_wxHashTable

// ---------------------------------------------------------------------------
// wxLongLong

%if wxUSE_LONGLONG

%include "wx/longlong.h"

%class %delete wxLongLong
    wxLongLong(long hi = 0, unsigned long lo = 0)

    wxLongLong Abs() const
    wxLongLong& Assign(double d)
    long GetHi() const
    unsigned long GetLo() const
    double ToDouble() const
    long ToLong() const
    wxString ToString() const

    //%operator wxLongLong operator+(const wxLongLong& ll) const
    //%operator wxLongLong& operator+(const wxLongLong& ll)
    //%operator wxLongLong& operator++()
    //%operator wxLongLong operator-() const
    //%operator wxLongLong operator-(const wxLongLong& ll) const
%endclass

// ---------------------------------------------------------------------------
// wxULongLong

%class %delete wxULongLong
    wxULongLong(unsigned long hi = 0, unsigned long lo = 0)

    unsigned long GetHi() const
    unsigned long GetLo() const
    long ToULong() const
    wxString ToString() const
%endclass

%endif wxUSE_LONGLONG
