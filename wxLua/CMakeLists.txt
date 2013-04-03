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

include( build/CMakewxAppLib.cmake )
include( build/CMakeFunctions.txt )

# ===========================================================================
# wxLua version
# ===========================================================================

set( wxLua_VERSION         "2.8.12" )
set( wxLua_MAJOR_VERSION   "2" )
set( wxLua_MINOR_VERSION   "8" )
set( wxLua_RELEASE_VERSION "12" )

# ===========================================================================
# wxWidgets libraries and wxLua bindings setup
# ===========================================================================

# ---------------------------------------------------------------------------
# Find and setup the wxWidgets library
# ---------------------------------------------------------------------------

# Specify what wxWidgets libs we need to link to. Note: 'core' must be before 'base'.
# If this CMakeLists.txt was called from another, FIND_WXWIDGETS() may have already been called.
if (NOT DEFINED wxWidgets_COMPONENTS)
    set(wxWidgets_COMPONENTS xrc xml net media propgrid richtext aui stc html adv core base)     # complete set for static lib/dll
    #set(wxWidgets_COMPONENTS gl xrc xml net media propgrid richtext aui stc html adv core base) # for multilib/dll
    #set(wxWidgets_COMPONENTS stc mono) # for monolithic
endif()

FIND_WXWIDGETS(wxWidgets_COMPONENTS) # Ok to call multiple times
# CMake's wxWidgets include that will configure the build in this dir and sub-dirs
include( "${wxWidgets_USE_FILE}" )

# ---------------------------------------------------------------------------
# Setup the location of the customizable wxluasetup.h file
# ---------------------------------------------------------------------------

if (NOT DEFINED wxLuaBind_WXLUASETUP_DIR)
    set(wxLuaBind_WXLUASETUP_DIR "${wxLua_ROOT_DIR}/modules/wxbind/setup")
endif()
set(wxLuaBind_WXLUASETUP_DIR ${wxLuaBind_WXLUASETUP_DIR} CACHE PATH 
    "Path to wxLua's wxWidgets binding wxluasetup.h setup file." FORCE)

if (NOT EXISTS "${wxLuaBind_WXLUASETUP_DIR}")
    MESSAGE(FATAL_ERROR "wxLuaBind_WXLUASETUP_DIR points to a non-existant path: '${wxLuaBind_WXLUASETUP_DIR}', the default is '${wxLua_ROOT_DIR}/modules/wxbind/setup'.")
endif()

# ---------------------------------------------------------------------------
# Setup what wxWidgets libraries wxLua will make bindings for and link to.
# This is done at the root CMakeLists since we need to call
# add_definitions(-DwxLUA_USEBINDING...) for both the modules/ and the apps/.
# ---------------------------------------------------------------------------

# This is the list of all the wxLua bindings for wxWidgets with the same names as the wxWidgets libs.
set(wxLuaBind_ALL_COMPONENTS gl stc xrc richtext html media aui adv core xml net base )

if (NOT DEFINED wxLuaBind_COMPONENTS)
    set(wxLuaBind_COMPONENTS ${wxLuaBind_ALL_COMPONENTS})
endif()
set(wxLuaBind_COMPONENTS ${wxLuaBind_COMPONENTS} CACHE STRING 
    "wxWidgets libs wxLua should build bindings for, choose from '${wxLuaBind_ALL_COMPONENTS}', the wxWidgets_COMPONENTS must contain all of these." FORCE)

# We will create this list of the source files to compile in the next section.
set(wxLuaBindLib_SOURCES "" CACHE INTERNAL "")
# These are the wxLua compiler definitions, see SETUP_wxLua().
set(wxLua_CXX_DEFINITIONS)

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

set(wxLua_CXX_DEFINITIONS "${wxLua_CXX_DEFINITIONS}" CACHE INTERNAL 
    "wxLua C++ compiler flags to include/exclude wxLua binding libs" FORCE)

# ---------------------------------------------------------------------------
# This function must be called in any other CMakeLists.txt for projects that 
# use any wxLua headers to ensure that the compiler #defines are correct.
# ---------------------------------------------------------------------------

macro(SETUP_wxLua)
    # These have to be defined so that the macros in modules/wxbind/include/wxbinddefs.h work
    add_definitions(${wxLua_CXX_DEFINITIONS})
endmacro()

SETUP_wxLua()

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

if ((NOT "${wxLua_LUA_LIBRARY_VERSION}" STREQUAL "5.1") AND (NOT "${wxLua_LUA_LIBRARY_VERSION}" STREQUAL "5.2"))
    MESSAGE(FATAL_ERROR "wxLua_LUA_LIBRARY_VERSION may only be set to '5.1' or '5.2'")
endif()

if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.1)
    set(wxLua_LUA_LIBRARY_VERSION_NUM 51)
else()
    set(wxLua_LUA_LIBRARY_VERSION_NUM 52)
endif()

if (NOT DEFINED wxLua_LUA_INCLUDE_DIR)
    set(wxLua_LUA_INCLUDE_DIR )
endif()
if (NOT DEFINED wxLua_LUA_LIBRARY)
    set(wxLua_LUA_LIBRARY )
endif()

if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.2)
    add_definitions( -DLUA_COMPAT_ALL ) # Match build used in default 5.2 Makefile
endif()

if (NOT wxLua_LUA_LIBRARY_USE_BUILTIN)
    # They can enter these by hand so don't overwrite them if they're already valid
    if (NOT EXISTS "${wxLua_LUA_LIBRARY}") # OR (NOT EXISTS "${wxLua_LUA_INCLUDE_DIR}"))
        message(STATUS "* wxLua attempting to automatically find an external Lua ${wxLua_LUA_LIBRARY_VERSION} library.")

        if (${wxLua_LUA_LIBRARY_VERSION} VERSION_EQUAL 5.1)
            FIND_PACKAGE(Lua51)
        else()
            FIND_PACKAGE(Lua52)
        endif()
        
        if (LUA51_FOUND OR LUA52_FOUND)
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
        set(wxLua_LUA_ROOT_DIR "${wxLua_ROOT_DIR}/modules/lua-5.2")
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
    set(wxLua_proxydlls_to_not_copy "lua51.dll" "lua5.1.dll" "lua52.dll" "lua5.2.dll")

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
            set(wxLua_proxydlls_to_not_copy "lua52.dll" "lua5.2.dll")
        else()
            set(wxLua_proxydlls_to_not_copy "lua51.dll" "lua5.1.dll")
        endif()
    endif()

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

if (NOT TARGET wxStEditLib)
    add_subdirectory( modules/wxstedit )
endif()

include_directories(${wxLuaBind_WXLUASETUP_DIR})

if (NOT TARGET wxLuaLib)
    add_subdirectory( modules/ )
endif()

if (NOT TARGET wxLuaCan)
    add_subdirectory( apps/ )
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
# Import target "LuaLib"
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
        PATTERN "*.txt" PATTERN "*.html"
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
        DESTINATION "include/wxlua")

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
