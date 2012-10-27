
#include "canlua.h"
#include "cancom.h"
#include "cansim.h"
#include "wx/gdicmn.h"

class wxlCanObj : public wxObject
{
    wxlCanObj( double x = 0, double y = 0 );
   	void SetPos( double x, double y );
    double GetX( );
    double GetY( );
    void SetPen( const wxPen& pen );
    void SetBrush( const wxBrush& brush );
    void SetPending( bool pending = true );
    void AddObject( wxlCanObj *canobj );
};

class wxlCanObjRect : public wxlCanObj
{
    wxlCanObjRect(  double x, double y, double w, double h );
};

class wxlCanObjCircle : public wxlCanObj
{
    wxlCanObjCircle( double x, double y, double r );
};

class wxlCanObjScript : public wxlCanObj
{
    wxlCanObjScript( double x, double y, const wxString& name );
};

class wxlCanObjAddScript : public wxlCanObj
{
    wxlCanObjAddScript( double x, double y,  const wxString& script );
    void SetScript( const wxString& script );
};

class wxlCan : public wxScrolledWindow
{
    wxlCan( wxWindow* parent, wxWindowID id = -1, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize );
    void AddObject( wxlCanObj *canobj );
    bool GetYaxis( );

    wxlLuaCanCmd* GetCmdh( );
};

%function wxlCan* GetCan( );
%function wxlLuaCanCmd* GetCmdhMain( );

class wxlLuaCanCmd : public wxCommandProcessor
{
    wxlLuaCanCmd( wxlCan* canvas, int maxCommands = -1 );
    void MoveObject( int index, double x, double y );
};


