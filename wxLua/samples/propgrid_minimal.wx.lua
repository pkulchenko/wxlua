local IDCounter = wx.wxID_HIGHEST
local function NewID()
    IDCounter = IDCounter + 1
    return IDCounter
end

local ID_ACTION = NewID()

local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "wxPropertyGrid Minimal")

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

local function OnAction(_)
end

local function OnPropertyGridChange(event)
   local p = event:GetProperty()

   if p then
      wx.wxLogVerbose("OnPropertyGridChange(%s, value=%s)", p:GetName(), p:GetValueAsString())
   else
      wx.wxLogVerbose("OnPropertyGridChange(NULL)")
   end
end

local function OnPropertyGridChanging(event)
   local p = event:GetProperty()
   wx.wxLogVerbose("OnPropertyGridChanging(%s)", p:GetName())
end

frame:Connect(ID_ACTION, wx.wxEVT_MENU, OnAction)
frame:Connect(wx.wxID_ANY, wx.wxEVT_PG_CHANGED, OnPropertyGridChange)
frame:Connect(wx.wxID_ANY, wx.wxEVT_PG_CHANGING, OnPropertyGridChanging)

frame:Show()

wx.wxGetApp():MainLoop()
