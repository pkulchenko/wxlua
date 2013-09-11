# ---------------------------------------------------------------------------
# CMakeProject.cmake - Initialize CMake for a project.
#
# This file should be suitable for use with a variety of projects
# without modification.
#
# Usage: In your CMakeLists.txt write code along these lines:
#
# project( MyProject )
# include( CMakeProject.cmake )
#
# General Notes:
#
# Prepend messages with a '*', e.g. message(STATUS "* blah blah) so we know
#   what our messages are versus messages from CMake.
# We try to not to modify already set values.
#
# ---------------------------------------------------------------------------

# ===========================================================================
# This file may be called multiple times during configuration.
# Using properties does the trick of storing a variable per configuration run,
# accessible at all scopes that is not cached between runs.
# ===========================================================================

get_property(PROP_CMAKEPROJECT_RUN_ONCE GLOBAL PROPERTY CMAKEPROJECT_RUN_ONCE SET)

if (PROP_CMAKEPROJECT_RUN_ONCE)
    return()
endif()

set_property(GLOBAL PROPERTY CMAKEPROJECT_RUN_ONCE TRUE)

# ---------------------------------------------------------------------------

# Backwards compat to CMake < 2.8.3
if ("${CMAKE_CURRENT_LIST_DIR}" STREQUAL "")
    get_filename_component(CMAKE_CURRENT_LIST_DIR
                           ${CMAKE_CURRENT_LIST_FILE} PATH ABSOLUTE)
endif()

set(CMakeProject_LIST_DIR ${CMAKE_CURRENT_LIST_DIR})

# Load the helper file with additional functions
include( "${CMAKE_CURRENT_LIST_DIR}/CMakeFunctions.cmake" )

# ===========================================================================
# Display to the user what the options are that may be passed to CMake
# to control the build before we do anything.
# ===========================================================================

message(STATUS "* ---------------------------------------------------------------------------" )
message(STATUS "* CMake command line options and tips specific to this project " )
message(STATUS "* " )
message(STATUS "* In the CMake GUI you can set values and press configure a few times " )
message(STATUS "* and until there are no more red items, then press generate." )
message(STATUS "* " )
message(STATUS "* Usage: cmake -D[OPTION_NAME]=[OPTION_VALUE] /path/to/CMakeLists.txt/" )
message(STATUS "* ---------------------------------------------------------------------------" )
message(STATUS "* -DHELP=TRUE " )
message(STATUS "*   Show this help message and exit, no files will be generated." )
message(STATUS "* -DCMAKE_BUILD_TYPE=[Debug, Release, RelWithDebInfo, MinSizeRel] : (Default Debug)")
message(STATUS "*   Makefiles : You must set the build type to Debug, Release..." )
message(STATUS "*   MSVC GUI  : No need to set this since you can choose it in the GUI." )
message(STATUS "* -DBUILD_SHARED_LIBS=[TRUE, FALSE] : (Default static in MSW, shared in Linux)")
message(STATUS "*   Build shared (.DLL or .so) or static (.lib or .a) libraries." )
message(STATUS "* ---------------------------------------------------------------------------" )
message(STATUS " " )


# If the user runs "$cmake -DHELP=TRUE" then exit.
# Call this function after all help would be given
function( EXIT_IF_HELP_REQUESTED )
    if (HELP)
        unset(HELP CACHE) # vars specified on the cmd line are cached
        message("\nHelp shown, exiting... (ignore error message below)\n")
        message(FATAL_ERROR "")
        return()
    endif()
endfunction()

# ===========================================================================
# Create a script/batch file to easily open cmake-gui in the proper dir
# ===========================================================================

if (UNIX)
    if (EXISTS "${CMAKE_EDIT_COMMAND}")
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
    endif()
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
# It's so much nicer, you might as well always have it enabled.

if (NOT DEFINED BUILD_USE_SOLUTION_FOLDERS)
    set( BUILD_USE_SOLUTION_FOLDERS TRUE )
endif()

set(BUILD_USE_SOLUTION_FOLDERS ${BUILD_USE_SOLUTION_FOLDERS} CACHE BOOL
    "Use solution folders to group projects in MSVC Gui" FORCE)
set_property( GLOBAL PROPERTY USE_FOLDERS ${BUILD_USE_SOLUTION_FOLDERS} )

# ---------------------------------------------------------------------------
# Don't insist that everything needs to be built before being able to "install"

if (NOT DEFINED CMAKE_SKIP_INSTALL_ALL_DEPENDENCY)
    set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY TRUE)
endif()

set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY ${CMAKE_SKIP_INSTALL_ALL_DEPENDENCY} CACHE BOOL
    "Don't require all projects to be built in order to install" FORCE)

# ===========================================================================
# Build Settings
# ===========================================================================

# ---------------------------------------------------------------------------
# Show the "install" target dir in the CMake GUI so people can change it.
# There are differences between CMake versions showing (or not) CMAKE_INSTALL_PREFIX to the user.
# ---------------------------------------------------------------------------

set(CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX} CACHE PATH
    "Install Directory prefix for the INSTALL target" FORCE)

# ---------------------------------------------------------------------------
# Default build is Debug, change on the command line with
# $cmake -DCMAKE_BUILD_TYPE=Release /path/to/CMakeLists.txt
# Possible options are "Debug, Release, RelWithDebInfo and MinSizeRel"
# ---------------------------------------------------------------------------

IF (DEFINED CMAKE_BUILD_TYPE)
    if(NOT CMAKE_BUILD_TYPE)
         MESSAGE(STATUS "* No build type was specified, using default 'Debug'")
         SET(CMAKE_BUILD_TYPE "Debug")
    ENDIF()
ELSE()
    MESSAGE(STATUS "* No build type was specified, using default 'Debug'")
    SET (CMAKE_BUILD_TYPE "Debug")
ENDIF()

# Sanity check - we don't handle any other build types
if (NOT DEFINED CMAKE_BUILD_TYPES)
    SET( CMAKE_BUILD_TYPES "Debug;Release;RelWithDebInfo;MinSizeRel" )
endif()
LIST(FIND CMAKE_BUILD_TYPES ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_valid)
if ("${CMAKE_BUILD_TYPE_valid}" EQUAL "-1")
    MESSAGE(FATAL_ERROR "Build type can ONLY be one of '${CMAKE_BUILD_TYPES}', but is set to '${CMAKE_BUILD_TYPE}'")
endif()

if (NOT MSVC)
    # This is used only for the Makefile generator.
    # In MSVC you can choose the build type in the IDE.
    SET(CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING
        "Set build type, options are one of ${CMAKE_BUILD_TYPES}" FORCE)
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

set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS} CACHE BOOL
    "Build shared libraries (TRUE) or static libraries (FALSE)" FORCE)

# Set if we are building DLLs, MSWindows and shared libraries
set(BUILD_SHARED_LIBS_WIN_DLLS FALSE CACHE INTERNAL
    "TRUE when building shared libs on MSW, else FALSE" FORCE)

if (BUILD_SHARED_LIBS) # CMake has problems with "if ("ON" AND "TRUE")"
    if (WIN32)
        set(BUILD_SHARED_LIBS_WIN_DLLS TRUE CACHE INTERNAL
            "TRUE when building shared libs on MSW, else FALSE" FORCE)
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
    # Put into Debug/Release/... subdirs to mimic MSVC appending dirs.
    # We do this so that relative paths from exe to data files are the same on both platforms.
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

set(BUILD_OUTPUT_DIRECTORY_RUNTIME ${BUILD_OUTPUT_DIRECTORY_RUNTIME} CACHE PATH
    "Dir to put all built executables, blank to output to each project dir." FORCE)
set(BUILD_OUTPUT_DIRECTORY_LIBRARY ${BUILD_OUTPUT_DIRECTORY_LIBRARY} CACHE PATH
    "Dir to put all built libraries, blank to output to each project dir." FORCE)
set(BUILD_OUTPUT_DIRECTORY_ARCHIVE ${BUILD_OUTPUT_DIRECTORY_ARCHIVE} CACHE PATH
    "Dir to put all built libraries, blank to output to each project dir." FORCE)

# ---------------------------------------------------------------------------
# RPath options to allow execution of Linux programs in the build tree to
# find their shared libraries.
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

set(BUILD_VERBOSELY ${BUILD_VERBOSELY} CACHE BOOL
    "Verbose compiler build output (enable if using Eclipse to help it discover paths)" FORCE)
set(CMAKE_VERBOSE_MAKEFILE ${BUILD_VERBOSELY} CACHE BOOL
    "Verbose build output (set by BUILD_VERBOSELY)" FORCE)

# ---------------------------------------------------------------------------
# Compiler specific settings
# ---------------------------------------------------------------------------

# NOTE : Don't use add_definitions() for CMAKE_XXX_FLAGS since MSVC2010 and
#        MingW's windres.exe error on basic compiler flags.


if (NOT DEFINED BUILD_WARNINGS_HIGH)
    SET(BUILD_WARNINGS_HIGH FALSE)
endif()
SET(BUILD_WARNINGS_HIGH ${BUILD_WARNINGS_HIGH} CACHE BOOL
    "Build with a higher level of warnings than normal" FORCE)

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
    # #pragma warnings come from if multiple files are compiled at once.

    if ("${MSVC_VERSION}" GREATER "1200")
        if (NOT DEFINED BUILD_USE_MULTIPROCESSOR)
            set(BUILD_USE_MULTIPROCESSOR TRUE)
        endif()

        set(BUILD_USE_MULTIPROCESSOR ${BUILD_USE_MULTIPROCESSOR} CACHE BOOL
            "Build in MSVC using multiple processors (TRUE) else single processor (FALSE)" FORCE)

        if (BUILD_USE_MULTIPROCESSOR)
            set(MSVC_EXTRA_FLAGS "${MSVC_EXTRA_FLAGS} /MP")
        endif()
    endif()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MSVC_EXTRA_FLAGS}")
    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} ${MSVC_EXTRA_FLAGS}")

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
    set(CMAKE_COLOR_MAKEFILE ${CMAKE_COLOR_MAKEFILE} CACHE BOOL
        "Colorize the makefile output." FORCE)

    # -----------------------------------------------------------------------
    if (IS_64_BIT)
        set(GNUC_EXTRA_FLAGS "${GNUC_EXTRA_FLAGS} -fPIC")
    endif()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GNUC_EXTRA_FLAGS}")
    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} ${GNUC_EXTRA_FLAGS}")
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
