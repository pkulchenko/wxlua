# ---------------------------------------------------------------------------
# wxLua CMake build file
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Project name, sets ${wxLua_SOURCE_DIR} and ${wxLua_BINARY_DIR}

project( wxLua )

set(wxLua_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH
    "Root dir of wxLua" FORCE)

# ===========================================================================
# General settings for CMake
# ===========================================================================

# ---------------------------------------------------------------------------
# Use a minimum version of CMake of 2.8, >= 2.8.3 is prefered

cmake_minimum_required( VERSION 2.8 )

# ---------------------------------------------------------------------------
# Setup the CMake environment

include( build/CMakeProject.cmake )
include( build/CMakewxAppLib.cmake )

# ===========================================================================
# wxLua version
# ===========================================================================

set( wxLua_VERSION           "3.2.0.2" )
set( wxLua_MAJOR_VERSION     "3" )
set( wxLua_MINOR_VERSION     "2" )
set( wxLua_RELEASE_VERSION   "0" )
set( wxLua_SUBRELEASE_NUMBER "2")

# ===========================================================================
# wxWidgets libraries and wxLua bindings setup
# ===========================================================================

# ---------------------------------------------------------------------------
# Find and setup the wxWidgets library
# ---------------------------------------------------------------------------

# Specify what wxWidgets libs we need to link to. Note: 'core' must be before 'base'.
# If this CMakeLists.txt was called from another, FIND_WXWIDGETS() may have already been called.
if (NOT DEFINED wxWidgets_COMPONENTS)
    if (UNIX)
      set(wxWidgets_COMPONENTS gl xrc xml net media propgrid richtext aui stc html adv core base)  # complete set for static lib/dll
    else()
      set(wxWidgets_COMPONENTS webview gl xrc xml net media propgrid richtext aui stc html adv core base)  # complete set for static lib/dll
    endif()
    #set(wxWidgets_COMPONENTS webview gl xrc xml net media propgrid richtext aui stc html adv core base) # for multilib/dll
    #set(wxWidgets_COMPONENTS stc mono) # for monolithic
endif()

FIND_WXWIDGETS(wxWidgets_COMPONENTS) # Ok to call multiple times
# CMake's wxWidgets include that will configure the build in this dir and sub-dirs
include( "${wxWidgets_USE_FILE}" )

# ---------------------------------------------------------------------------
# Setup the location of the customizable wxluasetup.h file
# ---------------------------------------------------------------------------

if (DEFINED wxLuaBind_WXLUASETUP_DIR)
set(wxLuaBind_WXLUASETUP_DIR ${wxLuaBind_WXLUASETUP_DIR} CACHE PATH
    "Path to wxLua's wxWidgets binding wxluasetup.h setup file." FORCE)

if (NOT EXISTS "${wxLuaBind_WXLUASETUP_DIR}")
    MESSAGE(FATAL_ERROR "wxLuaBind_WXLUASETUP_DIR points to a non-existant path: '${wxLuaBind_WXLUASETUP_DIR}', the default is '${wxLua_ROOT_DIR}/modules/wxbind/setup'.")
endif()
endif()

# ---------------------------------------------------------------------------
# Setup what wxWidgets libraries wxLua will make bindings for and link to.
# This is done at the root CMakeLists since we need to call
# add_definitions(-DwxLUA_USEBINDING...) for both the modules/ and the apps/.
# ---------------------------------------------------------------------------

# This is the list of all the wxLua bindings for wxWidgets with the same names as the wxWidgets libs.
set(wxLuaBind_ALL_COMPONENTS webview gl stc xrc richtext propgrid html media aui adv core xml net base )

if (NOT DEFINED wxLuaBind_COMPONENTS)
    set(wxLuaBind_COMPONENTS ${wxLuaBind_ALL_COMPONENTS})
endif()
set(wxLuaBind_COMPONENTS ${wxLuaBind_COMPONENTS} CACHE STRING
    "wxWidgets libs wxLua should build bindings for, choose from '${wxLuaBind_ALL_COMPONENTS}', the wxWidgets_COMPONENTS must contain all of these." FORCE)

# We will create this list of the source files to compile in the next section.
set(wxLuaBindLib_SOURCES "" CACHE INTERNAL "")
# These are the wxLua compiler definitions, see SETUP_wxLua().
set(wxLua_CXX_DEFINITIONS "" CACHE INTERNAL
    "wxLua C++ compiler flags to include/exclude wxLua binding libs" FORCE)

# check the specified wxLuaBind_COMPONENTS for typos
foreach( wxlua_comp ${wxLuaBind_COMPONENTS} )
    string(REGEX MATCH ${wxlua_comp} wxlua_comp_found "${wxLuaBind_ALL_COMPONENTS}")

    if (NOT wxlua_comp_found)
        message(FATAL_ERROR "Unknown wxLua binding library '${wxlua_comp}' in the wxLuaBind_COMPONENTS list, please choose from '${wxLuaBind_ALL_COMPONENTS}'")
    endif()
endforeach()

# Verify that each library exists in the wxWidgets_COMPONENTS after finding wxWidgets.
# Set all the -DwxLUA_USEBINDING_WXXXX, ignoring the defaults, for clarity.
foreach( wxlua_comp ${wxLuaBind_ALL_COMPONENTS} )
    string(TOUPPER ${wxlua_comp} wxlua_comp_upper)

    string(REGEX MATCH ${wxlua_comp} wxlua_comp_found "${wxLuaBind_COMPONENTS}")
    string(REGEX MATCH ${wxlua_comp} wx_comp_found    "${wxWidgets_COMPONENTS}")

    # assume that the monolithic wxWidgets lib has everything, we can't really know better.
    if (NOT wx_comp_found)
        string(REGEX MATCH "mono" wx_comp_found "${wxWidgets_COMPONENTS}")
    endif()

    if (wx_comp_found AND ("${wxlua_comp}" STREQUAL "${wxlua_comp_found}"))
        set(WXLUA_BINDTO_${wxlua_comp} TRUE CACHE INTERNAL "")
        set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} "-DwxLUA_USEBINDING_WX${wxlua_comp_upper}=1")
        set(wxLuaBindLib_SOURCES ${wxLuaBindLib_SOURCES} "src/wx${wxlua_comp}_*.cpp" CACHE INTERNAL "")
    else()
        message(STATUS "* WARNING: Specified wxLuaBinding lib '${wxlua_comp}' in variable wxLuaBind_COMPONENTS is missing from wxWidgets_COMPONENTS so it will not be compiled.")

        set(WXLUA_BINDTO_${wxlua_comp} FALSE CACHE INTERNAL "")
        set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} "-DwxLUA_USEBINDING_WX${wxlua_comp_upper}=0")
    endif()
endforeach()

# ---------------------------------------------------------------------------
# This function must be called in any other CMakeLists.txt for projects that
# use any wxLua headers to ensure that the compiler #defines are correct.
# ---------------------------------------------------------------------------

macro(SETUP_wxLua)
    # These have to be defined so that the macros in modules/wxbind/include/wxbinddefs.h work
    add_definitions(${wxLua_CXX_DEFINITIONS})
endmacro()

# ===========================================================================
# Set the Lua lib to an imported lib or build it from the provided sources.
# Note that CMake requires that we declare it here, rather than the modules dir,
# to be useable in the apps subdirectory.
# ===========================================================================

if (NOT DEFINED wxLua_LUA_LIBRARY_USE_BUILTIN)
    set(wxLua_LUA_LIBRARY_USE_BUILTIN TRUE)
endif()
set(wxLua_LUA_LIBRARY_USE_BUILTIN ${wxLua_LUA_LIBRARY_USE_BUILTIN} CACHE BOOL
    "Use the built-in Lua 5.1 or 5.2 library, else specify an external or try to find a system Lua library, see wxLua_LUA_INCLUDE_DIR and wxLua_LUA_LIBRARY" FORCE)

if (NOT DEFINED wxLua_LUA_LIBRARY_VERSION)
    set(wxLua_LUA_LIBRARY_VERSION "5.1")
endif()
set(wxLua_LUA_LIBRARY_VERSION ${wxLua_LUA_LIBRARY_VERSION} CACHE STRING
    "Choose the Lua library version to use, '5.1' or '5.2', see also wxLua_LUA_LIBRARY_USE_BUILTIN" FORCE)

if ((NOT "${wxLua_LUA_LIBRARY_VERSION}" STREQUAL "5.1") AND (NOT "${wxLua_LUA_LIBRARY_VERSION}" STREQUAL "5.2") AND (NOT "${wxLua_LUA_LIBRARY_VERSION}" STREQUAL "5.3") AND (NOT "${wxLua_LUA_LIBRARY_VERSION}" STREQUAL "5.4"))
    MESSAGE(FATAL_ERROR "wxLua_LUA_LIBRARY_VERSION may only be set to '5.1' or '5.2' or '5.3' or '5.4'")
endif()

if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.1)
    set(wxLua_LUA_LIBRARY_VERSION_NUM 51)
else()
    if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.2)
        set(wxLua_LUA_LIBRARY_VERSION_NUM 52)
    else()
        if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.3)
            set(wxLua_LUA_LIBRARY_VERSION_NUM 53)
        else()
            set(wxLua_LUA_LIBRARY_VERSION_NUM 54)
        endif()
    endif()
endif()

if (NOT DEFINED wxLua_LUA_INCLUDE_DIR)
    set(wxLua_LUA_INCLUDE_DIR )
endif()
if (NOT DEFINED wxLua_LUA_LIBRARY)
    set(wxLua_LUA_LIBRARY )
endif()

if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.2)
    set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} -DLUA_COMPAT_ALL) # Match build used in default 5.2 Makefile
endif()
if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.3)
    set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} -DLUA_COMPAT_5_2) # Match build used in default 5.3 Makefile
endif()
if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.4)
    set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} -DLUA_COMPAT_5_3) # Match build used in default 5.4 Makefile
endif()

set(wxLua_CXX_DEFINITIONS "${wxLua_CXX_DEFINITIONS}" CACHE INTERNAL
    "wxLua C++ compiler flags to include/exclude wxLua binding libs" FORCE)

if (NOT wxLua_LUA_LIBRARY_USE_BUILTIN)
    # They can enter these by hand so don't overwrite them if they're already valid
    if (NOT EXISTS "${wxLua_LUA_LIBRARY}") # OR (NOT EXISTS "${wxLua_LUA_INCLUDE_DIR}"))
        message(STATUS "* wxLua attempting to automatically find an external Lua ${wxLua_LUA_LIBRARY_VERSION} library.")

        if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.1)
            FIND_PACKAGE(Lua51)
        else()
            if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.2)
                FIND_PACKAGE(Lua52)
            else()
                FIND_PACKAGE(Lua53)
            endif()
        endif()

        if (LUA51_FOUND OR LUA52_FOUND OR LUA53_FOUND)
            set(wxLua_LUA_INCLUDE_DIR ${LUA_INCLUDE_DIR})
            set(wxLua_LUA_LIBRARY     ${LUA_LIBRARY})
        endif()
    endif()

    set(wxLua_LUA_ROOT_DIR ) # don't care for import Lua lib

    message(STATUS "* wxLua using external/system Lua library :")
    message(STATUS "*   - include dir : ${wxLua_LUA_INCLUDE_DIR}")
    message(STATUS "*   - library     : ${wxLua_LUA_LIBRARY}")

    if ((NOT EXISTS "${wxLua_LUA_LIBRARY}") OR (NOT EXISTS "${wxLua_LUA_INCLUDE_DIR}"))
        message(ERROR " An external/system Lua ${wxLua_LUA_LIBRARY_VERSION} library was requested, but not found.\nPlease set or correct the variables wxLua_LUA_INCLUDE_DIR and wxLua_LUA_LIBRARY to specify an external Lua library.")
    endif()

    # Don't know if external Lua lib is shared or static.
    add_library(LuaLib UNKNOWN IMPORTED)
    set_target_properties(LuaLib PROPERTIES IMPORTED_LOCATION ${wxLua_LUA_LIBRARY})

    add_library(LuaLibShared UNKNOWN IMPORTED)
    set_target_properties(LuaLibShared PROPERTIES IMPORTED_LOCATION ${wxLua_LUA_LIBRARY})

    set(LuaLibShared_TARGET_NAME LuaLib) # hopefully...

    set(LuaLib_Export) # Cmake only allows exporting targets that we build

else() # Use the built-in Lua library

    message(STATUS "* wxLua using built-in Lua ${wxLua_LUA_LIBRARY_VERSION} library")

    if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.1)
        set(wxLua_LUA_ROOT_DIR "${wxLua_ROOT_DIR}/modules/lua-5.1")
    else()
        if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.2)
            set(wxLua_LUA_ROOT_DIR "${wxLua_ROOT_DIR}/modules/lua-5.2")
        endif()
    endif()

    set(wxLua_LUA_INCLUDE_DIR "${wxLua_LUA_ROOT_DIR}/src")
    set(wxLua_LUA_LIBRARY     "")

    set(LuaLib_Export LuaLib) # Cmake only allows exporting targets that we build

endif()

# Update cache
set(wxLua_LUA_INCLUDE_DIR ${wxLua_LUA_INCLUDE_DIR} CACHE PATH
    "Set the path to an external Lua library's include directory, overwritten if wxLua_LUA_LIBRARY_USE_BUILTIN" FORCE )
set(wxLua_LUA_LIBRARY ${wxLua_LUA_LIBRARY} CACHE FILEPATH
    "Set the path to an external Lua library to link to (E.G. lua.so or lua.lib), overwritten if wxLua_LUA_LIBRARY_USE_BUILTIN" FORCE )

# ===========================================================================
# We can build everything but the Lua library staticly.
# You need to have a shared Lua library to require() other modules.
# The shared lib is unneeded in MSW when using a proxydll or if nobody else needs it.
# ===========================================================================

if (NOT DEFINED wxLua_LUA_LIBRARY_BUILD_SHARED)
    set(wxLua_LUA_LIBRARY_BUILD_SHARED ${BUILD_SHARED_LIBS})
endif()

set(wxLua_LUA_LIBRARY_BUILD_SHARED ${wxLua_LUA_LIBRARY_BUILD_SHARED} CACHE BOOL
    "Build the built-in Lua library as a shared library regardless of the BUILD_SHARED_LIBS setting" FORCE )

if (wxLua_LUA_LIBRARY_BUILD_SHARED)
    set(wxLua_LUA_LIBRARY_BUILD_SHARED_FLAG SHARED)
endif()

# ---------------------------------------------------------------------------
# Setup the MACOSX bundle
# ---------------------------------------------------------------------------

set( MACOSX_BUNDLE_INFO_STRING          "wxLua")
set( MACOSX_BUNDLE_ICON_FILE            "wxlualogo.icns")
set( MACOSX_BUNDLE_GUI_IDENTIFIER       )
set( MACOSX_BUNDLE_LONG_VERSION_STRING  "wxLua ${wxLua_VERSION}, built with wxWidgets ${wxWidgets_VERSION}")
set( MACOSX_BUNDLE_BUNDLE_NAME          )
set( MACOSX_BUNDLE_SHORT_VERSION_STRING "${wxLua_VERSION}")
set( MACOSX_BUNDLE_BUNDLE_VERSION       "${wxLua_VERSION}")
set( MACOSX_BUNDLE_COPYRIGHT            "(2013) John Labenski, et al.")

# ---------------------------------------------------------------------------

# These are passed to ADD_LIBRARY_FULL() to call the INSTALL() function
# The targets are installed in the modules/ CMakeLists.txt
SET(WXLUA_LIB_INSTALL_FLAGS_NO_EXPORT
    #EXPORT  wxLua_export
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)
SET(WXLUA_LIB_INSTALL_FLAGS
    EXPORT  wxLua_export
    ${WXLUA_LIB_INSTALL_FLAGS_NO_EXPORT})
SET(WXLUA_APP_INSTALL_FLAGS
    ${ADD_EXECUTABLE_FULL_INSTALL_DEFAULT})

# ===========================================================================
# Copy the proxydll if in MSW
# ===========================================================================

if (WIN32)
    set(wxLua_proxydlls_to_not_copy "lua51.dll" "lua5.1.dll" "lua52.dll" "lua5.2.dll" "lua53.dll" "lua5.3.dll")

    if (IS_64_BIT)
        message(STATUS "* Not copying the Lua proxydlls since they do not work in the 64-bit build.")
    else()
        if (wxLua_LUA_LIBRARY_USE_BUILTIN AND NOT wxLua_LUA_LIBRARY_BUILD_SHARED)
            # In msw these are the shared lua.dlls we'll use.
            # The LuaLibShared is built into bin/Debug/shared/* so it won't conflict.
            CONFIGURE_FILE_TO_BUILD_CONFIGURATION_DIRS( lua${wxLua_LUA_LIBRARY_VERSION_NUM}.dll
                                                        ${wxLua_ROOT_DIR}/modules/luaproxydll
                                                        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
                                                        COPYONLY)
            CONFIGURE_FILE_TO_BUILD_CONFIGURATION_DIRS( lua${wxLua_LUA_LIBRARY_VERSION}.dll
                                                        ${wxLua_ROOT_DIR}/modules/luaproxydll
                                                        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
                                                        COPYONLY)

            if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.1)
                set(wxLua_proxydlls_to_not_copy "lua52.dll" "lua5.2.dll" "lua53.dll" "lua5.3.dll")
            else()
                if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.2)
                    set(wxLua_proxydlls_to_not_copy "lua51.dll" "lua5.1.dll" "lua53.dll" "lua5.3.dll")
                else()
                    set(wxLua_proxydlls_to_not_copy "lua51.dll" "lua5.1.dll" "lua52.dll" "lua5.2.dll")
                endif()
            endif()
        endif()
    endif (IS_64_BIT)

    # Cleanup if they accidently configured with one version or shared/static then switched.
    foreach (f ${wxLua_proxydlls_to_not_copy})
        REMOVE_MATCHING_FILE_FROM_BUILD_CONFIGURATION_DIRS("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
                                                           "${wxLua_ROOT_DIR}/modules/luaproxydll/${f}" ${f})
    endforeach()
endif(WIN32)

# ===========================================================================
# Add general targets
# ===========================================================================

ADD_CPPCHECK_TEST(wxLua_CppCheck)

set( DOXYGEN_PROJECT_NAME        "wxLua" )
set( DOXYGEN_PROJECT_NUMBER      "${wxLua_VERSION}" )
set( DOXYGEN_OUTPUT_DIRECTORY    "${CMAKE_BINARY_DIR}/doc-wxLua" )
set( DOXYGEN_STRIP_FROM_PATH     "${wxLua_ROOT_DIR}/modules" )
set( DOXYGEN_STRIP_FROM_INC_PATH "${wxLua_ROOT_DIR}/modules" )
set( DOXYGEN_INPUT               "${wxLua_ROOT_DIR}/modules" )
set( DOXYGEN_FILE_PATTERNS       "*.h *.hpp" )
set( DOXYGEN_PREDEFINED          "${DOXYGEN_PREDEFINED_WXWIDGETS}  WXDLLIMPEXP_DATA_WXLUA(x)=x")

ADD_DOXYGEN( wxLua_doxygen
             ${wxLua_ROOT_DIR}/build/CMake-doxygen.in
             ${CMAKE_BINARY_DIR}/doxygen_wxLua.cfg
             ${CMAKE_BINARY_DIR} )

# ===========================================================================
# Add the subdirectories with their projects in them
# ===========================================================================

SETUP_wxLua() # all libraries are built with these settings

function (wxLua_Binding_TARGETS)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxlua/wxlua_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxlua/wxlua_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxlua/wxlua_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxlua/wxlua_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxlua/override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxlua/wxlua.i

  COMMAND lua "-erulesFilename=\"wxlua/wxlua_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxluadebugger_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxlua_debugger/wxluadebugger_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxluadebugger_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxlua_debugger/wxluadebugger_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxlua_debugger/override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxlua_debugger/wxluadebugger.i

  COMMAND lua "-erulesFilename=\"wxlua_debugger/wxluadebugger_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_datatypes.lua
    ${wxLua_ROOT_DIR}/include/wxbind/wxbase_bind.h
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxbase_base.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxbase_bind.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxbase_config.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxbase_data.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxbase_datetime.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxbase_file.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_rules.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_base.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_config.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_data.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_datetime.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_file.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_override.hpp

  COMMAND lua "-erulesFilename=\"wxwidgets/wxbase_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
    ${wxLua_ROOT_DIR}/include/wxbind/wxcore_bind.h
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_appframe.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_bind.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_clipdrag.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_controls.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_core.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_defsutils.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_dialogs.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_event.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_gdi.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_geometry.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_graphics.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_help.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_image.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_mdi.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_menutool.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_picker.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_print.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_sizer.cpp
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxcore_windows.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_rules.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_appframe.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_clipdrag.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_controls.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_core.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_defsutils.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_dialogs.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_event.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_gdi.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_geometry.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_graphics.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_help.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_image.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_mdi.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_menutool.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_picker.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_print.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_sizer.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_windows.i

  COMMAND lua "-erulesFilename=\"wxwidgets/wxcore_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxadv_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxadv_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxadv_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxadv_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxadv_adv.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxadv_dataview.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxadv_dvrenderers.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxadv_grid.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxadv_override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua

  COMMAND lua "-erulesFilename=\"wxwidgets/wxadv_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxaui_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxaui_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxaui_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxaui_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxaui_aui.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxaui_override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua

  COMMAND lua "-erulesFilename=\"wxwidgets/wxaui_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxgl_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxgl_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxgl_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxgl_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
	  ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxgl_gl.i

  COMMAND lua "-erulesFilename=\"wxwidgets/wxgl_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxhtml_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxhtml_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxhtml_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxhtml_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxhtml_html.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxhtml_override.hpp

  COMMAND lua "-erulesFilename=\"wxwidgets/wxhtml_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxmedia_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxmedia_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxmedia_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxmedia_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxnet_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxmedia_media.i

  COMMAND lua "-erulesFilename=\"wxwidgets/wxmedia_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxnet_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxnet_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxnet_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxnet_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxnet_net.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxnet_override.hpp

  COMMAND lua "-erulesFilename=\"wxwidgets/wxnet_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxpropgrid_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxpropgrid_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxpropgrid_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxpropgrid_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxpropgrid_override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxpropgrid_propgrid.i

  COMMAND lua "-erulesFilename=\"wxwidgets/wxpropgrid_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxrichtext_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxrichtext_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_print.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_richtext.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_style.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_symboldlg.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_xml.i
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxml_datatypes.lua

  COMMAND lua "-erulesFilename=\"wxwidgets/wxrichtext_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxstc_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxstc_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxstc_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxstc_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxstc_override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxstc_stc.i

  COMMAND lua "-erulesFilename=\"wxwidgets/wxstc_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxwebview_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxwebview_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxwebview_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxwebview_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
	  ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxwebview_webview.i

  COMMAND lua "-erulesFilename=\"wxwidgets/wxwebview_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxxml_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxml_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxxml_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxml_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_datatypes.lua
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxml_override.hpp
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxml_xml.i

  COMMAND lua "-erulesFilename=\"wxwidgets/wxxml_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    ${wxLua_ROOT_DIR}/include/wxbind/wxxrc_bind.h
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxrc_datatypes.lua
    ${wxLua_ROOT_DIR}/modules/wxbind/src/wxxrc_bind.cpp

  DEPENDS
    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxrc_rules.lua

    ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua
	  ${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxrc_xrc.i

  COMMAND lua "-erulesFilename=\"wxwidgets/wxxrc_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

add_custom_command(
  OUTPUT
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wx_datatypes.lua"

  DEPENDS
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxdatatypes_rules.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxadv_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxaui_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxbase_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxcore_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxgl_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxhtml_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxmedia_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxnet_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxpropgrid_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxrichtext_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxstc_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxwebview_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxml_datatypes.lua"
    "${wxLua_ROOT_DIR}/bindings/wxwidgets/wxxrc_datatypes.lua"

  COMMAND lua "-erulesFilename=\"wxwidgets/wxdatatypes_rules.lua\"" genwxbind.lua
  WORKING_DIRECTORY "${wxLua_ROOT_DIR}/bindings/"
  VERBATIM
)

endfunction()

if (DEFINED wxLuaBind_WXLUASETUP_DIR)
include_directories(${wxLuaBind_WXLUASETUP_DIR})
endif()

include_directories("${wxLua_ROOT_DIR}/include")

if (NOT TARGET wxLuaLib)
    add_subdirectory( modules/ )
endif()

if (NOT TARGET wxLuaCan)
    add_subdirectory( apps/ )
endif()

if (NOT TARGET wxLuaBindings)
    add_subdirectory( bindings/ )
endif()

# ===========================================================================
# Export and install the CMake export files
# ===========================================================================

export( TARGETS ${LuaLib_Export} wxLuaLib wxLuaDebugLib wxLuaDebuggerLib ${wxLuaBind_ALL_LIBS}
        FILE "${CMAKE_BINARY_DIR}/build/wxLuaConfig.cmake")

# We need to add the system LuaLib to the export list by hand since CMake
# gives an error if an imported LuaLib is added to export()
if ("${LuaLib_Export}" STREQUAL "")
    file( APPEND "${CMAKE_BINARY_DIR}/build/wxLuaConfig.cmake"
"\n
# Create imported target LuaLib
ADD_LIBRARY(LuaLib UNKNOWN IMPORTED)
# Import target \"LuaLib\"
SET_TARGET_PROPERTIES(LuaLib PROPERTIES IMPORTED_LOCATION \"${wxLua_LUA_LIBRARY}\")
\n")
endif()

file( APPEND "${CMAKE_BINARY_DIR}/build/wxLuaConfig.cmake"
"\n
# ---------------------------------------------------------------------------
# Add the compiler flags in the variable wxLua_CXX_DEFINITIONS to your target
# or call the SETUP_wxLua() macro in any directory that has targets that #include
# macros in modules/wxbind/include/wxbinddefs.h to setup wxLua's wxWidgets bindings.
set(wxLua_CXX_DEFINITIONS \"${wxLua_CXX_DEFINITIONS}\")
macro(SETUP_wxLua)
    add_definitions(\${wxLua_CXX_DEFINITIONS})
endmacro(SETUP_wxLua)
")

install(EXPORT wxLua_export
        DESTINATION share/wxlua/
        FILE wxLuaConfig.cmake)

# ===========================================================================
# Install the remaining files
# ===========================================================================

if (WIN32)
    set(WXLUA_SHARE_DIR "")
else()
    set(WXLUA_SHARE_DIR "share/wxlua/")
endif()

if (WIN32 AND wxLua_LUA_LIBRARY_USE_BUILTIN AND NOT wxLua_LUA_LIBRARY_BUILD_SHARED)
    install(FILES
            ${wxLua_ROOT_DIR}/modules/luaproxydll/lua${wxLua_LUA_LIBRARY_VERSION_NUM}.dll
            ${wxLua_ROOT_DIR}/modules/luaproxydll/lua${wxLua_LUA_LIBRARY_VERSION}.dll
            DESTINATION "bin")
endif()

install(DIRECTORY   "${wxLua_ROOT_DIR}/docs/"
        DESTINATION "${WXLUA_SHARE_DIR}doc/wxLua"
        FILES_MATCHING
        PATTERN "*.md" PATTERN "*.html"
        PATTERN "CVS"     EXCLUDE
        PATTERN ".svn"    EXCLUDE
        PATTERN "doxygen" EXCLUDE)

install(DIRECTORY   "${wxLua_ROOT_DIR}/samples/"
        DESTINATION "${WXLUA_SHARE_DIR}samples"
        PATTERN "CVS"  EXCLUDE
        PATTERN ".svn" EXCLUDE)

install(FILES
        ${wxLuaBindLib_HEADER_FILES}                # set by ADD_LIBRARY_FULL()
        DESTINATION "include/wxlua/wxbind/include")

install(FILES
        ${wxLua_ROOT_DIR}/bindings/wxwidgets/wx_datatypes.lua
        DESTINATION "share/wxlua/bindings")

if (wxLua_LUA_LIBRARY_USE_BUILTIN)
    install(FILES
            ${wxLua_LUA_ROOT_DIR}/src/lauxlib.h
            ${wxLua_LUA_ROOT_DIR}/src/luaconf.h
            ${wxLua_LUA_ROOT_DIR}/src/lua.h
            ${wxLua_LUA_ROOT_DIR}/src/lualib.h
            DESTINATION "include/wxlua/lua")
endif(wxLua_LUA_LIBRARY_USE_BUILTIN)

install(FILES
        ${wxLua_ROOT_DIR}/include/wxlua/atomic.h
        ${wxLua_ROOT_DIR}/include/wxlua/sharedptr.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxlbind.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxlcallb.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxlconsole.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxldefs.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxllua.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxlobject.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxlstate.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxlua.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxlua_bind.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxlversion.h
        ${wxLua_ROOT_DIR}/include/wxlua/wxluasetup-defaults.h
        DESTINATION "include/wxlua")

install(FILES
        ${wxLua_ROOT_DIR}/include/wxlua/wxluasetup.h
        DESTINATION "include")

install(FILES
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/wxldebug.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/wxlstack.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debug/wxluadebugdefs.h
        DESTINATION "include/wxlua/debug")

install(FILES
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxldserv.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxldtarg.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxlsock.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxluadebugger_bind.h
        ${wxLua_ROOT_DIR}/modules/wxlua/debugger/wxluadebuggerdefs.h
        DESTINATION "include/wxlua/debugger")

install(FILES
        ${wxLua_ROOT_DIR}/apps/wxluacan/scripts/incircles.lua
        DESTINATION "${WXLUA_SHARE_DIR}apps/wxluacan")

install(FILES
        ${wxLua_ROOT_DIR}/apps/wxluafreeze/readme.txt
        ${wxLua_ROOT_DIR}/apps/wxluafreeze/wxluafreeze.lua
        DESTINATION "${WXLUA_SHARE_DIR}apps/wxluafreeze")

# ===========================================================================
# Setup the CPack distribution
# ===========================================================================

SET(CPACK_GENERATOR "ZIP")

SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "wxLua")
SET(CPACK_PACKAGE_VENDOR              "John Labenski")
SET(CPACK_PACKAGE_DESCRIPTION_FILE    "${CMAKE_CURRENT_SOURCE_DIR}/docs/readme.txt")
SET(CPACK_RESOURCE_FILE_LICENSE       "${CMAKE_CURRENT_SOURCE_DIR}/docs/licence.txt")
SET(CPACK_PACKAGE_VERSION_MAJOR       "${wxLua_MAJOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_MINOR       "${wxLua_MINOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_PATCH       "${wxLua_RELEASE_VERSION}")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY   "wxLua-${wxLua_VERSION}")
IF(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backslasshes.
  SET(CPACK_PACKAGE_ICON             "${CMAKE_CURRENT_SOURCE_DIR}/art\\\\wxlualogo.png")
  SET(CPACK_NSIS_INSTALLED_ICON_NAME "/art\\\\wxlualogo.png")
  SET(CPACK_NSIS_DISPLAY_NAME        "${CPACK_PACKAGE_INSTALL_DIRECTORY} wxLua")
  SET(CPACK_NSIS_HELP_LINK           "http:\\\\\\\\wxlua.sourceforge.com")
  SET(CPACK_NSIS_URL_INFO_ABOUT      "http:\\\\\\\\wxlua.sourceforge.com")
  SET(CPACK_NSIS_CONTACT             "wxlua-users@lists.sourceforge.net")
  SET(CPACK_NSIS_MODIFY_PATH         ON)
ELSE(WIN32 AND NOT UNIX)
  #SET(CPACK_STRIP_FILES "bin/MyExecutable")
  SET(CPACK_SOURCE_STRIP_FILES "")
ENDIF(WIN32 AND NOT UNIX)

#SET(CPACK_PACKAGE_EXECUTABLES "MyExecutable" "My Executable")
INCLUDE(CPack)

