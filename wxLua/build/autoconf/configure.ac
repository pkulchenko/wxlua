# ======================================================================================
# Author: Francesco Montorsi
# RCS-ID: $Id: configure.ac,v 1.68 2008/02/18 23:36:55 jrl1 Exp $
# ======================================================================================


# WXLUA VERSION
# =============
#
# The second argument of AC_INIT must be the same value of:
# 1) build\innosetup\wxlua.iss
# 2) WXLUA_RELEASE variable in build/bakefiles/wxluabase.bkl
AC_INIT([wxLua], [0], [frm@users.sourceforge.net])

# ENABLES/DISABLES THE DEBUG MODE FOR THIS CONFIGURE SCRIPT
#DBG_CONFIGURE=1

m4_include(utils.m4)
m4_include(wxcodecheck.m4)

AC_PREREQ([2.57])
AC_CONFIG_AUX_DIR([build/autoconf])
AC_LANG(C++)


## CONFIGURE OPTIONS
#################################################################################################
#################################################################################################


# standard wxWidgets options:
WX_CONFIG_OPTIONS

# the --enable-* and --with-* wx-related options
WX_STANDARD_OPTIONS([debug,unicode,shared,toolkit,wxshared,wxversion])

# we want to always have DEBUG==WX_DEBUG and UNICODE==WX_UNICODE
WX_DEBUG=$DEBUG
WX_UNICODE=$UNICODE

# Options for the APPS section
AC_ARG_ENABLE([wxlua-app],
                [AC_HELP_STRING([--enable-wxlua-app], [Compiles the wxLua app (default is yes)])],
                [], [enable_wxlua_app=yes])
AC_ARG_ENABLE([wxluacan-app],
                [AC_HELP_STRING([--enable-wxluacan-app], [Compiles the wxLuaCan app (default is yes)])],
                [], [enable_wxluacan_app=yes])
AC_ARG_ENABLE([wxluaedit-app],
                [AC_HELP_STRING([--enable-wxluaedit-app], [Compiles the wxLuaEditor app (default is yes)])],
                [], [enable_wxluaedit_app=yes])
AC_ARG_ENABLE([wxluafreeze-app],
                [AC_HELP_STRING([--enable-wxluafreeze-app], [Compiles the wxLuaFreeze app (default is yes)])],
                [], [enable_wxluafreeze_app=yes])

# Options for the MODULES section
# NOTE: AC_BINDLIB_ENABLE saves us from some copy&paste
AC_DEFUN([AC_BINDLIB_ENABLE],
        [
            AC_ARG_ENABLE([wxbind$1],
                [AC_HELP_STRING([--enable-wxbind$1],
                                [Compiles the wxLua bindings for $2 lib (default is auto)])],
                [], [enable_wxbind$1=auto])
        ])

AC_BINDLIB_ENABLE([adv],      [wxAdvanced])
AC_BINDLIB_ENABLE([aui],      [wxAUI])
AC_BINDLIB_ENABLE([base],     [wxBase])
AC_BINDLIB_ENABLE([core],     [wxCore])
AC_BINDLIB_ENABLE([gl],       [wxGl])
AC_BINDLIB_ENABLE([html],     [wxHTML])
AC_BINDLIB_ENABLE([media],    [wxMedia])
AC_BINDLIB_ENABLE([net],      [wxNet])
AC_BINDLIB_ENABLE([richtext], [wxRichText])
AC_BINDLIB_ENABLE([stc],      [wxSTC])
AC_BINDLIB_ENABLE([xml],      [wxXml])
AC_BINDLIB_ENABLE([xrc],      [wxXRC])

AC_ARG_ENABLE([wxluadebug],
                [AC_HELP_STRING([--enable-wxluadebug], [Compiles the wxLua debug support (default is yes)])],
                [], [enable_wxluadebug=yes])
AC_ARG_ENABLE([wxluasocket],
                [AC_HELP_STRING([--enable-wxluasocket], [Compiles the wxLua socket support (default is yes)])],
                [], [enable_wxluasocket=yes])
AC_ARG_ENABLE([luamodule],
                [AC_HELP_STRING([--enable-luamodule], [Compiles the lua module (default is yes)])],
                [], [enable_luamodule=yes])
AC_ARG_ENABLE([monolithic_luamodule],
                [AC_HELP_STRING([--enable-monolithic-luamodule], [Compile a monolithic lua module (default is no)])],
                [], [enable_monolithic_luamodule=no])
AC_ARG_ENABLE([customwxbind-install],
                [AC_HELP_STRING([--enable-customwxbind-install], [Installs wxBind sources for custom builds (default is yes)])],
                [], [enable_customwxbind_install=yes])

AC_ARG_ENABLE([systemlua],
                [AC_HELP_STRING([--enable-systemlua], [Use the system Lua (default is auto)])],
                [], [enable_systemlua=auto])
AC_ARG_WITH([lua-prefix],
                [AC_HELP_STRING([--with-lua-prefix], [Prefix where Lua is installed (optional)])],
                [lua_prefix="$withval"], [lua_prefix=""])

AC_ARG_WITH([wxstedit-prefix],
                [AC_HELP_STRING([--with-wxstedit-prefix], [Prefix where wxStEdit is installed (optional)])],
                [wxstedit_dir="$withval"], [wxstedit_dir=""])

UTILS_YESNO_OPTCHECK([USE_WXLUAAPP],       [enable_wxlua_app], [--enable-wxlua-app])
UTILS_YESNO_OPTCHECK([USE_WXLUACANAPP],    [enable_wxluacan_app], [--enable-wxluacan-app])
UTILS_YESNO_OPTCHECK([USE_WXLUAEDITAPP],   [enable_wxluaedit_app], [--enable-wxluaedit-app])
UTILS_YESNO_OPTCHECK([USE_WXLUAFREEZEAPP], [enable_wxluafreeze_app], [--enable-wxluafreeze-app])

UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDADV],      [enable_wxbindadv], [--enable-wxbindadv])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDAUI],      [enable_wxbindaui], [--enable-wxbindaui])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDBASE],     [enable_wxbindbase], [--enable-wxbindbase])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDCORE],     [enable_wxbindcore], [--enable-wxbindcore])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDGL],       [enable_wxbindgl], [--enable-wxbindgl])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDHTML],     [enable_wxbindhtml], [--enable-wxbindhtml])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDMEDIA],    [enable_wxbindmedia], [--enable-wxbindmedia])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDNET],      [enable_wxbindnet], [--enable-wxbindnet])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDRICHTEXT], [enable_wxbindrichtext], [--enable-wxbindrichtext])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDSTC],      [enable_wxbindstc], [--enable-wxbindstc])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDXML],      [enable_wxbindxml], [--enable-wxbindxml])
UTILS_YESNOAUTO_OPTCHECK([USE_WXBINDXRC],      [enable_wxbindxrc], [--enable-wxbindxrc])

UTILS_YESNO_OPTCHECK([USE_WXLUADEBUG],         [enable_wxluadebug], [--enable-wxluadebug])
UTILS_YESNO_OPTCHECK([USE_WXLUASOCKET],        [enable_wxluasocket], [--enable-wxluasocket])
UTILS_YESNO_OPTCHECK([USE_LUAMODULE],          [enable_luamodule], [--enable-luamodule])
UTILS_YESNO_OPTCHECK([MONOLITHIC_LUAMODULE],   [enable_monolithic_luamodule], [--enable-monolithic-luamodule])

UTILS_YESNO_OPTCHECK([INSTALL_CUSTOM_WXBIND], [enable_customwxbind_install], [--enable-customwxbind-install])


AC_MSG_CHECKING([for the --with-lua-prefix option])
if test ! $lua_prefix = ""; then

    # user explicitely provided a path to its own lua, check that it's an absolute path
    # (or it won't work for out-of-tree builds)
    case $lua_prefix in
    /*) continue;;
    *)
        AC_MSG_ERROR([
    You must provide an absolute path for the --with-lua-prefix option.
        ])
    esac
fi
AC_MSG_RESULT([$lua_prefix])

AC_MSG_CHECKING([for the --with-wxstedit-prefix option])
if test ! $wxstedit_dir = ""; then

    # user explicitely provided a path to its own wxStEdit, check that it's an absolute path
    # (or it won't work for out-of-tree builds)
    case $wxstedit_dir in
    /*) continue;;
    *)
        AC_MSG_ERROR([
    You must provide an absolute path for the --with-wxstedit-prefix option.
        ])
    esac
fi
AC_MSG_RESULT([$wxstedit_dir])


# Global wxLua options:
# we could use these to define options like --enable-all-apps but these would
# be rather uncommon options in Unix world and thus we'll leave these
# options fixed to their default values
USE_APPS=1





## CONFIGURE CHECKS
#################################################################################################
#################################################################################################

# Initial wx libs, we will add more to these variables as we check for their existance
WXLIB_NAMES="core,base"

# Initial list of wxLua libraries
WXLUA_LIBS="-llua5.1"

# NB: to avoid getting "-g -02" automatically added to C*FLAGS we need
#     to explicitely initialize CFLAGS and CXXFLAGS to empty
CFLAGS=
CXXFLAGS=

AC_CANONICAL_SYSTEM
AC_PROG_CC
AC_PROG_CXX

# standard wxWidgets checks:
# NOTE: the 'core,base' string passed to WX_CONFIG_CHECK macro here
#       is just a fake list of the required wxWidgets libraries.
#       Later we'll check for the existence of each wxWidgets library
#       and then we'll rebuild the WX_LIBS string
WX_CONVERT_STANDARD_OPTIONS_TO_WXCONFIG_FLAGS
WX_CONFIG_CHECK([2.8.0], [wxWin=1], [], [core,base], [$WXCONFIG_FLAGS])
WX_DETECT_STANDARD_OPTION_VALUES


# NOTE: -rpath is not supported by Mac's ld linker!
RPATH_FLAGS=""
if test "SHARED" = "1" -a "PLATFORM_UNIX" = "1"; then
    RPATH_FLAGS="-Wl,-rpath,../lib"
fi

# NOTE: Need longer library rpath names for Mac's linker, -header-pad_max_install_names
#   "install_name_tool: changing install names can't be redone for: wxLua.app/Contents/MacOS/wxLua
#    (for architecture i386) because larger updated load commands do not fit (the program must be relinked)"
if test "SHARED" = "1" -a "PLATFORM_MACOSX" = "1"; then
    RPATH_FLAGS="-Wl,-header-pad_max_install_names"
fi

AC_SUBST(RPATH_FLAGS)

# check for Lua
#
# NB: by default we try to use the system-wide lua 5.1; if it does not
#     exist then we use our built-in lua

USE_SYSTEM_LUA=0

LUA_INCLUDE_DIR="."         # leaving these vars empty would give problems
LUA_LIB_DIR="."

if test ! "$enable_systemlua" = "no"; then

    # the default prefix is /usr
    if test "$lua_prefix" = ""; then
        lua_prefix="/usr"
    fi

    # default include folder for lua 5.1 seems to be $lua_prefix/include/lua5.1
    LUA_INCLUDE_DIR="$lua_prefix/include/lua5.1"
    LUA_LIB_DIR="$lua_prefix/lib"

    UTILS_SAVE_COREVAR()

    # force C compilation, not C++
    CPPFLAGS="-x c $CPPFLAGS"

    # use the Lua path given by the user through --with-lua-prefix option
    CPPFLAGS="-I$LUA_INCLUDE_DIR $CPPFLAGS"
    LDFLAGS="-L$LUA_LIB_DIR $LDFLAGS"
    LIBS="-llua5.1 $LIBS"

    AC_LINK_IFELSE([
                    AC_LANG_PROGRAM([#include <lua.h>],
                                    [lua_newtable(NULL);])
                    ],
                    [LUA_PRESENCE=1], [LUA_PRESENCE=0])

    # NOTE: put this AC_MSG_CHECKING macro call immediately before
    #       the AC_MSG_RESULT macro calls as otherwise messages coming
    #       from other macros called by AC_LINK_IFELSE may interfere
    #       in the final output
    AC_MSG_CHECKING([if Lua 5.1 is installed])

    if test "$LUA_PRESENCE" = "1"; then
        AC_MSG_RESULT([yes, using system Lua])
        USE_SYSTEM_LUA=1
    else
        AC_MSG_RESULT([not found, falling back to the built-in lua])

        if test "$enable_systemlua" = "yes"; then
            AC_MSG_ERROR([
    You specified --enable-systemlua=yes, but it is not useable. See config.log.
            ])
        fi
    fi

    UTILS_RESTORE_COREVAR()        # restore $CPPFLAGS and $LIBS
else
    AC_MSG_RESULT([using built-in Lua --enable-systemlua=no])
fi

AC_SUBST(LUA_INCLUDE_DIR)
AC_SUBST(LUA_LIB_DIR)

if test "$USE_SYSTEM_LUA" = "0"; then

    # LUA_INCLUDE_DIR must always be an absolute path!
    LUA_INCLUDE_DIR="`pwd`/$srcdir/modules/lua/include"
    LUA_LIB_DIR="`pwd`/lib"

    # Checks used to determine right LUA flags (see modules/lua/src/Makefile)
    luadefs=
    lualibs=

    # these do not require additional libs
    AC_CHECK_FUNC([isatty], [luadefs="$luadefs -DLUA_USE_ISATTY"])
    AC_CHECK_FUNC([mkstemp], [luadefs="$luadefs -DLUA_USE_MKSTEMP"])
    AC_CHECK_FUNC([popen], [luadefs="$luadefs -DLUA_USE_POPEN"])
    AC_CHECK_FUNC([_longjmp], [luadefs="$luadefs -DLUA_USE_ULONGJMP"])

    # these require addlibs
    AC_CHECK_LIB([dl], [dlopen], [
                    AC_CHECK_HEADER([dlfcn.h], [
                                luadefs="$luadefs -DLUA_USE_DLOPEN"
                                lualibs="$lualibs -ldl"
                            ])
                ])
    AC_CHECK_LIB([readline], [readline], [
                    luadefs="$luadefs -DLUA_USE_READLINE"
                    lualibs="$lualibs -lreadline"
                ])

    LUA_PLATFORM_SPECIFIC_CFLAGS=$luadefs
    LUA_PLATFORM_SPECIFIC_LDFLAGS=$lualibs
    AC_SUBST(LUA_PLATFORM_SPECIFIC_CFLAGS)
    AC_SUBST(LUA_PLATFORM_SPECIFIC_LDFLAGS)
fi



dnl ---------------------------------------------------------------------------
dnl WX_CHECK_FOR_WXLIB([wx-lib name lowercase],
dnl                    [wx-lib name uppercase prefixed by WX],
dnl                    [wx-lib include file with final .h],
dnl                    [a C++ line of code which tests for existence of the wx-lib],
dnl                    [action if found],
dnl                    [action if not found])
dnl ---------------------------------------------------------------------------
AC_DEFUN([WX_CHECK_FOR_WXLIB],
        [
            dnl save original flags into support variables
            UTILS_SAVE_COREVAR()

            dnl add to the compilation & link flags the wxWidgets flags
            dnl
            dnl NOTE: this is very important since the test program
            dnl       we will compile needs to be linked against wx
            dnl       and the configure script will use these *FLAGS
            dnl       variables and it cannot be told to use other flags.
            dnl
            dnl NOTE2: we don't want to put into *FLAGS variables the
            dnl        WX_* variable values since the Makefile.in for
            dnl        a wxpresets-based application already merges
            dnl        the *FLAGS contents with WX_* vars
            dnl
            dnl NOTE3: the CXXFLAGS are merged with CPPFLAGS and
            dnl        thus we don't need to add the WX_CPPFLAGS to both

            CPPFLAGS="$CPPFLAGS $WX_CPPFLAGS"
            CFLAGS="$CFLAGS $WX_CFLAGS_ONLY"

            dnl the WXLIB_NAMES variable contains the names of the wxWidgets
            dnl library whose presence was already verified.
            LIBS=`$WX_CONFIG_NAME $WXCONFIG_FLAGS --libs $1,$WXLIB_NAMES`

            dnl check for this component presence
            AC_MSG_CHECKING([if wxWidgets $1 library is available])
            AC_LINK_IFELSE([
                            AC_LANG_PROGRAM([#include <$3>],
                                            [$4])
                            ],
                            [$2_PRESENCE=1], [$2_PRESENCE=0])

            if test "$$2_PRESENCE" = "1"; then
                AC_MSG_RESULT([yes])
                $5
            else
                AC_MSG_RESULT([no])
                $6
            fi

            dnl restore the original flags
            UTILS_RESTORE_COREVAR()
        ])


#
# now check for wxWidgets libraries presence in the correct order
#
# NOTE: in wx >= 2.9 this won't be necessary since we'll be able to
#       simply search in the `wx-config --libs all` string which
#       contains all the available wx libraries for a certain wx build
#

if [[[ "$USE_WXBINDADV" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([adv], [WXADV],
                       [wx/grid.h], [wxGrid dummy(NULL, -1, wxDefaultPosition);],
                       [USE_WXBINDADV=1; WXLIB_NAMES="adv,$WXLIB_NAMES"],
                       [USE_WXBINDADV=0])
fi
if [[[ "$USE_WXBINDADV" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXADV=0"
fi

if [[[ "$USE_WXBINDAUI" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([aui], [WXAUI],
                       [wx/aui/aui.h], [wxAuiPaneInfo dummy();],
                       [USE_WXBINDAUI=1; WXLIB_NAMES="aui,$WXLIB_NAMES"],
                       [USE_WXBINDAUI=0])
fi
if [[[ "$USE_WXBINDAUI" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXAUI=0"
fi

if [[[ "$USE_WXBINDGL" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([gl], [WXGL],
                       [wx/glcanvas.h], [wxGLCanvas dummy(NULL, -1, wxDefaultPosition);],
                       [USE_WXBINDGL=1; WXLIB_NAMES="gl,$WXLIB_NAMES"],
                       [USE_WXBINDGL=0])
fi
if [[[ "$USE_WXBINDGL" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXGL=0"
fi

if [[[ "$USE_WXBINDHTML" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([html], [WXHTML],
                       [wx/html/htmlcell.h], [wxHtmlSelection dummy;],
                       [USE_WXBINDHTML=1; WXLIB_NAMES="html,$WXLIB_NAMES"],
                       [USE_WXBINDHTML=0])
fi
if [[[ "$USE_WXBINDHTML" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXHTML=0"
fi

if [[[ "$USE_WXBINDMEDIA" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([media], [WXMEDIA],
                       [wx/mediactrl.h], [wxMediaCtrl dummy();],
                       [USE_WXBINDMEDIA=1; WXLIB_NAMES="media,$WXLIB_NAMES"],
                       [USE_WXBINDMEDIA=0])
fi
if [[[ "$USE_WXBINDMEDIA" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXMEDIA=0"
fi

if [[[ "$USE_WXBINDNET" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([net], [WXNET],
                       [wx/socket.h], [wxSocketClient dummy;],
                       [USE_WXBINDNET=1; WXLIB_NAMES="net,$WXLIB_NAMES"],
                       [USE_WXBINDNET=0])
fi
if [[[ "$USE_WXBINDNET" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXNET=0"
fi

if [[[ "$USE_WXBINDXML" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([xml], [WXXML],
                       [wx/xml/xml.h], [wxXmlProperty dummy;],
                       [USE_WXBINDXML=1; WXLIB_NAMES="xml,$WXLIB_NAMES"],
                       [USE_WXBINDXML=0])
fi
if [[[ "$USE_WXBINDXML" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXXML=0"
fi

if [[[ "$USE_WXBINDXRC" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([xrc], [WXXRC],
                       [wx/xrc/xh_all.h], [wxSizerXmlHandler dummy;],
                       [USE_WXBINDXRC=1; WXLIB_NAMES="xrc,$WXLIB_NAMES"],
                       [USE_WXBINDXRC=0])
fi
if [[[ "$USE_WXBINDXRC" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXXRC=0"
fi

if [[[ "$USE_WXBINDRICHTEXT" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([richtext], [WXRICHTEXT],
                       [wx/richtext/richtextctrl.h], [wxRichTextCtrl dummy;],
                       [USE_WXBINDRICHTEXT=1; WXLIB_NAMES="richtext,$WXLIB_NAMES"],
                       [USE_WXBINDRICHTEXT=0])
fi
if [[[ "$USE_WXBINDRICHTEXT" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXRICHTEXT=0"
fi

# NOTE: even if the STC library is a contrib in wx <= 2.8, we can still use
#       the WX_CHECK_FOR_WXLIB macro to test for it

if [[[ "$USE_WXBINDSTC" = "1" ]]]; then

    # the user set the relative --enable-wxbindXXX option to 'auto' or to 'yes' value:
    # check if the XXX library is available:

    WX_CHECK_FOR_WXLIB([stc], [WXSTC],
                       [wx/stc/stc.h], [wxStyledTextCtrl dummy;],
                       [USE_WXBINDSTC=1; WXLIB_NAMES="stc,$WXLIB_NAMES"],
                       [USE_WXBINDSTC=0])
fi
if [[[ "$USE_WXBINDSTC" = "0" ]]]; then
    # either the user set --enable-wxbindXXX=no or the test above failed
    # as the wx XXX library is not available...
    CPPFLAGS="$CPPFLAGS -DwxLUA_USEBINDING_WXSTC=0"

    # these depends from wxSTC !
    USE_WXLUAAPP=0
    USE_WXLUAEDITAPP=0

    WXBUILD_STR="$($WX_CONFIG_WITH_ARGS --selected_config)"
    AC_MSG_NOTICE([
 The wxWidgets wrappers for Scintilla text control could not be found
 (at least not for the '$WXBUILD_STR' wxWidgets build).
 Please be sure that you compiled and installed it since they are
 not built together with wxWidgets <= 2.8 by default.
 E.g. from wxWidgets build directory type:

    cd contrib/src/stc && make && sudo make install
    cd contrib/samples/stc && make

 If you still get this error message, look at config.log for more details
 or report this problem to $PACKAGE_BUGREPORT.
 NOTE: build is proceeding without Scintilla wrappers, but you will miss
        the wxLuaApp and wxLuaEdit applications!
    ])
fi



dnl ---------------------------------------------------------------------------
dnl wxStEdit check
dnl --------------------------------------------------------------------------

# check for the wxStEdit component...
# NOTE: autopackage HACK: do an "export NO_WXLUAEDIT_CHECK=1" symbol
#       to get rid of this check which fails for some reason when building the AP
if [[[ "$USE_WXLUAEDITAPP" = "1" && -z "$NO_WXLUAEDIT_CHECK" ]]]; then

    minversion="1.2.4"

    if test ! "$wxstedit_dir" = ""; then
        WXSTEDIT=$wxstedit_dir
        echo "  wxStEdit include path from --with-wxstedit-dir: '$WXSTEDIT'"
    else
        # Try to get the wxStEdit src dir from the shell environment variable
        WXSTEDIT=`echo $WXSTEDIT`
        echo "  wxStEdit include path from \$WXSTEDIT environment variable: '$WXSTEDIT'"
    fi

    # if it's not empty then add the search paths for the includes and lib
    if test ! "$WXSTEDIT" = ""; then
        CPPFLAGS="$CPPFLAGS -I$WXSTEDIT/include"
        LDFLAGS="$LDFLAGS -L$WXSTEDIT/lib"
    fi

    # Temporarily rewrite WX_LIBS to include all the libs that wxStEdit requires.
    WX_LIBS=`$WX_CONFIG_WITH_ARGS --libs stc,html,adv,core,base`

    WX_LIKE_LIBNAME([_WX_STEDIT_LIBNAME], [wxcode], [stedit])
    AM_WXCODE_CHECKFOR_COMPONENT_VERSION([wxStEdit], [wx/stedit/stedit.h],
                      [$_WX_STEDIT_LIBNAME], [wxSTEditor dummy;], [$minversion],
                      [STE_], [_VERSION],
                      [ac_cv_prog_stedit_set=1],
                      [ac_cv_prog_stedit_set=0])

    if test $ac_cv_prog_stedit_set = "0"; then
        WXBUILD_STR="$($WX_CONFIG_WITH_ARGS --selected_config)"
        AC_MSG_NOTICE([
    Could not find the wxStEdit component version $minversion or higher
    (at least not for the '$WXBUILD_STR' wxWidgets build).
    For more information about wxStEdit look at
       http://wxcode.sourceforge.net/components/wxstedit
    For more information about why exactly this check has
    failed look in config.log.

    Disabling the wxLuaEdit application and proceeding...
        ])
        USE_WXLUAEDITAPP=0
    fi
fi

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

# recreate the wx-config --libs after determining what libs we've found

WX_LIBS=`$WX_CONFIG_WITH_ARGS --libs $WXLIB_NAMES`
WX_LIBS_STATIC=`$WX_CONFIG_WITH_ARGS --static --libs $WXLIB_NAMES 2>/dev/null`

AC_DEFUN([AC_ADD_WXLUA_LIBS],
    [
        if test $1 == "1"; then
            WX_LIKE_LIBNAME([_TMP], [wxlua], [$2])
            WXLUA_LIBS="-l$_TMP $WXLUA_LIBS"
        fi
    ])


AC_ADD_WXLUA_LIBS(["1"], [wxlua])
AC_ADD_WXLUA_LIBS([$USE_WXLUADEBUG], [wxluadebug])
AC_ADD_WXLUA_LIBS([$USE_WXLUASOCKET], [wxluasocket])

AC_ADD_WXLUA_LIBS([$USE_WXBINDBASE], [wxbindbase])
AC_ADD_WXLUA_LIBS([$USE_WXBINDCORE], [wxbindcore])
AC_ADD_WXLUA_LIBS([$USE_WXBINDNET], [wxbindnet])
AC_ADD_WXLUA_LIBS([$USE_WXBINDXML], [wxbindxml])
AC_ADD_WXLUA_LIBS([$USE_WXBINDADV], [wxbindadv])
AC_ADD_WXLUA_LIBS([$USE_WXBINDAUI], [wxbindaui])
AC_ADD_WXLUA_LIBS([$USE_WXBINDGL], [wxbindgl])
AC_ADD_WXLUA_LIBS([$USE_WXBINDHTML], [wxbindhtml])
AC_ADD_WXLUA_LIBS([$USE_WXBINDMEDIA], [wxbindmedia])
AC_ADD_WXLUA_LIBS([$USE_WXBINDRICHTEXT], [wxbindrichtext])
AC_ADD_WXLUA_LIBS([$USE_WXBINDSTC], [wxbindstc])
AC_ADD_WXLUA_LIBS([$USE_WXBINDXRC], [wxbindxrc])

AC_SUBST([WXLUA_LIBS])


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

# Produce some useful info for pkg-config:
AC_DEFUN([AC_ADDMODULE],
    [
        dnl the set of the module names, comma separed
        WXLUA_MODNAMES="$WXLUA_MODNAMES $1"

        dnl the set of the wxLua library names
        WX_LIKE_LIBNAME([_TMP], [wxlua], [$1])
        WXLUA_LIBNAMES="$WXLUA_LIBNAMES $_TMP"

        dnl the set of the wxLua library names prefixed with -l
        WXLUA_LDFLAGS="$WXLUA_LDFLAGS -l$_TMP"
    ])

AC_ADDMODULE([wxbindadv])
AC_ADDMODULE([wxbindaui])
AC_ADDMODULE([wxbindbase])
AC_ADDMODULE([wxbindcore])
AC_ADDMODULE([wxbindgl])
AC_ADDMODULE([wxbindhtml])
AC_ADDMODULE([wxbindmedia])
AC_ADDMODULE([wxbindnet])
AC_ADDMODULE([wxbindrichtext])
AC_ADDMODULE([wxbindstc])
AC_ADDMODULE([wxbindxml])
AC_ADDMODULE([wxbindxrc])

AC_ADDMODULE([wxluasocket])
AC_ADDMODULE([wxluadebug])
AC_ADDMODULE([wxlua])

WXLUA_LIBNAMES="$WXLUA_LIBNAMES lua5.1"
WXLUA_LDFLAGS="$WXLUA_LDFLAGS -llua5.1"

# remove initial space:
WXLUA_MODNAMES=${WXLUA_MODNAMES:1}
WXLUA_LIBNAMES=${WXLUA_LIBNAMES:1}
WXLUA_LDFLAGS=${WXLUA_LDFLAGS:1}

AC_SUBST([WXLUA_MODNAMES])
AC_SUBST([WXLUA_LIBNAMES])
AC_SUBST([WXLUA_LDFLAGS])

# now that we know the wxWidgets' version, we can update the PACKAGE_VERSION var
PACKAGE_VERSION="$WX_VERSION.$PACKAGE_VERSION"






## END OF CONFIGURE SCRIPT
#################################################################################################
#################################################################################################

AC_BAKEFILE([m4_include(autoconf_inc.m4)])
AC_CONFIG_FILES([Makefile modules/Makefile apps/Makefile build/autoconf/wxlua.pc distrib/autopackage/default.apspec])

# since at least the "luamodule.wx.lua" sample require to be able to find
# the wx.so library in ../lib we need to copy the sample(s) to the
# build directory to preserve the relative path correctness
#
# NOTE: we cannot check $top_srcdir here since it's not defined yet at this
#       point of the configure script
#
if [[ ! -d "samples" ]]; then

    AC_MSG_NOTICE([configure: copying $srcdir/samples to ./samples])
    cp -r "$srcdir/samples" samples

    # NB: we don't use AC_CONFIG_LINKS([samples:samples], [cp]) because making
    #     a symbolic link from $srcdir/samples to samples would not work for
    #     luamodule.wx.lua (because require("wx") uses the effective path).
fi

# makefiles require "lib" and "bin" folders to exist
if [[ ! -d "lib" ]]; then
    mkdir lib
fi
if [[ ! -d "bin" ]]; then
    mkdir bin
fi

AC_OUTPUT




# output a nice summary of detected options
# NOTE: keep build conditions in synch with bakefiles; e.g. app_wxlua is
#       declared as:
#        <exe id="app_wxlua" template="wxluaapp" cond="USE_WXLUAAPP=='1' and USE_WXBINDSTC=='1' and USE_WXLUADEBUG=='1'">
#       and thus the AM_3BOOLOPT_SUMMARY([USE_WXLUAAPP], [USE_WXBINDSTC], [USE_WXLUADEBUG], ...)
#       macro must be used !

WX_STANDARD_OPTIONS_SUMMARY_MSG_BEGIN

# applications
echo

# note that these use the _INV_ version of the macros since in the bakefiles
# the associated "cond" property are respectively USE_SYSTEM_LUA=='0' and
# SHARED=='0' and USE_SYSTEM_LUA=='1'
UTILS_BOOLOPT_INV_SUMMARY([USE_SYSTEM_LUA],
        ["  - Lua interpreter:                yes"],
        ["  - Lua interpreter:                no"])
UTILS_2BOOLOPT_INV_SUMMARY([SHARED], [USE_SYSTEM_LUA],
        ["  - Lua compiler:                   yes"],
        ["  - Lua compiler:                   no"])

# these use "normal" versions of the macros
UTILS_3BOOLOPT_SUMMARY([USE_WXLUAAPP], [USE_WXBINDSTC], [USE_WXLUADEBUG],
        ["  - wxLua application:              yes"],
        ["  - wxLua application:              no"])
UTILS_BOOLOPT_SUMMARY([USE_WXLUACANAPP],
        ["  - wxLuaCan application:           yes"],
        ["  - wxLuaCan application:           no"])
UTILS_2BOOLOPT_SUMMARY([USE_WXLUAEDITAPP], [USE_WXBINDSTC],
        ["  - wxLuaEdit application:          yes"],
        ["  - wxLuaEdit application:          no"])
UTILS_BOOLOPT_SUMMARY([USE_WXLUAFREEZEAPP],
        ["  - wxLuaFreeze application:        yes"],
        ["  - wxLuaFreeze application:        no"])

# modules
echo

if test "$USE_SYSTEM_LUA" = "1"; then
    echo "  - Using SYSTEM lua library (prefix is '$lua_prefix')"
else
    echo "  - Using BUILT-IN lua library"
fi

UTILS_BOOLOPT_SUMMARY([USE_WXBINDADV],
        ["  - enable_wxbindadv module:        yes"],
        ["  - enable_wxbindadv module:        no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDAUI],
        ["  - enable_wxbindaui module:        yes"],
        ["  - enable_wxbindaui module:        no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDBASE],
        ["  - enable_wxbindbase module:       yes"],
        ["  - enable_wxbindbase module:       no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDCORE],
        ["  - enable_wxbindcore module:       yes"],
        ["  - enable_wxbindcore module:       no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDGL],
        ["  - enable_wxbindgl module:         yes"],
        ["  - enable_wxbindgl module:         no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDHTML],
        ["  - enable_wxbindhtml module:       yes"],
        ["  - enable_wxbindhtml module:       no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDMEDIA],
        ["  - enable_wxbindmedia module:      yes"],
        ["  - enable_wxbindmedia module:      no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDNET],
        ["  - enable_wxbindnet module:        yes"],
        ["  - enable_wxbindnet module:        no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDRICHTEXT],
        ["  - enable_wxbindrichtext module:   yes"],
        ["  - enable_wxbindrichtext module:   no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDSTC],
        ["  - enable_wxbindstc module:        yes"],
        ["  - enable_wxbindstc module:        no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDXML],
        ["  - enable_wxbindxml module:        yes"],
        ["  - enable_wxbindxml module:        no"])
UTILS_BOOLOPT_SUMMARY([USE_WXBINDXRC],
        ["  - enable_wxbindxrc module:        yes"],
        ["  - enable_wxbindxrc module:        no"])

echo
echo "  - compact list of the wxWidgets libraries for which"
echo "    binding modules will be created: "
echo "     $WXLIB_NAMES"
echo

UTILS_BOOLOPT_SUMMARY([USE_WXLUADEBUG],
        ["  - enable_wxluadebug module:           yes"],
        ["  - enable_wxluadebug module:           no"])
UTILS_BOOLOPT_SUMMARY([USE_WXLUASOCKET],
        ["  - enable_wxluasocket module:          yes"],
        ["  - enable_wxluasocket module:          no"])
UTILS_BOOLOPT_SUMMARY([USE_LUAMODULE],
        ["  - enable_luamodule module:            yes"],
        ["  - enable_luamodule module:            no"])
UTILS_BOOLOPT_SUMMARY([MONOLITHIC_LUAMODULE],
        ["  - enable_monolithic_luamodule module: yes"],
        ["  - enable_monolithic_luamodule module: no"])

# miscellaneous
echo
UTILS_BOOLOPT_SUMMARY([INSTALL_CUSTOM_WXBIND],
        ["  - install custom wxBind stuff:    yes"],
        ["  - install custom wxBind stuff:    no"])

# It is sometimes hard to dig out these values from the Makefiles

#echo "  - wxLua compiler and linker directives summary: "
#echo "    CFLAGS      : '$CFLAGS'"
#echo "    CXXFLAGS    : '$CXXFLAGS'"
#echo "    CPPFLAGS    : '$CPPFLAGS'"
#echo "    WX_CXXFLAGS : '$WX_CXXFLAGS'"
#echo "    LDFLAGS     : '$LDFLAGS'"
#echo "    WX_LIBS     : '$WX_LIBS'"
#echo "    WXLUA_LIBS  : '$WXLUA_LIBS'"
#echo " "

echo
echo "  - wxLua make install path settings:"
echo "    prefix      : '$prefix'"
echo "    exec_prefix : '$exec_prefix'"
echo "    libdir      : '$libdir'"
echo "    datadir     : '$datadir'"

#echo "  - wxWidgets wx-config information summary: "
#echo "    wx-config                   : '$WX_CONFIG_NAME'"
#echo "    wx-config flags             : '$WXCONFIG_FLAGS'"
#echo "    wx-config with args         : '$WX_CONFIG_WITH_ARGS'"
#echo "    wx-config --release         : '`$WX_CONFIG_NAME $WXCONFIG_FLAGS --release`'"
#echo "    wx-config --version-full    : '`$WX_CONFIG_NAME $WXCONFIG_FLAGS --version-full`'"
#echo "    wx-config --selected-config : '`$WX_CONFIG_NAME $WXCONFIG_FLAGS --selected-config`'"
#echo "    wx-config --prefix          : '`$WX_CONFIG_NAME $WXCONFIG_FLAGS --prefix`'"
#echo "    wx-config --exec-prefix     : '`$WX_CONFIG_NAME $WXCONFIG_FLAGS --exec-prefix`'"
#echo

WX_STANDARD_OPTIONS_SUMMARY_MSG_END

