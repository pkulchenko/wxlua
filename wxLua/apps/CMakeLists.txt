# ---------------------------------------------------------------------------
# CMake build file
# ---------------------------------------------------------------------------

include(../build/CMakeFunctions.txt)

# ---------------------------------------------------------------------------
# Project name, sets ${wxLuaApps_SOURCE_DIR} and ${wxLuaApps_BINARY_DIR}

project( wxLuaApps )

set( wxLua_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../ CACHE INTERNAL "Root dir of wxLua" FORCE)

# ---------------------------------------------------------------------------
# CMake build file for wxLua apps
# ---------------------------------------------------------------------------

include_directories(${wxLua_ROOT_DIR}/
                    ${wxLua_ROOT_DIR}/modules/
                    ${wxLua_ROOT_DIR}/modules/lua/src)

function (wxLua_Apps_wxLua_TARGETS)

ADD_EXECUTABLE_FULL( wxLua_app WIN32 MACOSX_BUNDLE
    HEADERS
        "${wxLua_ROOT_DIR}/apps/wxlua/src/*.h"
    SOURCES
        "${wxLua_ROOT_DIR}/apps/wxlua/src/*.cpp"
        ${wxLua_ROOT_DIR}/apps/wxlua/src/wxlua.rc
    LINK_LIBRARIES
        #wxLuaBindLib
        ${wxLuaBind_ALL_LIBS}
        wxLuaSocketLib
        wxLuaDebugLib
        wxLuaLib
        LuaLib
        ${wxWidgets_LIBRARIES}
    PROPERTIES FOLDER "wxLua/apps"
    PROPERTIES OUTPUT_NAME wxLua)

endfunction (wxLua_Apps_wxLua_TARGETS)

# ---------------------------------------------------------------------------

function (wxLua_Apps_wxLuaCan_TARGETS)

ADD_EXECUTABLE_FULL( wxLuaCan WIN32 MACOSX_BUNDLE
    HEADERS
        "${wxLua_ROOT_DIR}/apps/wxluacan/src/*.h"
    SOURCES
        "${wxLua_ROOT_DIR}/apps/wxluacan/src/*.cpp"
        ${wxLua_ROOT_DIR}/apps/wxluacan/src/cansim.rc
    LINK_LIBRARIES
        #wxLuaBindLib
        ${wxLuaBind_ALL_LIBS}
        wxLuaSocketLib
        wxLuaDebugLib
        wxLuaLib
        LuaLib
        ${wxWidgets_LIBRARIES}
    PROPERTIES FOLDER "wxLua/apps")

endfunction (wxLua_Apps_wxLuaCan_TARGETS)

# ---------------------------------------------------------------------------

function (wxLua_Apps_wxLuaEdit_TARGETS)

set( wxStEdit_ROOT_DIR ${wxStEdit_ROOT_DIR} CACHE PATH "Root dir of wxStEdit" FORCE)

if (EXISTS ${wxStEdit_ROOT_DIR}/CMakeLists.txt AND EXISTS ${wxStEdit_ROOT_DIR}/include/wx/stedit/stedit.h)
    if (NOT TARGET wxStEditLib)
        add_subdirectory(${wxStEdit_ROOT_DIR} ${CMAKE_BINARY_DIR}/wxStEdit)
    endif()
else()
    MESSAGE(STATUS "* WARNING: wxLuaEdit application will not be built since wxStEdit was not found.")
    MESSAGE(STATUS "* WARNING: wxStEdit_ROOT_DIR directory does not exist: '${wxStEdit_ROOT_DIR}'")
    return()
endif()

include_directories(${wxStEdit_ROOT_DIR}/include ${wxStEdit_SETUP_INCLUDE_PATH})

ADD_EXECUTABLE_FULL( wxLuaEdit WIN32 MACOSX_BUNDLE
    HEADERS
        "${wxLua_ROOT_DIR}/apps/wxluaedit/src/*.h"
    SOURCES
        "${wxLua_ROOT_DIR}/apps/wxluaedit/src/*.cpp"
        ${wxLua_ROOT_DIR}/apps/wxluaedit/src/wxluaedit.rc
    LINK_LIBRARIES
        wxStEditLib
        #wxLuaBindLib
        ${wxLuaBind_ALL_LIBS}
        wxLuaSocketLib
        wxLuaDebugLib
        wxLuaLib
        LuaLib
        ${wxWidgets_LIBRARIES}
    PROPERTIES FOLDER "wxLua/apps")

if (BUILD_SHARED_LIBS)
    APPEND_TARGET_PROPERTIES(wxLuaEdit PROPERTIES COMPILE_DEFINITIONS "WXUSINGDLL_STEDIT")
endif()

endfunction (wxLua_Apps_wxLuaEdit_TARGETS)

# ---------------------------------------------------------------------------

function (wxLua_Apps_wxLuaFreeze_TARGETS)

ADD_EXECUTABLE_FULL( wxLuaFreeze WIN32 MACOSX_BUNDLE
    HEADERS
        "${wxLua_ROOT_DIR}/apps/wxluafreeze/src/*.h"
    SOURCES
        "${wxLua_ROOT_DIR}/apps/wxluafreeze/src/*.cpp"
        ${wxLua_ROOT_DIR}/apps/wxluafreeze/src/wxluafreeze.rc
    LINK_LIBRARIES
        #wxLuaBindLib
        ${wxLuaBind_ALL_LIBS}
        wxLuaSocketLib
        wxLuaDebugLib
        wxLuaLib
        LuaLib
        ${wxWidgets_LIBRARIES}
    PROPERTIES FOLDER "wxLua/apps")

endfunction (wxLua_Apps_wxLuaFreeze_TARGETS)

# ===========================================================================

add_subdirectory( wxlua )
add_subdirectory( wxluacan )
add_subdirectory( wxluaedit )
add_subdirectory( wxluafreeze )
