/////////////////////////////////////////////////////////////////////////////
// Purpose:     Implements the client end of wxLua debugging session
// Author:      J. Winwood, John Labenski, Ray Gilbert
// Created:     May 2002
// RCS-ID:      $Id: wxldtarg.cpp,v 1.50 2010/08/27 20:23:30 jrl1 Exp $
// Copyright:   (c) 2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#include "wx/wxprec.h"

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#ifndef WX_PRECOMP
    #include "wx/wx.h"
#endif

#include "wxluasocket/include/wxldtarg.h"
#include "wxluasocket/include/wxldserv.h"

#if !wxCHECK_VERSION(2, 6, 0)
    #define wxMilliSleep wxUsleep
#endif // !wxCHECK_VERSION(2, 6, 0)

#define WXLUASOCKET_CONNECT_TIMEOUT 200       // 20 seconds

// ----------------------------------------------------------------------------
// wxLuaDebugTarget::LuaThread
// ----------------------------------------------------------------------------

void *wxLuaDebugTarget::LuaThread::Entry()
{
    m_pTarget->ThreadFunction();
    //m_pTarget->m_pThread = NULL;
    return 0;
}

// ----------------------------------------------------------------------------
// wxLuaDebugTarget - Handles Debugger/Debuggee IO
// ----------------------------------------------------------------------------

wxLuaDebugTarget::wxLuaDebugTarget(const wxLuaState& wxlState,
                                   const wxString &serverName,
                                   int             port_number) :
    m_wxlState(wxlState),
    m_port_number(port_number),
    m_serverName(serverName),
    m_debugCondition(m_debugMutex),
    m_forceBreak(false),
    m_resetRequested(false),
    m_fConnected(false),
    m_fRunning(false),
    m_fStopped(false),
    m_fExiting(false),
    m_fErrorsSeen(false),
    m_nFramesUntilBreak(0),
    m_runCondition(m_runMutex),
    m_pThread(NULL)
{
    m_clientSocket.m_name = wxString::Format(wxT("wxLuaDebugTarget::m_clientSocket (%ld)"), (long)wxGetProcessId());

    lua_State* L = m_wxlState.GetLuaState();
    // Stick us into the lua_State - push key, value
    lua_pushstring( L, "__wxLuaDebugTarget__" );
    lua_pushlightuserdata( L, (void*)this );
    // set the value
    lua_rawset( L, LUA_REGISTRYINDEX );

    lua_sethook(L, LuaDebugHook, LUA_MASKCALL | LUA_MASKLINE | LUA_MASKRET, 0);

    lua_pushcfunction(L, LuaPrint);
    lua_setglobal(L, "print");

    EnterLuaCriticalSection();
}

wxLuaDebugTarget::~wxLuaDebugTarget()
{
    //if (m_pThread != NULL)
    //    delete m_pThread;

    LeaveLuaCriticalSection();
}

bool wxLuaDebugTarget::IsConnected(bool wait_for_connect) const
{
    if (m_fConnected || !wait_for_connect) return m_fConnected;

    for (int idx = 0; idx < WXLUASOCKET_CONNECT_TIMEOUT; ++idx)
    {
        if (m_fConnected)
            break;

        wxMilliSleep(100);
    }
    return m_fConnected;
}

bool wxLuaDebugTarget::Run()
{
    wxCHECK_MSG(m_pThread == NULL, false, wxT("wxLuaDebugTarget::Run already called"));

    // Assume something is going to go wrong
    m_fErrorsSeen = true;

    m_pThread = new LuaThread(this);
    // Start the thread
    if ((m_pThread != NULL) &&
        (m_pThread->Create() == wxTHREAD_NO_ERROR) &&
        (m_pThread->Run()    == wxTHREAD_NO_ERROR))
    {
        // Wait for the connection to the server to complete
        if (!IsConnected())
        {
            wxMessageBox(wxT("Unable to connect to server"), wxT("wxLua client"), wxOK | wxCENTRE, NULL);
        }
        else
        {
            // OK, now we can start running.
            m_runCondition.Wait();

            m_fRunning    = true;
            m_fErrorsSeen = false;

            size_t idx, count = m_bufferArray.GetCount();
            for (idx = 0; idx < count; ++idx)
            {
                wxString luaBuffer = m_bufferArray.Item(idx);
                wxString bufFilename = luaBuffer.BeforeFirst(wxT('\0'));
                wxString buf =  luaBuffer.AfterFirst(wxT('\0'));

                wxLuaCharBuffer char_buf(buf);
                int rc = m_wxlState.LuaDoBuffer(char_buf, char_buf.Length(),
                                            wx2lua(bufFilename));

                m_fErrorsSeen = (rc != 0);
                if (m_fErrorsSeen)
                {
                    NotifyError(wxlua_LUA_ERR_msg(rc));
                    break;
                }
            }

            m_bufferArray.Clear();
        }
    }

    return !m_fErrorsSeen;
}

void wxLuaDebugTarget::Stop()
{
    NotifyExit();

    if (m_fConnected)
    {
        m_clientSocket.Shutdown(SD_BOTH);
        wxMilliSleep(100);
        m_clientSocket.Close();
    }

    if (m_pThread)
        m_pThread->Wait();
}

void wxLuaDebugTarget::ThreadFunction()
{
    bool fThreadRunning = false;

    if (m_clientSocket.Connect(m_serverName, m_port_number))
    {
        m_fConnected   = true;
        fThreadRunning = true;
    }
    else
    {
        return; // FIXME
    }

    while (fThreadRunning && !m_pThread->TestDestroy() && !m_resetRequested && !m_fExiting)
    {
        unsigned char debugCommand = 0; // wxLuaSocketDebuggerCommands_Type
        if (!m_clientSocket.ReadCmd(debugCommand) ||
            !HandleDebuggerCmd(debugCommand))
        {
            fThreadRunning = false;
        }
    }
}

bool wxLuaDebugTarget::HandleDebuggerCmd(int debugCommand)
{
    bool ret = false;

    switch ((int)debugCommand)
    {
        case wxLUASOCKET_DEBUGGER_CMD_NONE :
        {
            // This is an error, but maybe we can continue?
            ret = true;
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_ADD_BREAKPOINT:
        {
            wxString fileName;
            wxInt32  lineNumber = 0;

            if (m_clientSocket.ReadString(fileName) &&
                m_clientSocket.ReadInt32(lineNumber))
            {
                ret = AddBreakPoint(fileName, lineNumber);
            }
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_REMOVE_BREAKPOINT:
        {
            wxString fileName;
            wxInt32  lineNumber = 0;

            if (m_clientSocket.ReadString(fileName) &&
                m_clientSocket.ReadInt32(lineNumber))
            {
                ret = RemoveBreakPoint(fileName, lineNumber);
            }
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_CLEAR_ALL_BREAKPOINTS:
        {
            ret = ClearAllBreakPoints();
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_RUN_BUFFER:
        {
            wxString fileName;
            wxString buffer;

            if (m_clientSocket.ReadString(fileName) &&
                m_clientSocket.ReadString(buffer))
            {
                ret = Run(fileName, buffer);
            }
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_DEBUG_STEP:
        {
            ret = Step();
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_DEBUG_STEPOVER:
        {
            ret = StepOver();
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_DEBUG_STEPOUT:
        {
            ret = StepOut();
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_DEBUG_CONTINUE:
        {
            m_forceBreak = false;
            ret = Continue();
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_DEBUG_BREAK:
        {
            ret = Break();
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_ENUMERATE_STACK:
        {
            ret = EnumerateStack();
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_ENUMERATE_STACK_ENTRY:
        {
            wxInt32 stackRef = 0;

            if (m_clientSocket.ReadInt32(stackRef))
                ret = EnumerateStackEntry(stackRef);

            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_ENUMERATE_TABLE_REF:
        {
            wxInt32 tableRef = 0;
            wxInt32 index    = 0;
            long    itemNode = 0;

            if (m_clientSocket.ReadInt32(tableRef) &&
                m_clientSocket.ReadInt32(index) &&
                m_clientSocket.ReadLong(itemNode))
            {
                ret = EnumerateTable(tableRef, index, itemNode);
            }
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_RESET:
        {
            ret = Reset();
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_EVALUATE_EXPR:
        {
            wxInt32 exprRef = 0;
            wxString buffer;

            if (m_clientSocket.ReadInt32(exprRef) &&
                m_clientSocket.ReadString(buffer))
            {
                ret = EvaluateExpr(exprRef, buffer);
            }
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_CLEAR_DEBUG_REFERENCES:
        {
            size_t idx, idxMax = m_references.GetCount();
            for (idx = 0; idx < idxMax; ++idx)
            {
                int iItem = m_references.Item(idx);
                m_wxlState.wxluaR_Unref(iItem, &wxlua_lreg_debug_refs_key);
            }
            m_references.Clear();
            ret = true;
            break;
        }
        case wxLUASOCKET_DEBUGGER_CMD_DISABLE_BREAKPOINT: // FIXME do something here
            ret = true;
            break;
        case wxLUASOCKET_DEBUGGER_CMD_ENABLE_BREAKPOINT: // FIXME do something here
            ret = true;
            break;
        default :
            wxFAIL_MSG(wxT("Invalid wxLuaSocketDebuggerCommands_Type in wxLuaDebugTarget::ThreadFunction"));
    }

    return ret;
}

wxString wxLuaDebugTarget::CreateBreakPoint(const wxString &fileName, int lineNumber) const
{
    return wxString::Format(wxT("%d:"), lineNumber) + fileName;
}

bool wxLuaDebugTarget::AtBreakPoint(const wxString &fileName, int lineNumber) const
{
    wxCriticalSectionLocker locker(m_breakPointListCriticalSection);
    return (m_breakPointList.Index(CreateBreakPoint(fileName, lineNumber)) != wxNOT_FOUND);
}

bool wxLuaDebugTarget::AddBreakPoint(const wxString &fileName, int lineNumber)
{
    wxString breakPoint = CreateBreakPoint(fileName, lineNumber);
    wxCriticalSectionLocker locker(m_breakPointListCriticalSection);
    if (m_breakPointList.Index(breakPoint) == wxNOT_FOUND)
        m_breakPointList.Add(breakPoint);
    return true;
}

bool wxLuaDebugTarget::RemoveBreakPoint(const wxString &fileName, int lineNumber)
{
    wxCriticalSectionLocker locker(m_breakPointListCriticalSection);
    m_breakPointList.Remove(CreateBreakPoint(fileName, lineNumber));
    return true;
}

bool wxLuaDebugTarget::ClearAllBreakPoints()
{
    wxCriticalSectionLocker locker(m_breakPointListCriticalSection);
    m_breakPointList.Clear();
    return true;
}

bool wxLuaDebugTarget::Run(const wxString &fileName, const wxString &buffer)
{
    m_bufferArray.Add(fileName + wxT('\0') + buffer);
    return true;
}

bool wxLuaDebugTarget::Step()
{
    m_nextOperation = DEBUG_STEP;

    if (!m_fRunning)
        m_runCondition.Signal();
    else if (m_fStopped)
        m_debugCondition.Signal();

    return true;
}

bool wxLuaDebugTarget::StepOver()
{
    m_nFramesUntilBreak = 0;
    m_nextOperation = DEBUG_STEPOVER;

    if (!m_fRunning)
        m_runCondition.Signal();
    else if (m_fStopped)
        m_debugCondition.Signal();

    return true;
}

bool wxLuaDebugTarget::StepOut()
{
    m_nFramesUntilBreak = 1;
    m_nextOperation = DEBUG_STEPOVER;

    if (!m_fRunning)
        m_runCondition.Signal();
    else if (m_fStopped)
        m_debugCondition.Signal();

    return true;
}

bool wxLuaDebugTarget::Continue()
{
    m_nextOperation = DEBUG_GO;

    if (!m_fRunning)
        m_runCondition.Signal();
    else if (m_fStopped)
        m_debugCondition.Signal();

    return true;
}

bool wxLuaDebugTarget::Break()
{
    m_forceBreak = true;
    return true;
}

bool wxLuaDebugTarget::Reset()
{
    NotifyExit();

    m_forceBreak     = true;
    m_resetRequested = true;

    if (!m_fRunning)
        m_runCondition.Signal();
    else if (m_fStopped)
        m_debugCondition.Signal();

    return true;
}

bool wxLuaDebugTarget::EnumerateStack()
{
    wxLuaDebugData debugData(true);

    EnterLuaCriticalSection();
    debugData.EnumerateStack(m_wxlState.GetLuaState());
    LeaveLuaCriticalSection();

    return NotifyStackEnumeration(debugData);
}

bool wxLuaDebugTarget::EnumerateStackEntry(int stackRef)
{
    wxLuaDebugData debugData(true);

    EnterLuaCriticalSection();
    debugData.EnumerateStackEntry(m_wxlState.GetLuaState(), stackRef, m_references);
    LeaveLuaCriticalSection();

    return NotifyStackEntryEnumeration(stackRef, debugData);
}

bool wxLuaDebugTarget::EnumerateTable(int tableRef, int nIndex, long nItemNode)
{
    wxLuaDebugData debugData(true);

    EnterLuaCriticalSection();
    debugData.EnumerateTable(m_wxlState.GetLuaState(), tableRef, nIndex, m_references);
    LeaveLuaCriticalSection();

    return NotifyTableEnumeration(nItemNode, debugData);
}

bool wxLuaDebugTarget::EvaluateExpr(int exprRef, const wxString &strExpr) // FIXME - check this code
{
    wxString strResult(wxT("Error"));
    int      nReference = LUA_NOREF;

    EnterLuaCriticalSection();
    {
        lua_State* L = m_wxlState.GetLuaState();

        if (wxStrpbrk(strExpr.c_str(), wxT(" ~=<>+-*/%(){}[]:;,.\"'")) != NULL)
        {
            // an expression
            int nOldTop = lua_gettop(L);

            wxLuaCharBuffer charbuf(strExpr);
            int nResult = luaL_loadbuffer(L, charbuf.GetData(), charbuf.Length(), "debug");

            if (nResult == 0)
                nResult = lua_pcall(L, 0, LUA_MULTRET, 0);  // call main

            if (nResult != 0)
                wxlua_pushwxString(L, wxlua_LUA_ERR_msg(nResult));

            else if (lua_gettop(L) == nOldTop)
                lua_pushliteral(L, "OK");

            nReference = m_wxlState.wxluaR_Ref(-1, &wxlua_lreg_refs_key);
            lua_settop(L, nOldTop); // throw out all return values
        }
        else
        {
             lua_Debug ar = INIT_LUA_DEBUG;
             int       iLevel = 0;
             bool      fFound = false;

             while (lua_getstack(L, iLevel++, &ar) != 0)
             {
                int       iIndex = 0;
                wxString name = lua2wx(lua_getlocal(L, &ar, ++iIndex));
                if (!name.IsEmpty())
                {
                    if (strExpr == name)
                    {
                        nReference = m_wxlState.wxluaR_Ref(-1, &wxlua_lreg_refs_key);
                        fFound = true;
                        break;
                    }

                    lua_pop(L, 1);
                }

                if (fFound)
                    break;

                name = lua2wx(lua_getlocal(L, &ar, ++iIndex));
             }

             if (!fFound)
             {
                  int nOldTop = lua_gettop(L);
                  lua_pushvalue(L, LUA_GLOBALSINDEX);
                  lua_pushnil(L);
                  while (lua_next(L, -2) != 0)
                  {
                      if (lua_type(L, -2) == LUA_TSTRING)
                      {
                          wxString name = lua2wx(lua_tostring(L, -2));
                          if (strExpr == name)
                          {
                              nReference = m_wxlState.wxluaR_Ref(-1, &wxlua_lreg_refs_key); // reference value
                              lua_pop(L, 2);    // pop key and value
                              fFound = true;
                              break;
                          }
                      }

                      lua_pop(L, 1);  // removes 'value';
                  }
                  lua_settop(L, nOldTop); // the table of globals.
             }
        }

        if (m_wxlState.wxluaR_GetRef(nReference, &wxlua_lreg_refs_key))
        {
            m_wxlState.wxluaR_Unref(nReference, &wxlua_lreg_refs_key);

            int wxl_type = 0;
            wxString value;
            wxLuaDebugData::GetTypeValue(L, -1, &wxl_type, value);

            strResult.Printf(wxT("%s : %s"), wxluaT_typename(L, wxl_type).c_str(), value.c_str());

            lua_pop(L, 1);
        }
    }
    LeaveLuaCriticalSection();

    return NotifyEvaluateExpr(exprRef, strResult);
}

bool wxLuaDebugTarget::NotifyBreak(const wxString &fileName, int lineNumber)
{
    return IsConnected() && !m_resetRequested &&
           m_clientSocket.WriteCmd(wxLUASOCKET_DEBUGGEE_EVENT_BREAK) &&
           m_clientSocket.WriteString(fileName) &&
           m_clientSocket.WriteInt32(lineNumber);
}

bool wxLuaDebugTarget::NotifyPrint(const wxString &errorMsg)
{
    return IsConnected() &&
           m_clientSocket.WriteCmd(wxLUASOCKET_DEBUGGEE_EVENT_PRINT) &&
           m_clientSocket.WriteString(errorMsg);
}

bool wxLuaDebugTarget::NotifyError(const wxString &errorMsg)
{
    if (IsConnected() &&
        m_clientSocket.WriteCmd(wxLUASOCKET_DEBUGGEE_EVENT_ERROR) &&
        m_clientSocket.WriteString(errorMsg))
    {
        return true;
    }
    else
        wxMessageBox(errorMsg, wxT("wxLua debug client error"), wxOK | wxCENTRE, NULL);

    m_fErrorsSeen = true;
    return false;
}

bool wxLuaDebugTarget::NotifyExit()
{
    bool ret = IsConnected() &&
           m_clientSocket.WriteCmd(wxLUASOCKET_DEBUGGEE_EVENT_EXIT);

    return ret;
}

bool wxLuaDebugTarget::NotifyStackEnumeration(const wxLuaDebugData& debugData)
{
    return IsConnected() &&
           m_clientSocket.WriteCmd(wxLUASOCKET_DEBUGGEE_EVENT_STACK_ENUM) &&
           m_clientSocket.WriteDebugData(debugData);
}

bool wxLuaDebugTarget::NotifyStackEntryEnumeration(int entryRef,
                                                   const wxLuaDebugData& debugData)
{
    return IsConnected() &&
           m_clientSocket.WriteCmd(wxLUASOCKET_DEBUGGEE_EVENT_STACK_ENTRY_ENUM) &&
           m_clientSocket.WriteInt32(entryRef) &&
           m_clientSocket.WriteDebugData(debugData);
}

bool wxLuaDebugTarget::NotifyTableEnumeration(long itemNode,
                                              const wxLuaDebugData& debugData)
{
    return IsConnected() &&
           m_clientSocket.WriteCmd(wxLUASOCKET_DEBUGGEE_EVENT_TABLE_ENUM) &&
           m_clientSocket.WriteLong(itemNode) &&
           m_clientSocket.WriteDebugData(debugData);
}

bool wxLuaDebugTarget::NotifyEvaluateExpr(int exprRef,
                                          const wxString &strResult)
{
    return IsConnected() &&
           m_clientSocket.WriteCmd(wxLUASOCKET_DEBUGGEE_EVENT_EVALUATE_EXPR) &&
           m_clientSocket.WriteInt32(exprRef) &&
           m_clientSocket.WriteString(strResult);
}

bool wxLuaDebugTarget::DebugHook(int event)
{
    bool fWait = false;
    m_fStopped = true;

    int      lineNumber = 0;
    wxString fileName;

    if (!(m_forceBreak && m_resetRequested))
    {
        lua_Debug luaDebug = INIT_LUA_DEBUG;
        lua_getstack(m_wxlState.GetLuaState(), 0, &luaDebug);
        lua_getinfo(m_wxlState.GetLuaState(), "Sln", &luaDebug);
        lineNumber = luaDebug.currentline - 1;
        fileName = lua2wx(luaDebug.source);
        if (!fileName.IsEmpty() && (fileName[0] == wxT('@')))
            fileName = fileName.Mid(1);
    }

    if (m_forceBreak)
    {
        if (m_resetRequested)
        {
            fWait = true;
            m_fExiting = true;
            wxExit();
        }

        if (!m_fExiting)
        {
            if (NotifyBreak(fileName, lineNumber))
                fWait = true;
        }
    }
    else
    {
        if (event == LUA_HOOKCALL) // call
            m_nFramesUntilBreak++;
        else if ((event == LUA_HOOKRET) || (event == LUA_HOOKTAILRET)) // return
        {
            if (m_nFramesUntilBreak > 0)
                m_nFramesUntilBreak--;
        }
        else if (event == LUA_HOOKLINE) // line
        {
            switch (m_nextOperation)
            {
                case DEBUG_STEP:
                {
                    if (NotifyBreak(fileName, lineNumber))
                        fWait = true;

                    break;
                }
                case DEBUG_STEPOVER:
                {
                    if ((m_nFramesUntilBreak == 0) && NotifyBreak(fileName, lineNumber))
                        fWait = true;

                    break;
                }
                case DEBUG_GO:
                default:
                {
                    if (AtBreakPoint(fileName, lineNumber) && NotifyBreak(fileName, lineNumber))
                        fWait = true;

                    break;
                }
            }
        }
    }

    if (fWait)
    {
        // release the critical section so
        // the other thread can access LUA
        LeaveLuaCriticalSection();
        // Wait for a command
        m_debugCondition.Wait();
        // acquire the critical section again
        EnterLuaCriticalSection();
    }

    m_fStopped = false;
    return fWait;
}

// --------------------------------------------------------------------------

wxLuaDebugTarget* wxLuaDebugTarget::GetDebugTarget(lua_State* L)
{
    wxLuaDebugTarget *pTarget = NULL;

    // try to get the state we've stored
    lua_pushstring( L, "__wxLuaDebugTarget__" );
    lua_rawget( L, LUA_REGISTRYINDEX );
    // if nothing was returned or it wasn't a ptr, abort
    if ( lua_islightuserdata(L, -1) )
        pTarget = (wxLuaDebugTarget*)lua_touserdata( L, -1 );

    lua_pop(L, 1);

    return pTarget;
}

void LUACALL wxLuaDebugTarget::LuaDebugHook(lua_State *L, lua_Debug *pLuaDebug)
{
    wxLuaDebugTarget *pTarget = GetDebugTarget(L);

    if (pTarget != NULL)
        pTarget->DebugHook(pLuaDebug->event);
}

int LUACALL wxLuaDebugTarget::LuaPrint(lua_State *L)
{
    int         idx;
    wxString stream;
    int n = lua_gettop(L);  /* number of arguments */
    lua_getglobal(L, "tostring");
    for (idx = 1; idx <= n;  idx++)
    {
        lua_pushvalue(L, -1);  /* function to be called */
        lua_pushvalue(L, idx);   /* value to print */
        lua_call(L, 1, 1);
        wxString s = lua2wx(lua_tostring(L, -1));  /* get result */
        if (s.IsEmpty())
            return luaL_error(L, "`tostring' must return a string to `print'");
        if (idx > 1)
            stream.Append(wxT("\t"));
        stream.Append(s);
        lua_pop(L, 1);  /* pop result */
    }

    wxLuaDebugTarget *pTarget = GetDebugTarget(L);

    if (pTarget != NULL)
        pTarget->NotifyPrint(stream);

    return 0;
}
