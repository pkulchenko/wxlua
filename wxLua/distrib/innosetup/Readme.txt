
 Notes about wxlua.iss
 =====================

 To build the windows installer of wxLua you need:
 1) InnoSetup    and InnoSetup Preprocessor
    (http://www.jrsoftware.org/isinfo.php)
 2) UPX (http://upx.sourceforge.net)

 To actually build do:

 1) go in wxLua\build\msw and build with MSVC or BORLAND compiler
    the entire wxLua project using the USE_WXLUAEDIT=1 option
 2) run the 'compress' utility target to optimize the .exe
 3) run the 'docs' utility target to create doxygen docs
 4) copy the MSVCR71.dll and MSVCP71.dll files in the "bin" folder
    so to include them in the final .exe package
 5) open the wxLua\build\innosetup\wxlua.iss file
 6) eventually update version numbers
 7) click 'Compile' to create in wxLua\.. the installer.
