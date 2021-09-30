// ----------------------------------------------------------------------------
// Overridden functions for the wxWidgets binding for wxLua
//
// Please keep these functions in the same order as the .i file and in the
// same order as the listing of the functions in that file.
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Overrides for wxpropgrid_propgrid.i
// ----------------------------------------------------------------------------

%override wxLua_wxPGChoicesData_delete_function
// delete is private in wxPGChoicesData
void wxLua_wxPGChoicesData_delete_function(void** p)
{
}
%end

%override wxLua_wxPGCellData_delete_function
// delete is private in wxPGCellData
void wxLua_wxPGCellData_delete_function(void** p)
{
}
%end