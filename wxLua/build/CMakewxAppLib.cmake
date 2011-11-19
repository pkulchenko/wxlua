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
message( STATUS "* -DHELP=1 " )
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
message( STATUS "*   Set wxWidgets configuration; e.g. msw, mswd, mswud, mswunivud..." )
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
         "\"${CMAKE_EDIT_COMMAND}\" \"${CMAKE_HOME_DIRECTORY}\"\n" )
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

set( BUILD_USE_SOLUTION_FOLDERS ${BUILD_USE_SOLUTION_FOLDERS} CACHE BOOL "Use solution folders to group projects in MSVC Gui")
set_property( GLOBAL PROPERTY USE_FOLDERS ${BUILD_USE_SOLUTION_FOLDERS} )

# ---------------------------------------------------------------------------
# Don't insist that everything needs to be built before being able to "install"

if (NOT DEFINED CMAKE_SKIP_INSTALL_ALL_DEPENDENCY)
    set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY TRUE CACHE INTERNAL "Don't require all projects to be built in order to install" FORCE)
endif()

# ===========================================================================
# Enable doxygen to be run via "make doc" if the doxygen executable is found
# It includes the Doxyfile.in file.
# ===========================================================================

find_package(Doxygen)

if (DOXYGEN_FOUND_fixme)
    configure_file( ${CMAKE_SOURCE_DIR}/build/Doxyfile.in
                    ${CMAKE_BINARY_DIR}/Doxyfile @ONLY )
    add_custom_target( doc ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/Doxyfile
                       WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                       COMMENT "Generate API documentation with Doxygen" VERBATUM )

    message( STATUS "* Doxygen found, run $make doc to generate documentation in doc/ folder" )
else()
    message( STATUS "* WARNING: Doxygen NOT found, 'doc' target will not be generated" )
endif (DOXYGEN_FOUND_fixme)

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
set( BUILD_INSTALL_PREFIX ${BUILD_INSTALL_PREFIX} CACHE PATH "Install Directory prefix for INSTALL target" FORCE)
set( CMAKE_INSTALL_PREFIX ${BUILD_INSTALL_PREFIX} CACHE INTERNAL "Install Directory prefix for INSTALL target" FORCE)

# ---------------------------------------------------------------------------
# Set bool variables IS_32_BIT and IS_64_BIT
# ---------------------------------------------------------------------------

if ((CMAKE_SIZEOF_VOID_P MATCHES 4) OR (CMAKE_CL_64 MATCHES 0))
    set(IS_32_BIT TRUE)
    set(IS_64_BIT FALSE)
elseif((CMAKE_SIZEOF_VOID_P MATCHES 8) OR (CMAKE_CL_64 MATCHES 1))
    set(IS_32_BIT FALSE)
    set(IS_64_BIT TRUE)
else()
    MESSAGE(WARNING "Oops, unable to determine if using 32 or 64 bit compilation.")
endif()

# ---------------------------------------------------------------------------
# Default build is Debug, change on the command line with
# $cmake -DCMAKE_BUILD_TYPE=Release /path/to/CMakeLists.txt
# Possible options are "Debug, Release, RelWithDebInfo and MinSizeRel"
# ---------------------------------------------------------------------------

if (NOT CMAKE_BUILD_TYPE)
    if (NOT MSVC)
        # This is used only for the Makefile generator.
        # In MSVC you can choose the build type in the IDE.
        set (CMAKE_BUILD_TYPE "Debug" CACHE string "Set build type, options are Debug, Release, RelWithDebInfo, and MinSizeRel" FORCE)
    endif()
endif ()

if (DEFINED CMAKE_BUILD_TYPE)
    # Useful, since I cannot find a case-insensitive string comparison function
    string(TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_UPPERCASE)
endif()

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
        set(BUILD_SHARED_LIBS FALSE CACHE BOOL "Build shared libraries (TRUE) or static libraries (FALSE)" FORCE)
    else()
        set(BUILD_SHARED_LIBS TRUE  CACHE BOOL "Build shared libraries (TRUE) or static libraries (FALSE)" FORCE)
    endif()
endif()

set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS} CACHE BOOL "Build shared libraries (TRUE) or static libraries (FALSE)" FORCE)

# Set if we are building DLLs, MSWindows and shared libraries
set(BUILDING_DLLS FALSE)

if (BUILD_SHARED_LIBS) # CMake has problems with "if ("ON" AND "TRUE")"
    if (WIN32)
        set(BUILDING_DLLS TRUE)
    endif()
endif()

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
    set(BUILD_VERBOSELY FALSE CACHE BOOL "Verbose compiler build output (enable if using Eclipse to help it discover paths)" )
endif()

set( CMAKE_VERBOSE_MAKEFILE ${BUILD_VERBOSELY} CACHE BOOL "Verbose build output (set by BUILD_VERBOSELY)" FORCE)

# ---------------------------------------------------------------------------
# Compiler specific settings
# ---------------------------------------------------------------------------

set(BUILD_WARNINGS_HIGH FALSE CACHE BOOL "Build with a higher level of warnings than normal")

if (MSVC) # if (CMAKE_BUILD_TOOL MATCHES "(msdev|devenv|nmake)")

    # -----------------------------------------------------------------------
    # Set the compiler warning level
    if (BUILD_WARNINGS_HIGH)
        add_definitions( /W4 )
    else()
        add_definitions( /W3 )
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
            add_definitions( /MP )
        endif()
    endif()
elseif (UNIX) # elseif (CMAKE_BUILD_TOOL MATCHES "(gmake)")

    # -----------------------------------------------------------------------
    # Set compiler warning level
    if (BUILD_WARNINGS_HIGH)
        add_definitions( -Wall -Wextra ) # -Wextra gives warnings about unused parameters and others
    else()
        add_definitions( -Wall )
    endif()

    # -----------------------------------------------------------------------
    # Colorize the output of the Makefiles
    if (NOT DEFINED CMAKE_COLOR_MAKEFILE)
        set(CMAKE_COLOR_MAKEFILE TRUE)
    endif()
    set( CMAKE_COLOR_MAKEFILE ${CMAKE_COLOR_MAKEFILE} CACHE BOOL "Colorize the makefile output.")

    # -----------------------------------------------------------------------
    if (IS_64_BIT)
        add_definitions( -fPIC )
        set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} -fPIC)
    endif()
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
# Usage: Note how base is last!
#       set(wxWidgets_COMPONENTS aui stc html adv core base)
#       FIND_WXWIDGETS(wxWidgets_COMPONENTS)
#
# Sets up the CMake Gui to make it a little more convenient.
# Swaps std and scintilla lib as appropriate for wx version < 2.9 and > 2.9
# Check the variable wxWidgets_FOUND for success.
# ---------------------------------------------------------------------------

macro( FIND_WXWIDGETS wxWidgets_COMPONENTS_)

    # call this function without ${comps}
    set(wxWidgets_COMPONENTS ${${wxWidgets_COMPONENTS_}})

    # Eventually they will have found the wxWidgets dir
    # and this will be correctly run
    if (EXISTS "${wxWidgets_ROOT_DIR}/include/wx/version.h")
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
        execute_process(COMMAND ${wxWidgets_CONFIG_EXECUTABLE} --version OUTPUT_VARIABLE wxWidgets_VERSION)
        # remove spaces and linefeed
        string(STRIP "${wxWidgets_VERSION}" wxWidgets_VERSION)
        # Match major.minor.revision
        string(REGEX MATCH "^([0-9]+)\\."   wxWidgets_MAJOR_VERSION  ${wxWidgets_VERSION})
        string(REGEX MATCH "\\.([0-9]+)\\." wxWidgets_MINOR_VERSION  ${wxWidgets_VERSION})
        string(REGEX MATCH "\\.([0-9]+)$"   wxWidgets_RELEASE_NUMBER ${wxWidgets_VERSION})
        # strip of '.' between numbers
        string(REGEX MATCH "([0-9]+)"  wxWidgets_MAJOR_VERSION  ${wxWidgets_MAJOR_VERSION})
        string(REGEX MATCH "([0-9]+)"  wxWidgets_MINOR_VERSION  ${wxWidgets_MINOR_VERSION})
        string(REGEX MATCH "([0-9]+)"  wxWidgets_RELEASE_NUMBER ${wxWidgets_RELEASE_NUMBER})
    else()
        message(STATUS "* WARNING : Unable to find '${wxWidgets_ROOT_DIR}/include/wx/version.h'")
        message(STATUS "*           Please set wxWidgets_ROOT_DIR")
    endif()

    # wxWidgets has stc lib in < 2.9 and stc + scintilla lib in >= 2.9
    if (wxWidgets_VERSION VERSION_LESS 2.9)
        # remove these >= 2.9 libs, they should if #ifdefed it in the code
        # so we allow them to specify them as link libs, but remove them for 2.8
        list(REMOVE_ITEM wxWidgets_COMPONENTS propgrid)

        list(FIND wxWidgets_COMPONENTS scintilla idx)
        if (idx GREATER "-1")
            message(STATUS "* Note: Linking to stc lib and not scintilla lib for wx < 2.9")
            list(REMOVE_ITEM wxWidgets_COMPONENTS scintilla)
            set(wxWidgets_COMPONENTS stc ${wxWidgets_COMPONENTS})
        endif()

        list(FIND wxWidgets_COMPONENTS stc idx)
        if (idx GREATER "-1")
            include_directories(${wxWidgets_ROOT_DIR}/contrib/include)
        endif()
    else()

        # In 2.8 stc was in not in the mono lib, but was a separate contrib
        list(FIND wxWidgets_COMPONENTS mono      idx_mono)
        list(FIND wxWidgets_COMPONENTS stc       idx_stc)
        list(FIND wxWidgets_COMPONENTS scintilla idx_scintilla)

        if (idx_mono GREATER "-1")
            if (idx_stc GREATER "-1")
                message(STATUS "* Note: wxWidgets libs; automatically removing stc component for mono build in >= 2.9, but note that stc is a separate lib in 2.8.")
                list(REMOVE_ITEM wxWidgets_COMPONENTS stc)
            endif()
            if (idx_scintilla EQUAL "-1")
                message(STATUS "* Note: wxWidgets libs; automatically adding scintilla lib for stc in mono build in >= 2.9, but note that the scintilla lib doesn't exist in 2.8.")
                set(wxWidgets_COMPONENTS "scintilla" ${wxWidgets_COMPONENTS})
            endif()
        else()
            if (idx_stc GREATER "-1")
                # Need scintilla lib in 2.9, just remove both and add them back in correct order
                list(REMOVE_ITEM wxWidgets_COMPONENTS stc)
                list(REMOVE_ITEM wxWidgets_COMPONENTS scintilla)
                set(wxWidgets_COMPONENTS "stc" "scintilla" ${wxWidgets_COMPONENTS})
            endif()
        endif()
    endif()

    message(STATUS "* Using these wxWidgets components: ${wxWidgets_COMPONENTS}")

    # Note: it is essential that 'core' is mentioned before 'base'.
    # Don't use REQUIRED since it only gives a useless error message on failure.
    find_package( wxWidgets COMPONENTS ${wxWidgets_COMPONENTS})


    # Set the variables FindwxWidgets.cmake uses so they show up in cmake-gui
    # so you'll actually have a chance to find wxWidgets...

    if (MSVC)

        # We add the version so we can swap stc and scintilla libs
        set( wxWidgets_VERSION       ${wxWidgets_VERSION}       CACHE string "wxWidgets version e.g. 2.8, 2.9.2..." FORCE)
        # These are used by FindwxWidgets.cmake
        set( wxWidgets_ROOT_DIR      ${wxWidgets_ROOT_DIR}      CACHE PATH   "Root directory of wxWidgets install (set 1st)" FORCE)
        set( wxWidgets_LIB_DIR       ${wxWidgets_LIB_DIR}       CACHE PATH   "Lib directory of wxWidgets install (set 2nd)" FORCE)
        set( wxWidgets_CONFIGURATION ${wxWidgets_CONFIGURATION} CACHE string "wxWidgets configuration e.g. msw, mswd, mswu, mswunivud..." FORCE)
        set( wxWidgets_COMPONENTS    ${wxWidgets_COMPONENTS}    CACHE string "wxWidgets components: xrc;xml;gl;net;media;propgrid;richtext;aui;stc;html;adv;core;base or mono" FORCE)

    else()

        # Multiple builds will be presented with options
        #set( wxWidgets_USE_DEBUG     ${wxWidgets_USE_DEBUG}     CACHE BOOL "Link to a Debug build of wxWidgets" FORCE)
        #set( wxWidgets_USE_UNICODE   ${wxWidgets_USE_UNICODE}   CACHE BOOL "Link to a Unicode build of wxWidgets" FORCE)
        #set( wxWidgets_USE_UNIVERSAL ${wxWidgets_USE_UNIVERSAL} CACHE BOOL "Link to a Universal build of wxWidgets" FORCE)
        #set( wxWidgets_USE_STATIC    ${wxWidgets_USE_STATIC}    CACHE BOOL "Link to a Static build of wxWidgets" FORCE)

        set( wxWidgets_CONFIG_EXECUTABLE ${wxWidgets_CONFIG_EXECUTABLE} CACHE FILEPATH "Specify the path to the wx-config executable" FORCE)

        #set(wxWidgets_CONFIG_OPTIONS --toolkit=base --prefix=/usr)

    endif()

    message(STATUS "* ")

    if( wxWidgets_FOUND )
        message(STATUS "* Found wxWidgets :" )

        # Get the platform, gtk, gtk2, msw, univ...  TODO
        set(wxWidgets_PLATFORM)
        string(REGEX MATCH "gtk2" wxWidgets_PLATFORM "${wxWidgets_LIBRARIES}" )
        if (NOT "${wxWidgets_PLATFORM}" STREQUAL "gtk2")
            string(REGEX MATCH "gtk" wxWidgets_PLATFORM "${wxWidgets_LIBRARIES}")
        endif()

        if (NOT wxWidgets_PLATFORM)
            string(REGEX MATCH "mswuniv" wxWidgets_PLATFORM "${wxWidgets_LIBRARIES}")
        endif()

        if (NOT wxWidgets_PLATFORM)
            string(REGEX MATCH "msw" wxWidgets_PLATFORM "${wxWidgets_LIBRARIES}")
        endif()

        set(wxWidgets_PLATFORM ${wxWidgets_PLATFORM} CACHE STRING "" FORCE)

        # Set the values from the wxWidgets_CONFIG_EXECUTABLE
        if (EXISTS ${wxWidgets_CONFIG_EXECUTABLE})
            execute_process(COMMAND ${wxWidgets_CONFIG_EXECUTABLE} --prefix OUTPUT_VARIABLE wxWidgets_ROOT_DIR)
            string(STRIP "${wxWidgets_ROOT_DIR}" wxWidgets_ROOT_DIR)
        endif()
    else()
        # Do not exit here since they may want to do something else
        message(STATUS "* WARNING: Could not find wxWidgets! Please see help above.")
    endif()

    # wxWidgets include (this will do all the magic to configure everything)
    include( "${wxWidgets_USE_FILE}" )

    # always print out what we've found so far
    message(STATUS "* - wxWidgets_VERSION      = ${wxWidgets_VERSION} = ${wxWidgets_MAJOR_VERSION}.${wxWidgets_MINOR_VERSION}.${wxWidgets_RELEASE_NUMBER}")
    message(STATUS "* - wxWidgets_COMPONENTS   = ${wxWidgets_COMPONENTS}" )
    message(STATUS "* - wxWidgets_INCLUDE_DIRS = ${wxWidgets_INCLUDE_DIRS}" )
    message(STATUS "* - wxWidgets_LIBRARY_DIRS = ${wxWidgets_LIBRARY_DIRS}" )
    message(STATUS "* - wxWidgets_LIBRARIES    = ${wxWidgets_LIBRARIES}" )
    message(STATUS "* - wxWidgets_CXX_FLAGS    = ${wxWidgets_CXX_FLAGS}" )
    message(STATUS "* - wxWidgets_DEFINITIONS  = ${wxWidgets_DEFINITIONS}" )
    message(STATUS "* - wxWidgets_DEFINITIONS_DEBUG = ${wxWidgets_DEFINITIONS_DEBUG}" )

    # search through the list of components to see what we were able to find

    set(wxWidgets_ALL_COMPONENTS gizmos ogl stc webview gl qa svg xrc media propgrid richtext aui html adv core xml net base)
    # In Linux using wx-config the WX_{base/core/etc} vars are not set.
    # Mark all libs as not found
    foreach( wx_comp ${wxWidgets_ALL_COMPONENTS} )
        set(WX_HASLIB_${wx_comp} FALSE CACHE INTERNAL "")
    endforeach()

    foreach( wx_comp ${wxWidgets_ALL_COMPONENTS} )
        set(wx_comp_found FALSE)

        foreach( wx_comp_lib ${wxWidgets_LIBRARIES} )
            if ("${wx_comp}" STREQUAL "mono")
                if (WX_mono OR WX_monod)
                    set(wx_comp_found TRUE)
                    break()
                endif()
            endif()

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

        if (${wx_comp_found})
            set(WX_HASLIB_${wx_comp} TRUE)
            #message("found ${wx_comp}")
        endif()
    endforeach()

    foreach( wx_comp ${wxWidgets_COMPONENTS} )
        set(wx_comp_found FALSE)

        foreach( wx_comp_lib ${wxWidgets_LIBRARIES} )
            if ("${wx_comp}" STREQUAL "mono")
                if (WX_mono OR WX_monod)
                    set(wx_comp_found TRUE)
                    break()
                endif()
            endif()

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

    message(STATUS "* ")

    unset(wx_comp)
    unset(wx_comp_found)
    unset(wx_comp_lib)
    unset(wx_comp_lib_name)

endmacro( FIND_WXWIDGETS )
