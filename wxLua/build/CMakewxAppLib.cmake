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

get_property(PROP_CMAKEWXAPPLIB_RUN_ONCE GLOBAL PROPERTY CMAKEWXAPPLIB_RUN_ONCE SET)

if (PROP_CMAKEWXAPPLIB_RUN_ONCE)
    return()
endif()

set_property(GLOBAL PROPERTY CMAKEWXAPPLIB_RUN_ONCE TRUE)

# ---------------------------------------------------------------------------

# Backwards compat to CMake < 2.8.3
if ("${CMAKE_CURRENT_LIST_DIR}" STREQUAL "")
    get_filename_component(CMAKE_CURRENT_LIST_DIR
                           ${CMAKE_CURRENT_LIST_FILE} PATH ABSOLUTE)
endif()

set(CMakewxAppLib_LIST_DIR ${CMAKE_CURRENT_LIST_DIR})

# Load the helper file with additional functions
include( "${CMAKE_CURRENT_LIST_DIR}/CMakeFunctions.cmake" )

# ===========================================================================
# Display to the user what the options are that may be passed to CMake
# to control the build before we do anything.
# ===========================================================================

message( STATUS "* ---------------------------------------------------------------------------" )
message( STATUS "* wxWidgets library settings :")
message( STATUS "* ")
message( STATUS "* Note that ONLY an all shared (DLL) or all static build is supported." )
message( STATUS "*   I.E. If you choose shared you must link to shared wxWidgets libs." )
message( STATUS "*   Set -DBUILD_SHARED_LIBS=[TRUE, FALSE] to control shared/static lib.")
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
message( STATUS "*   You will get compilation/linker errors if wxWidgets is not found.")
message( STATUS "* ")
message( STATUS "* Finding wxWidgets for GCC and Unix type systems")
message( STATUS "* -DwxWidgets_CONFIG_EXECUTABLE=[path/to/wx-config] : ")
message( STATUS "*   Specify path to wx-config script for GCC and Unix type builds" )
message( STATUS "* ---------------------------------------------------------------------------" )
message( STATUS " " )

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

    set(wxWidgets_COMPONENTS ${wxWidgets_COMPONENTS} CACHE STRING
        "wxWidgets components to link to: xrc;xml;gl;net;media;propgrid;richtext;aui;stc;html;adv;core;base or mono" FORCE)

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
