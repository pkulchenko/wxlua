# ---------------------------------------------------------------------------
# CMake build file
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Project name, sets ${wxLua_SOURCE_DIR} and ${wxLua_BINARY_DIR}

project( wxLua )

# ===========================================================================
# General settings for CMake
# ===========================================================================

# ---------------------------------------------------------------------------
# Use a minimum version of CMake of 2.8, >= 2.8.3 is prefered

cmake_minimum_required( VERSION 2.8 )

# ---------------------------------------------------------------------------
# Setup the CMake environment

include( build/CMakewxAppLib.cmake )
include( build/CMakeFunctions.txt )

# Specify what wxWidgets libs we need to link to. Note: 'core' must be before 'base'.
# If you call this CMakeLists.txt from another one you may have already called FIND_WXWIDGETS()
if (NOT wxWidgets_COMPONENTS)
    set(wxWidgets_COMPONENTS xrc xml net media propgrid richtext aui stc html adv core base) # minimal set for static lib/dll
    #set(wxWidgets_COMPONENTS gl xrc xml net media propgrid richtext aui stc html adv core base) # for multilib/dll
    #set(wxWidgets_COMPONENTS stc mono) # for monolithic
endif()

FIND_WXWIDGETS(wxWidgets_COMPONENTS) # Ok to call multiple times

# ===========================================================================
# Add subdirectories containing CMakeLists.txt files or specify projects
# ===========================================================================

set( wxLua_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "Root dir of wxLua" FORCE)

ADD_CPPCHECK_TEST(wxLua_CppCheck)

include_directories(${wxLua_ROOT_DIR}/modules/wxbind/setup)

set(wxLuaBind_ALL_COMPONENTS gl stc xrc richtext html media aui adv core xml net base )
if (NOT wxLuaBind_COMPONENTS)
    set(wxLuaBind_COMPONENTS ${wxLuaBind_ALL_COMPONENTS})
endif()
set(wxLuaBind_COMPONENTS ${wxLuaBind_COMPONENTS} CACHE STRING "wxWidgets libs wxLua should add bindings for")

set(wxLuaBindLib_SOURCES)

foreach( wx_comp ${wxLuaBind_ALL_COMPONENTS} )
    string(TOUPPER ${wx_comp} wx_comp_upper)

    # match wx libs to binding libs
    string(REGEX MATCH ${wx_comp} wx_comp_found "${wxLuaBind_COMPONENTS}")

    if ("${wx_comp}" STREQUAL "${wx_comp_found}")
        set(WXLUA_BINDTO_${wx_comp} TRUE CACHE INTERNAL "")
        add_definitions("-DwxLUA_USEBINDING_WX${wx_comp_upper}=1")
        set(wxLuaBindLib_SOURCES ${wxLuaBindLib_SOURCES} "src/wx${wx_comp}_*.cpp")
    else()
        set(WXLUA_BINDTO_${wx_comp} FALSE CACHE INTERNAL "")
        add_definitions("-DwxLUA_USEBINDING_WX${wx_comp_upper}=0")
    endif()
endforeach()


if (NOT TARGET wxLuaLib)
    add_subdirectory( modules/ )
endif()

if (NOT TARGET wxLuaCan)
    add_subdirectory( apps/ )
endif()
