 wxLua ChangeLog
 ===============

 version 3.1.0.0 (released 9/12/2020)
 --------------------------------------------------------------------
 - INCOMPATIBILITY: Updated the order of parameters for `wxFileName.GetTimes` (closes #68).
 - Updated wxlua for Lua 5.4 compatibility.

 - Added wxWindow::DisableFocusFromKeyboard (from wxwidgets 3.1.4).
 - Added wxDataViewCtrl binding for wxHeaderColumn and wxSettableHeaderColumn classes (thanks to Konstantin Matveyev).
 - Added wxDataViewCtrl bindings for wxWidgets 3.1+ (thanks to Konstantin Matveyev).
 - Added GetSpacing/SetSpacing that were missing in wxTreeCtrl.
 - Added wxApp::OSXEnableAutomaticTabbing (from wxwidgets 3.1.4).
 - Added wxTranslations (thanks to Steve Murphree).
 - Added wxDATAVIEW_COL* constants.
 - Added wxWindow::GetDPIScaleFactor (thanks to Igor Ivanov).
 - Added wxItemContainer::Set (thanks to Igor Ivanov).
 - Added wxDataObjectComposite::GetObject (thanks to Igor Ivanov).
 - Fixed the order of methods to match wxwidgets interface files.
 - Fixed wxDisplay::GetFromWindow definition to match the one in wxwidgets interface files.
 - Fixed wxDataViewCtrl::wxDataObject (d'n'd) memory double free with %ungc (thanks to Konstantin Matveyev).
 - Fixed crash if lua interpreter exits after require"wx" and before MainLoop() is invoked (thanks to osch).
 - Noted current Lua version support, copy-edit (thanks to Caleb Maclennan)
 - Removed FindwxWidgets cmake script, as it fails on Linux (with cmake 3.5.1) (#67).
 - Updated versions for wxTranslations methods to track signature changes (closes #78).
 - Updated wxAui* components with wxwidgets 3.1.5 changes.
 - Updated reported call options (when wrong arguments are used) to use more Lua-ish syntax.
 - Updated wxDisplay::GetFromWindow to be available with wxWidgets versions prior to 2.8.
 - Updated wxDisplay and wxWindow to add methods for wxwidgets 3.1.5.
 - Updated to apply default LUA_COMPAT settings for Lua 5.4.
 - Updated to support lua 5.4 build as external library on Windows (thanks to QinghuaYang).
 - Updated wxDataViewEvent::GetDataBuffer to return stored data as wxString (thanks to Igor Ivanov).

 version 3.0.0.9 (released 8/20/2020)
 --------------------------------------------------------------------
 - Added POSIX names for permission flags (#68).
 - Added methods 'GetItemCount' and 'IsEmpty' to wxSizer
 - Add missing events related to wxHtml (#59).
 - Added `wxluasetup.h` to the list of installed files for embedded setup (closes #56).
 - Changed markdown documentation files to .md from .txt and updated references (closes #70).
 - Drop trailing whitespaces during processing (closes #55).
 - Handling of wxMemoryBuffer is improved to avoid unnecessary dependence (closes #63, #64)
 - Removed usage of LUA_QL, as it doesn't exist in Lua 5.4 (closes #69).
 - Updated bit32 inclusion to skip under Lua 5.4.
 - Updated integer handling to avoid gcc warning about misleading indentation.
 - Updated hash map signature to fix Visual Studio linking in multilib configuration (#67).
 - Updated FindwxWidgets.cmake script to fix building with wxwidgets 3.1.4 (fixes #67).
 - Updated `lua_rawget` check to make it compatible with Lua 5.2 (closes #54).
 - Updated wxGraphicsContext methods to accept Lua table as an array of wxPoint2DDoubles
 - Fixed `defined` check to use proper syntax (#67).
 - The argument type in overridden StrokeLines() is fixed (int ->size_t)
 - The missing argument fillStyle in DrawLines() is added back, and the argument type is fixed (int -> size_t)

 version 3.0.0.8 (released 12/30/2019)
 --------------------------------------------------------------------
 - Added `GetCurLineRaw` method for wxSTC.
 - Added event type aliases (wxEVT_XXXX for wxEVT_COMMAND_XXXX) are implemented
 - Added `wxGraphicsContext.GetPartialTextExtents` (#50).
 - Added `wxArrayDouble`.
 - Added override for `wxGraphicContext.GetTextExtent` to properly return its results (closes #50).
 - Updated `wxArrayInt` handling to better work with Lua 5.3+.

 version 3.0.0.7 (released 12/09/2019)
 --------------------------------------------------------------------
 - Added 'Mandelbrot set' example using wxImage and wxMemoryBuffer (#49).
 - Added `CallAter` method for `wxEvtHandler`.
 - Added `wxSystemAppearance`.
 - Added wxAuiNotebook methods made public in wxwidgets 3.1.4.
 - Added wxSTC methods that require wxMemoryBuffer support (#49).
 - Added wxMemoryBuffer.
 - Added `wxAffineMatrix2D` and `*TransformMatrix` methods for wxDC.
 - Added `wxGetSelectedChoices` method.
 - Added missing wxFileConfig methods (Get{Global,Local}File{Name}).
 - Added wxAuiManager `PANE_ACTIVATED` event.
 - Updated wxAuiTabCtrl methods TabHitTest and ButtonHitTest to return hit controls.
 - Updated wxMemoryBuffer processing to avoid compilation warnings on comparisons (#49).
 - Updated wxMemoryBuffer to make it usable as a 'string-type' argument.
 - Updated wxImage methods to allow wxString and wxMemoryBuffer as arguments for 'unsigned char*'
 - Updated handling of integer values to better work with Lua 5.3+.
 - Updated `bit` module loading to work with Lua 5.3+ compiled without `LUA_COMPAT_MODULE` (#43).
 - Updated file reference and version checks to fix compilation with wxwidgets <3.1.2 (fixes #46).
 - Updated components to return integer types as appropriate (with Lua 5.3).
 - Updated "bit" module to compile with Lua 5.3.

 version 3.0.0.6 (released 10/28/2019)
 --------------------------------------------------------------------
 - Added `GetAutoWindowMenu`, `SetAutoWindowMenu`, and other macOS-specific menu methods.
 - Added `GetPartialTextExtents` method for wx*DC objects.

 version 3.0.0.5 (released 10/02/2019)
 --------------------------------------------------------------------
 - Added `Replace*Raw` methods for wxSTC in wxwidgets 3.1.3.
 - Added GDI graphics classes (thanks to Konstantin Matveyev).
 - Added `wxGauge` flags (thanks to Konstantin Matveyev).
 - Added missing methods for `wxProgressDialog`.
 - Added `wxTextInputStream` and `wxTextOutputStream` (thanks to Konstantin Matveyev).
 - Added missing methods for `wxAuiPaneInfo`.
 - Added `wxSpinCtrlDouble` (thanks to Konstantin Matveyev).
 - Added `GetScale*` methods for `wxBitmap`.
 - Added `SetLabelMarkup` to `wxControl` (thanks to Konstantin Matveyev).
 - Added `wxLaunchDefaultApplication` (thanks to laptabrok).
 - Added `wxRealPoint`.
 - Added support for `OnEnter`, `OnLeave`, and `OnDragOver` for `wxLuaTextDropTarget`.
 - Updated `wxBitmap` constructor to add scaling support.
 - Fix build with LuaJIT 2.1.0+ (thanks to Konstantin Matveyev).
 
 version 3.0.0.4 (released 9/19/2019)
 --------------------------------------------------------------------
 - Added missing wxToolTip methods.
 - Added `SetScrollbars` and other missing wxScrolledWindow methods.
 - Added `GetUnicodeKey` and `GetRawKey*` methods for wxKeyEvent.
 - Updated wxXml* classes for wxwidgets 3.x.
 - Updated bindings with wxwidgets 3.1.3 changes from master branch.
 - Use Lua BitOp instead of bitlib for the "bit" module. (Thanks to Jeff Davidson)
 - Removed `XmlProperty`, as it's no longer present in wxwidgets 2.9+
 - Fixed cmake warnings (fixes #35).

 version 3.0.0.3 (released 7/24/2019)
 --------------------------------------------------------------------
 - Updated wxFontList binding to work with wxwidgets 3.0 (closes #39).
 - Updated wxIcon bindings to work with wxwidgets 2.9.5 (closes #38, #36).
 - Updated wxlua binding version in all binding files (fixes #37).
 - Updated to only close Lua state when it's not marked as static (#20).
 - Updated bindings to work with wxwidgets 2.9.5 (closes #36).
 - Fixed example to use the current (wxwidgets 3.x) API.

 version 3.0.0.2 (released 7/15/2019)
 --------------------------------------------------------------------
 - Added wxTreeListCtrl and treelist example.
 - Added wxTimePickerCtrl.
 - Added wxLuaProcess to handle OnTerminate event to skip object deletion.
 - Removed two wxSTC methods that were, but no longer present in wxwidgets 3.1.3.
 - Updated wxSTC for 3.1.3 to remove obsolete StyleBits-related methods.
 - Updated wxTimer bindings to add some of the missing methods.
 - Updated bindings for wxMenuBar and wxAccelerator* based on auto-generation results.
 - Updated bindings to simplify auto-generation.
 - Updated luamodule makefile to fix 'multiple definition of ...' error (#32).
 - Updated README to add supported Lua versions.

 version 3.0.0.1 (released 6/28/2019)
 --------------------------------------------------------------------
 - Upgraded wxlua for Lua 5.3 compatibility.
 - Updated bindings for wxwidgets 3.0, 3.1, 3.1.1, 3.1.2, and the current 3.1.3 version

 - Added `wxGLAttributes` and `wxGLContextAttrs` classes (closes #11).
 - Added `GetLibraryVersionInfo` to wxSTC.
 - Added `wxAuiGenericTabArt`.
 - Added wxString::FromUTF8Unchecked method.
 - Added wxRect getters/setters (#18).
 - Added `LeftDown`, `RightDown` and `MiddleDown` methods for compatibility with earlier versions of wxlua.
 - Added MacOpenFiles support.
 - Added wxBrushStyle and updated wxPenStyle descriptions for 3.1.1.
 - Added wxStatusBarPane and updated wxStatusBar bindings for wx3.1.1.
 - Added missing `SetStatusWidths` in wxFrame.
 - Added `wxHitTest` and `wxShowEffect`.
 - Added wxAnyButton and wxBitmapToggleButton.
 - Added `LoadLexerLibrary`, `GetLexerLanguage`, `GetDirectPointer`, and `GetDirectFunction` methods for wxSTC.
 - Added `SetSelection` as it's an existing method, but not part of wxSTC interface.

 - Updated wxSTC for 3.1.3.
 - Updated wxAui for 3.1.2.
 - Updated wxHTML for 3.1.2.
 - Updated wxwidgets bindings for v3.1.2.
 - Updated menutool binding to remove deprecated `3DBUTTONS` style (#4).
 - Updated wxSTC bindings for Scintilla 3.7.2 (closes #4).
 - Updated wxSTC binding processing script to ignore parameter names when matching sinatures (#4).
 - Updated samples for 3.x API changes.
 - Updated wxSTC methods `AddTextRaw` and `AppendTextRaw` to accept length.
 - Updated wxFileName::GetVolumeString binding as it's windows-only.
 - Updated wxFileName bindings for wxwidgets 3.1.1.
 - Updated wxMouseState and added wxKeyboardState bindings for wxwidgets 3.1.1.
 - Updated wxProcess bindings for wxwidgets 3.1.1.
 - Updated wxStandardPaths bindings for wxwidgets 3.1.1.
 - Updated wxIcon bindings to remove one of the constructors that causes compilation issues on Linux.
 - Updated wxSTC bindings to include `GetTargetTextRaw` added in wxwidgets 3.1.1.
 - Updated wxBitmap binding to mark `cursor` constructor as win-only.
 - Updated wxImage bindings for wxwidgets 3.1.1.
 - Updated wxcore_image formatting to simplify automated processing.
 - Updated wxBitmap bindings for wxwidgets 3.1.1.
 - Updated wxAui* bindings for wxwidgets 3.1.1.
 - Updated AuiDemo sample to use proper method (`GetColour` instead of `GetColor`).
 - Updated wxColour bindings for 3.1.1.
 - Updated wxFont binding for wxwidgets 3.1.1.
 - Updated wxApp, wxEvent, and wxEvtHandler for wxwidgets 3.1.1; added wxAppConsole, wxEventLoopBase, and wxEventFilter classes.
 - Updated wxcore_appframe to add missing wxAppConsole inheritance.
 - Updated SetDoubleBuffered conditions as it is not present on OSX.
 - Updated SetBitmap signature to use one parameter, as OSX/Linux don't support two-parameter version.
 - Updated wxTopLevelWindow and wxFrame bindings; add wxNonOwnedWindow bindings for wxwidgets 3.1.1.
 - Updated wxWindow bindings for wxwidgets 3.1.1.
 - Updated `wxMenu` to include more constructors.
 - Updated wxButton, wxBitmapButton, and wxTogglebutton for wxwidgets 3.1.1.
 - Updated wxTextCtrl binding to explicitly use wxTextEntry.
 - Updated wxTextCtrl bindings for wxwidgets 3.1.1.
 - Updated wxTreeCtrl bindings for wxwidgets 3.1.1.
 - Updated wxDir bindings for wxwidgets 3.1.1.
 - Updated wxMenuItem bindings for wxwidgets 3.1.1.
 - Updated signatures and removed duplicates in wxMenuItem bindings.
 - Updated wxMenu bindings for wxwidgets 3.1.1.
 - Updated wxMenu binding to match the current method signatures.
 - Updated binding for `PrivateLexerCall` to handle string parameters.
 - Updated wxSTC constants and methods for wxwidgets 3.1.1.
 - Updated wxSTC event binding.
 - Updated wxSTC constants and methods for wxwidgets 3.1.0.

 - Updated vtable offset type to avoid casting to `int` (#32).
 - Replaced `long int` conversion for better portability (closes #32).
 - Removed macOS workaround that conflicted with `stdlib` settings for c++11 and later compilers.
 - Updated bindings to mark changes deprecated since wxwidgets 3.0.
 - Updated bindings to mark changes deprecated since wxwidgets 2.8.
 - Removed re-assigning Lua state when callbacks are created from coroutines.
 - Definition of LUAI_INT32 is added for LuaJIT 2.0.5
 - Updated bindings to work with wxwidgets 3.0 (#18).
 - Updated bindings to only enable `AddPrivateFont` when `wxUSE_PRIVATE_FONTS` is set.
 - Remove webview because it is dependent on webkit on Linux (closes #10).
 - Fix mingw compilation on Windows (closes #23).
 - Removed error message on an unknown method, as it's not needed and is causing memory leak.
 - Removed mingw workaround that is causing compilation errors under mingw.
 - Added matching to determine the wxWidgets details on MinGW builds (#15)
 - wxbind generated with pairs_sort in genwxbind.lua
 - use pairs_sort in genwxbind.lua for reproducable generates
 - declare wxLuaState::lua_SetHook to return void
 - build with lua5.3 without the need for LUA_COMPAT_MODULE (which is not defined in default 5.3 Makefile)
 - updated CMakeLists.txt for lua 5.3
 - Update the .desktop categories
 - Avoid the deprecated .xpm file format extension
 - Added scripts to update bindings based on wxwidgets interface files.
 - Added a check for the Lua state to be valid during closing.
 - Uncommented a check to help with crashes in delete processing on ArchLinux.
 - Updated clearing flag in MacOpenFiles to only call it on a valid wxLuaState.
 - Added a workaround to enable -std=c++11 compilation option.
 - Updated comment in the declaration for better automated matching.
 - Updated wxaui_aui formatting to simplify automated processing.
 - Fixed declarations for pure virtual functions and abstract classes.
 - Updated wxPen, wxBrush, wxIcon, wxMask, wxCursor, wxCaret, wxPalette, and wxDisplay bindings for 3.1.1.
 - Fixed DoDragLeave version as it's only present in 3.1+.
 - Fixed `MainLoop` override in wxAppConsole and in wxApp in previous versions.
 - Added version 3.1.1 to known datatypes.
 - Commented out Accelerator methods for wxMenuItem as those generate compilation error.
 - Added menu methods supported only on Windows.
 - Fixed COFFEESCRIPT lexer that should be included in 3.1.

 version 3.0.0 (unreleased)
 --------------------------------------------------------------------
 - Add wxWebView class for wx2.9+
 - Update to Lua 5.2.3
 - Add wxLuaURLDropTarget and wxLuaListCtrl.

 version 2.8.12.3 (released 9/12/2013)
 --------------------------------------------------------------------
 - wxLua now builds with Lua 5.1 and 5.2
 - Update wxStyledTextCtrl with new functions in 2.9
 - Implement wxDC::DrawLines(), DrawPolygon().
 - Handle drag and drop for files and text.
 * Remove Bakefile build files since the next-gen Bakefile version is
   incompatible with the current Bakefiles anyway.
   http://permalink.gmane.org/gmane.comp.sysutils.bakefile.devel/1502
 * Change the dir structure by removing the include/ and src/ dirs
   to flatten, simplify, and make it possible to "install" into a
   normal include directory structure.
 - Rename the wxLuaSocket lib to wxLuaDebugger lib since that's what it is.
 - Move wxLuaObject and "smart" helper classes into wxlobject.h/cpp
 - Add lbitlib.c and create the "bit32" table to help the transition
   to Lua 5.2. (Using backport version by Sean Bolton)
 - Start to use Markdown for documentation to make maintenance easier.
 * CONVERT *.i BINDINGS TO BE VALID(ish) C++ CODE!
   If you have written your own, you will have to make these changes.
   - Find/Replace "%if"              -> "#if"
   - Find/Replace "%endif"           -> "#endif"
   - Find/Replace "%include"         -> "#include"
   - Find/Replace "%define"          -> "#define"      (still only for numbers)
   - Find/Replace "%define_string"   -> "#define_string"
   - Find/Replace "%define_wxstring" -> "#define_wxstring"
   - Find/Replace "%define_object"   -> "#define_object"
   - Find/Replace "%define_pointer"  -> "#define_pointer"
   - Find/Replace "%define_event"    -> "%wxEventType" (not always #defines,
                                                        special to wx)
   - Find/Replace "%public"          -> "public"    (not currently used)
   - Find/Replace "%protected"       -> "protected" (not currently used)
   - Find/Replace "%private"         -> "private"   (not currently used)
   - Find/Replace "%typedef"         -> "typedef"
   - Change %class ClassName ... %endclass  to
        class ClassName [: public BaseClassName [, public BaseClassName2]]
        {
        ... // Note that {} braces must be on separate lines.
        };
   - Change %struct StructName ... %endstruct as per class change.
   - Change %enum [EnumName] ... %endenum to
        enum EnumName
        {
          A,  // commas are now required as in C
          ... // Note that {} braces must be on separate lines.
        };
   - Remove the keyword %function before all global 'C' style functions.
   - Remove the keyword %operator before all class member operator functions.
   - Remove the keyword %constructor before all class constructor functions.
   - Remove the keyword %member before all class member variables.

 version 2.8.12.2 (released 7/26/2012)
 --------------------------------------------------------------------
 - Allow setting event handlers in coroutines. Note that the callback will
   always be run in the main Lua thread.
   The only legitimate use of this is for a debugger.
 - Add wxPopupWindow bindings thanks to Qito Nomnom.

 version 2.8.12.1 (released 6/30/2012)
 --------------------------------------------------------------------
 - Renamed the Lua library.
 - Added CMake builds for using a static or shared Lua lib.
 - Use a dll proxy so all the MS Windows exe's double as Lua DLLs
   so that require() works for 3rd party precompiled libs.
 - Add MSW file property info using .rc files.
 - Fix "missing comctl32.dll error 126" problem with wx.dll.
   Thanks to Andre Arpin.

 version 2.8.12.0 (released 6/28/2012)
 --------------------------------------------------------------------
 - Use CMake to build since it is more flexible.
 - Add wxDateTime functions to make them more useable.
 - Fix wxGrid problems with reference counted render classes.
 - Update to Lua 5.1.5
 - Added more wxTreeCtrl functions, allow wxLuaTreeItemData to take
   any Lua data in its SetData/GetData() methods.
 - Fixed crash in error handler for wxLua functions.
 - Fixed multiple inheritance by adding the offset to the vtable
   of second or higher base classes. It has been tested in GCC and
   MSVC. See note in wxlstate.cpp above wxluaT_getuserdatatype().
 * Removed %encapsulate from the %class declarations in the bindings.
   Instead of wrapping non wxObject classes in a wxObject for deletion
   we now call a newly added delete function added to the wxLuaBindClass
   structs that properly cast the void* to the actual class type.
   The upshot is that wxLua is about 5% faster when creating thousands of
   wxPoints and just slightly smaller, 50Kb.
   Please remove this tag from your bindings.
 * Removed %noclassinfo from the %class declarations in the bindings.
   It is no longer used or needed since we can verify if a class is derived
   from a wxObject by inheritance.
   Please remove this tag from your bindings.

 version 2.8.10.0  (released 05/25/2009)
 --------------------------------------------------------------------

 - Updated Lua to 5.1.4

 * Changed the %typedef binding to work as the C/C++ typedefs work.
   The usage is reversed from how it was in previous versions.
   You will need to swap the parameters for it in your bindings.
   Example: %typedef long wxTextCoord
 - Added more C/C++ operators in the bindings.
 - wxLuaEdit now prints values in the console like the Lua executable.
 * Changed signature of wxLuaState::RunBuffer() to take a const char*
   instead of an const unsigned char*, cast to (const char*) as appropriate.
 - Allow wxLuaState::RunString/Buffer() and friends to allow for values left
   on the stack. The default is to leave none as before.
 - Added wxTextUrlEvent to the bindings.
 - Fixed double -> unsigned integer using all 32 bits conversion.
   Fixes wxSTC_MASK_FOLDERS problem, thanks to Andre Arpin.
 - Allow multiple inheritance in the bindings. Changed members of
   wxLuaBindClass to reflect that base class info are stored in arrays.

 version 2.8.7.0  (released 02/02/2008)
 --------------------------------------------------------------------

 - Streamlined wxLuaBinding::RegisterBinding(...) and remove the bool
   "registerClasses" since it didn't do anything useful anyway.
   If there needs to be a way to reregister the wxLua functions it should
   to be implemented from the ground up.
 - Renamed the functions wxlua_txxx to wxluaT_xxx to make it easier to
   search for their usage. The functions in the wxLuaState used to be
   called just "txxx" and are now called wxluaT_Xxx where the first
   letter of each word is capitalized for searching.
 - Made wxluaT_insert(L, idx) not pop the value that it refs since
   it may not be the one at the top of the stack.
 - Made wxLuaCheckStack class work a little nicer for easier debugging in C++.
 - Use wxSIGKILL to kill debuggee process since wxSIGTERM doesn't work in MSW.
 - wxLuaStackDialog has better search for all columns, collapse and expand
   tables, and show metatables. It also now uses a virtual wxListCtrl so
   it's much faster. You can expand both key and values of a table and
   more information is provided about items wxLua knows about.
 - Separated the "tags" for C++ classes from "refs" for objects we want a
   handle on in the Lua registry by putting them in separate tables.
 - Removed wxlua_pushkey_XXX #defines since we now have a few tables in the
   registry that we use and those methods were not useful anymore.
   The lightuserdata keys are now const char* strings with a descriptive name,
   however it is the mem address that is used as the table key.
 - wxluaT_newtag() now leaves the created table on the stack.
 - Removed wxluaT_newweaktag() and wxluaT_settagmethod() since they were
   not needed anymore.

 * A large portion of the internal workings of the wxLuaState have been
   rewritten. All of the data that was stored in wxLuaStateData that might
   be needed by a function taking a lua_State* is now in the
   LUA_REGISTRYINDEX. C functions have been added to access these values.
   The generated bindings no longer need to have "wxLuaState wxlState(L);"
   since everything can be done with the C functions.
   The result is that wxLua should be faster.

 - Applied patches to Lua 5.1.2 #8-11
     lua_setfenv may crash if called over an invalid object.
 - Made the garbage collector more aggressive since we push void* pointers
   but the data behind them may be quite large. Unfortunately there is no
   mechanism to give a size hint to Lua without modifying Lua.
   lua_gc(L, LUA_GCSETPAUSE, 120); lua_gc(L, LUA_GCSETSTEPMUL, 400);
 - Added wxLuaArtProvider with virtual functions to create custom
   wxArtProviders in Lua.

 * Allowed using wxObject:DynamicCast() on an object and be able to use the
   object as both types. The problem was that wxEvent:GetEventObject()
   returned a wxObject which overwrote the wxWindow (perhaps) that you had as
   a userdata in Lua already.
   Additionally, if you delete an object all of the userdata that wrap it
   have their metatables cleared for safety.

   Functions renamed since they don't do the same thing or behave the same.
   wxluaO_istrackedobject -> wxluaO_isgcobject
   wxluaO_addtrackedobject -> wxluaO_addgcobject
   wxluaO_removetrackedobject -> wxluaO_deletegcobject

 - Created a central luauserdata:delete() function for the bindings to reduce
   code. wxLua_userdata_delete(L)
 * Changed signature of the function wxLuaState::SetLuaDebugHook() so that
   the inputs to lua_sethook() are together and in the same order.
 - Renamed wxLuaCallback to wxLuaEventCallback to make it more clear that
   it is a callback for the wxEvents using wxEvtHandlers.

 - Removed wxluabind_removetableforcall(L) used in the bindings to determine
   if the function was called from the tables used for class constructors.
   It makes more sense to call an intermediatary function to remove
   the table before calling the real function.
 - Removed the wxLuaFunction class since we no longer need it. It was a
   userdata with a __call metatable to call the real function we want.
   We now push the actual function or an overload function helper with the
   wxLuaBindMethod struct as an upvalue to give better error messages.
   The new way should be faster since it doesn't generate as much garbage.
 - Added wxlua_argerror(L, stack_idx, type_str) to give a far more
   informative message from the bindings when the wrong type is an arg to
   a function.
 - Renamed WXLUAARG_XXX to WXLUA_TXXX to match LUA_TXXX.

 * Do not create a separate overload function in the bindings since we can
   just as easily check for multiple functions using the wxLuaBindMethod
   and call the generic overload function or just the single function.

 * Updated the naming conventions of the wxLua C/C++ functions to get rid of
   the term "tag" which dates back to Lua 4. Lua 5 does not use "tags", but
   rather metatables to attach functions to userdata in Lua.
   The new term for the C++ objects that wxLua wraps in Lua userdata and
   assigns a metatable to are wxLua types.
   WXLUA_TXXX types < WXLUA_T_MAX correspond to the LUA_TXXX Lua types.
   wxLua types > WXLUA_T_MAX are types from the bindings and denote a class or struct.
 - Most notably for people who have written their own overrides for their
   bindings will be that wxLuaState::PushUserTag() is now wxluaT_PushUserDataType().
   Those two functions existed before, but basically did the same thing.
   The calling arguments of PushUserTag() were taken however and were the
   reverse of what PushUserDataType() had.
 - wxluaT_new/get/set/tag() are now wxluaT_new/setmetatable() and
   wxluaT_type() where the latter works just like lua_type(), but returns
   one of the wxLua types.

 - Fix crash in wxListCtrl and wxTreeCtrl::AssignImageList() to use the
   %ungc tag to release wxLua from deleting the input wxImageList.
 - Added image sample translated from C++ by Hakki Dogusan.

 * Changed wxLuaState_Type enum for wxLuaState(lua_State*, wxLuaState_Type)
   Removed wxLUASTATE_USESTATE and you now | together wxLUASTATE_SETSTATE with
   wxLUASTATE_OPENBINDINGS if you want the bindings opened.
   Cleans up the creation of the wxLuaState so a precreated lua_State
   should be able to be used easier.
 - Remove poorly named wxLuaState::LuaError() and CheckRunError() and
   replaced them with the C functions wxlua_errorinfo() and wxlua_LUA_ERR_msg()
   respectively.
 - Added wxlua_pushargs(wxChar**, int) for a standard way to push args
   into Lua.
 - Copy Lua's print() function to print_lua() instead of simply
   overwriting it in case someone really wants to use it.

 - Revised the build system, specially the configure script under Linux which
   now accepts more options and automatically detects the presence/absence of
   each wxWidgets library when --enable-wxbind* options are left in "auto" mode

 * Updated Lua to 5.1.3

 - Added static bool wxLuaState::sm_wxAppMainLoop_will_run so that Lua code
   that calls "wx.wxGetApp:MainLoop()" will not do anything. C++ coders
   should call it if they create a wxLuaState and run Lua code from
   their wxApp:OnInit() when wxApp:IsMainLoopRunning() returns false.
   See the apps for usage.

 * The wxLua type numbers are now generated when the first wxLuaState is created
   rather then when the bindings are registered into Lua. This means that
   each wxLua type stays the same for the life of the program no matter what
   bindings are installed or in what order.
 - The copy of the wxLuaBindingList in the wxLuaState was removed since it is
   no longer needed. Renamed the functions static wxLuaBinding::GetBindXXX()
   to FindBindXXX() since they no longer needed the extra wxLuaBindingList parameter
   and they had the same signature as the existing GetBindXXX() functions.
   Removed the wxLuaBinding::Clone() function as it is no longer used.
 - Added wxLuaState::RegisterBinding(wxLuaBinding*) function to register
   single bindings at a time. You may also reregister bindings, which means
   that their metatable functions are simple rewritten.

 - Removed the wxLuaBinding::PreRegister() and PostRegister() functions and
   made RegisterBinding() virtual
   Note: wxLuaBinding::RegisterBinding() now leaves the Lua table that the
   binding objects were installed into on the stack. You must pop it.
 * The rules.lua for genwxbind.lua now uses wxLuaBinding_class_declaration and
   wxLuaBinding_class_implementation to replace wxLuaBinding_preregister and
   wxLuaBinding_postregister. You may now add whatever you like to the class
   declaration and implementation source code.

 - Updated bitlib to version 25.

 version 2.8.4.2
 --------------------------------------------------------------------

 - Separated the wxWidgets bindings into the libraries that wxWidgets
   uses. wxadv, wxaui, wxbase, wxcore, etc...

 - Allow bool = 1/0 and 1/0 = bool in wxlua_getboolean/integer/number.
 - Fix bug in prematurely garbage collecting userdata.
   The userdata was previously keyed on the pointer to the data instead
   of a pointer to the Lua userdata that wraps the data.
 - Moved wxLUA_VERSION... bindings into the 'wxlua' table.
 - Applied patch to lparser.c
   "Too many variables in an assignment may cause a C stack overflow"
 - Streamline creation of a wxLuaState and finding the wxLuaState from
   an existing lua_State,
   See wxlstate.h for changes to the enum WXLUASTATE_ATTACH/SETSTATE
   to be more complete.

 version 2.8.4.1
 --------------------------------------------------------------------

 - Made wxLUA_USE_wxMediaCtrl and wxLUA_USE_wxGLCanvas 1 by default.
   They are #if wxUSE_MEDIACTRL and wxUSE_GLCANVAS so they are only included
   if the wxWidgets you compile against uses them.
 - Added media.wx.lua sample to show off the wxMediaCtrl
 - Fixed the argtags for integer arrays.

 version 2.8.4.0
 --------------------------------------------------------------------

 - Added RUNTIME_LIBS and THREADING options to the build system to allow
   to statically compile against the C runtime (only for some win compilers)
 - Added all of the wxWidget's wxUSE_XXX conditions to the bindings
 - Hopefully fixed the wx2lua and lua2wx string conversion for unicode
   and high ascii characters.
 - Removed gc destructor functions, we can do it in the gc function itself.
 - Removed wxLua_AddTrackedObject functions, use wxLuaState::AddTrackedObject.
 - Updated lua to 5.1.2
 - Removed wxEVT_LUA_CONSOLE compatibility #define, use wxEVT_LUA_PRINT now
 - Refactored and cleaned up socket debugging code.
   Removed exception code.
   Removed DebuggerService code as it wasn't used.
 - Put derived functions into the LUA_REGISTRYINDEX instead of the
   wxLuaState's m_pDerivedList.
 - Change the wxLuaStackDialog to use a wxListCtrl instead of a hacked
   wxTreeCtrl that tries to act like a listctrl. Cleaner, faster, and smaller.

 - **** Big changes to the wxLua syntax! ****
   Hopefully this will be the last since it is now a little more flexible and
   logical with far fewer gotcha's since it matches the C++ documentation
   very closely now.
 - Removed wx.wxNull, the NULL tag for NULL pointers. Use wx.NULL now.
 - *** Removed MOST %renamed functions so that they are not overloaded.
   For example wxSizer::AddWindow/AddSizer is now just wxSizer::Add!
   Removed most renamed constructors like wxEmptyBitmap, wxBitmapFromFile
     and you now need only call wxBitmap(...). wxLua will determine which
     appropriate function to call at runtime.
 - Changed class member enums to be accessed by
   wx.ClassName.enumName instead of previously wx.ClassName_enumName.
 - Changed static class member functions to be accessed by
   wx.ClassName.StaticFuncName instead of previously wx.ClassName_StaticFuncName
 - Changed the class constructor functions to be a lua table instead of a C
   function. You can call the table using the __call metable, there is no
   code change required for wxLua scripts. You can get a pointer to the C
   function using the "new" table item of the class table if you actually want
   to get at the function.
 - Binding changes:
   Replaced %define %string with %define_string.
   Replaced %define %pointer with %define_pointer.
   Replaced %define %object with %define_object.
   Replaced %define %event with %define_event.
   Note: %define alone is still just for numbers.
   Removed %overload tag since this is done automatically.
   Added %override_name tag to enforce the name of the C function to use since
     the binding generator will append 1,2,3,... to overloaded functions.
   Removed %static and %static_only since these are automatically handled
     and static functions are put into the class table.
   Removed %property tag since these are generated on the fly.
   Depricated %constructor tag, use %rename NewConstructor ClassName(...)
     It is currently kept for very special cases, none of which exist now.
 - Changed version strings and numbers to match how wxWidgets defines them.
   WXLUA_MAJOR_VERSION -> wxLUA_MAJOR_VERSION
   WXLUA_MINOR_VERSION -> wxLUA_MINOR_VERSION
   WXLUA_RELEASE_VERSION -> wxLUA_RELEASE_NUMBER
   WXLUA_SUBRELEASE_VERSION -> wxLUA_SUBRELEASE_NUMBER
   WXLUA_VERSION_STRING -> wxLUA_VERSION_STRING
   WXCHECK_WXLUA_VERSION -> wxLUA_CHECK_VERSION
   Added wxLUA_CHECK_VERSION_FULL
 - Renamed wxConfigBase::Destroy() to Delete() to match the %delete generated
   functions.

 - Renamed WXLUACLASS, WXLUAMETHOD, WXLUADEFINE, WXLUASTRING, WXLUAEVENT
   structs to wxLuaBindClass, wxLuaBindMethod, wxLuaBindDefine,
   wxLuaBindString, and wxLuaBindEvent.
 - Renamed the GetLua[Class]List functions in wxLuaBindings to
   Get[Class]Array, since they're C arrays not wxLists.
 - Renamed wxLuaState::LuaCall to LuaPCall since that's what it calls
   and changed the parameters to match lua_pcall.

 - Removed binding helpers wxArrayString_FromLuaTable and
   wxArrayInt_FromLuaTable since the conversion is now automatic and the
   function can take either a table or a wxArrayXXX. See notes in binding.html.
 - Fixed sorting function for the listctrl.
 - Added validator.wx.lua to test wxGenericValidators and wxTextValidators,
   both of which work again.
 - Rename all functions dealing with "enumeration" to "integer" since it's
   more generic and that's what it's often used for.

 - Event handling is faster now that we store the wxLuaBindEvent struct
   instead of the wxEventType and then have to look up the struct each time.

 - Changed calling base class function from base_[FunctionName] to just
   _[Function Name]. This is faster and more reliable since if a function
   was called "base_XXX" before there would have been a problem.

 - Changed the Delete() function from the %delete tag for classes to just
   delete() to avoid any future name clashes since delete() is never allowed
   to be a function name in C++.

 - Moved the wxStyledTextCtrl class and its 1268 defines into the wxstc table.
 - Moved wxLuaObject, wxLuaDebugger (and friends) into the wxlua table and
   added more functions for inspecting userdata and the bindings.
 - Added the bit library from Reuben Thomas and put it into the bit table.
 - Fix mismatches between the bindings base classes and what they really are.

 - Add back the treectrl to the Stack Dialog so you get a tree on the left
   and the list on the right.
 - Added functions to get the items that wxLua tracks (userdata) to know
   if you need to garbage collect things
 - Use qsort and bsearch to find the class member functions to run.
   Combined with using integer items in lua's registry ~ %25 faster.
 - Make wxLuaDebugData a real wxObject refed class that can !Ok(), before
   it always created its ref data even if it wasn't used.

 - Add %gc, %ungc, %gc_this, and %ungc_this tags for fine tuning of tracking
   and releasing userdata objects by functions that take ownership of the data
   or release it.

 - Apply patches 1-6 for Lua 5.1.2

 version 2.8.0.0 (released 24/12/2006)
 --------------------------------------------------------------------

 - Fixed wxSocketBase::ReadMsg for reading less bytes, Steve Kieu
 - Fixed unicode conversion in wx2lua and lua2wx, thanks Steve Kieu
 - Switched from lua 5.0 to lua 5.1, updated to 5.1.1 (6/11/06)
 - All bindings for wxWidgets have been updated to 2.6.3
 - Reordered bindings/wxwidgets/overrides.hpp to follow binding *.i files
 - Fixed %member tag for bindings to work properly
 - Added %overload for the bindings to handle overloaded function calls
 - Added %operator tag for the bindings to handle C++ operators
 - Fixed printing and in general overridden functions that call base_XXX funcs
 - Added wxLuaFreeze program to create wxLua executables
 - Changed wxLuaBindings::OnRegister to Pre/PostRegister
     update your rules files for generating your bindings
 - Changed naming conventions of generated C binding functions by
     prepending "wxLua_" to them. This affects the %overrides so that you have
     to also prepend "wxLua_" as %override wxLua_SomeFunction and also add
     "wxLua_" to the name of the overridden C function.
 - static classmember functions now work and have the naming convention of
     classname_functionname. eg. wxButton_GetDefaultSize()
 - Added wxGLCanvas and wxGLContext to the bindings, see wxLUA_USE_wxGLCanvas
 - user-set C*FLAGS are now considered when building
   (previously they were ignored)
 - now the lua executable is called wxlua-lua to avoid conflicts
   with other installations of lua and a verbatim lua5.1 library and
   executable is created instead
 - updated wrapper generators and all build system for shared builds
   (under Windows)
 - added the new module "luamodule" which can be used to create a wx.dll/.so
   module to use with the require() function of lua with the verbatim interpreter
 - *** Changed wxEvtHandler::ConnectEvent to wxEvtHandler::Connect since there
   is NO C++ function called ConnectEvent.
 - Fixed wxEvtHandler::Connect[Event] to follow the C++ winID semantics for the
   case where there is no winId supplied, use wxID_ANY.
 - Finished cleaning up the code, moved all the code in
   modules/wxlua/include/internal.h and modules/wxlua/src/internal.cpp
   to other files. Please include wxlua/wxlstate.h instead of this file.
 - Cleanup debugging socket code
 - Add wxVERSION and wxCHECK_VERSION as well as WXLUA_XXX_VERSION bindings
 - Removed wxLuaHandler (in wxluasocket) and made wxLuaDebuggerBase a
   wxEvtHandler derived class to handle debugger events.
 - Renamed all the wxluasocket enums, wx events, and classnames to directly
   specify what they are used for, eg. debugger and debuggee.
 - Cleaned up and made more robust the wxlua IDE app.
 - Moved distribution-stuff into "distrib" to make it clear what is build-related
   and what is for making wxLua distributions
 - Added PCH support
 - Builds with different configurations are fully supported: both the build
   directory and the output folders for the libraries and for the binaries are
   named with the chosen configuration so that there should be no clashes
   when compiling wxLua with different settings.
 - Added the --with-lua-prefix configure's option or LUA_DIR option to allow
   to use an external LUA library for building wxLua.
 - Building under wxMac has been greatly improved thanks to Anders F Björklund;
   release 2.8.0.0 also includes a Mac bundle.


 version 2.6.2.0 (released 10/03/2006)
 --------------------------------------------------------------------

 - imported wxLua in SourceForge CVS servers
 - added bakefile build system
 - added InnoSetup and Autopackage scripts for packaging
 - created wxLua website
 - updated samples to use sizers


 versions < 2.6.2.0
 --------------------------------------------------------------------

 - the pre-SF releases were kept at http://www.luascript.thersgb.net
   which is now unavailable
