// ===========================================================================
// Purpose:     wxDateTime and other time related classes and functions
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

%include "wx/utils.h"
%include "wx/timer.h"

%function wxString wxNow()
%function long wxGetLocalTime()
%function long wxGetUTCTime()
%function wxLongLong wxGetLocalTimeMillis()
%wxcompat_2_6 %function void wxStartTimer()                           // deprecated in 2.8 use wxStopWatch
%wxcompat_2_6 %function long wxGetElapsedTime(bool resetTimer = true) // deprecated in 2.8 use wxStopWatch
%function void wxSleep(int secs)
%wxchkver_2_6 %function void wxMilliSleep(unsigned long milliseconds)
%wxchkver_2_6 %function void wxMicroSleep(unsigned long microseconds)
!%wxchkver_2_6 %function void wxUsleep(unsigned long milliseconds)

// ---------------------------------------------------------------------------
// wxDateTime

%if wxLUA_USE_wxDateTime && wxUSE_DATETIME

%include "wx/datetime.h"

%enum wxDateTime::TZ
    Local
    GMT_12
    GMT_11
    GMT_10
    GMT_9
    GMT_8
    GMT_7
    GMT_6
    GMT_5
    GMT_4
    GMT_3
    GMT_2
    GMT_1
    GMT0
    GMT1
    GMT2
    GMT3
    GMT4
    GMT5
    GMT6
    GMT7
    GMT8
    GMT9
    GMT10
    GMT11
    GMT12
    %wxchkver_2_8 GMT13
    WET
    WEST
    CET
    CEST
    EET
    EEST
    MSK
    MSD
    AST
    ADT
    EST
    EDT
    CST
    CDT
    MST
    MDT
    PST
    PDT
    HST
    AKST
    AKDT
    A_WST
    A_CST
    A_EST
    A_ESST
    %wxchkver_2_8 NZST
    %wxchkver_2_8 NZDT
    UTC
%endenum

%enum wxDateTime::Calendar
    Gregorian
    Julian
%endenum

%enum wxDateTime::Country
    Country_Unknown
    Country_Default
    Country_WesternEurope_Start
    Country_EEC
    France
    Germany
    UK
    Country_WesternEurope_End
    Russia
    USA
%endenum

%enum wxDateTime::Month
    Jan
    Feb
    Mar
    Apr
    May
    Jun
    Jul
    Aug
    Sep
    Oct
    Nov
    Dec
    Inv_Month
%endenum

%enum wxDateTime::WeekDay
    Sun
    Mon
    Tue
    Wed
    Thu
    Fri
    Sat
    Inv_WeekDay
%endenum

%typedef unsigned short wxDateTime::wxDateTime_t

%class %delete wxDateTime
    %define_object wxDefaultDateTime

    wxDateTime()
    wxDateTime(time_t dateTime) // use with Lua's os.time() on MSW, Linux, others?
    %rename wxDateTimeFromJDN wxDateTime(double dateTime)
    %rename wxDateTimeFromHMS wxDateTime(int hour, int minute, int second, int millisec)
    %rename wxDateTimeFromDMY wxDateTime(int day, wxDateTime::Month month = wxDateTime::Inv_Month, int year = wxDateTime::Inv_Year, int hour = 0, int minute = 0, int second = 0, int millisec = 0)

    static wxDateTime Now()
    static wxDateTime UNow()
    static wxDateTime Today()
    static void SetCountry(wxDateTime::Country country)

    wxDateTime& SetToCurrent()
    wxDateTime& Set(time_t time) // use with Lua's os.time() on MSW, Linux, others?
    %rename SetToJDN wxDateTime& Set(double dateTime)
    %rename SetToHMS wxDateTime& Set(int hour, int minute, int second, int millisec)
    %rename SetToDMY wxDateTime& Set(int day, wxDateTime::Month month = wxDateTime::Inv_Month, int year = wxDateTime::Inv_Year, int hour = 0, int minute = 0, int second = 0, int millisec = 0)
    wxDateTime& ResetTime()
    wxDateTime& SetDay(int day)
    wxDateTime& SetMonth(wxDateTime::Month month)
    wxDateTime& SetYear(int year)
    wxDateTime& SetHour(int hour)
    wxDateTime& SetMinute(int minute)
    wxDateTime& SetSecond(int second)
    wxDateTime& SetMillisecond(int millisecond)
    bool IsWorkDay(wxDateTime::Country country = wxDateTime::Country_Default) const
    bool IsEqualTo(const wxDateTime& datetime) const
    bool IsEarlierThan(const wxDateTime& datetime) const
    bool IsLaterThan(const wxDateTime& datetime) const
    bool IsStrictlyBetween(const wxDateTime& t1, const wxDateTime& t2) const
    bool IsBetween(const wxDateTime& t1, const wxDateTime& t2) const
    bool IsSameDate(const wxDateTime& dt) const
    bool IsSameTime(const wxDateTime& dt) const
    bool IsEqualUpTo(const wxDateTime& dt, const wxTimeSpan& ts) const
    bool IsValid()
    long GetTicks()
    wxDateTime& SetToWeekDayInSameWeek(wxDateTime::WeekDay weekday)
    wxDateTime  GetWeekDayInSameWeek(wxDateTime::WeekDay weekday) const
    wxDateTime& SetToNextWeekDay(wxDateTime::WeekDay weekday)
    wxDateTime GetNextWeekDay(wxDateTime::WeekDay weekday) const
    wxDateTime& SetToPrevWeekDay(wxDateTime::WeekDay weekday)
    wxDateTime GetPrevWeekDay(wxDateTime::WeekDay weekday) const
    bool SetToWeekDay(wxDateTime::WeekDay weekday, int n = 1, wxDateTime::Month month = wxDateTime::Inv_Month, int year = wxDateTime::Inv_Year)
    wxDateTime GetWeekDay(wxDateTime::WeekDay weekday, int n = 1, wxDateTime::Month month = wxDateTime::Inv_Month, int year = wxDateTime::Inv_Year) const
    bool SetToLastWeekDay(wxDateTime::WeekDay weekday, wxDateTime::Month month = wxDateTime::Inv_Month, int year = wxDateTime::Inv_Year)
    wxDateTime GetLastWeekDay(wxDateTime::WeekDay weekday, wxDateTime::Month month = wxDateTime::Inv_Month, int year = wxDateTime::Inv_Year)
    !%wxchkver_2_6 bool SetToTheWeek(wxDateTime::wxDateTime_t numWeek, wxDateTime::WeekDay weekday = wxDateTime::Mon)
    !%wxchkver_2_6 wxDateTime GetWeek(wxDateTime::wxDateTime_t numWeek, wxDateTime::WeekDay weekday = wxDateTime::Mon) const
    %wxchkver_2_6 static wxDateTime SetToWeekOfYear(int year, wxDateTime::wxDateTime_t numWeek, wxDateTime::WeekDay weekday = wxDateTime::Mon)
    wxDateTime& SetToLastMonthDay(wxDateTime::Month month = wxDateTime::Inv_Month, int year = wxDateTime::Inv_Year)
    wxDateTime GetLastMonthDay(wxDateTime::Month month = wxDateTime::Inv_Month, int year = wxDateTime::Inv_Year) const
    wxDateTime& SetToYearDay(wxDateTime::wxDateTime_t yday)
    wxDateTime GetYearDay(wxDateTime::wxDateTime_t yday) const
    double GetJulianDayNumber() const
    double GetJDN() const
    double GetModifiedJulianDayNumber() const
    double GetMJD() const
    double GetRataDie() const
    wxDateTime ToGMT(bool noDST = false) const
    wxDateTime& MakeGMT(bool noDST = false)
    int IsDST(wxDateTime::Country country = wxDateTime::Country_Default) const
    wxDateTime& Add(const wxTimeSpan& diff)
    wxDateTime& Add(const wxDateSpan& diff)
    wxDateTime& Subtract(const wxTimeSpan& diff)
    wxDateTime& Subtract(const wxDateSpan& diff)
    wxString ParseRfc822Date(wxString date)
    wxString ParseFormat(wxString date, wxString format = "%c", const wxDateTime& dateDef = wxDefaultDateTime)
    wxString ParseDateTime(wxString datetime)
    wxString ParseDate(wxString date)
    wxString ParseTime(wxString time)
    wxString FormatDate() const
    wxString FormatTime() const
    wxString FormatISODate() const
    wxString FormatISOTime() const
    wxString Format(wxString format = "%c", wxDateTime::TZ tz = wxDateTime::Local) const
%endclass

// ---------------------------------------------------------------------------
// wxDateTimeArray

%class %delete wxDateTimeArray
    wxDateTimeArray()
    wxDateTimeArray(const wxDateTimeArray& array)

    void Add(const wxDateTime& dateTime, size_t copies = 1)
    void Alloc(size_t nCount)
    void Clear()
    void Empty()
    int GetCount() const
    void Insert(const wxDateTime& dt, int nIndex, size_t copies = 1)
    bool IsEmpty()
    wxDateTime Item(size_t nIndex) const
    wxDateTime Last()
    void RemoveAt(size_t nIndex, size_t count = 1)
    void Shrink()
%endclass

%endif //wxLUA_USE_wxDateTime && wxUSE_DATETIME

// ---------------------------------------------------------------------------
// wxTimeSpan

%if wxLUA_USE_wxTimeSpan && wxUSE_DATETIME

%include "wx/datetime.h"

%class %delete wxTimeSpan
    wxTimeSpan()
    wxTimeSpan(long hours, long minutes = 0, long seconds = 0, long milliseconds = 0)

    wxTimeSpan Abs()
    wxTimeSpan Add(const wxTimeSpan& diff) const
    static wxTimeSpan Days(long days)
    static wxTimeSpan Day()
    wxString Format(wxString format = "%H:%M:%S") const
    int GetDays() const
    int GetHours() const
    wxLongLong GetMilliseconds() const
    int GetMinutes() const
    wxLongLong GetSeconds() const
    wxLongLong GetValue() const
    int GetWeeks() const
    static wxTimeSpan  Hours(long hours)
    static wxTimeSpan  Hour()
    bool IsEqualTo(const wxTimeSpan& ts) const
    bool IsLongerThan(const wxTimeSpan& ts) const
    bool IsNegative() const
    bool IsNull() const
    bool IsPositive() const
    bool IsShorterThan(const wxTimeSpan& ts) const
    static wxTimeSpan  Minutes(long min)
    static wxTimeSpan  Minute()
    wxTimeSpan Multiply(int n) const
    wxTimeSpan Negate() const
    wxTimeSpan& Neg()
    static wxTimeSpan Seconds(long sec)
    static wxTimeSpan Second()
    wxTimeSpan Subtract(const wxTimeSpan& diff) const
    static wxTimeSpan Weeks(long weeks)
    static wxTimeSpan Week()
%endclass

%endif //wxLUA_USE_wxTimeSpan && wxUSE_DATETIME

// ---------------------------------------------------------------------------
// wxDateSpan

%if wxLUA_USE_wxDateSpan && wxUSE_DATETIME

%include "wx/datetime.h"

%class %delete wxDateSpan
    wxDateSpan(int years = 0, int months = 0, int weeks = 0, int days = 0)

    wxDateSpan Add(const wxDateSpan& other) const
    static wxDateSpan Day()
    static wxDateSpan Days(int days)
    int GetDays() const
    int GetMonths() const
    int GetTotalDays() const
    int GetWeeks() const
    int GetYears() const
    static wxDateSpan  Month()
    static wxDateSpan  Months(int mon)
    wxDateSpan Multiply(int factor) const
    wxDateSpan Negate() const
    wxDateSpan& Neg()
    wxDateSpan& SetDays(int n)
    wxDateSpan& SetMonths(int n)
    wxDateSpan& SetWeeks(int n)
    wxDateSpan& SetYears(int n)
    wxDateSpan Subtract(const wxDateSpan& other) const
    static wxDateSpan Week()
    static wxDateSpan Weeks(int weeks)
    static wxDateSpan Year()
    static wxDateSpan Years(int years)

    %operator bool operator==(wxDateSpan& other) const
%endclass

%endif //wxLUA_USE_wxDateSpan && wxUSE_DATETIME

// ---------------------------------------------------------------------------
// wxDateTimeHolidayAuthority

%if wxLUA_USE_wxDateTimeHolidayAuthority && wxUSE_DATETIME

%class wxDateTimeHolidayAuthority
    // no constructor since this class has pure virtual functions

    static bool IsHoliday(const wxDateTime& dt)
    static size_t GetHolidaysInRange(const wxDateTime& dtStart, const wxDateTime& dtEnd, wxDateTimeArray& holidays)
    static void ClearAllAuthorities()
    static void AddAuthority(wxDateTimeHolidayAuthority *auth)

%endclass

// ---------------------------------------------------------------------------
// wxDateTimeWorkDays

%class %delete wxDateTimeWorkDays, wxDateTimeHolidayAuthority
    wxDateTimeWorkDays()
%endclass

%endif //wxLUA_USE_wxDateTimeHolidayAuthority && wxUSE_DATETIME


// ---------------------------------------------------------------------------
// wxStopWatch

%if wxLUA_USE_wxStopWatch && wxUSE_STOPWATCH

%include "wx/stopwatch.h"

%class %delete wxStopWatch
    wxStopWatch() // ctor starts the stop watch

    void Start(long t0 = 0) // start the stop watch at the moment t0
    void Pause()
    void Resume()
    long Time() const
%endclass

%endif // wxLUA_USE_wxStopWatch && wxUSE_STOPWATCH


// ---------------------------------------------------------------------------
// wxLocale

%include "wx/intl.h"

%if wxUSE_INTL

%enum wxLanguage
    // user's default/preffered language as got from OS:
    wxLANGUAGE_DEFAULT,
    // unknown language, if wxLocale::GetSystemLanguage fails:
    wxLANGUAGE_UNKNOWN,

    wxLANGUAGE_ABKHAZIAN,
    wxLANGUAGE_AFAR,
    wxLANGUAGE_AFRIKAANS,
    wxLANGUAGE_ALBANIAN,
    wxLANGUAGE_AMHARIC,
    wxLANGUAGE_ARABIC,
    wxLANGUAGE_ARABIC_ALGERIA,
    wxLANGUAGE_ARABIC_BAHRAIN,
    wxLANGUAGE_ARABIC_EGYPT,
    wxLANGUAGE_ARABIC_IRAQ,
    wxLANGUAGE_ARABIC_JORDAN,
    wxLANGUAGE_ARABIC_KUWAIT,
    wxLANGUAGE_ARABIC_LEBANON,
    wxLANGUAGE_ARABIC_LIBYA,
    wxLANGUAGE_ARABIC_MOROCCO,
    wxLANGUAGE_ARABIC_OMAN,
    wxLANGUAGE_ARABIC_QATAR,
    wxLANGUAGE_ARABIC_SAUDI_ARABIA,
    wxLANGUAGE_ARABIC_SUDAN,
    wxLANGUAGE_ARABIC_SYRIA,
    wxLANGUAGE_ARABIC_TUNISIA,
    wxLANGUAGE_ARABIC_UAE,
    wxLANGUAGE_ARABIC_YEMEN,
    wxLANGUAGE_ARMENIAN,
    wxLANGUAGE_ASSAMESE,
    wxLANGUAGE_AYMARA,
    wxLANGUAGE_AZERI,
    wxLANGUAGE_AZERI_CYRILLIC,
    wxLANGUAGE_AZERI_LATIN,
    wxLANGUAGE_BASHKIR,
    wxLANGUAGE_BASQUE,
    wxLANGUAGE_BELARUSIAN,
    wxLANGUAGE_BENGALI,
    wxLANGUAGE_BHUTANI,
    wxLANGUAGE_BIHARI,
    wxLANGUAGE_BISLAMA,
    wxLANGUAGE_BRETON,
    wxLANGUAGE_BULGARIAN,
    wxLANGUAGE_BURMESE,
    wxLANGUAGE_CAMBODIAN,
    wxLANGUAGE_CATALAN,
    wxLANGUAGE_CHINESE,
    wxLANGUAGE_CHINESE_SIMPLIFIED,
    wxLANGUAGE_CHINESE_TRADITIONAL,
    wxLANGUAGE_CHINESE_HONGKONG,
    wxLANGUAGE_CHINESE_MACAU,
    wxLANGUAGE_CHINESE_SINGAPORE,
    wxLANGUAGE_CHINESE_TAIWAN,
    wxLANGUAGE_CORSICAN,
    wxLANGUAGE_CROATIAN,
    wxLANGUAGE_CZECH,
    wxLANGUAGE_DANISH,
    wxLANGUAGE_DUTCH,
    wxLANGUAGE_DUTCH_BELGIAN,
    wxLANGUAGE_ENGLISH,
    wxLANGUAGE_ENGLISH_UK,
    wxLANGUAGE_ENGLISH_US,
    wxLANGUAGE_ENGLISH_AUSTRALIA,
    wxLANGUAGE_ENGLISH_BELIZE,
    wxLANGUAGE_ENGLISH_BOTSWANA,
    wxLANGUAGE_ENGLISH_CANADA,
    wxLANGUAGE_ENGLISH_CARIBBEAN,
    wxLANGUAGE_ENGLISH_DENMARK,
    wxLANGUAGE_ENGLISH_EIRE,
    wxLANGUAGE_ENGLISH_JAMAICA,
    wxLANGUAGE_ENGLISH_NEW_ZEALAND,
    wxLANGUAGE_ENGLISH_PHILIPPINES,
    wxLANGUAGE_ENGLISH_SOUTH_AFRICA,
    wxLANGUAGE_ENGLISH_TRINIDAD,
    wxLANGUAGE_ENGLISH_ZIMBABWE,
    wxLANGUAGE_ESPERANTO,
    wxLANGUAGE_ESTONIAN,
    wxLANGUAGE_FAEROESE,
    wxLANGUAGE_FARSI,
    wxLANGUAGE_FIJI,
    wxLANGUAGE_FINNISH,
    wxLANGUAGE_FRENCH,
    wxLANGUAGE_FRENCH_BELGIAN,
    wxLANGUAGE_FRENCH_CANADIAN,
    wxLANGUAGE_FRENCH_LUXEMBOURG,
    wxLANGUAGE_FRENCH_MONACO,
    wxLANGUAGE_FRENCH_SWISS,
    wxLANGUAGE_FRISIAN,
    wxLANGUAGE_GALICIAN,
    wxLANGUAGE_GEORGIAN,
    wxLANGUAGE_GERMAN,
    wxLANGUAGE_GERMAN_AUSTRIAN,
    wxLANGUAGE_GERMAN_BELGIUM,
    wxLANGUAGE_GERMAN_LIECHTENSTEIN,
    wxLANGUAGE_GERMAN_LUXEMBOURG,
    wxLANGUAGE_GERMAN_SWISS,
    wxLANGUAGE_GREEK,
    wxLANGUAGE_GREENLANDIC,
    wxLANGUAGE_GUARANI,
    wxLANGUAGE_GUJARATI,
    wxLANGUAGE_HAUSA,
    wxLANGUAGE_HEBREW,
    wxLANGUAGE_HINDI,
    wxLANGUAGE_HUNGARIAN,
    wxLANGUAGE_ICELANDIC,
    wxLANGUAGE_INDONESIAN,
    wxLANGUAGE_INTERLINGUA,
    wxLANGUAGE_INTERLINGUE,
    wxLANGUAGE_INUKTITUT,
    wxLANGUAGE_INUPIAK,
    wxLANGUAGE_IRISH,
    wxLANGUAGE_ITALIAN,
    wxLANGUAGE_ITALIAN_SWISS,
    wxLANGUAGE_JAPANESE,
    wxLANGUAGE_JAVANESE,
    wxLANGUAGE_KANNADA,
    wxLANGUAGE_KASHMIRI,
    wxLANGUAGE_KASHMIRI_INDIA,
    wxLANGUAGE_KAZAKH,
    wxLANGUAGE_KERNEWEK,
    wxLANGUAGE_KINYARWANDA,
    wxLANGUAGE_KIRGHIZ,
    wxLANGUAGE_KIRUNDI,
    wxLANGUAGE_KONKANI,
    wxLANGUAGE_KOREAN,
    wxLANGUAGE_KURDISH,
    wxLANGUAGE_LAOTHIAN,
    wxLANGUAGE_LATIN,
    wxLANGUAGE_LATVIAN,
    wxLANGUAGE_LINGALA,
    wxLANGUAGE_LITHUANIAN,
    wxLANGUAGE_MACEDONIAN,
    wxLANGUAGE_MALAGASY,
    wxLANGUAGE_MALAY,
    wxLANGUAGE_MALAYALAM,
    wxLANGUAGE_MALAY_BRUNEI_DARUSSALAM,
    wxLANGUAGE_MALAY_MALAYSIA,
    wxLANGUAGE_MALTESE,
    wxLANGUAGE_MANIPURI,
    wxLANGUAGE_MAORI,
    wxLANGUAGE_MARATHI,
    wxLANGUAGE_MOLDAVIAN,
    wxLANGUAGE_MONGOLIAN,
    wxLANGUAGE_NAURU,
    wxLANGUAGE_NEPALI,
    wxLANGUAGE_NEPALI_INDIA,
    wxLANGUAGE_NORWEGIAN_BOKMAL,
    wxLANGUAGE_NORWEGIAN_NYNORSK,
    wxLANGUAGE_OCCITAN,
    wxLANGUAGE_ORIYA,
    wxLANGUAGE_OROMO,
    wxLANGUAGE_PASHTO,
    wxLANGUAGE_POLISH,
    wxLANGUAGE_PORTUGUESE,
    wxLANGUAGE_PORTUGUESE_BRAZILIAN,
    wxLANGUAGE_PUNJABI,
    wxLANGUAGE_QUECHUA,
    wxLANGUAGE_RHAETO_ROMANCE,
    wxLANGUAGE_ROMANIAN,
    wxLANGUAGE_RUSSIAN,
    wxLANGUAGE_RUSSIAN_UKRAINE,
    wxLANGUAGE_SAMOAN,
    wxLANGUAGE_SANGHO,
    wxLANGUAGE_SANSKRIT,
    wxLANGUAGE_SCOTS_GAELIC,
    wxLANGUAGE_SERBIAN,
    wxLANGUAGE_SERBIAN_CYRILLIC,
    wxLANGUAGE_SERBIAN_LATIN,
    wxLANGUAGE_SERBO_CROATIAN,
    wxLANGUAGE_SESOTHO,
    wxLANGUAGE_SETSWANA,
    wxLANGUAGE_SHONA,
    wxLANGUAGE_SINDHI,
    wxLANGUAGE_SINHALESE,
    wxLANGUAGE_SISWATI,
    wxLANGUAGE_SLOVAK,
    wxLANGUAGE_SLOVENIAN,
    wxLANGUAGE_SOMALI,
    wxLANGUAGE_SPANISH,
    wxLANGUAGE_SPANISH_ARGENTINA,
    wxLANGUAGE_SPANISH_BOLIVIA,
    wxLANGUAGE_SPANISH_CHILE,
    wxLANGUAGE_SPANISH_COLOMBIA,
    wxLANGUAGE_SPANISH_COSTA_RICA,
    wxLANGUAGE_SPANISH_DOMINICAN_REPUBLIC,
    wxLANGUAGE_SPANISH_ECUADOR,
    wxLANGUAGE_SPANISH_EL_SALVADOR,
    wxLANGUAGE_SPANISH_GUATEMALA,
    wxLANGUAGE_SPANISH_HONDURAS,
    wxLANGUAGE_SPANISH_MEXICAN,
    wxLANGUAGE_SPANISH_MODERN,
    wxLANGUAGE_SPANISH_NICARAGUA,
    wxLANGUAGE_SPANISH_PANAMA,
    wxLANGUAGE_SPANISH_PARAGUAY,
    wxLANGUAGE_SPANISH_PERU,
    wxLANGUAGE_SPANISH_PUERTO_RICO,
    wxLANGUAGE_SPANISH_URUGUAY,
    wxLANGUAGE_SPANISH_US,
    wxLANGUAGE_SPANISH_VENEZUELA,
    wxLANGUAGE_SUNDANESE,
    wxLANGUAGE_SWAHILI,
    wxLANGUAGE_SWEDISH,
    wxLANGUAGE_SWEDISH_FINLAND,
    wxLANGUAGE_TAGALOG,
    wxLANGUAGE_TAJIK,
    wxLANGUAGE_TAMIL,
    wxLANGUAGE_TATAR,
    wxLANGUAGE_TELUGU,
    wxLANGUAGE_THAI,
    wxLANGUAGE_TIBETAN,
    wxLANGUAGE_TIGRINYA,
    wxLANGUAGE_TONGA,
    wxLANGUAGE_TSONGA,
    wxLANGUAGE_TURKISH,
    wxLANGUAGE_TURKMEN,
    wxLANGUAGE_TWI,
    wxLANGUAGE_UIGHUR,
    wxLANGUAGE_UKRAINIAN,
    wxLANGUAGE_URDU,
    wxLANGUAGE_URDU_INDIA,
    wxLANGUAGE_URDU_PAKISTAN,
    wxLANGUAGE_UZBEK,
    wxLANGUAGE_UZBEK_CYRILLIC,
    wxLANGUAGE_UZBEK_LATIN,
    wxLANGUAGE_VIETNAMESE,
    wxLANGUAGE_VOLAPUK,
    wxLANGUAGE_WELSH,
    wxLANGUAGE_WOLOF,
    wxLANGUAGE_XHOSA,
    wxLANGUAGE_YIDDISH,
    wxLANGUAGE_YORUBA,
    wxLANGUAGE_ZHUANG,
    wxLANGUAGE_ZULU,

    // for custom, user-defined languages:
    wxLANGUAGE_USER_DEFINED
%endenum

%enum wxFontEncoding
    wxFONTENCODING_SYSTEM           // system default
    wxFONTENCODING_DEFAULT         // current default encoding

    // ISO8859 standard defines a number of single-byte charsets
    wxFONTENCODING_ISO8859_1       // West European (Latin1)
    wxFONTENCODING_ISO8859_2       // Central and East European (Latin2)
    wxFONTENCODING_ISO8859_3       // Esperanto (Latin3)
    wxFONTENCODING_ISO8859_4       // Baltic (old) (Latin4)
    wxFONTENCODING_ISO8859_5       // Cyrillic
    wxFONTENCODING_ISO8859_6       // Arabic
    wxFONTENCODING_ISO8859_7       // Greek
    wxFONTENCODING_ISO8859_8       // Hebrew
    wxFONTENCODING_ISO8859_9       // Turkish (Latin5)
    wxFONTENCODING_ISO8859_10      // Variation of Latin4 (Latin6)
    wxFONTENCODING_ISO8859_11      // Thai
    wxFONTENCODING_ISO8859_12      // doesn't exist currently, but put it
                                    // here anyhow to make all ISO8859
                                    // consecutive numbers
    wxFONTENCODING_ISO8859_13      // Baltic (Latin7)
    wxFONTENCODING_ISO8859_14      // Latin8
    wxFONTENCODING_ISO8859_15      // Latin9 (a.k.a. Latin0, includes euro)
    wxFONTENCODING_ISO8859_MAX

    // Cyrillic charset soup (see http://czyborra.com/charsets/cyrillic.html)
    wxFONTENCODING_KOI8            // KOI8 Russian
    wxFONTENCODING_KOI8_U          // KOI8 Ukrainian
    wxFONTENCODING_ALTERNATIVE     // same as MS-DOS CP866
    wxFONTENCODING_BULGARIAN       // used under Linux in Bulgaria

    // what would we do without Microsoft? They have their own encodings
        // for DOS
    wxFONTENCODING_CP437           // original MS-DOS codepage
    wxFONTENCODING_CP850           // CP437 merged with Latin1
    wxFONTENCODING_CP852           // CP437 merged with Latin2
    wxFONTENCODING_CP855           // another cyrillic encoding
    wxFONTENCODING_CP866           // and another one
        // and for Windows
    wxFONTENCODING_CP874           // WinThai
    wxFONTENCODING_CP932           // Japanese (shift-JIS)
    wxFONTENCODING_CP936           // Chinese simplified (GB)
    wxFONTENCODING_CP949           // Korean (Hangul charset)
    wxFONTENCODING_CP950           // Chinese (traditional - Big5)
    wxFONTENCODING_CP1250          // WinLatin2
    wxFONTENCODING_CP1251          // WinCyrillic
    wxFONTENCODING_CP1252          // WinLatin1
    wxFONTENCODING_CP1253          // WinGreek (8859-7)
    wxFONTENCODING_CP1254          // WinTurkish
    wxFONTENCODING_CP1255          // WinHebrew
    wxFONTENCODING_CP1256          // WinArabic
    wxFONTENCODING_CP1257          // WinBaltic (same as Latin 7)
    wxFONTENCODING_CP12_MAX

    wxFONTENCODING_UTF7            // UTF-7 Unicode encoding
    wxFONTENCODING_UTF8            // UTF-8 Unicode encoding
    wxFONTENCODING_EUC_JP          // Extended Unix Codepage for Japanese
    wxFONTENCODING_UTF16BE         // UTF-16 Big Endian Unicode encoding
    wxFONTENCODING_UTF16LE         // UTF-16 Little Endian Unicode encoding
    wxFONTENCODING_UTF32BE         // UTF-32 Big Endian Unicode encoding
    wxFONTENCODING_UTF32LE         // UTF-32 Little Endian Unicode encoding

    wxFONTENCODING_MACROMAN        // the standard mac encodings
    wxFONTENCODING_MACJAPANESE
    wxFONTENCODING_MACCHINESETRAD
    wxFONTENCODING_MACKOREAN
    wxFONTENCODING_MACARABIC
    wxFONTENCODING_MACHEBREW
    wxFONTENCODING_MACGREEK
    wxFONTENCODING_MACCYRILLIC
    wxFONTENCODING_MACDEVANAGARI
    wxFONTENCODING_MACGURMUKHI
    wxFONTENCODING_MACGUJARATI
    wxFONTENCODING_MACORIYA
    wxFONTENCODING_MACBENGALI
    wxFONTENCODING_MACTAMIL
    wxFONTENCODING_MACTELUGU
    wxFONTENCODING_MACKANNADA
    wxFONTENCODING_MACMALAJALAM
    wxFONTENCODING_MACSINHALESE
    wxFONTENCODING_MACBURMESE
    wxFONTENCODING_MACKHMER
    wxFONTENCODING_MACTHAI
    wxFONTENCODING_MACLAOTIAN
    wxFONTENCODING_MACGEORGIAN
    wxFONTENCODING_MACARMENIAN
    wxFONTENCODING_MACCHINESESIMP
    wxFONTENCODING_MACTIBETAN
    wxFONTENCODING_MACMONGOLIAN
    wxFONTENCODING_MACETHIOPIC
    wxFONTENCODING_MACCENTRALEUR
    wxFONTENCODING_MACVIATNAMESE
    wxFONTENCODING_MACARABICEXT
    wxFONTENCODING_MACSYMBOL
    wxFONTENCODING_MACDINGBATS
    wxFONTENCODING_MACTURKISH
    wxFONTENCODING_MACCROATIAN
    wxFONTENCODING_MACICELANDIC
    wxFONTENCODING_MACROMANIAN
    wxFONTENCODING_MACCELTIC
    wxFONTENCODING_MACGAELIC
    wxFONTENCODING_MACKEYBOARD

    wxFONTENCODING_MAX             // highest enumerated encoding value

    wxFONTENCODING_MACMIN //= wxFONTENCODING_MACROMAN ,
    wxFONTENCODING_MACMAX //= wxFONTENCODING_MACKEYBOARD ,

    // aliases for endian-dependent UTF encodings
    wxFONTENCODING_UTF16   // native UTF-16
    wxFONTENCODING_UTF32   // native UTF-32

    // alias for the native Unicode encoding on this platform
    // (this is used by wxEncodingConverter and wxUTFFile only for now)
    wxFONTENCODING_UNICODE

    // alternative names for Far Eastern encodings
        // Chinese
    wxFONTENCODING_GB2312  // Simplified Chinese
    wxFONTENCODING_BIG5    // Traditional Chinese

        // Japanese (see http://zsigri.tripod.com/fontboard/cjk/jis.html)
    wxFONTENCODING_SHIFT_JIS // Shift JIS
%endenum

%enum wxLocaleCategory
    wxLOCALE_CAT_NUMBER,    // (any) numbers
    wxLOCALE_CAT_DATE,      // date/time
    wxLOCALE_CAT_MONEY,     // monetary value
    wxLOCALE_CAT_MAX
%endenum

%enum wxLocaleInfo
    wxLOCALE_THOUSANDS_SEP, // the thounsands separator
    wxLOCALE_DECIMAL_POINT  // the character used as decimal point
%endenum

%enum wxLocaleInitFlags
    wxLOCALE_LOAD_DEFAULT       // load wxwin.mo?
    wxLOCALE_CONV_ENCODING      // convert encoding on the fly?
%endenum

%if %wxchkver_2_8
%enum wxLayoutDirection
    wxLayout_Default
    wxLayout_LeftToRight
    wxLayout_RightToLeft
%endenum
%endif %wxchkver_2_8

%struct %delete wxLanguageInfo
    wxLanguageInfo() // you must set all the values by hand

    %member int Language;                   // wxLanguage id
    %member wxString CanonicalName;         // Canonical name, e.g. fr_FR
    %member wxString Description;           // human-readable name of the language
    %wxchkver_2_8 %member wxLayoutDirection LayoutDirection;
%endstruct


%class %delete wxLocale

    // call Init() if you use this ctor
    wxLocale()

    // the ctor has a side effect of changing current locale
    // name (for messages),  dir prefix (for msg files), locale (for setlocale), preload wxstd.mo?, convert Win<->Unix if necessary?
    wxLocale(const wxString& szName, const wxString& szShort = "", const wxString& szLocale = "", bool bLoadDefault = true, bool bConvertEncoding = false)

    // wxLanguage id or custom language
    wxLocale(int language, int flags = wxLOCALE_LOAD_DEFAULT | wxLOCALE_CONV_ENCODING)

    // the same as a function (returns true on success)
    //bool Init(const wxChar *szName, const wxChar *szShort = (const wxChar *) NULL, const wxChar *szLocale = (const wxChar *) NULL, bool bLoadDefault = true, bool bConvertEncoding = false)
    bool Init(const wxString &szName, const wxString &szShort = "", const wxString &szLocale = "", bool bLoadDefault = true, bool bConvertEncoding = false)

    // same as second ctor (returns true on success)
    bool Init(int language = wxLANGUAGE_DEFAULT, int flags = wxLOCALE_LOAD_DEFAULT | wxLOCALE_CONV_ENCODING);

    // Try to get user's (or OS's) preferred language setting.
    // Return wxLANGUAGE_UNKNOWN if language-guessing algorithm failed
    static int GetSystemLanguage()

    // get the encoding used by default for text on this system, returns
    // wxFONTENCODING_SYSTEM if it couldn't be determined
    static wxFontEncoding GetSystemEncoding();

    // get the string describing the system encoding, return empty string if
    // couldn't be determined
    static wxString GetSystemEncodingName();

    // get the values of the given locale-dependent datum: the current locale
    // is used, the US default value is returned if everything else fails
    static wxString GetInfo(wxLocaleInfo index, wxLocaleCategory cat);

    // return true if the locale was set successfully
    bool IsOk() const

    // returns locale name
    wxString GetLocale() const

    // return current locale wxLanguage value
    int GetLanguage() const

    // return locale name to be passed to setlocale()
    wxString GetSysName() const;

    // return 'canonical' name, i.e. in the form of xx[_YY], where xx is
    // language code according to ISO 639 and YY is country name
    // as specified by ISO 3166.
    wxString GetCanonicalName() const

    // add a prefix to the catalog lookup path: the message catalog files will be
    // looked up under prefix/<lang>/LC_MESSAGES, prefix/LC_MESSAGES and prefix
    // (in this order).
    //
    // This only applies to subsequent invocations of AddCatalog()!
    static void AddCatalogLookupPathPrefix(const wxString& prefix);

    // add a catalog: it's searched for in standard places (current directory
    // first, system one after), but the you may prepend additional directories to
    // the search path with AddCatalogLookupPathPrefix().
    //
    // The loaded catalog will be used for message lookup by GetString().
    //
    // Returns 'true' if it was successfully loaded
    bool AddCatalog(const wxString& szDomain);
    bool AddCatalog(const wxString& szDomain, wxLanguage msgIdLanguage, const wxString& msgIdCharset);

    // check if the given locale is provided by OS and C run time
    %wxchkver_2_8 static bool IsAvailable(int lang);

    // check if the given catalog is loaded
    bool IsLoaded(const wxString& szDomain) const;

    // Retrieve the language info struct for the given language
    //
    // Returns NULL if no info found, pointer must *not* be deleted by caller
    static const wxLanguageInfo *GetLanguageInfo(int lang);

    // Returns language name in English or empty string if the language
    // is not in database
    static wxString GetLanguageName(int lang);

    // Find the language for the given locale string which may be either a
    // canonical ISO 2 letter language code ("xx"), a language code followed by
    // the country code ("xx_XX") or a Windows full language name ("Xxxxx...")
    //
    // Returns NULL if no info found, pointer must *not* be deleted by caller
    static const wxLanguageInfo *FindLanguageInfo(const wxString& locale);

    // Add custom language to the list of known languages.
    // Notes: 1) wxLanguageInfo contains platform-specific data
    //        2) must be called before Init to have effect
    static void AddLanguage(const wxLanguageInfo& info);

    // retrieve the translation for a string in all loaded domains unless
    // the szDomain parameter is specified (and then only this domain is
    // searched)
    // n - additional parameter for PluralFormsParser
    //
    // return original string if translation is not available
    // (in this case an error message is generated the first time
    //  a string is not found; use wxLogNull to suppress it)
    //
    // domains are searched in the last to first order, i.e. catalogs
    // added later override those added before.
    virtual wxString GetString(const wxString& szOrigString, const wxChar* szDomain = NULL) const;
    // plural form version of the same:
    virtual wxString GetString(const wxString& szOrigString, const wxString& szOrigString2, size_t n, const wxChar* szDomain = NULL) const;

    // Returns the current short name for the locale
    const wxString& GetName() const

    // return the contents of .po file header
    wxString GetHeaderValue( const wxString& szHeader, const wxString& szDomain = "" ) const;
%endclass

%function wxLocale* wxGetLocale()

%wxchkver_2_8  %function wxString wxGetTranslation(const wxString& sz, const wxChar* domain=NULL)
!%wxchkver_2_8 %function wxString wxGetTranslation(const wxString& sz)

%wxchkver_2_8  %rename wxGetTranslationPlural %function wxString wxGetTranslation(const wxString& sz1, const wxString& sz2, size_t n, const wxChar* domain=NULL)
!%wxchkver_2_8 %rename wxGetTranslationPlural %function wxString wxGetTranslation(const wxString& sz1, const wxString& sz2, size_t n)

%endif //wxUSE_INTL
