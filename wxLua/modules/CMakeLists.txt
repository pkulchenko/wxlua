# ---------------------------------------------------------------------------
# CMake build file
# ---------------------------------------------------------------------------

include(../build/CMakeFunctions.txt)

# ---------------------------------------------------------------------------
# Project name, sets ${wxLuaModules_SOURCE_DIR} and ${wxLuaModules_BINARY_DIR}

project( wxLuaModules )

set( wxLua_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../ CACHE INTERNAL "Root dir of wxLua" FORCE)

# ---------------------------------------------------------------------------
# CMake build file for wxLua Library
# ---------------------------------------------------------------------------

include_directories(${wxLua_ROOT_DIR}/
                    ${wxLua_ROOT_DIR}/modules/
                    ${wxLua_ROOT_DIR}/modules/lua/src)

# ===========================================================================
# wxLua/modules/wxbind

function (wxLua_Modules_wxBind_TARGETS)

set(wxLuaBind_SEPARATE_LIBS FALSE) # a large monolithic binding library is easier to manage

if (wxLuaBind_SEPARATE_LIBS)

# Here we make separate libs for each wxWidgets library that wxLua binds to

if (WXLUA_BINDTO_adv)

ADD_LIBRARY_FULL( wxLuaBind_adv_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxadv_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxadv_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXADV"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_adv_Lib_ wxLuaBind_adv_Lib)
else()
    set(wxLuaBind_adv_Lib_)
endif (WXLUA_BINDTO_adv)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_aui)

ADD_LIBRARY_FULL( wxLuaBind_aui_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxaui_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxaui_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXAUI"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_aui_Lib_ wxLuaBind_aui_Lib)
else()
    set(wxLuaBind_aui_Lib_)
endif (WXLUA_BINDTO_aui)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_base)

ADD_LIBRARY_FULL( wxLuaBind_base_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxbase_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxbase_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXBASE"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_base_Lib_ wxLuaBind_base_Lib)
else()
    set(wxLuaBind_base_Lib_)
endif (WXLUA_BINDTO_base)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_core)

ADD_LIBRARY_FULL( wxLuaBind_core_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxcore_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_base_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXCORE"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_core_Lib_ wxLuaBind_core_Lib)
else()
    set(wxLuaBind_core_Lib_)
endif (WXLUA_BINDTO_core)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_gl)

ADD_LIBRARY_FULL( wxLuaBind_gl_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxgl_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxgl_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXGL"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_gl_Lib_ wxLuaBind_gl_Lib)
else()
    set(wxLuaBind_gl_Lib_)
endif (WXLUA_BINDTO_gl)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_html)

ADD_LIBRARY_FULL( wxLuaBind_html_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxhtml_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxhtml_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXHTML"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_html_Lib_ wxLuaBind_html_Lib)
else()
    set(wxLuaBind_html_Lib_)
endif (WXLUA_BINDTO_html)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_media)

ADD_LIBRARY_FULL( wxLuaBind_media_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxmedia_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxmedia_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_net_Lib
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXMEDIA"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_media_Lib_ wxLuaBind_media_Lib)
else()
    set(wxLuaBind_media_Lib_)
endif (WXLUA_BINDTO_media)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_net)

ADD_LIBRARY_FULL( wxLuaBind_net_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxnet_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxnet_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXNET"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_net_Lib_ wxLuaBind_net_Lib)
else()
    set(wxLuaBind_net_Lib_)
endif (WXLUA_BINDTO_net)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_richtext)

ADD_LIBRARY_FULL( wxLuaBind_richtext_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxrichtext_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxrichtext_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXRICHTEXT"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_richtext_Lib_ wxLuaBind_richtext_Lib)
else()
    set(wxLuaBind_richtext_Lib_)
endif (WXLUA_BINDTO_richtext)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_stc)

ADD_LIBRARY_FULL( wxLuaBind_stc_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxstc_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxstc_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXSTC"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_stc_Lib_ wxLuaBind_stc_Lib)
else()
    set(wxLuaBind_stc_Lib_)
endif (WXLUA_BINDTO_stc)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_xml)

ADD_LIBRARY_FULL( wxLuaBind_xml_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxxml_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxxml_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_base_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXXML"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_xml_Lib_ wxLuaBind_xml_Lib)
else()
    set(wxLuaBind_xml_Lib_)
endif (WXLUA_BINDTO_xml)

# ---------------------------------------------------------------------------

if (WXLUA_BINDTO_xrc)

ADD_LIBRARY_FULL( wxLuaBind_xrc_Lib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/wxxrc_*.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxbind/src/wxxrc_*.cpp
        ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
    LINK_LIBRARIES
        wxLuaBind_core_Lib
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_BINDWXXRC"
    PROPERTIES FOLDER "wxLua/Modules")

    set(wxLuaBind_xrc_Lib_ wxLuaBind_xrc_Lib)
else()
    set(wxLuaBind_xrc_Lib_)
endif (WXLUA_BINDTO_xrc)

# ---------------------------------------------------------------------------

set(wxLuaBind_ALL_LIBS
    ${wxLuaBind_adv_Lib_}
    ${wxLuaBind_aui_Lib_}
    ${wxLuaBind_base_Lib_}
    ${wxLuaBind_core_Lib_}
    ${wxLuaBind_gl_Lib_}
    ${wxLuaBind_html_Lib_}
    ${wxLuaBind_media_Lib_}
    ${wxLuaBind_net_Lib_}
    ${wxLuaBind_richtext_Lib_}
    ${wxLuaBind_stc_Lib_}
    ${wxLuaBind_xml_Lib_}
    ${wxLuaBind_xrc_Lib_}
    CACHE INTERNAL "")

set(wxLuaBindLib_SOURCES
    ${wxLuaBind_adv_Lib_SOURCE_FILES}
    ${wxLuaBind_aui_Lib_SOURCE_FILES}
    ${wxLuaBind_base_Lib_SOURCE_FILES}
    ${wxLuaBind_core_Lib_SOURCE_FILES}
    ${wxLuaBind_gl_Lib_SOURCE_FILES}
    ${wxLuaBind_html_Lib_SOURCE_FILES}
    ${wxLuaBind_media_Lib_SOURCE_FILES}
    ${wxLuaBind_net_Lib_SOURCE_FILES}
    ${wxLuaBind_richtext_Lib_SOURCE_FILES}
    ${wxLuaBind_stc_Lib_SOURCE_FILES}
    ${wxLuaBind_xml_Lib_SOURCE_FILES}
    ${wxLuaBind_xrc_Lib_SOURCE_FILES})
list(REMOVE_DUPLICATES wxLuaBindLib_SOURCES)

set(wxLuaBindLib_OBJECTS
    ${wxLuaBind_adv_Lib_OBJECT_FILES}
    ${wxLuaBind_aui_Lib_OBJECT_FILES}
    ${wxLuaBind_base_Lib_OBJECT_FILES}
    ${wxLuaBind_core_Lib_OBJECT_FILES}
    ${wxLuaBind_gl_Lib_OBJECT_FILES}
    ${wxLuaBind_html_Lib_OBJECT_FILES}
    ${wxLuaBind_media_Lib_OBJECT_FILES}
    ${wxLuaBind_net_Lib_OBJECT_FILES}
    ${wxLuaBind_richtext_Lib_OBJECT_FILES}
    ${wxLuaBind_stc_Lib_OBJECT_FILES}
    ${wxLuaBind_xml_Lib_OBJECT_FILES}
    ${wxLuaBind_xrc_Lib_OBJECT_FILES})
list(REMOVE_DUPLICATES wxLuaBindLib_OBJECTS)
set_source_files_properties(${wxLuaBindLib_OBJECTS} PROPERTIES GENERATED TRUE)

#add_dependencies(wxLuaBindLib
#    wxLuaBind_adv_Lib
#    wxLuaBind_aui_Lib
#    wxLuaBind_base_Lib
#    wxLuaBind_core_Lib
#    wxLuaBind_gl_Lib
#    wxLuaBind_html_Lib
#    wxLuaBind_media_Lib
#    wxLuaBind_net_Lib
#    wxLuaBind_richtext_Lib
#    wxLuaBind_stc_Lib
#    wxLuaBind_xml_Lib
#    wxLuaBind_xrc_Lib)

else() # NOT wxLuaBind_SEPARATE_LIBS

# ---------------------------------------------------------------------------

ADD_LIBRARY_FULL( wxLuaBindLib ALLOW_MISSING_FILES
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/*.h
    SOURCES
        #${wxLua_ROOT_DIR}/modules/wxbind/src/*.cpp
        ${wxLuaBindLib_SOURCES}
        #${wxLuaBindLib_OBJECTS}
    LINK_LIBRARIES
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXBIND"
    PROPERTIES FOLDER "wxLua/Modules")

set(wxLuaBind_ALL_LIBS wxLuaBindLib CACHE INTERNAL "")

endif (wxLuaBind_SEPARATE_LIBS)

endfunction (wxLua_Modules_wxBind_TARGETS)

# ===========================================================================
# wxLua/modules/wxlua

function (wxLua_Modules_wxLua_TARGETS)

ADD_LIBRARY_FULL( wxLuaLib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlbind.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlcallb.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxldefs.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlstate.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlua.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlua_bind.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxlua/src/dummy.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/src/wxlbind.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/src/wxlcallb.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/src/wxlstate.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/src/wxlua_bind.cpp
    LINK_LIBRARIES
        LuaLib
        ${wxWidgets_LIBRARIES}
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXLUA"
    PROPERTIES FOLDER "wxLua/Modules")

endfunction (wxLua_Modules_wxLua_TARGETS)

# ---------------------------------------------------------------------------
# wxLua/modules/wxluadebug

function (wxLua_Modules_wxLuaDebug_TARGETS)

ADD_LIBRARY_FULL( wxLuaDebugLib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxluadebug/include/wxldebug.h
        ${wxLua_ROOT_DIR}/modules/wxluadebug/include/wxlstack.h
        ${wxLua_ROOT_DIR}/modules/wxluadebug/include/wxluadebugdefs.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxluadebug/src/dummy.cpp
        ${wxLua_ROOT_DIR}/modules/wxluadebug/src/wxldebug.cpp
        ${wxLua_ROOT_DIR}/modules/wxluadebug/src/wxlstack.cpp
    LINK_LIBRARIES
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXLUADEBUG"
    PROPERTIES FOLDER "wxLua/Modules")

endfunction (wxLua_Modules_wxLuaDebug_TARGETS)

# ---------------------------------------------------------------------------
# wxLua/modules/wxluasocket

function (wxLua_Modules_wxLuaSocket_TARGETS)

ADD_LIBRARY_FULL( wxLuaSocketLib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxldserv.h
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxldtarg.h
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxlsock.h
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxluasocket_bind.h
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxluasocketdefs.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxluasocket/src/dummy.cpp
        ${wxLua_ROOT_DIR}/modules/wxluasocket/src/wxldserv.cpp
        ${wxLua_ROOT_DIR}/modules/wxluasocket/src/wxldtarg.cpp
        ${wxLua_ROOT_DIR}/modules/wxluasocket/src/wxlsock.cpp
        ${wxLua_ROOT_DIR}/modules/wxluasocket/src/wxluasocket_bind.cpp
    LINK_LIBRARIES
        #wxLuaBind_core_Lib
        ${wxLuaBind_ALL_LIBS} # Only need core for wxluatype_wxWindow
        wxLuaDebugLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXLUASOCKET"
    PROPERTIES FOLDER "wxLua/Modules")

endfunction (wxLua_Modules_wxLuaSocket_TARGETS)

# ===========================================================================
# wxLua/modules/luamodule

function (wxLua_Modules_LuaModule_TARGETS)

# We build a separate shared LuaLib when building everything else static
if (BUILD_SHARED_LIBS)
    set(wxLUAMODULE_LUALIB LuaLib)
else()
    set(wxLUAMODULE_LUALIB LuaLibShared)
endif (BUILD_SHARED_LIBS)

# Build from fresh sources so we have a clean stand-alone Lua module
ADD_LIBRARY_FULL( wxLuaModule SHARED ALLOW_MISSING_FILES
    HEADERS
        ${wxLua_ROOT_DIR}/modules/luamodule/include/luamoduledefs.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/luamodule/src/luamodule.cpp
        ${wxLuaBindLib_SOURCE_FILES}
        ${wxLuaSocketLib_SOURCE_FILES}
        ${wxLuaDebugLib_SOURCE_FILES}
        ${wxLuaLib_SOURCE_FILES}
    LINK_LIBRARIES
        #wxLuaBindLib
        #wxLuaSocketLib
        #wxLuaDebugLib
        #wxLuaLib
        ${wxLUAMODULE_LUALIB}
        ${wxWidgets_LIBRARIES}
    PROPERTIES OUTPUT_NAME   "wx"
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_LUAMODULE"
    PROPERTIES FOLDER "wxLua/Modules")

# When we link to the static wxWidgets lib ignore warnings about not exporting the wx symbols.
if (MSVC)
    add_definitions( /wd4251 ) # warning C4251: 'wxLuaSocketBase::m_name' : class 'wxString' needs to have dll-interface to be used by clients of class 'wxLuaSocketBase'
    add_definitions( /wd4275 ) # warning C4275: non dll-interface class 'wxObject' used as base for dll-interface class 'wxLuaSocketBase'
endif()


if (BUILD_SHARED_LIBS)
    SET_TARGET_PROPERTIES(wxLuaModule
        PROPERTIES COMPILE_DEFINITIONS "WXMAKINGDLL_WXLUA;WXMAKINGDLL_WXLUASOCKET;WXMAKINGDLL_WXLUADEBUG;WXMAKINGDLL_WXBIND")
endif()

endfunction (wxLua_Modules_LuaModule_TARGETS)

# ===========================================================================
# wxLua/modules/lua

function (wxLua_Modules_Lua_TARGETS)

if (MSVC)
    set( LUA_BUILD_AS_DLL PROPERTIES DEFINE_SYMBOL LUA_BUILD_AS_DLL )

    add_definitions( -D_CRT_SECURE_NO_WARNINGS )
elseif (APPLE)
    set( LUA_BUILD_AS_DLL )
    add_definitions( -DLUA_USE_LINUX )

    set(LUA_LINK_LIBRARIES m readline)

    #$(MAKE) all MYCFLAGS="-DLUA_USE_LINUX" MYLIBS="-lreadline"
else () # UNIX
    set( LUA_BUILD_AS_DLL )
    add_definitions( -DLUA_USE_LINUX )

    set(LUA_LINK_LIBRARIES m dl readline history ncurses)

    #$(MAKE) all MYCFLAGS="-DLUA_USE_LINUX -fPIC" MYLIBS="-fPIC -Wl,-E -ldl -lreadline -lhistory -lncurses"
endif()

# ---------------------------------------------------------------------------

ADD_LIBRARY_FULL( LuaLib
    HEADERS
        src/*.h
    SOURCES
        src/lapi.c
        src/lcode.c
        src/ldebug.c
        src/ldo.c
        src/ldump.c
        src/lfunc.c
        src/lgc.c
        src/llex.c
        src/lmem.c
        src/lobject.c
        src/lopcodes.c
        src/lparser.c
        src/lstate.c
        src/lstring.c
        src/ltable.c
        src/ltm.c
        src/lundump.c
        src/lvm.c
        src/lzio.c
        src/lauxlib.c
        src/lbaselib.c
        src/ldblib.c
        src/liolib.c
        src/lmathlib.c
        src/loslib.c
        src/ltablib.c
        src/lstrlib.c
        src/loadlib.c
        src/linit.c
    LINK_LIBRARIES
    ${LUA_BUILD_AS_DLL}
    PROPERTIES FOLDER "wxLua/Modules")

# ---------------------------------------------------------------------------

if (MSVC60)
    # Some sort of bug linking to the object files in MSVC6
    # the full path is in the .dsp file, but MSVC errors on ./lapi.obj
    # so somehow the path is stripped off.
    set(LUAC_SOURCES ${LuaLib_SOURCE_FILES})
else()
    # we can reuse the object files since we cannot link to the LuaLib DLL
    # since the LUAI_FUNC Lua functions are not exported.
    set(LuaLib_OBJECTS ${LuaLib_OBJECT_FILES})
    set_source_files_properties(${LuaLib_OBJECTS} PROPERTIES GENERATED TRUE)
    set(LUAC_SOURCES ${LuaLib_OBJECTS})
endif()

ADD_EXECUTABLE_FULL( luac ALLOW_MISSING_FILES
    HEADERS ""
    SOURCES
        src/luac.c
        src/print.c
        #${LuaLib_SOURCE_FILES} # alternatively we could simply recompile these
        #${LuaLib_OBJECTS}      # see note above about DLL linking
        ${LUAC_SOURCES}
    LINK_LIBRARIES
        # LuaLib                # see note above about DLL linking
        ${LUA_LINK_LIBRARIES}
    PROPERTIES FOLDER "wxLua/apps")

add_dependencies(luac LuaLib)

# ---------------------------------------------------------------------------

ADD_EXECUTABLE_FULL( lua
    HEADERS
    SOURCES
        src/lua.c
    LINK_LIBRARIES
        LuaLib
        ${LUA_LINK_LIBRARIES}
    PROPERTIES FOLDER "wxLua/apps")

# ---------------------------------------------------------------------------

# The wxLua Lua module always links to a shared LuaLib
if (BUILD_SHARED_LIBS)
    # CMake has problems with "ON/OFF" being used as booleans, even though its the one who changes them from TRUE/FALSE
else()

ADD_LIBRARY_FULL( LuaLibShared SHARED
    HEADERS
        src/*.h
    SOURCES
        src/lapi.c
        src/lcode.c
        src/ldebug.c
        src/ldo.c
        src/ldump.c
        src/lfunc.c
        src/lgc.c
        src/llex.c
        src/lmem.c
        src/lobject.c
        src/lopcodes.c
        src/lparser.c
        src/lstate.c
        src/lstring.c
        src/ltable.c
        src/ltm.c
        src/lundump.c
        src/lvm.c
        src/lzio.c
        src/lauxlib.c
        src/lbaselib.c
        src/ldblib.c
        src/liolib.c
        src/lmathlib.c
        src/loslib.c
        src/ltablib.c
        src/lstrlib.c
        src/loadlib.c
        src/linit.c
    LINK_LIBRARIES
    ${LUA_BUILD_AS_DLL}
    PROPERTIES FOLDER "wxLua/Modules")

ADD_EXECUTABLE_FULL( lua_shared
    HEADERS
    SOURCES
        src/lua.c
    LINK_LIBRARIES
        LuaLibShared
        ${LUA_LINK_LIBRARIES}
    PROPERTIES FOLDER "wxLua/apps")

endif (BUILD_SHARED_LIBS)

endfunction (wxLua_Modules_Lua_TARGETS)

# ===========================================================================

add_subdirectory( lua )
add_subdirectory( luamodule )
add_subdirectory( wxbind )
add_subdirectory( wxlua )
add_subdirectory( wxluadebug )
add_subdirectory( wxluasocket )
