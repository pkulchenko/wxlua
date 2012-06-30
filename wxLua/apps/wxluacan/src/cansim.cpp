/*! \file cansim.cpp
    \author Klaas Holwerda

    Copyright: 2001-2004 (C) XX

    Licence: wxWidgets Licence
*/

#include <wx/wxprec.h>

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif

// Include private headers
#include "cansim.h"

// Include icon header
#if defined(__WXGTK__) || defined(__WXMOTIF__) || defined(__WXMAC__)
    #include "art/wxluasmall.xpm"
#endif

// Declare the binding initialization functions
// Note : We could also do this "extern wxLuaBinding* wxLuaBinding_XXX_init();" and
//        later call "wxLuaBinding_XXX_init();" to initialize it.
//        However we use the macros that include #if conditions to have a
//        better chance of determining what libs are available.
// Note : Make sure you link to the binding libraries.

#include "wxbind/include/wxbinddefs.h"
WXLUA_DECLARE_BIND_STD
extern wxLuaBinding* wxLuaBinding_wxluacan_init();

//------------------------------------------------------------------------------
// MyFrame
//------------------------------------------------------------------------------
IMPLEMENT_APP(MyApp)

wxlCan* mainCan;
wxlCan* GetCan() { return mainCan; }
wxlLuaCanCmd* GetCmdhMain() { return mainCan->GetCmdh(); }

BEGIN_EVENT_TABLE(MyFrame,wxFrame)
    EVT_CLOSE(MyFrame::OnCloseWindow)
    EVT_TIMER(wxID_ANY, MyFrame::OnTimer)

    EVT_MENU_RANGE(MenuOption_First, MenuOption_Last, MyFrame::OnOption)
    EVT_MENU( lua_script, MyFrame::OnRunScript)
    EVT_MENU( wxID_UNDO, MyFrame::OnUndo)
    EVT_MENU( wxID_REDO, MyFrame::OnRedo)
    EVT_MENU( wxID_EXIT, MyFrame::OnQuit)

    EVT_LUA_PRINT       (wxID_ANY, MyFrame::OnLua)
    EVT_LUA_ERROR       (wxID_ANY, MyFrame::OnLua)
    EVT_LUA_DEBUG_HOOK  (wxID_ANY, MyFrame::OnLua)
END_EVENT_TABLE()

MyFrame::MyFrame( wxWindow *parent, wxWindowID id, const wxString &title,
    const wxPoint &position, const wxSize& size, long style ) :
    wxFrame( parent, id, title, position, size, style )
{
    m_xScale = 1.0;
    m_yScale = 1.0;
    m_xOrigin = 0;
    m_yOrigin = 0;
    m_yAxisReversed = true;

    CreateMyMenuBar();

    CreateStatusBar(1);
    SetStatusText( _T("Welcome to a2dCanvas sample!") );

    SetIcon(wxICON(wxLuaSmall));

    m_interp = wxLuaState(this, wxID_ANY);

    //default 1000,1000 mapping
    mainCan = m_canvas = new wxlCan( this, wxID_ANY, wxPoint(0,0), wxSize(10,10) );
    m_canvas->SetLuaState( &m_interp );

    m_canvas->GetCmdh()->SetEditMenu( m_menuObjects );

    //! set virtual size in pixels, this independent of the mapping below
    m_canvas->SetVirtualSize( 1000, 1000 );
    m_canvas->SetScrollRate( 50, 50 );
    m_canvas->SetBackgroundColour( wxColour(223, 234, 251) );
    m_canvas->SetBackgroundBrush( wxBrush( wxColour(30, 174, 171), wxCROSS_HATCH ) );
    m_canvas->SetYaxis( false ); //true );

    //defines the minimum x and y to show and the number of world units per pixel in x and y
    m_canvas->SetMappingUpp( m_xOrigin, m_yOrigin, m_xScale, m_yScale );

    // Add some initial objects to the canvas
    wxlCanObjRect* rect = new wxlCanObjRect( 170, 170,200, -120 );
    rect->SetPen(*wxGREEN_PEN);
    rect->SetBrush( wxBrush( wxColour(70, 124, 71) ) );
    m_canvas->AddObject( rect );

    wxlCanObjCircle* circs = new wxlCanObjCircle( 0, 0, 20 );
    circs->SetPen(*wxBLACK_PEN);
    circs->SetBrush( wxBrush( wxColour( 30,174,71) ) );
    rect->AddObject( circs );

    wxlCanObjCircle* circ = new wxlCanObjCircle( 140, 160,100 );
    circ->SetPen(*wxRED_PEN);
    circ->SetBrush( wxBrush( wxColour( 30,74,71), wxFDIAGONAL_HATCH ) );
    m_canvas->AddObject( circ );

    m_timer = new wxTimer( this );
    m_timer->Start( 80, false );
}

MyFrame::~MyFrame()
{
    delete m_timer;
}

void MyFrame::CreateMyMenuBar()
{
    wxMenu *file_menu = new wxMenu;
    file_menu->Append( wxID_EXIT, _T("Quit..."), _T("Quit program") );

    wxMenu *menuMap = new wxMenu;
    menuMap->Append( Scale_StretchHoriz, _T("Stretch &horizontally\tCtrl-H") );
    menuMap->Append( Scale_ShrinkHoriz, _T("Shrin&k horizontally\tCtrl-G") );
    menuMap->Append( Scale_StretchVertic, _T("Stretch &vertically\tCtrl-V") );
    menuMap->Append( Scale_ShrinkVertic, _T("&Shrink vertically\tCtrl-W") );
    menuMap->AppendSeparator();
    menuMap->Append( Map_Restore, _T("&Restore to normal\tCtrl-0") );

    wxMenu *menuAxis = new wxMenu;
    menuAxis->Append( Axis_Vertic, _T("Mirror vertically\tCtrl-N"), _T(""), true );

    wxMenu *menuLogical = new wxMenu;
    menuLogical->Append( Origin_MoveDown, _T("Move &down\tCtrl-D") );
    menuLogical->Append( Origin_MoveUp, _T("Move &up\tCtrl-U") );
    menuLogical->Append( Origin_MoveLeft, _T("Move &right\tCtrl-L") );
    menuLogical->Append( Origin_MoveRight, _T("Move &left\tCtrl-R") );
    menuLogical->AppendSeparator();

    m_menuObjects = new wxMenu;
    m_menuObjects->Append( Object_AddRect, _T("Add rectangle") );
    m_menuObjects->Append( Object_AddCircle, _T("Add circle") );
    m_menuObjects->Append( lua_script, _T("Run Script...") );

    m_menuObjects->AppendSeparator();
    m_menuObjects->Append(wxID_UNDO, _T("&Undo"));
    m_menuObjects->Append(wxID_REDO, _T("&Redo"));


    // now append the freshly created menu to the menu bar...
    wxMenuBar *menuBar = new wxMenuBar();
    menuBar->Append( file_menu, _T("File") );
    menuBar->Append(menuMap, _T("&Mapping"));
    menuBar->Append(menuAxis, _T("&Axis"));
    menuBar->Append(menuLogical, _T("&Origin"));
    menuBar->Append(m_menuObjects, _T("&ModifyObjects"));
    SetMenuBar( menuBar );
}

void MyFrame::OnUndo(wxCommandEvent& )
{
    m_canvas->GetCmdh()->Undo();
}

void MyFrame::OnRedo(wxCommandEvent& )
{
    m_canvas->GetCmdh()->Redo();
}

void MyFrame::OnQuit( wxCommandEvent & )
{
    Close( true );
}

void MyFrame::OnCloseWindow( wxCloseEvent & )
{
    Destroy();
}

void MyFrame::OnTimer( wxTimerEvent & )
{
    wxWakeUpIdle();
}

void MyFrame::OnOption(wxCommandEvent& event)
{
    switch (event.GetId())
    {
        case Origin_MoveDown:
            m_yOrigin += 10;
            break;
        case Origin_MoveUp:
            m_yOrigin -= 10;
            break;
        case Origin_MoveLeft:
            m_xOrigin += 10;
            break;
        case Origin_MoveRight:
            m_xOrigin -= 10;
            break;

        case Scale_StretchHoriz:
            m_xScale *= 1.10;
            break;
        case Scale_ShrinkHoriz:
            m_xScale /= 1.10;
            break;
        case Scale_StretchVertic:
            m_yScale *= 1.10;
            break;
        case Scale_ShrinkVertic:
            m_yScale /= 1.10;
            break;
        case Map_Restore:
            m_xScale =
            m_yScale = 1.0;
            m_xOrigin =
            m_yOrigin = 0;
            break;

        case Axis_Vertic:
            m_yAxisReversed = !m_yAxisReversed;
            m_canvas->SetYaxis(m_yAxisReversed);
            break;

        case Object_AddRect:
        {
            wxlCanObjRect* rect = new wxlCanObjRect( 170, 170,100, 50 );
            rect->SetPen(*wxGREEN_PEN);
            rect->SetBrush( wxBrush( wxColour( 70, 124,171) ) );
            m_canvas->AddObject( rect );
            m_canvas->GetCmdh()->MoveObject( -1, 100,100 );

            break;
        }
        case Object_AddCircle:
        {
            wxlCanObjCircle* circ = new wxlCanObjCircle( 140, 160,50 );
            circ->SetPen(*wxGREEN_PEN);
            circ->SetBrush( wxBrush( wxColour(130,74,71), wxCROSSDIAG_HATCH  ) );
            m_canvas->AddObject( circ );
            m_canvas->GetCmdh()->MoveObject( -1, 100,100 );


            break;
        }
        default:
            // skip Refresh()
            return;
    }
    m_canvas->SetMappingUpp( m_xOrigin, m_yOrigin, m_xScale, m_yScale );

    m_canvas->Refresh();
}


void MyFrame::OnRunScript(wxCommandEvent& )
{
    wxString fullPath = wxFileSelector( _("Select a script file"),
                                        _(""),
                                        _(""),
                                        _("lua"),
                                        _("*.lua") ,
                                        0,
                                        this
                                        );

    if ( !fullPath.IsEmpty() && ::wxFileExists( fullPath ) )
    {
        if ( 0 != m_interp.RunFile( fullPath ) )
        {
            wxLogWarning( _("Error in Lua Script") );
        }
    }
}

void MyFrame::OnLua( wxLuaEvent &event )
{
    if (event.GetEventType() == wxEVT_LUA_PRINT)
    {
        wxMessageBox(event.GetString(), wxT("maskpro"));
    }
    else if (event.GetEventType() == wxEVT_LUA_ERROR)
    {
        wxMessageBox(event.GetString(), wxT("maskpro"));
    }
}

//------------------------------------------------------------------------------
// MyApp
//------------------------------------------------------------------------------

MyApp::MyApp() : m_frame(NULL)
{
}

bool MyApp::OnInit()
{
    // Initialize the wxLua bindings we want to use.
    // See notes for WXLUA_DECLARE_BIND_STD above.
    WXLUA_IMPLEMENT_BIND_STD
    wxLuaBinding_wxluacan_init();

    m_frame = new MyFrame( NULL, wxID_ANY, _T("LuaCan"), wxPoint(20,30), wxSize(600,440) );
    m_frame->Show( true );

    return true;
}

int MyApp::OnExit()
{
    return 0;
}
