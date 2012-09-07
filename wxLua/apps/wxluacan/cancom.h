/*! \file canvas/include/cancom.h
    \brief wxlCanCom for do, undo and redo changes in a wxlCan

    \author Klaas Holwerda

    Copyright: 2000-2004 (c) Klaas Holwerda

    Licence: wxWidgets Licence
*/

#ifndef __WXLUACANCOM_H__
#define __WXLUACANCOM_H__


#include "canlua.h"

#include <wx/cmdproc.h>

//! a command interpreter
/*!
*/
class wxlLuaCanCmd : public wxCommandProcessor
{
    DECLARE_CLASS( wxlLuaCanCmd )

public:

    //! wxlLuaCanCmd
    wxlLuaCanCmd( wxlCan* canvas, int maxCommands = -1 );

    //! destructor
    ~wxlLuaCanCmd();

    void MoveObject( int index, double x, double y );

    wxlCan* m_canvas;
};

class wxlMoveObjectCmd: public wxCommand
{

public:

    wxlMoveObjectCmd( wxlCanObj* object, double x, double y );

    ~wxlMoveObjectCmd(void);

    bool Do(void);
    bool Undo(void);

protected:

    wxlCanObj* m_object;

    double m_x, m_y;
};

#endif

