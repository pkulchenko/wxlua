package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
local wx = require"wx"

local ID_ACTION = wx.wxID_HIGHEST + 1

local function DisplayMinimalFrame(parent)
   local frame = wx.wxFrame(parent, wx.wxID_ANY, "wxPropertyGrid Minimal")

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

   return frame
end

local frame = DisplayMinimalFrame(wx.NULL)

wx.wxLog.SetVerbose(true)
local logWindow = wx.wxLogWindow(frame, "Log Messages", false)
local pos = frame:GetPosition()
local size = frame:GetSize()
logWindow:GetFrame():Move(pos:GetX() + size:GetWidth() + 10, pos:GetY())
logWindow:Show()

wx.wxGetApp():MainLoop()
