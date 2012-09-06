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

# ===========================================================================
# wxWidgets libraries and wxLua bindings setup
# ===========================================================================

# Specify what wxWidgets libs we need to link to. Note: 'core' must be before 'base'.
# If you call this CMakeLists.txt from another one you may have already called FIND_WXWIDGETS()
if (NOT DEFINED wxWidgets_COMPONENTS)
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
set(wxLuaBind_COMPONENTS ${wxLuaBind_COMPONENTS} CACHE STRING "wxWidgets libs wxLua should build bindings for, choose from '${wxLuaBind_ALL_COMPONENTS}', the wxWidgets_COMPONENTS must contain all of these." FORCE)

# We will create a list of the source files needed to compile
set(wxLuaBindLib_SOURCES)
# These are the definitions that in your CMake project you can call add_definitions() with.
set(wxLua_CXX_DEFINITIONS "" CACHE INTERNAL "C++ compiler flags to include/exclude wxLua binding libs" FORCE)

# verify that each library exists from finding wxWidgets in the wxWidgets_COMPONENTS
foreach( wxlua_comp ${wxLuaBind_ALL_COMPONENTS} )
    string(TOUPPER ${wxlua_comp} wxlua_comp_upper)

    # find specified wxlua binding libs
    string(REGEX MATCH ${wxlua_comp} wxlua_comp_found "${wxLuaBind_COMPONENTS}")
    # find specified wxlua binding libs in the wxwidgets libs
    string(REGEX MATCH ${wxlua_comp} wx_comp_found "${wxWidgets_COMPONENTS}")

    # assume that the monolithic wxWidgets lib has everything
    if (NOT wx_comp_found)
        string(REGEX MATCH "mono" wx_comp_found "${wxWidgets_COMPONENTS}")
    endif()

    if (("${wxlua_comp}" STREQUAL "${wxlua_comp_found}") AND wx_comp_found) # ("${wxlua_comp}" STREQUAL "${wx_comp_found}"))
        set(WXLUA_BINDTO_${wxlua_comp} TRUE CACHE INTERNAL "")
        set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} "-DwxLUA_USEBINDING_WX${wxlua_comp_upper}=1")
        set(wxLuaBindLib_SOURCES ${wxLuaBindLib_SOURCES} "src/wx${wxlua_comp}_*.cpp")
    else()
        #if (("${wxlua_comp}" STREQUAL "${wxlua_comp_found}") AND (NOT "${wxlua_comp}" STREQUAL "${wx_comp_found}"))
            message(STATUS "* WARNING: Specified wxLuaBinding lib '${wxlua_comp}' in variable wxLuaBind_COMPONENTS is missing from wxWidgets_COMPONENTS so it will not be compiled.")
        #endif()

        set(WXLUA_BINDTO_${wxlua_comp} FALSE CACHE INTERNAL "")
        set(wxLua_CXX_DEFINITIONS ${wxLua_CXX_DEFINITIONS} "-DwxLUA_USEBINDING_WX${wxlua_comp_upper}=0")
    endif()
endforeach()

set(wxLua_CXX_DEFINITIONS "${wxLua_CXX_DEFINITIONS}" CACHE INTERNAL "C++ compiler flags to include/exclude wxLua binding libs" FORCE)

# ---------------------------------------------------------------------------
# This function must be called in any other CMakeLists that uses any wxLua
# headers to ensure that the compiler #defines are correct.
# ---------------------------------------------------------------------------

macro(SETUP_wxLua)
    # These have to be defined so that the macros in modules/wxbind/include/wxbinddefs.h work
    add_definitions(${wxLua_CXX_DEFINITIONS})
endmacro()

SETUP_wxLua()

# ===========================================================================
# wxLua specific setup
# ===========================================================================

set( wxLua_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "Root dir of wxLua" FORCE)

set( wxLua_VERSION         "2.8.12" )
set( wxLua_MAJOR_VERSION   "2" )
set( wxLua_MINOR_VERSION   "8" )
set( wxLua_RELEASE_VERSION "12" )

# ---------------------------------------------------------------------------

set( MACOSX_BUNDLE_INFO_STRING          "wxLua")
set( MACOSX_BUNDLE_ICON_FILE            "wxlualogo.icns")
set( MACOSX_BUNDLE_GUI_IDENTIFIER       )
set( MACOSX_BUNDLE_LONG_VERSION_STRING  "wxLua ${wxLua_VERSION}, built with wxWidgets ${wxWidgets_VERSION}")
set( MACOSX_BUNDLE_BUNDLE_NAME          )
set( MACOSX_BUNDLE_SHORT_VERSION_STRING "${wxLua_VERSION}")
set( MACOSX_BUNDLE_BUNDLE_VERSION       "${wxLua_VERSION}")
set( MACOSX_BUNDLE_COPYRIGHT            "(2012) John Labenski, et al.")

# ---------------------------------------------------------------------------

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
# Configure the Lua lib to an imported lib or to be built from the provided sources.
# Note that CMake requires that we declare it here, rather than the modules dir,
# to be useable in the apps subdirectory.
# ===========================================================================

if (NOT DEFINED wxLua_LUA_LIBRARY_USE_BUILTIN)
    set(wxLua_LUA_LIBRARY_USE_BUILTIN TRUE)
endif()
set(wxLua_LUA_LIBRARY_USE_BUILTIN ${wxLua_LUA_LIBRARY_USE_BUILTIN} CACHE BOOL "Use the built-in Lua 5.1 library, else try to find a system or external Lua library, see wxLua_LUA_INCLUDE_DIR and wxLua_LUA_LIBRARY" FORCE)

if (NOT wxLua_LUA_LIBRARY_USE_BUILTIN)
    # They can enter these by hand so don't overwrite them if they're already valid
    if ((NOT EXISTS "${wxLua_LUA_LIBRARY}") OR (NOT EXISTS "${wxLua_LUA_INCLUDE_DIR}"))
        FIND_PACKAGE(Lua51)

        if (LUA51_FOUND)
            set(wxLua_LUA_INCLUDE_DIR ${LUA_INCLUDE_DIR})
            set(wxLua_LUA_LIBRARY     ${LUA_LIBRARY})
        endif()
    endif()

    message(STATUS "* wxLua using external/system Lua library :")
    message(STATUS "*   - include dir : ${wxLua_LUA_INCLUDE_DIR}")
    message(STATUS "*   - library     : ${wxLua_LUA_LIBRARY}")

    if ((NOT EXISTS "${wxLua_LUA_LIBRARY}") OR (NOT EXISTS "${wxLua_LUA_INCLUDE_DIR}"))
        message(ERROR " An external/system Lua51 library was requested, but not found.\nPlease set or correct the variables wxLua_LUA_INCLUDE_DIR and wxLua_LUA_LIBRARY to specify an external Lua library.")
    endif()

    add_library(LuaLib UNKNOWN IMPORTED)
    set_target_properties(LuaLib PROPERTIES IMPORTED_LOCATION ${wxLua_LUA_LIBRARY})

    add_library(LuaLibShared UNKNOWN IMPORTED)
    set_target_properties(LuaLibShared PROPERTIES IMPORTED_LOCATION ${wxLua_LUA_LIBRARY})

    set(LuaLib_Export) # Cmake only allows exporting targets that we build

else() # Use the built-in Lua library

    message(STATUS "* wxLua using built-in Lua51 library")

    set(wxLua_LUA_INCLUDE_DIR "${wxLua_ROOT_DIR}/modules/lua/src")
    set(wxLua_LUA_LIBRARY     "")

    set(LuaLib_Export LuaLib) # Cmake only allows exporting targets that we build

endif()

if (NOT DEFINED wxLua_LUA_INCLUDE_DIR)
    set(wxLua_LUA_INCLUDE_DIR )
endif()
set(wxLua_LUA_INCLUDE_DIR ${wxLua_LUA_INCLUDE_DIR} CACHE PATH "Set the location of an external Lua library's include directory, else leave blank to use the built-in Lua lib" FORCE )

if (NOT DEFINED wxLua_LUA_LIBRARY)
    set(wxLua_LUA_LIBRARY )
endif()
set(wxLua_LUA_LIBRARY ${wxLua_LUA_LIBRARY} CACHE FILEPATH "Set the location of an external Lua library to link to (E.G. lua51.so), else leave blank to use the built-in Lua lib" FORCE )

# ===========================================================================
# We can build everything but the Lua library staticly.
# You need to have a shared Lua library to require() other modules,
# however, having the extra shared lib is annoying to drag around if unneeded.
# ===========================================================================

if (NOT DEFINED wxLua_LUA_LIBRARY_BUILD_SHARED)
    set(wxLua_LUA_LIBRARY_BUILD_SHARED )
endif()
set(wxLua_LUA_LIBRARY_BUILD_SHARED ${wxLua_LUA_LIBRARY_BUILD_SHARED} CACHE BOOL "Build the built-in Lua library as a shared library regardless of the BUILD_SHARED_LIBS setting" FORCE )

if (wxLua_LUA_LIBRARY_BUILD_SHARED)
    set(wxLua_LUA_LIBRARY_BUILD_SHARED_FLAG SHARED)
endif()

# ===========================================================================
# Add subdirectories containing CMakeLists.txt files or specify projects
# ===========================================================================

if (WIN32)
    # In msw these are the shared lua51.dlls we'll use.
    # The LuaLibShared is built into bin/Debug/shared/* so it won't conflict.
    CONFIGURE_FILE_TO_BUILD_CONFIGURATION_DIRS( lua51.dll
                                                ${wxLua_ROOT_DIR}/modules/luaproxydll
                                                ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
                                                COPYONLY)
    CONFIGURE_FILE_TO_BUILD_CONFIGURATION_DIRS( lua5.1.dll
                                                ${wxLua_ROOT_DIR}/modules/luaproxydll
                                                ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
                                                COPYONLY)
endif()

add_subdirectory( wxstedit )

include_directories(${wxLua_ROOT_DIR}/modules/wxbind/setup)

if (NOT TARGET wxLuaLib)
    add_subdirectory( modules/ )
endif()

if (NOT TARGET wxLuaCan)
    add_subdirectory( apps/ )
endif()

# ===========================================================================
# Export and install the CMake export files
# ===========================================================================

export( TARGETS ${LuaLib_Export} wxLuaLib wxLuaDebugLib wxLuaSocketLib wxLuaBindLib ${LuaLibShared_export_name}
        FILE "${CMAKE_BINARY_DIR}/build/wxLua-config.cmake")

file( APPEND "${CMAKE_BINARY_DIR}/build/wxLua-config.cmake"
"\n
# ---------------------------------------------------------------------------
# Add the compiler flags in the variable wxLua_CXX_DEFINITIONS to your target
# or call the SETUP_wxLua() macro in any directory that has targets that use the
# macros in modules/wxbind/include/wxbinddefs.h to initialize the wxWidgets bindings.
set(wxLua_CXX_DEFINITIONS \"${wxLua_CXX_DEFINITIONS}\")
macro(SETUP_wxLua)
    add_definitions(\${wxLua_CXX_DEFINITIONS})
endmacro(SETUP_wxLua)
")

install(EXPORT wxLua_export
        DESTINATION share/wxlua/
        FILE wxLua-config.cmake)

# ===========================================================================
# Install the remaining files
# ===========================================================================

if (WIN32)
    set(WXLUA_SHARE_DIR "")
else()
    set(WXLUA_SHARE_DIR "share/wxlua/")
endif()

if (WIN32)
    install(FILES
            ${wxLua_ROOT_DIR}/modules/luaproxydll/lua51.dll
            ${wxLua_ROOT_DIR}/modules/luaproxydll/lua5.1.dll
            DESTINATION "bin")
endif()

install(DIRECTORY   "${wxLua_ROOT_DIR}/docs/"
        DESTINATION "${WXLUA_SHARE_DIR}doc/wxLua"
        FILES_MATCHING
        PATTERN "*.txt" PATTERN "*.html"
        PATTERN "CVS" EXCLUDE
        PATTERN ".svn" EXCLUDE
        PATTERN "doxygen" EXCLUDE)

install(DIRECTORY   "${wxLua_ROOT_DIR}/samples/"
        DESTINATION "${WXLUA_SHARE_DIR}samples"
        PATTERN "CVS" EXCLUDE
        PATTERN ".svn" EXCLUDE)

install(FILES
        ${wxLuaBindLib_HEADER_FILES}                # set by ADD_LIBRARY_FULL()
        DESTINATION "include/wxlua/wxbind/include")

install(FILES
        ${wxLua_ROOT_DIR}/bindings/wxwidgets/wx_datatypes.lua
        DESTINATION "share/wxlua/bindings")

install(FILES
        ${wxLua_ROOT_DIR}/modules/lua/src/lauxlib.h
        ${wxLua_ROOT_DIR}/modules/lua/src/luaconf.h
        ${wxLua_ROOT_DIR}/modules/lua/src/lua.h
        ${wxLua_ROOT_DIR}/modules/lua/src/lualib.h
        DESTINATION "include/wxlua")

install(FILES
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlbind.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlcallb.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxldefs.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlstate.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlua.h
        ${wxLua_ROOT_DIR}/modules/wxlua/include/wxlua_bind.h
        DESTINATION "include/wxlua/wxlua/include")

install(FILES
        ${wxLua_ROOT_DIR}/modules/wxluadebug/include/wxldebug.h
        ${wxLua_ROOT_DIR}/modules/wxluadebug/include/wxlstack.h
        ${wxLua_ROOT_DIR}/modules/wxluadebug/include/wxluadebugdefs.h
        DESTINATION "include/wxlua/wxluadebug/include")

install(FILES
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxldserv.h
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxldtarg.h
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxlsock.h
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxluasocket_bind.h
        ${wxLua_ROOT_DIR}/modules/wxluasocket/include/wxluasocketdefs.h
        DESTINATION "include/wxlua/wxluasocket/include")

install(FILES
        ${wxLua_ROOT_DIR}/apps/wxluacan/scripts/incircles.lua
        DESTINATION "${WXLUA_SHARE_DIR}apps/wxluacan")

install(FILES
        ${wxLua_ROOT_DIR}/apps/wxluafreeze/src/readme.txt
        ${wxLua_ROOT_DIR}/apps/wxluafreeze/src/wxluafreeze.lua
        DESTINATION "${WXLUA_SHARE_DIR}apps/wxluafreeze")
