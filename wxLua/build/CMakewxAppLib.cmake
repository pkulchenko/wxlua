# ---------------------------------------------------------------------------
# CMakewxWidgets.txt - Initialize CMake for wxWidgets projects
#
# This file should be suitable for use with a variety of wxWidgets projects
# without modification.
#
# Usage: In your CMakeLists.txt write code along these lines:
#
# project( MyProject )
# include( CMakewxWidgets.txt )
# set(wxWidgets_COMPONENTS aui stc html adv core base)
# FIND_WXWIDGETS(${wxWidgets_COMPONENTS})
# add_library(myprojectlib file1.h file1.cpp)
# target_link_libraries(myprojectlib ${wxWidgets_LIBRARIES})
# add_executable(myprojectapp WIN32 file.h file.cpp)
# target_link_libraries(myprojectapp myprojectlib ${wxWidgets_LIBRARIES})
#
# ---------------------------------------------------------------------------

# General Notes:
# Prepend messages with a '*', e.g. message(STATUS "* blah blah) so we know
#   what our messages are versus messages from CMake.
# We try to not to modify already set values.

# ===========================================================================
# This file should only be called once during configuration, but the values
# are not cached so it needs to be be run for each configuration.
# Using properties does the trick of storing a variable per configuration run,
# accessible at all scopes, but having it cleared for the next run.
# ===========================================================================

get_property(PROP_CMAKEWXAPPLIB_RUN_ONCE GLOBAL PROPERTY CMAKEWXAPPLIB_RUN_ONCE SET)

if (PROP_CMAKEWXAPPLIB_RUN_ONCE)
    return()
endif()

set_property(GLOBAL PROPERTY CMAKEWXAPPLIB_RUN_ONCE TRUE)

# Backwards compat to CMake < 2.8.3
if ("${CMAKE_CURRENT_LIST_DIR}" STREQUAL "")
    get_filename_component(CMAKE_CURRENT_LIST_DIR
                           ${CMAKE_CURRENT_LIST_FILE} PATH ABSOLUTE)
endif()

set(CMakewxAppLib_LIST_DIR ${CMAKE_CURRENT_LIST_DIR})

# Load the helper file with additional functions
include( "${CMAKE_CURRENT_LIST_DIR}/CMakeFunctions.txt" )

# ===========================================================================
# Display to the caller what the options are that may be passed to
# CMake to control the build before we do anything.
# ===========================================================================

message( STATUS "* ---------------------------------------------------------------------------" )
message( STATUS "* CMake command line options and tips specific to this project " )
message( STATUS "* " )
message( STATUS "* In the CMake GUI you can set values and press configure a few times since " )
message( STATUS "* sometimes once is not enough, after a few configurations, press generate." )
message( STATUS "* " )
message( STATUS "* Usage: cmake -D[OPTION_NAME]=[OPTION_VALUE] /path/to/CMakeLists.txt/" )
message( STATUS "* ---------------------------------------------------------------------------" )
message( STATUS "* -DHELP=TRUE " )
message( STATUS "*   Show this help message and exit, no files will be generated." )
message( STATUS "* -DCMAKE_BUILD_TYPE=[Debug, Release, RelWithDebInfo, MinSizeRel] : (Default Debug)")
message( STATUS "*   Makefiles : Set the build type to Debug, Release..." )
message( STATUS "*   MSVC GUI  : No need to set this since you choose it in the GUI." )
message( STATUS "* -DBUILD_SHARED_LIBS=[TRUE, FALSE] : (Default static in MSW, shared in Linux)")
message( STATUS "*   Build shared (DLL) or static libraries." )
message( STATUS "*   Currently ONLY an all shared (DLL) or all static build is supported." )
message( STATUS "*   I.E. If you choose shared you must link to shared wxWidgets libs." )
message( STATUS "* ")
message( STATUS "* Finding wxWidgets for MSW and MSVC")
message( STATUS "* -DwxWidgets_ROOT_DIR=[path] : (e.g. /path/to/wxWidgets/)")
message( STATUS "*   Path to the root of the wxWidgets build, must at least set this." )
message( STATUS "* -DwxWidgets_LIB_DIR=[path] : (e.g. /path/to/wxWidgets/lib/vc_lib/)")
message( STATUS "*   Path to the wxWidgets lib dir also set this if libs can't be found." )
message( STATUS "* -DwxWidgets_CONFIGURATION=[configuration] : ")
message( STATUS "*   Set wxWidgets configuration; e.g. msw, mswu, mswunivu..." )
message( STATUS "*   Where 'u' = unicode and 'd' = debug." )
message( STATUS "*   MSVC GUI : You need only choose msw, mswu, mswuniv, mswunivu since " )
message( STATUS "*              release or debug mode is chosen in the GUI." )
message( STATUS "* -DwxWidgets_COMPONENTS=[...stc;html;adv;core;base or mono] : ")
message( STATUS "*   For non-monolithic builds choose the wxWidgets libs to link to.")
message( STATUS "*    xrc;xml;gl;net;media;propgrid;richtext;aui;stc;html;adv;core;base")
message( STATUS "*   For monolithic builds choose mono and the contribs libs.")
message( STATUS "*    stc;mono")
message( STATUS "*   The extra decorations, e.g. wxmsw28ud_adv.lib, will be searched for.")
message( STATUS "*   Libs that cannot be found will be printed below, please fix/remove")
message( STATUS "*   them to be able to build this project.")
message( STATUS "*   You will get strange compilation/linker errors if wxWidgets is not found.")
message( STATUS "* ")
message( STATUS "* Finding wxWidgets for GCC and Unix type systems")
message( STATUS "* -DwxWidgets_CONFIG_EXECUTABLE=[path/to/wx-config] : ")
message( STATUS "*   Specify path to wx-config script for GCC and Unix type builds" )
message( STATUS "* ---------------------------------------------------------------------------" )
message( STATUS " " )

if (HELP)
    unset(HELP CACHE) # do not cache this
    message(FATAL_ERROR "* Help shown, exiting...")
    return()
endif()

# ===========================================================================
# Create a script/batch file to easily open CMake-Gui in the proper dir
# ===========================================================================

if (UNIX)
    # We want to open it in the gui, not in the curses ccmake which is broken in the gnome terminal (RHEL6)
    get_filename_component(CMAKE_EDIT_COMMAND_PATH ${CMAKE_EDIT_COMMAND} PATH)

    if (EXISTS ${CMAKE_EDIT_COMMAND_PATH}/cmake-gui)
        set(CMAKE_EDIT_COMMAND2 ${CMAKE_EDIT_COMMAND_PATH}/cmake-gui)
    else()
        set(CMAKE_EDIT_COMMAND2 ${CMAKE_EDIT_COMMAND})
    endif()

    file(WRITE "${CMAKE_BINARY_DIR}/cmake-gui.sh"
         "cd \"${CMAKE_BINARY_DIR}\"\n"
         "${CMAKE_EDIT_COMMAND2} \"${CMAKE_HOME_DIRECTORY}\" &\n" )
    execute_process(COMMAND chmod a+x ${CMAKE_BINARY_DIR}/cmake-gui.sh)
else()
    file(WRITE "${CMAKE_BINARY_DIR}/cmake-gui.bat"
         "cd /D \"${CMAKE_BINARY_DIR}\"\n"
         "start \"Title\" \"${CMAKE_EDIT_COMMAND}\" \"${CMAKE_HOME_DIRECTORY}\"\n" )
endif()

# ===========================================================================
# General global settings for CMake
# ===========================================================================

# ---------------------------------------------------------------------------
# Enable use of folders in MSVC Gui to separate projects into logical groups
# It's so much nicer so you might as well always have it enabled.

if (NOT DEFINED BUILD_USE_SOLUTION_FOLDERS)
    set( BUILD_USE_SOLUTION_FOLDERS TRUE )
endif()

set( BUILD_USE_SOLUTION_FOLDERS ${BUILD_USE_SOLUTION_FOLDERS} CACHE BOOL "Use solution folders to group projects in MSVC Gui" FORCE)
set_property( GLOBAL PROPERTY USE_FOLDERS ${BUILD_USE_SOLUTION_FOLDERS} )

# ---------------------------------------------------------------------------
# Don't insist that everything needs to be built before being able to "install"

if (NOT DEFINED CMAKE_SKIP_INSTALL_ALL_DEPENDENCY)
    set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY TRUE)
endif()

set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY ${CMAKE_SKIP_INSTALL_ALL_DEPENDENCY} CACHE BOOL "Don't require all projects to be built in order to install" FORCE)

# ===========================================================================
# Build Settings
# ===========================================================================

# ---------------------------------------------------------------------------
# Show the "install" target dir in the CMake GUI so people can change it.
# ---------------------------------------------------------------------------

if (NOT DEFINED BUILD_INSTALL_PREFIX)
    # CMake defaults to C:/Program Files and /usr/local neither of which normal users have permissions to
    set( BUILD_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" )
endif()

# There is some weirdness between CMake versions showing (or not) CMAKE_INSTALL_PREFIX to the user
# Just show our own variable and hide theirs to smooth over the inconsistencies.
set( BUILD_INSTALL_PREFIX ${BUILD_INSTALL_PREFIX} CACHE PATH     "Install Directory prefix for INSTALL target" FORCE)
set( CMAKE_INSTALL_PREFIX ${BUILD_INSTALL_PREFIX} CACHE INTERNAL "Install Directory prefix for INSTALL target" FORCE)

# ---------------------------------------------------------------------------
# Default build is Debug, change on the command line with
# $cmake -DCMAKE_BUILD_TYPE=Release /path/to/CMakeLists.txt
# Possible options are "Debug, Release, RelWithDebInfo and MinSizeRel"
# ---------------------------------------------------------------------------

IF (DEFINED CMAKE_BUILD_TYPE)
    if(NOT CMAKE_BUILD_TYPE)
         MESSAGE(STATUS "* No build type was specified, using default 'Debug'")
         SET (CMAKE_BUILD_TYPE "Debug")
    ENDIF()
ELSE()
    MESSAGE(STATUS "* No build type was specified, using default 'Debug'")
    SET (CMAKE_BUILD_TYPE "Debug")
ENDIF()

# Sanity check - we don't handle any other build types
SET( CMAKE_BUILD_TYPES "Debug;Release;RelWithDebInfo;MinSizeRel" )
LIST(FIND CMAKE_BUILD_TYPES ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_valid)
if ("${CMAKE_BUILD_TYPE_valid}" EQUAL "-1")
    MESSAGE(FATAL_ERROR "Build type can ONLY be one of '${CMAKE_BUILD_TYPES}', but is set to '${CMAKE_BUILD_TYPE}'")
endif()

if (NOT MSVC)
    # This is used only for the Makefile generator.
    # In MSVC you can choose the build type in the IDE.
    SET(CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING "Set build type, options are one of ${CMAKE_BUILD_TYPES}" FORCE)
    if (${CMAKE_VERSION} VERSION_GREATER 2.8.0)
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${CMAKE_BUILD_TYPES})
    endif ()
endif ()

# Useful, since I cannot find a case-insensitive string comparison function
string(TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_UPPERCASE)

# We can use this later for the default MSVC library output directories, Debug and Release
IF ("${CMAKE_BUILD_TYPE_UPPERCASE}" STREQUAL "DEBUG")
    SET( CMAKE_BUILD_TYPE_CAPTIALIZED "Debug" )
ELSE() # All other build types are variants of release
    SET( CMAKE_BUILD_TYPE_CAPTIALIZED "Release" )
ENDIF()

# ---------------------------------------------------------------------------
# Set the default for CMake's add_library(target [STATIC/SHARED]) directive
# if [STATIC/SHARED] is not explicitly stated.
#
# We will use static libs in MSW and shared libs in Linux.
# If we use shared libs (DLLs) in MSW we would need to copy/move them so that
# the executables can find them. It's easier (for now) to build static libs.
#
# To override use: $cmake -DBUILD_SHARED_LIBS=[TRUE or FALSE] /path/to/CMakeLists.txt/
# ---------------------------------------------------------------------------

if( "${BUILD_SHARED_LIBS}" STREQUAL "" )
    if (WIN32)
        set(BUILD_SHARED_LIBS FALSE)
    else()
        set(BUILD_SHARED_LIBS TRUE)
    endif()
endif()

set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS} CACHE BOOL "Build shared libraries (TRUE) or static libraries (FALSE)" FORCE)

# Set if we are building DLLs, MSWindows and shared libraries
set(BUILD_SHARED_LIBS_WIN_DLLS FALSE CACHE INTERNAL "TRUE when building shared libs on MSW, else FALSE" FORCE)

if (BUILD_SHARED_LIBS) # CMake has problems with "if ("ON" AND "TRUE")"
    if (WIN32)
        set(BUILD_SHARED_LIBS_WIN_DLLS TRUE CACHE INTERNAL "TRUE when building shared libs on MSW, else FALSE" FORCE)
    endif()
endif()


# ---------------------------------------------------------------------------
# Specify where to put the built files. The default will put all the binaries,
# libs, and DLL's from different targets into the same dir.
# Normally each build runtime (exe,dll) and library/archive (libs) are put in
# the build/project/dir_with_CMakeLists.txt directory, so they're
# spread all over and it's hard to find/run them unless you already know
# about them.
# ---------------------------------------------------------------------------

if (NOT DEFINED BUILD_OUTPUT_DIRECTORY_RUNTIME)
    set(BUILD_OUTPUT_DIRECTORY_RUNTIME ${CMAKE_BINARY_DIR}/bin)
endif()
if (NOT DEFINED BUILD_OUTPUT_DIRECTORY_LIBRARY)
    set(BUILD_OUTPUT_DIRECTORY_LIBRARY ${CMAKE_BINARY_DIR}/lib)
endif()
if (NOT DEFINED BUILD_OUTPUT_DIRECTORY_ARCHIVE)
    set(BUILD_OUTPUT_DIRECTORY_ARCHIVE ${CMAKE_BINARY_DIR}/lib)
endif()

if (MSVC)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BUILD_OUTPUT_DIRECTORY_RUNTIME}) # + /Debug/Release/...
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${BUILD_OUTPUT_DIRECTORY_LIBRARY}) # + /Debug/Release/...
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${BUILD_OUTPUT_DIRECTORY_ARCHIVE}) # + /Debug/Release/...
else() # MSW
    # Put into Debug/Release/... subdirs to mimic MSVC appending dirs
    # We need this so that relative paths from exe to data files are correct on both platforms
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BUILD_OUTPUT_DIRECTORY_RUNTIME}/${CMAKE_BUILD_TYPE})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${BUILD_OUTPUT_DIRECTORY_LIBRARY}/${CMAKE_BUILD_TYPE})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${BUILD_OUTPUT_DIRECTORY_ARCHIVE}/${CMAKE_BUILD_TYPE})
endif()

# To simplify logic - if these were blank then unset the CMAKE_XXX vars to get default behavior
if ("${BUILD_OUTPUT_DIRECTORY_RUNTIME}" STREQUAL "")
    unset(CMAKE_RUNTIME_OUTPUT_DIRECTORY)
endif()
if ("${BUILD_OUTPUT_DIRECTORY_LIBRARY}" STREQUAL "")
    unset(CMAKE_LIBRARY_OUTPUT_DIRECTORY)
endif()
if ("${BUILD_OUTPUT_DIRECTORY_ARCHIVE}" STREQUAL "")
    unset(CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
endif()

set(BUILD_OUTPUT_DIRECTORY_RUNTIME ${BUILD_OUTPUT_DIRECTORY_RUNTIME} CACHE PATH "Dir to put all built executables, blank to output to each project dir." FORCE)
set(BUILD_OUTPUT_DIRECTORY_LIBRARY ${BUILD_OUTPUT_DIRECTORY_LIBRARY} CACHE PATH "Dir to put all built libraries, blank to output to each project dir." FORCE)
set(BUILD_OUTPUT_DIRECTORY_ARCHIVE ${BUILD_OUTPUT_DIRECTORY_ARCHIVE} CACHE PATH "Dir to put all built libraries, blank to output to each project dir." FORCE)

# ---------------------------------------------------------------------------
# RPath options to allow execution of Linux programs in the build tree to
# find the shared libraries both in the build tree and those outside your project.
# When installing, all executables and shared libraries will be relinked to find all libraries they need.
# See: http://www.vtk.org/Wiki/CMake_RPATH_handling
# ---------------------------------------------------------------------------

# Use, i.e. don't skip the full RPATH for the build tree
if (NOT DEFINED CMAKE_SKIP_BUILD_RPATH)
    set(CMAKE_SKIP_BUILD_RPATH FALSE)
endif()

# Set the RPATH to the build directory not the install directory. (FALSE below)
# The install target will relink with the install directory as the RPATH so it will work there too.
if (NOT DEFINED CMAKE_BUILD_WITH_INSTALL_RPATH)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
endif()

# Set the RPATH to be used for the install target
if (NOT DEFINED CMAKE_INSTALL_RPATH)
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
endif()

# Add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
if (NOT DEFINED CMAKE_INSTALL_RPATH_USE_LINK_PATH)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
endif()

# ----------------------------------------------------------------------------
# Turn on verbose Makefiles so Eclipse can discover -I include paths for
# external libs instead of defaulting to /usr/include.
# Also works for MSVC so you don't have to look at the BuildLog file.

if (NOT DEFINED BUILD_VERBOSELY)
    set(BUILD_VERBOSELY FALSE )
endif()

set( BUILD_VERBOSELY        ${BUILD_VERBOSELY} CACHE BOOL "Verbose compiler build output (enable if using Eclipse to help it discover paths)" FORCE)
set( CMAKE_VERBOSE_MAKEFILE ${BUILD_VERBOSELY} CACHE BOOL "Verbose build output (set by BUILD_VERBOSELY)" FORCE)

# ---------------------------------------------------------------------------
# Compiler specific settings
# ---------------------------------------------------------------------------

# NOTE : Don't use add_definitions() for CMAKE_XXX_FLAGS since MSVC2010 and
#        MingW's windres.exe error basic compiler flags.


if (NOT DEFINED BUILD_WARNINGS_HIGH)
    SET(BUILD_WARNINGS_HIGH FALSE)
endif()
SET(BUILD_WARNINGS_HIGH ${BUILD_WARNINGS_HIGH} CACHE BOOL "Build with a higher level of warnings than normal" FORCE)

if (MSVC) # if (CMAKE_BUILD_TOOL MATCHES "(msdev|devenv|nmake)")

    # -----------------------------------------------------------------------
    # Set the compiler warning level
    if (BUILD_WARNINGS_HIGH)
        set(MSVC_EXTRA_FLAGS "${MSVC_EXTRA_FLAGS} /W4")
    else()
        set(MSVC_EXTRA_FLAGS "${MSVC_EXTRA_FLAGS} /W3")
    endif()

    # -----------------------------------------------------------------------
    # Use multiprocessor compliation if MSVC > ver 6
    # In some cases it is nice to turn it off since it can be hard tell where some
    # pragma warnings come from if multiple files are compiled at once.

    if ("${MSVC_VERSION}" GREATER "1200")
        if (NOT DEFINED BUILD_USE_MULTIPROCESSOR)
            set(BUILD_USE_MULTIPROCESSOR TRUE)
        endif()

        set(BUILD_USE_MULTIPROCESSOR ${BUILD_USE_MULTIPROCESSOR} CACHE BOOL "Build in MSVC using multiple processors (TRUE) else single processor (FALSE)" FORCE)

        if (BUILD_USE_MULTIPROCESSOR)
            set(MSVC_EXTRA_FLAGS "${MSVC_EXTRA_FLAGS} /MP")
        endif()
    endif()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MSVC_EXTRA_FLAGS}")
    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${MSVC_EXTRA_FLAGS}")

elseif (CMAKE_COMPILER_IS_GNUCXX) # elseif (CMAKE_BUILD_TOOL MATCHES "(gmake)")

    # -----------------------------------------------------------------------
    # Set compiler warning level
    if (BUILD_WARNINGS_HIGH)
        # -Wextra gives warnings about unused parameters and others
        set(GNUC_EXTRA_FLAGS "${GNUC_EXTRA_FLAGS} -Wall -Wextra")
    else()
        set(GNUC_EXTRA_FLAGS "${GNUC_EXTRA_FLAGS} -Wall")
    endif()

    # -----------------------------------------------------------------------
    # Colorize the output of the Makefiles
    if (NOT DEFINED CMAKE_COLOR_MAKEFILE)
        set(CMAKE_COLOR_MAKEFILE TRUE)
    endif()
    set( CMAKE_COLOR_MAKEFILE ${CMAKE_COLOR_MAKEFILE} CACHE BOOL "Colorize the makefile output." FORCE)

    # -----------------------------------------------------------------------
    if (IS_64_BIT)
        set(GNUC_EXTRA_FLAGS "${GNUC_EXTRA_FLAGS} -fPIC")
    endif()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GNUC_EXTRA_FLAGS}")
    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${GNUC_EXTRA_FLAGS}")
endif()


# ---------------------------------------------------------------------------
# Print out the basic settings

message(STATUS " ")
message(STATUS "*****************************************************************************")
message(STATUS "* BUILD TYPE:        ${CMAKE_BUILD_TYPE}")
message(STATUS "* BUILD_SHARED_LIBS: ${BUILD_SHARED_LIBS}")
message(STATUS "*****************************************************************************")
message(STATUS "* System is 32-bit ${IS_32_BIT}, is 64-bit ${IS_64_BIT}")
message(STATUS "*****************************************************************************")
message(STATUS "* CMAKE_SOURCE_DIR = ${CMAKE_SOURCE_DIR}")
message(STATUS "* CMAKE_BINARY_DIR = ${CMAKE_BINARY_DIR}")
message(STATUS "*****************************************************************************")
message(STATUS " ")


# ---------------------------------------------------------------------------
# Look for wxWidgets.
#
# In MSW set
#   wxWidgets_ROOT_DIR      : Root dir of the wxWidgets build
#   wxWidgets_LIB_DIR       : Path to the wxWidgets libs, e.g. ${wxWidgets_ROOT_DIR}/lib/vc_lib
#   wxWidgets_CONFIGURATION : msw, mswu (no need to specify debug for MSVC since you can select it in the GUI)
# In Unix set
#   wxWidgets_CONFIG_EXECUTABLE : /path/to/wx-config
#
# Usage: Note how base is last!
#   set(wxWidgets_COMPONENTS aui stc html adv core base)
#   FIND_WXWIDGETS(wxWidgets_COMPONENTS)
#
# Sets up the CMake Gui to make it a little more convenient.
# Adjusts stc and scintilla lib as appropriate for wx version < 2.9 or > 2.9
#
# When wxWidgets is successfully found these variables will be set:
#
# wxWidgets_FOUND      = TRUE on success
# wxWidgets_ROOT_DIR   = /path/to/wxWidgets, in Unix it is equal to wx-config --prefix
# wxWidgets_COMPONENTS = what was input, but with stc/scintilla adjusted for 2.8/2.9
#
# wxWidgets_VERSION        = 2.9.3 (for example)
# wxWidgets_MAJOR_VERSION  = 2
# wxWidgets_MINOR_VERSION  = 9
# wxWidgets_RELEASE_NUMBER = 3
#
# WX_HASLIB_[wx_comp]      = TRUE/FALSE where each wx_comp is from the
#                                       wxWidgets_ALL_COMPONENTS list.
# ---------------------------------------------------------------------------

set(DOXYGEN_PREDEFINED_WXWIDGETS "WXUNUSED(x)=x DECLARE_EXPORTED_EVENT_TYPE(x,y,z)=y")

# The component list is in wxWidgets/build/bakefiles/wxwin.py
set(wxWidgets_ALL_COMPONENTS_29 gl stc richtext propgrid ribbon aui xrc qa media webview net xml html adv core base)
# contrib libs in 28 gizmos, ogl, plot, ...
set(wxWidgets_ALL_COMPONENTS_28 gl stc richtext                 aui xrc qa media         net xml html adv core base)

set(wxWidgets_ALL_COMPONENTS ${wxWidgets_ALL_COMPONENTS_28} ${wxWidgets_ALL_COMPONENTS_29})
list(REMOVE_DUPLICATES wxWidgets_ALL_COMPONENTS)

set(wxWidgets_ALL_COMPONENTS    ${wxWidgets_ALL_COMPONENTS}    CACHE STRING "All wxWidgets library names in 2.8, 2.9, ..." FORCE)
set(wxWidgets_ALL_COMPONENTS_28 ${wxWidgets_ALL_COMPONENTS_28} CACHE STRING "All wxWidgets library names in < 2.9" FORCE)
set(wxWidgets_ALL_COMPONENTS_29 ${wxWidgets_ALL_COMPONENTS_29} CACHE STRING "All wxWidgets library names in >= 2.9" FORCE)
mark_as_advanced(wxWidgets_ALL_COMPONENTS)
mark_as_advanced(wxWidgets_ALL_COMPONENTS_28)
mark_as_advanced(wxWidgets_ALL_COMPONENTS_29)

macro( FIND_WXWIDGETS wxWidgets_COMPONENTS_)

    # We only want this function called once per CMake configure, but we may link
    # CMakeLists.txt from different projects that call this. Only run it the first call.

    get_property(FIND_WXWIDGETS_RUN_ONCE_CALLED DIRECTORY ${CMAKE_HOME_DIRECTORY}
                 PROPERTY FIND_WXWIDGETS_RUN_ONCE SET)
    if (NOT FIND_WXWIDGETS_RUN_ONCE_CALLED)
    set_property(DIRECTORY ${CMAKE_HOME_DIRECTORY}
                 PROPERTY FIND_WXWIDGETS_RUN_ONCE TRUE)

    # call this function without ${} around wxWidgets_COMPONENTS_
    set(wxWidgets_COMPONENTS ${${wxWidgets_COMPONENTS_}})

    # The wxWidgets_CONFIGURATION should never be mswd since then
    # wxWidgets_USE_REL_AND_DBG can't be set since mswdd will never exist.
    string(REGEX MATCH "([a-zA-Z]+)d$" wxWidgets_CONFIGURATION_is_debug "${wxWidgets_CONFIGURATION}")
    if (wxWidgets_CONFIGURATION_is_debug)
        #set(wxWidgets_CONFIGURATION ${CMAKE_MATCH_1} CACHE STRING "Set wxWidgets configuration (${WX_CONFIGURATION_LIST})" FORCE)
    endif()
    unset(wxWidgets_CONFIGURATION_is_debug)

    # Nobody probably needs to see this...
    mark_as_advanced(wxWidgets_wxrc_EXECUTABLE)

    # -----------------------------------------------------------------------
    # Get the version of wxWidgets, we'll need it before finding wxWidgets to get stc lib right.
    # Eventually they will have found the wxWidgets dir and this will work.
    # -----------------------------------------------------------------------

    DETERMINE_WXWIDGETS_VERSION()

    # -----------------------------------------------------------------------

    # Set the variable ${wxWidgets_MONOLITHIC}
    set(wxWidgets_MONOLITHIC FALSE)
    list(FIND wxWidgets_COMPONENTS mono idx_mono)
    if (idx_mono GREATER "-1")
        set(wxWidgets_MONOLITHIC TRUE)
    endif()
    set(wxWidgets_MONOLITHIC ${wxWidgets_MONOLITHIC} CACHE BOOL "wxWidgets library is monolithic." FORCE)
    mark_as_advanced(wxWidgets_MONOLITHIC)

    # -----------------------------------------------------------------------
    # wxWidgets has stc lib in < 2.9 and stc + scintilla lib in >= 2.9
    # Let people specify either stc and/or scintilla
    # -----------------------------------------------------------------------

    list(FIND wxWidgets_COMPONENTS stc       idx_stc)
    list(FIND wxWidgets_COMPONENTS scintilla idx_scintilla)

    if (wxWidgets_VERSION VERSION_LESS 2.9)
        # Remove these >= 2.9 libs, they should if #ifdefed it in the C++ code.
        # We allow them to specify them as link libs, but remove them for 2.8.

        list(FIND wxWidgets_COMPONENTS propgrid idx_propgrid)
        if (idx_propgrid GREATER "-1")
            message(STATUS "* Note: wxWidgets libs; Removing 'propgrid' lib from wxWidgets_COMPONENTS since it didn't exit in wx < 2.9")
            list(REMOVE_ITEM wxWidgets_COMPONENTS propgrid)
        endif()

        if (idx_scintilla GREATER "-1")
            message(STATUS "* Note: wxWidgets libs; Linking to 'stc' lib and not 'scintilla' lib for wx < 2.9")
            list(REMOVE_ITEM wxWidgets_COMPONENTS scintilla)
            set(wxWidgets_COMPONENTS stc ${wxWidgets_COMPONENTS})
        endif()

        if (NOT UNIX)
            if (idx_stc GREATER "-1")
                include_directories("${wxWidgets_ROOT_DIR}/contrib/include")
            endif()
        endif()
    else()

        # In 2.8 stc was in not in the mono lib, but was a separate contrib
        if (wxWidgets_MONOLITHIC)
            if (idx_stc GREATER "-1")
                message(STATUS "* Note: wxWidgets libs; automatically removing stc component for mono build in >= 2.9, but note that stc is a separate lib in 2.8.")
                list(REMOVE_ITEM wxWidgets_COMPONENTS stc)
            endif()
            if (NOT UNIX) # scintilla is static in Unix and we don't have to link to it
                if (idx_scintilla EQUAL "-1")
                    message(STATUS "* Note: wxWidgets libs; automatically adding scintilla lib for stc in mono build in >= 2.9, but note that the scintilla lib doesn't exist in 2.8.")
                    set(wxWidgets_COMPONENTS "scintilla" ${wxWidgets_COMPONENTS})
                endif()
            endif()
        else()
            if (idx_stc GREATER "-1")
                # Need scintilla lib in 2.9, just remove both and add them back in correct order
                list(REMOVE_ITEM wxWidgets_COMPONENTS stc)
                list(REMOVE_ITEM wxWidgets_COMPONENTS scintilla)

                if (NOT UNIX)
                    set(wxWidgets_COMPONENTS "stc" "scintilla" ${wxWidgets_COMPONENTS})
                else()
                    set(wxWidgets_COMPONENTS "stc" ${wxWidgets_COMPONENTS})
                endif()
            endif()
        endif()
    endif()

    unset(idx_stc)
    unset(idx_scintilla)
    unset(idx_propgrid)

    # -----------------------------------------------------------------------

    message(STATUS "* Using these wxWidgets components: ${wxWidgets_COMPONENTS}")

    if (EXISTS "${CMakewxAppLib_LIST_DIR}/FindwxWidgets.cmake")
        # Use our own copy of FindwxWidgets.cmake that has some fixes
        set(CMAKE_MODULE_PATH_old ${CMAKE_MODULE_PATH})
        set(CMAKE_MODULE_PATH     ${CMakewxAppLib_LIST_DIR})

        # Note: it is essential that 'core' is mentioned before 'base'.
        # Don't use REQUIRED since it only gives a useless error message on failure.
        find_package( wxWidgets COMPONENTS ${wxWidgets_COMPONENTS})

        set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH_old})
        unset(CMAKE_MODULE_PATH_old)
    else()
        # Use the default CMake FindwxWidgets.cmake
        # Note: it is essential that 'core' is mentioned before 'base'.
        # Don't use REQUIRED since it only gives a useless error message on failure.
        find_package( wxWidgets COMPONENTS ${wxWidgets_COMPONENTS})
    endif()

    # Set the variables FindwxWidgets.cmake uses so they show up in cmake-gui
    # so people will actually have a chance of finding wxWidgets...

    set( wxWidgets_COMPONENTS ${wxWidgets_COMPONENTS} CACHE STRING "wxWidgets components to link to: xrc;xml;gl;net;media;propgrid;richtext;aui;stc;html;adv;core;base or mono" FORCE)

    if ("${wxWidgets_FIND_STYLE}" STREQUAL "win32")

        # We show the user the version so we can fix stc and scintilla libs
        set( wxWidgets_VERSION       ${wxWidgets_VERSION}       CACHE STRING "wxWidgets version e.g. 2.8.12, 2.9.4..." FORCE)
        # These are used by FindwxWidgets.cmake
        set( wxWidgets_ROOT_DIR      ${wxWidgets_ROOT_DIR}      CACHE PATH   "Root directory of wxWidgets install (set 1st)" FORCE)
        set( wxWidgets_LIB_DIR       ${wxWidgets_LIB_DIR}       CACHE PATH   "Lib directory of wxWidgets install (set 2nd)" FORCE)
        set( wxWidgets_CONFIGURATION ${wxWidgets_CONFIGURATION} CACHE STRING "wxWidgets configuration e.g. msw, mswu, mswunivu..." FORCE)

    else()

        # These may need to be set, but they're untested
        #set( wxWidgets_USE_DEBUG     ${wxWidgets_USE_DEBUG}     CACHE BOOL "Link to a Debug build of wxWidgets" FORCE)
        #set( wxWidgets_USE_UNICODE   ${wxWidgets_USE_UNICODE}   CACHE BOOL "Link to a Unicode build of wxWidgets" FORCE)
        #set( wxWidgets_USE_UNIVERSAL ${wxWidgets_USE_UNIVERSAL} CACHE BOOL "Link to a Universal build of wxWidgets" FORCE)
        #set( wxWidgets_USE_STATIC    ${wxWidgets_USE_STATIC}    CACHE BOOL "Link to a Static build of wxWidgets" FORCE)

        set( wxWidgets_CONFIG_EXECUTABLE ${wxWidgets_CONFIG_EXECUTABLE} CACHE FILEPATH "Specify the path to the wx-config executable" FORCE)

        #set(wxWidgets_CONFIG_OPTIONS --toolkit=base --prefix=/usr)

    endif()

    message(STATUS "* ")

    # -----------------------------------------------------------------------

    if( wxWidgets_FOUND )
        message(STATUS "* Found wxWidgets :" )

        # Set the values from the wxWidgets_CONFIG_EXECUTABLE
        if (EXISTS ${wxWidgets_CONFIG_EXECUTABLE})
            execute_process(COMMAND ${wxWidgets_CONFIG_EXECUTABLE} --prefix OUTPUT_VARIABLE wxWidgets_ROOT_DIR)
            string(STRIP "${wxWidgets_ROOT_DIR}" wxWidgets_ROOT_DIR)
            set(wxWidgets_ROOT_DIR "${wxWidgets_ROOT_DIR}" CACHE PATH "wxWidgets root directory" FORCE)
        endif()

        PARSE_WXWIDGETS_LIB_NAMES()
    else()
        # Do not exit here since they may want to do something else
        message(WARNING "* WARNING: Could not find wxWidgets! Please see help above.")
    endif()

    # -----------------------------------------------------------------------
    # These generators #include wxWidgets/lib/lib_XXX/wx/include/wx/setup.h
    # which uses #ifndef wxUSE_UNICODE to set it to 0 in 2.8 and 1 in 2.9.
    # If the user did not edit the original include/wx/msw/setup0.h the value
    # may be wrong so we force it to be right.

    if( wxWidgets_FOUND )
        set(wxUSE_UNICODE_DEFINE "wxUSE_UNICODE=0")
        if ("${wxWidgets_UNICODEFLAG}" STREQUAL "u")
            set(wxUSE_UNICODE_DEFINE "wxUSE_UNICODE=1")
        endif()

        if ("${CMAKE_GENERATOR}" MATCHES "MinGW Makefiles")
            set( wxWidgets_DEFINITIONS ${wxWidgets_DEFINITIONS} ${wxUSE_UNICODE_DEFINE} )
        elseif ("${CMAKE_GENERATOR}" MATCHES "NMake Makefiles")
            set( wxWidgets_DEFINITIONS ${wxWidgets_DEFINITIONS} ${wxUSE_UNICODE_DEFINE} )
        endif()
    endif( wxWidgets_FOUND )

    # -----------------------------------------------------------------------
    # Fix WXUSINGDLL being defined for BUILD_SHARED_LIBS, even in Linux...
    
    if (NOT BUILD_SHARED_LIBS_WIN_DLLS)
        # awkwardly remove leading or trailing ; (compat with old cmake versions)
        string(REPLACE ";WXUSINGDLL" "" wxWidgets_DEFINITIONS "${wxWidgets_DEFINITIONS}")
        string(REPLACE "WXUSINGDLL;" "" wxWidgets_DEFINITIONS "${wxWidgets_DEFINITIONS}")
        string(REPLACE "WXUSINGDLL"  "" wxWidgets_DEFINITIONS "${wxWidgets_DEFINITIONS}")
    endif()

    # -----------------------------------------------------------------------
    # Print out what we've found so far

    # This is from FindwxWidgets.cmake and is "typically an empty string" in MSW.
    if (WIN32 AND ("${wxWidgets_LIBRARY_DIRS}" STREQUAL ""))
        set(wxWidgets_LIBRARY_DIRS2 "${wxWidgets_LIB_DIR}")
    endif()

    message(STATUS "* - wxWidgets_VERSION           = ${wxWidgets_VERSION} = ${wxWidgets_MAJOR_VERSION}.${wxWidgets_MINOR_VERSION}.${wxWidgets_RELEASE_NUMBER}")
    message(STATUS "* - wxWidgets_COMPONENTS        = ${wxWidgets_COMPONENTS}" )
    message(STATUS "* - wxWidgets_INCLUDE_DIRS      = ${wxWidgets_INCLUDE_DIRS}" )
    message(STATUS "* - wxWidgets_LIBRARY_DIRS      = ${wxWidgets_LIBRARY_DIRS2}" )
    message(STATUS "* - wxWidgets_LIBRARIES         = ${wxWidgets_LIBRARIES}" )
    message(STATUS "* - wxWidgets_CXX_FLAGS         = ${wxWidgets_CXX_FLAGS}" )
    message(STATUS "* - wxWidgets_DEFINITIONS       = ${wxWidgets_DEFINITIONS}" )
    message(STATUS "* - wxWidgets_DEFINITIONS_DEBUG = ${wxWidgets_DEFINITIONS_DEBUG}" )

    message(STATUS "* - wxWidgets_PORTNAME          = ${wxWidgets_PORTNAME}" )
    message(STATUS "* - wxWidgets_UNIVNAME          = ${wxWidgets_UNIVNAME}" )
    message(STATUS "* - wxWidgets_UNICODEFLAG       = ${wxWidgets_UNICODEFLAG}" )
    message(STATUS "* - wxWidgets_DEBUGFLAG         = ${wxWidgets_DEBUGFLAG}" )

    unset(wxWidgets_LIBRARY_DIRS2)
    # -----------------------------------------------------------------------
    # Always verify the libs, for success or failure in finding wxWidgets.
    VERIFY_WXWIDGETS_COMPONENTS()

    message(STATUS "* ")

    endif (NOT FIND_WXWIDGETS_RUN_ONCE_CALLED)
endmacro( FIND_WXWIDGETS )


# ---------------------------------------------------------------------------
# Find the version of wxWidgets and set these variables:
# wxWidgets_VERSION        : 2.8.12 or 2.9.3 for example
# wxWidgets_MAJOR_VERSION  : 2
# wxWidgets_MINOR_VERSION  : 8
# wxWidgets_RELEASE_NUMBER : 12
# wxWidgets_RELEASE        : e.g. 2.8 ir 2.9
# wxWidgets_RELEASE_NODOT  : e.g. 28 or 29
# ---------------------------------------------------------------------------

function( DETERMINE_WXWIDGETS_VERSION )

    if (EXISTS "${wxWidgets_ROOT_DIR}/include/wx/version.h")
        # For MSW use version.h
        FILE(STRINGS "${wxWidgets_ROOT_DIR}/include/wx/version.h" wxWidgets_MAJOR_VERSION  REGEX "#define wxMAJOR_VERSION[^0-9]*([0-9]+)")
        FILE(STRINGS "${wxWidgets_ROOT_DIR}/include/wx/version.h" wxWidgets_MINOR_VERSION  REGEX "#define wxMINOR_VERSION[^0-9]*([0-9]+)")
        FILE(STRINGS "${wxWidgets_ROOT_DIR}/include/wx/version.h" wxWidgets_RELEASE_NUMBER REGEX "#define wxRELEASE_NUMBER[^0-9]*([0-9]+)")

        string(REGEX MATCH "([0-9]+)" wxWidgets_MAJOR_VERSION  "${wxWidgets_MAJOR_VERSION}")
        string(REGEX MATCH "([0-9]+)" wxWidgets_MINOR_VERSION  "${wxWidgets_MINOR_VERSION}")
        string(REGEX MATCH "([0-9]+)" wxWidgets_RELEASE_NUMBER "${wxWidgets_RELEASE_NUMBER}")

        if (wxWidgets_MAJOR_VERSION) # AND wxWidgets_MINOR_VERSION AND wxWidgets_RELEASE_NUMBER)
            set( wxWidgets_VERSION "${wxWidgets_MAJOR_VERSION}.${wxWidgets_MINOR_VERSION}.${wxWidgets_RELEASE_NUMBER}")
        endif()
    elseif (EXISTS ${wxWidgets_CONFIG_EXECUTABLE})
        # For Unix use wx-config script
        execute_process(COMMAND ${wxWidgets_CONFIG_EXECUTABLE} --version OUTPUT_VARIABLE wxWidgets_VERSION)
        # remove spaces and linefeed
        string(STRIP "${wxWidgets_VERSION}" wxWidgets_VERSION)

        # Match major.minor.revision
        string(REGEX MATCH "^([0-9]+)\\."   wxWidgets_MAJOR_VERSION  ${wxWidgets_VERSION})
        string(REGEX MATCH "\\.([0-9]+)\\." wxWidgets_MINOR_VERSION  ${wxWidgets_VERSION})
        string(REGEX MATCH "\\.([0-9]+)$"   wxWidgets_RELEASE_NUMBER ${wxWidgets_VERSION})
        # strip off '.' between numbers
        string(REGEX MATCH "([0-9]+)"  wxWidgets_MAJOR_VERSION  ${wxWidgets_MAJOR_VERSION})
        string(REGEX MATCH "([0-9]+)"  wxWidgets_MINOR_VERSION  ${wxWidgets_MINOR_VERSION})
        string(REGEX MATCH "([0-9]+)"  wxWidgets_RELEASE_NUMBER ${wxWidgets_RELEASE_NUMBER})
    else()
        message(STATUS "* WARNING : Unable to find '${wxWidgets_ROOT_DIR}/include/wx/version.h'")
        # Note: We can't use ("${wxWidgets_FIND_STYLE}" STREQUAL "win32") before calling the find wxWidgets script
        IF(WIN32 AND NOT CYGWIN AND NOT MSYS)
            message(STATUS "*           Please set wxWidgets_ROOT_DIR to point to the root wxWidgets build dir.")
        ELSE()
            message(STATUS "*           Please set wxWidgets_CONFIG_EXECUTABLE to point to wx-config script.")
        ENDIF()
    endif()

    set(wxWidgets_VERSION        "${wxWidgets_VERSION}"        CACHE STRING "The wxWidgets version to compile and link against. (e.g. 2.9.3)" FORCE)
    set(wxWidgets_MAJOR_VERSION  "${wxWidgets_MAJOR_VERSION}"  CACHE STRING "" FORCE)
    set(wxWidgets_MINOR_VERSION  "${wxWidgets_MINOR_VERSION}"  CACHE STRING "" FORCE)
    set(wxWidgets_RELEASE_NUMBER "${wxWidgets_RELEASE_NUMBER}" CACHE STRING "" FORCE)

    set(wxWidgets_RELEASE       "${wxWidgets_MAJOR_VERSION}.${wxWidgets_MINOR_VERSION}" CACHE STRING "" FORCE)
    set(wxWidgets_RELEASE_NODOT "${wxWidgets_MAJOR_VERSION}${wxWidgets_MINOR_VERSION}" CACHE STRING "" FORCE)

    mark_as_advanced( wxWidgets_MAJOR_VERSION
                      wxWidgets_MINOR_VERSION
                      wxWidgets_RELEASE_NUMBER
                      wxWidgets_RELEASE
                      wxWidgets_RELEASE_NODOT )

endfunction( DETERMINE_WXWIDGETS_VERSION )

# ---------------------------------------------------------------------------
# Internal use function to parse the wxWidgets lib names and set the
# wxWidgets_PORTNAME, wxWidgets_UNIVNAME, wxWidgets_UNICODEFLAG, wxWidgets_DEBUGFLAG
# variables.
# ---------------------------------------------------------------------------

function( PARSE_WXWIDGETS_LIB_NAMES )

    # Test each port, use the lib name to get the port, unicode, and debug
    # wxmsw28[ud]_core.lib, wxmswuniv29[ud]_core.lib, wx_gtk2u_core-2.8.so
    # wx$(PORTNAME)$(WXUNIVNAME)$(WX_RELEASE_NODOT)$(WXUNICODEFLAG)$(WXDEBUGFLAG)$(WX_LIB_FLAVOUR).lib

    set(wxWidgets_PORTNAME    "" CACHE STRING "wxWidgets port; 'msw', 'gtk1', 'gtk2'..." FORCE)
    set(wxWidgets_UNIVNAME    "" CACHE STRING "wxWidgets universal build, either 'univ' or ''" FORCE)
    set(wxWidgets_UNICODEFLAG "" CACHE STRING "wxWidgets unicode build, either 'u' or ''" FORCE)
    set(wxWidgets_DEBUGFLAG   "" CACHE STRING "wxWidgets debug build, either 'd' or ''" FORCE)

    # wxWidgets lib/dll build using MSVC (wxmsw29u_core.lib) or MinGW (libwxmsw29ud_core.a)
    if ("${wxWidgets_PORTNAME}" STREQUAL "")
        string(REGEX MATCH "wx(msw)(univ)?([0-9][0-9])(u)?(d)?_core" _match_msw "${wxWidgets_LIBRARIES}")

        if (NOT "${_match_msw}" STREQUAL "")
            set(wxWidgets_PORTNAME    "${CMAKE_MATCH_1}" )
            set(wxWidgets_UNIVNAME    "${CMAKE_MATCH_2}" )
            #set(wxWidgets_LIB_VERSION "${CMAKE_MATCH_3}" )
            set(wxWidgets_UNICODEFLAG "${CMAKE_MATCH_4}" )
            set(wxWidgets_DEBUGFLAG   "${CMAKE_MATCH_5}" )
        endif()
    endif()

    # wxWidgets monolithic DLL build using nmake MSVC : lib/vc_amd64_dll/wxmsw29ud.lib and wxmsw294ud_vc_custom.dll
    if ("${wxWidgets_PORTNAME}" STREQUAL "")
        string(REGEX MATCH "wx(msw)(univ)?([0-9][0-9])(u)?(d)?\\.lib" _match_msw_mono "${wxWidgets_LIBRARIES}")

        if (NOT "${_match_msw_mono}" STREQUAL "")
            set(wxWidgets_PORTNAME    "${CMAKE_MATCH_1}" )
            set(wxWidgets_UNIVNAME    "${CMAKE_MATCH_2}" )
            #set(wxWidgets_LIB_VERSION "${CMAKE_MATCH_3}" )
            set(wxWidgets_UNICODEFLAG "${CMAKE_MATCH_4}" )
            set(wxWidgets_DEBUGFLAG   "${CMAKE_MATCH_5}" )
        endif()
    endif()

    # wxWidgets monolithic DLL build using mingw : lib/gcc_dll/libwxmsw29ud.a and libwxmsw294ud_gcc_custom.dll
    if ("${wxWidgets_PORTNAME}" STREQUAL "")
        string(REGEX MATCH "libwx(msw)(univ)?([0-9][0-9])(u)?(d)?\\.a" _match_msw_mono "${wxWidgets_LIBRARIES}")

        if (NOT "${_match_msw_mono}" STREQUAL "")
            set(wxWidgets_PORTNAME    "${CMAKE_MATCH_1}" )
            set(wxWidgets_UNIVNAME    "${CMAKE_MATCH_2}" )
            #set(wxWidgets_LIB_VERSION "${CMAKE_MATCH_3}" )
            set(wxWidgets_UNICODEFLAG "${CMAKE_MATCH_4}" )
            set(wxWidgets_DEBUGFLAG   "${CMAKE_MATCH_5}" )
        endif()
    endif()

    # wxWidgets GTK2 build using configure
    if ("${wxWidgets_PORTNAME}" STREQUAL "")
        string(REGEX MATCH "wx_(gtk[12]?)(univ)?(u)?(d)?_core-([0-9].[0-9])" _match_gtk "${wxWidgets_LIBRARIES}")

        if (NOT "${_match_gtk}" STREQUAL "")
            set(wxWidgets_PORTNAME    "${CMAKE_MATCH_1}" )
            set(wxWidgets_UNIVNAME    "${CMAKE_MATCH_2}" )
            set(wxWidgets_UNICODEFLAG "${CMAKE_MATCH_3}" )
            set(wxWidgets_DEBUGFLAG   "${CMAKE_MATCH_4}" )
            #set(wxWidgets_LIB_VERSION "${CMAKE_MATCH_5}" )
        endif()
    endif()

    # wxWidgets OSX Cocoa build using configure
    if ("${wxWidgets_PORTNAME}" STREQUAL "")
        # libwx_osx_cocoau_core-2.9.a
        string(REGEX MATCH "wx_(osx_cocoa)(univ)?(u)?(d)?_core-([0-9].[0-9])" _match_osx_cocoa "${wxWidgets_LIBRARIES}")
        if (NOT "${_match_osx_cocoa}" STREQUAL "")
            set(wxWidgets_PORTNAME    "${CMAKE_MATCH_1}" )
            set(wxWidgets_UNIVNAME    "${CMAKE_MATCH_2}" )
            set(wxWidgets_UNICODEFLAG "${CMAKE_MATCH_3}" )
            set(wxWidgets_DEBUGFLAG   "${CMAKE_MATCH_4}" )
            #set(wxWidgets_LIB_VERSION "${CMAKE_MATCH_5}" )
        endif()
    endif()

    # wxWidgets OSX Carbon build using configure
    if ("${wxWidgets_PORTNAME}" STREQUAL "")
        # libwx_macud-2.8.dylib
        string(REGEX MATCH "wx_(mac)(univ)?(u)?(d)?-([0-9].[0-9])" _match_mac "${wxWidgets_LIBRARIES}")
        if (NOT "${_match_mac}" STREQUAL "")
            set(wxWidgets_PORTNAME    "${CMAKE_MATCH_1}" )
            set(wxWidgets_UNIVNAME    "${CMAKE_MATCH_2}" )
            set(wxWidgets_UNICODEFLAG "${CMAKE_MATCH_3}" )
            set(wxWidgets_DEBUGFLAG   "${CMAKE_MATCH_4}" )
            #set(wxWidgets_LIB_VERSION "${CMAKE_MATCH_5}" )
        endif()
    endif()

    if ("${wxWidgets_PORTNAME}" STREQUAL "")
        message(WARNING "WARNING: Unable to find wxWidgets_PORTNAME/UNIVNAME/UNICODEFLAG/DEBUGFLAG from lib names! You may have to add code to CMake to help it parse your wxWidgets lib names.")
    endif()

    set(wxWidgets_PORTNAME    "${wxWidgets_PORTNAME}"    CACHE STRING "wxWidgets port; 'msw', 'gtk1', 'gtk2'..." FORCE)
    set(wxWidgets_UNIVNAME    "${wxWidgets_UNIVNAME}"    CACHE STRING "wxWidgets universal build, either 'univ' or ''" FORCE)
    set(wxWidgets_UNICODEFLAG "${wxWidgets_UNICODEFLAG}" CACHE STRING "wxWidgets unicode build, either 'u' or ''" FORCE)
    set(wxWidgets_DEBUGFLAG   "${wxWidgets_DEBUGFLAG}"   CACHE STRING "wxWidgets debug build, either 'd' or ''" FORCE)

    mark_as_advanced( wxWidgets_PORTNAME
                      wxWidgets_UNIVNAME
                      wxWidgets_UNICODEFLAG
                      wxWidgets_DEBUGFLAG )

endfunction(PARSE_WXWIDGETS_LIB_NAMES)

# ---------------------------------------------------------------------------
# Internal use function to verify that we found all of the desired
# wxWidgets_COMPONENTS and give a useful message about which ones we didn't find.
# Sets the variables WX_HASLIB_${wx_comp} where each wx_comp is from the
# wxWidgets_ALL_COMPONENTS list.
# ---------------------------------------------------------------------------

function( VERIFY_WXWIDGETS_COMPONENTS )

    # Search through the list of components to see what we were able to find.
    # CMake's find_package for wxWidgets fails on missing components and for
    # some reason CMake's find function gives no indication as to why it failed
    # which makes it difficult, if not impossible, to ever 'find' wxWidgets.

    # In Linux using wx-config the WX_{base/core/etc} vars are not set.
    # Mark all libs as not found.
    foreach( wx_comp ${wxWidgets_ALL_COMPONENTS} )
        set(WX_HASLIB_${wx_comp} FALSE CACHE INTERNAL "")
    endforeach()

    # Set the WX_HASLIB_${wx_comp} variables to TRUE/FALSE for all components
    foreach( wx_comp ${wxWidgets_ALL_COMPONENTS} )
        set(wx_comp_found FALSE)

        foreach( wx_comp_lib ${wxWidgets_LIBRARIES} )
            if ("${wx_comp}" STREQUAL "mono")
                if (WX_mono OR WX_monod)
                    set(wx_comp_found TRUE)
                    break()
                endif()
            endif()

            # strip off paths that may match the regex
            get_filename_component(wx_comp_lib_name ${wx_comp_lib} NAME_WE)
            string(REGEX MATCH ${wx_comp} wx_comp_found ${wx_comp_lib_name})

            if ("${wx_comp_found}" STREQUAL "${wx_comp}")
                # Also check that "wx" is in the filename as a sanity check
                string(REGEX MATCH "wx" wx_comp_found ${wx_comp_lib_name})
                if ("${wx_comp_found}" STREQUAL "wx")
                    set(wx_comp_found TRUE)
                    break()
                endif()
            endif()
        endforeach()

        if (wx_comp_found)
            set(WX_HASLIB_${wx_comp} TRUE CACHE INTERNAL "")
            #message("found ${wx_comp}")
        endif()
    endforeach()

    # Verify that all requested components were found
    foreach( wx_comp ${wxWidgets_COMPONENTS} )
        set(wx_comp_found FALSE)

        foreach( wx_comp_lib ${wxWidgets_LIBRARIES} )
            if ("${wx_comp}" STREQUAL "mono")
                if (WX_mono OR WX_monod)
                    set(wx_comp_found TRUE)
                    break()
                endif()
            endif()

            # strip off paths that may match the regex
            get_filename_component(wx_comp_lib_name ${wx_comp_lib} NAME_WE)
            string(REGEX MATCH ${wx_comp} wx_comp_match ${wx_comp_lib_name})

            if ("${wx_comp_match}" STREQUAL "${wx_comp}")
                # Also check that "wx" is in the filename as a sanity check
                string(REGEX MATCH "wx" wx_comp_match_wx ${wx_comp_lib_name})
                if ("${wx_comp_match_wx}" STREQUAL "wx")
                    set(wx_comp_found TRUE)
                    break()
                endif()
            endif()
        endforeach()

        if (NOT wx_comp_found)
            message(" WARNING: Unable to find requested wxWidgets component : ${wx_comp}")
        endif()
    endforeach()

endfunction(VERIFY_WXWIDGETS_COMPONENTS)

# ---------------------------------------------------------------------------
# Set the output names for a library target to include what flavor of
# wxWidgets was used to compile/link against to allow multiple flavors in the same dir.
# The libs will be named like this: ${lib_prefix}-wx28mswud-${lib_postfix}
# lib_prefix should be the name of your lib and lib_postfix the version.
# ---------------------------------------------------------------------------
function( WXLIKE_LIBRARY_NAMES target_name lib_prefix lib_postfix )

    # wxWidgets names their libaries this way - note MSW and Unix are different
    # wx$(PORTNAME)$(WXUNIVNAME)$(WX_RELEASE_NODOT)$(WXUNICODEFLAG)$(WXDEBUGFLAG)$(WX_LIB_FLAVOUR).lib
    # wxmsw28[ud]_core.lib, wx_gtk2[ud]_core-2.8.so

    # We could use ${wxWidgets_DEBUGFLAG}, but it's probably more important
    # to specify how this lib was built.
    SET( _libname_debug   "wx${wxWidgets_RELEASE_NODOT}${wxWidgets_PORTNAME}${wxWidgets_UNIVNAME}${wxWidgets_UNICODEFLAG}d")
    SET( _libname_release "wx${wxWidgets_RELEASE_NODOT}${wxWidgets_PORTNAME}${wxWidgets_UNIVNAME}${wxWidgets_UNICODEFLAG}")

    if (NOT "${lib_prefix}" STREQUAL "")
        SET( _libname_debug   "${lib_prefix}-${_libname_debug}")
        SET( _libname_release "${lib_prefix}-${_libname_release}")
    endif()
    if (NOT "${lib_postfix}" STREQUAL "")
        SET( _libname_debug   "${_libname_debug}-${lib_postfix}")
        SET( _libname_release "${_libname_release}-${lib_postfix}")
    endif()

    set_target_properties(${target_name} PROPERTIES DEBUG_OUTPUT_NAME          ${_libname_debug})
    set_target_properties(${target_name} PROPERTIES RELEASE_OUTPUT_NAME        ${_libname_release})
    set_target_properties(${target_name} PROPERTIES MINSIZEREL_OUTPUT_NAME     ${_libname_release})
    set_target_properties(${target_name} PROPERTIES RELWITHDEBINFO_OUTPUT_NAME ${_libname_release})
endfunction()
