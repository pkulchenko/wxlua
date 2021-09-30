-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath.."./?.dll./?.so../lib/?.so../lib/vc_dll/?.dll../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

--/* XPM */
local sample_xpm = {
--/* columns rows colors chars-per-pixel */
"32 32 6 1",
"  c black",
". c navy",
"X c red",
"o c yellow",
"O c gray100",
"+ c None",
--/* pixels */
"++++++++++++++++++++++++++++++++",
"++++++++++++++++++++++++++++++++",
"++++++++++++++++++++++++++++++++",
"++++++++++++++++++++++++++++++++",
"++++++++++++++++++++++++++++++++",
"++++++++              ++++++++++",
"++++++++ ............ ++++++++++",
"++++++++ ............ ++++++++++",
"++++++++ .OO......... ++++++++++",
"++++++++ .OO......... ++++++++++",
"++++++++ .OO......... ++++++++++",
"++++++++ .OO......              ",
"++++++++ .OO...... oooooooooooo ",
"         .OO...... oooooooooooo ",
" XXXXXXX .OO...... oOOooooooooo ",
" XXXXXXX .OO...... oOOooooooooo ",
" XOOXXXX ......... oOOooooooooo ",
" XOOXXXX ......... oOOooooooooo ",
" XOOXXXX           oOOooooooooo ",
" XOOXXXXXXXXX ++++ oOOooooooooo ",
" XOOXXXXXXXXX ++++ oOOooooooooo ",
" XOOXXXXXXXXX ++++ oOOooooooooo ",
" XOOXXXXXXXXX ++++ oooooooooooo ",
" XOOXXXXXXXXX ++++ oooooooooooo ",
" XXXXXXXXXXXX ++++              ",
" XXXXXXXXXXXX ++++++++++++++++++",
"              ++++++++++++++++++",
"++++++++++++++++++++++++++++++++",
"++++++++++++++++++++++++++++++++",
"++++++++++++++++++++++++++++++++",
"++++++++++++++++++++++++++++++++",
"++++++++++++++++++++++++++++++++"
}

local wxT = function(s) return s end
local _ = function(s) return s end

local IDCounter = nil
local function NewID()
    if not IDCounter then IDCounter = wx.wxID_HIGHEST end
    IDCounter = IDCounter + 1
    return IDCounter
end


local FormMain = {
    PGID = NewID(),
    ID_ABOUT = NewID(),
    ID_QUIT = NewID(),
    ID_APPENDPROP = NewID(),
    ID_APPENDCAT = NewID(),
    ID_INSERTPROP = NewID(),
    ID_INSERTCAT = NewID(),
    ID_ENABLE = NewID(),
    ID_SETREADONLY = NewID(),
    ID_HIDE = NewID(),
    ID_BOOL_CHECKBOX = NewID(),
    ID_DELETE = NewID(),
    ID_DELETER = NewID(),
    ID_DELETEALL = NewID(),
    ID_UNSPECIFY = NewID(),
    ID_ITERATE1 = NewID(),
    ID_ITERATE2 = NewID(),
    ID_ITERATE3 = NewID(),
    ID_ITERATE4 = NewID(),
    ID_CLEARMODIF = NewID(),
    ID_FREEZE = NewID(),
    ID_DUMPLIST = NewID(),
    ID_COLOURSCHEME1 = NewID(),
    ID_COLOURSCHEME2 = NewID(),
    ID_COLOURSCHEME3 = NewID(),
    ID_COLOURSCHEME4 = NewID(),
    ID_CATCOLOURS = NewID(),
    ID_SETBGCOLOUR = NewID(),
    ID_SETBGCOLOURRECUR = NewID(),
    ID_STATICLAYOUT = NewID(),
    ID_POPULATE1 = NewID(),
    ID_POPULATE2 = NewID(),
    ID_COLLAPSE = NewID(),
    ID_COLLAPSEALL = NewID(),
    ID_GETVALUES = NewID(),
    ID_SETVALUES = NewID(),
    ID_SETVALUES2 = NewID(),
    ID_RUNTESTFULL = NewID(),
    ID_RUNTESTPARTIAL = NewID(),
    ID_FITCOLUMNS = NewID(),
    ID_CHANGEFLAGSITEMS = NewID(),
    ID_TESTINSERTCHOICE = NewID(),
    ID_TESTDELETECHOICE = NewID(),
    ID_INSERTPAGE = NewID(),
    ID_REMOVEPAGE = NewID(),
    ID_SETSPINCTRLEDITOR = NewID(),
    ID_SETPROPERTYVALUE = NewID(),
    ID_TESTREPLACE = NewID(),
    ID_SETCOLUMNS = NewID(),
    ID_SETVIRTWIDTH = NewID(),
    ID_SETPGDISABLED = NewID(),
    ID_TESTXRC = NewID(),
    ID_ENABLECOMMONVALUES = NewID(),
    ID_SELECTSTYLE = NewID(),
    ID_SAVESTATE = NewID(),
    ID_RESTORESTATE = NewID(),
    ID_RUNMINIMAL = NewID(),
    ID_ENABLELABELEDITING = NewID(),
    ID_VETOCOLDRAG = NewID(),
    ID_SHOWHEADER = NewID(),
    ID_ONEXTENDEDKEYNAV = NewID(),
    ID_SHOWPOPUP = NewID(),
    ID_POPUPGRID = NewID(),

    m_pPropGridManager = nil,
    m_propGrid = nil,

    m_tcPropLabel = nil,
    m_panel = nil,
    m_topSizer = nil,

    m_logWindow = nil,

    m_pSampleMultiButtonEditor = nil,
    m_combinedFlags = wx.wxPGChoices(),

    m_itemCatColours = nil,
    m_itemFreeze = nil,
    m_itemEnable = nil,
    m_itemVetoDragging = nil,

    m_storedValues = nil,

    m_savedState = "",
    m_hasHeader = false,
    m_labelEditingEnabled = false
}

function FormMain:OnMove(event)
   if self.m_pPropGridManager == nil then
      event:Skip()
      return
   end
end

function FormMain:OnResize(event)
   if self.m_pPropGridManager == nil then
      event:Skip()
      return
   end
end

function FormMain:OnPropertyGridChanging(event)
   local p = event:GetProperty()

   if p:GetName() == "Font" then
      local res = wx.wxMessageBox(
         ("'%s' is about to change (to variant of type '%s')\n\nAllow or deny?")
         :format(p:GetName(), event:GetValue():GetType()),
         "Testing wxEVT_PG_CHANGING", wx.wxYES_NO, self.m_pPropGridManager)

      if res == wx.wxNO then
         -- wxASSERT(event.CanVeto())
         event:Veto()
         event:SetValidationFailureBehavior(0)
      end
   end
end

local pwdMode = false

function FormMain:OnPropertyGridChange(event)
   local property = event:GetProperty()
   local name = property:GetName()

   local value = property:GetValue()

   if value:IsNull() then
      return
   end

   if name == "X" then
      self:SetSize(value:GetInt(), -1, -1, -1, wx.wxSIZE_USE_EXISTING)
   elseif name == "Y" then
      self:SetSize(-1, value:GetInt(), -1, -1, wx.wxSIZE_USE_EXISTING)
   elseif name == "Width" then
      self:SetSize(-1, -1, value:GetInt(), -1, wx.wxSIZE_USE_EXISTING)
   elseif name == "Height" then
      self:SetSize(-1, -1, -1, value:GetInt(), wx.wxSIZE_USE_EXISTING)
   elseif name == "Label" then
      self:SetTitle(value:GetString())
   elseif name == "Password" then
      pwdMode = value:GetBool()
   elseif name == "Font" then
      local font = value:As("wxFont")
      self.m_pPropGridManager:SetFont(font)

      -- TODO custom properties
      -- elseif name == "Margin Colour" then
      -- elseif name == "Cell Colour" then
      -- elseif name == "Line Colour" then
      -- elseif name == "Cell Text Colour" then
   end
end

function FormMain:OnPropertyGridSelect(event)
   local property = event:GetProperty()
   if property then
      self.m_itemEnable:Enable(true)
      if property:IsEnabled() then
         self.m_itemEnable:SetItemLabel("Disable")
      else
         self.m_itemEnable:SetItemLabel("Enable")
      end
   else
      self.m_itemEnable:Enable(false)
   end

   -- #if wxUSE_STATUSBAR
   local prop = event:GetProperty()
   local sb = self:GetStatusBar()
   if prop then
      local text = ("Selected: %s"):format(self.m_pPropGridManager:GetPropertyLabel(prop))
      sb:SetStatusText(text)
   end
   -- #endif // wsxUSE_STATUSBAR
end

function FormMain:OnPropertyGridPageChange(_)
   -- #if wxUSE_STATUSBAR
   local sb = self:GetStatusBar()
   local text = ("Page Changed: %s"):format(self.m_pPropGridManager:GetPageName(self.m_pPropGridManager:GetSelectedPage()))
   sb:SetStatusText(text)
   -- #endif // wsxUSE_STATUSBAR
end

function FormMain:OnPropertyGridLabelEditBegin(event)
   wx.wxLogMessage(("wxPG_EVT_LABEL_EDIT_BEGIN(%s)"):format(event:GetProperty():GetLabel()))
end

function FormMain:OnPropertyGridLabelEditEnding(event)
   wx.wxLogMessage(("wxPG_EVT_LABEL_EDIT_ENDING(%s)"):format(event:GetProperty():GetLabel()))
end

function FormMain:OnPropertyGridHighlight(_)
end

function FormMain:OnPropertyGridItemRightClick(event)
   -- #if wxUSE_STATUSBAR
   local prop = event:GetProperty()
   local sb = self:GetStatusBar()
   if prop then
      local text = ("Right-clicked: %s, name=%s"):format(prop:GetLabel(), self.m_pPropGridManager:GetPropertyName(prop))
      sb:SetStatusText(text)
   else
      sb:SetStatusText("")
   end
   -- #endif // wsxUSE_STATUSBAR
end

function FormMain:OnPropertyGridItemDoubleClick(event)
   -- #if wxUSE_STATUSBAR
   local prop = event:GetProperty()
   local sb = self:GetStatusBar()
   if prop then
      local text = ("Double-clicked: %s, name=%s"):format(prop:GetLabel(), self.m_pPropGridManager:GetPropertyName(prop))
      sb:SetStatusText(text)
   else
      sb:SetStatusText("")
   end
   -- #endif // wsxUSE_STATUSBAR
end

function FormMain:OnPropertyGridButtonClick(_)
   -- #if wxUSE_STATUSBAR
   local prop = self.m_pPropGridManager:GetSelection()
   local sb = self:GetStatusBar()
   if prop then
      local text = ("Button clicked: %s, name=%s"):format(self.m_pPropGridManager:GetPropertyLabel(prop),
                                                          self.m_pPropGridManager:GetPropertyName(prop))
      sb:SetStatusText(text)
   else
      sb:SetStatusText("SHOULD NOT HAPPEN!!!")
   end
   -- #endif // wsxUSE_STATUSBAR
end

function FormMain:OnPropertyGridItemCollapse(_)
   wx.wxLogMessage("Item was Collapsed")
end

function FormMain:OnPropertyGridItemExpand(_)
   wx.wxLogMessage("Item was Expanded")
end

function FormMain:OnPropertyGridColBeginDrag(event)
   if self.m_itemVetoDragging:IsChecked() then
      wx.wxLogDebug(("Splitter %d resize was vetoed"):format(event.GetColumn()))
      event:Veto()
   else
      wx.wxLogDebug(("Splitter %d resize began"):format(event.GetColumn()))
   end
end

function FormMain:OnPropertyGridColDragging(_)
end

function FormMain:OnPropertyGridColEndDrag(event)
   wx.wxLogDebug(("Splitter %d resize ended"):format(event.GetColumn()))
end

function FormMain:OnPropertyGridTextUpdate(event)
   event:Skip()
end

function FormMain:OnPropertyGridKeyUpdate(_)
end

function FormMain:OnLabelTextChange(_)
end

local _fs_windowstyle_labels = {
   "wxSIMPLE_BORDER",
   "wxDOUBLE_BORDER",
   "wxSUNKEN_BORDER",
   "wxRAISED_BORDER",
   "wxNO_BORDER",
   "wxTRANSPARENT_WINDOW",
   "wxTAB_TRAVERSAL",
   "wxWANTS_CHARS",
   "wxVSCROLL",
   "wxALWAYS_SHOW_SB",
   "wxCLIP_CHILDREN",
   "wxFULL_REPAINT_ON_RESIZE",
}

local _fs_windowstyle_values = {}
for i, label in ipairs(_fs_windowstyle_labels) do
   _fs_windowstyle_values[i] = wx[label]
end

local _fs_framestyle_labels = {
   "wxCAPTION",
   "wxMINIMIZE",
   "wxMAXIMIZE",
   "wxCLOSE_BOX",
   "wxSTAY_ON_TOP",
   "wxSYSTEM_MENU",
   "wxRESIZE_BORDER",
   "wxFRAME_TOOL_WINDOW",
   "wxFRAME_NO_TASKBAR",
   "wxFRAME_FLOAT_ON_PARENT",
   "wxFRAME_SHAPED"
}

local _fs_framestyle_values = {}
for i, label in ipairs(_fs_framestyle_labels) do
   _fs_framestyle_values[i] = wx[label]
end

function FormMain:PopulateWithStandardItems()
    local pgman = self.m_pPropGridManager
    local pg = pgman:GetPage("Standard Items")
    local this = self.this

    ----// Append is ideal way to add items to wxPropertyGrid.
    pg:Append( wx.wxPropertyCategory("Appearance",wx.wxPG_LABEL) )

    pg:Append( wx.wxStringProperty("Label",wx.wxPG_LABEL,this:GetTitle()) )
    pg:Append( wx.wxFontProperty("Font",wx.wxPG_LABEL) )
    pg:SetPropertyHelpString ( "Font", "Editing this will change font used in the property grid." )

    pg:Append( wx.wxSystemColourProperty("Margin Colour",wx.wxPG_LABEL,
        pg:GetGrid():GetMarginColour()) )

    pg:Append( wx.wxSystemColourProperty("Cell Colour",wx.wxPG_LABEL,
        pg:GetGrid():GetCellBackgroundColour()) )
    pg:Append( wx.wxSystemColourProperty("Cell Text Colour",wx.wxPG_LABEL,
        pg:GetGrid():GetCellTextColour()) )
    pg:Append( wx.wxSystemColourProperty("Line Colour",wx.wxPG_LABEL,
        pg:GetGrid():GetLineColour()) )
    pg:Append( wx.wxFlagsProperty("Window Styles",wx.wxPG_LABEL, self.m_combinedFlags, this:GetWindowStyle()) )

    --//pg:SetPropertyAttribute("Window Styles",wx.wxPG_BOOL_USE_CHECKBOX,true,wxPG_RECURSE)

    pg:Append( wx.wxCursorProperty("Cursor",wx.wxPG_LABEL) )

    pg:Append( wx.wxPropertyCategory("Position","PositionCategory") )
    pg:SetPropertyHelpString( "PositionCategory", "Change in items in this category will cause respective changes in frame." )

    ----// Let's demonstrate 'Units' attribute here

    --// Note that we use many attribute constants instead of strings here
    --// (for instance, wx.wxPG_ATTR_MIN, instead of "min").
    --// Using constant may reduce binary size.

    pg:Append( wx.wxIntProperty("Height",wx.wxPG_LABEL,480) )
    pg:SetPropertyAttribute("Height", wx.wxPG_ATTR_MIN, 10 )
    pg:SetPropertyAttribute("Height", wx.wxPG_ATTR_MAX, 2048 )
    pg:SetPropertyAttribute("Height", wx.wxPG_ATTR_UNITS, "Pixels" )

    --// Set value to unspecified so that Hint attribute will be demonstrated
    pg:SetPropertyValueUnspecified("Height")
    pg:SetPropertyAttribute("Height", wx.wxPG_ATTR_HINT,
                             "Enter wx.height for window" )

    --// Difference between hint and help string is that the hint is shown in
    --// an empty value cell, while help string is shown either in the
    --// description text box, as a tool tip, or on the status bar.
    pg:SetPropertyHelpString("Height",
        "This property uses attributes \"Units\" and \"Hint\".")

    pg:Append( wx.wxIntProperty("Width",wx.wxPG_LABEL,640) )
    pg:SetPropertyAttribute("Width", wx.wxPG_ATTR_MIN, 10 )
    pg:SetPropertyAttribute("Width", wx.wxPG_ATTR_MAX, 2048 )
    pg:SetPropertyAttribute("Width", wx.wxPG_ATTR_UNITS, "Pixels" )

    pg:SetPropertyValueUnspecified("Width")
    pg:SetPropertyAttribute("Width", wx.wxPG_ATTR_HINT,
                             "Enter wx.width for window" )
    pg:SetPropertyHelpString("Width",
        "This property uses attributes \"Units\" and \"Hint\".")

    pg:Append( wx.wxIntProperty("X",wx.wxPG_LABEL,10) )
    pg:SetPropertyAttribute("X", wx.wxPG_ATTR_UNITS, "Pixels" )
    pg:SetPropertyHelpString("X", "This property uses \"Units\" attribute.")

    pg:Append( wx.wxIntProperty("Y",wx.wxPG_LABEL,10) )
    pg:SetPropertyAttribute("Y", wx.wxPG_ATTR_UNITS, "Pixels" )
    pg:SetPropertyHelpString("Y", "This property uses \"Units\" attribute.")

    local disabledHelpString = "This property is simply disabled. In order to have label disabled as well, " ..
                                       "you need to set wx.wxPG_EX_GREY_LABEL_WHEN_DISABLED using SetExtraStyle."

    pg:Append( wx.wxPropertyCategory("Environment",wx.wxPG_LABEL) )
    pg:Append( wx.wxStringProperty("Operating System",wx.wxPG_LABEL,wx.wxGetOsDescription()) )

    pg:Append( wx.wxStringProperty("User Id",wx.wxPG_LABEL,wx.wxGetUserId()) )
    pg:Append( wx.wxDirProperty("User Home",wx.wxPG_LABEL,wx.wxGetUserHome()) )
    pg:Append( wx.wxStringProperty("User Name",wx.wxPG_LABEL,wx.wxGetUserName()) )

    --// Disable some of them
    pg:DisableProperty( "Operating System" )
    pg:DisableProperty( "User Id" )
    pg:DisableProperty( "User Name" )

    pg:SetPropertyHelpString( "Operating System", disabledHelpString )
    pg:SetPropertyHelpString( "User Id", disabledHelpString )
    pg:SetPropertyHelpString( "User Name", disabledHelpString )

    pg:Append( wx.wxPropertyCategory("More Examples",wx.wxPG_LABEL) )

    -- pg:Append( wx.wxFontDataProperty( "FontDataProperty", wx.wxPG_LABEL) )
    -- pg:SetPropertyHelpString( "FontDataProperty",
    --     "This demonstrates wxFontDataProperty class defined in this sample app. " ..
    --     "It is exactly like wxFontProperty from the library, but also has colour sub-property."
    --     )

    -- pg:Append( wx.wxDirsProperty("DirsProperty",wx.wxPG_LABEL) )
    -- pg:SetPropertyHelpString( "DirsProperty",
    --     "This demonstrates wxDirsProperty class defined in this sample app. " ..
    --     "It is built with WX_PG_IMPLEMENT_ARRAYSTRING_PROPERTY_WITH_VALIDATOR macro, " ..
    --     "with custom action (dir dialog popup) defined."
    --     )

    -- local arrdbl = { -1.0, -0.5, 0.0, 0.5, 1.0 }

    -- pg:Append( wx.wxArrayDoubleProperty("ArrayDoubleProperty",wx.wxPG_LABEL,arrdbl) )
    -- --//pg:SetPropertyAttribute("ArrayDoubleProperty",wx.wxPG_FLOAT_PRECISION,2L)
    -- pg:SetPropertyHelpString( "ArrayDoubleProperty",
    --     "This demonstrates wxArrayDoubleProperty class defined in this sample app. " ..
    --     "It is an example of a custom list editor property."
    --     )

    pg:Append( wx.wxLongStringProperty("Information",wx.wxPG_LABEL,
        "Editing properties will have immediate effect on this window, " ..
        "and vice versa (at least in most cases, that is)."
        ) )
    pg:SetPropertyHelpString( "Information",
                               "This property is read-only." )

    pg:SetPropertyReadOnly( "Information", true )

    --//
    --// Set test information for cells in columns 3 and 4
    --// (reserve column 2 for displaying units)
    --[[ FIXME
    wxPropertyGridIterator it
    wxBitmap bmp = wxArtProvider::GetBitmap(wxART_FOLDER)

    for ( it = pg:GetGrid():GetIterator()
          !it.AtEnd()
          ++it )
    {
        wx.wxPGProperty* p = *it
        if ( p:IsCategory() )
            continue

        pg:SetPropertyCell( p, 3, "Cell 3", bmp )
        pg:SetPropertyCell( p, 4, "Cell 4", wxNullBitmap, *wxWHITE, *wxBLACK )
    }
    --]]
end

function FormMain:PopulateWithExamples()
    local pgman = self.m_pPropGridManager
    local pg = pgman:GetPage("Examples")
    local this = self.this
    local pid, prop

    ----//pg:Append( wx.wxPropertyCategory("Examples (low priority)","Examples") )
    ----//pg:SetPropertyHelpString ( "Examples", "This category has example of (almost) every built-in property class." )

--#if wxUSE_SPINBTN
    pg:Append( wx.wxIntProperty ( "SpinCtrl", wx.wxPG_LABEL, 0 ) )

    pg:SetPropertyEditor( "SpinCtrl", wx.wxPGEditor_SpinCtrl() )
    pg:SetPropertyAttribute( "SpinCtrl", wx.wxPG_ATTR_MIN, -2 )--// Use constants instead of string
    pg:SetPropertyAttribute( "SpinCtrl", wx.wxPG_ATTR_MAX, 16384 )--// for reduced binary size.
    pg:SetPropertyAttribute( "SpinCtrl", wx.wxPG_ATTR_SPINCTRL_STEP, 2 )
    pg:SetPropertyAttribute( "SpinCtrl", wx.wxPG_ATTR_SPINCTRL_MOTION, true )
    --//pg:SetPropertyAttribute( "SpinCtrl", wx.wxPG_ATTR_SPINCTRL_WRAP, true )

    pg:SetPropertyHelpString( "SpinCtrl",
        "This is regular wxIntProperty, which editor has been " ..
        "changed to wx.wxPGEditor_SpinCtrl. Note however that " ..
        "static wxPropertyGrid::RegisterAdditionalEditors() " ..
        "needs to be called prior to using it.")

--#endif

    --// Add bool property
    pg:Append( wx.wxBoolProperty( "BoolProperty", wx.wxPG_LABEL, false ) )

    --// Add bool property with check box
    pg:Append( wx.wxBoolProperty( "BoolProperty with CheckBox", wx.wxPG_LABEL, false ) )
    pg:SetPropertyAttribute( "BoolProperty with CheckBox",
                              wx.wxPG_BOOL_USE_CHECKBOX,
                              true )

    pg:SetPropertyHelpString( "BoolProperty with CheckBox",
        "Property attribute wx.wxPG_BOOL_USE_CHECKBOX has been set to true." )

    prop = pg:Append( wx.wxFloatProperty("FloatProperty",
                                           wx.wxPG_LABEL,
                                           1234500.23) )
    prop:SetAttribute(wx.wxPG_ATTR_MIN, -100.12)

    --// A string property that can be edited in a separate editor dialog.
    pg:Append( wx.wxLongStringProperty( "LongStringProperty", "LongStringProp",
        "This is much longer string than the first one. Edit it by clicking the button." ) )

    --// A property that edits a wxArrayString.
    local example_array = { "String 1", "String 2", "String 3" }
    pg:Append( wx.wxArrayStringProperty( "ArrayStringProperty", wx.wxPG_LABEL,
                                           example_array) )

    --// Test adding same category multiple times ( should not actually create a wx.one )
    --//pg:Append( wx.wxPropertyCategory("Examples (low priority)","Examples") )

    --// A file selector property. Note that argument between name
    --// and initial value is wildcard (format same as in wxFileDialog).
    prop = wx.wxFileProperty( "FileProperty", "TextFile" )
    pg:Append( prop )

    prop:SetAttribute(wx.wxPG_FILE_WILDCARD,"Text Files (*.txt)|*.txt")
    prop:SetAttribute(wx.wxPG_DIALOG_TITLE,"Custom File Dialog Title")
    prop:SetAttribute(wx.wxPG_FILE_SHOW_FULL_PATH,false)

--#ifdef __WXMSW__
    prop:SetAttribute(wx.wxPG_FILE_SHOW_RELATIVE_PATH,"C:\\Windows")
    pg:SetPropertyValue(prop,"C:\\Windows\\System32\\msvcrt71.dll")
--#endif

--#if wxUSE_IMAGE
    --// An image file property. Arguments are just like for FileProperty, but
    --// wildcard is missing (it is autogenerated from supported image formats).
    --// If you really need to override it, create property separately, and call
    --// its SetWildcard method.
    pg:Append( wx.wxImageFileProperty( "ImageFile", wx.wxPG_LABEL ) )
--#endif

    pid = pg:Append( wx.wxColourProperty("ColourProperty",wx.wxPG_LABEL,wx.wxRED) )
    pg:SetPropertyEditor( "ColourProperty", wx.wxPGEditor_ComboBox )
    pg:GetProperty("ColourProperty"):SetAutoUnspecified(true)
    pg:SetPropertyHelpString( "ColourProperty",
        "wxPropertyGrid::SetPropertyEditor method has been used to change " ..
        "editor of this property to wx.wxPGEditor_ComboBox)")

    pid = pg:Append( wx.wxColourProperty("ColourPropertyWithAlpha",
                                           wx.wxPG_LABEL,
                                           wx.wxColour(15, 200, 95, 128)) )
    pg:SetPropertyAttribute("ColourPropertyWithAlpha", wx.wxPG_COLOUR_HAS_ALPHA, true)
    pg:SetPropertyHelpString("ColourPropertyWithAlpha",
        "Attribute \"HasAlpha\" is set to true for this property.")

    --//
    --// This demonstrates using alternative editor for colour property
    --// to trigger colour dialog directly from button.
    pg:Append( wx.wxColourProperty("ColourProperty2",wx.wxPG_LABEL,wx.wxGREEN) )

    --//
    --// wxEnumProperty does not store strings or even list of strings
    --// ( so that's why they are static in function ).
    local enum_prop_labels = { "One Item", "Another Item", "One More", "This Is Last" }

    --// this value array would be optional if values matched string indexes
    local enum_prop_values = { 40, 80, 120, 160 }

    --// note that the initial value (the last argument) is the actual value,
    --// not index or anything like that. Thus, our value selects "Another Item".
    pg:Append( wx.wxEnumProperty("EnumProperty",wx.wxPG_LABEL, enum_prop_labels, enum_prop_values) )

    local soc = wx.wxPGChoices()

    --// use basic table from our previous example
    --// can also set/add wxArrayStrings and wxArrayInts directly.
    soc:Set(enum_prop_labels, enum_prop_values)

    --// add extra items
    soc:Add( "Look, it continues", 200 )
    soc:Add( "Even More", 240 )
    soc:Add( "And More", 280 )
    soc:Add( "", 300 )
    soc:Add( "True End of the List", 320 )

    --// Test custom colours ([] operator of wx.wxPGChoices returns
    --// references to wx.wxPGChoiceEntry).
    soc[1]:SetFgCol(wx.wxRED)
    soc[1]:SetBgCol(wx.wxLIGHT_GREY)
    soc[2]:SetFgCol(wx.wxGREEN)
    soc[2]:SetBgCol(wx.wxLIGHT_GREY)
    soc[3]:SetFgCol(wx.wxBLUE)
    soc[3]:SetBgCol(wx.wxLIGHT_GREY)
    soc[4]:SetBitmap(wx.wxArtProvider.GetBitmap(wx.wxART_FOLDER))

    pg:Append( wx.wxEnumProperty("EnumProperty 2", wx.wxPG_LABEL, soc, 240) )
    pg:GetProperty("EnumProperty 2"):AddChoice("Testing Extra", 360)

    --// Here we only display the original 'soc' choices
    pg:Append( wx.wxEnumProperty("EnumProperty 3",wx.wxPG_LABEL, soc, 240 ) )

    --// Test Hint attribute in EnumProperty
    pg:GetProperty("EnumProperty 3"):SetAttribute(wx.wxPG_ATTR_HINT, "Dummy Hint")

    pg:SetPropertyHelpString("EnumProperty 3", "This property uses \"Hint\" attribute.")

    --// 'soc' plus one exclusive extra choice "4th only"
    pg:Append( wx.wxEnumProperty("EnumProperty 4",wx.wxPG_LABEL, soc, 240 ) )
    pg:GetProperty("EnumProperty 4"):AddChoice("4th only", 360)

    pg:SetPropertyHelpString("EnumProperty 4", "Should have one extra item when compared to EnumProperty 3")

    --// Plus property value bitmap
    pg:Append( wx.wxEnumProperty("EnumProperty With Bitmap", "EnumProperty 5", soc, 280) )
    pg:SetPropertyHelpString("EnumProperty 5", "Should have bitmap in front of the displayed value")
    local bmpVal = wx.wxArtProvider.GetBitmap(wx.wxART_REMOVABLE)
    pg:SetPropertyImage("EnumProperty 5", bmpVal)

    --// Password property example.
    pg:Append( wx.wxStringProperty("Password",wx.wxPG_LABEL, "password") )
    pg:SetPropertyAttribute( "Password", wx.wxPG_STRING_PASSWORD, true )
    pg:SetPropertyHelpString( "Password", "Has attribute wx.wxPG_STRING_PASSWORD set to true" )

    --// String editor with dir selector button. Uses wxEmptyString as name, which
    --// is allowed (naturally, in this case property cannot be accessed by name).
    pg:Append( wx.wxDirProperty( "DirProperty", wx.wxPG_LABEL, wx.wxGetUserHome()) )
    pg:SetPropertyAttribute( "DirProperty", wx.wxPG_DIALOG_TITLE, "This is a custom dir dialog title" )

    --// Add string property - first arg is label, second name, and third initial value
    pg:Append( wx.wxStringProperty ( "StringProperty", wx.wxPG_LABEL ) )
    pg:SetPropertyMaxLength( "StringProperty", 6 )
    pg:SetPropertyHelpString( "StringProperty",
        "Max length of this text has been limited to 6, using wxPropertyGrid::SetPropertyMaxLength." )

    --// Set value after limiting so that it will be applied
    pg:SetPropertyValue( "StringProperty", "some text" )

    --//
    --// Demonstrate "AutoComplete" attribute
    pg:Append( wx.wxStringProperty( "StringProperty AutoComplete", wx.wxPG_LABEL ) )

    local autoCompleteStrings = {
       "One choice",
       "Another choice",
       "Another choice, yeah",
       "Yet another choice",
       "Yet another choice, bear with me"
    }
    pg:SetPropertyAttribute( "StringProperty AutoComplete", wx.wxPG_ATTR_AUTOCOMPLETE, autoCompleteStrings )

    pg:SetPropertyHelpString( "StringProperty AutoComplete",
        "AutoComplete attribute has been set for this property " ..
        "(try writing something beginning with 'a', 'o' or 'y').")

    --// Add string property with arbitrarily wide bitmap in front of it. We
    --// intentionally lower-than-typical row height here so that the ugly
    --// scaling code won't be run.
    pg:Append( wx.wxStringProperty( "StringPropertyWithBitmap", wx.wxPG_LABEL, "Test Text") )
    local myTestBitmap = wx.wxBitmap(60, 15, 32)
    local mdc = wx.wxMemoryDC()
    mdc:SelectObject(myTestBitmap)
    mdc:SetBackground(wx.wxWHITE_BRUSH)
    mdc:Clear()
    mdc:SetPen(wx.wxBLACK)
    mdc:DrawLine(0, 0, 60, 15)
    mdc:SelectObject(wx.wxNullBitmap)
    pg:SetPropertyImage( "StringPropertyWithBitmap", myTestBitmap )


    --// this value array would be optional if values matched string indexes
    --//long flags_prop_values[] = { wxICONIZE, wxCAPTION, wxMINIMIZE_BOX, wxMAXIMIZE_BOX }

    --//pg:Append( wxFlagsProperty("Example of FlagsProperty","FlagsProp",
    --//    flags_prop_labels, flags_prop_values, 0, GetWindowStyle() ) )


    --// Multi choice dialog.
    local tchoices = {
       "Cabbage",
       "Carrot",
       "Onion",
       "Potato",
       "Strawberry"
    }

    local tchoicesValues = {
       "Carrot",
       "Potato"
    }

    pg:Append( wx.wxEnumProperty("EnumProperty X",wx.wxPG_LABEL, tchoices ) )

    pg:Append( wx.wxMultiChoiceProperty( "MultiChoiceProperty", wx.wxPG_LABEL, tchoices, tchoicesValues ) )
    pg:SetPropertyAttribute("MultiChoiceProperty", wx.wxPG_ATTR_MULTICHOICE_USERSTRINGMODE, 1)

    pg:Append( wx.wxSizeProperty( "SizeProperty", "Size", this:GetSize() ) )
    pg:Append( wx.wxPointProperty( "PointProperty", "Position", this:GetPosition() ) )

    --// UInt samples
--#if wxUSE_LONGLONG
    pg:Append( wx.wxUIntProperty( "UIntProperty", wx.wxPG_LABEL, 0xFEEEFEEEFEEE))
--#else
    pg:Append( wx.wxUIntProperty( "UIntProperty", wx.wxPG_LABEL, 0xFEEEFEEE))
--#endif
    pg:SetPropertyAttribute( "UIntProperty", wx.wxPG_UINT_PREFIX, wx.wxPG_PREFIX_NONE )
    pg:SetPropertyAttribute( "UIntProperty", wx.wxPG_UINT_BASE, wx.wxPG_BASE_HEX )
    --//pg:SetPropertyAttribute( "UIntProperty", wx.wxPG_UINT_PREFIX, wxPG_PREFIX_NONE )
    --//pg:SetPropertyAttribute( "UIntProperty", wx.wxPG_UINT_BASE, wxPG_BASE_OCT )

    --//
    --// wxEditEnumProperty
    local eech = wx.wxPGChoices()
    eech:Add("Choice 1")
    eech:Add("Choice 2")
    eech:Add("Choice 3")
    pg:Append( wx.wxEditEnumProperty("EditEnumProperty", wx.wxPG_LABEL, eech, "Choice not in the list") )

    --// Test Hint attribute in EditEnumProperty
    pg:GetProperty("EditEnumProperty"):SetAttribute(wx.wxPG_ATTR_HINT, "Dummy Hint")

    --//wxString v_
    --//wxTextValidator validator1(wxFILTER_NUMERIC,&v_)
    --//pg:SetPropertyValidator( "EditEnumProperty", validator1 )

--#if wxUSE_DATETIME
    --//
    --// wxDateTimeProperty
    pg:Append( wx.wxDateProperty("DateProperty", wx.wxPG_LABEL, wx.wxDateTime.Now() ) )

--#if wxUSE_DATEPICKCTRL
    pg:SetPropertyAttribute( "DateProperty", wx.wxPG_DATE_PICKER_STYLE,
                             (wxDP_DROPDOWN + wxDP_SHOWCENTURY + wxDP_ALLOWNONE) )

    pg:SetPropertyHelpString( "DateProperty",
        "Attribute wx.wxPG_DATE_PICKER_STYLE has been set to (long)" ..
        "(wxDP_DROPDOWN | wxDP_SHOWCENTURY | wxDP_ALLOWNONE)." )
--#endif

--#endif

    --//
    --// Add Triangle properties as both wxTriangleProperty and
    --// a generic parent property (using wxStringProperty).
    --//
    local topId = pg:Append( wx.wxStringProperty("3D Object", wxPG_LABEL, "<composed>") )

    pid = pg:AppendIn( topId, wx.wxStringProperty("Triangle 1", "Triangle 1", "<composed>") )
    pg:AppendIn( pid, wx.wxVectorProperty( "A", wx.wxPG_LABEL ) )
    pg:AppendIn( pid, wx.wxVectorProperty( "B", wx.wxPG_LABEL ) )
    pg:AppendIn( pid, wx.wxVectorProperty( "C", wx.wxPG_LABEL ) )

    pg:AppendIn( topId, wx.wxTriangleProperty( "Triangle 2", "Triangle 2" ) )

    pg:SetPropertyHelpString( "3D Object",
        "3D Object is wxStringProperty with value \"<composed>\". Two of its children are similar wxStringProperties with " ..
        "three wxVectorProperty children, and other two are custom wxTriangleProperties." )

    pid = pg:AppendIn( topId, wx.wxStringProperty("Triangle 3", "Triangle 3", "<composed>") )
    pg:AppendIn( pid, wx.wxVectorProperty( "A", wx.wxPG_LABEL ) )
    pg:AppendIn( pid, wx.wxVectorProperty( "B", wx.wxPG_LABEL ) )
    pg:AppendIn( pid, wx.wxVectorProperty( "C", wx.wxPG_LABEL ) )

    pg:AppendIn( topId, wx.wxTriangleProperty( "Triangle 4", "Triangle 4" ) )

    --//
    --// This snippet is a doc sample test
    --//
    local carProp = pg:Append(wx.wxStringProperty("Car", wx.wxPG_LABEL, "<composed>"))

    pg:AppendIn(carProp, wx.wxStringProperty("Model", wx.wxPG_LABEL, "Lamborghini Diablo SV"))
    pg:AppendIn(carProp, wx.wxIntProperty("Engine Size (cc)", wx.wxPG_LABEL, 5707) )

    local speedsProp = pg:AppendIn(carProp, wx.wxStringProperty("Speeds", wx.wxPG_LABEL, "<composed>"))

    pg:AppendIn( speedsProp, wx.wxIntProperty("Max. Speed (mph)", wx.wxPG_LABEL,290) )
    pg:AppendIn( speedsProp, wx.wxFloatProperty("0-100 mph (sec)", wx.wxPG_LABEL,3.9) )
    pg:AppendIn( speedsProp, wx.wxFloatProperty("1/4 mile (sec)", wx.wxPG_LABEL,8.6) )

    --// This is how child property can be referred to by name
    pg:SetPropertyValue( "Car.Speeds.Max. Speed (mph)", 300 )

    pg:AppendIn(carProp, wx.wxIntProperty("Price ($)", wx.wxPG_LABEL, 300000) )
    pg:AppendIn(carProp, wx.wxBoolProperty("Convertible", wx.wxPG_LABEL, false) )

    --// Displayed value of "Car" property is now very close to this:
    --// "Lamborghini Diablo SV5707 [3003.98.6] 300000"

    --//
    --// Test wxSampleMultiButtonEditor
    pg:Append( wx.wxLongStringProperty("MultipleButtons", wx.wxPG_LABEL) )
    pg:SetPropertyEditor("MultipleButtons", m_pSampleMultiButtonEditor )

    --// Test SingleChoiceProperty
    pg:Append( wx.SingleChoiceProperty("SingleChoiceProperty") )


    --//
    --// Test adding variable height bitmaps in wx.wxPGChoices
    local bc = wx.wxPGChoices()
    bc:Add("Wee", wx.wxArtProvider.GetBitmap(wx.wxART_CDROM, wx.wxART_OTHER, wx.wxSize(16, 16)))
    bc:Add("Not so wee", wx.wxArtProvider.GetBitmap(wx.wxART_FLOPPY, wx.wxART_OTHER, wx.wxSize(32, 32)))
    bc:Add("Friggin' huge", wx.wxArtProvider.GetBitmap(wx.wxART_HARDDISK, wx.wxART_OTHER, wx.wxSize(64, 64)))

    pg:Append( wx.wxEnumProperty("Variable Height Bitmaps", wx.wxPG_LABEL, bc, 0) )

    --//
    --// Test how non-editable composite strings appear
    pid = wx.wxStringProperty("wxWidgets Traits", wx.wxPG_LABEL, "<composed>")
    pg:SetPropertyReadOnly(pid)

    --//
    --// For testing purposes, combine two methods of adding children
    --//

    pid:AppendChild( wx.wxStringProperty("Latest Release", wx.wxPG_LABEL, "3.1.2"))
    pid:AppendChild( wx.wxBoolProperty("Win API", wx.wxPG_LABEL, true) )

    pg:Append( pid )

    pg:AppendIn(pid, wx.wxBoolProperty("QT", wx.wxPG_LABEL, true) )
    pg:AppendIn(pid, wx.wxBoolProperty("Cocoa", wx.wxPG_LABEL, true) )
    pg:AppendIn(pid, wx.wxBoolProperty("Haiku", wx.wxPG_LABEL, false) )
    pg:AppendIn(pid, wx.wxStringProperty("Trunk Version", wx.wxPG_LABEL, wx.wxVERSION_NUM_DOT_STRING))
    pg:AppendIn(pid, wx.wxBoolProperty("GTK+", wx.wxPG_LABEL, true) )
    pg:AppendIn(pid, wx.wxBoolProperty("Android", wx.wxPG_LABEL, false) )

    -- self:AddTestProperties(pg)
end

function FormMain:PopulateWithLibraryConfig()
    local pgman = self.m_pPropGridManager
    local pg = pgman:GetPage("wxWidgets Library Config")

    --// Set custom column proportions (here in the sample app we need
    --// to check if the grid has wx.wxPG_SPLITTER_AUTO_CENTER style. You usually
    --// need not to do it in your application).
    if pgman:HasFlag(wx.wxPG_SPLITTER_AUTO_CENTER) then
        pg:SetColumnProportion(0, 3)
        pg:SetColumnProportion(1, 1)
    end

    local cat, pid

    local bmp = wx.wxArtProvider.GetBitmap(wx.wxART_REPORT_VIEW)

    local italicFont = pgman:GetGrid():GetCaptionFont()
    italicFont:SetStyle(wx.wxFONTSTYLE_ITALIC)

    local italicFontHelp = "Font of this property's wx.wxPGCell has " ..
                              "been modified. Obtain property's cell " ..
                              "with wx.wxPGProperty::" ..
                              "GetOrCreateCell(column)."

    local function ADD_WX_LIB_CONF_GROUP(A)
       cat = pg:AppendIn( pid, wx.wxPropertyCategory(A) )
       pg:SetPropertyCell( cat, 0, wx.wxPG_LABEL, bmp )
       cat:GetCell(0):SetFont(italicFont)
       cat:SetHelpString(italicFontHelp)
    end

    local function ADD_WX_LIB_CONF(A)
       pg:Append( wx.wxBoolProperty(A,wx.wxPG_LABEL, not not wx[A]) )
    end

    local function ADD_WX_LIB_CONF_NODEF(A)
       pg:Append( wx.wxBoolProperty(A,wx.wxPG_LABEL,false) )
       pg:DisableProperty(A)
    end

    pid = pg:Append( wx.wxPropertyCategory( "wxWidgets Library Configuration" ) )
    pg:SetPropertyCell( pid, 0, wx.wxPG_LABEL, bmp )

    --// Both of following lines would set a label for the second column
    pg:SetPropertyCell( pid, 1, "Is Enabled" )
    pid:SetValue("Is Enabled")

    ADD_WX_LIB_CONF_GROUP("Global Settings")
    ADD_WX_LIB_CONF( "wxUSE_GUI" )

    ADD_WX_LIB_CONF_GROUP("Compatibility Settings")
--#if defined(WXWIN_COMPATIBILITY_2_8)
    ADD_WX_LIB_CONF( "WXWIN_COMPATIBILITY_2_8" )
--#endif
--#if defined(WXWIN_COMPATIBILITY_3_0)
    ADD_WX_LIB_CONF( "WXWIN_COMPATIBILITY_3_0" )
--#endif
--#ifdef wxFONT_SIZE_COMPATIBILITY
    ADD_WX_LIB_CONF( "wxFONT_SIZE_COMPATIBILITY" )
--#else
--    ADD_WX_LIB_CONF_NODEF ( "wxFONT_SIZE_COMPATIBILITY" )
--#endif
--#ifdef wxDIALOG_UNIT_COMPATIBILITY
    ADD_WX_LIB_CONF( "wxDIALOG_UNIT_COMPATIBILITY" )
--#else
--    ADD_WX_LIB_CONF_NODEF ( "wxDIALOG_UNIT_COMPATIBILITY" )
--#endif

    ADD_WX_LIB_CONF_GROUP("Debugging Settings")
    ADD_WX_LIB_CONF( "wxUSE_DEBUG_CONTEXT" )
    ADD_WX_LIB_CONF( "wxUSE_MEMORY_TRACING" )
    ADD_WX_LIB_CONF( "wxUSE_GLOBAL_MEMORY_OPERATORS" )
    ADD_WX_LIB_CONF( "wxUSE_DEBUG_NEW_ALWAYS" )
    ADD_WX_LIB_CONF( "wxUSE_ON_FATAL_EXCEPTION" )

    ADD_WX_LIB_CONF_GROUP("Unicode Support")
    ADD_WX_LIB_CONF( "wxUSE_UNICODE" )

    ADD_WX_LIB_CONF_GROUP("Global Features")
    ADD_WX_LIB_CONF( "wxUSE_EXCEPTIONS" )
    ADD_WX_LIB_CONF( "wxUSE_EXTENDED_RTTI" )
    ADD_WX_LIB_CONF( "wxUSE_STL" )
    ADD_WX_LIB_CONF( "wxUSE_LOG" )
    ADD_WX_LIB_CONF( "wxUSE_LOGWINDOW" )
    ADD_WX_LIB_CONF( "wxUSE_LOGGUI" )
    ADD_WX_LIB_CONF( "wxUSE_LOG_DIALOG" )
    ADD_WX_LIB_CONF( "wxUSE_CMDLINE_PARSER" )
    ADD_WX_LIB_CONF( "wxUSE_THREADS" )
    ADD_WX_LIB_CONF( "wxUSE_STREAMS" )
    ADD_WX_LIB_CONF( "wxUSE_STD_IOSTREAM" )

    ADD_WX_LIB_CONF_GROUP("Non-GUI Features")
    ADD_WX_LIB_CONF( "wxUSE_LONGLONG" )
    ADD_WX_LIB_CONF( "wxUSE_FILE" )
    ADD_WX_LIB_CONF( "wxUSE_FFILE" )
    ADD_WX_LIB_CONF( "wxUSE_FSVOLUME" )
    ADD_WX_LIB_CONF( "wxUSE_TEXTBUFFER" )
    ADD_WX_LIB_CONF( "wxUSE_TEXTFILE" )
    ADD_WX_LIB_CONF( "wxUSE_INTL" )
    ADD_WX_LIB_CONF( "wxUSE_DATETIME" )
    ADD_WX_LIB_CONF( "wxUSE_TIMER" )
    ADD_WX_LIB_CONF( "wxUSE_STOPWATCH" )
    ADD_WX_LIB_CONF( "wxUSE_CONFIG" )
--#ifdef wxUSE_CONFIG_NATIVE
    ADD_WX_LIB_CONF( "wxUSE_CONFIG_NATIVE" )
--#else
--    ADD_WX_LIB_CONF_NODEF ( "wxUSE_CONFIG_NATIVE" )
--#endif
    ADD_WX_LIB_CONF( "wxUSE_DIALUP_MANAGER" )
    ADD_WX_LIB_CONF( "wxUSE_DYNLIB_CLASS" )
    ADD_WX_LIB_CONF( "wxUSE_DYNAMIC_LOADER" )
    ADD_WX_LIB_CONF( "wxUSE_SOCKETS" )
    ADD_WX_LIB_CONF( "wxUSE_FILESYSTEM" )
    ADD_WX_LIB_CONF( "wxUSE_FS_ZIP" )
    ADD_WX_LIB_CONF( "wxUSE_FS_INET" )
    ADD_WX_LIB_CONF( "wxUSE_ZIPSTREAM" )
    ADD_WX_LIB_CONF( "wxUSE_ZLIB" )
    ADD_WX_LIB_CONF( "wxUSE_APPLE_IEEE" )
    ADD_WX_LIB_CONF( "wxUSE_JOYSTICK" )
    ADD_WX_LIB_CONF( "wxUSE_FONTMAP" )
    ADD_WX_LIB_CONF( "wxUSE_MIMETYPE" )
    ADD_WX_LIB_CONF( "wxUSE_PROTOCOL" )
    ADD_WX_LIB_CONF( "wxUSE_PROTOCOL_FILE" )
    ADD_WX_LIB_CONF( "wxUSE_PROTOCOL_FTP" )
    ADD_WX_LIB_CONF( "wxUSE_PROTOCOL_HTTP" )
    ADD_WX_LIB_CONF( "wxUSE_URL" )
--#ifdef wxUSE_URL_NATIVE
    ADD_WX_LIB_CONF( "wxUSE_URL_NATIVE" )
--#else
--    ADD_WX_LIB_CONF_NODEF ( "wxUSE_URL_NATIVE" )
--#endif
    ADD_WX_LIB_CONF( "wxUSE_REGEX" )
    ADD_WX_LIB_CONF( "wxUSE_SYSTEM_OPTIONS" )
    ADD_WX_LIB_CONF( "wxUSE_SOUND" )
--#ifdef wxUSE_XRC
    ADD_WX_LIB_CONF( "wxUSE_XRC" )
--#else
--    ADD_WX_LIB_CONF_NODEF ( "wxUSE_XRC" )
--#endif
    ADD_WX_LIB_CONF( "wxUSE_XML" )

    --// Set them to use check box.
    pg:SetPropertyAttribute(pid,wx.wxPG_BOOL_USE_CHECKBOX,true,wx.wxPG_RECURSE)
end

function FormMain:PopulateGrid()
    local pgman = self.m_pPropGridManager
    pgman:AddPage("Standard Items")

    self:PopulateWithStandardItems()

    pgman:AddPage("wxWidgets Library Config")

    self:PopulateWithLibraryConfig()

    -- local myPage = wxMyPropertyGridPage()
    -- myPage:Append( wx.wxIntProperty ( "IntProperty", wxPG_LABEL, 12345678 ) )

    --// Use wxMyPropertyGridPage (see above) to test the
    --// custom wxPropertyGridPage feature.
    -- pgman:AddPage("Examples",wx.wxNullBitmap,myPage)

    -- self:PopulateWithExamples()
end

function FormMain:CreateGrid(style, extraStyle)
   if style == -1 then
      --// default style
      style = wx.wxPG_BOLD_MODIFIED +
         wx.wxPG_SPLITTER_AUTO_CENTER +
         wx.wxPG_AUTO_SORT +
         --//wx.wxPG_HIDE_MARGIN + wx.wxPG_STATIC_SPLITTER +
         --//wx.wxPG_TOOLTIPS +
         --//wx.wxPG_HIDE_CATEGORIES +
         --//wx.wxPG_LIMITED_EDITING +
         wx.wxPG_TOOLBAR +
         wx.wxPG_DESCRIPTION
   end

   if extraStyle == -1 then
      --// default extra style
      extraStyle = wx.wxPG_EX_MODE_BUTTONS +
         -- #if wxALWAYS_NATIVE_DOUBLE_BUFFER
         wx.wxPG_EX_NATIVE_DOUBLE_BUFFERING +
         -- #endif // wxALWAYS_NATIVE_DOUBLE_BUFFER
         wx.wxPG_EX_MULTIPLE_SELECTION
      --//+ wx.wxPG_EX_AUTO_UNSPECIFIED_VALUES
      --//+ wx.wxPG_EX_GREY_LABEL_WHEN_DISABLED
      --//+ wx.wxPG_EX_HELP_AS_TOOLTIPS
   end

   self.m_combinedFlags:Add(_fs_windowstyle_labels, _fs_windowstyle_values)
   self.m_combinedFlags:Add(_fs_framestyle_labels, _fs_framestyle_values)

   local pgman = wx.wxPropertyGridManager(self.m_panel, FormMain.PGID, wx.wxDefaultPosition, wx.wxDefaultSize, style)
   self.m_pPropGridManager = pgman

   self.m_propGrid = pgman:GetGrid()

   pgman:SetExtraStyle(extraStyle)

   self.m_pPropGridManager:SetValidationFailureBehavior(wx.wxPG_VFB_MARK_CELL + wx.wxPG_VFB_SHOW_MESSAGEBOX)

   self.m_pPropGridManager:GetGrid():SetVerticalSpacing(2)

   local cell = wx.wxPGCell()
   cell:SetText("Unspecified")
   cell:SetFgCol(wx.wxLIGHT_GREY)
   self.m_propGrid:SetUnspecifiedValueAppearance(cell)

   self:PopulateGrid()

   self.m_propGrid:MakeColumnEditable(0, self.m_labelEditingEnabled)
   self.m_pPropGridManager:ShowHeader(self.m_hasHeader)
   if self.m_hasHeader then
      self.m_pPropGridManager:SetColumnTitle(2, "Units")
   end

   --// Change some attributes in all properties
   --//pgman:SetPropertyAttributeAll(self.wxPG_BOOL_USE_DOUBLE_CLICK_CYCLING,true)

   --//self.m_pPropGridManager:SetSplitterLeft(true)
   --//self.m_pPropGridManager:SetSplitterPosition(137)
end

function FormMain:ReplaceGrid(style, extraStyle)
    local pgmanOld = self.m_pPropGridManager
    self:CreateGrid(style, extraStyle)
    self.m_topSizer:Replace(pgmanOld, self.m_pPropGridManager)
    pgmanOld:Destroy()
    self.m_pPropGridManager:SetFocus()

    self.m_panel:Layout()
end

function FormMain:create(parent, id, title, pos, size, style)
   local frameSize = wx.wxSize((wx.wxSystemSettings.GetMetric(wx.wxSYS_SCREEN_X) / 10) * 4,
      (wx.wxSystemSettings.GetMetric(wx.wxSYS_SCREEN_Y) / 10) * 8)

   if frameSize:GetWidth() > 500 then
      frameSize:SetWidth(500)
   end

   self.this = wx.wxFrame(wx.NULL,
                            wx.wxID_ANY,
                            wxT("wxPropertyGrid Sample"),
                            wx.wxPoint(0, 0),
                            frameSize)

   local this = self.this

   local bitmap = wx.wxBitmap(sample_xpm)
   local icon = wx.wxIcon()
   icon:CopyFromBitmap(bitmap)
   this:SetIcon(icon)
   bitmap:delete()
   icon:delete()

   this:Centre()

   --// Create menu bar
   local menuFile = wx.wxMenu("", wx.wxMENU_TEAROFF)
   local menuTry = wx.wxMenu()
   local menuTools1 = wx.wxMenu()
   local menuTools2 = wx.wxMenu()
   local menuHelp = wx.wxMenu()

   menuHelp:Append(FormMain.ID_ABOUT, "&About", "Show about dialog" )

   menuTools1:Append(FormMain.ID_APPENDPROP, "Append New Property" )
   menuTools1:Append(FormMain.ID_APPENDCAT, "Append New Category\tCtrl-S" )
   menuTools1:AppendSeparator()
   menuTools1:Append(FormMain.ID_INSERTPROP, "Insert New Property\tCtrl-I" )
   menuTools1:Append(FormMain.ID_INSERTCAT, "Insert New Category\tCtrl-W" )
   menuTools1:AppendSeparator()
   menuTools1:Append(FormMain.ID_DELETE, "Delete Selected" )
   menuTools1:Append(FormMain.ID_DELETER, "Delete Random" )
   menuTools1:Append(FormMain.ID_DELETEALL, "Delete All" )
   menuTools1:AppendSeparator()
   menuTools1:Append(FormMain.ID_SETBGCOLOUR, "Set Bg Colour" )
   menuTools1:Append(FormMain.ID_SETBGCOLOURRECUR, "Set Bg Colour (Recursively)" )
   menuTools1:Append(FormMain.ID_UNSPECIFY, "Set Value to Unspecified")
   menuTools1:AppendSeparator()
   this.m_itemEnable = menuTools1:Append(FormMain.ID_ENABLE, "Enable", "Toggles item's enabled state." )
   this.m_itemEnable:Enable( false )
   menuTools1:Append(FormMain.ID_HIDE, "Hide", "Hides a property" )
   menuTools1:Append(FormMain.ID_SETREADONLY, "Set as Read-Only", "Set property as read-only" )

   menuTools2:Append(FormMain.ID_ITERATE1, "Iterate Over Properties" )
   menuTools2:Append(FormMain.ID_ITERATE2, "Iterate Over Visible Items" )
   menuTools2:Append(FormMain.ID_ITERATE3, "Reverse Iterate Over Properties" )
   menuTools2:Append(FormMain.ID_ITERATE4, "Iterate Over Categories" )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_ONEXTENDEDKEYNAV, "Extend Keyboard Navigation",
                     "This will set Enter to navigate to next property, " ..
                     "and allows arrow keys to navigate even when in " ..
                     "editor control.")
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_SETPROPERTYVALUE, "Set Property Value" )
   menuTools2:Append(FormMain.ID_CLEARMODIF, "Clear Modified Status", "Clears wxPG_MODIFIED flag from all properties." )
   menuTools2:AppendSeparator()
   this.m_itemFreeze = menuTools2:AppendCheckItem(FormMain.ID_FREEZE, "Freeze", "Disables painting, auto-sorting, etc." )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_DUMPLIST, "Display Values as wxVariant List", "Tests GetAllValues method and wxVariant conversion." )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_GETVALUES, "Get Property Values", "Stores all property values." )
   menuTools2:Append(FormMain.ID_SETVALUES, "Set Property Values", "Reverts property values to those last stored." )
   menuTools2:Append(FormMain.ID_SETVALUES2, "Set Property Values 2", "Adds property values that should not initially be as items (so new items are created)." )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_SAVESTATE, "Save Editable State" )
   menuTools2:Append(FormMain.ID_RESTORESTATE, "Restore Editable State" )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_ENABLECOMMONVALUES, "Enable Common Value", "Enable values that are common to all properties, for selected property.")
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_COLLAPSE, "Collapse Selected" )
   menuTools2:Append(FormMain.ID_COLLAPSEALL, "Collapse All" )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_INSERTPAGE, "Add Page" )
   menuTools2:Append(FormMain.ID_REMOVEPAGE, "Remove Page" )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_FITCOLUMNS, "Fit Columns" )
   this.m_itemVetoDragging = menuTools2:AppendCheckItem(FormMain.ID_VETOCOLDRAG, "Veto Column Dragging")
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_CHANGEFLAGSITEMS, "Change Children of FlagsProp" )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_TESTINSERTCHOICE, "Test InsertPropertyChoice" )
   menuTools2:Append(FormMain.ID_TESTDELETECHOICE, "Test DeletePropertyChoice" )
   menuTools2:AppendSeparator()
   menuTools2:Append(FormMain.ID_SETSPINCTRLEDITOR, "Use SpinCtrl Editor" )
   menuTools2:Append(FormMain.ID_TESTREPLACE, "Test ReplaceProperty" )

   menuTry:Append(FormMain.ID_SELECTSTYLE, "Set Window Style",
                  "Select window style flags used by the grid.")
   menuTry:AppendCheckItem(FormMain.ID_ENABLELABELEDITING, "Enable label editing",
                           "This calls wxPropertyGrid::MakeColumnEditable(0)")
   menuTry:Check(FormMain.ID_ENABLELABELEDITING, m_labelEditingEnabled)
   --#if wxUSE_HEADERCTRL
   menuTry:AppendCheckItem(FormMain.ID_SHOWHEADER,
                           "Enable header",
                           "This calls wxPropertyGridManager::ShowHeader()")
   menuTry:Check(FormMain.ID_SHOWHEADER, m_hasHeader)
   --#endif // wxUSE_HEADERCTRL
   menuTry:AppendSeparator()
   menuTry:AppendRadioItem( FormMain.ID_COLOURSCHEME1, "Standard Colour Scheme" )
   menuTry:AppendRadioItem( FormMain.ID_COLOURSCHEME2, "White Colour Scheme" )
   menuTry:AppendRadioItem( FormMain.ID_COLOURSCHEME3, ".NET Colour Scheme" )
   menuTry:AppendRadioItem( FormMain.ID_COLOURSCHEME4, "Cream Colour Scheme" )
   menuTry:AppendSeparator()
   this.m_itemCatColours = menuTry:AppendCheckItem(FormMain.ID_CATCOLOURS, "Category Specific Colours",
                                                   "Switches between category-specific cell colours and default scheme (actually done using SetPropertyTextColour and SetPropertyBackgroundColour)." )
   menuTry:AppendSeparator()
   menuTry:AppendCheckItem(FormMain.ID_STATICLAYOUT, "Static Layout",
                           "Switches between user-modifiable and static layouts." )
   menuTry:AppendCheckItem(FormMain.ID_BOOL_CHECKBOX, "Render Boolean values as checkboxes",
                           "Renders Boolean values as checkboxes")
   menuTry:Append(FormMain.ID_SETCOLUMNS, "Set Number of Columns" )
   menuTry:Append(FormMain.ID_SETVIRTWIDTH, "Set Virtual Width")
   menuTry:AppendCheckItem(FormMain.ID_SETPGDISABLED, "Disable Grid")
   menuTry:AppendSeparator()
   menuTry:Append(FormMain.ID_TESTXRC, "Display XRC sample" )

   menuFile:Append(FormMain.ID_RUNMINIMAL, "Run Minimal Sample" )
   menuFile:AppendSeparator()
   menuFile:Append(FormMain.ID_RUNTESTFULL, "Run Tests (full)" )
   menuFile:Append(FormMain.ID_RUNTESTPARTIAL, "Run Tests (fast)" )
   menuFile:AppendSeparator()
   menuFile:Append(FormMain.ID_QUIT, "E&xit\tAlt-X", "Quit this program" )

   --// Now append the freshly created menu to the menu bar...
   local menuBar = wx.wxMenuBar()
   menuBar:Append(menuFile, "&File" )
   menuBar:Append(menuTry, "&Try These!" )
   menuBar:Append(menuTools1, "&Basic" )
   menuBar:Append(menuTools2, "&Advanced" )
   menuBar:Append(menuHelp, "&Help" )

   this:SetMenuBar(menuBar)

   --#if wxUSE_STATUSBAR
   --// create a status bar
   this:CreateStatusBar(1)
   this:SetStatusText("")
   --#endif // wxUSE_STATUSBAR

   --// Register all editors (SpinCtrl etc.)
   wx.wxPropertyGridInterface.RegisterAdditionalEditors()

   --// Register our sample custom editors
   -- this.m_pSampleMultiButtonEditor =
   --     wxPropertyGrid::RegisterEditorClass(new wxSampleMultiButtonEditor())

   self.m_panel = wx.wxPanel(this, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTAB_TRAVERSAL)

   self:CreateGrid( --// style
      wx.wxPG_BOLD_MODIFIED +
      wx.wxPG_SPLITTER_AUTO_CENTER +
      wx.wxPG_AUTO_SORT +
      --//wx.wxPG_HIDE_MARGIN + wx.wxPG_STATIC_SPLITTER +
      --//wx.wxPG_TOOLTIPS +
      --//wx.wxPG_HIDE_CATEGORIES +
      --//wx.wxPG_LIMITED_EDITING +
      wx.wxPG_TOOLBAR +
      wx.wxPG_DESCRIPTION,
      --// extra style
      --#if wxALWAYS_NATIVE_DOUBLE_BUFFER
      wx.wxPG_EX_NATIVE_DOUBLE_BUFFERING +
      --#endif // wxALWAYS_NATIVE_DOUBLE_BUFFER
      wx.wxPG_EX_MODE_BUTTONS +
      wx.wxPG_EX_MULTIPLE_SELECTION
      --//+ wx.wxPG_EX_AUTO_UNSPECIFIED_VALUES
      --//+ wx.wxPG_EX_GREY_LABEL_WHEN_DISABLED
      --//+ wx.wxPG_EX_HELP_AS_TOOLTIPS
   )

   self.m_topSizer = wx.wxBoxSizer(wx.wxVERTICAL)
   self.m_topSizer:Add(self.m_pPropGridManager, wx.wxSizerFlags(1):Expand())

   local btnSizer = wx.wxBoxSizer(wx.wxHORIZONTAL)
   btnSizer:Add(wx.wxButton(self.m_panel, wx.wxID_ANY, "Should be able to move here with Tab"),
                wx.wxSizerFlags(1):Border(wx.wxALL, 10))
   btnSizer:Add(wx.wxButton(self.m_panel, FormMain.ID_SHOWPOPUP, "Show Popup"),
                wx.wxSizerFlags(1):Border(wx.wxALL, 10))
   self.m_topSizer:Add(btnSizer, wx.wxSizerFlags(0):Border(wx.wxALL, 5):Expand())

   self.m_panel:SetSizer(self.m_topSizer)
   self.m_topSizer:SetSizeHints(self.m_panel)

   self.m_panel:Layout()

   -- #if wxUSE_LOGWINDOW
   --// Create log window
   self.m_logWindow = wx.wxLogWindow(this, "Log Messages", false)
   self.m_logWindow:GetFrame():Move(this:GetPosition():GetX() + this:GetSize():GetWidth() + 10,
                                    this:GetPosition():GetY())
   self.m_logWindow:Show()
   -- #endif

   return this
end

local function main()
   local frame = FormMain:create()
   frame:Show()
   wx.wxLog.SetVerbose(true)
   wx.wxGetApp():MainLoop()
end

main()
