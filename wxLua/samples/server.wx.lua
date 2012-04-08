--[[
Name:        server.wx.lua
Purpose:     Server for wxSocket (ported wx samples)
Author:      Andre Arpin
Modified by:
Created:     27-10-2010
Copyright:   (c) 2010 Andre Arpin
Licence:     wxWindows licence
--]]

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

local version = '0.0'
local port = 3000
local SERVER_ID, SOCKET_ID = 100, 101
local m_busy = false
local m_numClients = 0

function iff(cond, a, b) if cond then return a else return b end end

--> File menu

local editorApp = wx.wxGetApp()
editorApp.VendorName = "WXLUA"
editorApp.AppName = "wxSocket demo: Server"

local menuBar = wx.wxMenuBar()
fileMenu = wx.wxMenu{
    {wx.wxID_ABOUT, "&About\tF1",       "About Server" },
    {},
    {wx.wxID_EXIT,  "E&xit\tAlt-X",     "Exit Program" }
}

menuBar:Append(fileMenu, "&File")

local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, editorApp:GetAppName() .. ' by ' .. editorApp:GetVendorName())

frame:SetMenuBar(menuBar)
local statusBar = frame:CreateStatusBar(1)
local m_text = wx.wxTextCtrl(frame, wx.wxID_ANY, "Welcome to wxSocket demo: Server\n",     wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTE_MULTILINE + wx.wxTE_READONLY)
frame:Show(true)

--> Create the socket
local addr = wx.wxIPV4address()
addr:Service(port)
local  m_server = wx.wxSocketServer(addr)

function display(m)
    m_text:AppendText(m..'\n')
end

local function test1(sock)
    display("Test 1 begin")
    sock.Flags = wx.wxSOCKET_WAITALL
    local length = string.byte(sock:Read(1))
    local buffer = sock:Read(length)
    display("Got the data, sending it back")
    sock:Write(buffer, length)
    display("Test 1 end")
end

local function test2(sock)
    display("Test 2 begin")
    local message = sock:ReadMsg(10000)
    local translate = {}
    for i= 1, #message do
        local b = string.byte(message, i, i)
        if b ~= 0 then translate[#translate+1] = string.char(b) end
    end
    display("Client says: ".. table.concat(translate))
    sock:WriteMsg(message)
    display("Test 2 end")
end


local function test3(sock)
    display("Test 3 begin")
    sock.Flags = wx.wxSOCKET_WAITALL
    local length = string.byte(sock:Read(1)) * 1024
    display("Transferring :" .. length)
    local buffer = sock:Read(length)
    display("Got the data, sending it back")
    sock:Write(buffer, length)
    display("Test 3 end")
end

frame:Connect( wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        frame:Close()
    end)

frame:Connect(wx.wxID_ABOUT, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        wx.wxMessageBox('Server sample.\n\n'..
            wxlua.wxLUA_VERSION_STRING.." built with "..wx.wxVERSION_STRING,
            "About wxLua",
            wx.wxOK + wx.wxICON_INFORMATION,
            frame)
    end )

frame:Connect(SOCKET_ID, wx.wxEVT_SOCKET,
    function(event)
        display("Socket event:")
        local sock = event.Socket
        local socketEvent = event.SocketEvent
        if socketEvent  == wx.wxSOCKET_INPUT then
            display('wx.wxSOCKET_INPUT')
            -- We disable input events, so that the test doesn't trigger wxSocketEvent again.
            sock.Notify = wx.wxSOCKET_LOST_FLAG
            local v = string.byte(sock:Read(1))
            if v == 11*16+14 then
                test1(sock)
            elseif v == 12*16+14 then
                test2(sock)
            elseif v == 13*16+14 then
                test3(sock)
            else
                display(string.byte("Unknown test id: ".. v .." received from client"))
            end
            sock.Notify = wx.wxSOCKET_LOST_FLAG + wx.wxSOCKET_INPUT_FLAG
        elseif socketEvent == wx.wxSOCKET_LOST then
            display('wx.wxSOCKET_LOST')
            m_numClients = m_numClients -1
            UpdateStatusBar()
        else
            display("Unexpected socketEvent")
            display("Deleting socket.");
            sock:Destroy();
        end
    end)

frame:Connect(SERVER_ID, wx.wxEVT_SOCKET,
    function(event)
        if event:GetSocketEvent()  == wx.wxSOCKET_CONNECTION then
            display("wxSOCKET_CONNECTION")
        else
            display("Unexpected event !")
        end
        local sock = m_server:Accept(false)
        if sock then
            display("New client connection accepted")
        else
            display("Error: couldn't accept a new connection")
            return
        end
        sock:SetEventHandler(frame, SOCKET_ID)
        sock:SetNotify(wx.wxSOCKET_INPUT_FLAG + wx.wxSOCKET_LOST_FLAG);
        sock:Notify(true)
        m_numClients = m_numClients + 1
        UpdateStatusBar()
    end)

function UpdateStatusBar()
    frame:SetStatusText('client connected: '.. m_numClients);
end

if m_server:Ok() then
    display("\nServer listening.")
    m_server:SetEventHandler(frame, SERVER_ID)
    m_server:SetNotify(wx.wxSOCKET_CONNECTION_FLAG);
    m_server:Notify(true)
    UpdateStatusBar()
else
    display("\nCould not listen at the specified port !")
end

-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
wx.wxGetApp():MainLoop()

