// ----------------------------------------------------------------------------
// Overridden functions for the wxWidgets binding for wxLua
//
// Please keep these functions in the same order as the .i file and in the
// same order as the listing of the functions in that file.
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Overrides for wxstc_stc.i
// ----------------------------------------------------------------------------

%override wxLua_wxStyledTextCtrl_GetCurLine
// wxString GetCurLine(int* linePos=NULL)
static int LUACALL wxLua_wxStyledTextCtrl_GetCurLine(lua_State *L)
{
    int linePos;
    // get this
    wxStyledTextCtrl *self = (wxStyledTextCtrl *)wxluaT_getuserdatatype(L, 1, wxluatype_wxStyledTextCtrl);
    // call GetCurLine
    wxString returns = self->GetCurLine(&linePos);
    // push the result string
    lua_pushstring(L, wx2lua(returns));
    lua_pushnumber(L, linePos);
    // return the number of parameters
    return 2;
}
%end

%override wxLua_wxStyledTextCtrl_GetSelection
// void GetSelection(int* startPos, int* endPos)
static int LUACALL wxLua_wxStyledTextCtrl_GetSelection(lua_State *L)
{
    int endPos;
    int startPos;
    // get this
    wxStyledTextCtrl *self = (wxStyledTextCtrl *)wxluaT_getuserdatatype(L, 1, wxluatype_wxStyledTextCtrl);
    // call GetSelection
    self->GetSelection(&startPos, &endPos);
    // push results
    lua_pushnumber(L, startPos);
    lua_pushnumber(L, endPos);
    // return the number of parameters
    return 2;
}
%end

%override wxLua_wxStyledTextCtrl_SetStyleBytes
// void    SetStyleBytes(int length, const wxString &styleBytes)
static int LUACALL wxLua_wxStyledTextCtrl_SetStyleBytes(lua_State *L)
{
    // const wxString &styleBytes
    char* styleBytes = (char*)lua_tostring(L, 3);
    // int length
    int length = (int)lua_tonumber(L, 2);
    // get this
    wxStyledTextCtrl *self = (wxStyledTextCtrl *)wxluaT_getuserdatatype(L, 1, wxluatype_wxStyledTextCtrl);
    // call SetStyleBytes
    self->SetStyleBytes(length, styleBytes);
    // return the number of parameters
    return 0;
}
%end
