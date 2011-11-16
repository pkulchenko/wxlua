/*! \file canlua.cpp
    \author Klaas Holwerda

    Copyright: 2001-2004 (C) Klaas Holwerda

    Licence: wxWidgets Licence

    RCS-ID: $Id: canlua.cpp,v 1.17 2009/11/17 06:11:02 jrl1 Exp $
*/

#include "wx/wxprec.h"

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#ifndef WX_PRECOMP
    #include "wx/wx.h"
#endif

#include "canlua.h"
#include "cancom.h"
#include "wxluacan_bind.h"

#include "wx/listimpl.cpp"
WX_DEFINE_LIST(wxlCanObjList);

//------------------------------------------------------------------
//-------- wxlCanObj
//------------------------------------------------------------------

wxlCanObj::wxlCanObj( double x, double y )
{
    m_x = x;
    m_y = y;

    m_brush = wxNullBrush;
    m_pen   = wxNullPen;

    m_canvas = NULL;
}

wxlCanObj::~wxlCanObj()
{
    m_objects.DeleteContents( true );
    m_objects.Clear();
}

void wxlCanObj::AddObject( wxlCanObj *canobj )
{
    canobj->SetCanvas( m_canvas );
    m_objects.Append( canobj );
    SetPending( true );
}

wxlCanObj* wxlCanObj::GetItem( size_t index )
{
    return m_objects.Item( index )->GetData();
}

void wxlCanObj::SetPending( bool pending )
{
    m_pending = pending;
    m_canvas->SetPending( pending );
}

void wxlCanObj::Update( double absx, double absy )
{
    absx += m_x;
    absy += m_y;

    DoUpdate( absx, absy );

    // iterate over the child list
    for ( wxlCanObjList::Node *node = m_objects.GetFirst(); node; node = node->GetNext() )
    {
        wxlCanObj *obj = node->GetData();
        obj->Update( absx, absy );
    }
}

void wxlCanObj::Draw( wxDC& dc, double absx, double absy )
{
    if ( m_brush.Ok() )
        dc.SetBrush( m_brush );
    if ( m_pen.Ok() )
        dc.SetPen( m_pen );

    wxBrush currentBrush = dc.GetBrush();
    wxPen currentPen = dc.GetPen();

    absx += m_x;
    absy += m_y;

    DoDraw( dc, absx, absy );

    // iterate over the child list
    for ( wxlCanObjList::Node *node = m_objects.GetFirst(); node; node = node->GetNext() )
    {
        wxlCanObj *drawobj = node->GetData();
        // restore brush and pen
        dc.SetBrush( currentBrush );
        dc.SetPen( currentPen );
        drawobj->Draw( dc , absx, absy );
    }
}

wxlCanObj* wxlCanObj::WhichIsHit( double x, double y )
{
    // iterate over the child list
    for ( wxlCanObjList::Node *node = m_objects.GetLast(); node; node = node->GetPrevious() )
    {
        wxlCanObj *drawobj = node->GetData();
        if ( drawobj->IsHit( x, y ) )
            return drawobj;
    }
    return NULL;
}

bool wxlCanObj::IsHit( double x, double y, double absx, double absy )
{
    absx += m_x;
    absy += m_y;

    if ( DoIsHit( x, y, absx, absy ) )
        return true;

    // iterate over the child list
    for ( wxlCanObjList::Node *node = m_objects.GetFirst(); node; node = node->GetNext() )
    {
        wxlCanObj *drawobj = node->GetData();
        if ( drawobj->IsHit( x, y, absx, absy ) )
            return true;
    }
    return false;
}

//------------------------------------------------------------------
//-------- wxlCanObjRect
//------------------------------------------------------------------

wxlCanObjRect::wxlCanObjRect( double x, double y, double w, double h )
    :wxlCanObj( x, y )
{
    m_w = w;
    m_h = h;
}

void wxlCanObjRect::DoDraw( wxDC& dc, double absx, double absy )
{
    dc.DrawRectangle( m_canvas->WorldToDeviceX( absx ), m_canvas->WorldToDeviceX( absy ),
                      m_canvas->WorldToDeviceXRel( m_w ), m_canvas->WorldToDeviceYRel( m_h ) );
}

bool wxlCanObjRect::DoIsHit( double x, double y, double absx, double absy )
{
    double xh,yh;
    xh = x - absx;
    yh = y - absy;

    double xmin = wxMin( 0, m_w);
    double ymin = wxMin( 0, m_h);
    double xmax = wxMax( 0, m_w);
    double ymax = wxMax( 0, m_h);

    // check if inside bounding box with positive margin
    if (
        xh < xmax &&
        yh < ymax &&
        xh > xmin &&
        yh > ymin
    )
    {
        return true;
    }
    return false;
}

//------------------------------------------------------------------
//-------- wxlCanObjCircle
//------------------------------------------------------------------

wxlCanObjCircle::wxlCanObjCircle( double x, double y, double r )
    :wxlCanObj( x, y )
{
    m_r = r;
}

void wxlCanObjCircle::DoDraw( wxDC& dc, double absx, double absy )
{
    dc.DrawCircle( m_canvas->WorldToDeviceX( absx ), m_canvas->WorldToDeviceX( absy ), m_canvas->WorldToDeviceXRel( m_r ) );
}

bool wxlCanObjCircle::DoIsHit( double x, double y, double absx, double absy )
{
    double xh,yh;
    xh = x - absx;
    yh = y - absy;

    double r = sqrt((xh*xh)+(yh*yh));

    if ( m_r > r)
    {
        return true;
    }
    return false;
}

//------------------------------------------------------------------
//-------- wxlCanObjScript
//------------------------------------------------------------------

wxlCanObjScript::wxlCanObjScript( double x, double y, const wxString& name )
    :wxlCanObj( x, y )
{
    m_objectname = name;
}

void wxlCanObjScript::DoDraw( wxDC& dc, double absx, double absy )
{
    // run all statements in the script which should be drawing statements on a wxDC
    wxLuaState lst = *(m_canvas->GetLuastate());
    lua_State* L = lst.GetLuaState();
    lua_getglobal( L, wx2lua(m_objectname + wxT("Draw")) );

    lst.wxluaT_PushUserDataType(&dc, wxluatype_wxDC, true);

    lst.lua_PushNumber( m_canvas->WorldToDeviceX( absx ) );
    lst.lua_PushNumber( m_canvas->WorldToDeviceX( absy ) );

    if ( lst.lua_PCall( 3, 0, 0 ) != 0 )
    {
        wxLuaEvent event(wxEVT_LUA_ERROR, lst.GetId(), lst);
        event.SetString(wxT("wrong draw function"));
        lst.SendEvent(event);
    }
}

bool wxlCanObjScript::DoIsHit( double x, double y, double absx, double absy )
{
    double xh,yh;
    xh = x - absx;
    yh = y - absy;

    // run all statements in the script which should be returning a hit on the object or not

    wxLuaState lst = *(m_canvas->GetLuastate());
    lua_State* L = lst.GetLuaState();

    lua_getglobal( L, wx2lua(m_objectname + wxT("Hit")) ); // push func on stack

    lst.lua_PushNumber( xh );                            // push func parameters
    lst.lua_PushNumber( yh );

    if ( lst.lua_PCall( 2, 1, 0 ) != 0 )    // call function, 2 params, 1 return
    {
        wxLuaEvent event(wxEVT_LUA_ERROR, lst.GetId(), lst);
        event.SetString(wxT("wrong hit function"));
        lst.SendEvent(event);
    }

    bool hit = lst.GetBooleanType(-1);           // get return value
    lst.lua_Pop(1);                              // pop return value from stack

    //wxLogDebug( "hit %d", hit );

    if (hit)
        return true;
    return false;
}

//------------------------------------------------------------------
//-------- wxlCanObjScript
//------------------------------------------------------------------

wxlCanObjAddScript::wxlCanObjAddScript( double x, double y, const wxString& script )
    :wxlCanObj( x, y )
{
    m_script = script;
}

void wxlCanObjAddScript::SetScript( const wxString& script )
{
    m_script = script;
    SetPending( true );
}

void wxlCanObjAddScript::DoUpdate( double absx, double absy )
{
    if ( m_pending )
    {
        wxLuaState lst = *(m_canvas->GetLuastate());
        lua_State* L = lst.GetLuaState();
        if ( 0 != lst.RunString( m_script ) )
        {
            wxLogWarning( _("Error in Lua Script") );
        }
        else
        {
            lua_getglobal( L, wx2lua( wxT("AddChilds") ) );
            lst.wxluaT_PushUserDataType(this, wxluatype_wxlCanObj, true);

            lst.lua_PushNumber( m_canvas->WorldToDeviceX( absx ) );
            lst.lua_PushNumber( m_canvas->WorldToDeviceX( absy ) );

            if ( lst.lua_PCall( 3, 0, 0 ) != 0 )
            {
                wxLuaEvent event(wxEVT_LUA_ERROR, lst.GetId(), lst);
                event.SetString(wxT("wrong AddChilds function"));
                lst.SendEvent(event);
            }
        }
        m_pending = false;
    }
}

//------------------------------------------------------------------
//-------- wxlCan
//------------------------------------------------------------------

IMPLEMENT_CLASS( wxlCan, wxScrolledWindow)

BEGIN_EVENT_TABLE( wxlCan, wxScrolledWindow)
    EVT_IDLE( wxlCan::OnIdle )
    EVT_PAINT( wxlCan::OnPaint )
    EVT_SIZE( wxlCan::OnSize )
    EVT_SCROLLWIN( wxlCan::OnScroll )
    EVT_ERASE_BACKGROUND( wxlCan::OnEraseBackground )
    EVT_MOUSE_EVENTS( wxlCan::OnMouseEvent )
END_EVENT_TABLE()


wxlCan::wxlCan( wxWindow *parent, wxWindowID id, const wxPoint& pos, const wxSize& size, long style ):
    wxScrolledWindow( parent, id, pos, size, style )
{
    m_luastate = NULL;

    int w,h;

    GetVirtualSize( &w, &h );

    m_buffer = wxBitmap( size.GetWidth(), size.GetHeight() );
    m_pendingObjects = false;

    //set one to one mapping as default
    m_xpp = 1;
    m_ypp = 1;

    m_virt_minX = 0;
    m_virt_minY = 0;

    m_transx = 0;
    m_transy = 0;

    m_scalex = 1;
    m_scaley = 1;

    m_rootobject.SetCanvas( this );

    m_hit = NULL;

    m_cmdh = new wxlLuaCanCmd( this );
}


wxlCan::~wxlCan()
{
    delete m_cmdh;
}

void wxlCan::OnEraseBackground(wxEraseEvent& WXUNUSED(event) )
{
    //event.Skip();
}

void wxlCan::SetBackgroundBrush( const wxBrush& brush )
{
    m_backbrush = brush;
    m_pendingObjects = true;
}

void wxlCan::SetYaxis(bool up)
{
    m_yaxis = up;
    SetMappingUpp( m_virt_minX, m_virt_minY, m_xpp, m_ypp );
}

// maps the virtual window (Real drawing to the window coordinates
// also used for zooming
void wxlCan::SetMappingUpp( double vx1, double vy1, double xpp, double ypp )
{
    //double wx = m_buffer.GetWidth();
    double wy = m_buffer.GetHeight();

    m_xpp = xpp;
    m_ypp = ypp;

    m_virt_minX = vx1;
    m_virt_minY = vy1;

    // initialize the mapping used for mapping the
    // virtual window to the pixel window

    // translate the drawing to 0,0
    if (m_yaxis)
    {
        double virt_maxY = m_virt_minY + wy*m_ypp;
        m_transx = -m_virt_minX;
        m_transy = -virt_maxY  ;
    }
    else
    {
        m_transx = -m_virt_minX;
        m_transy = -m_virt_minY;
    }

    // scale the drawing so that one pixel is the right number of units
    m_scalex = 1/m_xpp;
    m_scaley = 1/m_ypp;
    m_transx = m_transx*m_scalex;
    m_transy = m_transy*m_scaley;

    // because of coordinate change mirror over X
    // 0,0 in graphic computerscreens: upperleft corner
    // 0,0 in cartesian: lowerleft corner
    if (m_yaxis)
    {
        m_scaley = -m_scaley;
        m_transy = -m_transy;
    }

    m_pendingObjects = true;
    Refresh();

}

void wxlCan::OnMouseEvent(wxMouseEvent& event)
{
    wxPoint pos = event.GetPosition();
    int xx, yy;
    CalcUnscrolledPosition( pos.x, pos.y, &xx, &yy );

    double mouse_worldx = DeviceToWorldX( xx );
    double mouse_worldy = DeviceToWorldY( yy );

    wxString str;
    str.Printf( _T("%6.3f,%6.3f"), mouse_worldx, mouse_worldy );

    ((wxFrame*)m_parent)->SetStatusText( str );

    if ( event.Moving() && !m_hit )
    {
        wxlCanObj* hit = m_rootobject.WhichIsHit( mouse_worldx, mouse_worldy );
        if ( hit )
            SetCursor( wxCURSOR_HAND );
        else
            SetCursor( wxCURSOR_ARROW );
    }

    if ( event.LeftDown() )
    {
        m_hit = m_rootobject.WhichIsHit( mouse_worldx, mouse_worldy );
        if ( m_hit )
        {
            CaptureMouse();
            m_startMouseX = mouse_worldx;
            m_startMouseY = mouse_worldy;
            m_startObjX = m_hit->GetX();
            m_startObjY = m_hit->GetY();
        }
    }
    else if ( event.Dragging() && m_hit )
    {
        m_hit->SetPos( m_startObjX + mouse_worldx - m_startMouseX, m_startObjY + mouse_worldy - m_startMouseY );
    }
    else if (event.LeftUp() && m_hit )
    {
        m_hit->SetPos( m_startObjX, m_startObjY);
        m_cmdh->Submit( new wxlMoveObjectCmd( m_hit,  m_startObjX + mouse_worldx - m_startMouseX, m_startObjY + mouse_worldy - m_startMouseY  ) );
        ReleaseMouse();
        m_hit = NULL;
    }
}

void wxlCan::OnIdle(wxIdleEvent &event)
{
    if ( m_pendingObjects )
    {
        m_rootobject.Update( 0, 0 );

        // we will now render all objects stored in the canvas to a bitmap
        wxMemoryDC mdc;
        mdc.SelectObject( m_buffer );

        //draw object into buffer
        Render( mdc );

        mdc.SelectObject( wxNullBitmap );

        // force a repaint in OnPaint()
        Refresh();

        m_pendingObjects = false;
    }
    event.Skip(); //always skip idle events
}

void wxlCan::AddObject( wxlCanObj *canobj )
{
    canobj->SetCanvas( this );
    m_rootobject.AddObject( canobj );
}

void wxlCan::SetPending( bool pending )
{
    m_pendingObjects = pending;
}

void wxlCan::Render( wxDC& dc )
{
    int w,h;
    GetVirtualSize( &w, &h );

    dc.SetBackground( GetBackgroundColour() );
    dc.Clear();

    dc.SetBrush(m_backbrush);
    dc.SetPen( *wxTRANSPARENT_PEN );
    dc.DrawRectangle( 0, 0, w, h );

    //draw objects
    m_rootobject.Draw( dc, 0, 0 );
}

void wxlCan::OnPaint(wxPaintEvent& WXUNUSED(event) )
{
    wxPaintDC dc(this);

    wxRegionIterator it( GetUpdateRegion() );
    while (it)
    {
        int x = it.GetX();
        int y = it.GetY();

        int w = it.GetWidth();
        int h = it.GetHeight();

        int xx;
        int yy;
        CalcUnscrolledPosition( x, y, &xx, &yy);

        wxMemoryDC mdc;
        mdc.SelectObject( m_buffer );

        dc.Blit( x, y, w, h, &mdc, xx, yy, wxCOPY, false );

        mdc.SelectObject( wxNullBitmap );

        it++;
    }

}

void wxlCan::OnScroll(wxScrollWinEvent& event)
{
    int dx,dy;
    GetClientSize(&dx,&dy);

    wxScrolledWindow::OnScroll( event );

    m_pendingObjects = true;
}

void wxlCan::OnSize(wxSizeEvent& WXUNUSED(event) )
{
    int dx,dy;
    GetClientSize(&dx,&dy);

    int w,h;
    GetVirtualSize( &w, &h );

    if ( w < dx )
        w = dx;
    if ( h < dy )
        h = dy;

    m_buffer = wxBitmap( w, h );

    m_pendingObjects = true;
}
