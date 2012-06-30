/*
// This code from http://lua-users.org/wiki/LuaProxyDllFour
// Author : Paul Moore
// 
// This program when compiled will create a DLL that is a proxy for the 
// functions in a staticly linked lib in an exe you want a dll for. 
// In other words, given an exe, like lua.exe, that was staticly linked to
// lua51.lib you can create a proxy lua51.dll that looks and acts just as
// if you had a lua.exe that was linked to lua51.dll.
// This allows Lua's require("other_lib_linked_to_lua51.dll") 
// to work since when the other dll looks for lua51.dll they'll actually 
// load the symbols from the executable's static lib.
//
// See also : http://www.codeproject.com/Articles/16541/Create-your-Proxy-DLLs-automatically
//
// Usage :
// The file proxy_exports.h should contain a list of functions that would
// normally be exported from the dll that is now part of the staticly linked exe.
// You can use MinGW's "pexports.exe lua51.dll > proxy_exports.h" or
//           or MSVC's "dumpbin.exe /exports lua51.dll > proxy_exports.h"
// pexports.exe is here: http://sourceforge.net/projects/mingw/files/MinGW/Extension/pexports/
// The list needs to be modified to look like this, where the word SYMBOL() 
// wraps each function and the other code is removed or remmed out.
//    SYMBOL(luaL_addlstring)
//    SYMBOL(luaL_addstring)
//    SYMBOL(luaL_addvalue)
//    ...
//
// This file can be compiled using MSVC 2008 using :
// > c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat
// > cl /O2 /LD /GS- proxydll.c /link /DLL /out:lua51.dll /nodefaultlib /entry:DllMain kernel32.lib
// If a printf() statement is used below, use this to compile :
// > cl /MD /O2 /LD /GS- proxydll.c /link /DLL /out:lua51.dll /entry:DllMain kernel32.lib
//
//
// If a manifest file is desired, though it doesn't seem to be needed. 
// > mt.exe -nologo -manifest wx.manifest -outputresource:"lua51.dll;#1"
//
// Simply copy the staticly linked lua.exe with the newly created lua51.dll
// and use as if you had a dynamicly linked lua.exe to a legitimate lua51.dll library. 
// You can also copy the lua51.dll to lua5.1.dll or whatever other name you require.
// The main benefit of using the proxy lib over other methods is that you can use 
// multiple precompiled 3rd party libs that all may require differenly named lua51.dlls, 
// but they'll all work.
*/

#include <windows.h>

static struct {
    #define SYMBOL(name) FARPROC name;
    #include "proxydll_exports.h"
    #undef SYMBOL
} s_funcs;

/* Macro for defining a proxy function.
   This is a direct jump (single "jmp" assembly instruction"),
   preserving stack and return address.
   The following uses MSVC inline assembly which may not be
   portable with other compilers.
 */

#define SYMBOL(name) void __declspec(dllexport,naked) name() { __asm { jmp s_funcs.name } }
#include "proxydll_exports.h"
#undef SYMBOL

BOOL APIENTRY
DllMain(HANDLE module, DWORD reason, LPVOID reserved)
{
    HANDLE h = GetModuleHandle(NULL);
    #define SYMBOL(name) s_funcs.name = GetProcAddress(h, #name); /* printf("%p %s, %p\n", h, #name, s_funcs.name); */
    #include "proxydll_exports.h"
    #undef SYMBOL
    return TRUE;
}
