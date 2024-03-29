% wxLua 3.2.0.2 - Writing and Generating Binding Files
% John Labenski
% 2022-11-06

The binding generator for wxLua provides information for Lua code to
interface to a C/C++ API. The C/C++ objects are created in Lua as userdata
and manipulated using the same functional semantics as you would in C/C++.
The wxLua manual, [wxlua.html](wxlua.html), describes in detail how the object
will be named and where it will be placed in Lua.

wxLua has binding files for the wxWidgets cross-platform GUI library
and the wxStyledTextCtrl contrib library of the wxWidgets library.
The binding generator is flexible enough to be used to create bindings for
other projects. This allows wxLua to be integrated as a scripting language in
C++ projects. There is an example in the `wxLua/apps/wxluacan` directory.

The interface files are stripped down skeletons of C/C++ header files. The
program `bindings/genwxbind.lua` parses these files and generates C functions
that are exposed to Lua by a generated `wxLuaBinding` derived class.
The whole process of generation is automatic and no editing of the output
files should be attempted. If there are any problems, the interface files or
the generator should be fixed. Some examples of the interface files are in the
`bindings/wxwidgets/*.i` directory. Before writing your own, take some time to
examine them and note the differences between them and the original C++ code.
If the automatic bindings do not generate suitable code for a specific
function you can `%override` individual function bindings with your own code
to implement it in any way you want.

## Table of Contents

1.  [Binding File Descriptions](#C1)
2.  [Generated Files](#C2)
3.  [Binding C++ Virtual Functions](#C3)
4.  [Interface File Constructs](#C4) \
    4.1 [Special Function Parameters](#C4.1) \
    4.2 [C++ Class Member Function Directives](#C4.2) \
    4.3 [Comments](#C4.3) \
    4.4 [Interface Tags](#C4.4)


<a name="C1"/>

## 1 - Binding File Descriptions

### bindings/genwxbind.lua

-   This program is the binding file generator that converts the *.i interface
    files into a set of C/C++ files to be compiled into a library and linked to
    or compiled along with your program.
-   `bindings/wxwidgets/wxbase_rules.lua` (for example) is a rules file that
    determines where and what interface files `genwxbind.lua` should read,
    how it should name the generated classes and output files, what extra
    header code to add, among other things.
    Documentation for creating a rule file is in each of the ones provided by
    wxLua and you should copy one to use as a starting point for your own.
-   The rules files are actual Lua programs that `genwxbind.lua` runs
    before processing the interface files, but after it has created
    various structures used for parsing allowing for customization by
    either adding to the structures or changing them.
-   Command line usage of genwxbind.lua
    -   `lua -e"rulesFilename="wxwidgets/wx_rules.lua"" genwxbind.lua`
    -   Informational messages, warnings, and errors are printed to the console.
    -   The output files are only overwritten if they differ.

### *.i interface files

-   Contain a skeleton of the C/C++ functions, classes, global variables,
    #defines that should be made accessible to Lua.
-   See [Interface File Constructs](#C4) below.
-   The structure of wxLua's interface files follows the wxWidgets
    documentation, typically alphabetical.
    -   Class constructors first, class member functions, %operators, %members.

### *_datatypes.lua files

-   These are generated files that contain Lua tables of typedefs, datatypes,
    and preprocessor conditions defined in a binding that may be used by
    another binding by adding them to the
    `datatype_cache_input_fileTable`{.lua} variable of the rules file.
-   The checking of known datatypes enforces that the generated bindings will
    work correctly. If a datatype is missing it will be unusable in Lua.
-   The items are added to the `typedefTable`{.lua},
    `dataTypeTable`{.lua}, and `preprocConditionTable`{.lua} variables
    of the `genwxbind.lua` program.
-   All of the wxWidgets types are added to the
    `bindings/wxwidgets/wx_datatypes.lua` file which may be used by external
    bindings that use datatypes declared in the wxLua wxWidgets bindings.
-   Each `bindings/wxwidgets/wx*_rules.lua` file will generate its own
    `wx*_datatypes.lua` datatype file, but these are gathered together into
    the `wx_datatype.lua` file for use by others.

### wxluasetup.h

-   Contains #defines of all of the `wxLUA_USE_XXX` for C++ compilation of the
    wxWidgets bindings.
-   This file is special to wxLua's wxWidgets binding.
-   If `wxLUA_USE_XXX` is 1 then it's compiled in and will be accessible to
    wxLua scripts, else skipped when compiling the binding cpp files to create
    a smaller library.
-   The primary reason to change the default, which has everything enabled,
    would be to cut down on the size of wxLua by removing the parts of the
    bindings that will not be used. Functionalty can also be removed if some
    sandboxing is required. These defines mixed with wxWidget's own `wxUSE_XXX`
    #defines control what parts of wxWidgets is available to wxLua programs.
-   For example, if you exclude the `wxColour` class by #defining
    `wxLUA_USE_wxColourPenBrush=0` then all functions that take or
    return a `wxColour` will be excluded. The best thing to do is to test
    things out and see what works for you.

### overrides.hpp

-   Contains functions that cannot be automatically wrapped.
-   You can name the file anything you want and have multiple files
    since it is specified as a table in the rules file.
    -   `override_fileTable = { "override.hpp" }`{.lua}

-   Functions that take pointers or references and return values through
    the variables passed in must be reworked to return multiple values.

-   In order for the `%overload` functionality to work and to get the proper
    signatures; the function parameters in the .i file should match the actual
    parameters that the `%override` code implements. The interface files for
    wxLua always have these three lines, where the first line is for
    documentation purposes only, the second line is the original C++ function
    declaration for reference, this is what wxWidgets expects to get, and the
    third line is the correct calling semantics for the `%overridden` function.

~~~
    // %override void wxFrame::SetStatusWidths(Lua table with number indexes and values)
    // C++ Func: virtual void SetStatusWidths(int n, int *widths)
    virtual void SetStatusWidths(LuaTable intTable)
~~~

<a name="C2"/>

## 2 - Generated Files

The binding generator `genwxbind.lua` generates a number of files and you
can specify both their names and directories.

-   A single header file is generated that typically does not have to be
    included by any files other than those generated by the bindings.
    -   Contains all the #includes and exports the tags, structs, and
        functions for use in a DLL.

-   The only function that absolutely must be called is
    `wxLuaBinding_[hook_cpp_binding_classname]_init()`.
    -   It is probably easiest to declare the function using
        `extern bool wxLuaBinding_[hook_cpp_binding_classname]_init();`
        in your C++ file rather than including the header.

    -   This function contains a static instance of the generated
        `wxLuaBinding` derived class that is added to a static wxList of
        bindings. There should only be one of the binding classes
        created as they all share the same structures anyway.
    -   The function `static wxLuaBindingList* wxLuaBinding::GetBindingList()`
        can be used to iterate through the bindings, if needed.
    -   Note: A variety of different ways to automatically initialize the
        bindings were tried that would invariably fail with certain compilers,
        but work with others. Having to call the init function before creating
        a wxLuaState seems to work everywhere as it guarantees that when the
        bindings are compiled as a library, at least something in it is used
        and the linker won't throw the whole lib out.

-   Each *.i binding file will have a *.cpp file generated that contains:
    -   Unique integer types, `int s_wxluatag_CLASS_NAME`, for each class that
        are mapped through the wxLuaBindClass struct. When the binding is
        initialized, a unique the tag index will be assigned to the class for
        marking the Lua userdata wrapper with its type.
    -   C functions, `int ClassMethodFunction(lua_State* L)`, that are called
        for the class methods.
    -   A `wxLuaBindMethod` struct for each class to map the method function
        names to the C functions.

-   A single C++ file to pull all the remaining parts together that contains:
    -   A `wxLuaBindEvent` struct that contains all the `wxEventType` values
        and their associated `wxEvent` classes
        to push into the Lua binding table.
    -   A `wxLuaBindDefine` struct that contains all the numerical values
        to push into the Lua binding table.
    -   A `wxLuaBindString` struct that contains all the strings
        to push into the Lua binding table.
    -   A `wxLuaBindObject` struct that contains all the objects
        to push as userdata into the Lua binding table.
    -   A `wxLuaBindMethod` struct that contains all the global C functions
        to push into the Lua binding table.
    -   A `wxLuaBindClass` struct that contains the class names, all the
        `wxLuaBindMethod` structs from each *.i generated cpp files, and
        their tags.
    -   A `wxLuaBinding` derived class that actually pushes the bindings
        into Lua.

<a name="C3"/>

## 3 - Binding C++ Virtual Functions

The only way to handle C++ virtual functions in wxLua is to subclass the
C++ class you want to be able to write Lua functions for and bind the
subclassed version. The hand coded `wxLuaPrintout` class is a good example
of this. Below is a description of how the C++ code and Lua work to allow
overriding a C++ virtual class member function from Lua.

The wxWidgets class `wxPrintout` has a number of virtual functions, but
lets focus on `virtual bool wxPrintout::OnBeginDocument(int startPage,
int endPage)` as an example, since if you override this function you
must also call the base class function for printing to operate correctly.
The source code for the class wxLuaPrintout located in
`modules/wxbind/include/wxcore_wxlcore.h` and
`modules/wxbind/src/wxcore_wxlcore.cpp` and you should review it before
reading further. You will also need to look at `samples/printing.wx.lua`
to see the Lua code that overrides the function and `modules/wxlua/wxlbind.cpp`
for the metatable functions Lua uses to handle a call to a function.

Below is a list of the function calls for `wxPrintout::OnBeginDocument()`
and notes about how it all works.

-   Create a userdata `wxLuaPrintout` in Lua, replace the function
    `OnBeginDocument()` with our own function in Lua, and begin the printing
    process, perhaps doing a print preview.
    The code for this is in the `printing.wx.lua` sample.
-   The wxWidgets printing framework calls
    `virtual wxPrintout::OnBeginDocument(...)`, but we've subclassed wxPrintout
    and so its function `wxLuaPrintout::OnBeginDocument(...)` gets called.
    -   The class `wxLuaPrintout` keeps a refed copy of the `wxLuaState`
        from when it was created since otherwise the function
        `wxLuaPrintout::OnBeginDocument()` wouldn't know what `lua_State`
        is active since wxWidgets doesn't know anything about wxLua.

-   In `wxLuaPrintout::OnBeginDocument()` we first check to see if
    `wxLuaState::GetCallBaseClassFunction()` is true, if not, check to
    see if `wxLuaState::HasDerivedMethod(this, "OnBeginDocument")` is true,
    where *this* is the particular instance of the `wxLuaPrintout` class.
    -   If we're not supposed to call the base class and there is a Lua
        function that replaces `OnBeginDocument()` we'll use it.
        First push the `wxLuaPrintout` and the parameters to the function
        that's already been pushed on the stack by a successful call to
        `wxLuaState::HasDerivedMethod()` when it calls
        `wxLuaObject::GetObject()`. Call it and then get the result, if any,
        pop the result, and reset the stack to the starting point.
    -   On the other hand; if we're supposed to call the base class
        function or there isn't a derived Lua method we'll just call
        `wxPrintout::OnBeginDocument(...)` explicitly.

-   Here's the tricky part for Lua derived functions that then call the
    base class function. In this case we're not calling the "base" class
    function of `wxLuaPrintout`, but rather `wxPrintout` since `wxLuaPrintout`
    is a hollow shell that merely forwards calls to Lua or to the base class.
    -   When in Lua we call `_OnBeginDocument(...)` on the
        `wxLuaPrintout` userdata object, the function
        `wxluabind__index_wxLuaBindClass(...)` in
        `modules/wxlua/wxbind.cpp` is called. This is the function
        that handles all function calls for wxLua userdata objects. It
        performs a lookup to see if the function exists and pushes it onto
        the stack for Lua to call **after** this function has returned.
    -   This is why we set a variable using
        `wxLuaState::Set/GetCallBaseClassFunction()` to remember if the
        Lua function was called with a preceding "_".
    -   The reason why we need to reset the `GetCallBaseClassFunction()`
        from within our derived C++ virtual class function is that
        wxWidgets may immediately call another C++ virtual function, but
        the wxLuaState is still flagged to call the base class and so
        calls to functions like `wxLuaPrintout::OnPrintPage(...)` fail
        since they are directed to call the base class function and not
        our derived Lua functions.

To summarize, here's the function calls and where in each function
`wxLuaPrintout::OnBeginDocument()` is when you override the function in Lua.

1.  wxWidgets calls `wxLuaPrintout::OnBeginDocument(...)` in C++.
2.  `wxLuaPrintout::OnBeginDocument(...)` runs the code to call the derived Lua
    function `OnBeginDocument(...)` by calling `wxLuaState::LuaCall()` on it.
    (GetCallBaseClassFunction() and HasDerivedMethod() are both true)
3.  `wxluabind__index_wxLuaBindClass(...)` is called when, in Lua, the
    function `_OnBeginPrinting()` is called for the `wxLuaPrintout` userdata.
    The flag `wxLuaState::GetCallBaseClassFunction()` is set to true,
    and the C function `wxLua_wxPrintout_OnBeginDocument()`
    (in `modules/wxbind/src/wxcore_print.cpp`) is run by Lua which calls
    back to `wxLuaPrintout::OnBeginDocument(...)`.
4.  We enter `wxLuaPrintout::OnBeginDocument(...)` a second time, the
    first time through is still stalled at `wxLuaState::LuaCall()` running
    Lua's `OnBeginDocument()` function, but this time we just call
    `wxPrintout::OnBeginDocument()` and return.
5.  The `wxLuaState::LuaCall()` function finishes and the first call to
    the function `wxLuaPrintout::OnBeginDocument(...)` returns.
6.  Success!

<a name="C4"/>

## 4 - Interface File Constructs

<a name="C4.1"/>

### 4.1 - Special Function Parameters

-   These parameters are interpreted by the generator to implement code to
    handle a few special cases so we don't have to write overrides for them.

-   **const wxArrayString& choices or wxArrayString choices**
    -   The binding generator will read from Lua either a wxArrayString or a
        numerically indexed table of strings for that parameter and
        convert them into a wxArrayString for the C++ function.
    -   If the parameter is either `wxArrayString& choices` or
        `wxArrayString* choices`, the generator will not perform the table
        conversion, but will require a wxArrayString userdata since it's
        assumed that the C++ function will modify the wxArrayString that's
        passed to it for the caller to use as a return value.

-   **const wxArrayInt& choices or wxArrayInt choices**
    -   The binding generator will read from Lua a wxArrayInt or a
        numerically indexed table of integers for that parameter and
        convert them into a wxArrayInt for the C++ function.
    -   If the parameter is either `wxArrayInt& choices` or
        `wxArrayInt* choices`, the generator will not perform the table
        conversion, but will require a wxArrayInt userdata since it's
        assumed that the C++ function will modify the wxArrayInt that's
        passed to it for the caller to use as a return value.

-   **IntArray_FromLuaTable**
    -   The binding generator will read from Lua a numerically indexed table
        array of integers and pass two parameters (int count, int* array) to
        the function.
    -   The int* array will be automatically deleted and the function
        must not take ownership of it and delete it itself.

-   **LuaTable tableName**
    -   The "datatype" LuaTable does not actually exist, but is used
        exclusively for %override functions in the .i interface files. It
        directs the binding generator to expect a Lua table for that parameter.
    -   Any function declaration that uses this as a parameter must be an
        %overrride as the generated code will not compile.
    -   This is useful for functions like wxFrame::SetStatusWidths().

-   **LuaFunction functionName**
    -   The "datatype" LuaFunction does not actually exist, but is used
        exclusively for %override functions in the .i interface files. It
        directs the binding generator to expect a Lua function for that parameter.
    -   Any function declaration that uses this as a parameter must be an
        %overrride as the generated code will not compile.

-   **voidptr_long**
    -   This is for functions that take a (void *) pointer
        and DO NOT EVER TRY TO CAST IT, ACCESS IT, OR DELETE IT.
        This tag will allow the Lua code to put a number (perhaps a table
        index) as the void* pointer value.
    -   See Get/SetClientData() functions in the wxWidgets bindings.

<a name="C4.2"/>

### 4.2 - C++ Class Member Function Directives

-   **const**
    -   This function attribute is ignored since wxLua doesn't create const
        objects, it's safe to leave it in the interface files as a reminder.

-   **static**
    -   Can be used with class member functions inside the *class* tag.
    -   Do not use with C style global functions.
    -   The generated code will call ClassName::FunctionName() and not
        use the object even if called with an object.
    -   Example : In the class wxFileName the function \
        *"static wxFileName DirExists(const wxString& dir)"* \
        `dir = wx.wxFileName.DirExists("/some/dir")`{.lua} or \
        `f = wx.wxFileName(); dir = f.DirExists("/some/dir")`{.lua}
    -   The bindings generate code to make the function accessible in the
        class table (first example above) as well as when called using a object.

-   ***virtual***
    -   *Currently ignored - TODO perhaps*

<a name="C4.3"/>

### 4.3 - Comments

-   **//** as in C++ to comment out the rest of a line of text.
-   **/\* ... \*/** to comment multiline blocks.

<a name="C4.4"/>

### 4.4 - Interface Tags

The descriptions below use `wx` the name of the binding table in Lua.
Other bindings would, of course, use their own tables.

***%alias***

-   Reference a class by another name (currently unused).

***class [%delete] ClassName [: public BaseClassName [, public BaseClassName2]] \
{ \
    ClassName(...) \
    member functions \
    ... \
};***

-   Declare a class and optionally its base class.
-   All methods of the base class can be called by an instance of the class.
-   If the class is in a namespace, such as `ns::ClassName`, the class must be
    declared as `class [...] ns::ClassName` and the constructor must also be
    declared as `ns::ClassName(...)`.
    The generator will change the "::" to "_" for use in Lua.
-   ***%delete*** can be used for classes you want the Lua garbage collector
    to delete when the object goes out of scope.
    -   For example; a `wxPoint` should be deleted when there are no longer any
        references to it, but `wxWindows` are typically attached to a parent
        and the parent `wxWindow` will delete its children, not Lua.
    -   Simple classes like `wxPoint` or ref-counted `wxObject` dervied classes
        like `wxPen` are often returned by C++ functions on the stack. wxLua
        will make a 'new' object, copy the value using the C++ '=' operator,
        and set a flag that this new object is to be deleted when the Lua
        garbage collector calls the wxLua collection function.
    -   Classes that will always be "owned" and deleted by other objects
        should not use this tag.
    -   See also %gc, %ungc, %gc_this, %ungc_this.

***#define NUMBER_NAME [Value]***

-   Declare a number which can be accessed in Lua using `wx.NUMBER_NAME`.
-   The *NUMBER_NAME* can be a #define, an integer, a double...
-   The optional parameter *[Value]* can be used to override or set the
    numerical value. This can be used to set preprocessor directives
    such as, *"#define A_DEFINE"* that don't have a value itself.
    In this case assign it to be 1 using `#define A_DEFINE 1`.
-   There are many examples of *#define* in `bindings/wxwidgets/defsutils.i`.

***#define_object OBJECT_NAME***

-   Declares an object in the binding table which can be accessed in
    Lua using *wx.OBJECT_NAME*.
-   This tag must be used inside the corresponding *class* tag so that
    the object's class methods can be known to Lua and the generator can
    assign the correct class type to it.
-   An example of this is in the wxPoint class interface in
    *bindings/wxwidgets/gdi.i*, *"#define_object wxDefaultPosition"*
    where wxWidgets has created wxDefaultPosition as
    *"const wxPoint wxDefaultPosition;"*.

***#define_pointer POINTER_NAME***

-   Declares a pointer to an object in the binding table which can be
    accessed in wxLua using *wx.POINTER_NAME*.
-   This tag must be used inside the corresponding *class* tag so that
    the pointer's methods can be known to Lua and the generator can
    assign the correct class type to it.
-   An example of this is in the wxPenList class interface in
    *bindings/wxwidgets/gdi.i*, *"#define_pointer wxThePenList"* where
    wxWidgets has created the wxThePenList as
    *"wxPenList* wxThePenList;"*.

***#define_string STRING_NAME [Value]***

-   Declares a string in the binding table which can be accessed in wxLua using
    *wx.STRING_NAME*.
-   The *STRING_NAME* must be defined as
    *"const char* STRING_NAME = "str"* or some way that
    allows it to be converted easily to *"const char*"*.
-   The optional parameter *[Value]* can be the actual string value to
    use and should be "str" or a const char*
    variable declared elsewhere.

***#define_wxstring STRING_NAME [Value]***

-   Declares a string in the binding table which can be accessed in wxLua using
    *wx.STRING_NAME*.
-   The *STRING_NAME* must be defined as
    *"const wxChar* STRING_NAME = _("str") or wxT("str")"* or some way that
    allows it to be converted easily to *"const wxChar*"* in Unicode or not.
-   The optional parameter *[Value]* can be the actual string value to
    use and should be _("str"), wxT("str"), or a const wxChar*
    variable declared elsewhere.
-   Note : wxString is not used since tou can't get the data from a wxString
    if you need to convert from Unicode and VC has problems having the
    class wxString as a member of a struct.

***enum [Enum_Type or ClassName::Enum_Type or Namespace::Enum_Type] \
{ \
    ENUM_ITEM1 \
    ENUM_ITEM2 \
    ... \
 };***

-   Declares enumerations in the binding table which can be accessed in
    wxLua using *wx.ENUM_ITEM1* as it could be in C++, meaning that the
    *Enum_Type* is stripped off.
-   If the enum is a part of a class use *"enum ClassName::Enum_Type"*
    and the enums will be accessed in wxLua as *"wx.ClassName.ENUM_ITEM1"*.

***functions : return_type FUNCTION_NAME(int value, ...)***

-   Declares a global C style function in the binding table which can be
    accessed in wxLua using *wx.FUNCTION_NAME(int value, ...)*.
-   An example of this is in *bindings/wxwidgets/datetime.i*,
    *"wxString wxNow()"*.

***%gc***

-   Use before a userdata parameter of a function or its return value only.
-   Declares that the parameter passed to the function or return value should
    be garbage collected or able to be delete()ed by the Lua program.
-   This is for C++ functions that change the 'ownership' of a userdata object
    and 'release' it from being deleted by something else and now it is up to
    wxLua to delete it to avoid a memory leak.
-   You should verify that the generated code is appropriate as this has only
    been implemented for pointers '*'. It can be extened for other
    cases as they needed.
-   Note that by default, functions that return a pointer '*' or a reference
    '&' do NOT add the return value to the list of objects to be garbage
    collected even if it is a *class* data type with the *%delete* tag.
    This is because it is assumed that the return value is 'owned' by someone
    else that will delete it. Use the *%gc* tag to override this behavior.
-   See also *%ungc*.

***%gc_this***

-   Use for class member functions only.
-   Declares that after calling this function the object itself
    (not the return value) should be garbage collected by Lua.
-   This is for functions that when called will release the object from
    being deleted by something else and therefore it should be deleted
    in wxLua by either the garbage collector or when a Lua program calls
    the delete() function on it.
-   If a class has the *%delete* tag, this tag would only make sense if at
    least one function that has the *%ungc_this* tag.
-   You should verify that the generated code is appropriate as this has
    only been implemented for return pointers '*'. It can be extened
    for other cases as they needed.
-   See also *%ungc_this*.

***#if wxLUA_USE_XXX && %\_\_WXMSW\_\_ \
    Interface file data... \
#endif // wxLUA_USE_XXX***

-   The C++ generated code within this block will be surrounded by
    *"#if wxLUA_USE_XXX && \_\_WXMSW\_\_" ... #endif*.
-   You can use any #defined value in the #if statement as well as the
    operators !, &, |.

***#include "headerfile.h"***

-   Include a C/C++ header file by generating the C code
    *#include "headerfile.h"*.

***%includefile interfacefile.i - DEPRECATED and probably does not work***

-   Includes another wrapper file that is added to the list of files to process.

***member variables of classes : int m_x***

-   Declare a property to access member variables in a class.
-   The variables will be accessible only using the '.' convention as if
    they were table members.
-   If the variable is const, it is only read-only.

***%member_func int m_x***

-   Declare a function to access member variables in a class.
-   This tag must be used inside of the *class* tag.
-   The generated functions in the example above will be named
    Get_m_x() and Set_m_x(int x) therefore, you may want to use *%rename*
    in conjunction with *%member*.
-   For example, in wxPoint *"%rename X %member int x"* will generate
    wxPoint methods named "pt:GetX()" and "pt:SetX(5)" for the wxPoint
    class as well as properties to access them as if they were table
    members, print(pt:x) and "pt:x = 5".

***operators for classes : bool operator==(const wxPoint& otherPt) const***

-   Declare that the operator == is defined for the class which can be
    accessed in wxLua using *point:op_eq(otherPoint)*.
-   The functions that will be generated for the declared operators use
    the semantics given below.
-   The reason that the operators are not overridden in Lua using the
    metatable is that Lua only defines a limited set of operators.
    Having some operators overridden and some not is probably more
    confusing that not overriding any. Secondly, the Lua operators,
    the '=' and '==' operators (for example) are useful
    as userdata pointer assignment and pointer comparisons respectively.
    This is equivalent to using pointers in C, as in
    *"wxPoint *pt = &otherPt"*, which merely increases the ref count of the
    object and is useful as is.

-   This is a list of all possible operator functions:

    ------------------------------------------- -------------- ---------------------------
    **Relational and equality operators**
    ==                                          op_eq()
    !=                                          op_ne()
    \>                                          op_gt()
    <                                           op_lt()
    \>=                                         op_ge()
    <=                                          op_le()
    **Logical operators**
    !                                           op_not()
    &&                                          op_land()      "l" stands for logical
    ||                                          op_lor()
    **Bitwise operators**
    \~                                          op_comp()      bitwise NOT or complement
    &                                           op_and()
    |                                           op_or()
    \^                                          op_xor()
    \<\<                                        op_lshift()
    \>\>                                        op_rshift()
    **Inplace bitwise assignment operators**
    &=                                          op_iand()      "i" stands for inplace
    |=                                          op_ior()
    \^=                                         op_ixor()
    \>\>=                                       op_irshift()
    <<=                                         op_ilshift()
    **Arithmetic operators**
    =                                           op_set()
    +                                           op_add()
    \-                                          op_sub()
    \*                                          op_mul()
    /                                           op_div()
    %                                           op_mod()
    **Unary arithmetic operators**
    \-                                          op_neg()
    **Inplace arithmetic assignment operators**
    +=                                          op_iadd()
    -=                                          op_isub()
    \*=                                         op_imul()
    /=                                          op_idiv()
    %=                                          op_imod()
    **Increment arithmetic operators**
    ++                                          op_inc()
    \--                                         op_dec()
    **Other operators**
    []                                          op_index()     Array indexing
    ()                                          op_func()      Function call
    \*                                          op_deref()     Dereference/Indirection
    ------------------------------------------- -------------- ---------------------------

***%not_overload int FUNC_NAME(int value)***

-   Declare to the binding generator that even though the FUNC_NAME function
    has two or more different signatures to not generate code to overload it.
-   This can be used when a class has two functions with the same name
    that have mutually exclusive #ifdef conditions.
-   This can happen when, for example, a function is "void DoStuff()"
    and then in a later version of the C++ library "bool DoStuff(int flag)".

***%override wxLua_ClassName_FunctionName \
 // any code or comments can go within the %override ... %end block \
 static int LUACALL wxLua_ClassName_FunctionName(lua_State\* L) \
 {  \
 ...\
 }  \
 %end***

-   Replace the generated binding code with this handwritten code.
-   The lines of C++ code between %override and %end is copied verbatim
    into the binding code.
-   This is necessary for functions that take pointers or references and
    return values though them. Since Lua cannot have values passed by
    reference the only solution is to return multiple values.
-   See the function wxLua_wxConfigBase_GetNextGroup in
    *bindings/wxwidgets/overrides.hpp* for an example of this and many
    other examples of when %override is necessary.
-   The program genwxbind.lua uses the function signature,
    wxLua_ClassName_FunctionName for class member functions, to lookup
    whether there was a %override or not. Therefore, it is important that you
    get the signature correct. The simplest way to get started with your own
    %override is to add the function to your interface files and run
    *genwxbind.lua* on them. Then look at the C++ output for that function and
    copy it into your %override file and adjust as necessary.

***%override_name CFunctionNameTheOverrideUses***

-   The binding generator will automatically generate names for the
    functions it binds, which is by default wxLua_ClassName_FunctionName.
-   There are other special cases, please review the output of the
    generated bindings to determine what the default will be.
-   However, if the function is overloaded (two or more with same name)
    additional C functions created will have 1,2,3... appended to their name.
-   In order to enforce that the %override that you have written will be
    used for the proper function you can use this tag followed by the
    exact same name you gave the C function in your override.

***%rename NEW_FUNC_NAME void FUNC_NAME()***

-   Rename a C/C++ method to a new name which can be accessed in Lua as
    NEW_FUNC_NAME() though it's accessed in C using FUNC_NAME().
-   This can be necessary when there are two overloaded C functions that
    are hard or impossible to distinguish between the two and so it is
    necessary to rename them for the Lua script to access them correctly.
-   An example of when this is necessary is
    -   wxSize wxWindow::GetClientSize()
    -   void wxWindow::GetClientSize(int* width, int* height)
    -   Since Lua cannot pass the int *width and *height by reference,
        we change the function to have this signature.
        -   [int width, int height] = wxWindow::GetClientSize()
        -   However there is not anyway to distinguish between getting
            ints or a wxSize since we cannot check the left hand side,
            the return values.
        -   The only solution seems to be to %rename the int width,
            height function to GetClientSizeWH()

***%skip***

-   The next item is skipped, either a single line or a whole class.


***struct [%delete] StructName \
{ \
    member variables \
    ... \
};***

-   Declare a struct.
-   If the struct is in a namespace, such as `ns::StructName`, the struct must
    be declared as `struct [...] ns::StructName` and the constructor must also
    be declared as `ns::StructName(...)`.
    The generator will change the "::" to "_" for use in Lua.
-   ***%delete*** can be used for structs you want the Lua garbage collector
    to delete when the object goes out of scope.
-   See ***class*** for more information.
    The wxLua binding treats classes and structs nearly the same.


***typedef KNOWN_DATATYPE*** ***UNKNOWN_DATATYPE***

-   Declares to the binding that the *UNKNOWN_DATATYPE* should be
    treated as *KNOWN_DATATYPE*.
-   An example of this is *"typedef long wxTextCoord"* where the
    wxTextCoord is just a long integer.
-   Without the `typedef` the binding generator would give an error about
    an unknown data type, since it would assume that a typo or an error
    in the interface file had been made.

***%ungc***

-   For use before a userdata parameter of a function or its return value only.
-   Declares that the parameter passed to the function or return value should
    not be garbage collected or able to be delete()ed by the Lua program.
-   This is for functions that when passed a userdata object will take
    'ownership' of it and wxLua should not delete it to avoid double
    deletion. This can also be used for return values.
-   You should verify that the generated code is appropriate as this has
    only been implemented for pointers '*'. It can be extened for other
    cases as they needed, please send a message to the wxlua-users
    mailing list with your special circumstances.
-   See also *%gc*.

***%ungc_this***

-   For a class member functions only and may be necessary for classes
    that use the *%delete* tag.
-   Declares that after calling this function the object itself (not
    return value) will not be garbage collected by Lua.
-   See also *%gc_this*.

***%wxchkver_X_Y_Z***

-   The next item will be *#if wxCHECK_VERSION(X,Y,Z).*
-   The Y and Z parameters are optional and default to 0.
-   *%wxchkverXY is now deprecated, please use %wxchkver_X_Y_Z*

***%wxcompat_X_Y***

-   The next item will be
    *#if (defined(WXWIN_COMPATIBILITY_X_Y*) && *WXWIN_COMPATIBILITY_X_Y)*.
-   The rest of the string beyond "%wxcompat" is appended to
    "WXWIN_COMPATIBILITY" so hopefully all future versions of wxWidgets
    should be supported.
-   *%wxcompatXY is now deprecated, please use %wxcompat_X_Y*

 **Standard wxWidgets #defines for conditional use using the #if directive**

~~~
    %__WINDOWS__
    %__WIN16__
    %__WIN32__
    %__WIN95__
    %__WXBASE__
    %__WXCOCOA__
    %__WXWINCE__
    %__WXGTK__
    %__WXGTK12__
    %__WXGTK20__
    %__WXMOTIF__
    %__WXMOTIF20__
    %__WXMAC__
    %__WXMAC_CLASSIC__
    %__WXMAC_CARBON__
    %__WXMAC_OSX__
    %__WXMGL__
    %__WXMSW__
    %__WXOS2__
    %__WXOSX__
    %__WXPALMOS__
    %__WXPM__
    %__WXSTUBS__
    %__WXXT__
    %__WXX11__
    %__WXWINE__
    %__WXUNIVERSAL__
    %__X__
    %__WXWINCE__
~~~

***%wxEventType wxEVT_XXX***

-   Declares a wxEventType *wxEVT_XXX* which can be accessed in Lua
    using *wx.wxEVT_XXX*.
-   This tag must be used inside of the `class` tag for the wxEvent
    derived class it corresponds to so the event's methods can be known
    to Lua and the generator can assign the correct class type to it.
-   An example of this is the wxCommandEvent class's interface in
    *bindings/wxwidgets/event.i*, *"%wxEventType wxEVT_COMMAND_ENTER"*.
