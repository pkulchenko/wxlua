wxluafreeze readme.txt

The wxLuaFreeze application creates the wxWidgets wxApp and then tries to load
a script that has been attached to the executable using wxluafreeze.lua. It is
a simple way make a single file wxlua application into an executable.

1) Compile the wxLuaFreeze application for the system of your choice. You'll
want to compile it statically and in release mode so that all that's required
for the resultant app is a single executable.

2) Run $lua wxluafreeze.lua to attach your single file wxlua script to the
wxLuaFreeze application. To get help on using wxluafreeze.lua just run it
without any command line parameters.

For example in MSW in the wxLua\bin dir:
lua.exe ..\apps\wxluafreeze\apps\wxluafreeze.lua wxluafreeze.exe myprogram.wx.lua myprogram.exe

3) Optionally use the program "upx" to compress the executable. The wxLuaFreeze
program is ~4.5 Mb in release mode using the MSVC6, but after compression
it's size is ~1.5 Mbytes, about 1/3 the size.
