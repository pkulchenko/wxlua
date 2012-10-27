wxLua readme.txt

wxLua is a Lua scripting language wrapper around the wxWidgets cross-platform
C++ GUI library. It consists of two IDE type editors that can edit, debug, and
run Lua programs (wxLua and wxLuaEdit), an executable for running standalone
wxLua scripts (wxLuaFreeze), a Lua module that may be loaded using
require("wx") when using the standard Lua executable, and a library for
extending C++ programs with a fast, small, fully embeddable scripting language.

Lua is a small scripting language written in ANSI C that can load and run
interpreted scripts as either files or strings. The Lua language is fast,
dynamic, and easy to learn. Lua contains a limited number of data types,
mainly numbers, booleans, strings, functions, tables, and userdata. Perhaps
the most powerful feature of the Lua language is that tables can be used as
either numerically indexed arrays or associative arrays that can
cross-reference any variable type to any other variable type.

wxLua adds to this small and elegant language the power of the C++ wxWidgets
cross-platform GUI library. This includes the ability to create complex user
interface dialogs, file and image manipulation, drawing, sockets, displaying
HTML, and printing to name a few. You can use as much or as little of wxWidgets
as you like and C++ developers can trim down the size the bindings by turning
off preprocessor directives.


References:
http://wxlua.sourceforge.net
http://www.lua.org
http://www.wxwidgets.org
