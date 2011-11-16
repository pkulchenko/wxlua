///////////////////////////////////////////////////////////////////////////////
// Name:        wxluadebugdefs.h
// Purpose:     definitions for wxLuaDebug module
// Author:      Francesco Montorsi
// Modified by:
// Created:     20/5/2006
// RCS-ID:      $Id: wxluasocketdefs.h,v 1.5 2007/05/21 01:08:00 jrl1 Exp $
// Copyright:   (c) Francesco Montorsi
// Licence:     wxWidgets licence
///////////////////////////////////////////////////////////////////////////////

#ifndef __WX_WXLUASOCKETDEFS_H__
#define __WX_WXLUASOCKETDEFS_H__

#include "wx/defs.h"

#include "wxlua/include/wxldefs.h"
#include "wxluadebug/include/wxluadebugdefs.h"

// ----------------------------------------------------------------------------
// WXDLLIMPEXP macros
// ----------------------------------------------------------------------------

#ifdef WXMAKINGDLL_WXLUASOCKET
    #define WXDLLIMPEXP_WXLUASOCKET WXEXPORT
    #define WXDLLIMPEXP_DATA_WXLUASOCKET(type) WXEXPORT type
#elif defined(WXUSINGDLL)
    #define WXDLLIMPEXP_WXLUASOCKET WXIMPORT
    #define WXDLLIMPEXP_DATA_WXLUASOCKET(type) WXIMPORT type
#else // not making nor using DLL
    #define WXDLLIMPEXP_WXLUASOCKET
    #define WXDLLIMPEXP_DATA_WXLUASOCKET(type) type
#endif

// ----------------------------------------------------------------------------
// Defines for various things
// ----------------------------------------------------------------------------

#define ID_WXLUA_SERVER          1200
#define ID_WXLUA_SOCKET          1201

#define WXLUA_SOCKET_PORT        1561

#endif  // __WX_WXLUASOCKETDEFS_H__
