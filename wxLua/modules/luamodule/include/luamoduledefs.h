///////////////////////////////////////////////////////////////////////////////
// Name:        luamoduledefs.h
// Purpose:     definitions for luamodule
// Author:      Francesco Montorsi
// Modified by:
// Created:     20/5/2006
// RCS-ID:      $Id: luamoduledefs.h,v 1.2 2006/12/19 17:53:39 frm Exp $
// Copyright:   (c) Francesco Montorsi
// Licence:     wxWidgets licence
///////////////////////////////////////////////////////////////////////////////

#ifndef __WX_LUAMODULEDEFS_H__
#define __WX_LUAMODULEDEFS_H__

#include "wx/defs.h"

// ----------------------------------------------------------------------------
// WXDLLIMPEXP macros
// ----------------------------------------------------------------------------

#ifdef WXMAKINGDLL_LUAMODULE
    #define WXDLLIMPEXP_LUAMODULE WXEXPORT
    #define WXDLLIMPEXP_DATA_LUAMODULE(type) WXEXPORT type
#elif defined(WXUSINGDLL)
    #define WXDLLIMPEXP_LUAMODULE WXIMPORT
    #define WXDLLIMPEXP_DATA_LUAMODULE(type) WXIMPORT type
#else // not making nor using DLL
    #define WXDLLIMPEXP_LUAMODULE
    #define WXDLLIMPEXP_DATA_LUAMODULE(type) type
#endif

// Forward declare classes with this macro
#if defined(HAVE_VISIBILITY) || (defined(__WINDOWS__) && defined(__GNUC__))
    #define WXDLLIMPEXP_FWD_LUAMODULE
#else
    #define WXDLLIMPEXP_FWD_LUAMODULE WXDLLIMPEXP_LUAMODULE
#endif

#endif  // __WX_LUAMODULEDEFS_H__
