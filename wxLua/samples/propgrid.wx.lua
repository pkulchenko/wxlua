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

    m_pPropGridManager = nil
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

function FormMain:OnPropertyGridChange(event)
   local property = event:GetProperty()
   local name = property:GetName()

   local value = property:ToLuaValue()
end

local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "wxPropertyGrid")

local menu = wx.wxMenu()
menu:Append(ID_ACTION, "Action")

local menuBar = wx.wxMenuBar()
menuBar:Append(menu, "Action")
frame:SetMenuBar(menuBar)


print(wx.wxPG_SPLITTER_AUTO_CENTER)
print(wx.wxPG_BOLD_MODIFIED)
local pg = wx.wxPropertyGrid(frame, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxSize(400, 400),
                             wx.wxPG_SPLITTER_AUTO_CENTER + wx.wxPG_BOLD_MODIFIED)

pg:Append(wx.wxStringProperty("String Property", wx.wxPG_LABEL))
pg:Append(wx.wxIntProperty("Int Property", wx.wxPG_LABEL))
pg:Append(wx.wxBoolProperty("Bool Property", wx.wxPG_LABEL))

frame:SetSize(400, 600)

local function OnAction(_)
end

local function OnPropertyGridChange(event)
   local p = event:GetProperty()

   if p then
      wx.wxLogVerbose(("OnPropertyGridChange(%s, value=%s)"):format(p:GetName(), p:GetValueAsString()))
   else
      wx.wxLogVerbose("OnPropertyGridChange(NULL)")
   end
end

local function OnPropertyGridChanging(event)
   local p = event:GetProperty()
   wx.wxLogVerbose(("OnPropertyGridChanging(%s)"):format(p:GetName()))
end

frame:Connect(ID_ACTION, wx.wxEVT_MENU, OnAction)
frame:Connect(wx.wxID_ANY, wx.wxEVT_PG_CHANGED, OnPropertyGridChange)
frame:Connect(wx.wxID_ANY, wx.wxEVT_PG_CHANGING, OnPropertyGridChanging)

frame:Show()

wx.wxLog.SetVerbose(true)
local logWindow = wx.wxLogWindow(frame, "Log Messages", false)
local pos = frame:GetPosition()
local size = frame:GetSize()
logWindow:GetFrame():Move(pos:GetX() + size:GetWidth() + 10, pos:GetY())
logWindow:Show()

wx.wxGetApp():MainLoop()
