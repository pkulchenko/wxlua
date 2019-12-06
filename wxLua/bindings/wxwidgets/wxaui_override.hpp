// ----------------------------------------------------------------------------
// Overridden functions for the wxWidgets binding for wxLua
//
// Please keep these functions in the same order as the .i file and in the
// same order as the listing of the functions in that file.
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Overrides for wxaui_aui.i
// ----------------------------------------------------------------------------


%override wxLua_wxAuiNotebook_FindTab
// void FindTab(wxWindow*);
static int LUACALL wxLua_wxAuiNotebook_FindTab(lua_State *L)
{
    // wxWindow page
    wxWindow * page = (wxWindow *)wxluaT_getuserdatatype(L, 2, wxluatype_wxWindow);
    // get this
    wxAuiNotebook * self = (wxAuiNotebook *)wxluaT_getuserdatatype(L, 1, wxluatype_wxAuiNotebook);
    // call FindTab
    int idx;
    wxAuiTabCtrl *ctrl;
    bool returns = (self->FindTab(page, &ctrl, &idx));
    if (returns) {
        wxluaT_pushuserdatatype(L, ctrl, wxluatype_wxAuiTabCtrl);
        lua_pushnumber(L, idx);
        return 2;
    }
    return 0;
}
%end

%override wxLua_wxAuiMDIChildFrame_GetIcon
// virtual const wxIcon& GetIcon() const;
static int LUACALL wxLua_wxAuiMDIChildFrame_GetIcon(lua_State *L)
{
    // get this
    wxAuiMDIChildFrame * self = (wxAuiMDIChildFrame *)wxluaT_getuserdatatype(L, 1, wxluatype_wxAuiMDIChildFrame);
    // call GetIcon
    const wxIcon returns = self->GetIcon();
    // push the result datatype
    wxluaT_pushuserdatatype(L, &returns, wxluatype_wxIcon);

    return 1;
}
%end

%override wxLua_wxAuiMDIChildFrame_GetIcons
// virtual const wxIconBundle& GetIcons() const;
static int LUACALL wxLua_wxAuiMDIChildFrame_GetIcons(lua_State *L)
{
    // get this
    wxAuiMDIChildFrame * self = (wxAuiMDIChildFrame *)wxluaT_getuserdatatype(L, 1, wxluatype_wxAuiMDIChildFrame);
    // call GetIcons
    const wxIconBundle returns = self->GetIcons();
    // push the result datatype
    wxluaT_pushuserdatatype(L, &returns, wxluatype_wxIconBundle);

    return 1;
}
%end
