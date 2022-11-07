// ---------------------------------------------------------------------------
// wxnet.h - headers and wxLua types for wxLua binding
//
// This file was generated by genwxbind.lua 
// Any changes made to this file will be lost when the file is regenerated
// ---------------------------------------------------------------------------

#ifndef __HOOK_WXLUA_wxnet_H__
#define __HOOK_WXLUA_wxnet_H__

#include "wxbind/include/wxbinddefs.h"
#include "wxluasetup.h"
#include "wxbind/include/wxcore_bind.h"

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
class WXDLLIMPEXP_BINDWXNET wxLuaBinding_wxnet : public wxLuaBinding
{
public:
    wxLuaBinding_wxnet();


private:
    DECLARE_DYNAMIC_CLASS(wxLuaBinding_wxnet)
};


// initialize wxLuaBinding_wxnet for all wxLuaStates
extern WXDLLIMPEXP_BINDWXNET wxLuaBinding* wxLuaBinding_wxnet_init();

// ---------------------------------------------------------------------------
// Includes
// ---------------------------------------------------------------------------

#if (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL)
    #include "wx/protocol/protocol.h"
#endif // (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL)

#if (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL_FTP)
    #include "wx/protocol/ftp.h"
#endif // (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL_FTP)

#if (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL_HTTP)
    #include "wx/protocol/http.h"
#endif // (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL_HTTP)

#if (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_URL)
    #include "wx/url.h"
#endif // (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_URL)

#if wxLUA_USE_wxSocket && wxUSE_SOCKETS
    #include "wx/socket.h"
    #include "wx/uri.h"
#endif // wxLUA_USE_wxSocket && wxUSE_SOCKETS

// ---------------------------------------------------------------------------
// Lua Tag Method Values and Tables for each Class
// ---------------------------------------------------------------------------

#if (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL)
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxProtocol;
#endif // (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL)

#if (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL_FTP)
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxFTP;
#endif // (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL_FTP)

#if (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL_HTTP)
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxHTTP;
#endif // (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_PROTOCOL_HTTP)

#if (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_URL)
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxURL;
#endif // (wxLUA_USE_wxSocket && wxUSE_SOCKETS) && (wxUSE_URL)

#if wxLUA_USE_wxSocket && wxUSE_SOCKETS
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxIPV4address;
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxIPaddress;
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxSockAddress;
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxSocketBase;
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxSocketClient;
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxSocketEvent;
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxSocketServer;
    extern WXDLLIMPEXP_DATA_BINDWXNET(int) wxluatype_wxURI;
#endif // wxLUA_USE_wxSocket && wxUSE_SOCKETS



#endif // __HOOK_WXLUA_wxnet_H__

