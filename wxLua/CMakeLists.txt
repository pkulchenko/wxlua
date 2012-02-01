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
# wxWidgets include (this will do all the magic to configure everything)
include( "${wxWidgets_USE_FILE}" )

# ---------------------------------------------------------------------------
# Setup what wxWidgets libraries we will make bindings for.
# We do this at the root CMakeLists since we need to call
# add_definitions(-DwxLUA_USEBINDING...) for each one.
# NOTE: If you include this CMakeLists to build wxLua and then
#       use it, you MUST call SETUP_wxLua() to setup the defines.

# This is the list of all the wxLua bindings for wxWidgets with the same names as the wxWidgets libs.
set(wxLuaBind_ALL_COMPONENTS gl stc xrc richtext html media aui adv core xml net base )

# You can edit them in the cmake-gui
if (NOT wxLuaBind_COMPONENTS)
    set(wxLuaBind_COMPONENTS ${wxLuaBind_ALL_COMPONENTS})
endif()
set(wxLuaBind_COMPONENTS ${wxLuaBind_COMPONENTS} CACHE STRING "wxWidgets libs wxLua should add bindings for, the variable wxWidgets_COMPONENTS must contain all of these.")

# We will create a list of the source files needed to compile
set(wxLuaBindLib_SOURCES)
# These are the definitions that in your CMake project you can call add_definitions() on.
set(wxLua_CXX_DEFINITIONS)

# verify that each library exists from finding wxWidgets in the wxWidgets_COMPONENTS
foreach( wxlua_comp ${wxLuaBind_ALL_COMPONENTS} )
    string(TOUPPER ${wxlua_comp} wxlua_comp_upper)

    # find specified wxlua binding libs
    string(REGEX MATCH ${wxlua_comp} wxlua_comp_found "${wxLuaBind_COMPONENTS}")
    # find specified wxlua binding libs in the wxwidgets libs
    string(REGEX MATCH ${wxlua_comp} wx_comp_found "${wxWidgets_COMPONENTS}")

    if (("${wxlua_comp}" STREQUAL "${wxlua_comp_found}") AND ("${wxlua_comp}" STREQUAL "${wx_comp_found}"))
        set(WXLUA_BINDTO_${wxlua_comp} TRUE CACHE INTERNAL "")
        set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} "-DwxLUA_USEBINDING_WX${wxlua_comp_upper}=1")
        set(wxLuaBindLib_SOURCES ${wxLuaBindLib_SOURCES} "src/wx${wxlua_comp}_*.cpp")
    else()
        if (("${wxlua_comp}" STREQUAL "${wxlua_comp_found}") AND (NOT "${wxlua_comp}" STREQUAL "${wx_comp_found}"))
            message(STATUS "* WARNING: Specified wxLuaBinding lib '${wxlua_comp}' in variable wxLuaBind_COMPONENTS is missing from wxWidgets_COMPONENTS so it will not be compiled.")
        endif()

        set(WXLUA_BINDTO_${wxlua_comp} FALSE CACHE INTERNAL "")
        set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} "-DwxLUA_USEBINDING_WX${wxlua_comp_upper}=0")
    endif()
endforeach()

# ===========================================================================
# This function must be called in any CMakeLists that uses any wxLua headers to
# ensure that the compiler #defines are correct.
# ===========================================================================

macro(SETUP_wxLua)
    # These have to be defined so that the macros in modules/wxbind/include/wxbinddefs.h work
    add_definitions(${wxLua_CXX_DEFINITIONS})
endmacro()

SETUP_wxLua()

# ===========================================================================
# Add subdirectories containing CMakeLists.txt files or specify projects
# ===========================================================================

set( wxLua_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "Root dir of wxLua" FORCE)

ADD_CPPCHECK_TEST(wxLua_CppCheck)

include_directories(${wxLua_ROOT_DIR}/modules/wxbind/setup)

if (NOT TARGET wxLuaLib)
    add_subdirectory( modules/ )
endif()

if (NOT TARGET wxLuaCan)
    add_subdirectory( apps/ )
endif()

export( TARGETS LuaLib wxLuaLib wxLuaDebugLib wxLuaSocketLib wxLuaBindLib
        FILE "${CMAKE_BINARY_DIR}/build/wxLua-config.cmake")
