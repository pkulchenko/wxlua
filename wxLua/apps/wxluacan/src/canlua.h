/*! \file canlua.h
    \brief simple canvas which takes as drawable area the whole of the scrollable area.

    \author Klaas Holwerda

    Copyright: 2001-2004 (C) Klaas Holwerda

    Licence: wxWidgets Licence

    RCS-ID: $Id: canlua.h,v 1.10 2009/11/17 06:11:03 jrl1 Exp $
*/

#ifndef __LUACAN_H__
#define __LUACAN_H__

#include <wx/wx.h>
#include "wxlua/include/wxlstate.h"

class wxlCanObj;
class wxlLuaCanCmd;

WX_DECLARE_LIST( wxlCanObj, wxlCanObjList);

class wxlCan;

//! base canvas object
/*!
    this and derived objects or placed on the canvas in the m_rootobject or as a child of another canvasobject.
    This way nested structures can be made.
*/
class wxlCanObj: public wxEvtHandler
{

public:

    //! constructor
    /*!
        This object can have child objects added, and acts as a grouping object.
        All derived object can have childs too.
    */
    wxlCanObj( double x = 0, double y = 0 );

    virtual ~wxlCanObj();

    //! sets the position of the object relative to its parent object.
    void SetPos( double x, double y ) { m_x = x; m_y = y; SetPending( true ); }

    //! get x positions
    double GetX() { return m_x; }
    //! get y positions
    double GetY() { return m_y; }

    //! set default pen to use for drawing
    void SetPen( const wxPen& pen ) { m_pen = pen; }
    //! set default brush to use for drawing
    void SetBrush( const wxBrush& brush ) { m_brush = brush; }

    //! called when there is a pending objects in the canvas
    /*!
        when this specific object was set pending, it can update its state.
    */
    void Update( double absx, double absy );

    //! draw the object at an absolute position.
    void Draw( wxDC& dc, double absx, double absy );

    //! hit test all child objects in this object at an absolute position.
    wxlCanObj* WhichIsHit( double x, double y );

    //! hit test the object at an absolute position.
    bool IsHit( double x, double y, double absx = 0, double absy = 0);

    //! the object is part of this canvas
    void SetCanvas( wxlCan* canvas ) { m_canvas = canvas; }

    //! add a child object
    void AddObject( wxlCanObj *canobj );

    //! get child object at index
    wxlCanObj* GetItem( size_t index );

    //! something changed in this object, it needs an update and re-draw
    void SetPending( bool pending = true );

    //! child objects
    wxlCanObjList m_objects;

protected:

    virtual void DoUpdate( double WXUNUSED(absx), double WXUNUSED(absy) )
    {
        m_pending = false;
    }

    virtual void DoDraw( wxDC& WXUNUSED(dc), double WXUNUSED(absx), double WXUNUSED(absy) ) {}

    virtual bool DoIsHit( double WXUNUSED(x), double WXUNUSED(y), double WXUNUSED(absx), double WXUNUSED(absy) ) { return false; }

    wxBrush m_brush;
    wxPen   m_pen;

    wxlCan* m_canvas;

    double m_x, m_y;

    bool m_pending;

};

//! rectangle canvas object
/*!
    to be placed on the canvas in the m_rootobject or as a child of another canvasobject
*/
class wxlCanObjRect: public wxlCanObj
{

public:

    wxlCanObjRect( double x, double y, double w, double h );

    void DoDraw( wxDC& dc, double absx, double absy );

    bool DoIsHit( double x, double y, double absx, double absy );

protected:

    double m_w, m_h;
};

//! circle canvas object
/*!
    to be placed on the canvas in the m_rootobject or as a child of another canvasobject
*/
class wxlCanObjCircle: public wxlCanObj
{

public:

    wxlCanObjCircle( double x, double y, double r );

    void DoDraw( wxDC& dc, double absx, double absy );

    bool DoIsHit( double x, double y, double absx, double absy );

protected:

    double m_r;
};

//! lua script canvas object
/*!
    to be placed on the canvas in the m_rootobject or as a child of another canvasobject.
    The object name, is used to call a lua function fron DoDraw() called

      NameDraw( wxDC& dc, double absx, double absy ) to draw the object

    And in DoIsHit()

      NameHit(  double x, double y ) to hit test the object

*/
class wxlCanObjScript: public wxlCanObj
{

public:

    wxlCanObjScript( double x, double y, const wxString& name );

    void DoDraw( wxDC& dc, double absx, double absy );

    bool DoIsHit( double x, double y, double absx, double absy );

protected:

    wxString m_objectname;
};

//! lua script canvas object
/*!
    to be placed on the canvas in the m_rootobject or as a child of another canvasobject.
    The lua script in m_script will contain a function to generate the drawing for the object.
    It should do that by adding child objects to this object itself.
    The hit is no more then a hit on those childs, which is default functionality.
*/
class wxlCanObjAddScript: public wxlCanObj
{

public:

    wxlCanObjAddScript( double x, double y, const wxString& script );

    void SetScript( const wxString& script );

protected:

    virtual void DoUpdate( double absx, double absy );

    wxString m_script;
};

//! Simple canvas using a whole view for all of the scrolled window
/*!

*/
class wxlCan: public wxScrolledWindow
{
public:

    //!constructor
    /*!
    construct a canvas window.

    \param parent parent window (use wxNO_FULL_REPAINT_ON_RESIZE on parent wxFrame)
    \param id window id
    \param pos position of window
    \param size size of window
    \param style type of window (wxHSCROLL|wxVSCROLL)

    \remark with new unknown drawer types you can derive or extend the library
    */
    wxlCan( wxWindow *parent, wxWindowID id = -1,
        const wxPoint& pos = wxDefaultPosition,
        const wxSize& size = wxDefaultSize,
        long style = wxScrolledWindowStyle );

    //!destructor
    /*!
    */
    virtual ~wxlCan();

    //!get y axis orientation
    inline bool GetYaxis() const { return m_yaxis; }

    //!set if the Yaxis goes up or down
    virtual void SetYaxis(bool up);

    void SetBackgroundBrush( const wxBrush& brush );

    void SetPending( bool pending = true );

    void Render( wxDC& dc );

    //! Give the virtual size to be displayed.
    /*!
        To display all of a drawing, set this here to the boundingbox of the root object
        of the canvas.

        So vx1 and vx2 to the miminum x and y of the boundingbox.
        Calculate xpp and ypp in such a manner that it will show the whole drawing.

        \param vx1: minimum x coordinate of display area
        \param vy1: minimum y coordinate of display area
        \param xpp: Number of user units per pixel in x
        \param ypp: Number of user units per pixel in y
    */
    void SetMappingUpp( double vx1, double vy1, double xpp, double ypp );


    //! convert x from device to virtual coordinates
    inline double DeviceToWorldX( double x) const { return (x - m_transx)/m_scalex; }
    //! convert y from device to virtual coordinates
    inline double DeviceToWorldY( double y) const { return (y - m_transy)/m_scaley; }
    //! convert x relative from device to virtual coordinates
    /*!
        Use this to convert a length of a line for instance
    */
    inline double DeviceToWorldXRel( double x) const { return x/m_scalex; }
    //! convert y relative from device to virtual coordinates
    /*!
        Use this to convert a length of a line for instance
    */
    inline double DeviceToWorldYRel( double y) const { return y/m_scaley; }

    /*!
        Use this to convert a length of a line for instance
    */
    inline int WorldToDeviceXRel(double x) const {return (int) floor(m_scalex * x + 0.5); }
    //! convert y relative from virtual to device coordinates
    /*!
        Use this to convert a length of a line for instance
    */
    inline int WorldToDeviceYRel(double y) const {return (int) floor(m_scaley * y + 0.5); }

    //! convert x from virtual to device coordinates
    inline int WorldToDeviceX(double x) const { return (int) floor(m_scalex * x + m_transx + 0.5); }
    //! convert y from virtual to device coordinates
    inline int WorldToDeviceY(double y) const { return (int) floor(m_scaley * y + m_transy + 0.5); }

    void AddObject( wxlCanObj *canobj );

    wxlLuaCanCmd* GetCmdh() { return m_cmdh; }

    wxlCanObj& GetRootObject() { return m_rootobject; }

    void SetLuaState( wxLuaState* luastate ) { m_luastate = luastate; }

    wxLuaState* GetLuastate() { return m_luastate; }

protected:

    void OnMouseEvent(wxMouseEvent& event);

    //! redraw  pending objects to the buffer
    void OnIdle(wxIdleEvent &event);

    //! resize, adjusting buffer of wxlCanvasView if needed.
    void OnSize( wxSizeEvent &event );

    //! repaint damaged araes, taking into acount non updated araes in wxlCanvasView.
    void OnPaint( wxPaintEvent &event );

    void OnScroll(wxScrollWinEvent& event);

    void OnEraseBackground(wxEraseEvent& WXUNUSED(event) );

private:

    wxlLuaCanCmd* m_cmdh;

    wxLuaState* m_luastate;

    wxBitmap m_buffer;

    bool m_pendingObjects;

    //! virtual coordinates box its miminum X
    double m_virt_minX;

    //! virtual coordinates box its miminum Y
    double m_virt_minY;

    //!user units per pixel in x
    double m_xpp;

    //!user units per pixel in y
    double m_ypp;

    //!transformation from world to device coordinates
    double m_scalex;

    //!transformation from world to device coordinates
    double m_scaley;

    //!transformation from world to device coordinates
    double m_transx;

    //!transformation from world to device coordinates
    double m_transy;

    //! up or down
    bool m_yaxis;

    wxBrush m_backbrush;

    wxlCanObj m_rootobject;

    wxlCanObj* m_hit;
    double m_startMouseX, m_startMouseY;
    double m_startObjX, m_startObjY;

    DECLARE_CLASS(wxlCan)
    DECLARE_EVENT_TABLE()
};

#endif
// A2DCANVAS

