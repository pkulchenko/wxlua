// ===========================================================================
// Purpose:     Various wxBase classes
// Author:      Ray Gilbert, John Labenski
// Created:     July 2004
// Copyright:   (c) Ray Gilbert
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

// ---------------------------------------------------------------------------
// wxWidgets version defines

%define wxMAJOR_VERSION
%define wxMINOR_VERSION
%define wxRELEASE_NUMBER
%define wxSUBRELEASE_NUMBER
%define_string wxVERSION_STRING

%function bool wxCHECK_VERSION(int major, int minor, int release) // actually a define
%function bool wxCHECK_VERSION_FULL(int major, int minor, int release, int subrel) // actually a define

%define wxABI_VERSION

// ---------------------------------------------------------------------------
// wxWidgets platform defines

%__WINDOWS__       %define __WINDOWS__       1
%__WIN16__         %define __WIN16__         1
%__WIN32__         %define __WIN32__         1
%__WIN95__         %define __WIN95__         1
%__WXBASE__        %define __WXBASE__        1
%__WXCOCOA__       %define __WXCOCOA__       1
%__WXWINCE__       %define __WXWINCE__       1
%__WXGTK__         %define __WXGTK__         1
%__WXGTK12__       %define __WXGTK12__       1
%__WXGTK20__       %define __WXGTK20__       1
%__WXMOTIF__       %define __WXMOTIF__       1
%__WXMOTIF20__     %define __WXMOTIF20__     1
%__WXMAC__         %define __WXMAC__         1
%__WXMAC_CLASSIC__ %define __WXMAC_CLASSIC__ 1
%__WXMAC_CARBON__  %define __WXMAC_CARBON__  1
%__WXMAC_OSX__     %define __WXMAC_OSX__     1
%__WXMGL__         %define __WXMGL__         1
%__WXMSW__         %define __WXMSW__         1
%__WXOS2__         %define __WXOS2__         1
%__WXOSX__         %define __WXOSX__         1
%__WXPALMOS__      %define __WXPALMOS__      1
%__WXPM__          %define __WXPM__          1
%__WXSTUBS__       %define __WXSTUBS__       1
%__WXXT__          %define __WXXT__          1
%__WXX11__         %define __WXX11__         1
%__WXWINE__        %define __WXWINE__        1
%__WXUNIVERSAL__   %define __WXUNIVERSAL__   1
%__X__             %define __X__             1

// ---------------------------------------------------------------------------

%if wxUSE_ON_FATAL_EXCEPTION
    %function bool wxHandleFatalExceptions(bool doIt = true)
%endif // wxUSE_ON_FATAL_EXCEPTION

// ---------------------------------------------------------------------------
// Network, user, and OS functions

%if !%wxchkver_2_8
%enum
    wxUNKNOWN_PLATFORM
    wxCURSES
    wxXVIEW_X
    wxMOTIF_X
    wxCOSE_X
    wxNEXTSTEP
    wxMAC
    wxMAC_DARWIN
    wxBEOS
    wxGTK
    wxGTK_WIN32
    wxGTK_OS2
    wxGTK_BEOS
    wxGEOS
    wxOS2_PM
    wxWINDOWS
    wxMICROWINDOWS
    wxPENWINDOWS
    wxWINDOWS_NT
    wxWIN32S
    wxWIN95
    wxWIN386
    wxWINDOWS_CE
    wxWINDOWS_POCKETPC
    wxWINDOWS_SMARTPHONE
    wxMGL_UNIX
    wxMGL_X
    wxMGL_WIN32
    wxMGL_OS2
    wxMGL_DOS
    wxWINDOWS_OS2
    wxUNIX
    wxX11
    wxPALMOS
    wxDOS
%endenum
%endif // !%wxchkver_2_8

%function wxString wxGetEmailAddress()
%function wxLongLong wxGetFreeMemory()
%function wxString wxGetFullHostName()
%function wxString wxGetHomeDir()
%function wxString wxGetHostName()
%function wxString wxGetOsDescription()
// %override [int version, int major, int minor] wxGetOsVersion()
// int wxGetOsVersion(int *major = NULL, int *minor = NULL)
%function int wxGetOsVersion()

%function wxString wxGetUserHome(const wxString& user = "")
%function wxString wxGetUserId()
%function wxString wxGetUserName()

// ---------------------------------------------------------------------------
// Environmental access functions

// %override [bool lua_string] wxGetEnv(const wxString& var)
// Returns success and the string environment variable.
// C++ Func: bool wxGetEnv(const wxString& var, wxString *value)
%function bool wxGetEnv(const wxString& var)
%function bool wxSetEnv(const wxString& var, const wxString& value)
%function bool wxUnsetEnv(const wxString& var)


// ---------------------------------------------------------------------------
// wxSystemOptions

%if wxLUA_USE_wxSystemOptions

%include "wx/sysopt.h"

%class wxSystemOptions, wxObject
    //wxSystemOptions() // No constructor, all member functions static

    static wxString GetOption(const wxString& name) const
    static int GetOptionInt(const wxString& name) const
    static bool HasOption(const wxString& name) const
    static bool IsFalse(const wxString& name) const

    %if wxUSE_SYSTEM_OPTIONS
        static void SetOption(const wxString& name, const wxString& value)
        static void SetOption(const wxString& name, int value)
    %endif //wxUSE_SYSTEM_OPTIONS
%endclass

%endif //wxLUA_USE_wxSystemOptions


// ---------------------------------------------------------------------------
// wxPlatformInfo

%enum wxOperatingSystemId
    wxOS_UNKNOWN                     // returned on error

    wxOS_MAC_OS                      // Apple Mac OS 8/9/X with Mac paths
    wxOS_MAC_OSX_DARWIN              // Apple Mac OS X with Unix paths
    wxOS_MAC                         // wxOS_MAC_OS|wxOS_MAC_OSX_DARWIN,

    wxOS_WINDOWS_9X                   // Windows 9x family (95/98/ME)
    wxOS_WINDOWS_NT                   // Windows NT family (NT/2000/XP)
    wxOS_WINDOWS_MICRO                // MicroWindows
    wxOS_WINDOWS_CE                   // Windows CE (Window Mobile)
    wxOS_WINDOWS                      //  wxOS_WINDOWS_9X|wxOS_WINDOWS_NT|wxOS_WINDOWS_MICRO|wxOS_WINDOWS_CE,

    wxOS_UNIX_LINUX                    // Linux
    wxOS_UNIX_FREEBSD                  // FreeBSD
    wxOS_UNIX_OPENBSD                  // OpenBSD
    wxOS_UNIX_NETBSD                   // NetBSD
    wxOS_UNIX_SOLARIS                  // SunOS
    wxOS_UNIX_AIX                      // AIX
    wxOS_UNIX_HPUX                     // HP/UX
    wxOS_UNIX                          // wxOS_UNIX_LINUX|wxOS_UNIX_FREEBSD|wxOS_UNIX_OPENBSD|wxOS_UNIX_NETBSD|wxOS_UNIX_SOLARIS|wxOS_UNIX_AIX|wxOS_UNIX_HPUX,

    wxOS_DOS                           // Microsoft DOS
    wxOS_OS2                           // OS/2
%endenum

%enum wxPortId
    wxPORT_UNKNOWN      // returned on error

    wxPORT_BASE         // wxBase, no native toolkit used

    wxPORT_MSW          // wxMSW, native toolkit is Windows API
    wxPORT_MOTIF        // wxMotif, using [Open]Motif or Lesstif
    wxPORT_GTK          // wxGTK, using GTK+ 1.x, 2.x, GPE or Maemo
    wxPORT_MGL          // wxMGL, using wxUniversal
    wxPORT_X11          // wxX11, using wxUniversal
    wxPORT_PM           // wxOS2, using OS/2 Presentation Manager
    wxPORT_OS2          // wxOS2, using OS/2 Presentation Manager
    wxPORT_MAC          // wxMac, using Carbon or Classic Mac API
    wxPORT_COCOA        // wxCocoa, using Cocoa NextStep/Mac API
    wxPORT_WINCE        // wxWinCE, toolkit is WinCE SDK API
    wxPORT_PALMOS       // wxPalmOS, toolkit is PalmOS API
    wxPORT_DFB          // wxDFB, using wxUniversal
%endenum

%enum wxArchitecture
    wxARCH_INVALID         // returned on error

    wxARCH_32              // 32 bit
    wxARCH_64

    wxARCH_MAX
%endenum

%enum wxEndianness
    wxENDIAN_INVALID           // returned on error

    wxENDIAN_BIG               // 4321
    wxENDIAN_LITTLE            // 1234
    wxENDIAN_PDP               // 3412

    wxENDIAN_MAX
%endenum

%class wxPlatformInfo
    // No constructor, use static Get() function
    //wxPlatformInfo();
    //wxPlatformInfo(wxPortId pid, int tkMajor = -1, int tkMinor = -1, wxOperatingSystemId id = wxOS_UNKNOWN, int osMajor = -1, int osMinor = -1, wxArchitecture arch = wxARCH_INVALID, wxEndianness endian = wxENDIAN_INVALID, bool usingUniversal = false)

    // Gets a wxPlatformInfo already initialized with the values for
    // the currently running platform.
    //static const wxPlatformInfo& Get();
    static const wxPlatformInfo& Get()

    static wxOperatingSystemId GetOperatingSystemId(const wxString &name);
    static wxPortId GetPortId(const wxString &portname);

    static wxArchitecture GetArch(const wxString &arch);
    static wxEndianness GetEndianness(const wxString &end);

    static wxString GetOperatingSystemFamilyName(wxOperatingSystemId os);
    static wxString GetOperatingSystemIdName(wxOperatingSystemId os);
    static wxString GetPortIdName(wxPortId port, bool usingUniversal);
    static wxString GetPortIdShortName(wxPortId port, bool usingUniversal);

    static wxString GetArchName(wxArchitecture arch);
    static wxString GetEndiannessName(wxEndianness end);

    int GetOSMajorVersion() const
    int GetOSMinorVersion() const

    bool CheckOSVersion(int major, int minor) const

    int GetToolkitMajorVersion() const
    int GetToolkitMinorVersion() const

    bool CheckToolkitVersion(int major, int minor) const
    bool IsUsingUniversalWidgets() const

    wxOperatingSystemId GetOperatingSystemId() const
    wxPortId GetPortId() const
    wxArchitecture GetArchitecture() const
    wxEndianness GetEndianness() const

    wxString GetOperatingSystemFamilyName() const
    wxString GetOperatingSystemIdName() const
    wxString GetPortIdName() const
    wxString GetPortIdShortName() const
    wxString GetArchName() const
    wxString GetEndiannessName() const

    void SetOSVersion(int major, int minor)
    void SetToolkitVersion(int major, int minor)
    void SetOperatingSystemId(wxOperatingSystemId n)
    void SetPortId(wxPortId n)
    void SetArchitecture(wxArchitecture n)
    void SetEndianness(wxEndianness n)

    bool IsOk() const

    //bool operator==(const wxPlatformInfo &t) const; // we only use the wxWidget's wxPlatformInfo
    //bool operator!=(const wxPlatformInfo &t) const
%endclass


// ---------------------------------------------------------------------------
// wxSingleInstanceChecker

%if wxUSE_SNGLINST_CHECKER

%include "wx/snglinst.h"

%class %delete wxSingleInstanceChecker
    wxSingleInstanceChecker() // default ctor, use Create() after it
    // like Create() but no error checking (dangerous!)
    //wxSingleInstanceChecker(const wxString& name, const wxString& path = "")

    // name must be given and be as unique as possible, it is used as the mutex
    // name under Win32 and the lock file name under Unix -
    // wxTheApp->GetAppName() may be a good value for this parameter
    //
    // path is optional and is ignored under Win32 and used as the directory to
    // create the lock file in under Unix (default is wxGetHomeDir())
    //
    // returns false if initialization failed, it doesn't mean that another
    // instance is running - use IsAnotherRunning() to check it
    bool Create(const wxString& name, const wxString& path = "")

    bool IsAnotherRunning() const // is another copy of this program already running?

%endclass

%endif // wxUSE_SNGLINST_CHECKER


// ---------------------------------------------------------------------------
// wxLog - See GUI log bindings in wxcore_core.i

%if wxLUA_USE_wxLog && wxUSE_LOG

%include "wx/log.h"

// These functions are in log.h
%function unsigned long wxSysErrorCode()
%function wxString wxSysErrorMsg(unsigned long nErrCode = 0)

%function void wxSafeShowMessage(const wxString& title, const wxString& text)

// All of the wxLogXXX functions take only a single string,
// use string.format(...) to format the string in Lua.

// C++ Func: void wxLogError(const char *formatString, ...)
%function void wxLogError(const wxString& message)
// C++ Func: void wxLogFatalError(const char *formatString, ...)
%function void wxLogFatalError(const wxString& message)
// C++ Func: void wxLogWarning(const char *formatString, ...)
%function void wxLogWarning(const wxString& message)
// C++ Func: void wxLogMessage(const char *formatString, ...)
%function void wxLogMessage(const wxString& message)
// C++ Func: void wxLogVerbose(const char *formatString, ...)
%function void wxLogVerbose(const wxString& message)
// C++ Func: void wxLogStatus(wxFrame *frame, const char *formatString, ...)
// void wxLogStatus(const char *formatString, ...) // this just uses the toplevel frame, use wx.NULL for the frame
// IN wxCore %function void wxLogStatus(wxFrame *frame, const wxString& message)

// C++ Func: void wxLogSysError(const char *formatString, ...)
%function void wxLogSysError(const wxString& message)
// C++ Func: void wxLogDebug(const char *formatString, ...)
%function void wxLogDebug(const wxString& message)
// C++ Func: void wxLogTrace(const char *mask, const char *formatString, ...)
%function void wxLogTrace(const wxString& mask, const wxString& message)
// void wxLogTrace(const char *formatString, ...)
// void wxLogTrace(wxTraceMask mask, const char *formatString, ...) - deprecated

%typedef unsigned long wxTraceMask
%typedef unsigned long wxLogLevel

%enum // wxLogLevel - uses these enums
    wxLOG_FatalError, // program can't continue, abort immediately
    wxLOG_Error,      // a serious error, user must be informed about it
    wxLOG_Warning,    // user is normally informed about it but may be ignored
    wxLOG_Message,    // normal message (i.e. normal output of a non GUI app)
    wxLOG_Status,     // informational: might go to the status line of GUI app
    wxLOG_Info,       // informational message (a.k.a. 'Verbose')
    wxLOG_Debug,      // never shown to the user, disabled in release mode
    wxLOG_Trace,      // trace messages are also only enabled in debug mode
    wxLOG_Progress,   // used for progress indicator (not yet)

    wxLOG_User,       // user defined levels start here
    wxLOG_Max
%endenum

// symbolic trace masks - wxLogTrace("foo", "some trace message...") will be
// discarded unless the string "foo" has been added to the list of allowed
// ones with AddTraceMask()
%define_string wxTRACE_MemAlloc //wxT("memalloc") // trace memory allocation (new/delete)
%define_string wxTRACE_Messages //wxT("messages") // trace window messages/X callbacks
%define_string wxTRACE_ResAlloc //wxT("resalloc") // trace GDI resource allocation
%define_string wxTRACE_RefCount //wxT("refcount") // trace various ref counting operations
%msw %define_string wxTRACE_OleCalls //wxT("ole") // OLE interface calls

%class %delete wxLog
    //wxLog() - No constructor, a base class, use one of the derived classes.

    static bool IsEnabled()
    static bool EnableLogging(bool doIt = true)
    virtual void Flush()
    static void FlushActive()
    // Don't delete the active target until you set a new one or set it to wx.NULL
    // Note, a new wxLog is created unless DontCreateOnDemand() is called.
    static wxLog *GetActiveTarget()
    // When you create a new wxLog and call "oldLog = SetActiveTarget(MyLog)"
    // the returned oldLog will be garbage collected or you can delete() the
    // oldLog unless you want to reuse it by calling "myLog = SetActiveTarget(oldLog)"
    // which releases myLog to be garbage collected or delete()ed by you.
    // Basicly, wxWidgets 'owns' the log you pass to SetActiveTarget() and
    // wxLua 'owns' the returned log.
    static %gc wxLog *SetActiveTarget(%ungc wxLog *pLogger)
    static void Suspend()
    static void Resume()
    static void SetVerbose(bool bVerbose = true)
    static void SetLogLevel(wxLogLevel logLevel)
    static void DontCreateOnDemand()
    %wxchkver_2_8 static void SetRepetitionCounting(bool bRepetCounting = true)
    %wxchkver_2_8 static bool GetRepetitionCounting()
    static void SetTraceMask(wxTraceMask ulMask)
    static void AddTraceMask(const wxString& str)
    static void RemoveTraceMask(const wxString& str)
    static void ClearTraceMasks()
    static wxArrayString GetTraceMasks() // not const wxArrayString since we copy it anyway

    // %override static void wxLog::SetTimestamp(const wxString& ts)
    // Allows an input of "nil" or no value to disable time stamping.
    // C++ Func: static void wxLog::SetTimestamp(const wxChar* ts)
    static void SetTimestamp(const wxString& ts)

    static bool GetVerbose()
    static wxTraceMask GetTraceMask()
    static bool IsAllowedTraceMask(const wxString& mask)
    static wxLogLevel GetLogLevel()
    static wxString GetTimestamp()
%endclass

// ---------------------------------------------------------------------------
// wxLogBuffer

%class %delete wxLogBuffer, wxLog
    wxLogBuffer()

    const wxString& GetBuffer() const // get the string contents with all messages logged
%endclass

// ---------------------------------------------------------------------------
// wxLogChain

%class %delete wxLogChain, wxLog
    wxLogChain(wxLog *logger)

    void SetLog(wxLog *logger) // change the new log target
    // this can be used to temporarily disable (and then reenable) passing
    // messages to the old logger (by default we do pass them)
    void PassMessages(bool bDoPass)
    // are we passing the messages to the previous log target?
    bool IsPassingMessages() const
    // return the previous log target (may be NULL)
    wxLog *GetOldLog() const
%endclass

// ---------------------------------------------------------------------------
// wxLogNull

%class %delete wxLogNull // NOTE: this is not derived from wxLog
    // NOTE: ALWAYS delete() this when done since Lua's gc may not delete it soon enough
    wxLogNull()

%endclass

// ---------------------------------------------------------------------------
// wxLogPassThrough - a chain log target which uses itself as the new logger

%class %delete wxLogPassThrough, wxLogChain
    wxLogPassThrough()

%endclass

// ---------------------------------------------------------------------------
// wxLogStderr - FIXME need to implement FILE*

/*
%class %delete wxLogStderr, wxLog
    wxLogStderr(FILE *fp = (FILE *) NULL) // redirect log output to a FILE

%endclass
*/

// ---------------------------------------------------------------------------
// wxLogStream - FIXME need to implement wxSTD ostream* (just use wxLogBuffer)

/*
%if wxUSE_STD_IOSTREAM

%class %delete wxLogStream, wxLog
    wxLogStream(wxSTD ostream *ostr = NULL); // redirect log output to an ostream

%endclass

%endif // wxUSE_STD_IOSTREAM
*/

%endif // wxLUA_USE_wxLog && wxUSE_LOG

// ---------------------------------------------------------------------------
// wxDynamicLibrary - No a lot you can do with this, but it might make
//                    testing or debugging a C++ program easier to test thing
//                    out in wxLua first.

%if // wxLUA_USE_wxDynamicLibrary && wxUSE_DYNLIB_CLASS

%include "wx/dynlib.h"

%enum wxDLFlags
    wxDL_LAZY       // resolve undefined symbols at first use
                    // (only works on some Unix versions)
    wxDL_NOW        // resolve undefined symbols on load
                    // (default, always the case under Win32)
    wxDL_GLOBAL     // export extern symbols to subsequently
                    // loaded libs.
    wxDL_VERBATIM   // attempt to load the supplied library
                    // name without appending the usual dll
                    // filename extension.
    wxDL_NOSHARE    // load new DLL, don't reuse already loaded
                    // (only for wxPluginManager)

    wxDL_DEFAULT    // = wxDL_NOW // default flags correspond to Win32
%endenum

%enum wxDynamicLibraryCategory
    wxDL_LIBRARY,       // standard library
    wxDL_MODULE         // loadable module/plugin
%endenum

%enum wxPluginCategory
    wxDL_PLUGIN_GUI,    // plugin that uses GUI classes
    wxDL_PLUGIN_BASE    // wxBase-only plugin
%endenum


%class %delete wxDynamicLibraryDetails
    // ctor, normally never used as these objects are only created by wxDynamicLibrary
    // wxDynamicLibrary::ListLoaded()
    //wxDynamicLibraryDetails() { m_address = NULL; m_length = 0; }

    wxString GetName() const // get the (base) name
    wxString GetPath() const // get the full path of this object

    // get the load address and the extent, return true if this information is available
    //bool GetAddress(void **addr, size_t *len) const

    wxString GetVersion() const // return the version of the DLL (may be empty if no version info)
%endclass

%class %delete wxDynamicLibraryDetailsArray
    //wxDynamicLibraryDetailsArray() // Get this from wxDynamicLibrary::ListLoaded

    int  GetCount() const
    wxDynamicLibraryDetails Item( int n )
%endclass


%class %delete wxDynamicLibrary
    wxDynamicLibrary()
    wxDynamicLibrary(const wxString& libname, int flags = wxDL_DEFAULT)

    // return a valid handle for the main program itself or NULL if back
    // linking is not supported by the current platform (e.g. Win32)
    //static wxDllType GetProgramHandle();

    // return the platform standard DLL extension (with leading dot)
    //static const wxChar *GetDllExt()
    static wxString GetDllExt()

    // return true if the library was loaded successfully
    bool IsLoaded() const

    // load the library with the given name (full or not), return true if ok
    bool Load(const wxString& libname, int flags = wxDL_DEFAULT);

    // raw function for loading dynamic libs: always behaves as if
    // wxDL_VERBATIM were specified and doesn't log error message if the
    // library couldn't be loaded but simply returns NULL
    //static wxDllType RawLoad(const wxString& libname, int flags = wxDL_DEFAULT);

    // detach the library object from its handle, i.e. prevent the object from
    // unloading the library in its dtor -- the caller is now responsible for doing this
    //wxDllType Detach()

    // unload the given library handle (presumably returned by Detach() before)
    //static void Unload(wxDllType handle);

    // unload the library, also done automatically in dtor
    void Unload()

    // Return the raw handle from dlopen and friends.
    //wxDllType GetLibHandle() const { return m_handle; }

    // check if the given symbol is present in the library, useful to verify if
    // a loadable module is our plugin, for example, without provoking error
    // messages from GetSymbol()
    bool HasSymbol(const wxString& name) const

    // resolve a symbol in a loaded DLL, such as a variable or function name.
    // 'name' is the (possibly mangled) name of the symbol. (use extern "C" to
    // export unmangled names)
    // Since it is perfectly valid for the returned symbol to actually be NULL,
    // that is not always indication of an error.  Pass and test the parameter
    // 'success' for a true indication of success or failure to load the symbol.
    // Returns a pointer to the symbol on success, or NULL if an error occurred
    // or the symbol wasn't found.
    //void *GetSymbol(const wxString& name, bool *success = NULL) const;

    // low-level version of GetSymbol()
    //static void *RawGetSymbol(wxDllType handle, const wxString& name);
    //void *RawGetSymbol(const wxString& name) const

//#ifdef __WXMSW__
    // this function is useful for loading functions from the standard Windows
    // DLLs: such functions have an 'A' (in ANSI build) or 'W' (in Unicode, or
    // wide character build) suffix if they take string parameters
    //static void *RawGetSymbolAorW(wxDllType handle, const wxString& name)
    //void *GetSymbolAorW(const wxString& name) const
//#endif // __WXMSW__

    // return all modules/shared libraries in the address space of this process
    // returns an empty array if not implemented or an error occurred
    static wxDynamicLibraryDetailsArray ListLoaded();

    // return platform-specific name of dynamic library with proper extension
    // and prefix (e.g. "foo.dll" on Windows or "libfoo.so" on Linux)
    static wxString CanonicalizeName(const wxString& name, wxDynamicLibraryCategory cat = wxDL_LIBRARY);

    // return name of wxWidgets plugin (adds compiler and version info
    // to the filename):
    static wxString CanonicalizePluginName(const wxString& name, wxPluginCategory cat = wxDL_PLUGIN_GUI);

    // return plugin directory on platforms where it makes sense and empty string on others:
    static wxString GetPluginsDirectory()
%endclass

// ---------------------------------------------------------------------------
// wxPluginLibrary - You cannot use this within wxLua

// ---------------------------------------------------------------------------
// wxPluginManager - You cannot use this within wxLua

%endif // wxLUA_USE_wxDynamicLibrary && wxUSE_DYNLIB_CLASS


// ---------------------------------------------------------------------------
// wxCriticalSection

%if wxLUA_USE_wxCriticalSection && wxUSE_THREADS

%include "wx/thread.h"

%class %delete wxCriticalSection
    wxCriticalSection()
    void Enter()
    void Leave()
%endclass

%endif // wxLUA_USE_wxCriticalSection


// ---------------------------------------------------------------------------
// wxCriticalSectionLocker

%if wxLUA_USE_wxCriticalSectionLocker

%include "wx/thread.h"

%class %delete wxCriticalSectionLocker
    wxCriticalSectionLocker(wxCriticalSection& cs);
%endclass

%endif // wxLUA_USE_wxCriticalSectionLocker && wxUSE_THREADS


// ---------------------------------------------------------------------------
//  wxRegEx - Regular expression support

%if wxLUA_USE_wxRegEx && wxUSE_REGEX

%include "wx/regex.h"

%enum
    wxRE_EXTENDED
    wxRE_BASIC
    wxRE_ICASE
    wxRE_NOSUB
    wxRE_NEWLINE
    wxRE_DEFAULT
%endenum

%enum
    wxRE_NOTBOL
    wxRE_NOTEOL
%endenum

%class %delete wxRegEx
    wxRegEx()
    wxRegEx(const wxString& expr, int flags = wxRE_DEFAULT)

    bool Compile(const wxString& pattern, int flags = wxRE_DEFAULT)
    bool IsValid() const
    wxString GetMatch(const wxString& text, size_t index = 0) const

    // %override [bool, size_t start, size_t len] wxRegEx::GetMatch(size_t index = 0) const
    // C++ Func: bool GetMatch(size_t* start, size_t* len, size_t index = 0) const
    %override_name wxLua_wxRegEx_GetMatchIndexes bool GetMatch(size_t index = 0) const

    size_t GetMatchCount() const
    // Note: only need this form of Matches
    bool Matches(const wxString &text, int flags = 0) const

    // %override [int, string text] wxRegEx::Replace(const wxString& text, const wxString& replacement, size_t maxMatches = 0) const
    // C++ Func: int Replace(wxString* text, const wxString& replacement, size_t maxMatches = 0) const
    int Replace(const wxString& text, const wxString& replacement, size_t maxMatches = 0) const

    // %override [int, string text] wxRegEx::ReplaceAll(const wxString& text, const wxString& replacement) const
    // C++ Func: int ReplaceAll(wxString* text, const wxString& replacement) const
    int ReplaceAll(const wxString& text, const wxString& replacement) const

    // %override [int, string text] wxRegEx::ReplaceFirst(const wxString& text, const wxString& replacement) const
    // C++ Func: int ReplaceFirst(wxString* text, const wxString& replacement) const
    int ReplaceFirst(const wxString& text, const wxString& replacement) const

%endclass

%endif //wxLUA_USE_wxRegEx && wxUSE_REGEX

