/////////////////////////////////////////////////////////////////////////////
// Purpose:     Implements the client end of wxLua debugging session
// Author:      J. Winwood, John Labenski, Ray Gilbert
// Created:     May 2002
// RCS-ID:      $Id: wxldtarg.h,v 1.26 2007/11/28 22:55:02 jrl1 Exp $
// Copyright:   (c) 2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#ifndef LUA_DEBUG_TARGET_H
#define LUA_DEBUG_TARGET_H

#include "wx/thread.h"
#include "wxluasocket/include/wxluasocketdefs.h"
#include "wxlua/include/wxlua.h"
#include "wxluadebug/include/wxldebug.h"
#include "wxluasocket/include/wxlsock.h"

// ----------------------------------------------------------------------------
// wxLuaDebugTarget - a C++ socket target that the wxLuaDebuggerServer run in Lua
//                    communicates with. Handles the Debugger/Debuggee IO
// ----------------------------------------------------------------------------

class WXDLLIMPEXP_WXLUASOCKET wxLuaDebugTarget : public wxObject
{
protected:
    // -----------------------------------------------------------------------
    // wxLuaDebugTarget::LuaThread - a wxThread for the wxLuaDebugTarget
    // -----------------------------------------------------------------------
    class LuaThread : public wxThread
    {
        public:
            LuaThread(wxLuaDebugTarget *pTarget) : wxThread(wxTHREAD_JOINABLE),
                                                   m_pTarget(pTarget) {}
        protected:
            virtual void *Entry();   // thread execution starts here
            virtual void OnExit() {} // called when the thread exits

            wxLuaDebugTarget *m_pTarget;
    };

public:
    wxLuaDebugTarget(const wxLuaState& wxlState, const wxString &serverName,
                                                 int portNumber);
    virtual ~wxLuaDebugTarget();

    bool Run();
    void Stop();

    void ThreadFunction();
    bool HandleDebuggerCmd(int cmd);
    void DisplayError(const wxString& errorMsg) { NotifyError(errorMsg); }

protected:

    enum debugOperations
    {
        DEBUG_STEP,
        DEBUG_STEPOVER,
        DEBUG_STEPOUT,
        DEBUG_GO
    };

    wxLuaState          m_wxlState;
    int                 m_port_number;
    wxString            m_serverName;
    wxSortedArrayString m_breakPointList;
    wxMutex             m_debugMutex;
    wxCondition         m_debugCondition;
    wxLuaSocket         m_clientSocket;
    debugOperations     m_nextOperation;
    bool                m_forceBreak;
    bool                m_resetRequested;
    bool                m_fConnected;
    bool                m_fRunning;
    bool                m_fStopped;
    bool                m_fExiting;
    bool                m_fErrorsSeen;
    int                 m_nFramesUntilBreak;
    wxMutex             m_runMutex;
    wxCondition         m_runCondition;
    wxArrayString       m_bufferArray;
    LuaThread          *m_pThread;
    wxArrayInt          m_references;
    wxCriticalSection   m_luaCriticalSection;
    mutable wxCriticalSection m_breakPointListCriticalSection;

    // Enter/Leave critical section for the threaded sockets
    inline void EnterLuaCriticalSection() { m_luaCriticalSection.Enter(); }
    inline void LeaveLuaCriticalSection() { m_luaCriticalSection.Leave(); }

    void ExitThread();

    // Return a string ("%d:%s", lineNumber, fileName) for the breakpoint
    wxString CreateBreakPoint(const wxString &fileName, int lineNumber) const;
    // Are we at a set breakpoint?
    bool AtBreakPoint(const wxString &fileName, int lineNumber) const;

    bool AddBreakPoint(const wxString &fileName, int lineNumber);
    bool RemoveBreakPoint(const wxString &fileName, int lineNumber);
    bool ClearAllBreakPoints();
    bool Run(const wxString &fileName, const wxString &buffer);
    bool Step();
    bool StepOver();
    bool StepOut();
    bool Continue();
    bool Break();
    bool Reset();
    bool EnumerateStack();
    bool EnumerateStackEntry(int stackRef);
    bool EnumerateTable(int tableRef, int nIndex, long itemNode);
    bool EvaluateExpr(int exprRef, const wxString &strExpr);

    bool NotifyBreak(const wxString &fileName, int lineNumber);
    bool NotifyPrint(const wxString &errorMsg);
    bool NotifyError(const wxString &errorMsg);
    bool NotifyExit();
    bool NotifyStackEnumeration(const wxLuaDebugData& debugData);
    bool NotifyStackEntryEnumeration(int stackRef, const wxLuaDebugData& debugData);
    bool NotifyTableEnumeration(long itemNode, const wxLuaDebugData& debugData);
    bool NotifyEvaluateExpr(int exprRef, const wxString &strResult);

    // Handle events from the static wxLuaDebugTarget::LuaDebugHook
    bool DebugHook(int event);

    bool IsConnected(bool wait_for_connect = true) const;

    // Get the wxLuaDebugTarget that was pushed into Lua
    static wxLuaDebugTarget* GetDebugTarget(lua_State* L);

    // Handle the events from lua_sethook()
    static void LUACALL LuaDebugHook(lua_State *L, lua_Debug *debug);
    // Forward the print statements to NotifyPrint()
    static int  LUACALL LuaPrint (lua_State *L);
};

#endif // LUA_DEBUG_TARGET_H
