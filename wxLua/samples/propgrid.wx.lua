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
};

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
         -- wxASSERT(event.CanVeto());
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


function FormMain:PopulateWithStandardItems(_)
   local pgman = self.m_pPropGridManager
   local pg = pgman:GetPage("Standard Items")

   pg:Append(wx.wxPropertyCategory("Appearance", wx.wxPG_LABEL))

   pg:Append(wx.wxStringProperty("Label", wx.wxPG_LABEL, self:GetTitle()))
   pg:Append(wx.wxFontProperty("Font", wx.wxPG_LABEL))
   pg:SetPropertyHelpString("Font", "Editing this will change font used in the property grid.");





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

local _fs_framestyle_values = {};
for i, label in ipairs(_fs_framestyle_labels) do
   _fs_framestyle_values[i] = wx[label]
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
         wxPG_EX_NATIVE_DOUBLE_BUFFERING +
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

   -- self:PopulateGrid()

   -- self.m_propGrid:MakeColumnEditable(0, self.m_labelEditingEnabled)









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
                            frameSize);

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
   --     wxPropertyGrid::RegisterEditorClass(new wxSampleMultiButtonEditor());

   self.m_panel = wx.wxPanel(this, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTAB_TRAVERSAL);

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
   );

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
   self.m_logWindow = wx.wxLogWindow(this, "Log Messages", false);
   self.m_logWindow:GetFrame():Move(this:GetPosition():GetX() + this:GetSize():GetWidth() + 10,
                                    this:GetPosition():GetY());
   self.m_logWindow:Show();
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
