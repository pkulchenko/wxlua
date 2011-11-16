wxLuaEditor is an application and sample program that demonstrates an embedded 
wxLua interpreter. This means that wxLua is run in the same thread as the 
main program and "threading" is done by using lua's debug facility to run the
wxWidgets message pump and see if the user has pressed stop. The editor
itself can load/save/run lua programs and it also has a console for entering
single line lua code for quick testing.

------------------------------------------------------------------------------
Building
------------------------------------------------------------------------------

wxLuaEditor depends on the wxcode.sourceforge.net component wxstedit for it's
scintilla text editor functionality. You must have compiled wxstedit first and
set the environment variable WXCODE to point to the root direction of wxCode.

------------------------------------------------------------------------------
Files
------------------------------------------------------------------------------

wxluaedit.cpp    -- sample IDE type editor
Makefile         -- gmake for gcc to compile the wxluaedit program (unix)
wxledit.cpp      -- contains an editor, shell, console class
wxLedit.h

The two files wxledit.h/cpp can be easily used in another project by simply
adding them to your project's build.
