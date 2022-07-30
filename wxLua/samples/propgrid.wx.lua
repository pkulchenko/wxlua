--[[
/////////////////////////////////////////////////////////////////////////////
// Name:        samples/propgrid/propgrid.cpp
// Purpose:     wxPropertyGrid sample
// Author:      Jaakko Salli
// Modified by:
// Created:     2004-09-25
// Copyright:   (c) Jaakko Salli
// Licence:     wxWindows licence
/////////////////////////////////////////////////////////////////////////////
--]]

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
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

-- ---------------------------------------------------------------------------
-- return the path part of the currently executing file
function GetExePath()
   local function findLast(filePath) -- find index of last / or \ in string
      local lastOffset = nil
      local offset = nil
      repeat
         offset = string.find(filePath, "\\") or string.find(filePath, "/")

         if offset then
            lastOffset = (lastOffset or 0) + offset
            filePath = string.sub(filePath, offset + 1)
         end
      until not offset

      return lastOffset
   end

   local filePath = debug.getinfo(1, "S").source

   if string.byte(filePath) == string.byte('@') then
      local offset = findLast(filePath)
      if offset ~= nil then
         -- remove the @ at the front up to just before the path separator
         filePath = string.sub(filePath, 2, offset - 1)
      else
         filePath = "."
      end
   else
      filePath = wx.wxGetCwd()
   end

   return filePath
end

-------------------------------------------------------------------------

local wxT = function(s) return s end
local _ = function(s) return s end

local IDCounter = nil
local function NewID()
   if not IDCounter then IDCounter = wx.wxID_HIGHEST end
   IDCounter = IDCounter + 1
   return IDCounter
end


local MyApp = {}

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

   m_storedValues = wx.wxVariant(),

   m_savedState = "",
   m_hasHeader = false,
   m_labelEditingEnabled = false
}

-------------------------------------------------------------------------

function FormMain:OnMove(event)
   if self.m_pPropGridManager == nil then
      --// this check is here so the frame layout can be tested
      --// without creating propertygrid
      event:Skip()
      return
   end

    --// Update position properties
   local pos = self.this:GetPosition()
   local x = pos:GetX()
   local y = pos:GetY()

   local id

   --// Must check if properties exist (as they may be deleted).

   --// Using m_pPropGridManager, we can scan all pages automatically.
   id = self.m_pPropGridManager:GetPropertyByName( "X" )
   if id then
      self.m_pPropGridManager:SetPropertyValue( id, x )
   end

   id = self.m_pPropGridManager:GetPropertyByName( "Y" )
   if id then
      self.m_pPropGridManager:SetPropertyValue( id, y )
   end

   id = self.m_pPropGridManager:GetPropertyByName( "Position" )
   if id then
      selfm_pPropGridManager:SetPropertyValue( id, wx.wxVariant(wx.wxPoint(x,y)) )
   end

   --// Should always call event:Skip() in frame's MoveEvent handler
   event:Skip()
end

-------------------------------------------------------------------------

function FormMain:OnResize(event)
   if self.m_pPropGridManager == nil then
      --// this check is here so the frame layout can be tested
      --// without creating propertygrid
      event:Skip()
      return
   end

   --// Update size properties
   local size = self.this:GetSize()
   local w = size:GetWidth()
   local h = size:GetHeight()

   local id, p

   --// Must check if properties exist (as they may be deleted).

   --// Using m_pPropGridManager, we can scan all pages automatically.
   p = self.m_pPropGridManager:GetPropertyByName( "Width" )
   if p and not p:IsValueUnspecified() then
      self.m_pPropGridManager:SetPropertyValue( p, w )
   end

   p = self.m_pPropGridManager:GetPropertyByName( "Height" )
   if p and not p:IsValueUnspecified() then
      self.m_pPropGridManager:SetPropertyValue( p, h )
   end

   id = self.m_pPropGridManager:GetPropertyByName ( "Size" )
   if id then
      self.m_pPropGridManager:SetPropertyValue( id, wx.wxVariant(wx.wxSize(w,h)) )
   end

   --// Should always call event:Skip() in frame's SizeEvent handler
   event:Skip()
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridChanging(event)
   local p = event:GetProperty()

   if p:GetName() == "Font" then
      local res = wx.wxMessageBox(
         ("'%s' is about to change (to variant of type '%s')\n\nAllow or deny?")
         :format(p:GetName(), event:GetValue():GetType()),
         "Testing wxEVT_PG_CHANGING", wx.wxYES_NO, self.m_pPropGridManager)

      if res == wx.wxNO then
         -- wxASSERT(event:CanVeto())
         event:Veto()
         event:SetValidationFailureBehavior(0)
      end
   end
end

-------------------------------------------------------------------------

local pwdMode = 0

function FormMain:OnPropertyGridChange(event)
   local this = self.this
   local property = event:GetProperty()
   local name = property:GetName()

   --// Properties store values internally as wxVariants, but it is preferred
   --// to use the more modern wxAny at the interface level
   local value = property:GetValue()

   --// Don't handle 'unspecified' values
   if value:IsNull() then
      return
   end

   --// Some settings are disabled outside Windows platform
   if name == "X" then
      this:SetSize(value:GetLong(), -1, -1, -1, wx.wxSIZE_USE_EXISTING)
   elseif name == "Y" then
      this:SetSize(-1, value:GetLong(), -1, -1, wx.wxSIZE_USE_EXISTING)
   elseif name == "Width" then
      this:SetSize(-1, -1, value:GetLong(), -1, wx.wxSIZE_USE_EXISTING)
   elseif name == "Height" then
      this:SetSize(-1, -1, -1, value:GetLong(), wx.wxSIZE_USE_EXISTING)
   elseif name == "Label" then
      this:SetTitle(value:GetString())
   elseif name == "Password" then
      pwdMode = value:GetLong()
      self.m_pPropGridManager:SetPropertyAttribute(property, wx.wxPG_STRING_PASSWORD, pwdMode)
   elseif name == "Font" then
      local font = wx.wxFont.FromVariant(value)
      self.m_pPropGridManager:SetFont(font)
   elseif name == "Margin Colour" then
      local cpv = wx.wxColourPropertyValue.FromVariant(value)
      self.m_pPropGridManager:GetGrid():SetMarginColour( cpv.m_colour );
   elseif name == "Cell Colour" then
      local cpv = wx.wxColourPropertyValue.FromVariant(value)
      self.m_pPropGridManager:GetGrid():SetCellBackgroundColour( cpv.m_colour );
   elseif name == "Line Colour" then
      local cpv = wx.wxColourPropertyValue.FromVariant(value)
      self.m_pPropGridManager:GetGrid():SetLineColour( cpv.m_colour );
   elseif name == "Cell Text Colour" then
      local cpv = wx.wxColourPropertyValue.FromVariant(value)
      self.m_pPropGridManager:GetGrid():SetCellTextColour( cpv.m_colour );
   end
end

-------------------------------------------------------------------------

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
   local sb = self.this:GetStatusBar()
   if prop then
      local text = ("Selected: %s"):format(self.m_pPropGridManager:GetPropertyLabel(prop))
      sb:SetStatusText(text)
   end
   -- #endif --// wsxUSE_STATUSBAR
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridPageChange(_)
   -- #if wxUSE_STATUSBAR
   local sb = self.this:GetStatusBar()
   local text = ("Page Changed: %s"):format(self.m_pPropGridManager:GetPageName(self.m_pPropGridManager:GetSelectedPage()))
   sb:SetStatusText(text)
   -- #endif --// wsxUSE_STATUSBAR
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridLabelEditBegin(event)
   wx.wxLogMessage(("wxPG_EVT_LABEL_EDIT_BEGIN(%s)"):format(event:GetProperty():GetLabel()))
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridLabelEditEnding(event)
   wx.wxLogMessage(("wxPG_EVT_LABEL_EDIT_ENDING(%s)"):format(event:GetProperty():GetLabel()))
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridHighlight(_)
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridItemRightClick(event)
   -- #if wxUSE_STATUSBAR
   local prop = event:GetProperty()
   local sb = self.this:GetStatusBar()
   if prop then
      local text = ("Right-clicked: %s, name=%s"):format(prop:GetLabel(), self.m_pPropGridManager:GetPropertyName(prop))
      sb:SetStatusText(text)
   else
      sb:SetStatusText("")
   end
   -- #endif --// wsxUSE_STATUSBAR
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridItemDoubleClick(event)
   -- #if wxUSE_STATUSBAR
   local prop = event:GetProperty()
   local sb = self.this:GetStatusBar()
   if prop then
      local text = ("Double-clicked: %s, name=%s"):format(prop:GetLabel(), self.m_pPropGridManager:GetPropertyName(prop))
      sb:SetStatusText(text)
   else
      sb:SetStatusText("")
   end
   -- #endif --// wsxUSE_STATUSBAR
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridButtonClick(_)
   -- #if wxUSE_STATUSBAR
   local prop = self.m_pPropGridManager:GetSelection()
   local sb = self.this:GetStatusBar()
   if prop then
      local text = ("Button clicked: %s, name=%s"):format(self.m_pPropGridManager:GetPropertyLabel(prop),
                                                          self.m_pPropGridManager:GetPropertyName(prop))
      sb:SetStatusText(text)
   else
      sb:SetStatusText("SHOULD NOT HAPPEN!!!")
   end
   -- #endif --// wsxUSE_STATUSBAR
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridItemCollapse(_)
   wx.wxLogMessage("Item was Collapsed")
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridItemExpand(_)
   wx.wxLogMessage("Item was Expanded")
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridColBeginDrag(event)
   if self.m_itemVetoDragging:IsChecked() then
      wx.wxLogDebug(("Splitter %d resize was vetoed"):format(event:GetColumn()))
      event:Veto()
   else
      wx.wxLogDebug(("Splitter %d resize began"):format(event:GetColumn()))
   end
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridColDragging(_)
    --// For now, let's not spam the log output
    --//wx.wxLogDebug("Splitter %d is being resized", event:GetColumn())
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridColEndDrag(event)
   wx.wxLogDebug(("Splitter %d resize ended"):format(event:GetColumn()))
end

-------------------------------------------------------------------------

--// EVT_TEXT handling
function FormMain:OnPropertyGridTextUpdate(event)
   event:Skip()
end

-------------------------------------------------------------------------

function FormMain:OnPropertyGridKeyEvent(_)
    --// Occurs on wxGTK mostly, but not wxMSW.
end

-------------------------------------------------------------------------

function FormMain:OnLabelTextChange(_)
--// Uncomment following to allow property label modify in real-time
--//    local p = self.m_pPropGridManager:GetGrid():GetSelection()
--//    if not p:IsOk() then return end
--//    self.m_pPropGridManager:SetPropertyLabel( p, self.m_tcPropLabel:DoGetValue() )
end

-------------------------------------------------------------------------

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

function FormMain:OnTestXRC(_)
   wx.wxMessageBox("Sorry, not yet implemented")
end

function FormMain:OnEnableCommonValues(_)
   local prop = self.m_pPropGridManager:GetSelection()
   if prop then
      prop:EnableCommonValue()
   else
      wx.wxMessageBox("First select a property")
   end
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

   --// Let's demonstrate 'Units' attribute here

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

--[[ FIXME
   pg:Append( wx.wxFontDataProperty( "FontDataProperty", wx.wxPG_LABEL) )
   pg:SetPropertyHelpString( "FontDataProperty",
       "This demonstrates wxFontDataProperty class defined in this sample app. " ..
       "It is exactly like wxFontProperty from the library, but also has colour sub-property."
       )

   pg:Append( wx.wxDirsProperty("DirsProperty",wx.wxPG_LABEL) )
   pg:SetPropertyHelpString( "DirsProperty",
       "This demonstrates wxDirsProperty class defined in this sample app. " ..
       "It is built with WX_PG_IMPLEMENT_ARRAYSTRING_PROPERTY_WITH_VALIDATOR macro, " ..
       "with custom action (dir dialog popup) defined."
       )

   local arrdbl = { -1.0, -0.5, 0.0, 0.5, 1.0 }

   pg:Append( wx.wxArrayDoubleProperty("ArrayDoubleProperty",wx.wxPG_LABEL,arrdbl) )
   --//pg:SetPropertyAttribute("ArrayDoubleProperty",wx.wxPG_FLOAT_PRECISION,2L)
   pg:SetPropertyHelpString( "ArrayDoubleProperty",
       "This demonstrates wxArrayDoubleProperty class defined in this sample app. " ..
       "It is an example of a custom list editor property."
       )
--]]

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
   local it = pg:GetGrid():GetIterator()
   local bmp = wx.wxArtProvider.GetBitmap(wx.wxART_FOLDER)

   while not it:AtEnd() do
      local p = it:op_deref()
      if not p:IsCategory() then
         pg:SetPropertyCell( p, 3, "Cell 3", bmp )
         pg:SetPropertyCell( p, 4, "Cell 4", wx.wxNullBitmap, wx.wxWHITE, wx.wxBLACK )
      end
      it:op_inc()
   end
--]]
end

-------------------------------------------------------------------------

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
   pg:SetPropertyEditor("MultipleButtons", self.m_pSampleMultiButtonEditor )

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

-------------------------------------------------------------------------

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

-------------------------------------------------------------------------

function FormMain:PopulateGrid()
   local pgman = self.m_pPropGridManager
   pgman:AddPage("Standard Items")

   self:PopulateWithStandardItems()

--[[ FIXME
   pgman:AddPage("wxWidgets Library Config")

   self:PopulateWithLibraryConfig()

   local myPage = wxMyPropertyGridPage()
   myPage:Append( wx.wxIntProperty ( "IntProperty", wxPG_LABEL, 12345678 ) )

   --// Use wxMyPropertyGridPage (see above) to test the
   --// custom wxPropertyGridPage feature.
   pgman:AddPage("Examples",wx.wxNullBitmap,myPage)

   self:PopulateWithExamples()
--]]
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
         -- #endif --// wxALWAYS_NATIVE_DOUBLE_BUFFER
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

-------------------------------------------------------------------------

function FormMain:create()
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
   self.m_itemEnable = menuTools1:Append(FormMain.ID_ENABLE, "Enable", "Toggles item's enabled state." )
   self.m_itemEnable:Enable( false )
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
   self.m_itemFreeze = menuTools2:AppendCheckItem(FormMain.ID_FREEZE, "Freeze", "Disables painting, auto-sorting, etc." )
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
   self.m_itemVetoDragging = menuTools2:AppendCheckItem(FormMain.ID_VETOCOLDRAG, "Veto Column Dragging")
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
   menuTry:Check(FormMain.ID_ENABLELABELEDITING, self.m_labelEditingEnabled)
   --#if wxUSE_HEADERCTRL
   menuTry:AppendCheckItem(FormMain.ID_SHOWHEADER,
                           "Enable header",
                           "This calls wxPropertyGridManager::ShowHeader()")
   menuTry:Check(FormMain.ID_SHOWHEADER, self.m_hasHeader)
   --#endif --// wxUSE_HEADERCTRL
   menuTry:AppendSeparator()
   menuTry:AppendRadioItem( FormMain.ID_COLOURSCHEME1, "Standard Colour Scheme" )
   menuTry:AppendRadioItem( FormMain.ID_COLOURSCHEME2, "White Colour Scheme" )
   menuTry:AppendRadioItem( FormMain.ID_COLOURSCHEME3, ".NET Colour Scheme" )
   menuTry:AppendRadioItem( FormMain.ID_COLOURSCHEME4, "Cream Colour Scheme" )
   menuTry:AppendSeparator()
   self.m_itemCatColours = menuTry:AppendCheckItem(FormMain.ID_CATCOLOURS, "Category Specific Colours",
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
   --#endif --// wxUSE_STATUSBAR

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
      --#endif --// wxALWAYS_NATIVE_DOUBLE_BUFFER
      wx.wxPG_EX_MODE_BUTTONS +
      wx.wxPG_EX_MULTIPLE_SELECTION
      --//+ wx.wxPG_EX_AUTO_UNSPECIFIED_VALUES
      --//+ wx.wxPG_EX_GREY_LABEL_WHEN_DISABLED
      --//+ wx.wxPG_EX_HELP_AS_TOOLTIPS
   )

   self.m_topSizer = wx.wxBoxSizer(wx.wxVERTICAL)
   self.m_topSizer:Add(self.m_pPropGridManager, wx.wxSizerFlags(1):Expand())

   --// Button for tab traversal testing
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

   local function Connect(id, evt, cb)
      if cb == nil then
         cb = evt
         evt = id
         assert(cb)
         this:Connect(evt, function(event) cb(self, event) end)
      else
         assert(cb)
         this:Connect(id, evt, function(event) cb(self, event) end)
      end
   end

   Connect(wx.wxEVT_IDLE, self.OnIdle)
   Connect(wx.wxEVT_MOVE, self.OnMove)
   Connect(wx.wxEVT_SIZE, self.OnResize)

   --// This occurs when a property is selected
   Connect(self.PGID, wx.wxEVT_PG_SELECTED, self.OnPropertyGridSelect)
   --// This occurs when a property value changes
   Connect(self.PGID, wx.wxEVT_PG_CHANGED, self.OnPropertyGridChange)
   --// This occurs just prior a property value is changed
   Connect(self.PGID, wx.wxEVT_PG_CHANGING, self.OnPropertyGridChanging)
   --// This occurs when a mouse moves over another property
   Connect(self.PGID, wx.wxEVT_PG_HIGHLIGHTED, self.OnPropertyGridHighlight)
   --// This occurs when mouse is right-clicked.
   Connect(self.PGID, wx.wxEVT_PG_RIGHT_CLICK, self.OnPropertyGridItemRightClick)
   --// This occurs when mouse is double-clicked.
   Connect(self.PGID, wx.wxEVT_PG_DOUBLE_CLICK, self.OnPropertyGridItemDoubleClick)
   --// This occurs when propgridmanager's page changes.
   Connect(self.PGID, wx.wxEVT_PG_PAGE_CHANGED, self.OnPropertyGridPageChange)
   --// This occurs when user starts editing a property label
   Connect(self.PGID, wx.wxEVT_PG_LABEL_EDIT_BEGIN, self.OnPropertyGridLabelEditBegin)
   --// This occurs when user stops editing a property label
   Connect(self.PGID, wx.wxEVT_PG_LABEL_EDIT_ENDING, self.OnPropertyGridLabelEditEnding)
   --// This occurs when property's editor button (if any) is clicked.
   Connect(self.PGID, wx.wxEVT_BUTTON, self.OnPropertyGridButtonClick)

   Connect(self.PGID, wx.wxEVT_PG_ITEM_COLLAPSED, self.OnPropertyGridItemCollapse)
   Connect(self.PGID, wx.wxEVT_PG_ITEM_EXPANDED, self.OnPropertyGridItemExpand)

   Connect(self.PGID, wx.wxEVT_PG_COL_BEGIN_DRAG, self.OnPropertyGridColBeginDrag)
   Connect(self.PGID, wx.wxEVT_PG_COL_DRAGGING, self.OnPropertyGridColDragging)
   Connect(self.PGID, wx.wxEVT_PG_COL_END_DRAG, self.OnPropertyGridColEndDrag)

   Connect(self.PGID, wx.wxEVT_TEXT, self.OnPropertyGridTextUpdate)

   --//
   --// Rest of the events are not property grid specific
   Connect(wx.wxEVT_KEY_DOWN, self.OnPropertyGridKeyEvent)
   Connect(wx.wxEVT_KEY_UP, self.OnPropertyGridKeyEvent)

   Connect(self.ID_APPENDPROP, wx.wxEVT_MENU, self.OnAppendPropClick)
   Connect(self.ID_APPENDCAT, wx.wxEVT_MENU, self.OnAppendCatClick)
   Connect(self.ID_INSERTPROP, wx.wxEVT_MENU, self.OnInsertPropClick)
   Connect(self.ID_INSERTCAT, wx.wxEVT_MENU, self.OnInsertCatClick)
   Connect(self.ID_DELETE, wx.wxEVT_MENU, self.OnDelPropClick)
   Connect(self.ID_DELETER, wx.wxEVT_MENU, self.OnDelPropRClick)
   Connect(self.ID_UNSPECIFY, wx.wxEVT_MENU, self.OnMisc)
   Connect(self.ID_DELETEALL, wx.wxEVT_MENU, self.OnClearClick)
   Connect(self.ID_ENABLE, wx.wxEVT_MENU, self.OnEnableDisable)
   Connect(self.ID_SETREADONLY, wx.wxEVT_MENU, self.OnSetReadOnly)
   Connect(self.ID_HIDE, wx.wxEVT_MENU, self.OnHide)
   Connect(self.ID_BOOL_CHECKBOX, wx.wxEVT_MENU, self.OnBoolCheckbox)

   Connect(self.ID_ITERATE1, wx.wxEVT_MENU, self.OnIterate1Click)
   Connect(self.ID_ITERATE2, wx.wxEVT_MENU, self.OnIterate2Click)
   Connect(self.ID_ITERATE3, wx.wxEVT_MENU, self.OnIterate3Click)
   Connect(self.ID_ITERATE4, wx.wxEVT_MENU, self.OnIterate4Click)
   Connect(self.ID_ONEXTENDEDKEYNAV, wx.wxEVT_MENU, self.OnExtendedKeyNav)
   Connect(self.ID_SETBGCOLOUR, wx.wxEVT_MENU, self.OnSetBackgroundColour)
   Connect(self.ID_SETBGCOLOURRECUR, wx.wxEVT_MENU, self.OnSetBackgroundColour)
   Connect(self.ID_CLEARMODIF, wx.wxEVT_MENU, self.OnClearModifyStatusClick)
   Connect(self.ID_FREEZE, wx.wxEVT_MENU, self.OnFreezeClick)
   Connect(self.ID_ENABLELABELEDITING, wx.wxEVT_MENU, self.OnEnableLabelEditing)
   --#if wxUSE_HEADERCTRL
   Connect(self.ID_SHOWHEADER, wx.wxEVT_MENU, self.OnShowHeader)
   --#endif
   Connect(self.ID_DUMPLIST, wx.wxEVT_MENU, self.OnDumpList)

   Connect(self.ID_COLOURSCHEME1, wx.wxEVT_MENU, self.OnColourScheme)
   Connect(self.ID_COLOURSCHEME2, wx.wxEVT_MENU, self.OnColourScheme)
   Connect(self.ID_COLOURSCHEME3, wx.wxEVT_MENU, self.OnColourScheme)
   Connect(self.ID_COLOURSCHEME4, wx.wxEVT_MENU, self.OnColourScheme)

   Connect(self.ID_ABOUT, wx.wxEVT_MENU, self.OnAbout)
   Connect(self.ID_QUIT, wx.wxEVT_MENU, self.OnCloseClick)

   Connect(self.ID_CATCOLOURS, wx.wxEVT_MENU, self.OnCatColours)
   Connect(self.ID_SETCOLUMNS, wx.wxEVT_MENU, self.OnSetColumns)
   Connect(self.ID_SETVIRTWIDTH, wx.wxEVT_MENU, self.OnSetVirtualWidth)
   Connect(self.ID_SETPGDISABLED, wx.wxEVT_MENU, self.OnSetGridDisabled)
   Connect(self.ID_TESTXRC, wx.wxEVT_MENU, self.OnTestXRC)
   Connect(self.ID_ENABLECOMMONVALUES, wx.wxEVT_MENU, self.OnEnableCommonValues)
   Connect(self.ID_SELECTSTYLE, wx.wxEVT_MENU, self.OnSelectStyle)

   Connect(self.ID_STATICLAYOUT, wx.wxEVT_MENU, self.OnMisc)
   Connect(self.ID_COLLAPSE, wx.wxEVT_MENU, self.OnMisc)
   Connect(self.ID_COLLAPSEALL, wx.wxEVT_MENU, self.OnMisc)

   Connect(self.ID_POPULATE1, wx.wxEVT_MENU, self.OnPopulateClick)
   Connect(self.ID_POPULATE2, wx.wxEVT_MENU, self.OnPopulateClick)

   Connect(self.ID_GETVALUES, wx.wxEVT_MENU, self.OnMisc)
   Connect(self.ID_SETVALUES, wx.wxEVT_MENU, self.OnMisc)
   Connect(self.ID_SETVALUES2, wx.wxEVT_MENU, self.OnMisc)

   Connect(self.ID_FITCOLUMNS, wx.wxEVT_MENU, self.OnFitColumnsClick)

   Connect(self.ID_CHANGEFLAGSITEMS, wx.wxEVT_MENU, self.OnChangeFlagsPropItemsClick)

   Connect(self.ID_RUNTESTFULL, wx.wxEVT_MENU, self.OnMisc)
   Connect(self.ID_RUNTESTPARTIAL, wx.wxEVT_MENU, self.OnMisc)

   Connect(self.ID_TESTINSERTCHOICE, wx.wxEVT_MENU, self.OnInsertChoice)
   Connect(self.ID_TESTDELETECHOICE, wx.wxEVT_MENU, self.OnDeleteChoice)

   Connect(self.ID_INSERTPAGE, wx.wxEVT_MENU, self.OnInsertPage)
   Connect(self.ID_REMOVEPAGE, wx.wxEVT_MENU, self.OnRemovePage)

   Connect(self.ID_SAVESTATE, wx.wxEVT_MENU, self.OnSaveState)
   Connect(self.ID_RESTORESTATE, wx.wxEVT_MENU, self.OnRestoreState)

   Connect(self.ID_SETSPINCTRLEDITOR, wx.wxEVT_MENU, self.OnSetSpinCtrlEditorClick)
   Connect(self.ID_TESTREPLACE, wx.wxEVT_MENU, self.OnTestReplaceClick)
   Connect(self.ID_SETPROPERTYVALUE, wx.wxEVT_MENU, self.OnSetPropertyValue)

   Connect(self.ID_RUNMINIMAL, wx.wxEVT_MENU, self.OnRunMinimalClick)

   Connect(self.ID_CATCOLOURS, wx.wxEVT_UPDATE_UI, self.OnCatColoursUpdateUI)

   Connect(wx.wxEVT_CONTEXT_MENU, self.OnContextMenu)
   Connect(self.ID_SHOWPOPUP, wx.wxEVT_BUTTON, self.OnShowPopup)

   return this
end

--//
--// Normally, wxPropertyGrid does not check whether item with identical
--// label already exists. However, since in this sample we use labels for
--// identifying properties, we have to be sure not to generate identical
--// labels.
--//
function FormMain:GenerateUniquePropertyLabel(pg, baselabel)
   local count = -1
   local newlabel

   if pg:GetPropertyByLabel(baselabel) then
      while true do
         count = count + 1
         newlabel = ("%s%d"):format(baselabel, count)
         if not pg:GetPropertyByLabel(newlabel) then
            break
         end
      end
   end

   if count >= 0 then
      baselabel = newlabel
   end

   return baselabel
end

-------------------------------------------------------------------------

function FormMain:OnInsertPropClick(_)
   local propLabel = "Property"

   if not self.m_pPropGridManager:GetGrid():GetRoot():GetChildCount() then
      wx.wxMessageBox("No items to relate - first add some with Append.")
      return
   end

   local id = self.m_pPropGridManager:GetGrid():GetSelection()
   if not id then
      wx.wxMessageBox("First select a property - new one will be inserted right before that.")
      return
   end

   propLabel = self:GenerateUniquePropertyLabel( self.m_pPropGridManager, propLabel )

   self.m_pPropGridManager:Insert( self.m_pPropGridManager:GetPropertyParent(id),
                                   id:GetIndexInParent(),
                                   wx.wxStringProperty(propLabel) )
end

-------------------------------------------------------------------------

function FormMain:OnAppendPropClick(_)
   local propLabel = "Property"

   propLabel = self:GenerateUniquePropertyLabel( self.m_pPropGridManager, propLabel )

   self.m_pPropGridManager:Append( wx.wxStringProperty(propLabel) )

   self.m_pPropGridManager:Refresh()
end

-------------------------------------------------------------------------

function FormMain:OnClearClick(_)
   self.m_pPropGridManager:GetGrid():Clear()
end

-------------------------------------------------------------------------

function FormMain:OnAppendCatClick(_)
   local propLabel = "Category"

   propLabel = self:GenerateUniquePropertyLabel( self.m_pPropGridManager, propLabel )

   self.m_pPropGridManager:Append( wx.wxPropertyCategory (propLabel) )

   self.m_pPropGridManager:Refresh()

end

-------------------------------------------------------------------------

function FormMain:OnInsertCatClick(_)
   local propLabel = "Category"

   if ( not self.m_pPropGridManager:GetGrid():GetRoot():GetChildCount() ) then
      wx.wxMessageBox("No items to relate - first add some with Append.")
      return
   end

   local id = self.m_pPropGridManager:GetGrid():GetSelection()
   if not id then
      wx.wxMessageBox("First select a property - new one will be inserted right before that.")
      return
   end

   propLabel = self:GenerateUniquePropertyLabel( self.m_pPropGridManager, propLabel )

   self.m_pPropGridManager:Insert( self.m_pPropGridManager:GetPropertyParent(id),
                                   id:GetIndexInParent(),
                                   wx.wxPropertyCategory (propLabel) )
end

-------------------------------------------------------------------------

function FormMain:OnDelPropClick(_)
   local id = self.m_pPropGridManager:GetGrid():GetSelection()
   if not id then
      wx.wxMessageBox("First select a property.")
      return
   end

   self.m_pPropGridManager:DeleteProperty( id )
end

-------------------------------------------------------------------------

function FormMain:OnDelPropRClick(_)
   --// Delete random property
   local p = self.m_pPropGridManager:GetGrid():GetRoot()

   while true do
      if p:GetChildCount() == 0 then
         break
      end

      local n = math.random(0, p:GetChildCount())
      p = p:Item(n)

      if not p:IsCategory() then
         local label = p:GetLabel()
         self.m_pPropGridManager:DeleteProperty(p)
         wx.wxLogMessage(("Property deleted: %s"):format(label))
         break
      end
   end
end

-------------------------------------------------------------------------

function FormMain:OnContextMenu(event)
   wx.wxLogDebug(("FormMain::OnContextMenu(%d,%d)")
      :format(event:GetPosition():GetX(), event:GetPosition():GetY()))

   --//event:Skip()
end

-------------------------------------------------------------------------

function FormMain:OnCloseClick(_)
   -- /*#ifdef __WXDEBUG__
   --    self.m_pPropGridManager:GetGrid():DumpAllocatedChoiceSets()
   --    wx.wxLogDebug("\\: Don't worry, this is perfectly normal in this sample.")
   -- #endif*/

   self.this:Close(false)
end

-------------------------------------------------------------------------

local function IterateMessage(prop)
   local s = ( "\"%s\" class = %s, valuetype = %s")
      :format( prop:GetLabel(), prop:GetClassInfo():GetClassName(), prop:GetValueType() )

   return wx.wxMessageBox( s, "Iterating... (press CANCEL to end)", wx.wxOK + wx.wxCANCEL )
end

-------------------------------------------------------------------------

function FormMain:OnIterate1Click(_)
--[[ FIXME
   local it = self.m_pPropGridManager:GetCurrentPage():GetIterator()

   while not it:AtEnd() do
      local p = it:op_deref()
      local res = IterateMessage( p )
      if res == wx.wxCANCEL then break end
      it:op_inc()
   end
--]]
end

-------------------------------------------------------------------------

function FormMain:OnIterate2Click(event)
--[[ FIXME
   local it = self.m_pPropGridManager:GetCurrentPage():GetIterator( wx.wxPG_ITERATE_VISIBLE )

   while not it:AtEnd() do
      local p = it:op_deref()
      local res = IterateMessage( p )
      if res == wx.wxCANCEL then break end
      it:op_inc()
   end
--]]
end

-------------------------------------------------------------------------

function FormMain:OnIterate3Click(event)
--[[ FIXME
   --// iterate over items in reverse order
   local it = self.m_pPropGridManager:GetCurrentPage():GetIterator( wx.wxPG_ITERATE_DEFAULT, wx.wxBOTTOM )

   while not it:AtEnd() do
      local p = it:op_deref()
      local res = IterateMessage( p )
      if res == wx.wxCANCEL then break end
      it:op_inc()
   end
--]]
end

-------------------------------------------------------------------------

function FormMain:OnIterate4Click(_)
--[[ FIXME
   local it = self.m_pPropGridManager:GetCurrentPage():GetIterator( wx.wxPG_ITERATE_CATEGORIES )

   while not it:AtEnd() do
      local p = it:op_deref()
      local res = IterateMessage( p )
      if res == wx.wxCANCEL then break end
      it:op_inc()
   end
--]]
end

-------------------------------------------------------------------------

function FormMain:OnExtendedKeyNav(_)
   --// Use AddActionTrigger() and DedicateKey() to set up Enter,
   --// Up, and Down keys for navigating between properties.
   local propGrid = self.m_pPropGridManager:GetGrid()

   propGrid:AddActionTrigger(wx.wxPG_ACTION_NEXT_PROPERTY, wx.WXK_RETURN)
   propGrid:DedicateKey(wx.WXK_RETURN)

   --// Up and Down keys are already associated with navigation,
   --// but we must also prevent them from being eaten by
   --// editor controls.
   propGrid:DedicateKey(wx.WXK_UP)
   propGrid:DedicateKey(wx.WXK_DOWN)
end

-------------------------------------------------------------------------

function FormMain:OnFitColumnsClick(_)
   local page = self.m_pPropGridManager:GetCurrentPage()

   --// Remove auto-centering
   self.m_pPropGridManager:SetWindowStyle( bit.band(self.m_pPropGridManager:GetWindowStyle(), bit.bnot(wx.wxPG_SPLITTER_AUTO_CENTER)) )

   --// Grow manager size just prior fit - otherwise
   --// column information may be lost.
   local oldGridSize = self.m_pPropGridManager:GetGrid():GetClientSize()
   local oldFullSize = self.this:GetSize()
   self.this:SetSize(1000, oldFullSize:GetHeight())

   local newSz = page:FitColumns()

   local dx = oldFullSize:GetWidth() - oldGridSize:GetWidth()
   local dy = oldFullSize:GetHeight() - oldGridSize:GetHeight()

   newSz:IncBy(dx, dy)

   self.this:SetSize(newSz)
end

-------------------------------------------------------------------------

function FormMain:OnChangeFlagsPropItemsClick(_)
   local p = self.m_pPropGridManager:GetPropertyByName("Window Styles")

   local newChoices = wx.wxPGChoices()

   newChoices:Add("Fast",0x1)
   newChoices:Add("Powerful",0x2)
   newChoices:Add("Safe",0x4)
   newChoices:Add("Sleek",0x8)

   p:SetChoices(newChoices)
end

-------------------------------------------------------------------------

function FormMain:OnEnableDisable(_)
   local id = self.m_pPropGridManager:GetGrid():GetSelection()
   if not id then
      wx.wxMessageBox("First select a property.")
      return
   end

   if self.m_pPropGridManager:IsPropertyEnabled( id ) then
      self.m_pPropGridManager:DisableProperty ( id )
      self.m_itemEnable:SetItemLabel( "Enable" )
   else
      self.m_pPropGridManager:EnableProperty ( id )
      self.m_itemEnable:SetItemLabel( "Disable" )
   end
end

-------------------------------------------------------------------------

function FormMain:OnSetReadOnly(_)
   local p = self.m_pPropGridManager:GetGrid():GetSelection()
   if not p then
      wx.wxMessageBox("First select a property.")
      return
   end

   self.m_pPropGridManager:SetPropertyReadOnly(p)
end

-------------------------------------------------------------------------

function FormMain:OnHide(_)
   local id = self.m_pPropGridManager:GetGrid():GetSelection()
   if not id then
      wx.wxMessageBox("First select a property.")
      return
   end

   self.m_pPropGridManager:HideProperty( id, true )
end

function FormMain:OnBoolCheckbox(event)
   self.m_pPropGridManager:SetPropertyAttributeAll(wx.wxPG_BOOL_USE_CHECKBOX, event:IsChecked())
end

-------------------------------------------------------------------------

function FormMain:OnSetBackgroundColour(event)
   local pg = self.m_pPropGridManager:GetGrid()
   local prop = pg:GetSelection()
   if not prop then
      wx.wxMessageBox("First select a property.")
      return
   end

   local col = wx.wxGetColourFromUser(self.this, wx.wxWHITE, "Choose colour")

   if col:IsOk() then
      local flags = 0
      if event:GetId() == self.ID_SETBGCOLOURRECUR then
         flags = wx.wxPG_RECURSE
      end
      pg:SetPropertyBackgroundColour(prop, col, flags)
   end
end

-------------------------------------------------------------------------

function FormMain:OnInsertPage(_)
   self.m_pPropGridManager:AddPage("New Page")
end

-------------------------------------------------------------------------

function FormMain:OnRemovePage(_)
   self.m_pPropGridManager:RemovePage(self.m_pPropGridManager:GetSelectedPage())
end

-------------------------------------------------------------------------

function FormMain:OnSaveState(_)
   self.m_savedState = self.m_pPropGridManager:SaveEditableState()
   wx.wxLogDebug(("Saved editable state string: \"%s\""):format(self.m_savedState))
end

-------------------------------------------------------------------------

function FormMain:OnRestoreState(_)
   self.m_pPropGridManager:RestoreEditableState(self.m_savedState)
end

-------------------------------------------------------------------------

function FormMain:OnSetSpinCtrlEditorClick(_)
   --#if wxUSE_SPINBTN
   local pgId = self.m_pPropGridManager:GetSelection()
   if pgId then
      self.m_pPropGridManager:SetPropertyEditor( pgId, wx.wxPGEditor_SpinCtrl )
   else
      wx.wxMessageBox("First select a property")
   end
   --#endif
end

-------------------------------------------------------------------------

function FormMain:OnTestReplaceClick(_)
   local pgId = self.m_pPropGridManager:GetSelection()
   if pgId then
      local choices = wx.wxPGChoices()
      choices:Add("Flag 0",0x0001)
      choices:Add("Flag 1",0x0002)
      choices:Add("Flag 2",0x0004)
      choices:Add("Flag 3",0x0008)
      local maxVal = 0x000F
      --// Look for unused property name
      local propName = "ReplaceFlagsProperty"
      local idx = 0
      while self.m_pPropGridManager:GetPropertyByName(propName) do
         idx = idx + 1
         propName = ("ReplaceFlagsProperty %d"):format(idx)
      end
      --// Replace property and select new one
      --// with random value in range [1..maxVal]
      local propVal = wx.wxGetLocalTime() % maxVal + 1
      local newId = self.m_pPropGridManager:ReplaceProperty( pgId, wx.wxFlagsProperty(propName, wx.wxPG_LABEL, choices, propVal) )
      self.m_pPropGridManager:SetPropertyAttribute( newId, wx.wxPG_BOOL_USE_CHECKBOX, true, wx.wxPG_RECURSE )
      self.m_pPropGridManager:SelectProperty(newId)
   else
      wx.wxMessageBox("First select a property")
   end
end

-------------------------------------------------------------------------

function FormMain:OnClearModifyStatusClick(_)
   self.m_pPropGridManager:ClearModifiedStatus()
   self.m_pPropGridManager:Refresh()
end

-------------------------------------------------------------------------

--Freeze check-box checked?
function FormMain:OnFreezeClick(event)
   if not self.m_pPropGridManager then return end

   if event:IsChecked() then
      if not self.m_pPropGridManager:IsFrozen() then
         self.m_pPropGridManager:Freeze()
      end
   else
      if self.m_pPropGridManager:IsFrozen() then
         self.m_pPropGridManager:Thaw()
         self.m_pPropGridManager:Refresh()
      end
   end
end

-------------------------------------------------------------------------

function FormMain:OnEnableLabelEditing(event)
   self.m_labelEditingEnabled = event:IsChecked()
   self.m_propGrid:MakeColumnEditable(0, self.m_labelEditingEnabled)
end

-------------------------------------------------------------------------

--#if wxUSE_HEADERCTRL
function FormMain:OnShowHeader(event)
   self.m_hasHeader = event:IsChecked()
   self.m_pPropGridManager:ShowHeader(self.m_hasHeader)
   if self.m_hasHeader then
      self.m_pPropGridManager:SetColumnTitle(2, "Units")
   end
end
--#endif --// wxUSE_HEADERCTRL

-------------------------------------------------------------------------

function FormMain:OnAbout(event)
   local pi = wx.wxPlatformInfo.Get()
   local toolkit = ("%s %d.%d.%d"):format(pi:GetPortIdName(),
                                          pi:GetToolkitMajorVersion(),
                                          pi:GetToolkitMinorVersion(),
                                          pi:GetToolkitMicroVersion())

   local msg = ("wxPropertyGrid Sample" ..
                -- #if wxUSE_UNICODE
                --   #if defined(wxUSE_UNICODE_UTF8) && wxUSE_UNICODE_UTF8
                --                 " <utf-8>"
                --   #else
                --                 " <unicode>"
                --   #endif
                -- #else
                --                 " <ansi>"
                -- #endif
                -- #ifdef __WXDEBUG__
                --                 " <debug>"
                -- #else
                --                 " <release>"
                -- #endif
                "\n\n" ..
                "Programmed by %s\n\n" ..
                "Using %s (%s)\n\n")
      :format("Jaakko Salli", wx.wxVERSION_STRING, toolkit)


   wx.wxMessageBox(msg, "About", wx.wxOK + wx.wxICON_INFORMATION, self.this)
end

-------------------------------------------------------------------------

function FormMain:OnColourScheme(event)
   local id = event:GetId()
   if id == self.ID_COLOURSCHEME1 then
      self.m_pPropGridManager:GetGrid():ResetColours()
   elseif id == self.ID_COLOURSCHEME2 then
      --// white
      local my_grey_1 = wx.wxColour(212,208,200)
      local my_grey_3 = wx.wxColour(113,111,100)
      self.m_pPropGridManager:Freeze()
      self.m_pPropGridManager:GetGrid():SetMarginColour( wx.wxWHITE )
      self.m_pPropGridManager:GetGrid():SetCaptionBackgroundColour( wx.wxWHITE )
      self.m_pPropGridManager:GetGrid():SetCellBackgroundColour( wx.wxWHITE )
      self.m_pPropGridManager:GetGrid():SetCellTextColour( my_grey_3 )
      self.m_pPropGridManager:GetGrid():SetLineColour( my_grey_1 )--//wx.wxColour(160,160,160)
      self.m_pPropGridManager:Thaw()
   elseif id == self.ID_COLOURSCHEME3 then
      --// .NET
      local my_grey_1 = wx.wxColour(212,208,200)
      local my_grey_2 = wx.wxColour(236,233,216)
      self.m_pPropGridManager:Freeze()
      self.m_pPropGridManager:GetGrid():SetMarginColour( my_grey_1 )
      self.m_pPropGridManager:GetGrid():SetCaptionBackgroundColour( my_grey_1 )
      self.m_pPropGridManager:GetGrid():SetLineColour( my_grey_1 )
      self.m_pPropGridManager:Thaw()
   elseif id == self.ID_COLOURSCHEME4 then
      --// cream
      local my_grey_1 = wx.wxColour(212,208,200)
      local my_grey_2 = wx.wxColour(241,239,226)
      local my_grey_3 = wx.wxColour(113,111,100)
      self.m_pPropGridManager:Freeze()
      self.m_pPropGridManager:GetGrid():SetMarginColour( wx.wxWHITE )
      self.m_pPropGridManager:GetGrid():SetCaptionBackgroundColour( wx.wxWHITE )
      self.m_pPropGridManager:GetGrid():SetCellBackgroundColour( my_grey_2 )
      self.m_pPropGridManager:GetGrid():SetCellBackgroundColour( my_grey_2 )
      self.m_pPropGridManager:GetGrid():SetCellTextColour( my_grey_3 )
      self.m_pPropGridManager:GetGrid():SetLineColour( my_grey_1 )
      self.m_pPropGridManager:Thaw()
   end
end

-------------------------------------------------------------------------

function FormMain:OnCatColoursUpdateUI(_)
   --// Prevent menu item from being checked
   --// if it is selected from improper page.
   local pg = self.m_pPropGridManager:GetGrid()
   self.m_itemCatColours:SetCheckable(
      pg:GetPropertyByName("Appearance") ~= nil and
      pg:GetPropertyByName("PositionCategory") ~= nil and
      pg:GetPropertyByName("Environment") ~= nil and
      pg:GetPropertyByName("More Examples") ~= nil )
end

function FormMain:OnCatColours(event)
   local pg = self.m_pPropGridManager:GetGrid()
   if ( not pg:GetPropertyByName("Appearance") or
        not pg:GetPropertyByName("PositionCategory") or
        not pg:GetPropertyByName("Environment") or
        not pg:GetPropertyByName("More Examples") )
   then
      wx.wxMessageBox("First switch to 'Standard Items' page!")
      return
   end

   self.m_pPropGridManager:Freeze()

   if event:IsChecked() then
      --// Set custom colours.
      pg:SetPropertyTextColour( "Appearance", wx.wxColour(255,0,0), wx.wxPG_DONT_RECURSE )
      pg:SetPropertyBackgroundColour( "Appearance", wx.wxColour(255,255,183) )
      pg:SetPropertyTextColour( "Appearance", wx.wxColour(255,0,183) )
      pg:SetPropertyTextColour( "PositionCategory", wx.wxColour(0,255,0), wx.wxPG_DONT_RECURSE )
      pg:SetPropertyBackgroundColour( "PositionCategory", wx.wxColour(255,226,190) )
      pg:SetPropertyTextColour( "PositionCategory", wx.wxColour(255,0,190) )
      pg:SetPropertyTextColour( "Environment", wx.wxColour(0,0,255), wx.wxPG_DONT_RECURSE )
      pg:SetPropertyBackgroundColour( "Environment", wx.wxColour(208,240,175) )
      pg:SetPropertyTextColour( "Environment", wx.wxColour(255,255,255) )
      pg:SetPropertyBackgroundColour( "More Examples", wx.wxColour(172,237,255) )
      pg:SetPropertyTextColour( "More Examples", wx.wxColour(172,0,255) )
   else
      --// Revert to original.
      pg:SetPropertyColoursToDefault( "Appearance" )
      pg:SetPropertyColoursToDefault( "Appearance", wx.wxPG_RECURSE )
      pg:SetPropertyColoursToDefault( "PositionCategory" )
      pg:SetPropertyColoursToDefault( "PositionCategory", wx.wxPG_RECURSE )
      pg:SetPropertyColoursToDefault( "Environment" )
      pg:SetPropertyColoursToDefault( "Environment", wx.wxPG_RECURSE )
      pg:SetPropertyColoursToDefault( "More Examples", wx.wxPG_RECURSE )
   end
   self.m_pPropGridManager:Thaw()
   self.m_pPropGridManager:Refresh()
end

-------------------------------------------------------------------------

function FormMain:OnSelectStyle(_)
   local style = 0
   local extraStyle = 0

   do
      local chs = {}
      local vls = {}
      local sel = {}
      local ind = 0
      local flags = self.m_pPropGridManager:GetWindowStyle()

      local function ADD_FLAG(FLAG)
         chs[#chs+1] = FLAG
         vls[#vls+1] = wx[FLAG]
         if bit.band(flags, wx[FLAG]) == wx[FLAG] then
            sel[#sel+1] = ind
         end
         ind = ind + 1
      end

      ADD_FLAG("wxPG_HIDE_CATEGORIES")
      ADD_FLAG("wxPG_AUTO_SORT")
      ADD_FLAG("wxPG_BOLD_MODIFIED")
      ADD_FLAG("wxPG_SPLITTER_AUTO_CENTER")
      ADD_FLAG("wxPG_TOOLTIPS")
      ADD_FLAG("wxPG_STATIC_SPLITTER")
      ADD_FLAG("wxPG_HIDE_MARGIN")
      ADD_FLAG("wxPG_LIMITED_EDITING")
      ADD_FLAG("wxPG_TOOLBAR")
      ADD_FLAG("wxPG_DESCRIPTION")
      ADD_FLAG("wxPG_NO_INTERNAL_BORDER")
      local dlg = wx.wxMultiChoiceDialog( self.this, "Select window styles to use", "wxPropertyGrid Window Style", chs )
      dlg:SetSelections(sel)
      if dlg:ShowModal() == wx.wxID_CANCEL then
         return
      end

      flags = 0
      sel = dlg:GetSelections():ToLuaTable()
      for ind = 1, #sel do
         flags = bit.bor(flags, vls[sel[ind]+1])
      end

      style = flags
   end

   do
      local chs = {}
      local vls = {}
      local sel = {}
      local ind = 0
      local flags = self.m_pPropGridManager:GetExtraStyle()

      local function ADD_FLAG(FLAG)
         chs[#chs+1] = FLAG
         vls[#vls+1] = wx[FLAG]
         if bit.band(flags, wx[FLAG]) == wx[FLAG] then
            sel[#sel+1] = ind
         end
         ind = ind + 1
      end

      ADD_FLAG("wxPG_EX_INIT_NOCAT")
      ADD_FLAG("wxPG_EX_NO_FLAT_TOOLBAR")
      ADD_FLAG("wxPG_EX_MODE_BUTTONS")
      ADD_FLAG("wxPG_EX_HELP_AS_TOOLTIPS")
      ADD_FLAG("wxPG_EX_NATIVE_DOUBLE_BUFFERING")
      ADD_FLAG("wxPG_EX_AUTO_UNSPECIFIED_VALUES")
      ADD_FLAG("wxPG_EX_WRITEONLY_BUILTIN_ATTRIBUTES")
      ADD_FLAG("wxPG_EX_HIDE_PAGE_BUTTONS")
      ADD_FLAG("wxPG_EX_MULTIPLE_SELECTION")
      ADD_FLAG("wxPG_EX_ENABLE_TLP_TRACKING")
      ADD_FLAG("wxPG_EX_NO_TOOLBAR_DIVIDER")
      ADD_FLAG("wxPG_EX_TOOLBAR_SEPARATOR")
      ADD_FLAG("wxPG_EX_ALWAYS_ALLOW_FOCUS")
      local dlg = wx.wxMultiChoiceDialog( self.this, "Select extra window styles to use", "wxPropertyGrid Extra Style", chs )
      dlg:SetSelections(sel)
      if dlg:ShowModal() == wx.wxID_CANCEL then
         return
      end

      flags = 0
      sel = dlg:GetSelections():ToLuaTable()
      for ind = 1, #sel do
         flags = bit.bor(flags, vls[sel[ind]+1])
      end

      extraStyle = flags
   end

   self:ReplaceGrid( style, extraStyle )
end

-------------------------------------------------------------------------

function FormMain:OnSetColumns(_)
   local colCount = wx.wxGetNumberFromUser("Enter number of columns (2-20).","Columns:",
                                           "Change Columns",self.m_pPropGridManager:GetColumnCount(),
                                           2,20)

   if colCount >= 2 then
      self.m_pPropGridManager:SetColumnCount(colCount)
   end
end

-------------------------------------------------------------------------

function FormMain:OnSetVirtualWidth(_)
   local oldWidth = self.m_pPropGridManager:GetCurrentPage():GetStatePtr():GetVirtualWidth()
   local newWidth = oldWidth
   do
      local dlg = wx.wxNumberEntryDialog (self.this, "Enter virtual width (-1-2000).", "Width:",
                                          "Change Virtual Width", oldWidth, -1, 2000)
      if dlg:ShowModal() == wx.wxID_OK then
         newWidth = dlg:GetValue()
      end
   end
   if newWidth ~= oldWidth then
      self.m_pPropGridManager:GetGrid():SetVirtualWidth(newWidth)
   end
end

-------------------------------------------------------------------------

function FormMain:OnSetGridDisabled(event)
   self.m_pPropGridManager:Enable(not event:IsChecked())
end

-------------------------------------------------------------------------

function FormMain:OnSetPropertyValue(_)
   local pg = self.m_pPropGridManager:GetGrid()
   local selected = pg:GetSelection()

   if selected then
      local value = wx.wxGetTextFromUser( "Enter new value:" )
      pg:SetPropertyValue( selected, value )
   end
end

-------------------------------------------------------------------------

function FormMain:OnInsertChoice(_)
   local pg = self.m_pPropGridManager:GetGrid()
   local selected = pg:GetSelection()

   if selected then
      local choices = selected:GetChoices()

      if choices:IsOk() then
         --// Insert new choice to the center of list

         local pos = choices:GetCount() / 2
         selected:InsertChoice("New Choice", pos)
         return
      end
   end

   wx.wxMessageBox("First select a property with some choices.")
end

-------------------------------------------------------------------------

function FormMain:OnDeleteChoice(_)
   local pg = self.m_pPropGridManager:GetGrid()
   local selected = pg:GetSelection()

   if selected then
      local choices = selected:GetChoices()

      if choices:IsOk() then
         --// Deletes choice from the center of list

         local pos = choices:GetCount() / 2
         selected:DeleteChoice(pos)
         return
      end
   end

   wx.wxMessageBox("First select a property with some choices.")
end

-------------------------------------------------------------------------

function FormMain:OnMisc (event)
   local id = event:GetId()
   if id == self.ID_STATICLAYOUT then
      local wsf = self.m_pPropGridManager:GetWindowStyleFlag()
      if event:IsChecked() then
         self.m_pPropGridManager:SetWindowStyleFlag( bit.bor(wsf, wx.wxPG_STATIC_LAYOUT) )
      else
         self.m_pPropGridManager:SetWindowStyleFlag( bit.band(wsf, bit.bnot(wx.wxPG_STATIC_LAYOUT)) )
      end
   elseif id == self.ID_COLLAPSEALL then
      local pg = self.m_pPropGridManager:GetGrid()
      local it = pg:GetVIterator( wx.wxPG_ITERATE_ALL )

      while not it:AtEnd() do
         it:GetProperty():SetExpanded( false )
         it:Next()
      end

      pg:RefreshGrid()
   elseif id == self.ID_GETVALUES then
      self.m_storedValues = self.m_pPropGridManager:GetGrid():GetPropertyValues("Test",
                                                                                self.m_pPropGridManager:GetGrid():GetRoot(),
                                                                                wx.wxPG_KEEP_STRUCTURE + wx.wxPG_INC_ATTRIBUTES)
   elseif id == self.ID_SETVALUES then
      if self.m_storedValues:IsType("list") then
         self.m_pPropGridManager:GetGrid():SetPropertyValues(self.m_storedValues)
      else
         wx.wxMessageBox("First use Get Property Values.")
      end
   elseif id == self.ID_SETVALUES2 then
      local list = wx.wxVariant()
      list:NullList()
      list:Append( wx.wxVariant(1234,"VariantLong") )
      list:Append( wx.wxVariant(true,"VariantBool") )
      list:Append( wx.wxVariant("Test Text","VariantString") )
      self.m_pPropGridManager:GetGrid():SetPropertyValues(list)
   elseif id == self.ID_COLLAPSE then
      --// Collapses selected.
      local selProp = self.m_pPropGridManager:GetSelection()
      if selProp then
         self.m_pPropGridManager:Collapse(selProp)
      end
   elseif id == self.ID_RUNTESTFULL then
      --// Runs a regression test.
      self:RunTests(true)
   elseif id == self.ID_RUNTESTPARTIAL then
      --// Runs a regression test.
      self:RunTests(false)
   elseif id == self.ID_UNSPECIFY then
      local prop = self.m_pPropGridManager:GetSelection()
      if prop then
         self.m_pPropGridManager:SetPropertyValueUnspecified(prop)
         prop:RefreshEditor()
      end
   end
end

-------------------------------------------------------------------------

function FormMain:OnIdle(event)
--[[
      // This code is useful for debugging focus problems
      static wxWindow* last_focus = (wxWindow*) NULL

      wxWindow* cur_focus = ::wxWindow::FindFocus()

      if ( cur_focus != last_focus )
      {
      const wxChar* class_name = "<none>"
      if ( cur_focus )
      class_name = cur_focus->GetClassInfo()->GetClassName()
      last_focus = cur_focus
      wxLogDebug( "FOCUSED: %s %X",
      class_name,
      (unsigned int)cur_focus)
      }
--]]

   event:Skip()
end

-------------------------------------------------------------------------

function FormMain:OnPopulateClick(event)
   local id = event:GetId()
   self.m_propGrid:Clear()
   self.m_propGrid:Freeze()
   if id == self.ID_POPULATE1 then
      self:PopulateWithStandardItems()
   elseif id == self.ID_POPULATE2 then
      self:PopulateWithLibraryConfig()
   end
   self.m_propGrid:Thaw()
end

-------------------------------------------------------------------------

function FormMain:OnDumpList(_)
   local values = self.m_pPropGridManager:GetPropertyValues("list", wx.wxNullProperty(), wx.wxPG_INC_ATTRIBUTES)
   local text = "This only tests that wxVariant related routines do not crash.\n"

   local dlg = wx.wxDialog(self.this,wx.wxID_ANY,"wxVariant Test",
                           wx.wxDefaultPosition,wx.wxDefaultSize,wx.wxDEFAULT_DIALOG_STYLE+wx.wxRESIZE_BORDER)

   for i = 0, values:GetCount()-1 do
      local t
      local v = values[i]

      local strValue = v:GetString()

      if v:GetName():EndsWith("@attr") then
         text = text .. "Attributes:\n"

         for n = 0, v.GetCount() - 1 do
            local a = v[n]

            t = ("  attribute %d: name=\"%s\"  (type=\"%s\"  value=\"%s\")\n")
               :format(n, a:GetName(),a:GetType(),a:GetString())
            text = text .. t
         end
      else
         t = ("%d: name=\"%s\"  type=\"%s\"  value=\"%s\"\n")
            :format(i, v:GetName(),v:GetType(),strValue)
         text = text .. t
      end
   end

   --// multi-line text editor dialog
   local spacing = 8
   local topsizer = wx.wxBoxSizer( wx.wxVERTICAL )
   local rowsizer = wx.wxBoxSizer( wx.wxHORIZONTAL )
   local ed = wx.wxTextCtrl(dlg, wx.wxID_ANY, text,
                            wx.wxDefaultPosition, wx.wxDefaultSize,
                            wx.wxTE_MULTILINE + wx.wxTE_READONLY)
   rowsizer:Add( ed, wx.wxSizerFlags(1):Expand():Border(wx.wxALL, spacing))
   topsizer:Add( rowsizer, wx.wxSizerFlags(1):Expand())
   rowsizer = wx.wxBoxSizer( wx.wxHORIZONTAL )
   rowsizer:Add( wx.wxButton(dlg,wx.wxID_OK,"Ok"),
                 wx.wxSizerFlags(0):Centre():Border(wx.wxBOTTOM + wx.wxLEFT + wx.wxRIGHT, spacing))
   topsizer:Add( rowsizer, wx.wxSizerFlags():Right() )

   dlg:SetSizer( topsizer )
   topsizer:SetSizeHints( dlg )

   dlg:SetSize(400,300)
   dlg:Centre()
   dlg:ShowModal()
end

-------------------------------------------------------------------------

local DisplayMinimalFrame = dofile(GetExePath() .. "/propgrid_minimal.wx.lua")

function FormMain:OnRunMinimalClick(_)
   DisplayMinimalFrame(self.this)
end

-------------------------------------------------------------------------

-- local PropertyGridPopup popup = nil

function FormMain:OnShowPopup(_)
--[[ FIXME
   if popup then
      popup:Destroy()
      popup = nil
      return
   end
   popup = wx.PropertyGridPopup(self.this)
   local pt = wx.wxGetMousePosition()
   popup:Position(pt, wx.wxSize(0, 0))
   popup:Show()
--]]
end

-------------------------------------------------------------------------

function FormMain:RunTests(full)
   -- TODO
end

-------------------------------------------------------------------------

function MyApp:OnInit()
   local frame = FormMain:create()
   frame:Show()
   wx.wxLog.SetVerbose(true)
   return true
end

MyApp:OnInit()


-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
wx.wxGetApp():MainLoop()
