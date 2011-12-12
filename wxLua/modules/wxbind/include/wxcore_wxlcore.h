/////////////////////////////////////////////////////////////////////////////
// Purpose:     Wrappers around wxCore classes for wxLua
// Author:      J. Winwood
// Created:     July 2002
// Copyright:   (c) 2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
/////////////////////////////////////////////////////////////////////////////

#ifndef WX_LUA_WXLCORE_H
#define WX_LUA_WXLCORE_H

#include "wxbind/include/wxbinddefs.h"
#include "wxluasetup.h"

class WXDLLIMPEXP_FWD_WXLUA wxLuaObject;


#if (wxVERSION_NUMBER < 2900)
    typedef int wxPenCap;
    typedef int wxPenJoin;
    typedef int wxPenStyle;

    typedef int wxRasterOperationMode;
    typedef int wxPolygonFillMode;
    typedef int wxFloodFillStyle;
    typedef int wxMappingMode;
    typedef int wxImageResizeQuality;
#endif


// ----------------------------------------------------------------------------
// wxLuaPrintout
// ----------------------------------------------------------------------------
#if wxLUA_USE_wxLuaPrintout

#include "wx/print.h"

class WXDLLIMPEXP_BINDWXCORE wxLuaPrintout : public wxPrintout
{
public:
    wxLuaPrintout(const wxLuaState& wxlState,
                  const wxString& title = wxT("Printout"),
                  wxLuaObject *pObject = NULL);

    // added function so you don't have to override GetPageInfo
    void SetPageInfo(int minPage, int maxPage, int pageFrom, int pageTo);

    // overrides
    virtual void GetPageInfo(int *minPage, int *maxPage, int *pageFrom, int *pageTo);
    virtual bool HasPage(int pageNum);
    virtual bool OnBeginDocument(int startPage, int endPage);
    virtual void OnEndDocument();
    virtual void OnBeginPrinting();
    virtual void OnEndPrinting();
    virtual void OnPreparePrinting();
    virtual bool OnPrintPage(int pageNumber);

    wxLuaObject *GetID() const { return m_pObject; }

    // Dummy test function to directly verify that the binding virtual functions really work.
    virtual wxString TestVirtualFunctionBinding(const wxString& val);
    static int ms_test_int;

private:
    wxLuaState   m_wxlState;
    wxLuaObject *m_pObject;
    int          m_minPage;
    int          m_maxPage;
    int          m_pageFrom;
    int          m_pageTo;
    DECLARE_ABSTRACT_CLASS(wxLuaPrintout)
};

#endif //wxLUA_USE_wxLuaPrintout

// ----------------------------------------------------------------------------
// wxLuaArtProvider
// ----------------------------------------------------------------------------
#if wxLUA_USE_wxArtProvider

#include "wx/artprov.h"

class WXDLLIMPEXP_BINDWXCORE wxLuaArtProvider : public wxArtProvider
{
public:
    wxLuaArtProvider(const wxLuaState& wxlState);

    // Get the default size of an icon for a specific client
    virtual wxSize DoGetSizeHint(const wxArtClient& client);

    // Derived classes must override this method to create requested
    // art resource. This method is called only once per instance's
    // lifetime for each requested wxArtID.
    virtual wxBitmap CreateBitmap(const wxArtID& id, const wxArtClient& client, const wxSize& size);

private:
    wxLuaState m_wxlState;

    DECLARE_ABSTRACT_CLASS(wxLuaArtProvider)
};

#endif // wxLUA_USE_wxArtProvider


// ----------------------------------------------------------------------------
// wxLuaTreeItemData - our treeitem data that allows us to get/set an index
// ----------------------------------------------------------------------------
#if wxLUA_USE_wxTreeCtrl && wxUSE_TREECTRL

#include "wx/treectrl.h"

class WXDLLIMPEXP_BINDWXCORE wxLuaTreeItemData : public wxTreeItemData
{
public:
	wxLuaTreeItemData() : m_data(NULL) {}
	wxLuaTreeItemData(wxLuaObject* obj) : m_data(obj) {}

    virtual ~wxLuaTreeItemData() { if (m_data) delete m_data; }

	wxLuaObject* GetData() const { return m_data; }
	void         SetData(wxLuaObject* obj) { if (m_data) delete m_data; m_data = obj; }

private:
	wxLuaObject* m_data;
};

#endif //wxLUA_USE_wxTreeCtrl && wxUSE_TREECTRL


#endif //WX_LUA_WXLCORE_H

