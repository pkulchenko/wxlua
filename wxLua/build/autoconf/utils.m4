dnl ---------------------------------------------------------------------------
dnl Author:          Francesco Montorsi
dnl Creation date:   20/3/2007
dnl RCS-ID:          $Id: utils.m4,v 1.3 2008/01/15 20:19:56 frm Exp $
dnl Purpose:         Some generic M4 utilities
dnl ---------------------------------------------------------------------------


dnl ---------------------------------------------------------------------------
dnl UTILS_YESNO_OPTCHECK([name of the boolean variable to set],
dnl                   [name of the --enable-option variable with yes/no values],
dnl                   [name of the --enable option])
dnl
dnl Converts the $3 variable, suppose to contain a yes/no value to a 1/0
dnl boolean variable and saves the result into $1.
dnl Outputs also the standard checking-option message.
dnl ---------------------------------------------------------------------------
AC_DEFUN([UTILS_YESNO_OPTCHECK],
        [
        AC_MSG_CHECKING([for the $3 option])
        if [[ "x$$2" = "xyes" ]]; then
            AC_MSG_RESULT([yes])
            $1=1
        else
            AC_MSG_RESULT([no])
            $1=0
        fi
    ])


dnl ---------------------------------------------------------------------------
dnl UTILS_YESNOAUTO_OPTCHECK([name of the boolean variable to set],
dnl                          [name of the --enable-option variable with yes/no/auto values],
dnl                          [name of the --enable option])
dnl
dnl Converts the $3 variable, suppose to contain a yes/no/auto value to a 1/0
dnl boolean variable and saves the result into $1.
dnl Outputs also the standard checking-option message.
dnl ---------------------------------------------------------------------------
AC_DEFUN([UTILS_YESNOAUTO_OPTCHECK],
        [
        AC_MSG_CHECKING([for the $3 option])
        if [[ "x$$2" = "xyes" ]]; then
            AC_MSG_RESULT([yes])
            $1=1
        elif [[ "x$$2" = "xauto" ]]; then
            AC_MSG_RESULT([auto])

            dnl We set $1 variable to "1" even if the user given the 'auto' option
            dnl value because the configure script is supposed to check for the
            dnl correctness of this option both in case "automatic" configuration
            dnl is enabled both in case the user explicitely gives a "yes" value
            dnl (think to external library checks: both in case 'auto' or 'yes' is
            dnl  given, the configure script will need to check the external library
            dnl  do exists and disable $1 variable if it does not).
            $1=1
        else
            AC_MSG_RESULT([no])
            $1=0
        fi
    ])


dnl ---------------------------------------------------------------------------
dnl UTILS_BOOLOPT_SUMMARY([name of the boolean variable to show summary for],
dnl                   [what to print when var is 1],
dnl                   [what to print when var is 0])
dnl
dnl Prints $2 when variable $1 == 1 and prints $3 when variable $1 == 0.
dnl This macro mainly exists just to make configure.ac scripts more readable.
dnl
dnl NOTE: you need to use the [" my message"] syntax for 2nd and 3rd arguments
dnl       if you want that M4 avoid to throw away the spaces prefixed to the
dnl       argument value.
dnl ---------------------------------------------------------------------------
AC_DEFUN([UTILS_BOOLOPT_SUMMARY],
        [
        if [[ "x$$1" = "x1" ]]; then
            echo $2
        elif [[ "x$$1" = "x0" ]]; then
            echo $3
        else
            echo "$1 is $$1"
        fi
    ])

# same as UTILS_BOOLOPT_SUMMARY but takes 2 bool options
AC_DEFUN([UTILS_2BOOLOPT_SUMMARY],
        [
        if [[ "x$$1" = "x1" -a "x$$2" = "x1" ]]; then
            echo $3
        elif [[ "x$$1" = "x0" -o "x$$2" = "x0" ]]; then
            echo $4
        else
            echo "$1 is $$1; $2 is $$2"
        fi
    ])

# same as UTILS_BOOLOPT_SUMMARY but takes 3 bool options
AC_DEFUN([UTILS_3BOOLOPT_SUMMARY],
        [
        if [[ "x$$1" = "x1" -a "x$$2" = "x1" -a "x$$3" = "x1" ]]; then
            echo $4
        elif [[ "x$$1" = "x0" -o "x$$2" = "x0" -o "x$$3" = "x0" ]]; then
            echo $5
        else
            echo "$1 is $$1; $2 is $$2; $3 is $$3"
        fi
    ])

AC_DEFUN([UTILS_BOOLOPT_INV_SUMMARY],
        [
        if [[ "x$$1" = "x0" ]]; then
            echo $2
        elif [[ "x$$1" = "x1" ]]; then
            echo $3
        else
            echo "$1 is $$1"
        fi
    ])

# same as UTILS_BOOLOPT_SUMMARY but takes 2 bool options
AC_DEFUN([UTILS_2BOOLOPT_INV_SUMMARY],
        [
        if [[ "x$$1" = "x0" -a "x$$2" = "x0" ]]; then
            echo $3
        elif [[ "x$$1" = "x1" -o "x$$2" = "x1" ]]; then
            echo $4
        else
            echo "$1 is $$1; $2 is $$2"
        fi
    ])


dnl ---------------------------------------------------------------------------
dnl UTILS_SAVE_COREVAR()
dnl
dnl Saves the CPPFLAGS, CXXFLAGS, CFLAGS and LIBS variables in some helper
dnl variables which are used to restore them later (see UTILS_RESTORE_COREVAR)
dnl ---------------------------------------------------------------------------
AC_DEFUN([UTILS_SAVE_COREVAR],
        [
        SAVED_CPPFLAGS="$CPPFLAGS"
        SAVED_CXXFLAGS="$CXXFLAGS"
        SAVED_CFLAGS="$CFLAGS"
        SAVED_LIBS="$LIBS"
    ])


dnl ---------------------------------------------------------------------------
dnl UTILS_RESTORE_COREVAR()
dnl
dnl Loads into the CPPFLAGS, CXXFLAGS, CFLAGS and LIBS variables the values
dnl of the helper variables set by UTILS_SAVE_COREVAR
dnl ---------------------------------------------------------------------------
AC_DEFUN([UTILS_RESTORE_COREVAR],
        [
        CPPFLAGS="$SAVED_CPPFLAGS"
        CXXFLAGS="$SAVED_CXXFLAGS"
        CFLAGS="$SAVED_CFLAGS"
        LIBS="$SAVED_LIBS"
    ])



