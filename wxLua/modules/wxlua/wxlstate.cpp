/////////////////////////////////////////////////////////////////////////////
// Name:        wxlstate.cpp
// Purpose:     wxLuaState, a wxWidgets interface to Lua
// Author:      Ray Gilbert, John Labenski, J Winwood (Reuben Thomas for bitlib at bottom)
// Created:     14/11/2001
// Copyright:   (c) 2012 John Labenski, 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

// For compilers that support precompilation, includes "wx/wx.h"
#include <wx/wxprec.h>

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

// for all others, include the necessary headers
#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif

#include "wxlua/wxlstate.h"
#include "wxlua/wxlcallb.h"
#include <wx/tokenzr.h>

//#include "wxluadebug/include/wxldebug.h" // for debugging only

const char* wxlua_lreg_regtable_key            = "wxlua_lreg_regtable_key : wxLua LUA_REGISTRYINDEX tables";

const char* wxlua_lreg_wxluastate_key          = "wxlua_lreg_wxluastate_key : wxLuaState";
const char* wxlua_lreg_wxluastatedata_key      = "wxlua_lreg_wxluastatedata_key : wxLuaStateData";

const char* wxlua_lreg_wxluabindings_key       = "wxlua_lreg_wxluabindings_key : wxLuaBindings installed";
const char* wxlua_lreg_classes_key             = "wxlua_lreg_classes_key : wxLuaBindClass structs installed";
const char* wxlua_lreg_types_key               = "wxlua_lreg_types_key : wxLua metatable class types";

const char* wxlua_lreg_weakobjects_key         = "wxlua_lreg_weakobjects_key : wxLua objects pushed";
const char* wxlua_lreg_gcobjects_key           = "wxlua_lreg_gcobjects_key : wxLua gc objects to delete";
const char* wxlua_lreg_derivedmethods_key      = "wxlua_lreg_derivedmethods_key : wxLua derived class methods";
const char* wxlua_lreg_evtcallbacks_key        = "wxlua_lreg_evtcallbacks_key : wxLuaEventCallbacks";
const char* wxlua_lreg_windestroycallbacks_key = "wxlua_lreg_windestroycallbacks_key : wxLuaWinDestoyCallbacks";
const char* wxlua_lreg_topwindows_key          = "wxlua_lreg_topwindows_key : wxLua top level wxWindows";
const char* wxlua_lreg_wxeventtype_key         = "wxlua_lreg_wxeventtype_key : wxLua wxEventType";
const char* wxlua_lreg_callbaseclassfunc_key   = "wxlua_lreg_callbaseclassfunc_key : wxLua CallBaseClassFunc";

const char* wxlua_lreg_refs_key                = "wxlua_lreg_refs_key : wxLua Lua object refs";
const char* wxlua_lreg_debug_refs_key          = "wxlua_lreg_debug_refs_key : wxLuaDebugData refs";

const char* wxlua_metatable_type_key           = "wxlua_metatable_type_key : wxLua metatable class type";
const char* wxlua_metatable_wxluabindclass_key = "wxlua_metatable_wxluabindclass_key : wxLua metatable wxLuaBindClass";


wxLuaState wxNullLuaState(false);

int LUACALL luaopen_bit(lua_State *L); // implemented at bottom of file

extern "C"
{
    int luaopen_bit32 (lua_State *L);
}

// ----------------------------------------------------------------------------
// C functions for Lua used in wxLuaState
// ----------------------------------------------------------------------------

// The print function that we push into Lua replacing "print(...)"
// to generate wxLuaEvent(wxEVT_LUA_PRINT, ...)
// Code copied from Lua's luaB_print() function in lbaselib.c
int LUACALL wxlua_printFunction( lua_State *L )
{
    wxLuaState wxlState(L); // doesn't have to be ok

    // If the wxLuaState is not going to print, we'll let Lua print normally
    if (!wxlState.Ok() || (wxlState.GetEventHandler() == NULL) || (!wxApp::IsMainLoopRunning() && !wxlState.sm_wxAppMainLoop_will_run))
    {
        // Get our saved copy of the Lua's print function from the registry
        lua_pushlstring(L, "print_lua", 9);
        lua_rawget( L, LUA_REGISTRYINDEX ); // pop key, push print function

        lua_CFunction lua_print = lua_tocfunction(L, -1);
        lua_pop(L, 1);                      // pop the print function
        return lua_print(L);
    }

    // The wxLuaState can print by sending an event
    wxString msg;
    int i, n = lua_gettop(L);

    // Use the Lua tostring() function to print them as Lua would
    lua_getglobal(L, "tostring");

    if (!lua_isfunction(L, -1))
    {
        // This code is also used in wxledit.cpp, wxLuaShell::RunString()
        msg = wxT("wxLua ERROR: Unable to print() without the tostring() function. Did you remove it?");
        lua_pop(L, 1);  // pop the nil or whatever replaced tostring()
        n = 0;          // don't let for loop run
    }

    for (i = 1; i <= n; ++i)
    {
        const char *s;
        lua_pushvalue(L, -1);       /* function to be called */
        lua_pushvalue(L, i);        /* value to print */
        lua_call(L, 1, 1);
        s = lua_tostring(L, -1);    /* get result */
        if (s == NULL)
        {
            // FIXME use wxlua_error here? right now wxlua_error doesn't do anything special - JL
            return luaL_error(L, LUA_QL("tostring") " must return a string to "
                              LUA_QL("print"));
        }

        if (i > 1) msg.Append(wxT("\t")); // Lua uses a tab too in luaB_print
        msg += lua2wx(s);

        lua_pop(L, 1);  /* pop result */
    }

    if (!msg.IsEmpty())
    {
        wxLuaEvent event(wxEVT_LUA_PRINT, wxlState.GetId(), wxlState);
        event.SetString(msg);
        wxlState.SendEvent(event);
    }
    //else if (!msg.IsEmpty())
    //    wxPrintf(wxT("%s\n"), msg.c_str()); // Lua puts a \n too

    return 0; // no items put onto stack
}

void LUACALL wxlua_debugHookFunction(lua_State *L, lua_Debug *LDebug)
{
    // NULL when shutting down.
    wxLuaStateData* wxlStateData = wxlua_getwxluastatedata(L);
    if (!wxlStateData) return;

    // FIXME - for select event types we don't want to do anything
    wxEventType evtType = wxlua_getwxeventtype(L);
    if ((evtType != wxEVT_NULL))
        //(evtType == wxEVT_IDLE) && (evtType == wxEVT_PAINT) &&
        //(evtType == wxEVT_DESTROY) && (evtType == wxEVT_CLOSE_WINDOW))
        return;

    // they want to break the program, restore old debug hook, then error out
    if (wxlStateData->m_debug_hook_break)
    {
        // It's ok that we get the wxLuaState here since we're stopping anyway.
        wxLuaState wxlState(L);

        // restore hook to previous state
        wxlState.ClearDebugHookBreak();
        wxlua_error(L, wxlStateData->m_debug_hook_break_msg);
        return;
    }

    // We use wxLuaState::SendEvent() because it sets wxEvent::SetEventObject() for us.
    if (wxlStateData->m_lua_debug_hook_send_evt && wxlStateData->m_evtHandler)
    {
        wxLuaState wxlState(L);

        lua_getinfo(L, "l", LDebug); // line (ldebug.currentline)

        wxLuaEvent event(wxEVT_LUA_DEBUG_HOOK, wxlState.GetId(), wxlState);
        event.m_lua_Debug = LDebug;
        event.SetInt(LDebug->currentline);
        wxlState.SendEvent( event );
        if (event.m_debug_hook_break)
            wxlState.wxlua_Error("Lua interpreter stopped.");
    }

    // Try to yield *after* sending event to allow C++ gui update
    if (wxlStateData->m_lua_debug_hook_yield > 0)
    {
        // yield based on number of ms passed NOT every hook event
        unsigned long last_time = wxlStateData->m_last_debug_hook_time;
        unsigned long cur_time  = wxGetLocalTimeMillis().GetLo();

        if ((cur_time > last_time + wxlStateData->m_lua_debug_hook_yield) ||
            (cur_time < last_time)) // wrapped
        {
            wxlStateData->m_last_debug_hook_time = cur_time;

            bool painting = (evtType == wxEVT_PAINT);

/*
            wxLongToLongHashMap::iterator it;
            wxLongToLongHashMap* hashMap = &wxlState.GetLuaStateRefData()->m_wxlStateData->m_trackedObjects;
            for (it = hashMap->begin(); it != hashMap->end(); ++it)
            {
                wxObject* obj = (wxObject*)it->second;
                if (obj && wxDynamicCast(obj, wxPaintDC))
                {
                    painting = true;
                    break;
                }
            }
*/

            if (!painting)
                wxYield(); //IfNeeded();
        }
    }
}

// ----------------------------------------------------------------------------

void wxlua_lreg_createtable(lua_State* L, void* lightuserdata_reg_key, int narr, int nrec)
{
    // clear the old ref to the table, even though it's weak kv
    // it doesn't get cleared until the gc runs
    lua_pushlightuserdata(L, &wxlua_lreg_regtable_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                   // get table
      lua_pushlightuserdata(L, lightuserdata_reg_key);  // push key
      lua_rawget(L, LUA_REGISTRYINDEX);                 // get table or nil
      if (lua_istable(L, -1))
      {
          lua_pushnil(L);                               // push value
          lua_rawset(L, -3);                            // clear t[key] = nil
          lua_pop(L, 1);                                // pop wxlua_lreg_regtable_key table
      }
      else
        lua_pop(L, 2); // pop nil and wxlua_lreg_regtable_key table

    // Add new LUA_REGISTRYINDEX[&wxlua_lreg_regtable_key][lightuserdata_reg_key table] = lightuserdata_reg_key
    lua_pushlightuserdata(L, lightuserdata_reg_key); // push key
    lua_createtable(L, narr, nrec);                  // push value
        lua_pushlightuserdata(L, &wxlua_lreg_regtable_key); // push key
        lua_rawget(L, LUA_REGISTRYINDEX);                   // get wxlua_lreg_regtable_key table
        lua_pushvalue(L, -2);    // push key (copy of the new table)
        lua_pushvalue(L, -4);    // push value (copy of lightuserdata key)
        lua_rawset(L, -3);       // set t[key] = value; pops key and value
        lua_pop(L, 1);           // pop wxlua_lreg_regtable_key table
    lua_rawset(L, LUA_REGISTRYINDEX); // set the value
}

// ----------------------------------------------------------------------------
// Lua helper functions
// ----------------------------------------------------------------------------

wxString wxlua_LUA_ERR_msg(int LUA_ERRx)
{
    switch (LUA_ERRx)
    {
        case 0             : return wxEmptyString;
        case LUA_YIELD     : return wxT("Lua: Thread is suspended");
        case LUA_ERRRUN    : return wxT("Lua: Error while running chunk");
        case LUA_ERRSYNTAX : return wxT("Lua: Syntax error during pre-compilation");
        case LUA_ERRMEM    : return wxT("Lua: Memory allocation error");
        case LUA_ERRERR    : return wxT("Lua: Generic error or an error occurred while running the error handler");
        case LUA_ERRFILE   : return wxT("Lua: Error occurred while opening file");
    }

    return wxT("Lua: Unknown LUA_ERRx error value");
}

bool wxlua_errorinfo(lua_State* L, int status, int top, wxString* errorMsg_, int* line_num_)
{
    if (status == 0)
        return false;

    int newtop = lua_gettop(L);

    wxString errorMsg = wxlua_LUA_ERR_msg(status);

    switch(status)
    {
        case LUA_ERRMEM:
        case LUA_ERRERR:
        {
            if (newtop > top)
                errorMsg += wxT("\n");
            break;
        }
        case LUA_ERRRUN:
        case LUA_ERRFILE:
        case LUA_ERRSYNTAX:
        default:
        {
            if (newtop > top)
                errorMsg += wxT("\n") + lua2wx(lua_tostring(L, -1));
            break;
        }
    }

    errorMsg += wxT("\n");

    // Why can't I fill a lua_Debug here? Try to get the line number
    // by parsing the error message that looks like this, 3 is linenumber
    // [string "a = 1("]:3: unexpected symbol near `<eof>'
    wxString lineStr = errorMsg;
    long line_num = -1;
    while(!lineStr.IsEmpty())
    {
        // search through the str to find ']:LONG:' pattern
        lineStr = lineStr.AfterFirst(wxT(']'));
        if ((lineStr.Length() > 0) && (lineStr.GetChar(0) == wxT(':')))
        {
            lineStr = lineStr.AfterFirst(wxT(':'));
            if (lineStr.IsEmpty() || lineStr.BeforeFirst(wxT(':')).ToLong(&line_num))
                break;
        }
    }

    lua_settop(L, top); // pops the message if any

    if (errorMsg_) *errorMsg_ = errorMsg;
    if (line_num_) *line_num_ = (int)line_num;

    return true;
}

void LUACALL wxlua_error(lua_State *L, const char *errorMsg)
{
    // Use luaL_error(L, s) and not "lua_pushstring(L, s); lua_error(L)" since
    // luaL_error() provides the file and line number too.
    luaL_error(L, "%s", errorMsg);
}

void LUACALL wxlua_argerror(lua_State *L, int stack_idx, const wxString& expectedType)
{
    wxString argType = wxlua_luaL_typename(L, stack_idx);

    wxString msg(wxString::Format(_("wxLua: Expected %s for parameter %d, but got a '%s'."),
                                    expectedType.c_str(), stack_idx, argType.c_str()));

    wxlua_argerrormsg(L, msg);
}

void LUACALL wxlua_argerrormsg(lua_State *L, const wxString& msg_)
{
    wxString funcArgs(wxT("\n"));
    wxString argMsg  = wxlua_getLuaArgsMsg(L, 1, lua_gettop(L));

    wxLuaBindMethod* wxlMethod = (wxLuaBindMethod *)lua_touserdata(L, lua_upvalueindex(1)); // lightuserdata
    if (wxlMethod != NULL)
    {
        // Guarantee that this is a wxLuaBindMethod of ours so we don't crash.
        // Since we're going to error out we don't have to be quick about it.

        // check if this method is part of a class
        const wxLuaBindClass* wxlClass = wxLuaBinding::FindBindClass(wxlMethod);

        // if not, check if it's a global C style function
        wxLuaBinding* binding = NULL;
        if (wxlClass == NULL)
            binding = wxLuaBinding::FindMethodBinding(wxlMethod);

        if ((wxlClass != NULL) || (binding != NULL))
            funcArgs += wxlua_getBindMethodArgsMsg(L, wxlMethod);
    }

    wxString msg;
    msg.Printf(wxT("%s\nFunction called: '%s'%s"), msg_.c_str(), argMsg.c_str(), funcArgs.c_str());
    wxlua_error(L, msg);
}

void* LUACALL wxlua_touserdata(lua_State *L, int stack_idx, bool null_ptr /*= false*/)
{
    if (lua_islightuserdata(L, stack_idx) != 0)
    {
        // can't NULL the ptr, just return the lightuserdata as is
        return lua_touserdata(L, stack_idx);
    }

    void *pdata = NULL;
    void **ptr = (void **)lua_touserdata(L, stack_idx);

    if (ptr != NULL)
    {
        pdata = *ptr;       // get the pointer the userdata holds
        if (null_ptr)       // NULL ptr so Lua won't try to gc it
            *ptr = NULL;
    }

    return pdata;
}

// ----------------------------------------------------------------------------
// wxluaR_XXX - functions operate on tables in Lua's LUA_REGISTRYINDEX
// ----------------------------------------------------------------------------

#define ABS_LUA_STKIDX(n, added_items) ((n) > 0 ? (n) : (n)-(added_items))

// Note about luaL_ref() and luaL_unref().
// ref creates integer numbers from 1 to ...
// unref uses t[0] to hold the last unused reference and when you call unref
// again the next unused ref points back to the first and t[0] points to the
// last unrefed key.
// eg. create 5 refs, get refs 1,2,3,4,5, then call unref on 3 then 4 then
//     call ref 3 times and the new references will be 4, 3, 6

int wxluaR_ref(lua_State* L, int stack_idx, void* lightuserdata_reg_key)
{
    // nothing on stack to insert and don't bother inserting nil
    if (lua_isnoneornil(L, stack_idx))
        return LUA_REFNIL;

    lua_pushlightuserdata(L, lightuserdata_reg_key);    // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                   // pop key, push value (table)

    lua_pushvalue(L, ABS_LUA_STKIDX(stack_idx,1));      // push value to store

    int ref_idx = luaL_ref(L, -2);                      // t[ref_idx] = value; pops value

    // We also store t[value] = table_idx for this table for faster lookup
    if (lightuserdata_reg_key == &wxlua_lreg_debug_refs_key)
    {
        lua_pushvalue(L, ABS_LUA_STKIDX(stack_idx,1));  // push key
        lua_pushnumber(L, ref_idx);                     // push value
        lua_rawset(L, -3);                              // set t[key] = value; pops key and value
    }

    lua_pop(L, 1);                                      // pop table

    return ref_idx;
}

bool wxluaR_unref(lua_State* L, int ref_idx, void* lightuserdata_reg_key)
{
    if (ref_idx == LUA_REFNIL)                       // nothing to remove
        return false;

    lua_pushlightuserdata(L, lightuserdata_reg_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                // pop key, push value (table)

    // Also remove the t[value] = table_idx for this table
    if (lightuserdata_reg_key == &wxlua_lreg_debug_refs_key)
    {
        lua_pushnumber(L, ref_idx);   // push key
        lua_rawget(L, -2);            // get t[key] = value; pop key, push value;

        lua_pushnil(L);
        lua_rawset(L, -3);            // t[value] = nil; pops key and value
    }

    luaL_unref(L, -1, ref_idx);       // remove key and value in refs table
                                      // note: this key will be used for the next wxluaR_ref()

    lua_pop(L, 1);                    // pop table

    return true;
}

bool LUACALL wxluaR_getref(lua_State *L, int ref_idx, void* lightuserdata_reg_key)
{
    if (ref_idx == LUA_REFNIL)          // nothing to get
        return false;

    lua_pushlightuserdata(L, lightuserdata_reg_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                // pop key, push value (table)

    lua_rawgeti(L, -1, ref_idx);        // get t[ref_idx] = value; push value

    if (lua_isnil(L, -1))               // not a valid table key
    {
        lua_pop(L, 2);                  // pop nil and table
        return false;
    }

    lua_remove(L, -2);                  // remove table, leaving value on top

    return true; // return if table has a valid value and it's on the stack
}

int LUACALL wxluaR_isrefed(lua_State* L, int stack_idx, void* lightuserdata_reg_key)
{
    int ref_idx = LUA_NOREF;

    lua_pushlightuserdata(L, lightuserdata_reg_key);    // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                   // pop key, push value (table)

    if (lightuserdata_reg_key == &wxlua_lreg_debug_refs_key)
    {
        // For this table we've pushed the value for a faster lookup
        lua_pushvalue(L, ABS_LUA_STKIDX(stack_idx,1));  // push key (the value)
        lua_rawget(L, -2);                              // get t[key] = value; pop key push value
        ref_idx = (int)lua_tonumber(L, -1);

        if ((ref_idx == 0) && !lua_isnumber(L, -1))     // if !isnumber it returns 0 (faster)
            ref_idx = LUA_NOREF;

        lua_pop(L, 2); // pop object we pushed and the ref table
    }
    else
    {
        // otherwise search through all the values
        lua_pushnil(L);
        while (lua_next(L, -2) != 0)
        {
            // value = -1, key = -2, table = -3, object = stack_idx before 3 added items
            if (lua_equal(L, -1, ABS_LUA_STKIDX(stack_idx,3)))
            {
                ref_idx = (int)lua_tonumber(L, -2);
                lua_pop(L, 2);               // pop key, value
                break;
            }
            else
                lua_pop(L, 1);               // pop value, lua_next will pop key at end
        }

        lua_pop(L, 1); // pop ref table
    }

    return ref_idx;
}

// ----------------------------------------------------------------------------
// wxluaO_XXX - functions operate on the "Objects"
// ----------------------------------------------------------------------------

bool LUACALL wxluaO_addgcobject(lua_State *L, void *obj_ptr, int wxl_type)
{
    lua_pushlightuserdata(L, &wxlua_lreg_gcobjects_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                    // pop key, push value (table)

    // Check if it's already tracked since that means the weak udata table isn't working right
    lua_pushlightuserdata(L, obj_ptr); // push key
    lua_rawget(L, -2);                 // get t[key] = value, pops key

    if (!lua_isnil(L, -1))
    {
        lua_pop(L, 2); // pop table and value
        wxCHECK_MSG(false, false, wxT("Tracking an object twice in wxluaO_addgcobject: ") + wxluaT_typename(L, wxl_type));
        return false;
    }

    lua_pop(L, 1); // pop nil

    // Then add it
    lua_pushlightuserdata(L, obj_ptr);  // push key
    lua_pushnumber(L, wxl_type);        // push value
    lua_rawset(L, -3);                  // set t[key] = value, pops key and value

    lua_pop(L, 1); // pop table

    return true;
}

bool LUACALL wxluaO_deletegcobject(lua_State *L, int stack_idx, int flags)
{
    void* udata   = lua_touserdata(L, stack_idx);
    void* obj_ptr = wxlua_touserdata(L, stack_idx, true); // clear lua userdata's ptr

    //if (obj_ptr == NULL) return false; // can happen

    bool delete_all = WXLUA_HASBIT(flags, WXLUA_DELETE_OBJECT_ALL);

    wxLuaBindClass *wxlClass = NULL;

    if (lua_getmetatable(L, stack_idx))
    {
        lua_pushlightuserdata(L, &wxlua_metatable_wxluabindclass_key); // push key
        lua_rawget(L, -2);                                   // get t[key] = value; pop key push value
        wxlClass = (wxLuaBindClass *)lua_touserdata(L, -1);
        lua_pop(L, 2); // pop metatable and lightuserdata value
    }

    // Remove the weak ref to it, will optionally clear all the metatables
    // for an userdata created for this object to make them unusable.
    int udata_count = wxluaO_untrackweakobject(L, delete_all ? NULL : udata, obj_ptr);

    if (delete_all || (udata_count < 1))
    {
        // remove any derived methods attached to this object
        wxlua_removederivedmethods(L, obj_ptr);

        // check if we are really supposed to delete it
        lua_pushlightuserdata(L, &wxlua_lreg_gcobjects_key); // push key
        lua_rawget(L, LUA_REGISTRYINDEX);                    // pop key, push value (table)

        lua_pushlightuserdata(L, obj_ptr); // push key
        lua_rawget(L, -2);                 // get t[key] = value, pops key

        if (wxlClass && lua_isnumber(L, -1)) // the wxLua type for it
        {
            lua_pop(L, 1); // pop number value

            lua_pushlightuserdata(L, obj_ptr); // push key
            lua_pushnil(L);                    // push value
            lua_rawset(L, -3);                 // set t[key] = value, pops key and value

            lua_pop(L, 1); // pop delobj table

            // delete the object using the function stored in the wxLuaBindClass
            if (obj_ptr)
                wxlClass->delete_fn(&obj_ptr);
            else
                return false;

            return true;
        }
        else
        {
            // no error message since we're called from wxlua_wxLuaBindClass__gc
            // automatically for all our objects and this table stores which ones to delete
            // so we don't want to have to check first and then call this.
            lua_pop(L, 2); // pop nil and delobj
        }
    }

    return false;
}

bool LUACALL wxluaO_undeletegcobject(lua_State *L, void *obj_ptr)
{
    if (obj_ptr == NULL) return false;

    lua_pushlightuserdata(L, &wxlua_lreg_gcobjects_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                    // pop key, push value (table)

    lua_pushlightuserdata(L, obj_ptr); // push key
    lua_rawget(L, -2);                 // get t[key] = value, pops key

    if (lua_isnumber(L, -1)) // is the wxLua type of the object
    {
        lua_pop(L, 1); // pop number

        lua_pushlightuserdata(L, obj_ptr); // push key
        lua_pushnil(L);                    // push value
        lua_rawset(L, -3);                 // set t[key] = value, pops key and value

        lua_pop(L, 1); // pop delobj table
        return true;
    }
    else
        lua_pop(L, 2); // pop nil and gcobject table

    return false;
}

bool LUACALL wxluaO_isgcobject(lua_State *L, void *obj_ptr)
{
    lua_pushlightuserdata(L, &wxlua_lreg_gcobjects_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                    // pop key, push value (table)

    lua_pushlightuserdata(L, obj_ptr); // push key
    lua_rawget(L, -2);                 // get t[key] = value, pops key

    bool found = (0 != lua_isnumber(L, -1));
    lua_pop(L, 2); // pop udata and table

    return found;
}

wxArrayString LUACALL wxluaO_getgcobjectinfo(lua_State *L)
{
    wxArrayString arrStr;

    lua_pushlightuserdata(L, &wxlua_lreg_gcobjects_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                    // pop key, push value (table)

    lua_pushnil(L);
    while (lua_next(L, -2) != 0)
    {
        // value = -1, key = -2, table = -3
        wxString name(wxT("wxObject?"));

        int wxl_type = (int)lua_tonumber(L, -1);
        name = wxluaT_typename(L, wxl_type);

        arrStr.Add(wxString::Format(wxT("%s(%p)"), name.c_str(), lua_touserdata(L, -2)));

        lua_pop(L, 1); // pop value, lua_next will pop key at end
    }

    lua_pop(L, 1); // pop table

    arrStr.Sort();
    return arrStr;
}

void LUACALL wxluaO_trackweakobject(lua_State *L, int udata_stack_idx, void *obj_ptr, int wxl_type)
{
    lua_pushlightuserdata(L, &wxlua_lreg_weakobjects_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                      // pop key, push value (the obj table)

    lua_pushlightuserdata(L, obj_ptr); // push key
    lua_rawget(L, -2);

    if (lua_isnil(L, -1)) // not tracked yet, create new table to store items
    {
        lua_pop(L, 1); // pop nil

        lua_pushlightuserdata(L, obj_ptr);
        lua_newtable(L);
          lua_newtable(L);                    // metatable
            lua_pushlstring(L, "__mode", 6);
            lua_pushlstring(L, "v", 1);
            lua_rawset(L, -3);                // set mode of main table
          lua_setmetatable(L, -2);            // via the metatable
        lua_rawset(L, -3);

        lua_pushlightuserdata(L, obj_ptr); // get the table back
        lua_rawget(L, -2);
    }
    else
    {
        // check for dupes since that's what we're trying to avoid
        lua_pushnumber(L, wxl_type);
        lua_rawget(L, -2);
        // this must never happen
        if (!lua_isnil(L, -1))
        {
            wxFAIL_MSG(wxT("Trying to push userdata for object with same wxLua type twice"));
        }
        lua_pop(L, 1); // pop nil
    }

    lua_pushnumber(L, wxl_type);
    lua_pushvalue(L, ABS_LUA_STKIDX(udata_stack_idx, 3)); // push the Lua userdata as the value (note: weak valued table)
    lua_rawset(L, -3);    // t[key] = value; pops key and value
    lua_pop(L, 2);        // pop weakobj table and obj_ptr table
}

int LUACALL wxluaO_untrackweakobject(lua_State *L, void* udata, void *obj_ptr)
{
    lua_pushlightuserdata(L, &wxlua_lreg_weakobjects_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                      // pop key, push value (the object table)

    lua_pushlightuserdata(L, (void*)obj_ptr); // push key
    lua_rawget(L, -2);                        // get t[key] = value; pop key push value

    int count = 0;

    if (lua_istable(L, -1))
    {
        // clear the metatables for the userdata
        lua_pushnil(L);
        while (lua_next(L, -2) != 0)
        {
            // value = -1, key = -2, table = -3
            void *u = lua_touserdata(L, -1);

            if ((udata == NULL) || (udata == u))
            {
                lua_pushnil(L);
                lua_setmetatable(L, -2); // remove value's metatable
            }

            if (udata == u)
            {
                lua_pop(L, 1);        // pop value

                lua_pushvalue(L, -1); // copy key for next iteration
                lua_pushnil(L);
                lua_rawset(L, -4);    // set t[key] = nil to remove it
            }
            else
            {
                ++count;       // only count ones that still exist
                lua_pop(L, 1); // pop value, leave key for next iteration
            }
        }

        lua_pop(L, 1); // pop obj_ptr table

        // If we've cleared everything then remove the table
        if ((udata == NULL) || (count == 0))
        {
            count = 0;                                // removed them all
            lua_pushlightuserdata(L, (void*)obj_ptr); // push key
            lua_pushnil(L);                           // push value
            lua_rawset(L, -3);                        // set t[key] = nil; pops key and value
        }

        lua_pop(L, 1);                            // pop objects table
    }
    else
        lua_pop(L, 2); // pop nil and weakobj table

    return count;
}

bool LUACALL wxluaO_istrackedweakobject(lua_State *L, void *obj_ptr, int wxl_type, bool push_on_stack)
{
    lua_pushlightuserdata(L, &wxlua_lreg_weakobjects_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);   // pop key, push value (the obj table)

    lua_pushlightuserdata(L, obj_ptr); // push key
    lua_rawget(L, -2);                 // get t[key] value; pop key push value

    if (lua_istable(L, -1))
    {
        lua_pushnumber(L, wxl_type); // push key
        lua_rawget(L, -2);           // get t[key] = value; pops key

        // check if they've dynamic casted the object or if it was casted in C++
        if (wxl_type == wxluaT_type(L, -1))
        {
            if (push_on_stack)
            {
                lua_remove(L, -3); // remove the obj table, leave value on the stack
                lua_remove(L, -2); // remove table of userdata, leave value on the stack
            }
            else
                lua_pop(L, 3);

            return true;
        }
        else
            lua_pop(L, 1); // pop the userdata that is not the right type
    }

    lua_pop(L, 2); // pop the weakobj table and the nil.
    return false;
}

wxArrayString LUACALL wxluaO_gettrackedweakobjectinfo(lua_State *L)
{
    wxArrayString arrStr;

    lua_pushlightuserdata(L, &wxlua_lreg_weakobjects_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                      // pop key, push value (table)

    lua_pushnil(L);
    while (lua_next(L, -2) != 0)
    {
        // value = -1, key = -2, table = -3
        void* obj_ptr = lua_touserdata(L, -2); // actually lightuserdata

        wxString name;

        // iterate the table of userdata
        lua_pushnil(L);
        while (lua_next(L, -2) != 0)
        {
            // value = -1, key = -2, table = -3
            int wxl_type = (int)lua_tonumber(L, -2);
            if (!name.IsEmpty()) name += wxT(", ");
            name += wxString::Format(wxT("%s(%p, type=%d)"), wxluaT_typename(L, wxl_type).c_str(), lua_touserdata(L, -1), wxl_type);
            lua_pop(L, 1); // pop value, lua_next will pop key at end
        }

        arrStr.Add(wxString::Format(wxT("%p = %s"), obj_ptr, name.c_str()));

        lua_pop(L, 1); // pop value, lua_next will pop key at end
    }

    lua_pop(L, 1); // pop table

    arrStr.Sort();
    return arrStr;
}

// ----------------------------------------------------------------------------
// wxluaW_XXX - functions operate on tracked wxWindows
// ----------------------------------------------------------------------------

void LUACALL wxluaW_addtrackedwindow(lua_State *L, wxObject* wxobj)
{
    if (!wxobj) return; // allow NULL w/o error

    // don't track these "windows" since they're supposed to be attached
    // and their parents are not properly set so we can't tell if
    // their parents are tracked.
    if (wxDynamicCast(wxobj, wxMenuBar) != NULL) return;
    if (wxDynamicCast(wxobj, wxToolBar) != NULL) return;

    wxWindow* win = wxDynamicCast(wxobj, wxWindow);

    // only need to track parent window, it deletes children for us
    if (win && !wxluaW_istrackedwindow(L, win, true))
    {
        lua_pushlightuserdata(L, &wxlua_lreg_topwindows_key); // push key
        lua_rawget(L, LUA_REGISTRYINDEX);                     // pop key, push value (table)

        lua_pushlightuserdata(L, win); // push key
        lua_pushnumber(L, 1);          // push value
        lua_rawset(L, -3);             // set t[key] = value, pops key and value

        lua_pop(L, 1); // pop topwindows table
    }
}

void LUACALL wxluaW_removetrackedwindow(lua_State *L, wxWindow* win)
{
    lua_pushlightuserdata(L, &wxlua_lreg_topwindows_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                     // pop key, push value (table)

    lua_pushlightuserdata(L, win); // push key
    lua_pushnil(L);                // push value
    lua_rawset(L, -3);             // set t[key] = value, pops key and value

    lua_pop(L, 1); // pop topwindows table
}

bool LUACALL wxluaW_istrackedwindow(lua_State *L, wxWindow* win, bool check_parents)
{
    lua_pushlightuserdata(L, &wxlua_lreg_topwindows_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                     // pop key, push value (table)

    wxWindow* parent = win;

    while (parent)
    {
        lua_pushlightuserdata(L, parent); // push key
        lua_rawget(L, -2);                // pop key, push value

        if (lua_isnumber(L, -1))
        {
            lua_pop(L, 2); // pop topwindows table and value
            return true;
        }

        parent = check_parents ? parent->GetParent() : NULL;
        lua_pop(L, 1); // pop value (nil)
    }

    lua_pop(L, 1); // pop topwindows table

    return false;
}

wxArrayString LUACALL wxluaW_gettrackedwindowinfo(lua_State *L)
{
    wxArrayString arrStr;

    lua_pushlightuserdata(L, &wxlua_lreg_topwindows_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                     // pop key, push value (table)

    lua_pushnil(L);
    while (lua_next(L, -2) != 0)
    {
        // value = -1, key = -2, table = -3
        wxWindow* win = (wxWindow*)lua_touserdata(L, -2);
        wxCHECK_MSG(win, arrStr, wxT("Invalid wxWindow"));

        wxString name(win->GetClassInfo()->GetClassName());
        arrStr.Add(wxString::Format(wxT("%s(%p id=%d)"), name.c_str(), win, win->GetId()));

        lua_pop(L, 1); // pop value, lua_next will pop key at end
    }

    lua_pop(L, 1); // pop table

    arrStr.Sort();
    return arrStr;
}

// ----------------------------------------------------------------------------
// wxluaT_XXX - functions operate on the wxLua types
// ----------------------------------------------------------------------------

int wxluaT_newmetatable(lua_State* L, int wxl_type)
{
    lua_newtable(L);                                     // create a table for our new type
    lua_pushlightuserdata(L, &wxlua_metatable_type_key); // push key
    lua_pushnumber(L, wxl_type);                         // push value
    lua_rawset(L, -3);                                   // set t[key] = value; pop key and value

    lua_pushlightuserdata(L, &wxlua_lreg_types_key);     // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                    // pop key, push value (table)

    // make sure that the Lua table array is contiguous
    int len = (int)lua_objlen(L, -1);                    // get the length of the table
    while (++len < wxl_type)
    {
        lua_pushnumber(L, 0);
        lua_rawseti(L, -2, len);
    }

    // It is not allowed to reregister this type
    lua_rawgeti(L, -1, wxl_type);
    int t = lua_type(L, -1);
    wxCHECK_MSG((t == LUA_TNUMBER) || (t == LUA_TNIL), WXLUA_TUNKNOWN, wxT("Attempting to reregister wxLua type"));
    lua_pop(L, 1);

    // Add the metatable to the wxlua_lreg_types_key table
    lua_pushvalue(L, -2);                                // copy the metatable
    lua_rawseti(L, -2, wxl_type);                        // add it, pops table
    lua_pop(L, 1);                                       // pop wxlua_lreg_types_key table

    return wxl_type; // leave the table on the stack
}

bool LUACALL wxluaT_getmetatable(lua_State* L, int wxl_type)
{
    if (wxluaR_getref(L, wxl_type, &wxlua_lreg_types_key)) // get the metatable
    {
        if (lua_type(L, -1) == LUA_TTABLE)
            return true;

        lua_pop(L, 1); // pop nil or 0 placeholder
    }

    return false;
}

bool LUACALL wxluaT_setmetatable(lua_State *L, int wxl_type)
{
    if (wxluaT_getmetatable(L, wxl_type)) // get the metatable
    {
        // set it as the metatable of the object at the top of the stack
        if (lua_setmetatable(L, -2)) // pops table
            return true;
        else
        {
            lua_pop(L, 1); // pop table
            wxlua_error(L, "wxLua: Unable to set metatable in wxluaT_setmetatable.");
        }
    }
    else
        wxlua_error(L, "wxLua: Unable to get metatable in wxluaT_setmetatable.");

    return false;
}

int LUACALL wxluaT_type(lua_State *L, int stack_idx)
{
    int wxl_type = WXLUA_TUNKNOWN;
    int ltype = lua_type(L, stack_idx);

    if ((ltype == LUA_TUSERDATA) && lua_getmetatable(L, stack_idx)) // see wxluaT_newmetatable()
    {
        lua_pushlightuserdata(L, &wxlua_metatable_type_key); // push key
        lua_rawget(L, -2);                                   // get t[key] = value; pop key push value
        wxl_type = (int)lua_tonumber(L, -1); // if !isnumber it returns 0 (check below is faster)

        // if it's not a number (it's probably nil) then it's someone else's userdata
        if ((wxl_type == 0) && !lua_isnumber(L, -1))
            wxl_type = WXLUA_TUSERDATA;

        lua_pop(L, 2); // pop metatable and wxl_type number
    }
    else
        wxl_type = wxlua_luatowxluatype(ltype);

    return wxl_type;
}

wxString LUACALL wxluaT_typename(lua_State* L, int wxl_type)
{
    // try to use wxString's ref counting and return this existing copy
    static wxString s[14] = {
        wxT("unknown"),
        wxT("none"),
        wxT("nil"),
        wxT("boolean"),
        wxT("lightuserdata"),
        wxT("number"),
        wxT("string"),
        wxT("table"),
        wxT("function"),
        wxT("userdata"),
        wxT("thread"),
        wxT("integer"),
        wxT("cfunction"),
        wxT("pointer")
    };

    // Check for real type or this is a predefined WXLUA_TXXX type
    if ((L == NULL) || (WXLUAT_IS_LUAT(wxl_type)))
    {
        switch (wxl_type)
        {
            case WXLUA_TUNKNOWN :       return s[0];
            case WXLUA_TNONE :          return s[1];
            case WXLUA_TNIL :           return s[2];
            case WXLUA_TBOOLEAN :       return s[3];
            case WXLUA_TLIGHTUSERDATA : return s[4];
            case WXLUA_TNUMBER :        return s[5];
            case WXLUA_TSTRING :        return s[6];
            case WXLUA_TTABLE :         return s[7];
            case WXLUA_TFUNCTION :      return s[8];
            case WXLUA_TUSERDATA :      return s[9];
            case WXLUA_TTHREAD :        return s[10];

            case WXLUA_TINTEGER :       return s[11];
            case WXLUA_TCFUNCTION :     return s[12];
            case WXLUA_TPOINTER :       return s[13];
        }
    }
    else
    {
        const wxLuaBindClass* wxlClass = wxluaT_getclass(L, wxl_type);
        if (wxlClass)
            return lua2wx(wxlClass->name);
    }

    return wxT("Unknown wxLua Type?");
}

wxString LUACALL wxluaT_gettypename(lua_State* L, int stack_idx)
{
    return wxluaT_typename(L, wxluaT_type(L, stack_idx));
}

wxString LUACALL wxlua_luaL_typename(lua_State* L, int stack_idx)
{
    // lua_typename(L, lua_type(L, stack_idx))
    return lua2wx(luaL_typename(L, stack_idx));
}

int LUACALL wxluaT_gettype(lua_State* L, const char* class_name)
{
    const wxLuaBindClass* wxlClass = wxluaT_getclass(L, class_name);
    if (wxlClass)
        return *wxlClass->wxluatype;

    return WXLUA_TUNKNOWN;
}

const wxLuaBindClass* LUACALL wxluaT_getclass(lua_State* L, int wxl_type)
{
    // note: wxluaT_getmetatable() doesn't leave anything on the stack on failure
    if (wxluaT_getmetatable(L, wxl_type))
    {
        // t[wxluatype] = { [bindclass_key] = lightuserdata wxLuaBindClass... (or nil if not a wxLua class type)
        lua_pushlightuserdata(L, &wxlua_metatable_wxluabindclass_key);
        lua_rawget(L, -2);
        const wxLuaBindClass* wxlClass = (wxLuaBindClass *)lua_touserdata(L, -1); // actually lightuserdata

        lua_pop(L, 2); // pop type table and lightuserdata (or nil if none)

        return wxlClass;
    }

    return NULL;
}

const wxLuaBindClass* LUACALL wxluaT_getclass(lua_State* L, const char* class_name)
{
    lua_pushlightuserdata(L, &wxlua_lreg_classes_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                  // pop key, push value (table)

    lua_pushstring(L, class_name); // push key
    lua_rawget(L, -2);             // get t["class_name"] = &wxLuaBindClass; pop key push value
    const wxLuaBindClass* wxlClass = (wxLuaBindClass *)lua_touserdata(L, -1); // actually lightuserdata

    lua_pop(L, 2); // pop table and lightuserdata (or nil if none)

    return wxlClass; // may be NULL
}

bool wxluaT_isuserdatatype(lua_State* L, int stack_idx, int wxl_type)
{
    int stack_type = wxluaT_type(L, stack_idx);

    if (wxlua_iswxuserdatatype(stack_type) &&
        ((wxluatype_NULL == stack_type) || // FIXME, how to check when NULL is valid or not?
        ((wxl_type == WXLUA_TSTRING) && (wxluaT_isderivedtype(L, stack_type, *p_wxluatype_wxString) >= 0)) ||
        (wxluaT_isderivedtype(L, stack_type, wxl_type) >= 0)))
        return true;

    return false;
}

// Note about multiple inheritance in wxLua :
// See wxLuaBindClass::baseclass_vtable_offsets
//
// class A { int x; }; class B { int y; }; class AB : public A, public B { int z; };
// AB ab; void *v_ab_a = (A*)&ab; void *v_ab_b = (B*)&ab;
// long int dummy = 0;
// long int AB_diff = ((long int)(B*)(AB*)&dummy) - ((long int)(A*)(AB*)&dummy);
// wxPrintf(wxT("AB*=%p, A*=%p, B*=%p, B*-A*=%d\n"), &ab, v_ab_a, v_ab_b, AB_diff);
// prints: "AB*=0x614dfc, A*=0x614dfc, B*=0x614e00, B*-A*=4"
//
// In order to call B's functions from a void* pointer to an AB object :
// 1) Ideally, we cast to an AB object and the compiler will appropriately lookup
//    and handle calls to B's functions.
// 2) Cast to an AB object then to a B object where the compiler has already
//    shifted the pointer and calls to B's functions are made directly.
// 3) Explicitly shift the void* pointer to the AB object to where the vtable for
//    B is. We now have an object that only knows about B and what B was derived from.
//    I'm sure this is frowned upon by C++ enthusiasts.
//
// Ways of doing 1 and 2 in wxLua with C++ constraints, wxLua does #3 above.
//
// 1) wxLua would duplicate all the the binding functions for second
//    and higher base classes and therefore each binding function will cast the
//    void* we get from Lua to exactly the object type that it is. This is best,
//    but it adds bloat.
// 2) Come up with a clever way using overloaded functions, templates,
//    or some sort of variant class to convert the void* pointer from Lua to
//    type of object that it really is (we know by the wxLuaType integer)
//    and then the binding function will cast it whatever base class it may be.
//    The problem is that we really need to overload this casting function by
//    return type, the function takes void* and returns ClassXYZ*, but this
//    is not allowed in C++.
// 3) Store an array of the offsets in each classes' wxLuaBindClass struct
//    to the second or higher base classes and automatically add this offset in
//    wxluaT_getuserdatatype(). The offsets are calculated at compile time
//    using the AB_diff method above.
//
// Various ways to cast a void* pointer to the second base class :
// void* v_ab = &ab;   // compilier doesn't know what v_ab is anymore
// AB* ab = (AB*)v_ab; // ok since we cast right back to original type
// A*  a  = (A*)v_ab;  // ok in GCC & MSVC since we are casting to 1st base class
// B*  b  = (B*)v_ab;  // segfault! since B*'s vtable is +4 bytes as shown above
// B*  b1 = (B*)(AB*)v_ab; // ok since compiler converts to AB* and knows that B* is shifted
// B*  b2 = (B*)((long int)v_ab + AB_diff); // ok since we've shifted to B


// forward declaration
static int wxluaT_isderivedtype_recurser(const wxLuaBindClass *wxlClass, int base_wxl_type, int levels, int* baseclass_n);

void* LUACALL wxluaT_getuserdatatype(lua_State* L, int stack_idx, int wxl_type)
{
    int stack_type = wxluaT_type(L, stack_idx);

    if (wxluatype_NULL == stack_type)
        return NULL;

    // Note: we directly use the recurser function since we may need the wxLuaBindClass
    //int level = wxluaT_isderivedtype(L, stack_type, wxl_type);

    int baseclass_n = 0;
    const wxLuaBindClass* wxlClass = wxluaT_getclass(L, stack_type);
    int level = wxluaT_isderivedtype_recurser(wxlClass, wxl_type, 0, &baseclass_n);

    if ((level >= 0) && (baseclass_n == 0))
    {
        // We can directly cast the void* pointer to the baseclass if baseclass_n == 0
        return wxlua_touserdata(L, stack_idx, false);
    }
    else if (level > 0)
    {
        // The class on the stack is derived from a second or higher base class
        // and therefore the pointer to the base class is not the same as the
        // pointer to the class object on the stack. We need to shift the
        // pointer by the number of bytes in wxLuaBindClass::baseclass_vtable_offsets
        // so that when it is casted to the base class we don't segfault.
        long int o = (long int)wxlua_touserdata(L, stack_idx, false);

        if (wxlClass->baseclass_wxluatypes)
        {
            int i = 0;
            while (wxlClass->baseclass_wxluatypes[i]) // NULL terminated, the baseclass_vtable_offsets is not
            {
                if (*(wxlClass->baseclass_wxluatypes[i]) == wxl_type)
                {
                    o += wxlClass->baseclass_vtable_offsets[i];
                    break;
                }
                i++;
            }
        }

        return (void*)o;
    }



    wxlua_argerror(L, stack_idx, wxT("a '") + wxluaT_typename(L, wxl_type) + wxT("'"));

    return NULL;
}

bool LUACALL wxluaT_pushuserdatatype(lua_State* L, const void *obj_ptr, int wxl_type, bool track, bool allow_NULL)
{
    // FIXME allow_NULL is a hack for the NULL userdata type.

    if (allow_NULL || (obj_ptr != NULL))
    {
        // First check to see if we've already pushed this object into Lua.
        // This avoids the problem of the gc deleting a returned pointer to a permanent object.
        // Test code is this:
        // il = wx.wxImageList(16,16); ... noteBook:SetImageList(il); ... local il2 = noteBook:GetImageList()
        // When il2 gets gc it will delete il even though il may still be valid and used by the notebook.

        if (wxluaO_istrackedweakobject(L, (void*)obj_ptr, wxl_type, true))
            return true;

        // if the object we are referencing is derived from wxWindow
        if (obj_ptr && (wxluaT_isderivedtype(L, wxl_type, *p_wxluatype_wxWindow) >= 0))
        {
            wxWindow* win = wxDynamicCast(obj_ptr, wxWindow); // double check that it's a wxWindow
            if (win != NULL)
            {
                // check to make sure that we're not trying to attach another destroy callback
                lua_pushlightuserdata(L, &wxlua_lreg_windestroycallbacks_key); // push key
                lua_rawget(L, LUA_REGISTRYINDEX);                              // pop key, push value (table)

                lua_pushlightuserdata(L, win); // push key
                lua_rawget(L, -2);             // get t[key] = value; pops key

                if (!lua_islightuserdata(L, -1))
                {
                    // Connect the wxWindow to wxEVT_DESTROY callback so if Lua has
                    // a copy(s) of it we can clear the metatable when we get the
                    // event so we don't segfault if we try to access it by accident.
                    wxLuaState wxlState(L);
                    wxCHECK_MSG(wxlState.Ok(), false, wxT("Invalid wxLuaState"));
                    wxLuaWinDestroyCallback *pCallback =
                            new wxLuaWinDestroyCallback(wxlState, win);

                    if (pCallback == NULL)
                        wxlua_error(L, "wxLua: Out of memory creating wxLuaWinDestroyCallback.");
                    // assert should have been given in constructor so delete it
                    // since it's not attached as a callback user data
                    if (!pCallback->Ok())
                        delete pCallback;
                }

                lua_pop(L, 2); // pop windestroy table and value
            }
        }

        // Wrap the void* pointer in a newuserdata
        const void **ptr = (const void **)lua_newuserdata(L, sizeof(void *));
        if (ptr != NULL)
        {
            *ptr = obj_ptr;
            // try to get the object's references table and set the metatable to the object
            if (wxluaT_getmetatable(L, wxl_type))
            {
                // pop the table and set it as the metatable for the newuserdata
                lua_setmetatable(L, -2);

                if (track)
                    wxluaO_trackweakobject(L, -1, (void*)obj_ptr, wxl_type);

                return true; // leave value on the stack
            }
            else
                wxlua_error(L, "wxLua: Unable to get metatable in wxluaT_pushuserdatatype.");
        }
        else
            wxlua_error(L, "wxLua: Out of memory");
    }
    else
    {
        lua_pushnil(L);
        return true;
    }

    return false;
}

// ----------------------------------------------------------------------------
// Functions to get info about the wxLua types
// ----------------------------------------------------------------------------

static int wxluaT_isderivedtype_recurser(const wxLuaBindClass *wxlClass, int base_wxl_type, int levels, int* baseclass_n)
{
    if (wxlClass != NULL)
    {
        // check that input isn't what we want first since this func is used in a couple places
        if (*wxlClass->wxluatype == base_wxl_type)
            return levels;
        else if (wxlClass->baseclassNames != NULL) // check baseclass by baseclass
        {
            for (size_t i = 0; wxlClass->baseclassNames[i]; ++i)
            {
                // Note: base class may be NULL if lib/module containing it is not loaded
                wxLuaBindClass* baseClass = wxlClass->baseBindClasses[i];

                if (baseClass != NULL)
                {
                    if (*baseClass->wxluatype == base_wxl_type)
                    {
                        if (baseclass_n) *baseclass_n = wxMax(*baseclass_n, (int)i);
                        return levels+1;
                    }
                    else
                    {
                        // create a new baseclass_n since we may be going down the wrong path
                        // and we do not want to change the original.
                        int baseclass_n_tmp = wxMax(baseclass_n ? *baseclass_n : 0, (int)i);
                        int ret = wxluaT_isderivedtype_recurser(baseClass, base_wxl_type, levels+1, &baseclass_n_tmp);
                        if (ret > -1)
                        {
                            // now set the baseclass_n var to the tmp one
                            if (baseclass_n) *baseclass_n = wxMax(baseclass_n_tmp, (int)i);
                            return ret;
                        }
                    }
                }
            }
        }
    }

    return -1; // wxluatype is not derived from base_wxluatype
}

int LUACALL wxluaT_isderivedtype(lua_State* L, int wxl_type, int base_wxl_type, int* baseclass_n)
{
    // couldn't possibly be derived from each other
    if (!wxlua_iswxuserdatatype(wxl_type) || !wxlua_iswxuserdatatype(base_wxl_type))
        return -1;

    // These two types are the same, yes recurser also checks, but this is faster
    if (wxl_type == base_wxl_type)
        return 0;

    const wxLuaBindClass *wxlClass = wxluaT_getclass(L, wxl_type);

    if (baseclass_n != NULL) *baseclass_n = 0;

    return wxluaT_isderivedtype_recurser(wxlClass, base_wxl_type, 0, baseclass_n);
}

int LUACALL wxluaT_isderivedclass(const wxLuaBindClass* wxlClass, const wxLuaBindClass* base_wxlClass, int* baseclass_n)
{
    // Ok if either is NULL to allow blindly calling this
    if ((wxlClass == NULL) || (base_wxlClass == NULL))
        return -1;

    // These two types are the same
    if (wxlClass->wxluatype == base_wxlClass->wxluatype) // comparing pointers
        return 0;

    if (baseclass_n != NULL) *baseclass_n = 0;

    return wxluaT_isderivedtype_recurser(wxlClass, *base_wxlClass->wxluatype, 1, baseclass_n);
}

int LUACALL wxlua_iswxluatype(int luatype, int wxl_type, lua_State* L /* = NULL */)
{
    int ret = -1; // unknown wxlua arg type

    switch (wxl_type)
    {
        case WXLUA_TNONE :
            ret = (luatype == LUA_TNONE) ? 1 : 0;
            break;
        case WXLUA_TNIL :
            ret = (luatype == LUA_TNIL) ? 1 : 0;
            break;
        case WXLUA_TBOOLEAN :
            // LUA_TNIL:    nil == false
            // LUA_TNUMBER: 0 == false as in C
            ret = ((luatype == LUA_TBOOLEAN) || (luatype == LUA_TNUMBER) || (luatype == LUA_TNIL)) ? 1 : 0;
            break;
        case WXLUA_TLIGHTUSERDATA:
            ret = (luatype == LUA_TLIGHTUSERDATA) ? 1 : 0;
            break;
        case WXLUA_TNUMBER :
            // LUA_TNIL:     evaluates to 0, too easy to have a typo
            // LUA_TSTRING:  will be 0 unless really a number "2"
            // LUA_TBOOLEAN: can't do (bool_val or 1)
            ret = ((luatype == LUA_TNUMBER) || (luatype == LUA_TBOOLEAN)) ? 1 : 0;
            break;
        case WXLUA_TSTRING :
            // LUA_TNIL:    too easy to have a variable typo, use (str or "")
            // LUA_TNUMBER: can convert easily, always works, but breaks overload bindings
            ret = (luatype == LUA_TSTRING) ? 1 : 0;
            break;
        case WXLUA_TTABLE :
            ret = (luatype == LUA_TTABLE) ? 1 : 0;
            break;
        case WXLUA_TFUNCTION :
            ret = (luatype == LUA_TFUNCTION) ? 1 : 0;
            break;
        case WXLUA_TUSERDATA :
            ret = (luatype == LUA_TUSERDATA) ? 1 : 0;
            break;
        case WXLUA_TTHREAD :
            ret = (luatype == LUA_TTHREAD) ? 1 : 0;
            break;
        case WXLUA_TINTEGER :
            // LUA_TNIL: evaluates to 0 so wx.ENUM_typo = 0
            ret = (luatype == LUA_TNUMBER) ? 1 : 0;
            break;
        case WXLUA_TCFUNCTION :
            ret = (luatype == LUA_TFUNCTION) ? 1 : 0;
            break;
        case WXLUA_TPOINTER :
            ret = (luatype == LUA_TLIGHTUSERDATA) || (luatype == LUA_TUSERDATA) ||
                  (luatype == LUA_TFUNCTION) || (luatype == LUA_TTABLE) ||
                  (luatype == LUA_TTHREAD) ? 1 : 0;
            break;
        case WXLUA_TANY :
            ret = 1; // any type is acceptable
            break;
    }

    // if we don't know the type (it's not predefined)
    if ((ret < 0) && L &&(luatype == LUA_TTABLE))
    {
        const wxLuaBindClass* wxlClass = wxluaT_getclass(L, wxl_type);

        if (wxluaT_isderivedclass(wxlClass, wxluaT_getclass(L, "wxArrayString")) >= 0)
            ret = 1;
        else if (wxluaT_isderivedclass(wxlClass, wxluaT_getclass(L, "wxSortedArrayString")) >= 0)
            ret = 1;
        else if (wxluaT_isderivedclass(wxlClass, wxluaT_getclass(L, "wxArrayInt")) >= 0)
            ret = 1;
    }

    return ret;
}

int wxlua_luatowxluatype(int luatype)
{
    //int wxltype = LUAT_TO_WXLUAT(luatype);
    //if (!WXLUAT_IS_LUAT(wxltype))
    //    return WXLUA_TUNKNOWN;
    //return wxltype;

    switch (luatype)
    {
        case LUA_TNONE          : return WXLUA_TNONE;
        case LUA_TNIL           : return WXLUA_TNIL;
        case LUA_TBOOLEAN       : return WXLUA_TBOOLEAN;
        case LUA_TLIGHTUSERDATA : return WXLUA_TLIGHTUSERDATA;
        case LUA_TNUMBER        : return WXLUA_TNUMBER;
        case LUA_TSTRING        : return WXLUA_TSTRING;
        case LUA_TTABLE         : return WXLUA_TTABLE;
        case LUA_TFUNCTION      : return WXLUA_TFUNCTION;
        case LUA_TUSERDATA      : return WXLUA_TUSERDATA;
        case LUA_TTHREAD        : return WXLUA_TTHREAD;
        //case LUA_T???         : return WXLUA_TINTEGER;
        //case LUA_T???         : return WXLUA_TCFUNCTION;
        //case LUA_T???         : return WXLUA_TPOINTER;
    }

    return WXLUA_TUNKNOWN;
}

int wxlua_wxluatoluatype(int wxlarg)
{
    switch (wxlarg)
    {
        case WXLUA_TNONE :          return LUA_TNONE;
        case WXLUA_TNIL :           return LUA_TNIL;
        case WXLUA_TBOOLEAN :       return LUA_TBOOLEAN;
        case WXLUA_TLIGHTUSERDATA : return LUA_TLIGHTUSERDATA;
        case WXLUA_TNUMBER :        return LUA_TNUMBER;
        case WXLUA_TSTRING :        return LUA_TSTRING;
        case WXLUA_TTABLE :         return LUA_TTABLE;
        case WXLUA_TFUNCTION :      return LUA_TFUNCTION;
        case WXLUA_TUSERDATA :      return LUA_TUSERDATA;
        case WXLUA_TTHREAD :        return LUA_TTHREAD;
        case WXLUA_TINTEGER :       return LUA_TNUMBER;
        case WXLUA_TCFUNCTION :     return LUA_TFUNCTION;
        //case WXLUA_TPOINTER :       return LUA_T???; multiple types
    }

    return -1;
}

bool wxlua_iswxstringtype(lua_State* L, int stack_idx)
{
    // NOTE: If we ever allow numbers to be coerced to strings we must
    // change how we handle lua_tostring() calls since it will change a number
    // to a string on the stack. This could break people's code.
    if (wxlua_iswxluatype(lua_type(L, stack_idx), WXLUA_TSTRING) == 1)
        return true;
    else if (wxlua_iswxuserdata(L, stack_idx))
    {
        int wxl_type = wxluaT_type(L, stack_idx);
        return (wxluaT_isderivedtype(L, wxl_type, *p_wxluatype_wxString) >= 0);
    }

    return false;
}

const char* LUACALL wxlua_getstringtype(lua_State *L, int stack_idx)
{
    if (wxlua_isstringtype(L, stack_idx))
        return lua_tostring(L, stack_idx);
    else if (wxlua_iswxuserdata(L, stack_idx))
    {
        int stack_type = wxluaT_type(L, stack_idx);

        if (wxluaT_isderivedtype(L, stack_type, *p_wxluatype_wxString) >= 0)
        {
            wxString* wxstr = (wxString*)wxlua_touserdata(L, stack_idx, false);
            wxCHECK_MSG(wxstr, NULL, wxT("Invalid userdata wxString"));
            return wx2lua(*wxstr);
        }
    }

    wxlua_argerror(L, stack_idx, wxT("a 'string' or 'wxString'"));

    return NULL;
}

wxString LUACALL wxlua_getwxStringtype(lua_State *L, int stack_idx)
{
    if (wxlua_isstringtype(L, stack_idx))
        return lua2wx(lua_tostring(L, stack_idx));
    else if (wxlua_iswxuserdata(L, stack_idx))
    {
        int stack_type = wxluaT_type(L, stack_idx);

        if (wxluaT_isderivedtype(L, stack_type, *p_wxluatype_wxString) >= 0)
        {
            wxString* wxstr = (wxString*)wxlua_touserdata(L, stack_idx, false);
            wxCHECK_MSG(wxstr, wxEmptyString, wxT("Invalid userdata wxString"));
            return *wxstr;
        }
    }

    wxlua_argerror(L, stack_idx, wxT("a 'string' or 'wxString'"));

    return wxEmptyString;
}

bool LUACALL wxlua_getbooleantype(lua_State *L, int stack_idx)
{
    int l_type = lua_type(L, stack_idx);

    if (!wxlua_iswxluatype(l_type, WXLUA_TBOOLEAN))
        wxlua_argerror(L, stack_idx, wxT("a 'boolean'"));

    int num = 0;
    // we also allow 0 = false and !0 = true (Lua thinks 0 == true, i.e. !nil)
    if (l_type == LUA_TNUMBER)
        num = (int)lua_tonumber(L, stack_idx);
    else
        num = (int)lua_toboolean(L, stack_idx);

    return (num != 0);
}
long LUACALL wxlua_getenumtype(lua_State *L, int stack_idx)
{
    int l_type = lua_type(L, stack_idx);

    if (!wxlua_iswxluatype(l_type, WXLUA_TINTEGER))
        wxlua_argerror(L, stack_idx, wxT("an 'integer enum'"));

    // we don't allow bool or round, enums must strictly be integers
    double value = lua_tonumber(L, stack_idx);
    long long_value = (long)value;

    if (value != long_value)
        wxlua_argerror(L, stack_idx, wxT("an 'integer enum'"));

    return long_value;
}
long LUACALL wxlua_getintegertype(lua_State *L, int stack_idx)
{
    int l_type = lua_type(L, stack_idx);

    if (!wxlua_iswxluatype(l_type, WXLUA_TINTEGER))
        wxlua_argerror(L, stack_idx, wxT("an 'integer'"));

    double value = 0;
    // we also allow bool = 1/0 which Lua evaluates to nil in lua_tonumber
    if (l_type == LUA_TBOOLEAN)
        value = lua_toboolean(L, stack_idx) ? 1 : 0;
    else
        value = lua_tonumber(L, stack_idx);

    long long_value = (long)value;

    if (value != long_value)
        wxlua_argerror(L, stack_idx, wxT("an 'integer'"));

    return long_value;
}
unsigned long LUACALL wxlua_getuintegertype(lua_State *L, int stack_idx)
{
    int l_type = lua_type(L, stack_idx);

    if (!wxlua_iswxluatype(l_type, WXLUA_TINTEGER))
        wxlua_argerror(L, stack_idx, wxT("an 'unsigned integer'"));

    double value = 0;
    // we also allow bool = 1/0 which Lua evaluates to nil in lua_tonumber
    if (l_type == LUA_TBOOLEAN)
        value = lua_toboolean(L, stack_idx) ? 1 : 0;
    else
        value = lua_tonumber(L, stack_idx);

    unsigned long ulong_value = (unsigned long)value;

    if ((value != ulong_value) || (value < 0))
        wxlua_argerror(L, stack_idx, wxT("an 'unsigned integer'"));

    return ulong_value;
}
double LUACALL wxlua_getnumbertype(lua_State *L, int stack_idx)
{
    int l_type = lua_type(L, stack_idx);

    if (!wxlua_iswxluatype(l_type, WXLUA_TNUMBER))
        wxlua_argerror(L, stack_idx, wxT("a 'number'"));

    double value = 0;
    // we also allow bool = 1/0 which Lua evaluates to nil in lua_tonumber
    if (l_type == LUA_TBOOLEAN)
        value = lua_toboolean(L, stack_idx) ? 1 : 0;
    else
        value = lua_tonumber(L, stack_idx);

    return value;
}

void* LUACALL wxlua_getpointertype(lua_State* L, int stack_idx)
{
    int l_type = lua_type(L, stack_idx);

    if (!wxlua_iswxluatype(l_type, WXLUA_TPOINTER))
        wxlua_argerror(L, stack_idx, wxT("a 'pointer'"));

    void* value = (void *)lua_topointer(L, stack_idx);

    return value;
}

const char** LUACALL wxlua_getchararray(lua_State *L, int stack_idx, int &count)
{
    const char **arrChar = NULL;
    count = 0;

    if (lua_istable(L, stack_idx))
    {
        int table_len = lua_objlen(L, stack_idx);
        if (table_len > 0)
            arrChar = new const char *[table_len];

        if (arrChar != NULL)
        {
            for (int n = 0; n < table_len; ++n)
            {
                lua_rawgeti(L, stack_idx, n+1); // Lua array starts at 1
                const char *s = wxlua_getstringtype(L, -1);
                arrChar[n] = s; // share Lua string
                lua_pop(L, 1);
            }
        }

        count = table_len;
    }
    else
        wxlua_argerror(L, stack_idx, wxT("a 'table' array of strings"));

    return arrChar;
}

wxString* LUACALL wxlua_getwxStringarray(lua_State* L, int stack_idx, int& count)
{
    wxString *strArray = NULL;
    count = 0; // zero it in case we do a long jmp
    wxLuaSmartwxArrayString arr(wxlua_getwxArrayString(L, stack_idx));

    count = (int)((wxArrayString&)arr).GetCount();
    strArray = new wxString[count];
    for (int n = 0; n < count; ++n)
        strArray[n] = ((wxArrayString&)arr)[n];

    return strArray;
}

int* LUACALL wxlua_getintarray(lua_State* L, int stack_idx, int& count)
{
    int *intArray = NULL;
    count = 0; // zero it in case we do a long jmp
    wxLuaSmartwxArrayInt arr(wxlua_getwxArrayInt(L, stack_idx));

    count = (int)((wxArrayInt&)arr).GetCount();
    intArray = new int[count];
    for (int n = 0; n < count; ++n)
        intArray[n] = ((wxArrayInt&)arr)[n];

    return intArray;
}

wxLuaSmartwxArrayString LUACALL wxlua_getwxArrayString(lua_State* L, int stack_idx)
{
    wxLuaSmartwxArrayString arr(NULL, true); // will added to or replaced
    int count = -1;                          // used to check for failure

    if (lua_istable(L, stack_idx))
    {
        count = 0;

        while (1)
        {
            lua_rawgeti(L, stack_idx, count+1);

            if (wxlua_iswxstringtype(L, -1))
            {
                ((wxArrayString&)arr).Add(wxlua_getwxStringtype(L, -1));
                ++count;

                lua_pop(L, 1);
            }
            else if (lua_isnil(L, -1))
            {
                lua_pop(L, 1);
                break;
            }
            else
            {
                wxlua_argerror(L, stack_idx, wxT("a 'wxArrayString' or table array of strings"));
                return arr;
            }
        }
    }
    else if (wxlua_iswxuserdata(L, stack_idx))
    {
        int arrstr_wxltype = wxluaT_gettype(L, "wxArrayString");

        if (wxluaT_isuserdatatype(L, stack_idx, arrstr_wxltype))
        {
            wxArrayString *arrStr = (wxArrayString *)wxluaT_getuserdatatype(L, stack_idx, arrstr_wxltype);
            if (arrStr)
            {
                arr = wxLuaSmartwxArrayString(arrStr, false); // replace
                count = arrStr->GetCount();
            }
        }
    }

    if (count < 0)
        wxlua_argerror(L, stack_idx, wxT("a 'wxArrayString' or table array of strings"));

    return arr;
}

wxLuaSmartwxSortedArrayString LUACALL wxlua_getwxSortedArrayString(lua_State* L, int stack_idx)
{
    wxLuaSmartwxSortedArrayString arr(NULL, true); // will be replaced
    int count = -1;                                // used to check for failure

    if (lua_istable(L, stack_idx))
    {
        wxLuaSmartwxArrayString a = wxlua_getwxArrayString(L, stack_idx);
        arr = wxLuaSmartwxSortedArrayString(new wxSortedArrayString(a), true);
        count = 0;
    }
    else if (wxlua_iswxuserdata(L, stack_idx))
    {
        int arrstr_wxltype = wxluaT_gettype(L, "wxArrayString");

        if (wxluaT_isuserdatatype(L, stack_idx, arrstr_wxltype))
        {
            wxSortedArrayString *arrStr = (wxSortedArrayString *)wxluaT_getuserdatatype(L, stack_idx, arrstr_wxltype);
            if (arrStr)
            {
                arr = wxLuaSmartwxSortedArrayString(arrStr, false); // replace
                count = arrStr->GetCount();
            }
        }
    }

    if (count < 0)
        wxlua_argerror(L, stack_idx, wxT("a 'wxArrayString' or table array of strings"));

    return arr;
}

wxLuaSmartwxArrayInt LUACALL wxlua_getwxArrayInt(lua_State* L, int stack_idx)
{
    wxLuaSmartwxArrayInt arr(NULL, true); // will be replaced
    int count = -1;                       // used to check for failure

    if (lua_istable(L, stack_idx))
    {
        count = 0;

        while(1)
        {
            lua_rawgeti(L, stack_idx, count+1);

            if (wxlua_isnumbertype(L, -1))
            {
                ((wxArrayInt&)arr).Add((int)lua_tonumber(L, -1));
                ++count;

                lua_pop(L, 1);
            }
            else if (lua_isnil(L, -1))
            {
                lua_pop(L, 1);
                break;
            }
            else
            {
                wxlua_argerror(L, stack_idx, wxT("a 'wxArrayInt' or a table array of integers"));
                return arr;
            }
        }
    }
    else if (wxlua_iswxuserdata(L, stack_idx))
    {
        int arrint_wxltype = wxluaT_gettype(L, "wxArrayInt");

        if (wxluaT_isuserdatatype(L, stack_idx, arrint_wxltype))
        {
            wxArrayInt *arrInt = (wxArrayInt *)wxluaT_getuserdatatype(L, stack_idx, arrint_wxltype);
            if (arrInt)
            {
                arr = wxLuaSmartwxArrayInt(arrInt, false); // replace
                count = arrInt->GetCount();
            }
        }
    }

    if (count < 0)
        wxlua_argerror(L, stack_idx, wxT("a 'wxArrayInt' or a table array of integers"));

    return arr;
}

wxLuaSharedPtr<std::vector<wxPoint> > LUACALL wxlua_getwxPointArray(lua_State* L, int stack_idx)
{
    wxLuaSharedPtr<std::vector<wxPoint> > pointArray(new std::vector<wxPoint>);
    int count = -1;       // used to check for failure
    int is_xy_table = -1; // is it a table with x,y fields or a number array {1,2}

    if (lua_istable(L, stack_idx))
    {
        count = lua_objlen(L, stack_idx); /* get size of table */

        double x, y;
        for (int i = 1; i <= count; ++i)
        {
            lua_rawgeti(L, stack_idx, i); /* get next point as {x,y} */
            int t = wxluaT_type(L, -1);
            if (t == WXLUA_TTABLE)
            {
                // First time, check how it was formatted
                if (is_xy_table == -1)
                {
                    lua_rawgeti(L, -1, 1);
                    is_xy_table = (lua_isnumber(L, -1) == 0) ? 1 : 0;
                    lua_pop(L, 1);
                }

                if (is_xy_table == 1)
                {
                    lua_pushstring(L, "x");
                    lua_rawget(L, -2);
                    if (!lua_isnumber(L, -1))
                        wxlua_argerror(L, stack_idx, wxT("a 'number' for x-coordinate of a wxPoint array, valid tables are {{1,2},...}, {{x=1,y=2},...}, or {wx.wxPoint(1,2),,...}."));
                    x = lua_tonumber(L, -1);
                    lua_pop(L, 1);

                    lua_pushstring(L, "y");
                    lua_rawget(L, -2);
                    if (!lua_isnumber(L, -1))
                        wxlua_argerror(L, stack_idx, wxT("a 'number' for y-coordinate of a wxPoint array, valid tables are {{1,2},...}, {{x=1,y=2},...}, or {wx.wxPoint(1,2),,...}."));
                    y = lua_tonumber(L, -1);
                    lua_pop(L, 1);
                }
                else
                {
                    lua_rawgeti(L, -1, 1);
                    if (!lua_isnumber(L, -1))
                        wxlua_argerror(L, stack_idx, wxT("a 'number' for [1] index (x-coordinate) of a wxPoint array, valid tables {{1,2},...}, {{x=1,y=2},...}, or {wx.wxPoint(1,2),,...}."));
                    x = lua_tonumber(L, -1);
                    lua_pop(L, 1);

                    lua_rawgeti(L, -1, 2);
                    if (!lua_isnumber(L, -1))
                        wxlua_argerror(L, stack_idx, wxT("a 'number' for [2] index (y-coordinate) of a wxPoint array, valid tables {{1,2},...}, {{x=1,y=2},...}, or {wx.wxPoint(1,2),,...}."));
                    y = lua_tonumber(L,-1);
                    lua_pop(L, 1);
                }

                pointArray->push_back(wxPoint((int)x, (int)y));
            }
            else if (t == *p_wxluatype_wxPoint)
            {
                const wxPoint* point = (const wxPoint *)wxluaT_getuserdatatype(L, -1, *p_wxluatype_wxPoint);
                pointArray->push_back(*point);
            }
            else
            {
                wxlua_argerror(L, stack_idx, wxT("a Lua table of 'wxPoints', valid tables {{1,2},...}, {{x=1,y=2},...}, or {wx.wxPoint(1,2),,...}."));
                return pointArray;
            }

            lua_pop(L, 1);
        }
    }
/*

    // Binding the wxPointList is a problem since we have to worry about
    // wxList::DeleteContents() and who calls it, it'll be accident waiting to happen.

    else if (wxlua_iswxuserdata(L, stack_idx))
    {
        int pointlist_wxltype = wxluaT_gettype(L, "wxPointList");

        if (wxluaT_isuserdatatype(L, stack_idx, pointlist_wxltype))
        {
            wxPointList *ptList = (wxPointList *)wxluaT_getuserdatatype(L, stack_idx, pointlist_wxltype);
            if (ptList)
            {
                //pointArray.reset(ptList);
                //pointArray.SetDelete(false);
                count = ptList->GetCount();
            }
        }
    }
*/

    if (count < 0)
        wxlua_argerror(L, stack_idx, wxT("a Lua table of 'wxPoints', valid tables {{1,2},...}, {{x=1,y=2},...}, or {wx.wxPoint(1,2),,...}."));

    return pointArray;
}

int LUACALL wxlua_pushwxArrayStringtable(lua_State *L, const wxArrayString &strArray)
{
    size_t idx, count = strArray.GetCount();
    lua_createtable(L, count, 0);

    for (idx = 0; idx < count; ++idx)
    {
        wxlua_pushwxString(L, strArray[idx]);
        lua_rawseti(L, -2, idx + 1);
    }
    return idx;
}

int LUACALL wxlua_pushwxArrayInttable(lua_State *L, const wxArrayInt &intArray)
{
    size_t idx, count = intArray.GetCount();
    lua_createtable(L, count, 0);

    for (idx = 0; idx < count; ++idx)
    {
        lua_pushnumber(L, intArray[idx]);
        lua_rawseti(L, -2, idx + 1);
    }
    return idx;
}

void LUACALL wxlua_pushwxString(lua_State* L, const wxString& str)
{
    lua_pushstring(L, wx2lua(str));
}

wxString wxlua_concatwxArrayString(const wxArrayString& arr, const wxString& sep)
{
    wxString s;
    size_t n, count = arr.GetCount();
    for (n = 0; n < count; ++n)
    {
        s += arr[n];
        if (n < count - 1) s += sep;
    }

    return s;
}

int wxlua_pushargs(lua_State* L, wxChar **argv, int argc, int start_n)
{
    if (argc == 0) return 0;

    int i = 0;
    int narg = argc - (start_n + 1);  // number of arguments to the script
    luaL_checkstack(L, narg + 3, "too many arguments to script");
    for (i = start_n+1; i < argc; i++)
        lua_pushstring(L, wx2lua(argv[i]));

    lua_createtable(L, narg, start_n + 1);

    for (i = 0; i < argc; i++)
    {
        lua_pushstring(L, wx2lua(argv[i]));
        lua_rawseti(L, -2, i - start_n);
    }

    lua_setglobal(L, "arg");

    return narg;
}

//----------------------------------------------------------------------------
// Derived class member functions for classes in wxLua
//----------------------------------------------------------------------------

bool LUACALL wxlua_setderivedmethod(lua_State* L, void *obj_ptr, const char *method_name, wxLuaObject* wxlObj)
{
    lua_pushlightuserdata(L, &wxlua_lreg_derivedmethods_key); // push key
    lua_rawget( L, LUA_REGISTRYINDEX );                       // pop key, push value (table)

    lua_pushlightuserdata(L, (void *)obj_ptr); // push key
    lua_rawget(L, -2);                         // get t[key] = value, pop key push value

    if (!lua_istable(L, -1))
    {
        lua_pop(L, 1); // pop nil value

        // add new table for this object
        lua_pushlightuserdata(L, (void *)obj_ptr); // push key
        lua_newtable(L);                           // push value
        lua_rawset(L, -3);                         // set t[key] = value; pops key and value

        // put the new table back on the top of the stack
        lua_pushlightuserdata(L, (void *)obj_ptr);
        lua_rawget(L, -2);
    }
    else
    {
        // see if there already is a method
        lua_pushstring( L, method_name );
        lua_rawget(L, -2);

        if (lua_islightuserdata(L, -1))
        {
            // already have a method, delete it before replacing it
            wxLuaObject* o = (wxLuaObject*)lua_touserdata( L, -1 );
            o->RemoveReference(L);
            delete o;
        }

        lua_pop(L, 1); // pop the deleted old object, or nil
    }

    lua_pushstring( L, method_name );        // push key
    lua_pushlightuserdata(L, (void*)wxlObj); // push value
    lua_rawset(L, -3);                       // set t[key] = value; pops key and value

    lua_pop(L, 2); // pop the object and overridden function table

    return true;
}
bool LUACALL wxlua_hasderivedmethod(lua_State* L, const void *obj_ptr, const char *method_name, bool push_method)
{
    bool found = false;
    wxLuaObject* wxlObj = NULL;

    lua_pushlightuserdata(L, &wxlua_lreg_derivedmethods_key);
    lua_rawget( L, LUA_REGISTRYINDEX ); // pop key, push table

    lua_pushlightuserdata(L, (void *)obj_ptr);
    lua_rawget(L, -2); // pop key, push table or nil

    if (lua_istable(L, -1))
    {
        // see if there is a method with the same name
        lua_pushstring( L, method_name );
        lua_rawget(L, -2);

        if (lua_islightuserdata(L, -1))
            wxlObj = (wxLuaObject*)lua_touserdata( L, -1 );

        lua_pop(L, 1); // pop the method object or nil
    }

    lua_pop(L, 2); // pop registry table and object table or nil

    if (wxlObj != NULL)
    {
        // if we've got the object, put it on top of the stack
        if (push_method && wxlObj->GetObject(L))
            found = true;
        else if (!push_method)
            found = true;
    }

    return found;
}
bool LUACALL wxlua_removederivedmethods(lua_State* L, void *obj_ptr)
{
    bool found = false;

    lua_pushlightuserdata(L, &wxlua_lreg_derivedmethods_key);
    lua_rawget( L, LUA_REGISTRYINDEX ); // pop key, push table

    lua_pushlightuserdata(L, (void *)obj_ptr);
    lua_rawget(L, -2); // pop key, push table or nil

    if (lua_istable(L, -1))
    {
        found = true;

        // delete all of the derived methods we've pushed
        lua_pushnil(L);
        while (lua_next(L, -2) != 0)
        {
            // value at -1, key at -2, table at -3
            if (lua_islightuserdata(L, -1))
            {
                wxLuaObject* o = (wxLuaObject*)lua_touserdata(L, -1);
                o->RemoveReference(L);
                delete o;
            }

            lua_pop(L, 1); // remove value; keep key for next iteration
        }

        lua_pop(L, 1);     // pop the obj table

        lua_pushlightuserdata(L, (void *)obj_ptr); // push key
        lua_pushnil(L);                            // push value, to remove it
        lua_rawset(L, -3);                         // set t[key] = value; pop key and value

        lua_pop(L, 1); // pop the derived table
    }
    else
        lua_pop(L, 2); // pop the derived table and nil for the obj table

    return found;
}

//----------------------------------------------------------------------------
// Other functions for wxLua's keys in the
//----------------------------------------------------------------------------

bool LUACALL wxlua_getcallbaseclassfunction(lua_State* L)
{
    lua_pushlightuserdata(L, &wxlua_lreg_callbaseclassfunc_key);
    lua_rawget( L, LUA_REGISTRYINDEX ); // pop key, push bool

    bool call_base = (0 != lua_toboolean(L, -1)); // nil == 0 too
    lua_pop(L, 1);                               // pop bool

    return call_base;
}

void LUACALL wxlua_setcallbaseclassfunction(lua_State* L, bool call_base)
{
    lua_pushlightuserdata(L, &wxlua_lreg_callbaseclassfunc_key);
    lua_pushboolean(L, call_base);
    lua_rawset( L, LUA_REGISTRYINDEX ); // pop key and bool
}

wxEventType LUACALL wxlua_getwxeventtype(lua_State* L)
{
    lua_pushlightuserdata(L, &wxlua_lreg_wxeventtype_key);
    lua_rawget( L, LUA_REGISTRYINDEX ); // pop key, push bool

    wxEventType evt_type = (wxEventType)lua_tonumber(L, -1);
    lua_pop(L, 1); // pop number

    return evt_type;
}

void LUACALL wxlua_setwxeventtype(lua_State* L, wxEventType evt_type)
{
    lua_pushlightuserdata(L, &wxlua_lreg_wxeventtype_key);
    lua_pushnumber(L, evt_type);
    lua_rawset( L, LUA_REGISTRYINDEX ); // pop key and number
}

wxLuaStateData* LUACALL wxlua_getwxluastatedata(lua_State* L)
{
    lua_pushlightuserdata(L, &wxlua_lreg_wxluastatedata_key);
    lua_rawget( L, LUA_REGISTRYINDEX ); // pop key, push bool

    wxLuaStateData* data = (wxLuaStateData*)lua_touserdata(L, -1);
    lua_pop(L, 1); // pop udata

    return data;
}

// ----------------------------------------------------------------------------
// wxFindWindowByPointer - find a window by its pointer
//     return NULL if doesn't exist, see wxFindWindowByID and wxFindWindowByLabel
// ----------------------------------------------------------------------------
static wxWindow *wxFindWindowPointerRecursively(const wxWindow *parent, const wxWindow *win)
{
    wxCHECK_MSG(win, NULL, wxT("invalid window in wxFindWindowPointerRecursively"));

    if ( parent )
    {
        // see if this is the one we're looking for
        if ( parent == win )
            return (wxWindow*)win;

        // It wasn't, so check all its children
        for ( wxWindowList::compatibility_iterator node = parent->GetChildren().GetFirst();
              node;
              node = node->GetNext() )
        {
            // recursively check each child
            wxWindow *child_win = (wxWindow *)node->GetData();
            wxWindow *retwin = wxFindWindowPointerRecursively(child_win, win);
            if (retwin)
                return retwin;
        }
    }

    return NULL; // Not found
}

// Check to see if wxWidgets still thinks "win" is a valid window
//   parent is the window to start with, if parent=NULL check all windows
static wxWindow* wxFindWindowByPointer(const wxWindow *parent, const wxWindow *win)
{
    wxCHECK_MSG(win, NULL, wxT("Invalid window in wxFindWindowByPointer"));

    if ( parent )
    {
        // just check parent and all its children
        return wxFindWindowPointerRecursively(parent, win);
    }
    // start at very top of wx's windows
    for ( wxWindowList::compatibility_iterator top_node = wxTopLevelWindows.GetFirst();
          top_node;
          top_node = top_node->GetNext() )
    {
        // recursively check each window & its children
        wxWindow *top_win = top_node->GetData();
        wxWindow *retwin = wxFindWindowPointerRecursively(top_win, win);
        if (retwin)
            return retwin;
    }

    return NULL; // Not found
}

// ----------------------------------------------------------------------------
// wxLuaCleanupWindows - given a wxWindowList of wxWindows it runs wxFindWindowByPointer
//   on it to remove dead pointers from the list if only_check=true or
//   Destroy() the windows and remove them from the list if !only_check.
// Returns true if any windows are removed, i.e. the list has changed
// ----------------------------------------------------------------------------
bool wxLuaCleanupWindows(lua_State* L, bool only_check)
{
    wxCHECK_MSG(L, false, wxT("Invalid wxLuaState"));

    bool removed = false;

    lua_pushlightuserdata(L, &wxlua_lreg_topwindows_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                     // pop key, push value (table)

    bool try_again = true;

    while (try_again)
    {
        try_again = false;

        lua_pushnil(L);
        while (lua_next(L, -2) != 0)
        {
            // value = -1, key = -2, table = -3
            wxWindow* win = (wxWindow*)lua_touserdata(L, -2);
            wxCHECK_MSG(win, false, wxT("Invalid wxWindow"));

            if (wxFindWindowByPointer(NULL, win) == NULL)
            {
                // simply remove dead window from the list
                removed = true;
                lua_pop(L, 1);        // pop value

                lua_pushvalue(L, -1); // copy key for next iteration
                lua_pushnil(L);
                lua_rawset(L, -4);    // set t[key] = nil to remove it
            }
            else if (!only_check)
            {
                removed = true;
                if (win->HasCapture())
                    win->ReleaseMouse();

                // 2.9 insists that all pushed event handlers are popped before destroying window
                // we assume (for now) that they're properly owned so we don't pop or delete them
                //while (win->GetEventHandler() != win)
                //    win->PopEventHandler(false);

                // release capture for children since we may be abruptly ending
                for ( wxWindowList::compatibility_iterator childNode = win->GetChildren().GetFirst();
                    childNode;
                    childNode = childNode->GetNext() )
                {
                    wxWindow *child = childNode->GetData();

                    lua_pushlightuserdata(L, child);
                    lua_pushnil(L);
                    lua_rawset(L, -5);

                    if (child->HasCapture())
                        child->ReleaseMouse();

                    // 2.9 insists that all pushed event handlers are popped before destroying window
                    // we assume (for now) that they're properly owned so we don't pop or delete them
                    //while (child->GetEventHandler() != child)
                    //    child->PopEventHandler(false);
                }

                if (!win->IsBeingDeleted())
                {
                    delete win;
                }

                // wxLuaWindowDestroyHandler should destroy this node
                //  and also delete all the children and their nodes
                //  it's probably best to start from the top again
                lua_pop(L, 1);        // pop value

                lua_pushnil(L);
                lua_rawset(L, -3);    // set t[key] = nil to remove it

                try_again = true;
                break;
            }
            else
                lua_pop(L, 1); // pop value, lua_next will pop key at end
        }
    }

    lua_pop(L, 1); // pop table

    return removed;
}

//----------------------------------------------------------------------------
// wxLuaStateData
//----------------------------------------------------------------------------

wxLuaStateData::wxLuaStateData()
               :m_is_running(false),
                m_is_closing(false),
                m_lua_debug_hook_count(100), m_lua_debug_hook_yield(50),
                m_lua_debug_hook(0), m_lua_debug_hook_send_evt(false),
                m_last_debug_hook_time(0), m_debug_hook_break(false),
                m_debug_hook_break_msg(wxT("Break")),
                m_evtHandler(NULL),
                m_id(wxID_ANY)
{
}

wxLuaStateData::~wxLuaStateData()
{
    // no events here, the handler may already be gone
    m_evtHandler = NULL;
}

//----------------------------------------------------------------------------
// wxLuaStateRefData
//----------------------------------------------------------------------------

wxLuaStateRefData::wxLuaStateRefData(bool create_data)
                  :m_lua_State(NULL),
                   m_lua_State_static(false),
                   m_lua_State_coroutine(false),
                   m_wxlStateData(NULL),
                   m_own_stateData(false)
{
    if (create_data)
    {
        m_wxlStateData = new wxLuaStateData();
        m_own_stateData = true;
    }
}

wxLuaStateRefData::~wxLuaStateRefData()
{
    wxCHECK_RET((m_lua_State_static == true) || (m_lua_State == NULL),
                wxT("You must ALWAYS call wxLuaState::Destroy and not wxObject::UnRef"));

    CloseLuaState(true);
    if (m_own_stateData)
        delete m_wxlStateData;
}

bool wxLuaStateRefData::CloseLuaState(bool force)
{
    if ((m_lua_State == NULL) || m_wxlStateData->m_is_closing || m_lua_State_coroutine)
        return true;

    m_wxlStateData->m_is_closing = true;

    //wxCHECK_MSG(m_lua_State, false, wxT("Interpreter not created"));
    // wxCHECK_MSG(!m_is_running, false, wxT("Interpreter still running, can't destroy"));  FIXME

    // remove deleted windows first
    wxLuaCleanupWindows(m_lua_State, true);

    // are there still windows? ask to abort deleting them if !force
    bool tlwindows_open = false;
    lua_pushlightuserdata(m_lua_State, &wxlua_lreg_topwindows_key); // push key
    lua_rawget(m_lua_State, LUA_REGISTRYINDEX);                     // pop key, push value (table)

    lua_pushnil(m_lua_State);
    if (lua_next(m_lua_State, -2))
    {
        tlwindows_open = true;
        lua_pop(m_lua_State, 3); // pop key, value, table
    }
    else
        lua_pop(m_lua_State, 1); // pop table

    if (tlwindows_open)
    {
        int ret = wxOK;

        if (!force)
        {
            ret = wxMessageBox(wxT("Windows are still open, would you like to delete them?"),
                               wxT("Delete existing windows?"), wxOK|wxCANCEL|wxICON_QUESTION);
        }

        if (ret == wxCANCEL)
        {
            m_wxlStateData->m_is_closing = false;
            return false;
        }

        //wxPrintf(wxT("Deleting windows\n"));

        // delete windows and their eventhandler since they delete the wxLuaEventCallbacks
        //  which require a lua_State
        wxLuaCleanupWindows(m_lua_State, false);
        // wait for wxWindow::Destroy() to really delete the windows
        //wxYieldIfNeeded();
    }

    // clear the wxlua_lreg_wxluastatedata_key which we test for in the debug hook
    // to know if the lua_State is being closed
    lua_pushlightuserdata(m_lua_State, &wxlua_lreg_wxluastatedata_key);
    lua_pushnil(m_lua_State);
    lua_rawset( m_lua_State, LUA_REGISTRYINDEX ); // pop key, push bool

    ClearCallbacks();

    // remove refs table to try to clear memory gracefully
    wxlua_lreg_createtable(m_lua_State, &wxlua_lreg_refs_key);
    wxlua_lreg_createtable(m_lua_State, &wxlua_lreg_debug_refs_key);
    //wxlua_lreg_createtable(m_lua_State, &wxlua_lreg_derivedmethods_key); // gc will delete them

    lua_gc(m_lua_State, LUA_GCCOLLECT, 0); // round up dead refs

    if (!m_lua_State_static)
        lua_close(m_lua_State);

    // Clear out the wxLuaState we hashed, note it's not refed so we have
    // NULL its ref data.
    // Note: even though the lua_State is closed the pointer value is still good.
    // The wxLuaState we pushed into the reg table is a light userdata so
    // it didn't get deleted.
    wxHashMapLuaState::iterator it = wxLuaState::s_wxHashMapLuaState.find(m_lua_State);
    if (it != wxLuaState::s_wxHashMapLuaState.end())
    {
        wxLuaState* wxlState = it->second;
        wxlState->SetRefData(NULL);
        delete wxlState;
        wxLuaState::s_wxHashMapLuaState.erase(m_lua_State);
    }

    m_lua_State = NULL;

    return true;
}

void wxLuaStateRefData::ClearCallbacks()
{
    wxCHECK_RET(m_lua_State, wxT("Invalid lua_State"));

    lua_State* L = m_lua_State;

    lua_pushlightuserdata(L, &wxlua_lreg_evtcallbacks_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                       // pop key, push value (table)

    lua_pushnil(L);
    while (lua_next(L, -2) != 0)
    {
        // value = -1, key = -2, table = -3
        wxLuaEventCallback* cb = (wxLuaEventCallback*)lua_touserdata(L, -2);
        cb->ClearwxLuaState();

        lua_pop(L, 1);               // pop value, lua_next will pop key at end
    }

    lua_pop(L, 1); // pop table

    wxlua_lreg_createtable(m_lua_State, &wxlua_lreg_evtcallbacks_key);

    // ----------------------------------------------------------------------
    // These should already be gone from wxLuaCleanupWindows, make sure...

    lua_pushlightuserdata(L, &wxlua_lreg_windestroycallbacks_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                              // pop key, push value (table)

    lua_pushnil(L);
    while (lua_next(L, -2) != 0)
    {
        // value = -1, key = -2, table = -3
        wxLuaWinDestroyCallback* cb = (wxLuaWinDestroyCallback*)lua_touserdata(L, -1);
        cb->ClearwxLuaState();

        lua_pop(L, 1);               // pop value, lua_next will pop key at end
    }

    lua_pop(L, 1); // pop table

    wxlua_lreg_createtable(m_lua_State, &wxlua_lreg_windestroycallbacks_key);
}

//----------------------------------------------------------------------------
// wxLuaState
//----------------------------------------------------------------------------

IMPLEMENT_DYNAMIC_CLASS(wxLuaState, wxObject)

wxHashMapLuaState wxLuaState::s_wxHashMapLuaState;
bool wxLuaState::sm_wxAppMainLoop_will_run = false;


#define M_WXLSTATEDATA ((wxLuaStateRefData*)m_refData)

wxObjectRefData *wxLuaState::CreateRefData() const
{
    return new wxLuaStateRefData;
}
//wxObjectRefData *wxLuaState::CloneRefData(const wxObjectRefData *data) const
//{
//    return new wxLuaStateRefData(*(const wxLuaStateRefData *)data);
//}

void wxLuaState::Create( const wxLuaState& wxlState )
{
    Destroy();
    Ref(wxlState);
}

bool wxLuaState::Create(wxEvtHandler *handler, wxWindowID id)
{
    Destroy();

    lua_State* L = luaL_newstate();
    // load some useful libraries, loads all of them
    luaL_openlibs(L);

    bool ok = Create(L, wxLUASTATE_SETSTATE|wxLUASTATE_OPENBINDINGS);

    M_WXLSTATEDATA->m_wxlStateData->m_evtHandler = handler;
    M_WXLSTATEDATA->m_wxlStateData->m_id = id;

    // alert people that we've been created so they can finish setting us up
    wxLuaEvent event(wxEVT_LUA_CREATION, GetId(), *this);
    SendEvent( event );

    return ok;
}

bool wxLuaState::Create(lua_State* L, int state_type)
{
    wxCHECK_MSG(L != NULL, false, wxT("Invalid lua_State"));
    Destroy();

    if (WXLUA_HASBIT(state_type, wxLUASTATE_GETSTATE))
    {
        // returns an invalid, wxNullLuaState on failure
        Ref(wxLuaState::GetwxLuaState(L, WXLUA_HASBIT(state_type, wxLUASTATE_ROOTSTATE)));
    }
    else if (WXLUA_HASBIT(state_type, wxLUASTATE_SETSTATE))
    {
        m_refData = new wxLuaStateRefData();

        M_WXLSTATEDATA->m_lua_State = L;
        M_WXLSTATEDATA->m_lua_State_static = WXLUA_HASBIT(state_type, wxLUASTATE_STATICSTATE);

        // Make the GC a little more aggressive since we push void* data
        // that may be quite large. The upshot is that Lua runs faster.
        // Empirically found by timing: "for i = 1, 1E6 do local p = wx.wxPoint() end"
        lua_gc(L, LUA_GCSETPAUSE, 120);
        lua_gc(L, LUA_GCSETSTEPMUL, 400);

        // Create a new state to push into Lua, the last wxLuaStateRefData will delete it.
        // Note: we call SetRefData() so that we don't increase the ref count.
        wxLuaState* hashState = new wxLuaState(false);
        hashState->SetRefData(m_refData);
        wxLuaState::s_wxHashMapLuaState[L] = hashState;

        // Stick us into the Lua registry table - push key, value
        lua_pushlightuserdata(L, &wxlua_lreg_wxluastate_key);
        lua_pushlightuserdata( L, (void*)hashState );
        lua_rawset( L, LUA_REGISTRYINDEX ); // set the value

        // start off not in an event
        wxlua_setwxeventtype(L, wxEVT_NULL);

        // Push our wxLuaStateData
        lua_pushlightuserdata(L, &wxlua_lreg_wxluastatedata_key);
        lua_pushlightuserdata(L, M_WXLSTATEDATA->m_wxlStateData);
        lua_rawset(L, LUA_REGISTRYINDEX); // set the value

        // These tables are expected to exist no matter what.
        // They're in the registry so even if they're not used they
        // shouldn't bother anyone.

        lua_pushlightuserdata(L, &wxlua_lreg_regtable_key);
        lua_newtable(L);      // main table
          lua_newtable(L);    // metatable
          lua_pushlstring(L, "__mode", 6);
          lua_pushlstring(L, "kv", 2);
          lua_rawset(L, -3);                  // set mode of main table
          lua_setmetatable(L, -2);            // via the metatable
        lua_rawset(L, LUA_REGISTRYINDEX); // set the value

        // create the types table in registry
        wxlua_lreg_createtable(L, &wxlua_lreg_types_key);

        // create the refs table in registry
        wxlua_lreg_createtable(L, &wxlua_lreg_refs_key);

        // create the debug refs table in registry
        wxlua_lreg_createtable(L, &wxlua_lreg_debug_refs_key);

        // create the wxLuaBindClasses table in the registry
        wxlua_lreg_createtable(L, &wxlua_lreg_classes_key);

        // Create a table for overridden methods for C++ userdata objects
        wxlua_lreg_createtable(L, &wxlua_lreg_derivedmethods_key);

        // Create a table for the wxLuaBindings we've installed
        wxlua_lreg_createtable(L, &wxlua_lreg_wxluabindings_key);

        // Create a table for the userdata that we've pushed into Lua
        wxlua_lreg_createtable(L, &wxlua_lreg_weakobjects_key);

        // Create a table for objects to delete
        wxlua_lreg_createtable(L, &wxlua_lreg_gcobjects_key);

        // Create a table for wxLuaEventCallbacks
        wxlua_lreg_createtable(L, &wxlua_lreg_evtcallbacks_key);

        // Create a table for wxLuaWinDestroyCallbacks
        wxlua_lreg_createtable(L, &wxlua_lreg_windestroycallbacks_key);

        // Create a table for top level wxWindows
        wxlua_lreg_createtable(L, &wxlua_lreg_topwindows_key);

        // copy Lua's print function in case someone wants to use it
        lua_getglobal(L, "print");
#if LUA_VERSION_NUM < 502
        lua_pushlstring(L, "print_lua", 9);
        lua_pushvalue(L, -2);               // copy print function
        lua_rawset(L, LUA_GLOBALSINDEX);    // set t[key] = value, pops key and value
#else
        lua_pushglobaltable(L);
        lua_pushlstring(L, "print_lua", 9);
        lua_pushvalue(L, -3);               // copy print function
        lua_rawset(L, -3);                  // set t[key] = value, pops key and value
        lua_pop(L, 1);                      // pop the global table
#endif // LUA_VERSION_NUM < 502

        lua_pushlstring(L, "print_lua", 9); // also keep a permanent copy in registry
        lua_pushvalue(L, -2);               // copy print function
        lua_rawset(L, LUA_REGISTRYINDEX);   // set t[key] = value, pops key and value

        lua_pop(L, 1);                      // pop the print function

        // register wxLua's print handler to send events, replaces Lua's print function
        RegisterFunction(wxlua_printFunction, "print");

        // register our NULL type
        //wxluatype_NULL = wxluaT_newmetatable(L, wxluatype_NULL);
        wxLuaBinding::InstallClassMetatable(L, &wxLuaBindClass_NULL);

        // now register bindings
        if (WXLUA_HASBIT(state_type, wxLUASTATE_OPENBINDINGS))
        {
            // load the bit lib, this is the accepted way, see luaL_openlibs(L)
            lua_pushcfunction(L, luaopen_bit);
            lua_pushstring(L, "bit");
            lua_call(L, 1, 0);

            lua_pushcfunction(L, luaopen_bit32);
            lua_pushstring(L, "bit32");
            lua_call(L, 1, 0);

            RegisterBindings();
        }
    }
    else
        wxFAIL_MSG(wxT("Unknown state_type for wxLuaState::Create()"));

    return Ok();
}

// --------------------------------------------------------------------------

bool wxLuaState::IsOk() const
{
    return (m_refData != NULL) && (M_WXLSTATEDATA->m_lua_State != NULL);
}

// --------------------------------------------------------------------------

void wxLuaState::Destroy()
{
    if (m_refData == NULL) return;

    // we don't want recursion in UnRef and wxlua_garbageCollect
    if (GetRefData()->GetRefCount() == 1)
        M_WXLSTATEDATA->CloseLuaState(true);

    UnRef();
}

bool wxLuaState::CloseLuaState(bool force)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->CloseLuaState(force);
}

bool wxLuaState::IsClosing() const
{
    wxCHECK_MSG(m_refData && M_WXLSTATEDATA->m_wxlStateData, false, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_is_closing;
}

// --------------------------------------------------------------------------

lua_State* wxLuaState::GetLuaState() const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_lua_State;
}

wxLuaStateData* wxLuaState::GetLuaStateData() const
{
    wxCHECK_MSG(m_refData != NULL, NULL, wxT("Invalid wxLuaState, missing ref data"));
    return M_WXLSTATEDATA->m_wxlStateData;
}

wxLuaState wxLuaState::GetwxLuaState(lua_State* L, bool get_root_state) // static function
{
    if (!get_root_state)
    {
        // try our hashtable for faster lookup
        wxHashMapLuaState::iterator it = s_wxHashMapLuaState.find(L);
        if (it != s_wxHashMapLuaState.end())
            return wxLuaState(*it->second);
    }

    // else it's a coroutine? look up the state data from Lua
    wxLuaState* wxlState = NULL;

    // try to get the state we've stored
    lua_pushlightuserdata(L, &wxlua_lreg_wxluastate_key);
    lua_rawget( L, LUA_REGISTRYINDEX );

    // if nothing was returned or it wasn't a ptr, abort
    if ( lua_islightuserdata(L, -1) )
        wxlState = (wxLuaState*)lua_touserdata( L, -1 );

    lua_pop(L, 1); // pop the wxLuaState or nil on failure

    if (!wxlState)
        return wxNullLuaState;

    if (get_root_state || (wxlState->GetLuaState() == L))
    {
        return wxLuaState(*wxlState); // Ref it
    }
    else
    {
        // Create a new wxLuaState for the coroutine and set the wxLuaStateData
        //  to the original wxLuaState's data
        wxLuaStateRefData* refData = new wxLuaStateRefData(false);
        refData->m_lua_State = L;
        refData->m_lua_State_static = true;
        refData->m_lua_State_coroutine = true;

        refData->m_wxlStateData = wxlState->GetLuaStateData();
        refData->m_own_stateData = false;

        wxLuaState wxlState2(false);
        wxlState2.SetRefData(refData);
        return wxlState2;
    }

    return wxNullLuaState;
}

// --------------------------------------------------------------------------

void wxLuaState::SetEventHandler(wxEvtHandler *evtHandler)
{
    wxCHECK_RET(m_refData && M_WXLSTATEDATA->m_wxlStateData, wxT("Invalid wxLuaState"));
    M_WXLSTATEDATA->m_wxlStateData->m_evtHandler = evtHandler;
}
wxEvtHandler *wxLuaState::GetEventHandler() const
{
    wxCHECK_MSG(m_refData && M_WXLSTATEDATA->m_wxlStateData, NULL, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_evtHandler;
}

void wxLuaState::SetId(wxWindowID id)
{
    wxCHECK_RET(m_refData && M_WXLSTATEDATA->m_wxlStateData, wxT("Invalid wxLuaState"));
    M_WXLSTATEDATA->m_wxlStateData->m_id = id;
}
wxWindowID  wxLuaState::GetId() const
{
    wxCHECK_MSG(m_refData && M_WXLSTATEDATA->m_wxlStateData, wxID_ANY, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_id;
}

bool wxLuaState::SendEvent( wxLuaEvent &event ) const
{
    wxCHECK_MSG(m_refData && M_WXLSTATEDATA->m_wxlStateData, false, wxT("Invalid wxLuaState"));

    if (M_WXLSTATEDATA->m_wxlStateData->m_evtHandler)
    {
        event.SetEventObject( (wxObject*)this );
        return M_WXLSTATEDATA->m_wxlStateData->m_evtHandler->ProcessEvent(event);
    }

    return false;
}

// ----------------------------------------------------------------------------

int wxLuaState::RunFile(const wxString &filename, int nresults)
{
    wxCHECK_MSG(Ok(), LUA_ERRRUN, wxT("Lua interpreter not created"));
    wxCHECK_MSG(!M_WXLSTATEDATA->m_wxlStateData->m_is_running, LUA_ERRRUN, wxT("Lua interpreter is already running"));

    M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break = false;
    M_WXLSTATEDATA->m_wxlStateData->m_is_running = true;

    int top = lua_GetTop();
    int status = luaL_LoadFile(wx2lua(filename));
    if (status == 0)
        status = LuaPCall(0, nresults); // no args and nresults
    else
        SendLuaErrorEvent(status, top); // compilation error

    if (nresults == 0)
        lua_SetTop(top); // restore original top (removes err msg)

    M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break = false;
    M_WXLSTATEDATA->m_wxlStateData->m_is_running = false;

    return status;
}

int wxLuaState::RunString(const wxString &script, const wxString& name, int nresults)
{
    wxLuaCharBuffer buf(script);
    return RunBuffer(buf.GetData(), buf.Length(), name, nresults);
}

int wxLuaState::RunBuffer(const char buf[], size_t size, const wxString &name, int nresults)
{
    wxCHECK_MSG(Ok(), LUA_ERRRUN, wxT("Invalid wxLuaState"));
    wxCHECK_MSG(!M_WXLSTATEDATA->m_wxlStateData->m_is_running, LUA_ERRRUN, wxT("Lua interpreter is already running"));

    M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break = false;
    M_WXLSTATEDATA->m_wxlStateData->m_is_running = true;

    int top = lua_GetTop();
    int status = luaL_LoadBuffer(buf, size, wx2lua(name));
    if (status == 0)
        status = LuaPCall(0, nresults); // no args and nresults
    else
        SendLuaErrorEvent(status, top); // compilation error

    if (nresults == 0)
        lua_SetTop(top); // restore original top (removes err msg)

    M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break = false;
    M_WXLSTATEDATA->m_wxlStateData->m_is_running = false;

    return status;
}

bool wxLuaState::IsRunning() const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_is_running;
}

// this function taken from lua.c, the lua executable
static int LUACALL wxlua_traceback (lua_State *L) {
  if (!lua_isstring(L, 1))  /* 'message' not a string? */
    return 1;  /* keep it intact */
  lua_getglobal(L, "debug");
  if (!lua_istable(L, -1)) {
    lua_pop(L, 1);
  }
  lua_getfield(L, -1, "traceback");
  if (!lua_isfunction(L, -1)) {
    lua_pop(L, 2);
    return 1;
  }
  lua_pushvalue(L, 1);      /* pass error message */
  lua_pushinteger(L, 2);    /* skip this function and traceback */
  lua_call(L, 2, 1);        /* call debug.traceback */
  return 1;
}

int wxLuaState::LuaPCall(int narg, int nresults)
{
    wxCHECK_MSG(Ok(), LUA_ERRRUN, wxT("Invalid wxLuaState"));
    lua_State* L = M_WXLSTATEDATA->m_lua_State;

    int status = 0;
    int top  = lua_gettop(L);
    int base = top - narg;                  // function index

    lua_pushcfunction(L, wxlua_traceback);  // push our traceback function

    lua_insert(L, base);                    // put it under chunk and args
    status = lua_pcall(L, narg, nresults, base);
    lua_remove(L, base);                    // remove traceback function

    if (status != 0)
    {
        SendLuaErrorEvent(status, top - (narg + 1));
        lua_settop(L, top); // restore original top (removes err msg)
    }

    return status;
}

bool wxLuaState::SendLuaErrorEvent(int status, int top)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    wxString errorMsg;
    int line_num = -1;

    wxlua_errorinfo(GetLuaState(), status, top, &errorMsg, &line_num);

    wxLuaEvent event(wxEVT_LUA_ERROR, GetId(), *this);
    event.SetString(errorMsg);
    event.SetInt(line_num);
    return SendEvent(event);
}

wxEventType wxLuaState::GetInEventType() const
{
    wxCHECK_MSG(Ok(), wxEVT_NULL, wxT("Invalid wxLuaState"));
    return wxlua_getwxeventtype(M_WXLSTATEDATA->m_lua_State);
}

void wxLuaState::SetInEventType(wxEventType eventType)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    wxlua_setwxeventtype(M_WXLSTATEDATA->m_lua_State, eventType);
}

int wxLuaState::CompileString(const wxString &script, const wxString& name, wxString* errMsg_, int* line_num_)
{
    wxLuaCharBuffer buf(script);
    return CompileBuffer(buf.GetData(), buf.Length(), name, errMsg_, line_num_);
}
int wxLuaState::CompileBuffer(const char buf[], size_t size, const wxString &name, wxString* errMsg_, int* line_num_)
{
    // create a new lua_State so we don't mess up our own
    lua_State *L = luaL_newstate();
    luaL_openlibs(L); // load some useful libraries, loads all of them
    int top = lua_gettop(L);
    int status = luaL_loadbuffer(L, (const char*)buf, size, wx2lua(name));
    wxlua_errorinfo(L, status, top, errMsg_, line_num_);
    lua_close(L);
    return status;
}

void wxLuaState::DebugHookBreak(const wxString &msg)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    wxCHECK_RET(M_WXLSTATEDATA->m_wxlStateData->m_is_running, wxT("Lua interpreter not running"));

    // Lua likes to be stopped within the debug hook, you get funny wxYield
    //  recursion asserts if you call wxlua_Error() within another wxYield, i.e. from a gui button

    M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break_msg = msg;
    M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break = true;
    lua_sethook(GetLuaState(), wxlua_debugHookFunction, LUA_MASKCALL|LUA_MASKRET|LUA_MASKLINE|LUA_MASKCOUNT, 1);
    M_WXLSTATEDATA->m_wxlStateData->m_is_running = false;
}

void wxLuaState::ClearDebugHookBreak()
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));

    M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break = false;
    SetLuaDebugHook(GetLuaDebugHook(),
                    GetLuaDebugHookCount(),
                    GetLuaDebugHookYield(),
                    GetLuaDebugHookSendEvt());
}

bool wxLuaState::GetDebugHookBreak() const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break;
}
wxString wxLuaState::GetDebugHookBreakMessage() const
{
    wxCHECK_MSG(Ok(), wxEmptyString, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_debug_hook_break_msg;
}

// ----------------------------------------------------------------------------

void wxLuaState::SetLuaDebugHook(int hook, int count, int yield_ms, bool send_debug_evt)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));

    M_WXLSTATEDATA->m_wxlStateData->m_lua_debug_hook = hook;
    M_WXLSTATEDATA->m_wxlStateData->m_lua_debug_hook_count = count;
    M_WXLSTATEDATA->m_wxlStateData->m_lua_debug_hook_yield = yield_ms;
    M_WXLSTATEDATA->m_wxlStateData->m_lua_debug_hook_send_evt = send_debug_evt;

    // These are the various hooks you can install
    //LUA_MASKCALL, LUA_MASKRET, LUA_MASKLINE, and LUA_MASKCOUNT
    lua_sethook(M_WXLSTATEDATA->m_lua_State, wxlua_debugHookFunction, hook, count);
}

int wxLuaState::GetLuaDebugHook() const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_lua_debug_hook;
}
int wxLuaState::GetLuaDebugHookCount() const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_lua_debug_hook_count;
}
int wxLuaState::GetLuaDebugHookYield() const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_lua_debug_hook_yield;
}
bool wxLuaState::GetLuaDebugHookSendEvt() const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_lua_debug_hook_send_evt;
}

unsigned long wxLuaState::GetLastLuaDebugHookTime() const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return M_WXLSTATEDATA->m_wxlStateData->m_last_debug_hook_time;
}
void wxLuaState::SetLastLuaDebugHookTime(unsigned long t)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    M_WXLSTATEDATA->m_wxlStateData->m_last_debug_hook_time = t;
}

// ----------------------------------------------------------------------------

void wxLuaState::RegisterFunction(lua_CFunction func, const char* funcName)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_register( M_WXLSTATEDATA->m_lua_State, funcName, func );
}

bool wxLuaState::RegisterBinding(wxLuaBinding* binding)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    wxCHECK_MSG(binding, false, wxT("Invalid wxLuaState"));

    wxLuaBinding::InitAllBindings(); // only runs the first time through

    bool ret = binding->RegisterBinding(*this);
    if (ret) lua_Pop(1);

    return ret;
}

bool wxLuaState::RegisterBindings()
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));

    return wxLuaBinding::RegisterBindings(*this);
}

wxLuaBinding* wxLuaState::GetLuaBinding(const wxString& bindingName) const
{
    wxCHECK_MSG(GetRefData() != NULL, NULL, wxT("Invalid wxLuaState"));
    return wxLuaBinding::GetLuaBinding(bindingName);
}

const wxLuaBindClass* wxLuaState::GetBindClass(int wxluatype) const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));

    // try to get the wxLuaBindClass from the Lua registry table first
    const wxLuaBindClass* wxlClass = wxluaT_getclass(M_WXLSTATEDATA->m_lua_State, wxluatype);

    // we shouldn't ever need this code
    if (wxlClass == NULL)
        wxlClass = wxLuaBinding::FindBindClass(wxluatype);

    return wxlClass;
}
const wxLuaBindClass* wxLuaState::GetBindClass(const char* className) const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return wxluaT_getclass(M_WXLSTATEDATA->m_lua_State, className);
}
const wxLuaBindClass* wxLuaState::GetBindClass(const wxLuaBindMethod* wxlMethod) const
{
    wxCHECK_MSG(GetRefData() != NULL, NULL, wxT("Invalid wxLuaState"));
    return wxLuaBinding::FindBindClass(wxlMethod);
}
const wxLuaBindClass* wxLuaState::GetBindClass(const wxLuaBindCFunc* wxlClass) const
{
    wxCHECK_MSG(GetRefData() != NULL, NULL, wxT("Invalid wxLuaState"));
    return wxLuaBinding::FindBindClass(wxlClass);
}

int wxLuaState::IsDerivedType(int wxl_type, int base_wxl_type, int* baseclass_n) const
{
    wxCHECK_MSG(Ok(), -1, wxT("Invalid wxLuaState"));
    return wxluaT_isderivedtype(M_WXLSTATEDATA->m_lua_State, wxl_type, base_wxl_type, baseclass_n);
}

void wxLuaState::SetCallBaseClassFunction(bool call_base)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    wxlua_setcallbaseclassfunction(M_WXLSTATEDATA->m_lua_State, call_base);
}
bool wxLuaState::GetCallBaseClassFunction()
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxlua_getcallbaseclassfunction(M_WXLSTATEDATA->m_lua_State);
}

// ----------------------------------------------------------------------------
// memory tracking functions

void wxLuaState::AddGCObject(void* obj_ptr, int wxl_type)
{
    wxCHECK_RET(Ok() && obj_ptr, wxT("Invalid wxLuaState or wxObject to track"));
    wxluaO_addgcobject(M_WXLSTATEDATA->m_lua_State, obj_ptr, wxl_type);
}

bool wxLuaState::DeleteGCObject(int stack_idx, int flags)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState or object"));
    return wxluaO_deletegcobject(M_WXLSTATEDATA->m_lua_State, stack_idx, flags);
}

bool wxLuaState::IsGCObject(void *obj_ptr) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxluaO_isgcobject(M_WXLSTATEDATA->m_lua_State, obj_ptr);
}

wxArrayString wxLuaState::GetGCObjectInfo() const
{
    wxCHECK_MSG(Ok(), wxArrayString(), wxT("Invalid wxLuaState"));
    return wxluaO_getgcobjectinfo(M_WXLSTATEDATA->m_lua_State);
}

void wxLuaState::AddTrackedWindow(wxObject *obj)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    wxluaW_addtrackedwindow(M_WXLSTATEDATA->m_lua_State, obj);
}

void wxLuaState::RemoveTrackedWindow(wxWindow *win)
{
    wxCHECK_RET(Ok() && win, wxT("Invalid wxLuaState or wxWindow"));
    wxluaW_removetrackedwindow(M_WXLSTATEDATA->m_lua_State, win);
}

bool wxLuaState::IsTrackedWindow(wxWindow *win, bool check_parents) const
{
    wxCHECK_MSG(Ok() && win, false, wxT("Invalid wxLuaState or wxWindow"));
    return wxluaW_istrackedwindow(M_WXLSTATEDATA->m_lua_State, win, check_parents);
}

wxArrayString wxLuaState::GetTrackedWindowInfo() const
{
    wxCHECK_MSG(Ok(), wxArrayString(), wxT("Invalid wxLuaState"));
    return wxluaW_gettrackedwindowinfo(M_WXLSTATEDATA->m_lua_State);
}

void wxLuaState::GarbageCollectWindows(bool closeWindows)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    // remove deleted windows
    wxLuaCleanupWindows(M_WXLSTATEDATA->m_lua_State, !closeWindows);
}

void wxLuaState::AddTrackedEventCallback(wxLuaEventCallback* callback)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_State* L = M_WXLSTATEDATA->m_lua_State;

    lua_pushlightuserdata(L, &wxlua_lreg_evtcallbacks_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                       // pop key, push value (table)

    lua_pushlightuserdata(L, callback);                  // push key
    lua_pushlightuserdata(L, callback->GetEvtHandler()); // push value
    lua_rawset(L, -3); // set t[key] = value; pops key and value

    lua_pop(L, 1);     // pop table
}
bool wxLuaState::RemoveTrackedEventCallback(wxLuaEventCallback* callback)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    lua_State* L = M_WXLSTATEDATA->m_lua_State;

    lua_pushlightuserdata(L, &wxlua_lreg_evtcallbacks_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                       // pop key, push value (table)

    lua_pushlightuserdata(L, callback); // push key
    lua_pushnil(L);                     // push value
    lua_rawset(L, -3); // set t[key] = value; pops key and value

    lua_pop(L, 1);     // pop table

    return true; // FIXME return a real value
}

wxArrayString wxLuaState::GetTrackedEventCallbackInfo() const
{
    wxArrayString names;

    wxCHECK_MSG(Ok(), names, wxT("Invalid wxLuaState"));
    lua_State* L = M_WXLSTATEDATA->m_lua_State;

    lua_pushlightuserdata(L, &wxlua_lreg_evtcallbacks_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                       // pop key, push value (table)

    lua_pushnil(L);
    while (lua_next(L, -2) != 0)
    {
        // value = -1, key = -2, table = -3
        wxLuaEventCallback* wxlCallback = (wxLuaEventCallback*)lua_touserdata(L, -2);
        wxCHECK_MSG(wxlCallback, names, wxT("Invalid wxLuaEventCallback"));

        names.Add(wxlCallback->GetInfo());

        lua_pop(L, 1); // pop value, lua_next will pop key at end
    }

    lua_pop(L, 1); // pop table

    names.Sort();
    return names;
}

void wxLuaState::AddTrackedWinDestroyCallback(wxLuaWinDestroyCallback* callback)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_State* L = M_WXLSTATEDATA->m_lua_State;

    lua_pushlightuserdata(L, &wxlua_lreg_windestroycallbacks_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                              // pop key, push value (table)

    lua_pushlightuserdata(L, callback->GetWindow()); // push key
    lua_pushlightuserdata(L, callback);              // push value
    lua_rawset(L, -3); // set t[key] = value; pops key and value

    lua_pop(L, 1);     // pop table
}
bool wxLuaState::RemoveTrackedWinDestroyCallback(wxLuaWinDestroyCallback* callback)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    lua_State* L = M_WXLSTATEDATA->m_lua_State;

    lua_pushlightuserdata(L, &wxlua_lreg_windestroycallbacks_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                              // pop key, push value (table)

    lua_pushlightuserdata(L, callback->GetWindow()); // push key
    lua_pushnil(L);                                  // push value
    lua_rawset(L, -3); // set t[key] = value; pops key and value

    lua_pop(L, 1);     // pop table

    return true; // FIXME return if it was here or not
}

wxArrayString wxLuaState::GetTrackedWinDestroyCallbackInfo() const
{
    wxArrayString names;

    wxCHECK_MSG(Ok(), names, wxT("Invalid wxLuaState"));
    lua_State* L = M_WXLSTATEDATA->m_lua_State;

    lua_pushlightuserdata(L, &wxlua_lreg_windestroycallbacks_key); // push key
    lua_rawget(L, LUA_REGISTRYINDEX);                              // pop key, push value (table)

    lua_pushnil(L);
    while (lua_next(L, -2) != 0)
    {
        // value = -1, key = -2, table = -3
        wxLuaWinDestroyCallback* wxlDestroyCallBack = (wxLuaWinDestroyCallback*)lua_touserdata(L, -1);
        wxCHECK_MSG(wxlDestroyCallBack, names, wxT("Invalid wxLuaWinDestroyCallback"));

        names.Add(wxlDestroyCallBack->GetInfo());

        lua_pop(L, 1); // pop value, lua_next will pop key at end
    }

    names.Sort();
    return names;
}

// ----------------------------------------------------------------------------

void wxLuaState::wxlua_Error(const char *errorMsg) const
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    wxlua_error(M_WXLSTATEDATA->m_lua_State, errorMsg);
}

void* wxLuaState::wxlua_ToUserdata(int stack_idx, bool reset /* = false*/) const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return wxlua_touserdata(M_WXLSTATEDATA->m_lua_State, stack_idx, reset);
}

// ----------------------------------------------------------------------------
// wxLua Lua Registry Table Functions

int wxLuaState::wxluaR_Ref(int stack_idx, void* lightuserdata_reg_key)
{
    wxCHECK_MSG(Ok(), LUA_REFNIL, wxT("Invalid wxLuaState"));
    return wxluaR_ref(M_WXLSTATEDATA->m_lua_State, stack_idx, lightuserdata_reg_key);
}

bool wxLuaState::wxluaR_Unref(int wxlref_index, void* lightuserdata_reg_key)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxluaR_unref(M_WXLSTATEDATA->m_lua_State, wxlref_index, lightuserdata_reg_key);
}

bool wxLuaState::wxluaR_GetRef(int wxlref_index, void* lightuserdata_reg_key)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxluaR_getref(M_WXLSTATEDATA->m_lua_State, wxlref_index, lightuserdata_reg_key);
}

// ----------------------------------------------------------------------------

int wxLuaState::wxluaT_NewMetatable(int wxl_type)
{
    wxCHECK_MSG(Ok(), WXLUA_TUNKNOWN, wxT("Invalid wxLuaState"));
    return wxluaT_newmetatable(M_WXLSTATEDATA->m_lua_State, wxl_type);
}

bool wxLuaState::wxluaT_SetMetatable(int wxl_type)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxluaT_setmetatable(M_WXLSTATEDATA->m_lua_State, wxl_type);
}

int wxLuaState::wxluaT_Type(int stack_idx) const
{
    wxCHECK_MSG(Ok(), WXLUA_TUNKNOWN, wxT("Invalid wxLuaState"));
    return wxluaT_type(M_WXLSTATEDATA->m_lua_State, stack_idx);
}

bool wxLuaState::wxluaT_PushUserDataType(const void *obj_ptr, int wxl_type, bool track)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxluaT_pushuserdatatype(M_WXLSTATEDATA->m_lua_State, obj_ptr, wxl_type, track);
}

// ----------------------------------------------------------------------------
// wxLua get data type

int wxLuaState::IswxLuaType(int luatype, int wxl_type) const
{
    wxCHECK_MSG(Ok(), -1, wxT("Invalid wxLuaState"));
    return wxlua_iswxluatype(luatype, wxl_type, M_WXLSTATEDATA->m_lua_State);
}

bool wxLuaState::IsUserDataType(int stack_idx, int wxl_type) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxluaT_isuserdatatype(M_WXLSTATEDATA->m_lua_State, stack_idx, wxl_type);
}

void* wxLuaState::GetUserDataType(int stack_idx, int wxl_type) const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return wxluaT_getuserdatatype(M_WXLSTATEDATA->m_lua_State, stack_idx, wxl_type);
}

const char* wxLuaState::GetStringType(int stack_idx)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return wxlua_getstringtype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}
wxString wxLuaState::GetwxStringType(int stack_idx)
{
    wxCHECK_MSG(Ok(), wxEmptyString, wxT("Invalid wxLuaState"));
    return wxlua_getwxStringtype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}
bool wxLuaState::GetBooleanType(int stack_idx)
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxlua_getbooleantype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}
long wxLuaState::GetIntegerType(int stack_idx)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return wxlua_getintegertype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}
double wxLuaState::GetNumberType(int stack_idx)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return wxlua_getnumbertype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}

bool wxLuaState::IsStringType(int stack_idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxlua_isstringtype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}

bool wxLuaState::IswxStringType(int stack_idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxlua_iswxstringtype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}

bool wxLuaState::IsBooleanType(int stack_idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxlua_isbooleantype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}
bool wxLuaState::IsIntegerType(int stack_idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxlua_isintegertype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}
bool wxLuaState::IsNumberType(int stack_idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxlua_isnumbertype(M_WXLSTATEDATA->m_lua_State, stack_idx);
}

wxString* wxLuaState::GetwxStringArray(int stack_idx, int &count)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return wxlua_getwxStringarray(M_WXLSTATEDATA->m_lua_State, stack_idx, count);
}

wxLuaSmartwxArrayString wxLuaState::GetwxArrayString(int stack_idx)
{
    wxCHECK_MSG(Ok(), wxLuaSmartwxArrayString(NULL, true), wxT("Invalid wxLuaState"));
    return wxlua_getwxArrayString(M_WXLSTATEDATA->m_lua_State, stack_idx);
}

const char** wxLuaState::GetCharArray(int stack_idx, int &count)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return wxlua_getchararray(M_WXLSTATEDATA->m_lua_State, stack_idx, count);
}

int wxLuaState::PushwxArrayStringTable(const wxArrayString &strArray)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return wxlua_pushwxArrayStringtable(M_WXLSTATEDATA->m_lua_State, strArray);
}

int wxLuaState::PushwxArrayIntTable(const wxArrayInt &intArray)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return wxlua_pushwxArrayInttable(M_WXLSTATEDATA->m_lua_State, intArray);
}

int* wxLuaState::GetIntArray(int stack_idx, int &count)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return wxlua_getintarray(M_WXLSTATEDATA->m_lua_State, stack_idx, count);
}

wxLuaSmartwxArrayInt wxLuaState::GetwxArrayInt(int stack_idx)
{
    wxCHECK_MSG(Ok(), wxLuaSmartwxArrayInt(NULL, true), wxT("Invalid wxLuaState"));
    return wxlua_getwxArrayInt(M_WXLSTATEDATA->m_lua_State, stack_idx);
}

wxString wxLuaState::GetwxLuaTypeName(int wxl_type) const
{
    wxCHECK_MSG(Ok(), wxEmptyString, wxT("Invalid wxLuaState"));
    return wxluaT_typename(M_WXLSTATEDATA->m_lua_State, wxl_type);
}

bool wxLuaState::SetDerivedMethod(void *obj_ptr, const char *method_name, wxLuaObject* wxlObj)
{
    wxCHECK_MSG(Ok() && obj_ptr, false, wxT("Invalid wxLuaState or object to set derived method for."));
    return wxlua_setderivedmethod(M_WXLSTATEDATA->m_lua_State, obj_ptr, method_name, wxlObj);
}

bool wxLuaState::HasDerivedMethod(const void *obj_ptr, const char *method_name, bool push_method) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxlua_hasderivedmethod(M_WXLSTATEDATA->m_lua_State, obj_ptr, method_name, push_method);
}

bool wxLuaState::RemoveDerivedMethods(void *obj_ptr) const
{
    wxCHECK_MSG(Ok() && obj_ptr, false, wxT("Invalid wxLuaState or object to remove."));
    return wxlua_removederivedmethods(M_WXLSTATEDATA->m_lua_State, obj_ptr);
}

wxLuaState wxLuaState::GetDerivedMethodState(void *obj_ptr, const char *method_name)
{
    wxCHECK_MSG(obj_ptr, wxNullLuaState, wxT("Invalid object to wxLuaState::GetDerivedMethod"));

    wxHashMapLuaState::iterator it;
    for (it = wxLuaState::s_wxHashMapLuaState.begin();
         it != wxLuaState::s_wxHashMapLuaState.end(); ++it)
    {
        wxLuaState wxlState(*(wxLuaState*)it->second);
        if (wxlState.HasDerivedMethod(obj_ptr, method_name, false))
            return wxlState;
    }

    return wxNullLuaState;
}

// ----------------------------------------------------------------------------
// Raw basic Lua stack functions.

int wxLuaState::lua_GetTop() const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_gettop(M_WXLSTATEDATA->m_lua_State);
}
void wxLuaState::lua_SetTop(int index)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_settop(M_WXLSTATEDATA->m_lua_State, index);
}
void wxLuaState::lua_PushValue(int index)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushvalue(M_WXLSTATEDATA->m_lua_State, index);
}
void wxLuaState::lua_Remove(int index)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_remove(M_WXLSTATEDATA->m_lua_State, index);
}
void wxLuaState::lua_Pop(int count) const
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pop(M_WXLSTATEDATA->m_lua_State, count);
}
void wxLuaState::lua_Insert(int index)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_insert(M_WXLSTATEDATA->m_lua_State, index);
}
void wxLuaState::lua_Replace(int index)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_replace(M_WXLSTATEDATA->m_lua_State, index);
}
int wxLuaState::lua_CheckStack(int size)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_checkstack(M_WXLSTATEDATA->m_lua_State, size);
}
void wxLuaState::lua_XMove(const wxLuaState& to, int n)
{
    wxCHECK_RET(Ok() && to.Ok(), wxT("Invalid wxLuaState"));
    lua_xmove(M_WXLSTATEDATA->m_lua_State, to.GetLuaState(), n);
}

// ----------------------------------------------------------------------------
// access functions (stack -> C)

bool wxLuaState::lua_IsNumber(int index) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isnumber(M_WXLSTATEDATA->m_lua_State, index) != 0;
}
bool wxLuaState::lua_IsString(int index) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isstring(M_WXLSTATEDATA->m_lua_State, index) != 0;
}
bool wxLuaState::lua_IsCFunction(int index) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_iscfunction(M_WXLSTATEDATA->m_lua_State, index) != 0;
}
bool wxLuaState::lua_IsUserdata(int index) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isuserdata(M_WXLSTATEDATA->m_lua_State, index) != 0;
}
int wxLuaState::lua_Type(int index) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_type(M_WXLSTATEDATA->m_lua_State, index);
}
wxString wxLuaState::lua_TypeName(int type) const
{
    wxCHECK_MSG(Ok(), wxEmptyString, wxT("Invalid wxLuaState"));
    return lua2wx(lua_typename(M_WXLSTATEDATA->m_lua_State, type));
}

int wxLuaState::lua_Equal(int index1, int index2) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_equal(M_WXLSTATEDATA->m_lua_State, index1, index2);
}
int wxLuaState::lua_RawEqual(int index1, int index2) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_rawequal(M_WXLSTATEDATA->m_lua_State, index1, index2);
}
int wxLuaState::lua_LessThan(int index1, int index2) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_lessthan(M_WXLSTATEDATA->m_lua_State, index1, index2);
}

double wxLuaState::lua_ToNumber(int index) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_tonumber(M_WXLSTATEDATA->m_lua_State, index);
}
int wxLuaState::lua_ToInteger(int index) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_tointeger(M_WXLSTATEDATA->m_lua_State, index);
}
int wxLuaState::lua_ToBoolean(int index) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_toboolean(M_WXLSTATEDATA->m_lua_State, index);
}
const char* wxLuaState::lua_ToString(int index) const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_tostring(M_WXLSTATEDATA->m_lua_State, index);
}
wxString wxLuaState::lua_TowxString(int index) const
{
    wxCHECK_MSG(Ok(), wxEmptyString, wxT("Invalid wxLuaState"));
    return lua2wx(lua_tostring(M_WXLSTATEDATA->m_lua_State, index));
}
size_t wxLuaState::lua_StrLen(int index) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_strlen(M_WXLSTATEDATA->m_lua_State, index);
}
size_t wxLuaState::luaL_ObjLen(int t) const
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_objlen(M_WXLSTATEDATA->m_lua_State, t);
}
lua_CFunction wxLuaState::lua_ToCFunction(int index) const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_tocfunction(M_WXLSTATEDATA->m_lua_State, index);
}
void *wxLuaState::lua_ToUserdata(int index) const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_touserdata(M_WXLSTATEDATA->m_lua_State, index);
}
wxLuaState wxLuaState::lua_ToThread(int index) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return wxLuaState(lua_tothread(M_WXLSTATEDATA->m_lua_State, index));
}
const void* wxLuaState::lua_ToPointer(int index) const
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_topointer(M_WXLSTATEDATA->m_lua_State, index);
}

// ----------------------------------------------------------------------------
// Raw Lua push functions (C -> stack)

void wxLuaState::lua_PushNil()
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushnil(M_WXLSTATEDATA->m_lua_State);
}
void wxLuaState::lua_PushNumber(lua_Number n)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushnumber(M_WXLSTATEDATA->m_lua_State, n);
}
void wxLuaState::lua_PushInteger(lua_Integer n)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushinteger(M_WXLSTATEDATA->m_lua_State, n);
}
void wxLuaState::lua_PushLString(const char* s, size_t len)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushlstring(M_WXLSTATEDATA->m_lua_State, s, len);
}
void wxLuaState::lua_PushString(const char* s)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushstring(M_WXLSTATEDATA->m_lua_State, s);
}
void wxLuaState::lua_PushCClosure(lua_CFunction fn, int n)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushcclosure(M_WXLSTATEDATA->m_lua_State, fn, n);
}
void wxLuaState::lua_PushBoolean(bool b)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushboolean(M_WXLSTATEDATA->m_lua_State, b ? 1 : 0);
}
void wxLuaState::lua_PushLightUserdata(void* p)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushlightuserdata(M_WXLSTATEDATA->m_lua_State, p);
}

// ----------------------------------------------------------------------------
// Raw Lua get functions (Lua -> stack)

void wxLuaState::lua_GetTable(int idx)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_gettable(M_WXLSTATEDATA->m_lua_State, idx);
}
void wxLuaState::lua_GetField(int idx, const char* k)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_getfield(M_WXLSTATEDATA->m_lua_State, idx, k);
}
void wxLuaState::lua_RawGet(int idx)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_rawget(M_WXLSTATEDATA->m_lua_State, idx);
}
void wxLuaState::lua_RawGeti(int idx, int n)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_rawgeti(M_WXLSTATEDATA->m_lua_State, idx, n);
}
void wxLuaState::lua_CreateTable(int narr, int nrec)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_createtable(M_WXLSTATEDATA->m_lua_State, narr, nrec);
}
void wxLuaState::lua_NewTable()
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_newtable(M_WXLSTATEDATA->m_lua_State);
}
void* wxLuaState::lua_NewUserdata(size_t sz)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_newuserdata(M_WXLSTATEDATA->m_lua_State, sz);
}
int wxLuaState::lua_GetMetatable(int objindex)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_getmetatable(M_WXLSTATEDATA->m_lua_State, objindex);
}

#if LUA_VERSION_NUM < 502
void wxLuaState::lua_GetFenv(int idx)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_getfenv(M_WXLSTATEDATA->m_lua_State, idx);
}
#endif // LUA_VERSION_NUM < 502

// -----------------------------------------------------------------------
// Raw Lua set functions (stack -> Lua)

void wxLuaState::lua_SetTable(int idx)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_settable(M_WXLSTATEDATA->m_lua_State, idx);
}
void wxLuaState::lua_SetField(int idx, const char* k)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_setfield(M_WXLSTATEDATA->m_lua_State, idx, k);
}
void wxLuaState::lua_RawSet(int idx)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_rawset(M_WXLSTATEDATA->m_lua_State, idx);
}
void wxLuaState::lua_RawSeti(int idx, int n)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_rawseti(M_WXLSTATEDATA->m_lua_State, idx, n);
}
int wxLuaState::lua_SetMetatable(int objindex)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_setmetatable(M_WXLSTATEDATA->m_lua_State, objindex);
}

#if LUA_VERSION_NUM < 502
int wxLuaState::lua_SetFenv(int idx)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_setfenv(M_WXLSTATEDATA->m_lua_State, idx);
}
#endif // LUA_VERSION_NUM < 502

// ----------------------------------------------------------------------------
// Raw Lua `load' and `call' functions (load and run Lua code)

void wxLuaState::lua_Call(int nargs, int nresults)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_call(M_WXLSTATEDATA->m_lua_State, nargs, nresults);
}
int wxLuaState::lua_PCall(int nargs, int nresults, int errfunc)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_pcall(M_WXLSTATEDATA->m_lua_State, nargs, nresults, errfunc);
}
int wxLuaState::lua_CPCall(lua_CFunction func, void *ud)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_cpcall(M_WXLSTATEDATA->m_lua_State, func, ud);
}
#if LUA_VERSION_NUM < 502
int  wxLuaState::lua_Load(lua_Reader reader, void *dt, const char* chunkname)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_load(M_WXLSTATEDATA->m_lua_State, reader, dt, chunkname);
}
#else
int  wxLuaState::lua_Load(lua_Reader reader, void *dt, const char* chunkname, const char* mode)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_load(M_WXLSTATEDATA->m_lua_State, reader, dt, chunkname, mode);
}
#endif // LUA_VERSION_NUM < 502
int wxLuaState::lua_Dump(lua_Writer writer, void *data)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_dump(M_WXLSTATEDATA->m_lua_State, writer, data);
}

// ----------------------------------------------------------------------------
// Raw Lua coroutine functions

int wxLuaState::lua_Yield(int nresults)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_yield(M_WXLSTATEDATA->m_lua_State, nresults);
}

#if LUA_VERSION_NUM < 502
int wxLuaState::lua_Resume(int narg)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_resume(M_WXLSTATEDATA->m_lua_State, narg);
}
#endif // LUA_VERSION_NUM < 502

int wxLuaState::lua_Status()
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_status(M_WXLSTATEDATA->m_lua_State);
}

// ----------------------------------------------------------------------------
// Raw Lua garbage-collection functions

int wxLuaState::lua_GC(int what, int data)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_gc(M_WXLSTATEDATA->m_lua_State, what, data);
}

// ----------------------------------------------------------------------------
// Raw Lua miscellaneous functions

wxString wxLuaState::lua_Version() const
{
    return lua2wx(LUA_VERSION);
}
int wxLuaState::lua_Error()
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_error(M_WXLSTATEDATA->m_lua_State);
}
int wxLuaState::lua_Next(int idx)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_next(M_WXLSTATEDATA->m_lua_State, idx);
}
void wxLuaState::lua_Concat(int n)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_concat(M_WXLSTATEDATA->m_lua_State, n);
}

// -----------------------------------------------------------------------
// Raw Lua some useful "macros", lua.h

void wxLuaState::lua_Register(const char* funcName, lua_CFunction f)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_register(M_WXLSTATEDATA->m_lua_State, funcName, f);
}
void wxLuaState::lua_PushCFunction(lua_CFunction f)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushcfunction(M_WXLSTATEDATA->m_lua_State, f);
}

bool wxLuaState::lua_IsFunction(int idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isfunction(M_WXLSTATEDATA->m_lua_State, idx);
}
bool wxLuaState::lua_IsTable(int idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_istable(M_WXLSTATEDATA->m_lua_State, idx);
}
bool wxLuaState::lua_IsLightUserdata(int idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_islightuserdata(M_WXLSTATEDATA->m_lua_State, idx);
}
bool wxLuaState::lua_IsNil(int idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isnil(M_WXLSTATEDATA->m_lua_State, idx);
}
bool wxLuaState::lua_IsBoolean(int idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isboolean(M_WXLSTATEDATA->m_lua_State, idx);
}
bool wxLuaState::lua_IsThread(int idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isthread(M_WXLSTATEDATA->m_lua_State, idx);
}
bool wxLuaState::lua_IsNone(int idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isnone(M_WXLSTATEDATA->m_lua_State, idx);
}
bool wxLuaState::lua_IsNoneOrNil(int idx) const
{
    wxCHECK_MSG(Ok(), false, wxT("Invalid wxLuaState"));
    return lua_isnoneornil(M_WXLSTATEDATA->m_lua_State, idx);
}

void wxLuaState::lua_SetGlobal(const char* s)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_setglobal(M_WXLSTATEDATA->m_lua_State, s);
}
void wxLuaState::lua_GetGlobal(const char* s)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_getglobal(M_WXLSTATEDATA->m_lua_State, s);
}

// ----------------------------------------------------------------------------
// Raw Lua Debug functions, lua.h

int wxLuaState::lua_GetStack(int level, lua_Debug* ar)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_getstack(M_WXLSTATEDATA->m_lua_State, level, ar);
}
int wxLuaState::lua_GetInfo(const char* what, lua_Debug* ar)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_getinfo(M_WXLSTATEDATA->m_lua_State, what, ar);
}
const char* wxLuaState::lua_GetLocal(const lua_Debug* ar, int n)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_getlocal(M_WXLSTATEDATA->m_lua_State, ar, n);
}
const char* wxLuaState::lua_SetLocal(const lua_Debug* ar, int n)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_setlocal(M_WXLSTATEDATA->m_lua_State, ar, n);
}
const char* wxLuaState::lua_GetUpvalue(int funcindex, int n)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_getupvalue(M_WXLSTATEDATA->m_lua_State, funcindex, n);
}
const char* wxLuaState::lua_SetUpvalue(int funcindex, int n)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return lua_setupvalue(M_WXLSTATEDATA->m_lua_State, funcindex, n);
}

int wxLuaState::lua_SetHook(lua_Hook func, int mask, int count)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_sethook(M_WXLSTATEDATA->m_lua_State, func, mask, count);
}
lua_Hook wxLuaState::lua_GetHook()
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_gethook(M_WXLSTATEDATA->m_lua_State);
}
int wxLuaState::lua_GetHookMask()
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_gethookmask(M_WXLSTATEDATA->m_lua_State);
}
int wxLuaState::lua_GetHookCount()
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return lua_gethookcount(M_WXLSTATEDATA->m_lua_State);
}

// ----------------------------------------------------------------------------
// Raw Lua auxlib functions, lauxlib.h

void wxLuaState::luaL_Register(const char *libname, const luaL_Reg *l)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    luaL_register(M_WXLSTATEDATA->m_lua_State, libname, l);
}
int wxLuaState::luaL_GetMetafield(int obj, const char *e)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_getmetafield(M_WXLSTATEDATA->m_lua_State, obj, e);
}
int wxLuaState::luaL_CallMeta(int obj, const char *e)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_callmeta(M_WXLSTATEDATA->m_lua_State, obj, e);
}
#if LUA_VERSION_NUM < 502
int wxLuaState::luaL_TypeError(int narg, const char *tname)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_typerror(M_WXLSTATEDATA->m_lua_State, narg, tname);
}
#endif // LUA_VERSION_NUM < 502
int wxLuaState::luaL_ArgError(int numarg, const char *extramsg)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_argerror(M_WXLSTATEDATA->m_lua_State, numarg, extramsg);
}
const char* wxLuaState::luaL_CheckLString(int numArg, size_t *l)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return luaL_checklstring(M_WXLSTATEDATA->m_lua_State, numArg, l);
}
const char* wxLuaState::luaL_OptLString(int numArg, const char *def, size_t *l)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return luaL_optlstring(M_WXLSTATEDATA->m_lua_State, numArg, def, l);
}
lua_Number wxLuaState::luaL_CheckNumber(int numArg)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_checknumber(M_WXLSTATEDATA->m_lua_State, numArg);
}
lua_Number wxLuaState::luaL_OptNumber(int nArg, lua_Number def)
{
    wxCHECK_MSG(Ok(), def, wxT("Invalid wxLuaState"));
    return luaL_optnumber(M_WXLSTATEDATA->m_lua_State, nArg, def);
}
lua_Integer wxLuaState::luaL_CheckInteger(int numArg)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_checkinteger(M_WXLSTATEDATA->m_lua_State, numArg);
}
lua_Integer wxLuaState::luaL_OptInteger(int nArg, lua_Integer def)
{
    wxCHECK_MSG(Ok(), def, wxT("Invalid wxLuaState"));
    return luaL_optinteger(M_WXLSTATEDATA->m_lua_State, nArg, def);
}

void wxLuaState::luaL_CheckStack(int sz, const char *msg)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    luaL_checkstack(M_WXLSTATEDATA->m_lua_State, sz, msg);
}
void wxLuaState::luaL_CheckType(int narg, int t)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    luaL_checktype(M_WXLSTATEDATA->m_lua_State, narg, t);
}
void wxLuaState::luaL_CheckAny(int narg)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    luaL_checkany(M_WXLSTATEDATA->m_lua_State, narg);
}

int   wxLuaState::luaL_NewMetatable(const char *tname)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_newmetatable(M_WXLSTATEDATA->m_lua_State, tname);
}
void  wxLuaState::luaL_GetMetatable(const char *tname)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    luaL_getmetatable(M_WXLSTATEDATA->m_lua_State, tname);
}
void* wxLuaState::luaL_CheckUdata(int ud, const char *tname)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return luaL_checkudata(M_WXLSTATEDATA->m_lua_State, ud, tname);
}

void wxLuaState::luaL_Where(int lvl)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    luaL_where(M_WXLSTATEDATA->m_lua_State, lvl);
}
int wxLuaState::luaL_Error(const char *fmt, ...)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_error(M_WXLSTATEDATA->m_lua_State, fmt);
}

int wxLuaState::luaL_CheckOption(int narg, const char *def, const char *const lst[])
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_checkoption(M_WXLSTATEDATA->m_lua_State, narg, def, lst);
}

int wxLuaState::luaL_Ref(int t)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_ref(M_WXLSTATEDATA->m_lua_State, t);
}
void wxLuaState::luaL_Unref(int t, int ref)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    luaL_unref(M_WXLSTATEDATA->m_lua_State, t, ref);
}

int wxLuaState::luaL_LoadFile(const char *filename)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_loadfile(M_WXLSTATEDATA->m_lua_State, filename);
}
int wxLuaState::luaL_LoadBuffer(const char *buff, size_t sz, const char *name)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_loadbuffer(M_WXLSTATEDATA->m_lua_State, buff, sz, name);
}
int wxLuaState::luaL_LoadString(const char *s)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return luaL_loadstring(M_WXLSTATEDATA->m_lua_State, s);
}

void wxLuaState::luaL_ArgCheck(bool condition, int numarg, const char* extramsg)
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    luaL_argcheck(M_WXLSTATEDATA->m_lua_State, condition, numarg, extramsg);
}
const char* wxLuaState::luaL_CheckString(int numArg)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return luaL_checkstring(M_WXLSTATEDATA->m_lua_State, numArg);
}
const char* wxLuaState::luaL_OptString(int numArg, const char* def)
{
    wxCHECK_MSG(Ok(), NULL, wxT("Invalid wxLuaState"));
    return luaL_optstring(M_WXLSTATEDATA->m_lua_State, numArg, def);
}
int wxLuaState::luaL_CheckInt(int numArg)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return (int)luaL_checkint(M_WXLSTATEDATA->m_lua_State, numArg);
}
int wxLuaState::luaL_OptInt(int numArg, int def)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return (int)luaL_optint(M_WXLSTATEDATA->m_lua_State, numArg, def);
}
long wxLuaState::luaL_CheckLong(int numArg)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return (long)luaL_checklong(M_WXLSTATEDATA->m_lua_State, numArg);
}
long wxLuaState::luaL_OptLong(int numArg, int def)
{
    wxCHECK_MSG(Ok(), 0, wxT("Invalid wxLuaState"));
    return (long)luaL_optlong(M_WXLSTATEDATA->m_lua_State, numArg, def);
}

// ----------------------------------------------------------------------------
// others

void wxLuaState::GetGlobals()
{
    wxCHECK_RET(Ok(), wxT("Invalid wxLuaState"));
    lua_pushglobaltable(M_WXLSTATEDATA->m_lua_State);
}

#define LUA_PATH "LUA_PATH"

// get LUA_PATH
wxString wxLuaState::GetLuaPath()
{
    wxCHECK_MSG(Ok(), wxEmptyString, wxT("Invalid wxLuaState"));
    lua_GetGlobal(LUA_PATH);
    wxString path = lua_TowxString(-1);
    lua_Pop(1);

    return path;
}

// add path list to LUA_PATH
void wxLuaState::AddLuaPath(const wxPathList& pathlist)
{
    size_t i, count = pathlist.GetCount();
    for (i = 0; i < count; ++i)
    {
        wxFileName fname(pathlist[i]);
        AddLuaPath(fname);
    }
}

// add filename path to LUA_PATH
void wxLuaState::AddLuaPath(const wxFileName& filename)
{
    wxFileName fname = filename;
    fname.SetName(wxT("?"));
    fname.SetExt(wxT("lua"));

    wxString path    = fname.GetFullPath();
    wxString luapath = GetLuaPath();

    // check if path
    wxStringTokenizer tkz(luapath, wxT(";"));
    while (tkz.HasMoreTokens())
    {
        wxString token = tkz.GetNextToken();

        if ((token == path) || (!wxFileName::IsCaseSensitive() && token.CmpNoCase(path) == 0))
            return;
    }

    // append separator
    if (!luapath.IsEmpty() && (luapath.Last() != wxT(';')))
        luapath += wxT(';');

    // append path
    luapath += path + wxT(';');

    lua_PushString(luapath);
    lua_SetGlobal(LUA_PATH);
}

//-----------------------------------------------------------------------------
// wxLuaEvent
//-----------------------------------------------------------------------------

DEFINE_LOCAL_EVENT_TYPE(wxEVT_LUA_CREATION)
DEFINE_LOCAL_EVENT_TYPE(wxEVT_LUA_PRINT)
DEFINE_LOCAL_EVENT_TYPE(wxEVT_LUA_ERROR)
DEFINE_LOCAL_EVENT_TYPE(wxEVT_LUA_DEBUG_HOOK)
//DEFINE_LOCAL_EVENT_TYPE(wxEVT_LUA_INIT)
//DEFINE_LOCAL_EVENT_TYPE(wxEVT_LUA_DEBUGGERATTACHED)

wxLuaEvent::wxLuaEvent(wxEventType commandType, wxWindowID id, const wxLuaState& wxlState)
           :wxNotifyEvent(commandType, id),  m_wxlState(wxlState),
            m_debug_hook_break(false),
            m_lua_Debug(NULL)
{
}

wxLuaEvent::wxLuaEvent( const wxLuaEvent &event )
           :wxNotifyEvent(event), m_wxlState(event.m_wxlState),
            m_debug_hook_break(event.m_debug_hook_break),
            m_lua_Debug(event.m_lua_Debug)
{
}


//-----------------------------------------------------------------------------
// bitlib release 25 - Bitwise operations library
// by Reuben Thomas <rrt@sc3d.org>
// http://luaforge.net/projects/bitlib
// copyright Reuben Thomas 2000-2008, and is released under the MIT license
//-----------------------------------------------------------------------------

// This is the code copied directly from lbitlib.c and ever so slightly modified
// to allow it to work here.

/* Bitwise operations library */
/* (c) Reuben Thomas 2000-2008 */
/* See README for license */

//#include "config.h"

//#include <lua.h>
//#include <lauxlib.h>
#include <limits.h>

//#include "bit_limits.h"
#define BITLIB_FLOAT_BITS 53
#define BITLIB_FLOAT_MAX  0xfffffffffffffL
#define BITLIB_FLOAT_MIN  (-0x10000000000000L)
#if defined(__VISUALC__)
    #define BITLIB_FLOAT_UMAX 0x1fffffffffffffUL
#else
    #define BITLIB_FLOAT_UMAX 0x1fffffffffffffULL
#endif

/* FIXME: Assume lua_Integer is ptrdiff_t */
#define LUA_INTEGER_MAX PTRDIFF_MAX
#define LUA_INTEGER_MIN PTRDIFF_MIN

#ifndef SIZE_MAX
#define SIZE_MAX ((size_t)-1)
#endif

/* FIXME: Assume size_t is an unsigned lua_Integer */
typedef size_t lua_UInteger;
#define LUA_UINTEGER_MAX SIZE_MAX


/* Bit type size and limits */

#define BIT_BITS                                                        \
  (CHAR_BIT * sizeof(lua_Integer) > BITLIB_FLOAT_BITS ?                 \
   BITLIB_FLOAT_BITS : (CHAR_BIT * sizeof(lua_Integer)))

/* This code may give warnings if BITLIB_FLOAT_* are too big to fit in
   long, but that doesn't matter since in that case they won't be
   used. */
#define BIT_MAX                                                         \
  (CHAR_BIT * sizeof(lua_Integer) > BITLIB_FLOAT_BITS ? BITLIB_FLOAT_MAX : LUA_INTEGER_MAX)

#define BIT_MIN                                                         \
  (CHAR_BIT * sizeof(lua_Integer) > BITLIB_FLOAT_BITS ? BITLIB_FLOAT_MIN : LUA_INTEGER_MIN)

#define BIT_UMAX                                                        \
  (CHAR_BIT * sizeof(lua_Integer) > BITLIB_FLOAT_BITS ? BITLIB_FLOAT_UMAX : LUA_UINTEGER_MAX)


#define BUILTIN_CAST

/* Define TOBIT to get a bit value */
#ifdef BUILTIN_CAST
#define TOBIT(L, n, res)                    \
  ((void)(res), luaL_checkinteger((L), (n)))
#else
#include <stdint.h>
#include <math.h>

/* FIXME: Assume lua_Number fits in a double (use of fmod). */
#define TOBIT(L, n, res)                                            \
  ((lua_Integer)(((res) = fmod(luaL_checknumber(L, (n)), (double)BIT_UMAX + 1.0)), \
                 (res) > BIT_MAX ? ((res) -= (double)BIT_UMAX, (res) -= 1) : \
                 ((res) < BIT_MIN ? ((res) += (double)BIT_UMAX, (res) += 1) : (res))))
#endif


#define BIT_TRUNCATE(i)                         \
  ((i) & BIT_UMAX)

/* Operations

   The macros MONADIC and VARIADIC only deal with bitwise operations.

   LOGICAL_SHIFT truncates its left-hand operand before shifting so
   that any extra bits at the most-significant end are not shifted
   into the result.

   ARITHMETIC_SHIFT does not truncate its left-hand operand, so that
   the sign bits are not removed and right shift work properly.
   */

#define MONADIC(name, op)                                       \
  static int bit_ ## name(lua_State *L) {                       \
    lua_Number f;                                               \
    lua_pushinteger(L, BIT_TRUNCATE(op TOBIT(L, 1, f)));        \
    return 1;                                                   \
  }

#define VARIADIC(name, op)                      \
  static int bit_ ## name(lua_State *L) {       \
    lua_Number f;                               \
    int n = lua_gettop(L), i;                   \
    lua_Integer w = TOBIT(L, 1, f);             \
    for (i = 2; i <= n; i++)                    \
      w op TOBIT(L, i, f);                      \
    lua_pushinteger(L, BIT_TRUNCATE(w));        \
    return 1;                                   \
  }

#define LOGICAL_SHIFT(name, op)                                         \
  static int bit_ ## name(lua_State *L) {                               \
    lua_Number f;                                                       \
    lua_pushinteger(L, BIT_TRUNCATE(BIT_TRUNCATE((lua_UInteger)TOBIT(L, 1, f)) op \
                                    (unsigned)luaL_checknumber(L, 2))); \
    return 1;                                                           \
  }

#define ARITHMETIC_SHIFT(name, op)                                      \
  static int bit_ ## name(lua_State *L) {                               \
    lua_Number f;                                                       \
    lua_pushinteger(L, BIT_TRUNCATE((lua_Integer)TOBIT(L, 1, f) op      \
                                    (unsigned)luaL_checknumber(L, 2))); \
    return 1;                                                           \
  }

MONADIC(cast,  +)
MONADIC(bnot,  ~)
VARIADIC(band, &=)
VARIADIC(bor,  |=)
VARIADIC(bxor, ^=)
ARITHMETIC_SHIFT(lshift,  <<)
LOGICAL_SHIFT(rshift,     >>)
//ARITHMETIC_SHIFT(arshift, >>) // broken in 64 bit

static const struct luaL_Reg bitlib[] = {
  {"cast",    bit_cast},
  {"bnot",    bit_bnot},
  {"band",    bit_band},
  {"bor",     bit_bor},
  {"bxor",    bit_bxor},
  {"lshift",  bit_lshift},
  {"rshift",  bit_rshift},
  //{"arshift", bit_arshift},

  {NULL, NULL}
};

int LUACALL luaopen_bit (lua_State *L) {
  luaL_register(L, "bit", bitlib);
  lua_pushnumber(L, BIT_BITS);
  lua_setfield(L, -2, "bits");
  return 1;
}
