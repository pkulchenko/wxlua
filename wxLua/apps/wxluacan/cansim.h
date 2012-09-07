/*! \file canvas/samples/cansim/cansim.h
    \author Klaas Holwerda

    Copyright: 2001-2004 (C) XX

    Licence: wxWidgets Licence
*/

#ifndef __simplecan_H__
#define __simplecan_H__

// Include wxWindows' headers

#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif

#include "canlua.h"
#include "cancom.h"
#include <wx/timer.h>
#include "wxlua/include/wxlstate.h"

//----------------------------------------------------------------------------
//   constants
//----------------------------------------------------------------------------

// IDs the menu commands
enum
{
    MenuOption_First = 1,
    Scale_StretchHoriz = MenuOption_First,
    Scale_ShrinkHoriz,
    Scale_StretchVertic,
    Scale_ShrinkVertic,
    Origin_MoveDown,
    Origin_MoveUp,
    Origin_MoveLeft,
    Origin_MoveRight,
    Object_AddRect,
    Object_AddCircle,
    Axis_Vertic,
    Map_Restore,
    MenuOption_Last = Map_Restore,
    lua_script
};

//----------------------------------------------------------------------------
// MyFrame
//----------------------------------------------------------------------------

class MyFrame: public wxFrame
{
public:
    // constructors and destructors
    MyFrame( wxWindow *parent, wxWindowID id, const wxString &title,
        const wxPoint& pos = wxDefaultPosition,
        const wxSize& size = wxDefaultSize,
        long style = wxDEFAULT_FRAME_STYLE );
    ~MyFrame();

    wxMenu *m_menuObjects;

private:

    // method declarations for MyFrame
    void CreateMyMenuBar();

private:

    // member variable declarations for MyFrame

    wxlCan    *m_canvas;

    wxTimer   *m_timer;

    wxLuaState m_interp;

private:


    void OnUndo(wxCommandEvent& event);
    void OnRedo(wxCommandEvent& event);

    // handler declarations for MyFrame
    void OnQuit( wxCommandEvent &event );
    void OnCloseWindow( wxCloseEvent &event );
    void OnTimer( wxTimerEvent &event );

    void OnOption(wxCommandEvent& event);

    void OnRunScript(wxCommandEvent& event);
    void OnLua( wxLuaEvent &event );

    double      m_xScale;
    double      m_yScale;
    double      m_xOrigin;
    double      m_yOrigin;
    bool        m_yAxisReversed;

private:
    DECLARE_EVENT_TABLE()
};

extern wxlCan* mainCan;
extern wxlCan* GetCan();
extern wxlLuaCanCmd* GetCmdhMain();


//----------------------------------------------------------------------------
// MyApp
//----------------------------------------------------------------------------

class MyApp: public wxApp
{
public:

    MyApp();

    virtual bool OnInit();
    virtual int OnExit();

    MyFrame *m_frame;
};

#endif
