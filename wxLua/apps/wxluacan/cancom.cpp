/*! \file cancom.cpp
    \brief see canvas/include/cancom.h

    \author Klaas Holwerda

    Copyright: 2001-2004 (c) Klaas Holwerda

    Licence: wxWidgets Licence
*/

#include <wx/wxprec.h>

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif

#include "cancom.h"

IMPLEMENT_CLASS( wxlLuaCanCmd, wxCommandProcessor )

wxlLuaCanCmd::wxlLuaCanCmd( wxlCan* canvas, int maxCommands )
    : wxCommandProcessor( maxCommands )
{
     m_canvas = canvas;
}

wxlLuaCanCmd::~wxlLuaCanCmd()
{
}

void wxlLuaCanCmd::MoveObject( int index, double x, double y )
{
    wxlCanObj* canobj = NULL;
    if ( index < 0 )
        canobj = m_canvas->GetRootObject().m_objects.GetLast()->GetData();
    else
        canobj = m_canvas->GetRootObject().GetItem( index );
    canobj->SetPos( x, y );
}

wxlMoveObjectCmd::wxlMoveObjectCmd( wxlCanObj* object, double x, double y )
    :wxCommand( true, wxT("drag object") )
{
    m_object = object;
    m_x = x;
    m_y = y;
};

wxlMoveObjectCmd::~wxlMoveObjectCmd()
{
}

bool wxlMoveObjectCmd::Do(void)
{
    double x,y;
    x = m_object->GetX();
    y = m_object->GetY();

    m_object->SetPos( m_x, m_y );

    // store undo information
    m_x = x;
    m_y = y;

    return true;
}

bool wxlMoveObjectCmd::Undo(void)
{
    double x,y;
    x = m_object->GetX();
    y = m_object->GetY();

    m_object->SetPos( m_x, m_y );

    // store undo information
    m_x = x;
    m_y = y;

    return true;
}
