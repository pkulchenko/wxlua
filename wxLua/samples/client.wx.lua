--[[
Name:        client.wx.lua
Purpose:     Client for wxSocket (ported wx samples)
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

local CLIENT_OPEN = 100
local CLIENT_TEST1 = 101
local CLIENT_TEST2 = 102
local CLIENT_TEST3 = 103
local CLIENT_CLOSE = 104
local CLIENT_TESTURL = 105
local CLIENT_DGRAM = 106
local SOCKET_ID = 107
local TESTURL_ID = 108
local NEWURL_ID = 109

function iff(cond, a, b) if cond then return a else return b end end

local m_sock = wx.wxSocketClient()
local m_busy = false;

--> File menu

local editorApp = wx.wxGetApp()
editorApp.VendorName = "WXLUA"
editorApp.AppName = "wxSocket demo: Server"

local menuBar = wx.wxMenuBar()
fileMenu = wx.wxMenu {
    {wx.wxID_ABOUT, "&About\tF1",       "About Client" },
    {},
    {wx.wxID_EXIT,  "E&xit\tAlt-X",     "Exit Program" }
}

protocolsMenu = wx.wxMenu {
    { TESTURL_ID, "Test URL",           "Read a file from a URL uses wxURL" },
    { NEWURL_ID,  "Alternate Test URL", "Read a file from a URL uses wxFileSystem" },
}

socketClientMenu= wx.wxMenu{
    {CLIENT_OPEN, "&Open session", "Connect to client"};
    {},
    {CLIENT_TEST1, "Test &1", "Test basic functionality"};
    {CLIENT_TEST2, "Test &2", "Test ReadMsg and WriteMsg"};
    {CLIENT_TEST3, "Test &3", "Test large data transfer"};
    {},
    {CLIENT_CLOSE, "&Close session", "Close connection"};
}

menuBar:Append(fileMenu, "&File")
menuBar:Append(socketClientMenu, "&SocketClient")
menuBar:Append(protocolsMenu, "&Protocols")
local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, editorApp:GetAppName() .. ' by ' .. editorApp:GetVendorName())

frame:SetMenuBar(menuBar)
local statusBar = frame:CreateStatusBar(1)
local m_text = wx.wxTextCtrl(frame, wx.wxID_ANY, "Welcome to wxSocket demo: Client\n",
                             wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTE_MULTILINE + wx.wxTE_READONLY)
frame:Show(true)

function display(m)
    m_text:AppendText(tostring(m)..'\n')
end

frame:Connect(SOCKET_ID, wx.wxEVT_SOCKET,
    function(event)
        local s
        local sock = event.Socket
        local socketEvent = event.SocketEvent
        if socketEvent  == wx.wxSOCKET_INPUT then
            s = "wxSOCKET_INPUT"
        elseif socketEvent  == wx.wxSOCKET_LOST then
            s = "wxSOCKET_LOST"
        elseif socketEvent  == wx.wxSOCKET_CONNECTION then
            s = "wxSOCKET_CONNECTION"
        else
            s = "Unexpected event !"
        end
        display ("Socket event: " .. s)
    end)

frame:Connect( wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        frame:Close()
    end)

frame:Connect(CLIENT_CLOSE, wx.wxEVT_UPDATE_UI,
    function (event)
        event:Enable(m_sock:IsConnected())
    end)

frame:Connect( CLIENT_CLOSE, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        m_sock:Close()
    end)

frame:Connect(wx.wxID_ABOUT, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        wx.wxMessageBox('Client sample.\n\n'..
            wxlua.wxLUA_VERSION_STRING.." built with "..wx.wxVERSION_STRING,
            "About wxLua",
            wx.wxOK + wx.wxICON_INFORMATION,
            frame)
    end )

frame:Connect(CLIENT_OPEN, wx.wxEVT_UPDATE_UI,
    function (event)
        event:Enable(not m_sock:IsConnected() and not m_busy)
    end)

frame:Connect(CLIENT_OPEN, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        local addr = wx.wxIPV4address()
        -- Ask user for server address
        local hostname = wx.wxGetTextFromUser("Enter the address of the wxSocket demo server:", "Connect ...", "localhost");
        addr:Hostname(hostname)
        addr:Service(port)
        display("\nTrying to connect (timeout = 10 sec) ...");
        m_sock:Connect(addr, false)
        m_sock:WaitOnConnect(10)
        if m_sock:IsConnected() then
            display("Succeeded ! Connection established\n");
        else
            m_sock:Close();
            display("Failed ! Unable to connect")
            wx.wxMessageBox("Can't connect to the specified host", "Alert !");
        end
        UpdateStatusBar();
    end)

frame:Connect(CLIENT_TEST1, wx.wxEVT_UPDATE_UI,
    function (event)
        event:Enable(m_sock:IsConnected() and not m_busy)
    end)

frame:Connect(CLIENT_TEST1, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        -- Disable socket menu entries (exception: Close Session)
        m_busy = true;
        UpdateStatusBar();

        display("\n=== Test 1 begins ===\n")

        -- Tell the server which test we are running
        local c = string.char( 11 * 16  + 14)
        m_sock:Write(c, 1);

        -- Send some data and read it back. We know the size of the
        -- buffer, so we can specify the exact number of bytes to be
        -- sent or received and use the wxSOCKET_WAITALL flag. Also,
        -- we have disabled menu entries which could interfere with
        -- the test, so we can safely avoid the wxSOCKET_BLOCK flag.
        --
        -- First we send a byte with the length of the string, then
        -- we send the string itself (do NOT try to send any integral
        -- value larger than a byte "as is" across the network, or
        -- you might be in trouble! Ever heard about big and little
        -- endian computers?)

        m_sock:SetFlags(wx.wxSOCKET_WAITALL)

        local buf1 = "Test string (less than 256 chars!)"
        local len  = string.char(#buf1)

        display("Sending a test buffer to the server ...")
        m_sock:Write(len, 1);
        m_sock:Write(buf1, #buf1);
        display(iff(m_sock:Error() , "failed !" , "done\n"))
        display("Receiving the buffer back from server ...")
        buf2 = m_sock:Read(#buf1)
        display(iff(m_sock:Error() , "failed !" , "done\n"))
        display("Comparing the two buffers ...")
        if buf1 ~= buf2 then
            display("failed!\n")
            display("Test 1 failed !\n")
        else
            display("done\n")
            display("Test 1 passed !\n")
        end
        display("=== Test 1 ends ===\n")

        m_busy = false;
        UpdateStatusBar();
    end)

frame:Connect(CLIENT_TEST2, wx.wxEVT_UPDATE_UI,
    function (event)
        event:Enable(m_sock:IsConnected() and not m_busy)
    end)

frame:Connect(CLIENT_TEST2, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        -- Disable socket menu entries (exception: Close Session)
        m_busy = true;
        UpdateStatusBar();

        display("\n=== Test 2 begins ===")

        -- Tell the server which test we are running
        local c = string.char( 12 * 16  + 14)
        m_sock:Write(c, 1);

        -- Here we use ReadMsg and WriteMsg to send messages with
        -- a header with size information. Also, the reception is
        -- event triggered, so we test input events as well.
        --
        -- We need to set no flags here (ReadMsg and WriteMsg are
        -- not affected by flags)

        m_sock:SetFlags(wx.wxSOCKET_WAITALL);

        local msg1 = wx.wxGetTextFromUser(
            "Enter an arbitrary string to send to the server:",
            "Test 2 ...",
            "Yes I like wxWidgets!")

        display("Sending the string with WriteMsg ...")
        m_sock:WriteMsg(msg1, #msg1);
        display(iff(m_sock:Error(), "failed !", "done"))
        display("Waiting for an event (timeout = 2 sec)\n")

        -- Wait until data available (will also return if the connection is lost)
        m_sock:WaitForRead(2);

        if m_sock:IsData() then
            display("Reading the string back with ReadMsg ...")
            local msg2 = m_sock:ReadMsg(#msg1)
            display(iff(m_sock:Error(), "failed !", "done"))
            display("Comparing the two buffers ...")
            if msg1 ~= msg2 then
                display("failed!")
                display("Test 2 failed !")
                display(msg1)
                display(msg2)
            else
                display("done")
                display("Test 2 passed !")
            end
        else
            display("Timeout ! Test 2 failed.")
        end
        display("=== Test 2 ends ===\n")

        m_busy = false;
        UpdateStatusBar();
    end)

frame:Connect(CLIENT_TEST3, wx.wxEVT_UPDATE_UI,
    function (event)
        event:Enable(m_sock:IsConnected() and not m_busy)
    end)

frame:Connect(CLIENT_TEST3, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        -- Disable socket menu entries (exception: Close Session)
        m_busy = true;
        UpdateStatusBar();

        display("\n=== Test 3 begins ===")

        -- Tell the server which test we are running
        local c = string.char( 13 * 16  + 14)
        m_sock:Write(c, 1);

        -- This test also is similar to the first one but it sends a
        -- large buffer so that wxSocket is actually forced to split
        -- it into pieces and take care of sending everything before
        -- returning.

        m_sock:SetFlags(wx.wxSOCKET_WAITALL);

        -- Note that len is in kbytes here!
        local len  = 32;
        local buf1, buf2
        local t = {}
        for  i = 0, len * 1024 do
            t[i] = string.char(math.mod(i,256))
        end
        buf1 = table.concat(t)
        display("Sending a large buffer (32K) to the server ...");
        m_sock:Write(string.char(len), 1);
        m_sock:Write(buf1, len * 1024);
        display(iff(m_sock:Error(), "failed !", "done"))
        display("Receiving the buffer back from server ...");
        buf2 = m_sock:Read(len * 1024);
        display(iff(m_sock:Error(), "failed !", "done"))
        display("Comparing the two buffers ...");
        if buf1 ~= buf2 then
            display("failed!")
            display("Test 3 failed !")
        else
            display("done")
            display("Test 3 passed !")
        end
        display("=== Test 3 ends ===")

        m_busy = false;
        UpdateStatusBar();
    end)

local last_url = "http://wxlua.sourceforge.net"
function GetUrl()
    local url = wx.wxGetTextFromUser("Enter an URL to get", "URL:", "http://wxlua.sourceforge.net");

    -- If they canceled the dialog the returned string is empty, don't save it
    if (string.len(url) > 0) then
        last_url = url
    end

    return url
end

frame:Connect(TESTURL_ID, wx.wxEVT_COMMAND_MENU_SELECTED,
    function(event)
        -- Note that we are creating a new socket here, so this
        -- won't mess with the client/server demo.

        -- Ask for the URL
        display("\n=== URL test begins ===")
        local urlname = GetUrl()
        -- They canceled the dialog
        if (string.len(urlname) < 1) then
            return
        end
        -- Parse the URL
        local url = wx.wxURL(urlname);
        if url:GetError() ~= wx.wxURL_NOERR then
            display("Error: couldn't parse URL")
            display("=== URL test ends ===")
            return;
        end

        -- Try to get the input stream (connects to the given URL)
        display("Trying to establish connection...")
        data = url:GetInputStream();
        if not data then
            display("Error: couldn't read from URL")
            display("=== URL test ends ===")
            return;
        end
        -- Print the contents type and file size
        display("Contents type: " .. url:GetProtocol():GetContentType() ..
            "File size: " ..data:GetSize() .. "\nStarting to download...")

        -- Get the data
        local fileTest = wx.wxFile("test.url", wx.wxFile.write)
        local sout = wx.wxFileOutputStream(fileTest)
        if not sout:Ok() then
            display("Error: couldn't open 'test.url' file for output")
            display("=== URL test ends ===")
            return;
        end
        data:Read(sout);
        display("Results written to file: test.url")
        display("Done.")
        display("=== URL test ends ===")
        fileTest:delete()
    end)

frame:Connect(NEWURL_ID, wx.wxEVT_COMMAND_MENU_SELECTED,
    function(event)
        display("\n=== URL test begins ===")
        local urlname = GetUrl()
        if (string.len(urlname) < 1) then
            return
        end
        local file = wx.wxFileSystem():OpenFile(urlname)
        if not file then
            display("Could not access URL") return
        end
        local data = file:GetStream()
        local text = {}
        repeat
            local c= data.C
            if data:LastRead() ~= 0  then
                text[#text+1]=string.char(c)
            end
        until data:LastRead() == 0
        local fileTest = wx.wxFile("test.url", wx.wxFile.write)
        if not fileTest then
            display('Could not open "test.url" to output!')
            display("=== URL test ends ===")
            return;
        end
        fileTest:Write(table.concat(text))
        display("Results written to file: test.url")
        display("Done.")
        display("=== URL test ends ===")
        fileTest:delete()
    end)

function UpdateStatusBar()
    local s
    if not m_sock:IsConnected() then
        s = "Not connected"
    else
        local addr = wx.wxIPV4address()
        m_sock:GetPeer(addr)
        s = addr:Hostname()..' : '..addr:Service()
    end
    frame:SetStatusText(s);
end

-- Setup the event handler and subscribe to most events
m_sock:SetEventHandler(frame, SOCKET_ID);
m_sock:SetNotify(wx.wxSOCKET_CONNECTION_FLAG + wx.wxSOCKET_INPUT_FLAG + wx.wxSOCKET_LOST_FLAG);
m_sock:Notify(true);
display('Client ready')
UpdateStatusBar();

-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
wx.wxGetApp():MainLoop()

