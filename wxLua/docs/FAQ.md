% wxLua 3.2.0.2 - FAQ
% John Labenski
% 2022-11-06

## Table of Contents

1.  [Why wxLua?](#C1) \
    1.1 [What's best for my needs: wxLua, wxPython, wxSomethingElse?](#C1.1) \
    1.2 [Can I use wxLua as script interpreter embedded in my own C++ applications?](#C1.2)
2.  [How to learn wxLua](#C2) \
    2.1  [Read the wxLua documentation](#C2.1) \
    2.2  [Read the C++ wxWidgets documentation](#C2.2) \
    2.3  [Run and trace through the samples](#C2.3)
3.  [Programming in wxLua](#C3) \
    3.1 [wxStrings?](#C3.1) \
    3.2 [wxArrayString and wxSortedArrayString?](#C3.2) \
    3.3 [wxArrayInt?](#C3.3) \
    3.4 [When and how should you delete() objects?](#C3.4) \
    3.5 [Why do the samples use the function main() and is it special to wxLua?](#C3.5) \
    3.6 [Why are the arguments shifted +1 for error messages from class member function calls?](#C3.6)
4.  [Lua Module using require()](#C4) \
    4.1 [Why does the GUI not work from the Lua console?](#C4.1)
5.  [Building wxLua](#C5) \
    5.1 [Why are there so many warnings when building from source?](#C5.1)


<a name="C1"/>

## 1 - Why wxLua?

-   Because the Lua language is easy and straightforward to program in.
-   It vaguely looks like BASIC or C which many people are familiar with.
-   The code is very readable, almost no special notation, gotchas, or oddball
    constructs that require a large shift in thinking from BASIC or C.
-   Size : The Lua interpreter is ~100Kb, wxWidgets adds the remaining few Mb.
-   Speed : Lua is one of the fastest interpreted languages;
    see the Great Computer Language Shootout.
-   Again, why Lua? See
    [http://www.lua.org/about.html](http://www.lua.org/about.html)

<a name="C1.1"/>

### 1.1 - What's best for my needs: wxLua, wxPython, or wxSomethingElse?

-   It depends, wxPython has a much larger footprint and greater overhead than
    wxLua, but it does provide more add-ons from the Python standard library.
-   On the other hand, wxLua is is the size of wxWidgets + ~100Kb for
    Lua + ~500Kb for the wxLua library.
-   wxLua is designed to be easily interfaced with C++ code making it a
    powerful extension language.
-   In conclusion, if you want to write an entire application in a scripting
    language and you need things supported by Python which are not present in
    wxLua out-of-the-box, then you should use wxPython.
    Instead, if you want to write applications with little overhead or
    extend your C++ applications, try wxLua.

<a name="C1.2"/>

### 1.2 - Can I use wxLua as script interpreter embedded in my own C++ applications?

-   Yes, the C++ programming guide in the
    [wxLua Manual](wxlua.html#cpp_programming_guide)
    describes how to create and use a wxLuaState.
-   This is a strong point of wxLua; it is a fast and lightweight interpreter
    that is easy to use to extend an application and/or let users customize it.
-   You may create as many wxLua interpreters in a single program as you like.

<a name="C2"/>

## 2 - How to learn wxLua

<a name="C2.1"/>

### 2.1 - Read the wxLua documentation

-   [wxlua.html](wxlua.html) is the manual for wxLua that briefly describes the
    Lua language as well as where the wxWidgets C++ types are placed in Lua
    and how to create and use them.
-   [wxluaref.html](wxluaref.html) is an autogenerated document that can
    be thought of as a reference manual. It shows exactly what wxLua binds from
    wxWidgets. It also has usage notes for the cases where wxLua differs
    from C++ wxWidgets.
-   [binding.html](binding.html) describes how to write your own bindings for
    a C or C++ library. People who will only write Lua code should also read
    it to be able to interpret the [wxluaref.html](wxluaref.html) document.

<a name="C2.2"/>

### 2.2 - Read the C++ wxWidgets documentation

-   wxLua is mapped very closely to wxWidgets which means that
    descriptions for the C++ functions and values also apply to wxLua.
    See the [wxluaref.html](wxluaref.html) document to verify that this
    is the case since any non-default behavior will be clearly marked.
-   See the wxWidgets Wiki for examples of code, beginner howtos, and
    other useful bits of information.
-   See wxPython documentation and their Wiki, but note that wxLua
    follows the C++ notation a little closer than wxPython does.

<a name="C2.3"/>

### 2.3 - Run and trace through the samples

-   The wxLua samples try to show off various classes and their usage.
-   `unittest.wx.lua` is used to confirm that wxLua is operating properly,
    however it provides a wealth of information about what is allowed in
    terms of calling functions, casting classes to other classes, using
    virtual functions, and derived functions.
-   `binding.wx.lua` traverses the C structs that store the data used for wxLua
    and it's worth taking the time to browse them to see what is where and
    how it all fits together.

<a name="C3"/>

## 3 - Programming in wxLua

<a name="C3.1"/>

### 3.1 - wxStrings or ANSI Lua strings?

-   wxLua uses Lua strings and so all functions that take or return a
    wxString take or return a Lua string.
-   However, you can also use a wxString in Lua if you really want to.

<a name="C3.2"/>

### 3.2 - wxArrayString and wxSortedArrayString?

-   All functions that take a wxArrayString or wxSortedArrayString can
    also take a numerically indexed Lua table of strings.
-   Functions that return wxArrayStrings or wxSortedArrayStrings will
    return a wxArrayString or wxSortedArrayString unless specified
    otherwise in [wxluaref.html](wxluaref.html)

<a name="C3.3"/>

### 3.3 - wxArrayInt?

-   All functions that take a wxArrayInt can also take a numerically
    indexed table of numbers.
-   Functions that return wxArrayInts will return a wxArrayInt unless
    specified otherwise in [wxluaref.html](wxluaref.html).

<a name="C3.4"/>

### 3.4 - When and how should you delete() objects?

-   You should read the subsection "C++ Classes CLASS_NAME" of the
    "Programming in wxLua" section of the [wxlua.html](wxlua.html) manual.
-   In short, all objects that you create that deal with graphics should
    be delete()ed as soon as they're no longer used. Functions that take a
    `const wxPen& pen`{.lua} or any wxObject derived class that are passed
    to a function that is const and not a pointer\* will make a refed copy of
    them and so you may immediately delete them after the function call.
-   Use the function `t = wxlua.GetGCUserdataInfo()`{.lua} to get a table
    of items that are tracked and either have an active variable pointing
    to them or are waiting to be garbage collected.
-   Class objects that have the `%delete` tag in their declaration (see
    [wxluaref.html](wxluaref.html)) will be automatically garbage
    collected or can be delete()ed with the wxLua added function for the
    class. There are, of course, exceptions and these occur when you
    pass the object as a parameter to a function with the `%ungc` tag on it.
    The ungarbage collect tag specifies that the object is now owned by
    something else and you can no longer delete it in wxLua.
-   Bottom line - don't worry about delete()ing anything except:
    -   Graphics objects (for MSW really).
    -   Classes that specifically state (in
        [wxluaref.html](wxluaref.html)) that you should delete() them
        because the garbage collector may not do so soon enough.
    -   Objects that may be very large, like a wxImage(1000, 1000).

<a name="C3.5"/>

### 3.5 - Why do the samples use the function main() and is it special to wxLua?

-   There's nothing special about the function `main()`{.lua} other than
    that it's a common name for an entry point into a program.
-   It is often a good idea to encapsulate the program initialization code
    within a function so that you can use local variables and not pollute the
    global table with temporary variables that won't be needed again.
-   Additionally, it allows you to break out of this initialization code
    at any point by putting `do return end`{.lua} inside of the function
    for debugging, as opposed to wrapping parts you don't want using
    `if false then ... end`{.lua}.

<a name="C3.6"/>

### 3.6 - Why are the arguments shifted +1 for error messages from class member function calls?

-   Because the ':' calling convention is syntaxic sugar for putting the
    'self' as the first parameter.
-   `s = wx.wxSize(1, 2); s:Set(3, 4)`{.lua} is the same as
    `s.Set(s, 3, 4)`{.lua} and the first parameter is always the self,
    therefore `s.Set(s, "hello", 4)`{.lua} or `s:Set("hello", 4)`{.lua}
    will give an error that parameter 2 is not a number.
-   Unfortunately there is no way to tell whether the user has used the
    '.' or ':' calling convention and so the error message cannot be
    tailored for both static and nonstatic member functions.
    Just remember that the first parameter for nonstatic class member
    functions called using the ':' notation is the 'self'.

<a name="C4"/>

## 4 - Lua Module using require()

<a name="C4.1"/>

### 4.1 - Why does the GUI not work from the Lua console?

-   wxLua is a user-interactive GUI library that requires an event-loop to
    process user interaction with the controls,
    E.G. key presses and mouse-clicks.
-   [wxlua.html](wxlua.html) in section
    [6.1 - How to Run the Samples](wxlua.html#C6.1)
    has more informaton about using wxLua from the Lua console.
-   Briefly - In order to use wxLua as a module, the Lua code must have
    `require("wx")`{.lua} to load the wxLua bindings in the
    beginning and `wx.wxGetApp():MainLoop()`{.lua} at the end of the
    source code to run the wxWidgets event loop.
-   When `wx.wxGetApp():MainLoop()`{.lua} is called, the console will
    appear to be hung, but you have simply started the wxWidgets event-loop
    and the program is waiting for you to press buttons, open menus...
-   A soon as there are no longer any top-level windows open the MainLoop()
    exits and control is either returned to the Lua console or, if run
    without the console, the program exits.

<a name="C5"/>

## 5 - Building wxLua

<a name="C5.1"/>

### 5.1 - Why are there so many warnings when building from source?

-   wxLua was initially written before 2000 for wxWindows (now wxWidgets) 2.2.
-   As wxWidgets changes so too must wxLua.
-   wxWidgets marks functions no longer used as deprecated in one release and
    removes them in the next release.
-   This means that for wxLua to support wxWidgets 2.8, we use deprecated
    functions from 2.6, for 2.9 we use deprecated functions from 2.8...
-   To some extent, having these warnings is intentional, though unfortunate...
