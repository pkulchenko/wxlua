9/10/2012

This is a description of the directory structure of wxLua.

-------------------------------------------------------------------------------
Directory structure of wxLua
-------------------------------------------------------------------------------


/apps/          - C/C++ application code is here
    /wxlua/     - wxLua IDE using samples/edit.wx.lua
    /wxluaedit/ - wxLuaEdit IDE using wxStEdit as the editor
    /wxluafreeze/ - A program to execute wxLua code
    /wxluacan/  - A sample of how to write your own bindings

/art/           - Images and icons

/bin/           - Output executables are built here by Makefile.wx-config

/bindings/      - Input *.i files to make the "wrappers"
    genwxluabind.lua - Binding generator, converts *.i to *.cpp
    /wxwidgets/ - Wrapper files for wxWidgets
    /wxluadebugger/ - Wrapper files for bindings for wxlua/debugger

/build/         - Build files to compile wxLua

/distrib/       - Files to make a wxLua distribution with
    /autopackage/
    /innosetup/
    /macbundle/

/docs/          - Docs for wxLua
    /doxygen/   - Output dir for doxygen using doxygen.cfg file.

/lib/           - Output libs are built here by Makefile.wx-config

/modules/           - C/C++ code for wxLua libraries
    /lua/           - Lua distribution
        /include/   - headers from src copied here for install routine
        /src/
        /the rest of lua.../
    /luamodule/     - A Lua module, shared library, to load using require.
    /wxbind/        - Output from /bindings/wxwidgets
    /wxlua/         - the main wxlua library itself
        /debug/     - Debug code, to show stack, and variables
        /debugger/  - Remote debugging over TCP code

/samples/           - Sample wxlua programs

/util/              - Utilility programs
    /bin2c/         - A lua program to convert files to an unsigned char array
