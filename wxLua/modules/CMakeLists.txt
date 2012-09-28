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

include_directories("${wxLua_ROOT_DIR}/"
                    "${wxLua_ROOT_DIR}/modules/"
                    "${wxLua_LUA_INCLUDE_DIR}")

# ===========================================================================
# wxLua/modules/lua

function (wxLua_Modules_Lua_TARGETS)

if (TARGET LuaLib)
    # The Lua libs are imported and have to be declared in the root CMakeLists.txt
    return()
endif()

set( LUA_DLL_PROPERTIES ) # target properties for Lua built as a DLL
set( LUA_EXE_PROPERTIES ) # target properties for Lua exe
set( LUA_LINK_LIBRARIES ) # libaries to link Lua exe to

if (MSVC)
    set( LUA_DLL_PROPERTIES PROPERTIES DEFINE_SYMBOL LUA_BUILD_AS_DLL )
    add_definitions( -D_CRT_SECURE_NO_WARNINGS )

    # NOTE! We always export the Lua functions to allow the EXEs to be treated as DLLs.
    # We use modules/luaproxydll as the lua51.dll, but the functions are in the executables.
    add_definitions( -DLUA_BUILD_AS_DLL )
    set(LUA_EXE_PROPERTIES PROPERTIES COMPILE_DEFINITIONS "LUA_CORE")

elseif (APPLE)
    #$(MAKE) all MYCFLAGS="-DLUA_USE_LINUX" MYLIBS="-lreadline"

    add_definitions( -DLUA_USE_LINUX )
    set(LUA_LINK_LIBRARIES m readline)

elseif ("${CMAKE_GENERATOR}" MATCHES "MinGW Makefiles")

    set(LUA_LINK_LIBRARIES m)

else () # UNIX
    #$(MAKE) all MYCFLAGS="-DLUA_USE_LINUX -fPIC" MYLIBS="-fPIC -Wl,-E -ldl -lreadline -lhistory -lncurses"

    add_definitions( -DLUA_USE_LINUX )
    set(LUA_LINK_LIBRARIES m dl readline history ncurses)

endif()

# ---------------------------------------------------------------------------

set( LuaLib_ADD_LIBRARY_FULL_FILES
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
        src/linit.c )

# ---------------------------------------------------------------------------



ADD_LIBRARY_FULL( LuaLib ${wxLua_LUA_LIBRARY_BUILD_SHARED_FLAG}
    HEADERS
        src/*.h
    SOURCES
        ${LuaLib_ADD_LIBRARY_FULL_FILES}
    LINK_LIBRARIES
        ${LUA_LINK_LIBRARIES}
    ${LUA_DLL_PROPERTIES}
    PROPERTIES LINKER_LANGUAGE C
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    WXLIKE_LIBRARY_NAMES( LuaLib wxlua_lua51 "${wxLua_VERSION}")

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
    PROPERTIES LINKER_LANGUAGE C
    PROPERTIES FOLDER "wxLua/apps"
    INSTALL ${WXLUA_APP_INSTALL_FLAGS})

add_dependencies(luac LuaLib)

# ---------------------------------------------------------------------------

ADD_EXECUTABLE_FULL( lua
    HEADERS
    SOURCES
        src/lua.c
    LINK_LIBRARIES
        LuaLib
        ${LUA_LINK_LIBRARIES}
    ${LUA_EXE_PROPERTIES}
    PROPERTIES LINKER_LANGUAGE C
    PROPERTIES FOLDER "wxLua/apps"
    INSTALL ${WXLUA_APP_INSTALL_FLAGS})

# ---------------------------------------------------------------------------
# The wxLua Lua module always links to a shared LuaLib even when using luaproxydll.

if (BUILD_SHARED_LIBS OR wxLua_LUA_LIBRARY_BUILD_SHARED)
    set(LuaLibShared_export_name)
else()
    set(LuaLibShared_export_name LuaLibShared)

    ADD_LIBRARY_FULL( LuaLibShared SHARED
        HEADERS
            src/*.h
        SOURCES
            ${LuaLib_ADD_LIBRARY_FULL_FILES}
        LINK_LIBRARIES
            ${LUA_LINK_LIBRARIES}
        ${LUA_DLL_PROPERTIES}
        PROPERTIES LINKER_LANGUAGE C
        PROPERTIES FOLDER "wxLua/Modules")
        #INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    if (WIN32)
        set_target_properties(LuaLibShared PROPERTIES OUTPUT_NAME lua51)
        # Want these in subdir, note that RUNTIME_OUTPUT_DIRECTORY_<CONFIG> is ignored for some reason.
        #set_target_properties(LuaLibShared PROPERTIES PREFIX "shared/")
    else()
        WXLIKE_LIBRARY_NAMES( LuaLibShared wxlua_lua51 "${wxLua_VERSION}")
    endif()

    set_target_properties(LuaLibShared PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin-shared)
    set_target_properties(LuaLibShared PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin-shared)
    set_target_properties(LuaLibShared PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin-shared)

    ADD_EXECUTABLE_FULL( lua51-shared
        HEADERS
        SOURCES
            src/lua.c
        LINK_LIBRARIES
            LuaLibShared
            ${LUA_LINK_LIBRARIES}
        PROPERTIES LINKER_LANGUAGE C
        PROPERTIES FOLDER "wxLua/apps")

    set_target_properties(lua51-shared PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin-shared)
    set_target_properties(lua51-shared PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin-shared)
    set_target_properties(lua51-shared PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin-shared)

endif (BUILD_SHARED_LIBS OR wxLua_LUA_LIBRARY_BUILD_SHARED)

endfunction (wxLua_Modules_Lua_TARGETS)

# ===========================================================================
# wxLua/modules/wxlua

function (wxLua_Modules_wxLua_TARGETS)

ADD_LIBRARY_FULL( wxLuaLib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxlua/atomic.h
        ${wxLua_ROOT_DIR}/modules/wxlua/sharedptr.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlbind.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlcallb.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlconsole.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxldefs.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlobject.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlstate.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlua.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlua_bind.h
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlversion.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxlua/dummy.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/lbitlib.c
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlbind.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlcallb.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlconsole.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlobject.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlstate.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/wxlua_bind.cpp
    LINK_LIBRARIES
        LuaLib
        ${wxWidgets_LIBRARIES}
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXLUA"
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    WXLIKE_LIBRARY_NAMES( wxLuaLib wxlua "${wxLua_VERSION}")

endfunction (wxLua_Modules_wxLua_TARGETS)

# ---------------------------------------------------------------------------
# wxLua/modules/wxluadebug

function (wxLua_Modules_wxLua_Debug_TARGETS)

ADD_LIBRARY_FULL( wxLuaDebugLib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/wxldebug.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/wxlstack.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/wxluadebugdefs.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/dummy.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/wxldebug.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/wxlstack.cpp
    LINK_LIBRARIES
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXLUADEBUG"
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    WXLIKE_LIBRARY_NAMES( wxLuaDebugLib wxlua_debug "${wxLua_VERSION}")

endfunction (wxLua_Modules_wxLua_Debug_TARGETS)

# ---------------------------------------------------------------------------
# wxLua/modules/wxlua/debugger

function (wxLua_Modules_wxLua_Debugger_TARGETS)

ADD_LIBRARY_FULL( wxLuaDebuggerLib
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxldserv.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxldtarg.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxlsock.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxluadebugger_bind.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxluadebuggerdefs.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/dummy.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxldserv.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxldtarg.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxlsock.cpp
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxluadebugger_bind.cpp
    LINK_LIBRARIES
        #wxLuaBind_core_Lib
        ${wxLuaBind_ALL_LIBS} # Only need core for wxluatype_wxWindow
        wxLuaDebugLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXLUADEBUGGER"
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    WXLIKE_LIBRARY_NAMES( wxLuaDebuggerLib wxlua_debugger "${wxLua_VERSION}")

endfunction (wxLua_Modules_wxLua_Debugger_TARGETS)

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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_adv_Lib wxlua_bind_adv "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_aui_Lib wxlua_bind_aui "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_base_Lib wxlua_bind_base "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_aui_core wxluabind_core "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_gl_Lib wxlua_bind_gl "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_html_Lib wxlua_bind_html "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_media_Lib wxlua_bind_media "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_net_Lib wxlua_bind_net "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_richtext_Lib wxlua_bind_richtext "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_stc_Lib wxlua_bind_stc "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_xml_Lib wxlua_bind_xml "${wxLua_VERSION}")
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

    WXLIKE_LIBRARY_NAMES( wxLuaBind_xrc_Lib wxlua_bind_xrc "${wxLua_VERSION}")
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
        ${wxLuaBindLib_SOURCES} # set in root CMakeLists.txt when parsing wxLuaBind_COMPONENTS
        #${wxLuaBindLib_OBJECTS}
    LINK_LIBRARIES
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXBIND"
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    WXLIKE_LIBRARY_NAMES( wxLuaBindLib wxlua_bind "${wxLua_VERSION}")
    set(wxLuaBind_ALL_LIBS wxLuaBindLib CACHE INTERNAL "")

endif (wxLuaBind_SEPARATE_LIBS)

endfunction (wxLua_Modules_wxBind_TARGETS)

# ===========================================================================
# wxLua/modules/luamodule

function (wxLua_Modules_LuaModule_TARGETS)

# We build a separate shared LuaLib when building everything else static
# Note : A MSW static build needs this shared lua51.dll to build, but
#        when executing we use the luaproxydll.
if (BUILD_SHARED_LIBS)
    set(wxLUAMODULE_LUALIB LuaLib)
else()
    set(wxLUAMODULE_LUALIB LuaLibShared)
endif (BUILD_SHARED_LIBS)

# Build from fresh sources so we have a clean stand-alone Lua module and
# we get all the exports right.
ADD_LIBRARY_FULL( wxLuaModule SHARED # ALLOW_MISSING_FILES
    HEADERS
        ${wxLua_ROOT_DIR}/modules/luamodule/luamoduledefs.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/luamodule/luamodule.cpp
        ${wxLua_ROOT_DIR}/modules/luamodule/luamodule.rc
        ${wxLuaBindLib_SOURCE_FILES}
        ${wxLuaDebuggerLib_SOURCE_FILES}
        ${wxLuaDebugLib_SOURCE_FILES}
        ${wxLuaLib_SOURCE_FILES}
    LINK_LIBRARIES
        #wxLuaBindLib
        #wxLuaDebuggerLib
        #wxLuaDebugLib
        #wxLuaLib
        ${wxLUAMODULE_LUALIB}
        ${wxWidgets_LIBRARIES}
    PROPERTIES OUTPUT_NAME   "wx"
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_LUAMODULE"
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS_NO_EXPORT}")

# When we link to the static wxWidgets lib ignore warnings about not exporting the wx symbols
# since we don't want to export them.
if (MSVC)
    add_definitions( /wd4251 ) # warning C4251: 'wxLuaSocketBase::m_name' : class 'wxString' needs to have dll-interface to be used by clients of class 'wxLuaSocketBase'
    add_definitions( /wd4275 ) # warning C4275: non dll-interface class 'wxObject' used as base for dll-interface class 'wxLuaSocketBase'
endif()

if (BUILD_SHARED_LIBS)
    SET_TARGET_PROPERTIES(wxLuaModule
        PROPERTIES COMPILE_DEFINITIONS "WXMAKINGDLL_WXLUA;WXMAKINGDLL_WXLUADEBUGGER;WXMAKINGDLL_WXLUADEBUG;WXMAKINGDLL_WXBIND")
endif()

endfunction (wxLua_Modules_LuaModule_TARGETS)

# ===========================================================================

add_subdirectory( lua )
add_subdirectory( wxbind )
add_subdirectory( wxlua )
add_subdirectory( wxlua/debug )
add_subdirectory( wxlua/debugger )
add_subdirectory( luamodule ) # include after everything else to get source file list
