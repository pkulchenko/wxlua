/////////////////////////////////////////////////////////////////////////////
// Name:        wxlstate.h
// Purpose:     wxLuaState - a wxWidgets interface to Lua
// Author:      Ray Gilbert, John Labenski, J Winwood
// Created:     14/11/2001
// Copyright:   (c) 2012 John Labenski, 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#ifndef _WXLSTATE_H_
#define _WXLSTATE_H_

#include "wxlua/wxldefs.h"
#include "wxlua/wxlbind.h"
#include "wxlua/wxlobject.h"

#include <wx/filefn.h>
#include <wx/filename.h>
#include <wx/hashmap.h>

class WXDLLIMPEXP_FWD_WXLUA wxLuaEvent;
class WXDLLIMPEXP_FWD_WXLUA wxLuaState;
class WXDLLIMPEXP_FWD_WXLUA wxLuaStateData;
class WXDLLIMPEXP_FWD_WXLUA wxLuaStateRefData;
class WXDLLIMPEXP_FWD_WXLUA wxLuaEventCallback;
class WXDLLIMPEXP_FWD_WXLUA wxLuaWinDestroyCallback;

// ----------------------------------------------------------------------------
// String functions - convert between Lua (ansi string) and wxString (encoded)
// ----------------------------------------------------------------------------

#define WXLUA_USE_WXSTR_CONVUTF8    1
#define WXLUA_USE_WXSTR_CONVCURRENT 0

// Convert a 8-bit ANSI C Lua String into a wxString
inline WXDLLIMPEXP_WXLUA wxString lua2wx(const char* luastr)
{
    if (luastr == NULL) return wxEmptyString; // check for NULL

#if WXLUA_USE_WXSTR_CONVUTF8

    return wxString(luastr, wxConvUTF8);

#elif WXLUA_USE_WXSTR_CONVCURRENT

    return wxString(luastr, *wxConvCurrent);

#else //!WXLUA_USE_WXSTR_CONVCURRENT
    #if wxUSE_UNICODE
        wxString str(luastr, wxConvUTF8);
    #else
        wxString str(wxConvUTF8.cMB2WC(luastr), *wxConvCurrent);
    #endif // wxUSE_UNICODE

        if (str.IsEmpty())
            str = wxConvertMB2WX(luastr); // old way that mostly works

        return str;
#endif //WXLUA_USE_WXSTR_CONVCURRENT
}

// Convert a wxString to 8-bit ANSI C Lua String
inline const WXDLLIMPEXP_WXLUA wxCharBuffer wx2lua(const wxString& wxstr)
{
#if WXLUA_USE_WXSTR_CONVUTF8

    wxCharBuffer buffer(wxstr.mb_str(wxConvUTF8));
    return buffer;

#elif WXLUA_USE_WXSTR_CONVCURRENT

    wxCharBuffer buffer(wxstr.mb_str(*wxConvCurrent));
    return buffer;

#else //!WXLUA_USE_WXSTR_CONVCURRENT
    wxCharBuffer buffer(wxConvUTF8.cWC2MB(wxstr.wc_str(*wxConvCurrent))); // skieu

    if ((buffer.data() == NULL) && !wxstr.IsEmpty())
        buffer = wxConvertWX2MB(wxstr.c_str()); // old way that mostly works

    return buffer;
#endif //WXLUA_USE_WXSTR_CONVCURRENT
}


// Convert a wxString to 8-bit ANSI C Lua Buffer and store it
class WXDLLIMPEXP_WXLUA wxLuaCharBuffer
{
public:
    wxLuaCharBuffer(const wxString &wxstr) : m_buffer(wx2lua(wxstr)) {}

    size_t Length() const { return strlen((const char*)m_buffer); }
    const char *GetData() const { return (const char*)m_buffer; }

    operator const char *() const { return m_buffer; }

    wxCharBuffer m_buffer; // member since non virtual destructor in wxCharBuffer
};

// ----------------------------------------------------------------------------
// Special keys used by wxLua in the LUA_REGISTRYINDEX table.
//
// Note: We do not push a human readable string for these because Lua always
// makes a copy and hashes the string, this takes a considerable amount of
// time when benchmarked using valgrind.
// ----------------------------------------------------------------------------

// Light userdata used as keys in the Lua LUA_REGISTRYINDEX table for wxLua.
// Note that even though these keys have human readable names as values,
// they're not used, just the memory address.

// The key in the LUA_REGISTRYINDEX table that is a weak keyed table of
//   the tables wxLua pushed into the registry with their keys as values.
// This is used by the wxLuaDebugData to know if the table is one of the wxLua
//   registry tables for better wxLuaStackDialog performance.
// LUA_REGISTRYINDEX[&wxlua_lreg_regtable_key][weak {wxlua_lreg_XXX_key table}] =
//    lightuserdata(&wxlua_lreg_XXX_key)
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_regtable_key;

// The key in the LUA_REGISTRYINDEX table whose value is a lightuserdata
//   of a wxLuaState for this lua_State.
// LUA_REGISTRYINDEX[&wxlua_lreg_wxluastate_key] = lightuserdata(&wxLuaState)
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_wxluastate_key;
// The key in the LUA_REGISTRYINDEX table that has a wxLuaStateData class
//   lightuserdata value for the wxLuaState.
// LUA_REGISTRYINDEX[&wxlua_lreg_wxluastatedata_key] = lightuserdata(&wxLuaStateData)
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_wxluastatedata_key;

// The key in the LUA_REGISTRYINDEX table that is a table of lightuserdata
//   wxLuaBindings and the ref to the Lua table they were installed into.
// LUA_REGISTRYINDEX[&wxlua_lreg_wxluabindings_key] = {lightuserdata(&wxLuaBinding) = wxlua_lreg_refs_key ref#, ...}
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_wxluabindings_key;
// The key in the LUA_REGISTRYINDEX table that is a lookup table of string
//   C++ classname keys and lightuserdata pointers to the associated wxLuaBindClass struct.
// LUA_REGISTRYINDEX[&wxlua_lreg_debug_refs_key][wxLuaBindClass.name] = lightuserdata(&wxLuaBindClass)
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_classes_key;
// The key in the LUA_REGISTRYINDEX table that is a numerically keyed table indexed
//   on the wxLua types where each item is a userdata metatable for a C++ class.
// Note: The wxLua types WXLUA_TXXX that correspond to the Lua LUA_TXXX types
//   are not stored in this table since they do not use our metatables.
//   The keys in this table are all > 1. They values are either tables or 0
//   if the wxLuaBinding containing the wxLua type was not registered.
// LUA_REGISTRYINDEX[&wxlua_lreg_types_key][wxLua type number] = { metatable for a C++ class }
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_types_key;

// The key in the LUA_REGISTRYINDEX table that is a table of all
//   objects that we've pushed into Lua using wxluaT_pushuserdatatype().
// Note: A single object like a wxWindow may be pushed with multiple wxLua types.
//   e.g. wxWindow* w = wx.wxWindow() retrieve the window later from wxObject* wxEvent:GetEventObject()
// LUA_REGISTRYINDEX[&wxlua_lreg_weakobjects_key][lightuserdata(obj_ptr)] =
//     { wxLua type1 = weak fulluserdata, wxLua type2 = weak fulluserdata... }
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_weakobjects_key;
// The key in the LUA_REGISTRYINDEX table that is a table of all
//   objects to delete that were added using wxluaO_addgcobject().
// LUA_REGISTRYINDEX[&wxlua_lreg_gcobjects_key][lightuserdata(obj_ptr)] =
//     integer wxLua type
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_gcobjects_key;

// The key in the LUA_REGISTRYINDEX table that is a table
//   of Lua objects/functions assigned to wxLua userdata programatically in Lua.
// LUA_REGISTRYINDEX[&wxlua_lreg_derivedmethods_key][lightuserdata(obj_ptr)] =
//    {["derived func/value name"] = wxLuaObject(Lua function/value), ...}
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_derivedmethods_key;
// The key in the LUA_REGISTRYINDEX table that is a table of all
//   wxLuaEventCallbacks that we've created.
// LUA_REGISTRYINDEX[&wxlua_lreg_evtcallbacks_key][lightuserdata(&wxLuaEventCallback)] =
//     lightuserdata(&wxEvtHandler)
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_evtcallbacks_key;
// The key in the LUA_REGISTRYINDEX table that is a table of wxWindow keys and
//   wxLuaWinDestroyCallback values that we've created.
// LUA_REGISTRYINDEX[&wxlua_lreg_windestroycallbacks_key][lightuserdata(&wxWindow)] =
//    lightuserdata(wxLuaWinDestroyCallback)
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_windestroycallbacks_key;
// The key in the LUA_REGISTRYINDEX table that is a table of all
//   top level wxWindows that we've created and need to destroy when closed.
// LUA_REGISTRYINDEX[&wxlua_lreg_topwindows_key][lightuserdata(&wxWindow)] = 1
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_topwindows_key;
// The key in the LUA_REGISTRYINDEX table that has a boolean value
//   of whether the Lua code has prepended a '_' to function name to indicate
//   that they want the base class function called.
// LUA_REGISTRYINDEX[&wxlua_lreg_callbaseclassfunc_key] = true/false
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_callbaseclassfunc_key;
// The key in the LUA_REGISTRYINDEX table that has a wxEventType (integer) value
//   of the current wxEvent is that is being run or wxEVT_NULL if not in an event.
// LUA_REGISTRYINDEX[&wxlua_lreg_wxeventtype_key] = wxEventType (wxEVT_NULL)
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_wxeventtype_key;

// The key in the LUA_REGISTRYINDEX table that is a numerically keyed table
//   with references to Lua objects we want to keep a handle to. The object could be
//   anything, a table, function, number, string, userdata...
// LUA_REGISTRYINDEX[&wxlua_lreg_refs_key][ref number] = Lua object
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_refs_key;
// The key in the LUA_REGISTRYINDEX table that is a numerically keyed table
//   with references to objects the wxLuaDebugData wants to keep a handle to by
//   storing their value for lookup. It is used only for the wxLuaDebugData.
// LUA_REGISTRYINDEX[&wxlua_lreg_debug_refs_key][ref number] = Lua object
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_lreg_debug_refs_key;

// ----------------------------------------------------------------------------
// wxLua userdata metatable structure:
// {
//    lightuserdata(&wxlua_metatable_type_key) = wxLua type number in wxlua_lreg_types_key table
//    lightuserdata(&wxlua_metatable_wxluabindclass_key) = lightuserdata(&wxLuaBindClass)
//    __gc       = function(wxlua_wxLuaBindClass__gc)
//    __index    = function(wxlua_wxLuaBindClass__index)
//    __newindex = function(wxlua_wxLuaBindClass__newindex)
//    __tostring = function(wxlua_wxLuaBindClass__tostring)
// }

// Light userdata used as keys in the metatables created for the class userdata objects.
// Note that even though these keys have values, they're not used, just the memory address.

// The key of a metatable used for wxLua userdata that is the wxLua type number in the
//   wxlua_lreg_types_key table this metatable is for.
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_metatable_type_key;
// The key of a metatable used for wxLua userdata that stores a lightuserdata
//   of the wxLuaBindClass struct for this class.
extern WXDLLIMPEXP_DATA_WXLUA(const char*) wxlua_metatable_wxluabindclass_key;

// ----------------------------------------------------------------------------
// Create one of the wxlua_lreg_XXX_key tables in the LUA_REGISTRYINDEX and
//   properly set the wxlua_lreg_regtablekey_key too.
WXDLLIMPEXP_WXLUA void wxlua_lreg_createtable(lua_State* L, void* lightuserdata_reg_key, int narr = 0, int nrec = 0);

// ----------------------------------------------------------------------------
// The functions below are Lua C helper functions, some are also part of the wxLuaState
// and you are recommended to use those if the wxLuaState is required. However
// in some cases it may not be necessary to create a wxLuaState and just
// calling these functions will suffice. Only the functions that do not
// require the internal data from the wxLuaState are separated here.
// ----------------------------------------------------------------------------

// Translate the LUA_ERRXXX integers into a human readable string.
//   returns an empty string for an input of 0.
WXDLLIMPEXP_WXLUA wxString wxlua_LUA_ERR_msg(int LUA_ERRx);

// Get information from the return value of lua_pcall(), luaL_loadbuffer(), etc
//   The errMsg input is filled with wxlua_LUA_ERR_msg() and if the current top
//   is > than top it tries to get Lua's error string from the top of the stack.
// Returns true if the input status != 0 and the errMsg and line_num are filled.
// If errMsg and line_num aren't NULL then fill them with the msg and line.
// status is the return from lua_pcall(), luaL_loadbuffer(), etc, LUA_ERRxxx
// top is the lua_gettop from before the call that may have generated the error.
WXDLLIMPEXP_WXLUA bool wxlua_errorinfo(lua_State* L, int status, int top, wxString* errMsg = NULL, int* line_num = NULL);


// Push the errorMsg on the stack and call luaL_error()
WXDLLIMPEXP_WXLUA void LUACALL wxlua_error(lua_State* L, const char* errorMsg);
wxLUA_UNICODE_ONLY(WXDLLIMPEXP_WXLUA inline void LUACALL wxlua_error(lua_State* L, const wxString& errorMsg) { wxlua_error(L, wx2lua(errorMsg)); })

// Create an error message that the item at the stack_idx is not correct for a
//   function call and call wxlua_argerrormsg().
// The expectedType string should tell the user what is valid input and is a
//   string to be flexible for multiple valid types.
// The error message format is:
// "wxLua: Expected %s for parameter %d, but got a '%s'.", expectedType.c_str(), stack_idx, argType.c_str()
// Typical expectedType strings would be wxT("a 'number'")
WXDLLIMPEXP_WXLUA void LUACALL wxlua_argerror(lua_State *L, int stack_idx, const wxString& expectedType);
// Create an error message for an incorrect function call and call wxlua_error().
// The message created has this format:
//    msg
//    "functionNameCalled(argName1, argName2, ...)"         <-- from wxlua_getLuaArgsMsg()
//    "01. functionName(validArgName1, validArgName2, ...)" <-- from wxlua_getBindMethodArgsMsg()
//    "02. ..."
WXDLLIMPEXP_WXLUA void LUACALL wxlua_argerrormsg(lua_State *L, const wxString& msg);

// Get the userdata at the stack index, if null_ptr then set the pointer wrapped
//   by Lua's userdata to NULL to clear it.
WXDLLIMPEXP_WXLUA void* LUACALL wxlua_touserdata(lua_State* L, int stack_idx, bool null_ptr = false);

//----------------------------------------------------------------------------
// wxluaR_XXX - functions operate on the tables in Lua's LUA_REGISTRYINDEX which
// are keyed on lightuserdata that use the luaL_ref() integer reference mechanism
// to store objects. The 'R' stands for Registry or Reference.
//
// Possible values for the "void* lightuserdata_reg_key" are
//   &wxlua_lreg_types_key, &wxlua_lreg_refs_key, &wxlua_lreg_debug_refs_key
//   unless you are using these functions for your own table in the LUA_REGISTRYINDEX.
//----------------------------------------------------------------------------

// Create a reference to the object at stack index in a table with the key
//   lightuserdata_reg_key in the LUA_REGISTRYINDEX table. Does not pop the object.
// Returns the table index or LUA_REFNIL if the item on the stack is none or nil (an error).
WXDLLIMPEXP_WXLUA int LUACALL wxluaR_ref(lua_State* L, int stack_idx, void* lightuserdata_reg_key);
// Remove a reference to the object at the index in a table with the key
//   lightuserdata_reg_key in the LUA_REGISTRYINDEX table, returns success.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaR_unref(lua_State* L, int wxlref_idx, void* lightuserdata_reg_key);
// Push onto the top of the stack the object at the index in a table with the key
//   lightuserdata_reg_key in the LUA_REGISTRYINDEX table, if the index is LUA_REFNIL or the
//   value is nil it returns false and doesn't leave anything on the stack.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaR_getref(lua_State* L, int wxlref_idx, void* lightuserdata_reg_key);
// Is the item at the stack_idx in the table with the key lightuserdata_reg_key
//   in the LUA_REGISTRYINDEX table. Returns the ref index or LUA_NOREF if it's not.
WXDLLIMPEXP_WXLUA int LUACALL wxluaR_isrefed(lua_State* L, int stack_idx, void* lightuserdata_reg_key);

//----------------------------------------------------------------------------
// wxluaO_XXX - functions operate on wxLua "Objects" which are userdata wrapping
// C++ class objects and are stored in the wxlua_lreg_weakobjects_key
// and the wxlua_lreg_gcobjects_key table in the LUA_REGISTRYINDEX.
//----------------------------------------------------------------------------

enum wxLuaGCObject_Flags
{
    WXLUA_DELETE_OBJECT_LAST = 0x0000, // Delete the object only if this is the
                                       // last userdata referece to it.

    WXLUA_DELETE_OBJECT_ALL  = 0x0001, // Delete the object and clear all
                                       // userdata references to it.
};

// Track this object and delete it when Lua calls the __gc method for it.
// The object is stored in the wxlua_lreg_gcobjects_key of the LUA_REGISTRYINDEX.
//   Note that the Lua userdata internal pointer is to the obj_ptr.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaO_addgcobject(lua_State* L, void* obj_ptr, int wxl_type);
// Remove the wxLua object wrapped in a Lua userdata at the stack index from the
//   wxlua_lreg_gcobjects_key table of the LUA_REGISTRYINDEX.
// It is deleted depending on the flags enum wxLuaGCObject_Flags.
// If flags = WXLUA_DELETE_OBJECT_ALL or if this is the last userdata it will also remove all
//   wxlua_lreg_weakobjects_key and wxlua_lreg_derivedmethods_key since the object is gone.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaO_deletegcobject(lua_State *L, int stack_idx, int flags);
// Remove this obj_ptr from the wxlua_lreg_gcobjects_key table of the
//   LUA_REGISTRYINDEX. The Lua userdata for the object stays in Lua and it's
//   assumed that someone else will delete the object (took ownership of it).
WXDLLIMPEXP_WXLUA bool LUACALL wxluaO_undeletegcobject(lua_State *L, void *obj_ptr);
// Check if this obj_ptr is in the wxlua_lreg_gcobjects_key table of the
//   LUA_REGISTRYINDEX.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaO_isgcobject(lua_State *L, void *obj_ptr);
// Get a wxArrayString of the info in the wxlua_lreg_gcobjects_key LUA_REGISTRYINDEX table.
// Strings are of the form "ClassName(&obj)"
WXDLLIMPEXP_WXLUA wxArrayString LUACALL wxluaO_getgcobjectinfo(lua_State *L);

// Track the obj_ptr and its Lua userdata at udata_stack_idx which is of the
//   wxLua type in the wxlua_lreg_weakobjects_key table of the
//   LUA_REGISTRYINDEX so we can push it again if needed.
WXDLLIMPEXP_WXLUA void LUACALL wxluaO_trackweakobject(lua_State *L, int udata_stack_idx, void *obj_ptr, int wxl_type);
// Remove the obj_ptr key from the wxlua_lreg_weakobjects_key table of
//   the LUA_REGISTRYINDEX. It removes the metatable for the single Lua userdata,
//   "udata", since this function is called before the object is deleted.
//   e.g. p1 = wx.wxPoint(); p2 = p1; p2:delete(); p1:SetX(5) errors, but doesn't segfault.
// If udata == NULL it removes ALL tracked userdata for this obj_ptr and clears
//   all of their metatables.
WXDLLIMPEXP_WXLUA int LUACALL wxluaO_untrackweakobject(lua_State *L, void* udata, void *obj_ptr);
// Check if this object with the given wxLua type is in the wxlua_lreg_weakobjects_key
//   table of the LUA_REGISTRYINDEX.
// If the object is found with the right wxLua type and push_on_stack is true
//   the Lua userdata for the object is pushed on top of the stack. If it's not
//   found then it returns false and nothing is left on the stack.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaO_istrackedweakobject(lua_State *L, void *obj_ptr, int wxl_type, bool push_on_stack);
// Get a wxArrayString of the info in the wxlua_lreg_weakobjects_key LUA_REGISTRYINDEX table.
// Strings are of the form "&obj_ptr = wxLuaTypeName1(&udata, type=wxLuaType), ..."
// If the object is casted to multiple types there will be wxLuaTypeName2(...) and so on.
WXDLLIMPEXP_WXLUA wxArrayString LUACALL wxluaO_gettrackedweakobjectinfo(lua_State *L);

//----------------------------------------------------------------------------
// wxluaW_XXX - functions operate on tracked wxWindows stored in the
// wxlua_lreg_topwindows_key in Lua's LUA_REGISTRYINDEX.
//----------------------------------------------------------------------------

// Add the wxObject which is presumably a wxWindow (this function checks)
//   to the wxlua_lreg_topwindows_key table of the LUA_REGISTRYINDEX table if
//   it has not already been added.
WXDLLIMPEXP_WXLUA void LUACALL wxluaW_addtrackedwindow(lua_State *L, wxObject* wxobj);
// Remove the wxWindow from the wxlua_lreg_topwindows_key table of the
//   LUA_REGISTRYINDEX table.
WXDLLIMPEXP_WXLUA void LUACALL wxluaW_removetrackedwindow(lua_State *L, wxWindow* win);
// Is this wxWindow or one of its parents already added to the
//   wxlua_lreg_topwindows_key table of the LUA_REGISTRYINDEX table?
WXDLLIMPEXP_WXLUA bool LUACALL wxluaW_istrackedwindow(lua_State *L, wxWindow* win, bool check_parents);
// Get a wxArrayString of the info in the wxlua_lreg_topwindows_key LUA_REGISTRYINDEX table.
// Strings are of the form "ClassName(&win id=wxWindowID)"
WXDLLIMPEXP_WXLUA wxArrayString LUACALL wxluaW_gettrackedwindowinfo(lua_State *L);

//----------------------------------------------------------------------------
// wxluaT_XXX - functions operate on wxLua types which are integers.
// wxLua types for C++ classes are positive and the userdata metatables are
// stored in the wxlua_lreg_types_key table in Lua's LUA_REGISTRYINDEX.
// wxLua types matching LUA_TXXX types are negative, see WXLUA_TXXX.
//----------------------------------------------------------------------------

// Allocate a new table (a metatable for a userdata) with a
//   wxlua_metatable_type_key key equal to the input wxl_type and
//   store it in the wxlua_lreg_types_key LUA_REGISTRYINDEX table.
// Returns the index into the wxLua types table which is a new wxLua type.
// Leaves the new table on the top of the stack.
WXDLLIMPEXP_WXLUA int LUACALL wxluaT_newmetatable(lua_State* L, int wxl_type);
// Get the metatable for the wxLua type stored in the
//   wxlua_lreg_types_key LUA_REGISTRYINDEX table.
// Returns true if the type's metatable was found and is on the stack, nothing
//   is left on the stack on failure.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaT_getmetatable(lua_State* L, int wxl_type);
// Set the metatable of the userdata at top of stack to the table stored in the
//   wxlua_lreg_types_key LUA_REGISTRYINDEX table.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaT_setmetatable(lua_State* L, int wxl_type);

// Get the numeric wxLua type of the item at the stack index.
// This is the wxLua equivalent of lua_type() but instead of returning
//   LUA_TXXX it returns WXLUA_TXXX for standard types.
// If the object is a userdata it checks the metatable for the
//   wxlua_metatable_type_key to get the wxLua type where the type is
//   presumedly the index into the wxlua_lreg_types_key of the LUA_REGISTRYINDEX
//   table and denotes what type of C++ object this is.
// Returns WXLUA_TUNKNOWN on failure.
WXDLLIMPEXP_WXLUA int LUACALL wxluaT_type(lua_State* L, int stack_idx);

// Get a human readable name for the predefined WXLUA_TXXX or binding
//   wxluatype_XXX wxLua types stored in the wxlua_lreg_types_key
//   of the LUA_REGISTRYINDEX table.
// This is the wxLua equivalent of lua_typename(L, luatype).
// If the lua_State is not NULL then if the type is a wxLua type for classes
//   return the C++ class/struct name.
// Returns empty string if the type is unknown.
WXDLLIMPEXP_WXLUA wxString LUACALL wxluaT_typename(lua_State* L, int wxl_type);
// Get a human readable name for the item at the stack index.
// This is the wxLua equivalent of luaL_typename(L, stack_idx).
// This function calls wxluaT_typename(L, wxluaT_type(L, stack_idx)) and is a
//   convenience function.
WXDLLIMPEXP_WXLUA wxString LUACALL wxluaT_gettypename(lua_State* L, int stack_idx);
// Get the luaL_typename(L, stack_idx) == lua_typename(lua_type(L, stack_idx)) as a wxString.
// Returns one of the LUA_TXXX values.
WXDLLIMPEXP_WXLUA wxString LUACALL wxlua_luaL_typename(lua_State* L, int stack_idx);

// Get the wxLua type for the class or struct with the given name
WXDLLIMPEXP_WXLUA int LUACALL wxluaT_gettype(lua_State* L, const char* name);
// Get the wxLuaBindClass* for this wxLua type or NULL if the type is invalid.
// Gets the wxLuaBindClass from the metatable stored in the wxlua_lreg_types_key registry table
//   for the classes that have been installed into Lua.
WXDLLIMPEXP_WXLUA const wxLuaBindClass* LUACALL wxluaT_getclass(lua_State* L, int wxl_type);
// Get the wxLuaBindClass* for this class_name or NULL if the name is invalid.
// Gets the wxLuaBindClass from the wxlua_lreg_classes_key table in the LUA_REGISTRYINDEX.
WXDLLIMPEXP_WXLUA const wxLuaBindClass* LUACALL wxluaT_getclass(lua_State* L, const char* class_name);

// Is the item at stack_idx of the userdata type or derived from the the given wxLua type.
WXDLLIMPEXP_WXLUA bool wxluaT_isuserdatatype(lua_State* L, int stack_idx, int wxl_type);
// Get the userdata object at the stack_idx that is of the wxLua class type or a
//   class derived from the wxLua type. If the userdata does not have the correct type,
//   or if the parameter isn't a userdata then wxlua_error() is called and NULL is returned.
WXDLLIMPEXP_WXLUA void* LUACALL wxluaT_getuserdatatype(lua_State* L, int stack_idx, int wxl_type);
// Push the obj_ptr onto the top of the stack wrapped in a newuserdata
//   with its metatable set to the table from wxluaR_getref(L, wxl_type, &wxlua_lreg_types_key).
// Returns true if the wxLua type is known, the metatable set, and it's on the stack, nothing
//   is pushed on the stack if this returns false.
// If the wxLua type is derived from the wxWindow type it will be added to the
//   wxlua_lreg_windestroycallbacks_key table.
// If track=true then push the obj_ptr as a lightuser data key into the
//   wxlua_lreg_weakobjects_key table of the Lua LUA_REGISTRYINDEX table so
//   that if we need to push it again we just push the already created full userdata value.
WXDLLIMPEXP_WXLUA bool LUACALL wxluaT_pushuserdatatype(lua_State* L, const void *obj_ptr, int wxl_type, bool track = true, bool allow_NULL = false);

// ----------------------------------------------------------------------------
// Functions to get info about the wxLua types.
// Used to determine what to expect for a function call in the bindings.
// ----------------------------------------------------------------------------

// Is a class with the wxl_type equal to or derived from a class with the base_wxl_type.
//   Optional input baseclass_n is set to the highest multiple baseclass level, where
//     0 means that inheritance from wxl_type to base_wxl_type is always the first
//     base class, a 1 or higher means that wxl_type is derived from the second or higher
//     base class somewhere along the inheritance chain.
//   return of 0 means same class, +1 means base is parent, +2 base is grandparent, ...
//   returns -1 if the wxLua type is not derived from the base type.
WXDLLIMPEXP_WXLUA int LUACALL wxluaT_isderivedtype(lua_State* L, int wxl_type, int base_wxl_type, int* baseclass_n = NULL);
// Same as above, but works directly with the wxLuaBindClasses.
WXDLLIMPEXP_WXLUA int LUACALL wxluaT_isderivedclass(const wxLuaBindClass* wxlClass, const wxLuaBindClass* base_wxlClass, int* baseclass_n = NULL);
// Verify if the luatype = lua_type(L, stack_idx) is valid for the
//   wxl_type which is one of the predefined WXLUA_TXXX or s_wxluaarg_XXX types.
// Returns 1 if it matches, 0 if it doesn't, -1 if the wxl_type is not known.
// Note that this function does not do a direct mapping between wxlua_luatowxluatype()
//   and wxlua_wxluatoluatype() since it allows a small amount of coersion between types.
// If the input lua_State is not NULL it will account for the automatic conversion of
//   (wxString, wxArrayString, wxArrayInt) from the Lua type to wxLua type.
WXDLLIMPEXP_WXLUA int LUACALL wxlua_iswxluatype(int luatype, int wxl_type, lua_State* L = NULL);
// Get the wxLua type for the lua_type() = LUA_TXXX, returns -1 if unknown.
WXDLLIMPEXP_WXLUA int wxlua_luatowxluatype(int luatype);
// Get the lua_type() = LUA_TXXX for the predefined WXLUA_TXXX types.
//   returns -1 (LUA_TNONE) if the type was not one of the predefined types.
WXDLLIMPEXP_WXLUA int wxlua_wxluatoluatype(int wxluatype);

// Is the object at the stack_idx a userdata object that wxLua has pushed into Lua?
//   This should be the same as
//   (lua_isuserdata(L, stack_idx) && !lua_islightuserdata(L, stack_idx))
#define wxlua_iswxuserdata(L, stack_idx) (lua_type((L), (stack_idx)) == LUA_TUSERDATA)

// Helper functions to get numbers, booleans and strings safer.
// These validate that the object at the stack index specified is a string, bool,
//   int, or double number object or that the object can be converted to it.
// Note: wxLua has a stricter sense of type than Lua and we don't want to
//       always allow coersion between types since oftentimes there's an error.
WXDLLIMPEXP_WXLUA bool wxlua_iswxstringtype(lua_State* L, int stack_idx);
#define wxlua_isstringtype(L, stack_idx)  (wxlua_iswxluatype(lua_type(L, stack_idx), WXLUA_TSTRING) == 1)
#define wxlua_isbooleantype(L, stack_idx) (wxlua_iswxluatype(lua_type(L, stack_idx), WXLUA_TBOOLEAN) == 1)
#define wxlua_isintegertype(L, stack_idx) (wxlua_iswxluatype(lua_type(L, stack_idx), WXLUA_TINTEGER) == 1)
#define wxlua_isnumbertype(L, stack_idx)  (wxlua_iswxluatype(lua_type(L, stack_idx), WXLUA_TNUMBER) == 1)
#define wxlua_ispointertype(L, stack_idx) (wxlua_iswxluatype(lua_type(L, stack_idx), WXLUA_TPOINTER) == 1)

// After verifying using wxlua_isXXXtype return the value, else call
//   wxlua_error() with a message that is appropriate for stack_idx to be a
//   parameter to a function call. (These are used in the bindings)
// Note: The function wxLuaState::GetwxStringType does automatic conversion
//       of both a Lua string and a userdata wxString to a wxString.
WXDLLIMPEXP_WXLUA const char* LUACALL wxlua_getstringtype(lua_State* L, int stack_idx);
WXDLLIMPEXP_WXLUA wxString LUACALL    wxlua_getwxStringtype(lua_State* L, int stack_idx);
WXDLLIMPEXP_WXLUA bool LUACALL        wxlua_getbooleantype(lua_State* L, int stack_idx);
WXDLLIMPEXP_WXLUA long LUACALL        wxlua_getenumtype(lua_State* L, int stack_idx);
WXDLLIMPEXP_WXLUA long LUACALL        wxlua_getintegertype(lua_State* L, int stack_idx);
WXDLLIMPEXP_WXLUA unsigned long LUACALL wxlua_getuintegertype(lua_State* L, int stack_idx);
WXDLLIMPEXP_WXLUA double LUACALL      wxlua_getnumbertype(lua_State* L, int stack_idx);
WXDLLIMPEXP_WXLUA void* LUACALL       wxlua_getpointertype(lua_State* L, int stack_idx);


// Helper functions to get/set tables of strings and ints
// Validate that the object at the stack index specified is a table object.
// This assumes that each table array entry is a string/number
//   or can be converted to a string/number using the
//   wxlua_isstring/numbertype definitions of what is a string/number.

// Convert the table at stack index to a "new" array of const char* strings.
// Return a pointer to the array of strings. You need to delete the array, but not
//   the individual strings since Lua should still have them during the life of the
//   returned array, if not you will need to copy them.
// Returns the number of character strings in the array in count.
// See usage in the wxBitmap constructor for XPMs.
WXDLLIMPEXP_WXLUA const char** LUACALL wxlua_getchararray(lua_State* L, int stack_idx, int& count);

// Convert a table array or a wxArrayString at the stack_idx to an array of wxStrings.
// If it's a table, it must have integer keys and string or wxString values.
// Returns a pointer to a new array of wxStrings and set the size in count.
// You must delete the return value if not NULL.
WXDLLIMPEXP_WXLUA wxString* LUACALL wxlua_getwxStringarray(lua_State* L, int stack_idx, int& count);
// Convert a table array or a wxArrayInt at the stack_idx to an array of integers.
// If it's a table, it must have integer keys and values.
// Returns a pointer to a new array of ints and set the size in count
// You must delete the return value if not NULL.
WXDLLIMPEXP_WXLUA int* LUACALL wxlua_getintarray(lua_State* L, int stack_idx, int& count);

// Convert a table array or a wxArrayString object at the stack_idx to a wxArrayString.
// If it's a table, it must have integer keys and string or wxString values.
WXDLLIMPEXP_WXLUA wxLuaSmartwxArrayString LUACALL wxlua_getwxArrayString(lua_State* L, int stack_idx);
// Convert a table array or a wxSortedArrayString object at the stack_idx to a wxSortedArrayString.
// If it's a table, it must have integer keys and string or wxString values.
WXDLLIMPEXP_WXLUA wxLuaSmartwxSortedArrayString LUACALL wxlua_getwxSortedArrayString(lua_State* L, int stack_idx);
// Convert a table array or a wxArrayInt object at the stack_idx to a wxArrayInt.
// If it's a table, it must have integer keys and values.
WXDLLIMPEXP_WXLUA wxLuaSmartwxArrayInt LUACALL wxlua_getwxArrayInt(lua_State* L, int stack_idx);


// Creates a Lua table array and pushes Lua strings into it, returns the number of items added.
//   The table is left on the stack.
WXDLLIMPEXP_WXLUA int LUACALL wxlua_pushwxArrayStringtable(lua_State* L, const wxArrayString& strArray);
// Creates a Lua table array and pushes the integers into it, returns the number of items added.
//   The table is left on the stack.
WXDLLIMPEXP_WXLUA int LUACALL wxlua_pushwxArrayInttable(lua_State* L, const wxArrayInt& intArray);
// Push the wxString into Lua after converting it.
WXDLLIMPEXP_WXLUA void LUACALL wxlua_pushwxString(lua_State* L, const wxString& str);

// Helper function to concatenate a wxArrayString into a wxString.
WXDLLIMPEXP_WXLUA wxString wxlua_concatwxArrayString(const wxArrayString& arr, const wxString& sep = wxT("\n"));


// Push the program args into a global table called "args" as the Lua executable does.
//   start_n is the arg to start pushing until max args "argc".
//   returns the number of args pushed.
WXDLLIMPEXP_WXLUA int wxlua_pushargs(lua_State* L, wxChar **argv, int argc, int start_n);

//----------------------------------------------------------------------------
// Derived class member functions for classes in wxLua. The data is stored
// in the wxlua_lreg_derivedmethods_key table in the LUA_REGISTRYINDEX.
//----------------------------------------------------------------------------

// Add this derived method, a Lua function or value the user has set to a
//   wxLua userdata object that we will push onto the stack when they access
//   the __index of the object with the "method_name". The obj_ptr is the
//   object the Lua userdata stores and the new wxLuaObject wraps the Lua
//   function or value which will be deleted by wxLua when the userdata is deleted.
WXDLLIMPEXP_WXLUA bool LUACALL wxlua_setderivedmethod(lua_State* L, void *obj_ptr, const char *method_name, wxLuaObject* wxlObj);
// Is there a derived method for the given obj_ptr with the method_name that was
//   added by calling wxlua_setderivedmethod()?
// If push_method then push the method onto the stack.
WXDLLIMPEXP_WXLUA bool LUACALL wxlua_hasderivedmethod(lua_State* L, const void *obj_ptr, const char *method_name, bool push_method);
// Remove any derived functions or values for the obj_ptr that have been added with
//   wxlua_setderivedmethod().
// This is called when an object is being garbage collected by wxluaO_deletegcobject()
//   and probably shouldn't be called otherwise.
WXDLLIMPEXP_WXLUA bool LUACALL wxlua_removederivedmethods(lua_State* L, void *obj_ptr);

//----------------------------------------------------------------------------
// Other functions for wxLua's keys in the LUA_REGISTRYINDEX
//----------------------------------------------------------------------------

// Get the wxlua_lreg_callbaseclassfunc_key value of the LUA_REGISTRYINDEX table
//   to determines whether a virtual C++ class member function should call its own
//   base class function or a wxLua derived method if it exists.
WXDLLIMPEXP_WXLUA bool LUACALL wxlua_getcallbaseclassfunction(lua_State* L);
// Set if the class member function call in Lua has a prepended '_' to imply that
//   the user wants the base class function and not the derived method in the
//   wxlua_lreg_derivedmethods_key table.
// Sets the wxlua_lreg_callbaseclassfunc_key value of the LUA_REGISTRYINDEX table.
WXDLLIMPEXP_WXLUA void LUACALL wxlua_setcallbaseclassfunction(lua_State* L, bool call_base);

// Get the wxlua_lreg_wxeventtype_key value of the LUA_REGISTRYINDEX table
//   to see if we're currently in a wxEvent callback.
// Returns wxEVT_NULL if not in an event handler.
// Be careful about destroying Lua when in an event handler.
WXDLLIMPEXP_WXLUA wxEventType LUACALL wxlua_getwxeventtype(lua_State* L);
// Set the wxlua_lreg_wxeventtype_key value of the LUA_REGISTRYINDEX table
//   with the current wxEventType we're in or wxEVT_NULL if none.
WXDLLIMPEXP_WXLUA void LUACALL wxlua_setwxeventtype(lua_State* L, wxEventType evt_type);

// Get the wxlua_lreg_wxluastatedata_key wxLuaStateData value from
//   the LUA_REGISTRYINDEX table for the owner wxLuaState.
// Note: It returns NULL if the lua_State is about to be closed.
WXDLLIMPEXP_WXLUA wxLuaStateData* LUACALL wxlua_getwxluastatedata(lua_State* L);

//----------------------------------------------------------------------------
// wxLuaStateData - the internal data for the wxLuaState.
//   All members of this class should be accessed through the wxLuaState.
//   It is public only for people who need to get at the internals, there are
//   absolutely no guarantees that things won't change.
//----------------------------------------------------------------------------

class WXDLLIMPEXP_WXLUA wxLuaStateData
{
public:
    wxLuaStateData();
    ~wxLuaStateData();

    bool m_is_running;                    // is the lua_State running a script
    bool m_is_closing;                    // are we currently being closed

    int  m_lua_debug_hook_count;          // values from wxLuaState::SetLuaDebugHook()
    int  m_lua_debug_hook_yield;
    int  m_lua_debug_hook;
    bool m_lua_debug_hook_send_evt;

    unsigned long m_last_debug_hook_time; // last time the debug hook was called

    bool     m_debug_hook_break;          // should the lua_State break for next debug_hook
    wxString m_debug_hook_break_msg;      // message when breaking in the debug_hook

    wxEvtHandler *m_evtHandler;           // event handler to send wxLuaEvents to
    wxWindowID    m_id;                   // event id to send the events with
};

//----------------------------------------------------------------------------
// wxLuaStateRefData - the internal data for the wxLuaState.
//                     please use the wxLuaState accessor functions
//----------------------------------------------------------------------------

#include <wx/hashmap.h>
WX_DECLARE_VOIDPTR_HASH_MAP_WITH_DECL(wxLuaState *, wxHashMapLuaState, class WXDLLIMPEXP_WXLUA);

class WXDLLIMPEXP_WXLUA wxLuaStateRefData : public wxObjectRefData
{
public:
    wxLuaStateRefData(bool create_data = true);
    virtual ~wxLuaStateRefData();

    // destroy and cleanup the lua_State, returns success
    // if 'force' = true then make sure all wxWindows are destroyed.
    bool CloseLuaState(bool force);
    // clear all wxLuaEventCallbacks and wxLuaWinDestroyCallbacks on destruction
    void ClearCallbacks();

    // ------------------------------------------------------------------------

    lua_State* m_lua_State;           // the lua_State that "is" Lua
    bool       m_lua_State_static;    // lua_close() the lua_State if !static
    bool       m_lua_State_coroutine; // this is a coroutine, don't close it

    wxLuaStateData* m_wxlStateData;   // the data shared for this state
    bool            m_own_stateData;  // not a coroutine when true, so delete it when done
};

//----------------------------------------------------------------------------
// wxLuaState - a ref counted class to interface between C++ and Lua's C lua_State
//----------------------------------------------------------------------------

// enum wxLuaState_Type is for the functions
//  wxLuaState(lua_State* L, int state_type = wxLUASTATE_GETSTATE)
//  wxLuaState::Create(lua_State* L, int state_type = wxLUASTATE_GETSTATE);
enum wxLuaState_Type
{
    wxLUASTATE_GETSTATE = 1, // Attach to a previously created wxLuaState's
                             //   lua_State refing the existing wxLuaStateRefData

    wxLUASTATE_SETSTATE = 2, // Set the lua_State for the wxLuaState.
                             // Does not call lua_openlibs() so you should have
                             //   called before setting it to the wxLuaState.

    // The values below are to be ored with wxLUASTATE_GETSTATE only.
    wxLUASTATE_ROOTSTATE    = 0x10, // Get the root lua_State, the owner of a
                                    //   coroutine state, uses given lua_State
                                    //   if not coroutine.

    // The values below are to be ored with wxLUASTATE_SETSTATE only.
    wxLUASTATE_STATICSTATE  = 0x20, // The lua_State is static and the wxLuaState
                                    //   will not lua_close() it when Destroy()ed.
    wxLUASTATE_OPENBINDINGS = 0x40  // Install all the bindings in
                                    //   wxLuaBinding::GetBindingList() into the
                                    //   lua_State. You may install the bindings
                                    //   one at a time using
                                    //   wxLuaState::RegisterBinding(wxLuaBinding*)
};

// an invalid wxLuaState for comparison (like wxNullBitmap)
extern WXDLLIMPEXP_DATA_WXLUA(wxLuaState) wxNullLuaState;

class WXDLLIMPEXP_WXLUA wxLuaState : public wxObject
{
public:
    // Default constructor or if create=true then
    //   call the function Create(wxEvtHandler=NULL, id=wxID_ANY).
    wxLuaState(bool create = false) { if (create) Create(); }
    // Create a new lua_State and add the bindings.
    //   Calls the function Create(wxEvtHandler, id).
    wxLuaState(wxEvtHandler *handler, wxWindowID id = wxID_ANY) { Create(handler, id); }
    // Create a wxLuaState from an existing lua_State.
    //   Calls the function Create(lua_State, state_type), state_type is enum wxLuaState_Type.
    inline wxLuaState(lua_State* L, int state_type = wxLUASTATE_GETSTATE) { Create(L, state_type); }
    // Copy constructor, refs existing wxLuaState
    inline wxLuaState(const wxLuaState& wxlState) { Ref(wxlState); }

    // ALWAYS Destroy() the wxLuaState instead of calling UnRef(), else circular
    //  destruction since ref count goes to 0 before actually destroying the lua_State
    virtual ~wxLuaState() { Destroy(); }

    // -----------------------------------------------------------------------

    // Ref the given wxLuaState
    void Create(const wxLuaState& wxlState);
    // Create a new lua_State and send wxLuaEvents to this handler.
    //   The handler may be NULL to not send events to anyone.
    //   Calls the function Create(lua_State, wxLUASTATE_USESTATE).
    bool Create(wxEvtHandler *handler = NULL, wxWindowID id = wxID_ANY);
    // Create a wxLuaState from an existing lua_State.
    //   See enum wxLuaState_Type for infomation about state_type.
    bool Create(lua_State* L, int state_type = wxLUASTATE_GETSTATE);

    // -----------------------------------------------------------------------

    // Is this wxLuaState valid, has refed data and its lua_State is created
    bool IsOk() const;
    inline bool Ok() const { return IsOk(); }

    // -----------------------------------------------------------------------

    // Destroy the refed data, use this instead of wxObject::UnRef().
    //  Only calls lua_close(L) if this is the last refed state and this was
    //  created without the wxLUASTATE_STATICSTATE flag.
    //  Note: if you have a top level window (wxFrame) open in Lua and exit the
    //  C++ program your program will seem to "hang" because wxApp doesn't
    //  exit with a top level window open. Call CloseLuaState(true) to ensure
    //  all non parented (top level) windows are destroyed.
    //  You must always call CloseLuaState() when you want to close Lua instead
    //  of hoping that when you call Destroy() you have the last refed instance.
    void Destroy();
    // Close the lua_State and if 'force' close all attached wxWindows
    //   if !force then popup a dialog to ask if all wxWindows should be destroyed.
    // Only calls lua_close(L) if this is the last refed state and this was
    //  created without the wxLUASTATE_STATICSTATE flag.
    bool CloseLuaState(bool force);
    // Are we currently being closed? Used when the garbage collector is running when
    //  we don't care about cleaning Lua up so just delete the data. (internal use)
    bool IsClosing() const;

    // -----------------------------------------------------------------------

    // Get the lua_State
    lua_State* GetLuaState() const;
    // Get the ref data (internal use)
    wxLuaStateRefData* GetLuaStateRefData() const { return (wxLuaStateRefData*)GetRefData(); }
    // Get the data for the lua_State in the ref data (internal use)
    wxLuaStateData* GetLuaStateData() const;

    // -----------------------------------------------------------------------

    // Get the wxLuaState from the corresponding lua_State
    // If get_root_state and L is a coroutine then return the wxLuaState
    // for the parent lua_State of the coroutine, else just return the wxLuaState for L.
    //  returns wxNullLuaState if none found.
    static wxLuaState GetwxLuaState(lua_State* L, bool get_root_state);
    // A mapping between hashmap[lua_State* L] = wxLuaState*
    // Note: The hashed new wxLuaState is not Refed since we want to know when
    //       the ref count goes to 1 for cleanup and it is deleted when
    //       its wxLuaStateRefData is finally deleted.
    // Note: The coroutine lua_States are not hashed since we cannot know when
    //       they are created or deleted. We must create wxLuaStates for them on the fly.
    static wxHashMapLuaState s_wxHashMapLuaState;

    // -----------------------------------------------------------------------

    // In order for wxLua scripts to work from a C++ program's wxApp::OnInit()
    //   and the Lua module you may have to set this variable to force the wxLua
    //   code "wx.wxGetApp:MainLoop()" to not call wxApp::MainLoop().
    // The issue is that within the function wxApp::OnInit() wxApp::IsMainLoopRunning()
    //   returns false, but it will be running after OnInit() returns so we should
    //   silently ignore the Lua code wanting to prematurely start the MainLoop.
    // Initialized to false, meaning not set.
    // Set to true for the Lua code "wx.wxGetApp:MainLoop()" to not call
    //   the app's MainLoop() function.
    //
    // See the wxLua apps for usage.
    static bool sm_wxAppMainLoop_will_run;

    // -----------------------------------------------------------------------

    // Get/Set the event handler that the wxLuaEvents from this will be sent to, can be NULL.
    //  See wxEVT_LUA_XXX for a list of possible events that may be sent.
    void SetEventHandler(wxEvtHandler *evtHandler);
    wxEvtHandler *GetEventHandler() const;
    // Get/Set the wxWindowID that the wxLuaEvents will be sent with.
    void SetId(wxWindowID id);
    wxWindowID GetId() const;

    // Sends the input wxLuaEvent, after checking that this is valid, to the
    //  set wxEventHandler (may be NULL), see constructor or SetEventHandler().
    //  returns wxEvtHandler::ProcessEvent(event)
    bool SendEvent( wxLuaEvent &event ) const;

    // -----------------------------------------------------------------------

    // Run a Lua file from disk using lua_loadfile() then LuaPCall().
    //   Leaves nresults on the stack, use LUA_MULTRET to leave them all.
    //   Returns 0 on success or Lua's error code.
    //   Sends a wxEVT_LUA_ERROR wxLuaEvent on error.
    int RunFile(const wxString &fileName, int nresults = 0);
    // Run a string that contains Lua code using luaL_loadbuffer() then LuaPCall().
    //   Leaves nresults on the stack, use LUA_MULTRET to leave them all.
    //   Returns 0 on success or Lua's error code.
    //   Sends a wxEVT_LUA_ERROR wxLuaEvent on error.
    int RunString(const wxString &script, const wxString& name = wxEmptyString, int nresults = 0);
    // Run a char array #included from bin2c compilation or something else
    //   using luaL_loadbuffer() then LuaPCall().
    //   Leaves nresults on the stack, use LUA_MULTRET to leave them all.
    //   Returns 0 on success or Lua's error code.
    //   Sends a wxEVT_LUA_ERROR wxLuaEvent on error.
    int RunBuffer(const char buf[], size_t size, const wxString &name = wxT("= lua"), int nresults = 0);

    int LuaDoString(const wxString &script, const wxString& name = wxEmptyString, int nresults = 0) { return RunString(script, name, nresults); }
    int LuaDoFile(const wxString &filename, int nresults = 0) { return RunFile(filename, nresults); }
    int LuaDoBuffer(const char *buffer, size_t len, const char *name, int nresults = 0) { return RunBuffer(buffer, len, lua2wx(name), nresults); }

    // Is a program running now, running state is set for Run/File/String/Buffer
    bool IsRunning() const;

    // Replacement for lua_pcall()
    //   Returns 0 on success or Lua's error code.
    //   Sends a wxEVT_LUA_ERROR wxLuaEvent on error.
    //   narg is the number of args to the function to call.
    //   nresults is the number of values expected to be returned and Lua
    //     will adjust the stack to match.
    //     Use LUA_MULTRET for a variable number of returns.
    int LuaPCall(int narg, int nresults);

    //
    bool SendLuaErrorEvent(int status, int top);

    // Get the wxEventType that Lua may currently be in, wxEVT_NULL if not in an
    //   event handler. Be careful about destroying Lua when in an event handler.
    //   See wxlua_getwxeventtype()
    wxEventType GetInEventType() const;
    // Set the wxEventType that the Lua code is currently running (internal use).
    //   See wxlua_setwxeventtype()
    void SetInEventType(wxEventType eventType);

    // -----------------------------------------------------------------------

    // Try to compile the Lua program. Creates new lua_State to test for syntax
    //   errors and sends error events. See wxlua_errorinfo() for errMsg and line_num.
    int CompileString(const wxString &script, const wxString& name = wxEmptyString,
                      wxString* errMsg = NULL, int* line_num = NULL);
    int CompileBuffer(const char buf[], size_t size, const wxString &name = wxEmptyString,
                      wxString* errMsg = NULL, int* line_num = NULL);

    // -----------------------------------------------------------------------

    // Break a currently running Lua program by setting the Lua debug hook to
    //  be called for anything and breaking as soon as possible by calling
    //  wxlua_error() with the message
    void DebugHookBreak(const wxString &message = wxT("Lua interpreter stopped"));
    // Clear a previously set DebugHookBreak(), resetting the debug hook
    //  to the previous values
    void ClearDebugHookBreak();
    // Has DebugHookBreak() been called and we're waiting for the next hook call?
    bool GetDebugHookBreak() const;
    // Get the message that will be sent when from a DebugHookBreak() call
    wxString GetDebugHookBreakMessage() const;

    // Have Lua run an internal hook function with this mask
    //   hook = LUA_MASKCALL | LUA_MASKRET | LUA_MASKLINE | LUA_MASKCOUNT
    // Every count hook mask a wxEVT_LUA_DEBUG_HOOK event is sent if send_debug_evt.
    // If yield_ms > 0 then wxYield is called every yield milliseconds.
    // Turn the hook off with count < 1
    // see lua_sethook() function
    void SetLuaDebugHook(int hook = LUA_MASKCALL|LUA_MASKRET|LUA_MASKLINE|LUA_MASKCOUNT,
                         int count = 1000, int yield_ms = 100,
                         bool send_debug_evt = false);
    int  GetLuaDebugHook() const;
    int  GetLuaDebugHookCount() const;
    int  GetLuaDebugHookYield() const;
    bool GetLuaDebugHookSendEvt() const;

    // Internally updated time that the debug hook was last called when running
    //  Lua code and SetLuaDebugHook is turned on
    unsigned long GetLastLuaDebugHookTime() const;
    // Set to an specific time to control debug timing
    void SetLastLuaDebugHookTime(unsigned long t);

    // -----------------------------------------------------------------------
    // Binding functions

    // Registers a new C function for Lua, see usage in wxlstate.cpp
    void RegisterFunction(lua_CFunction func, const char* funcName);
    wxLUA_UNICODE_ONLY(void RegisterFunction(lua_CFunction func, const wxString &funcName) { RegisterFunction(func, wx2lua(funcName)); })

    // Register a single wxLuaBinding, returns true on success. Nothing is
    //   left on the stack.
    bool RegisterBinding(wxLuaBinding* binding);
    // Register all the bindings in the wxLuaBinding::GetBindingList(), this is done
    //   automatically if the wxLuaState is created with wxLUASTATE_OPENBINDINGS.
    bool RegisterBindings();

    // Get the installed wxLuaBinding with the given
    //   wxLuaBinding::GetBindingName() or NULL for no match.
    // See wxLuaBinding::GetLuaBinding().
    wxLuaBinding* GetLuaBinding(const wxString& bindingName) const;

    // Get wxLuaBindClass for given Lua Tag using wxLuaBindClass::wxluatype,
    //   returns NULL on failure. See wxluaT_getclass().
    const wxLuaBindClass* GetBindClass(int iClassTag) const;
    // Get wxLuaBindClass for given class name using wxLuaBindClass::name,
    //   returns NULL on failure. See wxluaT_getclass().
    const wxLuaBindClass* GetBindClass(const char* className) const;
    // Get the first wxLuaBindClass that has this particular wxLuaBindMethod
    //   returns NULL on failure. See wxLuaBinding::GetBindClass().
    const wxLuaBindClass* GetBindClass(const wxLuaBindMethod* wxlMethod) const;
    // Get the first wxLuaBindClass that has this particular wxLuaBindCFunc in its methods
    //   returns NULL on failure. See wxLuaBinding::GetBindClass().
    const wxLuaBindClass* GetBindClass(const wxLuaBindCFunc* wxlCFunc) const;
    // See wxluaT_isderivedtype().
    int IsDerivedType(int wxl_type, int base_wxl_type, int* baseclass_n) const;

    // See wxlua_setcallbaseclassfunction() and wxlua_getcallbaseclassfunction().
    void SetCallBaseClassFunction(bool call_base);
    bool GetCallBaseClassFunction();

    // -----------------------------------------------------------------------
    // memory tracking functions (internal use)

    // See wxluaO_addgcobject().
    void AddGCObject(void* obj_ptr, int wxl_type);
    // See wxluaO_deletegcobject().
    bool DeleteGCObject(int stack_idx, int flags);
    // See wxluaO_isgcobject().
    bool IsGCObject(void *obj_ptr) const;
    // See wxluaO_getgcobjectinfo().
    wxArrayString GetGCObjectInfo() const;

    // Add a wxWindow to track and delete when we're closed, only track
    //   the parent window, not its children. returns true if it was added.
    // Note: wxObject is used as the base class since we blindly call this
    // function for all objects with classinfo in the bindings and we
    // want to minimize the code in the bindings.
    void AddTrackedWindow(wxObject *win);
    // Don't track this window anymore and don't delete it.
    void RemoveTrackedWindow(wxWindow *win);
    // Is this window tracked, if check_parents see if a parent of it is.
    bool IsTrackedWindow(wxWindow *win, bool check_parents = true) const;
    // Get an array of strings "wxWindow_classname(&win id=wxWindowID)"
    wxArrayString GetTrackedWindowInfo() const;

    // delete all stray wxWindow derived classes that have been destroyed
    //   by wxWidgets (eg. a child window)
    // This function does not need to be called ever, for debugging perhaps?
    void GarbageCollectWindows(bool closeWindows);

    // Add or remove a tracked wxLuaEventCallback connected to a wxEvtHandler
    void AddTrackedEventCallback(wxLuaEventCallback* callback);
    bool RemoveTrackedEventCallback(wxLuaEventCallback* callback);
    // Get an array of strings "wxEVT_XXX (wxEventType #) count#"
    wxArrayString GetTrackedEventCallbackInfo() const;

    // Add or remove a tracked wxLuaWinDestroyCallback connected to wxEVT_DESTROY.
    void AddTrackedWinDestroyCallback(wxLuaWinDestroyCallback* callback);
    bool RemoveTrackedWinDestroyCallback(wxLuaWinDestroyCallback* callback);
    // Get an array of strings "wxWindow_classname count#"
    wxArrayString GetTrackedWinDestroyCallbackInfo() const;

    // -----------------------------------------------------------------------

    // Push the errorMsg on the stack and call wxlua_error()
    void wxlua_Error(const char *errorMsg) const;
    wxLUA_UNICODE_ONLY(void wxlua_Error(const wxString& errorMsg) const { wxlua_Error(wx2lua(errorMsg)); })

    void* wxlua_ToUserdata(int stack_idx, bool null_ptr = false) const;

    // -----------------------------------------------------------------------
    // wxLua Lua Registry Table Functions

    int   wxluaR_Ref(int stack_idx, void* lightuserdata_reg_key);
    bool  wxluaR_Unref(int wxlref_index, void* lightuserdata_reg_key);
    bool  wxluaR_GetRef(int wxlref_index, void* lightuserdata_reg_key);

    int   wxluaT_NewMetatable(int wxl_type);
    bool  wxluaT_SetMetatable(int wxl_type);
    int   wxluaT_Type(int stack_idx) const;

    bool  wxluaT_PushUserDataType(const void *obj_ptr, int wxl_type, bool track);

    // -----------------------------------------------------------------------
    // wxLua get data type

    // See wxlua_iswxluatype().
    int IswxLuaType(int luatype, int wxl_type) const;
    // See wxluaT_isuserdatatype().
    bool IsUserDataType(int stack_idx, int wxl_type) const;
    // See wxluaT_getuserdatatype().
    void* GetUserDataType(int stack_idx, int iTag) const;

    // helper functions to get numbers, booleans and strings safer

    // See wxlua_getstringtype().
    const char* GetStringType(int stack_idx);
    // See wxlua_getwxStringtype().
    wxString GetwxStringType(int stack_idx);
    // See wxlua_getbooleantype().
    bool GetBooleanType(int stack_idx);
    // See wxlua_getintegertype().
    long GetIntegerType(int stack_idx);
    // See wxlua_getnumbertype().
    double GetNumberType(int stack_idx);

    // See wxlua_isXXXtype().
    bool IsStringType(int stack_idx) const;
    bool IswxStringType(int stack_idx) const;
    bool IsBooleanType(int stack_idx) const;
    bool IsIntegerType(int stack_idx) const;
    bool IsNumberType(int stack_idx) const;

    // See wxlua_getwxStringarray().
    wxString* GetwxStringArray(int stack_idx, int &count);
    // See wxlua_getwxArrayString().
    wxLuaSmartwxArrayString GetwxArrayString(int stack_idx);
    // See wxlua_getchararray().
    const char** GetCharArray(int stack_idx, int &count);

    // See wxlua_getintarray().
    int* GetIntArray(int stack_idx, int &count);
    // See wxlua_getwxArrayInt().
    wxLuaSmartwxArrayInt GetwxArrayInt(int stack_idx);

    // See wxlua_pushwxArrayStringtable().
    int PushwxArrayStringTable(const wxArrayString &strArray);
    // See wxlua_pushwxArrayInttable().
    int PushwxArrayIntTable(const wxArrayInt &intArray);

    // -----------------------------------------------------------------------

    // See wxluaT_typename().
    wxString GetwxLuaTypeName(int wxl_type) const;

    // -----------------------------------------------------------------------

    // See wxlua_setderivedmethod
    bool SetDerivedMethod(void *obj_ptr, const char *method_name, wxLuaObject* wxlObj);
    // See wxlua_hasderivedmethod().
    bool HasDerivedMethod(const void *obj_ptr, const char *method_name, bool push_method) const;
    // See wxlua_removederivedmethods()
    bool RemoveDerivedMethods(void *obj_ptr) const;
    // Find a derived method given an object and and a method name.
    // If the method can be found, return the valid wxLuaState it belongs to.
    // This function can be used for classes that implement virtual functions to
    // try to find a wxLuaState that may have overridden the function to call it.
    // It is probably easier to merely make a wxLuaState a class member for
    // faster lookup though.
    static wxLuaState GetDerivedMethodState(void *obj_ptr, const char *method_name);

    // -----------------------------------------------------------------------
    // C++ interface for the lua_State functions
    //   functions prepended by lua_XXX directly call the 'C' lua_XXX function
    //   The function names have been capitalized to allow case sensitive searching
    // -----------------------------------------------------------------------
    // Raw basic Lua stack functions, lua.h

    int  lua_GetTop() const;
    void lua_SetTop(int index);
    void lua_PushValue(int index);
    void lua_Remove(int index);
    void lua_Pop(int count) const;
    void lua_Insert(int index);
    void lua_Replace(int index);
    int  lua_CheckStack(int size);
    void lua_XMove(const wxLuaState& to, int n);

    // -----------------------------------------------------------------------
    // Raw Lua accesses functions (stack -> C), lua.h

    bool lua_IsNumber(int index) const;
    bool lua_IsString(int index) const;
    bool lua_IsCFunction(int index) const;
    bool lua_IsUserdata(int index) const;
    int  lua_Type(int index) const;
    wxString lua_TypeName(int type) const;

    int  lua_Equal(int index1, int index2) const;
    int  lua_RawEqual(int index1, int index2) const;
    int  lua_LessThan(int index1, int index2) const;

    double        lua_ToNumber(int index) const;
    int           lua_ToInteger(int index) const;
    int           lua_ToBoolean(int index) const;
    const char*   lua_ToString(int index) const;
    wxString      lua_TowxString(int index) const; // wxLua added
    size_t        lua_StrLen(int index) const;
    size_t        luaL_ObjLen(int index) const;
    lua_CFunction lua_ToCFunction(int index) const;
    void*         lua_ToUserdata(int index) const;
    wxLuaState    lua_ToThread(int index) const;
    const void*   lua_ToPointer(int index) const;

    // -----------------------------------------------------------------------
    // Raw Lua push functions (C -> stack), lua.h

    void lua_PushNil();
    void lua_PushNumber(lua_Number n);
    void lua_PushInteger(lua_Integer n);
    void lua_PushLString(const char* s, size_t len);
    void lua_PushString(const char* s);
    wxLUA_UNICODE_ONLY(void lua_PushString(const wxString& s) { lua_PushString(wx2lua(s)); })
    //wxString lua_PushVfString();
    //wxString lua_PushFString();
    void lua_PushCClosure(lua_CFunction fn, int n);
    void lua_PushBoolean(bool b);
    void lua_PushLightUserdata(void* p);
    //void lua_PushThread(lua_State* L);

    // -----------------------------------------------------------------------
    // Raw Lua get functions (Lua -> stack), lua.h

    void  lua_GetTable(int idx);
    void  lua_GetField(int idx, const char* k);
    wxLUA_UNICODE_ONLY(void lua_GetField(int idx, const wxString& k) { lua_GetField(idx, wx2lua(k)); })
    void  lua_RawGet(int idx);
    void  lua_RawGeti(int idx, int n);
    void  lua_CreateTable(int narr, int nrec);
    void  lua_NewTable();
    void* lua_NewUserdata(size_t sz);
    int   lua_GetMetatable(int objindex);
    void  lua_GetFenv(int idx);

    // -----------------------------------------------------------------------
    // Raw Lua set functions (stack -> Lua), lua.h

    void  lua_SetTable(int idx);
    void  lua_SetField(int idx, const char* k);
    wxLUA_UNICODE_ONLY(void lua_SetField(int idx, const wxString& k) { lua_SetField(idx, wx2lua(k)); })
    void  lua_RawSet(int idx);
    void  lua_RawSeti(int idx, int n);
    int   lua_SetMetatable(int objindex);
    int   lua_SetFenv(int idx);

    // -----------------------------------------------------------------------
    // Raw Lua `load' and `call' functions (load and run Lua code), lua.h

    void lua_Call(int nargs, int nresults);
    int  lua_PCall(int nargs, int nresults, int errfunc);
    int  lua_CPCall(lua_CFunction func, void *ud);
    int  lua_Load(lua_Reader reader, void *dt, const char* chunkname);
    wxLUA_UNICODE_ONLY(int lua_Load(lua_Reader reader, void *dt, const wxString& chunkname) { return lua_Load(reader, dt, wx2lua(chunkname)); })

    int lua_Dump(lua_Writer writer, void *data);

    // -----------------------------------------------------------------------
    // Raw Lua coroutine functions, lua.h

    int lua_Yield(int nresults);
    int lua_Resume(int narg);
    int lua_Status();

    // -----------------------------------------------------------------------
    // Raw Lua garbage-collection functions, lua.h

    int lua_GetGCCount();

    // -----------------------------------------------------------------------
    // Raw Lua miscellaneous functions, lua.h

    wxString lua_Version() const;
    int   lua_Error();
    int   lua_Next(int idx);
    void  lua_Concat(int n);

    //LUA_API lua_Alloc (lua_getallocf) (lua_State *L, void **ud);
    //LUA_API void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);

    // -----------------------------------------------------------------------
    // Raw Lua some useful "macros", lua.h

    //lua_boxpointer(L,u)
    //lua_unboxpointer(L,i)
    //lua_pop(L,n)            lua_settop(L, -(n)-1)

    void lua_Register(const char* funcName, lua_CFunction f);
    wxLUA_UNICODE_ONLY(void lua_Register(const wxString& funcName, lua_CFunction f) { lua_Register(wx2lua(funcName), f); })
    void lua_PushCFunction(lua_CFunction f);

    bool lua_IsFunction(int idx) const;
    bool lua_IsTable(int idx) const;
    bool lua_IsLightUserdata(int idx) const;
    bool lua_IsNil(int idx) const;
    bool lua_IsBoolean(int idx) const;
    bool lua_IsThread(int idx) const;
    bool lua_IsNone(int idx) const;
    bool lua_IsNoneOrNil(int idx) const;

    //lua_pushliteral(L, s)   lua_pushlstring(L, "" s, (sizeof(s)/sizeof(char))-1)

    void lua_SetGlobal(const char* s);
    void lua_GetGlobal(const char* s);

    // -----------------------------------------------------------------------
    // Raw Lua Debug functions, lua.h

    int lua_GetStack(int level, lua_Debug* ar);
    int lua_GetInfo(const char* what, lua_Debug* ar);
    wxLUA_UNICODE_ONLY(int lua_GetInfo(const wxString& what, lua_Debug* ar) { return lua_GetInfo(wx2lua(what), ar); })
    const char* lua_GetLocal(const lua_Debug* ar, int n);
    const char* lua_SetLocal(const lua_Debug* ar, int n);
    const char* lua_GetUpvalue(int funcindex, int n);
    const char* lua_SetUpvalue(int funcindex, int n);

    int lua_SetHook(lua_Hook func, int mask, int count);
    lua_Hook lua_GetHook();
    int lua_GetHookMask();
    int lua_GetHookCount();

    // -----------------------------------------------------------------------
    // Raw Lua auxlib functions, lauxlib.h

    void luaI_OpenLib(const char *libname, const luaL_reg *l, int nup);
    void luaL_Register(const char *libname, const luaL_reg *l);
    int luaL_GetMetafield(int obj, const char *e);
    int luaL_CallMeta(int obj, const char *e);
    int luaL_TypeError(int narg, const char *tname);
    int luaL_ArgError(int numarg, const char *extramsg);
    const char *luaL_CheckLString(int numArg, size_t *l);
    const char *luaL_OptLString(int numArg, const char *def, size_t *len);
    lua_Number luaL_CheckNumber(int numArg);
    lua_Number luaL_OptNumber(int nArg, lua_Number def);
    lua_Integer luaL_CheckInteger(int numArg);
    lua_Integer luaL_OptInteger(int nArg, lua_Integer def);

    void luaL_CheckStack(int sz, const char *msg);
    void luaL_CheckType(int narg, int t);
    void luaL_CheckAny(int narg);

    int   luaL_NewMetatable(const char *tname);
    void  luaL_GetMetatable(const char *tname);
    void *luaL_CheckUdata(int ud, const char *tname);

    void luaL_Where(int lvl);
    int luaL_Error(const char *fmt, ...);

    int luaL_CheckOption(int narg, const char *def, const char *const lst[]);

    int luaL_Ref(int t);
    void luaL_Unref(int t, int ref);

    int luaL_LoadFile(const char *filename);
    int luaL_LoadBuffer(const char *buff, size_t sz, const char *name);
    int luaL_LoadString(const char *s);

    //LUALIB_API lua_State *(luaL_newstate) (void);
    //LUALIB_API const char *(luaL_gsub) (lua_State *L, const char *s, const char *p, const char *r);
    //LUALIB_API const char *(luaL_findtable) (lua_State *L, int idx, const char *fname, int szhint);

    // -----------------------------------------------------------------------
    // Raw Lua some useful macros, lauxlib.h

    void luaL_ArgCheck(bool condition, int numarg, const char* extramsg);
    const char* luaL_CheckString(int numArg);
    const char* luaL_OptString(int numArg, const char* def);
    int  luaL_CheckInt(int numArg);
    int  luaL_OptInt(int numArg, int def);
    long luaL_CheckLong(int numArg);
    long luaL_OptLong(int numArg, int def);

    // -----------------------------------------------------------------------
    // others

    void GetGlobals();

    // -----------------------------------------------------------------------
    // LUA_PATH

    wxString GetLuaPath();
    void AddLuaPath(const wxPathList& pathlist);
    void AddLuaPath(const wxFileName& filename);

    // -----------------------------------------------------------------------
    // operators

    bool operator == (const wxLuaState& wxlState) const
        { return m_refData == wxlState.m_refData; }
    bool operator != (const wxLuaState& wxlState) const
        { return m_refData != wxlState.m_refData; }

    wxLuaState& operator = (const wxLuaState& wxlState)
    {
        if ( (*this) != wxlState )
            Create(wxlState);
        return *this;
    }

private:
    // ref counting code
    virtual wxObjectRefData *CreateRefData() const;
    //virtual wxObjectRefData *CloneRefData(const wxObjectRefData *data) const;

    DECLARE_DYNAMIC_CLASS(wxLuaState)
};

//-----------------------------------------------------------------------------
// wxLuaEvent - An event sent from the wxLuaState to the set wxEvtHandler
//              to alert the handler of print,
//-----------------------------------------------------------------------------

class WXDLLIMPEXP_WXLUA wxLuaEvent: public wxNotifyEvent
{
public:
    wxLuaEvent(wxEventType commandType = wxEVT_NULL, wxWindowID id = wxID_ANY,
               const wxLuaState& wxlState = wxNullLuaState);

    wxLuaEvent(const wxLuaEvent &event);

    // use GetString method to retrieve info

    // Get the line number in the code, -1 if unknown
    int GetLineNum() const { return m_commandInt; }

    wxLuaState GetwxLuaState() const { return m_wxlState; }
    void SetwxLuaState(const wxLuaState& wxlState) { m_wxlState = wxlState; }

    lua_State *GetLuaState() const { return m_wxlState.GetLuaState(); }
    // non null only for wxEVT_LUA_DEBUG_HOOK
    lua_Debug *GetLuaDebug() const { return m_lua_Debug; }

    // If called from a wxEVT_LUA_DEBUG_HOOK the interpreter will stop
    void DebugHookBreak(bool stop) { m_debug_hook_break = stop; }

    // implementation
    virtual wxEvent *Clone() const { return new wxLuaEvent(*this); }

    wxLuaState m_wxlState;
    bool m_debug_hook_break;
    lua_Debug *m_lua_Debug;
};

BEGIN_DECLARE_EVENT_TYPES()
    // A wxLuaState is being created, sent at the end of
    //   wxLuaState(wxEvtHandler, win id) or Create(wxEvtHandler, win id)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_WXLUA, wxEVT_LUA_CREATION,   0)
    // Lua's print(...) statements and such, check GetString()
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_WXLUA, wxEVT_LUA_PRINT,      0)
    // an error in Lua has occurred, check GetString() for message
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_WXLUA, wxEVT_LUA_ERROR,      0)
    // see LuaDebugHook function
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_WXLUA, wxEVT_LUA_DEBUG_HOOK, 0)
    // after app starts, first idle
    //DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_WXLUA, wxEVT_LUA_INIT,       0)
    //DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_WXLUA, wxEVT_LUA_DEBUGGERATTACHED,   0)
END_DECLARE_EVENT_TYPES()

typedef void (wxEvtHandler::*wxLuaEventFunction)(wxLuaEvent&);

#define wxLuaEventHandler(func) \
    (wxObjectEventFunction)(wxEventFunction)(wxCommandEventFunction)(wxNotifyEventFunction)wxStaticCastEvent(wxLuaEventFunction, &func)

#define wx__DECLARE_WXLUAEVT(evt, id, fn) wx__DECLARE_EVT1(evt, id, wxLuaEventHandler(fn))

#define EVT_LUA_CREATION(id, fn)   wx__DECLARE_WXLUAEVT(wxEVT_LUA_CREATION,   id, fn)
#define EVT_LUA_PRINT(id, fn)      wx__DECLARE_WXLUAEVT(wxEVT_LUA_PRINT,      id, fn)
#define EVT_LUA_ERROR(id, fn)      wx__DECLARE_WXLUAEVT(wxEVT_LUA_ERROR,      id, fn)
#define EVT_LUA_DEBUG_HOOK(id, fn) wx__DECLARE_WXLUAEVT(wxEVT_LUA_DEBUG_HOOK, id, fn)

#endif // _WXLSTATE_H_
