# ---------------------------------------------------------------------------
# CMake build file
# ---------------------------------------------------------------------------

include(../build/CMakeFunctions.cmake)

# ---------------------------------------------------------------------------
# Project name, sets ${wxLuaApps_SOURCE_DIR} and ${wxLuaApps_BINARY_DIR}

project( wxLuaApps )

set(MINGW_EXTRA_LIBS)
if(MINGW)
	set(MINGW_EXTRA_LIBS "-lversion;-lshlwapi;-luxtheme;-loleacc;-lws2_32;-limm32")
	message("MINGW_EXTRA_LIBS is " ${MINGW_EXTRA_LIBS})
endif(MINGW)

if (NOT DEFINED wxLua_ROOT_DIR)
    set(wxLua_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../ CACHE INTERNAL
        "Root dir of wxLua" FORCE)
endif()

# ---------------------------------------------------------------------------
# CMake build file for wxLua apps
# ---------------------------------------------------------------------------

include_directories("${wxLua_ROOT_DIR}/"
                    "${wxLua_ROOT_DIR}/modules/"
                    "${wxLua_LUA_INCLUDE_DIR}")

function (wxLua_Apps_wxLua_TARGETS)

ADD_EXECUTABLE_FULL( wxLua_app WIN32 MACOSX_BUNDLE
    HEADERS
        "${wxLua_ROOT_DIR}/apps/wxlua/*.h"
    SOURCES
        "${wxLua_ROOT_DIR}/apps/wxlua/*.cpp"
        "${wxLua_ROOT_DIR}/apps/wxlua/wxlua.rc"
        "${wxLua_ROOT_DIR}/art/wxlualogo.icns"
    LINK_LIBRARIES
        ${wxLuaBind_ALL_LIBS}
        wxLuaDebuggerLib
        wxLuaDebugLib
        wxLuaLib
        LuaLib
        ${wxWidgets_LIBRARIES}
		${MINGW_EXTRA_LIBS}
    PROPERTIES FOLDER "wxLua/apps"
    PROPERTIES OUTPUT_NAME wxLua
    INSTALL ${WXLUA_APP_INSTALL_FLAGS})

# This must be set in the app directory
SET_SOURCE_FILES_PROPERTIES( "${wxLua_ROOT_DIR}/art/wxlualogo.icns"
                             PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

endfunction (wxLua_Apps_wxLua_TARGETS)

# ---------------------------------------------------------------------------

function (wxLua_Apps_wxLuaCan_TARGETS)

ADD_EXECUTABLE_FULL( wxLuaCan WIN32 MACOSX_BUNDLE
    HEADERS
        "${wxLua_ROOT_DIR}/apps/wxluacan/*.h"
    SOURCES
        "${wxLua_ROOT_DIR}/apps/wxluacan/*.cpp"
        "${wxLua_ROOT_DIR}/apps/wxluacan/cansim.rc"
        "${wxLua_ROOT_DIR}/art/wxlualogo.icns"
    LINK_LIBRARIES
        ${wxLuaBind_ALL_LIBS}
        wxLuaDebuggerLib
        wxLuaDebugLib
        wxLuaLib
        LuaLib
        ${wxWidgets_LIBRARIES}
		${MINGW_EXTRA_LIBS}
    PROPERTIES FOLDER "wxLua/apps"
    INSTALL ${WXLUA_APP_INSTALL_FLAGS})

# This must be set in the app directory
SET_SOURCE_FILES_PROPERTIES( "${wxLua_ROOT_DIR}/art/wxlualogo.icns"
                             PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

endfunction (wxLua_Apps_wxLuaCan_TARGETS)

# ---------------------------------------------------------------------------

function (wxLua_Apps_wxLuaEdit_TARGETS)

ADD_EXECUTABLE_FULL( wxLuaEdit WIN32 MACOSX_BUNDLE
    HEADERS
        "${wxLua_ROOT_DIR}/apps/wxluaedit/*.h"
    SOURCES
        "${wxLua_ROOT_DIR}/apps/wxluaedit/*.cpp"
        "${wxLua_ROOT_DIR}/apps/wxluaedit/wxluaedit.rc"
        "${wxLua_ROOT_DIR}/art/wxlualogo.icns"
    LINK_LIBRARIES
        ${wxLuaBind_ALL_LIBS}
        wxLuaDebuggerLib
        wxLuaDebugLib
        wxLuaLib
        LuaLib
        ${wxWidgets_LIBRARIES}
    PROPERTIES FOLDER "wxLua/apps"
    INSTALL ${WXLUA_APP_INSTALL_FLAGS})

if (BUILD_SHARED_LIBS_WIN_DLLS)
    APPEND_TARGET_PROPERTIES(wxLuaEdit PROPERTIES COMPILE_DEFINITIONS "WXUSINGDLL_STEDIT")
endif()

# This must be set in the app directory
SET_SOURCE_FILES_PROPERTIES( "${wxLua_ROOT_DIR}/art/wxlualogo.icns"
                             PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

endfunction (wxLua_Apps_wxLuaEdit_TARGETS)

# ---------------------------------------------------------------------------

function (wxLua_Apps_wxLuaFreeze_TARGETS)

ADD_EXECUTABLE_FULL( wxLuaFreeze WIN32 MACOSX_BUNDLE
    HEADERS
        "${wxLua_ROOT_DIR}/apps/wxluafreeze/*.h"
    SOURCES
        "${wxLua_ROOT_DIR}/apps/wxluafreeze/*.cpp"
        "${wxLua_ROOT_DIR}/apps/wxluafreeze/wxluafreeze.rc"
        "${wxLua_ROOT_DIR}/art/wxlualogo.icns"
    LINK_LIBRARIES
        ${wxLuaBind_ALL_LIBS}
        wxLuaDebuggerLib
        wxLuaDebugLib
        wxLuaLib
        LuaLib
        ${wxWidgets_LIBRARIES}
		${MINGW_EXTRA_LIBS}
    PROPERTIES FOLDER "wxLua/apps"
    INSTALL ${WXLUA_APP_INSTALL_FLAGS})

# This must be set in the app directory
SET_SOURCE_FILES_PROPERTIES( "${wxLua_ROOT_DIR}/art/wxlualogo.icns"
                             PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

endfunction (wxLua_Apps_wxLuaFreeze_TARGETS)

# ===========================================================================

add_subdirectory( wxlua )
add_subdirectory( wxluacan )
add_subdirectory( wxluafreeze )
