# ---------------------------------------------------------------------------
# CMake build file
# ---------------------------------------------------------------------------

include(../build/CMakeFunctions.txt)

# ---------------------------------------------------------------------------
# Project name, sets ${wxLuaModules_SOURCE_DIR} and ${wxLuaModules_BINARY_DIR}

project( wxLuaModules )

if (NOT DEFINED wxLua_ROOT_DIR)
    set(wxLua_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../ CACHE INTERNAL 
        "Root dir of wxLua" FORCE)
endif()

# ---------------------------------------------------------------------------
# CMake build file for wxLua Library
# ---------------------------------------------------------------------------

include_directories("${wxLua_ROOT_DIR}/"
                    "${wxLua_ROOT_DIR}/modules/"
                    "${wxLua_LUA_INCLUDE_DIR}")

# ===========================================================================
# wxLua/modules/lua
# ===========================================================================

function (wxLua_Modules_Lua_TARGETS)

if (TARGET LuaLib)
    # The Lua libs are imported and have been declared already in the root CMakeLists.txt
    return()
endif()

set( LUA_DLL_PROPERTIES ) # target properties for Lua built as a DLL
set( LUA_EXE_PROPERTIES ) # target properties for Lua exe
set( LUA_LINK_LIBRARIES ) # libaries to link Lua exe to

if (MSVC)

    # NOTE! We always export the Lua functions to allow the EXEs to be treated as DLLs.
    # We use modules/luaproxydll as the lua.dll, but the functions are in the executable.
    set( LUA_DLL_PROPERTIES PROPERTIES DEFINE_SYMBOL LUA_BUILD_AS_DLL )
    add_definitions( -DLUA_BUILD_AS_DLL )
    set(LUA_EXE_PROPERTIES PROPERTIES COMPILE_DEFINITIONS "LUA_CORE")

    add_definitions( -D_CRT_SECURE_NO_WARNINGS )

elseif ("${CMAKE_GENERATOR}" MATCHES "MinGW Makefiles")

    # NOTE! We always export the Lua functions to allow the EXEs to be treated as DLLs.
    # We use modules/luaproxydll as the lua.dll, but the functions are in the executable.
    set(LUA_DLL_PROPERTIES PROPERTIES DEFINE_SYMBOL LUA_BUILD_AS_DLL )
    add_definitions( -DLUA_BUILD_AS_DLL )
    set(LUA_EXE_PROPERTIES PROPERTIES COMPILE_DEFINITIONS "LUA_CORE")

    set(LUA_LINK_LIBRARIES m)

elseif (APPLE)
    # Lua 5.1 Makefile : $(MAKE) all MYCFLAGS="-DLUA_USE_LINUX" MYLIBS="-lreadline"
    # Lua 5.2 Makefile : $(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_MACOSX" SYSLIBS="-lreadline"

    if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.2)
        add_definitions( -DLUA_USE_MACOSX ) # is the same as LUA_USE_LINUX in 5.2.2 (at least)
    else()
        add_definitions( -DLUA_USE_LINUX ) # adds readline so which make the lua exe a little nicer.
    endif()

    set(LUA_LINK_LIBRARIES m readline)

else () # UNIX
    # Lua 5.1 Makefile : $(MAKE) all MYCFLAGS="-DLUA_USE_LINUX -fPIC" MYLIBS="-fPIC -Wl,-E -ldl -lreadline -lhistory -lncurses"
    # Lua 5.2 Makefile : $(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_LINUX" SYSLIBS="-Wl,-E -ldl -lreadline"
    #                    CFLAGS= -O2 -Wall -DLUA_COMPAT_ALL $(SYSCFLAGS) $(MYCFLAGS)
    #                    LDFLAGS= $(SYSLDFLAGS) $(MYLDFLAGS)

    add_definitions( -DLUA_USE_LINUX )
    set(LUA_LINK_LIBRARIES m dl readline history ncurses)

endif()

# ---------------------------------------------------------------------------

set( LuaLib_ADD_LIBRARY_FULL_FILES_51
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

set( LuaLib_ADD_LIBRARY_FULL_FILES_52
        src/lapi.c
        src/lcode.c
        src/lctype.c
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
        src/lbitlib.c
        src/lcorolib.c
        src/ldblib.c
        src/liolib.c
        src/lmathlib.c
        src/loslib.c
        src/ltablib.c
        src/lstrlib.c
        src/ltablib.c
        src/loadlib.c
        src/linit.c )

# ---------------------------------------------------------------------------

set(wxLua_LuaLib_NAME       "wxlua_lua${wxLua_LUA_LIBRARY_VERSION_NUM}") # e.g. wxlua_lua52
set(wxLua_LuaLibShared_NAME "lua${wxLua_LUA_LIBRARY_VERSION_NUM}")       # e.g. lua52

ADD_LIBRARY_FULL( LuaLib ${wxLua_LUA_LIBRARY_BUILD_SHARED_FLAG}
    HEADERS
        src/*.h
    SOURCES
        ${LuaLib_ADD_LIBRARY_FULL_FILES_${wxLua_LUA_LIBRARY_VERSION_NUM}}
    LINK_LIBRARIES
        ${LUA_LINK_LIBRARIES}
    ${LUA_DLL_PROPERTIES}
    PROPERTIES LINKER_LANGUAGE C
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

if (WIN32 AND wxLua_LUA_LIBRARY_BUILD_SHARED)
    # If we're building a DLL in MSW name it lua51.dll and we don't need the proxydll.
    set_target_properties(LuaLib PROPERTIES OUTPUT_NAME ${wxLua_LuaLibShared_NAME})
else()
    # It's a static lib or on Unix, give it an explicit name to avoid conflicts/confusion.
    # On Unix they can simply create symbolic links to give it whatever name they want.
    WXLIKE_LIBRARY_NAMES( LuaLib ${wxLua_LuaLib_NAME} "${wxLua_VERSION}")
endif()

# ---------------------------------------------------------------------------

if (MSVC60)
    # Some sort of bug linking to the object files in MSVC6
    # the full path is in the .dsp file, but MSVC errors on ./lapi.obj
    # so somehow the path is stripped off.
    set(LUAC_SOURCES ${LuaLib_SOURCE_FILES})
else()
    # Reuse the object files since we cannot link to the LuaLib DLL
    # because the LUAI_FUNC Lua functions are not exported.
    set(LuaLib_OBJECTS ${LuaLib_OBJECT_FILES})
    set_source_files_properties(${LuaLib_OBJECTS} PROPERTIES GENERATED TRUE)
    set(LUAC_SOURCES ${LuaLib_OBJECTS})
endif()

if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.1)
    set( luac_EXTRA_SOURCES "src/print.c" )
endif()

ADD_EXECUTABLE_FULL( luac ALLOW_MISSING_FILES
    HEADERS ""
    SOURCES
        src/luac.c
        ${luac_EXTRA_SOURCES}
        #${LuaLib_SOURCE_FILES} # alternatively we could simply recompile these
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
        "${wxLua_ROOT_DIR}/modules/lua-5.2/lua.rc"
    LINK_LIBRARIES
        LuaLib
        ${LUA_LINK_LIBRARIES}
    ${LUA_EXE_PROPERTIES}
    PROPERTIES LINKER_LANGUAGE C
    PROPERTIES FOLDER "wxLua/apps"
    INSTALL ${WXLUA_APP_INSTALL_FLAGS})

# ---------------------------------------------------------------------------
# The wxLua Lua module always links to a shared LuaLib even when using luaproxydll.
# We need to build a shared version no matter what.

if (wxLua_LUA_LIBRARY_BUILD_SHARED)
    set(LuaLibShared_TARGET_NAME LuaLib       CACHE INTERNAL "")
else()
    set(LuaLibShared_TARGET_NAME LuaLibShared CACHE INTERNAL "")

    ADD_LIBRARY_FULL( LuaLibShared SHARED
        HEADERS
            src/*.h
        SOURCES
            ${LuaLib_ADD_LIBRARY_FULL_FILES_${wxLua_LUA_LIBRARY_VERSION_NUM}}
        LINK_LIBRARIES
            ${LUA_LINK_LIBRARIES}
        ${LUA_DLL_PROPERTIES}
        PROPERTIES LINKER_LANGUAGE C
        PROPERTIES FOLDER "wxLua/Modules")
        #INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    if (WIN32)
        set_target_properties(LuaLibShared PROPERTIES OUTPUT_NAME ${wxLua_LuaLibShared_NAME})

        # Don't let CMake prepend "lib" on lua.dll with MingW
        if ("${CMAKE_GENERATOR}" MATCHES "MinGW Makefiles")
            set_target_properties(LuaLibShared PROPERTIES PREFIX "")
        endif()
    else()
        # They can make symbolic links to call it whatever they want
        WXLIKE_LIBRARY_NAMES( LuaLibShared ${wxLua_LuaLib_NAME} "${wxLua_VERSION}")
    endif()

    set(WXLUA_BINSHARED_DIR "${CMAKE_BINARY_DIR}/bin-shared")
    if (NOT MSVC)
        set(WXLUA_BINSHARED_DIR "${CMAKE_BINARY_DIR}/bin-shared/${CMAKE_BUILD_TYPE}")
    endif()

    set_target_properties(LuaLibShared PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${WXLUA_BINSHARED_DIR})
    set_target_properties(LuaLibShared PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${WXLUA_BINSHARED_DIR})
    set_target_properties(LuaLibShared PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${WXLUA_BINSHARED_DIR})

    ADD_EXECUTABLE_FULL( lua-shared
        HEADERS
        SOURCES
            src/lua.c
            "${wxLua_ROOT_DIR}/modules/lua-5.2/lua.rc"
        LINK_LIBRARIES
            LuaLibShared
            ${LUA_LINK_LIBRARIES}
        PROPERTIES LINKER_LANGUAGE C
        PROPERTIES FOLDER "wxLua/apps"
        PROPERTIES OUTPUT_NAME lua)

    set_target_properties(lua-shared PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${WXLUA_BINSHARED_DIR})
    set_target_properties(lua-shared PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${WXLUA_BINSHARED_DIR})
    set_target_properties(lua-shared PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${WXLUA_BINSHARED_DIR})

endif (wxLua_LUA_LIBRARY_BUILD_SHARED)

endfunction (wxLua_Modules_Lua_TARGETS)

# ===========================================================================
# wxLua/modules/wxlua
# ===========================================================================

function (wxLua_Modules_wxLua_TARGETS)

set( WXLUALIB_PROPERTIES_DEFINE_SYMBOL )
if ( BUILD_SHARED_LIBS_WIN_DLLS )
    set( WXLUALIB_PROPERTIES_DEFINE_SYMBOL PROPERTIES DEFINE_SYMBOL WXMAKINGDLL_WXLUA)
endif()

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
    ${WXLUALIB_PROPERTIES_DEFINE_SYMBOL}
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    WXLIKE_LIBRARY_NAMES( wxLuaLib wxlua "${wxLua_VERSION}")

endfunction (wxLua_Modules_wxLua_TARGETS)

# ===========================================================================
# wxLua/modules/wxlua/debug
# ===========================================================================

function (wxLua_Modules_wxLua_Debug_TARGETS)

set( WXLUALIB_PROPERTIES_DEFINE_SYMBOL )
if ( BUILD_SHARED_LIBS_WIN_DLLS )
    set( WXLUALIB_PROPERTIES_DEFINE_SYMBOL PROPERTIES DEFINE_SYMBOL WXMAKINGDLL_WXLUADEBUG)
endif()

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
    ${WXLUALIB_PROPERTIES_DEFINE_SYMBOL}
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    WXLIKE_LIBRARY_NAMES( wxLuaDebugLib wxlua_debug "${wxLua_VERSION}")

endfunction (wxLua_Modules_wxLua_Debug_TARGETS)

# ===========================================================================
# wxLua/modules/wxlua/debugger
# ===========================================================================

function (wxLua_Modules_wxLua_Debugger_TARGETS)

set( WXLUADEBUGGER_PROPERTIES_DEFINE_SYMBOL )
if ( BUILD_SHARED_LIBS_WIN_DLLS )
    set( WXLUADEBUGGER_PROPERTIES_DEFINE_SYMBOL PROPERTIES DEFINE_SYMBOL WXMAKINGDLL_WXLUADEBUGGER)
endif()

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
    ${WXLUADEBUGGER_PROPERTIES_DEFINE_SYMBOL}
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    WXLIKE_LIBRARY_NAMES( wxLuaDebuggerLib wxlua_debugger "${wxLua_VERSION}")

endfunction (wxLua_Modules_wxLua_Debugger_TARGETS)

# ===========================================================================
# wxLua/modules/wxbind
# ===========================================================================

# Call ADD_LIBRARY_FULL for the given wxLuaBind_COMPONENTS library name.
macro (ADD_LIBRARY_FULL_wxLuaBind name link_libraries)
    if (WXLUA_BINDTO_${name})
        string(TOUPPER ${name} _NAME)

        set( WXLUABIND_${_NAME}_PROPERTIES_DEFINE_SYMBOL )
        if ( BUILD_SHARED_LIBS_WIN_DLLS )
            set( WXLUABIND_${_NAME}_PROPERTIES_DEFINE_SYMBOL PROPERTIES DEFINE_SYMBOL WXMAKINGDLL_BINDWX${_NAME})
        endif()

        ADD_LIBRARY_FULL( wxLuaBind_${name}_Lib
            HEADERS
                ${wxLua_ROOT_DIR}/modules/wxbind/include/wx${name}_*.h
            SOURCES
                ${wxLua_ROOT_DIR}/modules/wxbind/src/wx${name}_*.cpp
                ${wxLua_ROOT_DIR}/modules/wxbind/src/dummy.cpp
            LINK_LIBRARIES
                ${link_libraries}
            ${WXLUABIND_${_NAME}_PROPERTIES_DEFINE_SYMBOL}
            PROPERTIES FOLDER "wxLua/Modules"
            INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

            WXLIKE_LIBRARY_NAMES( wxLuaBind_${name}_Lib wxlua_bind_${name} "${wxLua_VERSION}")
            set(wxLuaBind_${name}_Lib_ wxLuaBind_${name}_Lib)

        # Silence the deprecated warnings since there isn't much we can do about them.
        if (MSVC)
            set_property(TARGET wxLuaBind_${name}_Lib APPEND PROPERTY COMPILE_FLAGS "/wd4996")
        elseif (CMAKE_COMPILER_IS_GNUCXX)
            set_property(TARGET wxLuaBind_${name}_Lib APPEND PROPERTY COMPILE_FLAGS "-Wno-deprecated-declarations")
        endif()
    else()
        set(wxLuaBind_${name}_Lib_)
    endif (WXLUA_BINDTO_${name})
endmacro()

function (wxLua_Modules_wxBind_TARGETS)

# A large monolithic binding library is easier to manage,
# but the bindings libs can be built separately, one for each wxLuaBind_COMPONENTS.
set(wxLuaBind_SEPARATE_LIBS FALSE) 

if (wxLuaBind_SEPARATE_LIBS)

# Here we make separate libs for each wxWidgets library that wxLua binds to

ADD_LIBRARY_wxLuaBind(adv       "wxLuaBind_core_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(aui       "wxLuaBind_core_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(base      "wxLuaLib")
ADD_LIBRARY_wxLuaBind(core      "wxLuaBind_base_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(gl        "wxLuaBind_core_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(html      "wxLuaBind_core_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(media     "wxLuaBind_net_Lib;wxLuaBind_core_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(net       "wxLuaBind_core_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(richtext  "wxLuaBind_core_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(stc       "wxLuaBind_core_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(xml       "wxLuaBind_base_Lib;wxLuaLib")
ADD_LIBRARY_wxLuaBind(xrc       "wxLuaBind_core_Lib;wxLuaLib")

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
    ${wxLuaBind_xrc_Lib_SOURCE_FILES} CACHE INTERNAL "")
list(REMOVE_DUPLICATES wxLuaBindLib_SOURCES)
set(wxLuaBindLib_SOURCES ${wxLuaBindLib_SOURCES} CACHE INTERNAL "")

# ---------------------------------------------------------------------------
else() # NOT wxLuaBind_SEPARATE_LIBS


ADD_LIBRARY_FULL( wxLuaBindLib ALLOW_MISSING_FILES
    HEADERS
        ${wxLua_ROOT_DIR}/modules/wxbind/include/*.h
    SOURCES
        #${wxLua_ROOT_DIR}/modules/wxbind/src/*.cpp
        ${wxLuaBindLib_SOURCES} # set in root CMakeLists.txt when parsing wxLuaBind_COMPONENTS
                                # or when creating separate binding libs above.
    LINK_LIBRARIES
        wxLuaLib
    PROPERTIES DEFINE_SYMBOL "WXMAKINGDLL_WXBIND"
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS}")

    # Replace them with the fully specified path and filenames.
    set(wxLuaBindLib_SOURCES ${wxLuaBindLib_SOURCE_FILES} CACHE INTERNAL "")

    WXLIKE_LIBRARY_NAMES( wxLuaBindLib wxlua_bind "${wxLua_VERSION}")
    set(wxLuaBind_ALL_LIBS wxLuaBindLib CACHE INTERNAL "")

    # Silence the deprecated warnings since there isn't much we can do about them.
    if (MSVC)
        set_property(TARGET wxLuaBindLib APPEND PROPERTY COMPILE_FLAGS "/wd4996")
    elseif (CMAKE_COMPILER_IS_GNUCXX)
        set_property(TARGET wxLuaBindLib APPEND PROPERTY COMPILE_FLAGS "-Wno-deprecated-declarations")
    endif()

endif (wxLuaBind_SEPARATE_LIBS)

endfunction (wxLua_Modules_wxBind_TARGETS)

# ===========================================================================
# wxLua/modules/luamodule
# ===========================================================================

function (wxLua_Modules_LuaModule_TARGETS)

# This is always built as a DLL
set( WXLUAMODULE_PROPERTIES_DEFINE_SYMBOL PROPERTIES DEFINE_SYMBOL WXMAKINGDLL_LUAMODULE)

# Build from fresh sources so we have a clean stand-alone Lua module and
# we get all the DLL exports right.
ADD_LIBRARY_FULL( wxLuaModule SHARED # ALLOW_MISSING_FILES
    HEADERS
        ${wxLua_ROOT_DIR}/modules/luamodule/luamoduledefs.h
    SOURCES
        ${wxLua_ROOT_DIR}/modules/luamodule/luamodule.cpp
        ${wxLua_ROOT_DIR}/modules/luamodule/luamodule.rc
        ${wxLuaBindLib_SOURCES}
        ${wxLuaDebuggerLib_SOURCE_FILES}
        ${wxLuaDebugLib_SOURCE_FILES}
        ${wxLuaLib_SOURCE_FILES}
    LINK_LIBRARIES
        #wxLuaBindLib
        #wxLuaDebuggerLib
        #wxLuaDebugLib
        #wxLuaLib
        ${LuaLibShared_TARGET_NAME} # either target LuaLib or LuaLibShared (always a shared lib)
        ${wxWidgets_LIBRARIES}
    PROPERTIES OUTPUT_NAME   "wx"
    ${WXLUAMODULE_PROPERTIES_DEFINE_SYMBOL}
    PROPERTIES FOLDER "wxLua/Modules"
    INSTALL "${WXLUA_LIB_INSTALL_FLAGS_NO_EXPORT}")

    # Silence the deprecated warnings since there isn't much we can do about them.
    if (MSVC)
        set_property(TARGET wxLuaModule APPEND PROPERTY COMPILE_FLAGS "/wd4996")
    elseif (CMAKE_COMPILER_IS_GNUCXX)
        set_property(TARGET wxLuaModule APPEND PROPERTY COMPILE_FLAGS "-Wno-deprecated-declarations")
    endif()

# Don't let CMake prepend "lib" on wx.dll with MingW
if ("${CMAKE_GENERATOR}" MATCHES "MinGW Makefiles")
    set_target_properties(wxLuaModule PROPERTIES PREFIX "")
endif()

# When we link to the static wxWidgets lib ignore warnings about not exporting the wx symbols
# since we don't want to export them.
if (MSVC)
    # warning C4251: 'wxLuaSocketBase::m_name' : class 'wxString' needs to have dll-interface to be used by clients of class 'wxLuaSocketBase'
    # warning C4275: non dll-interface class 'wxObject' used as base for dll-interface class 'wxLuaSocketBase'
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4251 /wd4275")
endif()

if (BUILD_SHARED_LIBS_WIN_DLLS)
    SET_TARGET_PROPERTIES(wxLuaModule PROPERTIES COMPILE_DEFINITIONS 
                          "WXMAKINGDLL_WXLUA;WXMAKINGDLL_WXLUADEBUGGER;WXMAKINGDLL_WXLUADEBUG;WXMAKINGDLL_WXBIND")
endif()

endfunction (wxLua_Modules_LuaModule_TARGETS)

# ===========================================================================

if (wxLua_LUA_LIBRARY_USE_BUILTIN)
    if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.1)
        add_subdirectory( lua-5.1 )
    else()
        add_subdirectory( lua-5.2 )
    endif()
endif()

add_subdirectory( wxbind )
add_subdirectory( wxlua )
add_subdirectory( wxlua/debug )
add_subdirectory( wxlua/debugger )
add_subdirectory( luamodule ) # include after everything else to get source file list
