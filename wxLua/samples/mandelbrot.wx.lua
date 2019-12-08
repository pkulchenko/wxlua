-----------------------------------------------------------------------------
-- Name:        mandelbrot.wx.lua
-- Purpose:     a wxLua program to show 'Mandelbrot set' on screen
-- Author:      Toshi Nagata
-- Created:     03/12/2019
-- Copyright:   (c) 2019 Toshi Nagata. All rights reserved.
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
--  Description:
--    Draw the 'Mandelbrot set' on screen
--    Drag: expand the rectangle area
--    Right-click: reset expansion
--  This program is also for testing some of the wxImage and wxMemoryBuffer 
--  functions
-----------------------------------------------------------------------------

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require "wx"

local width = 800
local height = 600
local ncolors = 21

local function HueToRGB(hue)
  local r, g, b
  local phase = (hue - math.floor(hue)) * 6  --  value in [0 .. 6)
  if phase < 1 then
    r = 1
    g = phase
    b = 0
  elseif phase < 2 then
    r = 2 - phase
    g = 1
    b = 0
  elseif phase < 3 then
    r = 0
    g = 1
    b = phase - 2
  elseif phase < 4 then
    r = 0
    g = 4 - phase
    b = 1
  elseif phase < 5 then
    r = phase - 4
    g = 0
    b = 1
  else
    r = 1
    g = 0
    b = 6 - phase
  end
  r = math.floor(r * 255)
  g = math.floor(g * 255)
  b = math.floor(b * 255)
  return r, g, b
end

local function SetLimits(x, y, w, h)
  limits = { x, y, w, h }
  a = {}
  b = {}
  c = {}
  for n = 1, width * height do
    a[n] = 0
    b[n] = 0
    c[n] = 0
  end
  count = 0
  cmax = 1
  frame:SetTitle(string.format("(%f,%f)-(%f,%f)", x, y, x + w, y + h))
end

local function Step()
  local x, y, dx, dy, n
  count = count + 1
  dy = -limits[4] / height
  y = limits[2] + limits[4] + dy
  n = 1
  for i = 0, height - 1 do
    x = limits[1]
    dx = limits[3] / width
    for j = 0, width - 1 do
      if c[n] == 0 then
        local aa = a[n]
        local bb = b[n]
        local an = aa * aa - bb * bb + x
        local bn = 2 * aa * bb + y
        if an * an + bn * bn > 4 then
          c[n] = count
          if cmax < count then
            cmax = count
          end
        end
        a[n] = an
        b[n] = bn
      end
      x = x + dx
      n = n + 1
    end
    y = y + dy
  end
end

local function OnPaintTip(event)
  local dc = wx.wxPaintDC(tipwin)
  local size = tipwin:GetClientSize()
  local rect = wx.wxRect(0, 0, size:GetWidth(), size:GetHeight())
  dc:SetBrush(wx.wxBrush(tipwin:GetBackgroundColour(), wx.wxBRUSHSTYLE_SOLID))
  dc:SetPen(wx.wxPen(wx.wxBLACK, 1, wx.wxPENSTYLE_SOLID))
  dc:DrawRectangle(0, 0, size:GetWidth(), size:GetHeight())
  if tipwin.text ~= nil then
    dc:DrawText(tipwin.text, 2, 2)
  end
  dc:delete()
end

local function SetTipText(text)
  tipwin.text = text
  local w, h = tipwin:GetTextExtent(text)
  tipwin:SetClientSize(w + 4, h + 4)
end

local function OnPaint(event)
  local dc = wx.wxAutoBufferedPaintDC(frame)
  if bitmap then
    dc:DrawBitmap(bitmap, 0, 0, true)
  end
  if mouseDown and mouseRectWidth then
    dc:SetPen(wx.wxWHITE_PEN)
    local x1 = mouseDown.x
    local y1 = mouseDown.y
    local x2 = x1 + math.floor(mouseRectWidth)
    local y2 = y1 + math.floor(mouseRectHeight)
    dc:DrawLine(x1, y1, x2, y1)
    dc:DrawLine(x2, y1, x2, y2)
    dc:DrawLine(x2, y2, x1, y2)
    dc:DrawLine(x1, y2, x1, y1)
  end
  dc:delete()
end

local function MousePosToRealPos(x, y)
  local xx = limits[1] + x / width * limits[3]
  local yy = limits[2] + (1 - y / height) * limits[4]
  return xx, yy
end

local function CalcDraggedRectSize(x, y)
  local wi = x - mouseDown.x
  local hi = y - mouseDown.y
  if math.abs(wi) > math.abs(hi) then
    wi = (wi >= 0 and 1 or -1) * math.abs(hi) / height * width
  else
    hi = (hi >= 0 and 1 or -1) * math.abs(wi) / width * height
  end
  mouseRectWidth = wi
  mouseRectHeight = hi
end

local function OnMouseMotion(event)
  local pt = event:GetPosition()
  local mes
  if event:LeftIsDown() and event:Dragging() then
    CalcDraggedRectSize(pt.x, pt.y)
    local xx, yy = MousePosToRealPos(mouseDown.x, mouseDown.y)
    local x, y = MousePosToRealPos(mouseDown.x + mouseRectWidth, mouseDown.y + mouseRectHeight)
    mes = string.format("(%f,%f)-(%f,%f)", xx, yy, x, y)
  else
    local x, y = MousePosToRealPos(pt.x, pt.y)
    local r, g, b = buffer:GetByte((pt.y * width + pt.x) * 3, 3)
    mes = string.format("(%f,%f) [%d,%d,%d]", x, y, r, g, b)
  end
  SetTipText(mes)
  local size = tipwin:GetClientSize()
  tipwin:Move(pt.x + 1, pt.y - 1 - size:GetHeight())
  nextTime = wx.wxGetLocalTimeMillis():ToDouble() + 100
  frame:Refresh()
end

local function OnMouseDown(event)
  local pt = event:GetPosition()
  mouseDown = pt
end

local function OnMouseUp(event)
  local pt = event:GetPosition()
  local xx, yy = MousePosToRealPos(pt.x, pt.y)
  if mouseRectWidth and math.abs(mouseRectWidth) > 0 and math.abs(mouseRectHeight) > 0 then
    local x1, y1 = MousePosToRealPos(mouseDown.x, mouseDown.y)
    local x2, y2 = MousePosToRealPos(mouseDown.x + mouseRectWidth, mouseDown.y + mouseRectHeight)
    if x1 > x2 then x1, x2 = x2, x1 end
    if y1 > y2 then y1, y2 = y2, y1 end
    SetLimits(x1, y1, x2 - x1, y2 - y1)
    xx, yy = MousePosToRealPos(pt.x, pt.y)
  end
  mes = string.format("(%f,%f)", xx, yy)
  SetTipText(mes)
  mouseDown = nil
end

local function OnMouseEnter(event)
  stext:Show(true)
  tipwin:Show(true)
end

local function OnMouseLeave(event)
  stext:Show(false)
  tipwin:Show(false)
end

local function OnMouseRightUp(event)
  SetLimits(-2, -1.3, 3.47, 2.60)
end

local function OnIdle(event)
  if nextTime and wx.wxGetLocalTimeMillis():ToDouble() < nextTime then
    return
  end
  for i = 1, 100 do
    Step()
  end
  lastTime = thisTime
  local buf = buffer
  for n = 0, width * height - 1 do
    local cn = c[n + 1]
    if cn == 0 then
      buf:SetByte(3 * n, 0, 0, 0)
    else
      local col = math.log(cn) / math.log(ncolors)
      col = col - math.floor(col)
      col = (math.exp(col) - 1) / (math.exp(1) - 1)
      buf:SetByte(3 * n, HueToRGB(col + 0.5))
    end
  end
  local image = wx.wxImage(800, 600, buffer, true)
  bitmap = wx.wxBitmap(image)
  stext:SetLabel(tostring(count))
  frame:Refresh()
end

local function NewFrame()
  --  Create Frame (not resizable)
  frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxSize(width, height), bit32.band(wx.wxDEFAULT_FRAME_STYLE, bit32.bnot(wx.wxRESIZE_BORDER + wx.wxMAXIMIZE_BOX)))
  --  Create static text
  stext = wx.wxStaticText(frame, -1, "", wx.wxPoint(0, 0), wx.wxSize(80, 16))
  stext:SetBackgroundColour(wx.wxColour(220, 220, 220))
  font = wx.wxFont(14, wx.wxFONTFAMILY_SWISS, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL)
  stext:SetFont(font)
  stext:Show(false)
  --  Create tip window
  tipwin = wx.wxWindow(frame, -1, wx.wxPoint(0, 40), wx.wxSize(80, 14))
  tipwin:Connect(wx.wxEVT_PAINT, function (event) OnPaintTip(event) end)
  tipwin:SetBackgroundColour(wx.wxColour(220, 220, 128))
  tipfont = wx.wxFont(12, wx.wxFONTFAMILY_SWISS, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL)
  tipwin:SetFont(tipfont)
  SetTipText("test")
  tipwin:Show(false)
  --  Create buffer
  buffer = wx.wxMemoryBuffer(width * height * 3)
  buffer:Fill(0, 0, width * height * 3)
  --  Initialize data
  SetLimits(-2, -1.3, 3.47, 2.60)
  --  Connect paint event
  frame:Connect(wx.wxEVT_PAINT, function (event) OnPaint(event) end)
  frame:Connect(wx.wxEVT_ERASE_BACKGROUND, function(event) end)
  --  Connect mouse events
  frame:Connect(wx.wxEVT_MOTION, function (event) OnMouseMotion(event) end)
  frame:Connect(wx.wxEVT_LEFT_DOWN, function (event) OnMouseDown(event) end)
  frame:Connect(wx.wxEVT_LEFT_UP, function (event) OnMouseUp(event) end)
  frame:Connect(wx.wxEVT_RIGHT_UP, function (event) OnMouseRightUp(event) end)
  frame:Connect(wx.wxEVT_ENTER_WINDOW, function (event) OnMouseEnter(event) end)
  frame:Connect(wx.wxEVT_LEAVE_WINDOW, function (event) OnMouseLeave(event) end)
  --  Connect Idle event
  frame:Connect(wx.wxEVT_IDLE, function (event) OnIdle(event) end)
  frame:Show()
end

NewFrame()

wx.wxGetApp():MainLoop()
