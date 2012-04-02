-----------------------------------------------------------------------------
-- Name:        art.wx.lua
-- Purpose:     wxArtProvider wxLua sample
-- Author:      John Labenski
-- Modified by:
-- Created:     16/11/2012
-- Copyright:   (c) 2012 John Labenski. All rights reserved.
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

-- --------------------------------------------------------------------------

frame = nil

-- --------------------------------------------------------------------------
-- Initialize the wxArtProvider variables

local artClients = {}
local artIds     = {}

for k, v in pairs(wx) do
    if (k:find("wxART_[A-Z_]*") ~= nil) then
        -- wxArtClients values end with "_C"
        if v:sub(-2,-1) == "_C" then
            artClients[#artClients+1] = k
        else  
            artIds[#artIds+1] = k
        end
    end
end

local char_width         = nil -- cache value
local char_height        = nil
local colLefts           = nil
local colWidths          = nil
local rowTops            = nil
local rowHeights         = nil
local did_set_scrollbars = false

-- --------------------------------------------------------------------------
-- paint event handler for the panel that's called by wxEVT_PAINT
function OnPaint(event)
    -- must always create a wxPaintDC in a wxEVT_PAINT handler
    local dc = wx.wxPaintDC(panel)
    panel:PrepareDC(dc)
    
    local row_height = 50    
    local x_padding  = 10
    
    -- Find the sizes of things for later
    if not char_height then    
        local textExtentSize = dc:GetTextExtentSize("MMMM")
        char_height = textExtentSize:GetHeight()/2
        char_width  = textExtentSize:GetWidth()/4

        -- find the max width of the wxArtID strings
        local col0_width = 0

        for r = 1, #artIds do
            local artIdTextExtent = dc:GetTextExtentSize(artIds[r])
            local w = artIdTextExtent:GetWidth();
            if w > col0_width then 
                col0_width = w
            end
        end

        colWidths     = {};
        colWidths[0]  = col0_width + x_padding

        colLefts      = {};
        colLefts[0]   = 0
        colLefts[1]   = colWidths[0]        

        rowHeights    = {}
        rowHeights[0] = 50

        rowTops       = {}
        rowTops[0]    = 0
        rowTops[1]    = rowHeights[0]        

        for c = 1, #artClients do
            local artClientTextExtent = dc:GetTextExtentSize(artClients[c])
            local w = artClientTextExtent:GetWidth();
            
            colWidths[c]  = w + x_padding
            colLefts[c+1] = colLefts[c] + colWidths[c]

            for r = 1, #artIds do                        
                local artClient = wx[artClients[c]]
                local artId     = wx[artIds[r]]
                
                local bmp = wx.wxArtProvider.GetBitmap(artId, artClient)
                if bmp:Ok() then
                    local w, h = bmp:GetWidth(), bmp:GetHeight()
                    if (not rowHeights[r]) or (rowHeights[r] < h + 10) then 
                        rowHeights[r] = h + 10
                    end
                else
                    rowHeights[r] = 50
                end
                bmp:delete()
            end
        end

        for r = 0, #rowHeights do
            rowTops[r+1] = rowTops[r]+rowHeights[r]
        end
        rowTops[#rowTops+1] = rowTops[#rowTops] + rowHeights[#rowHeights]
    end   
    
    dc:DrawText("wxArtID  /  wxArtClient", x_padding/2, rowHeights[0]/2-char_height/2)
       
    for c = 0, #artClients do
        for r = 0, #artIds do
        
            local artClient = wx[artClients[c]]
            local artId     = wx[artIds[r]]
        
            local row_top    = rowTops[r+1]
            local row_height = rowHeights[r]
        
            if r == 0 then
                if c > 0 then
                    dc:DrawText(artClients[c], colLefts[c]+x_padding/2, rowTops[r]+rowHeights[r]/2-char_height/2)
                    
                    local artSizePlatform = wx.wxArtProvider.GetSizeHint(artClient, true)
                    local artSize = wx.wxArtProvider.GetSizeHint(artClient, false)
                    
                    local art_size_platform_str = string.format("(%d, %d)", artSizePlatform:GetWidth(), artSizePlatform:GetHeight())
                    local art_size_str          = string.format("(%d, %d)", artSize:GetWidth(),         artSize:GetHeight())

                    local textExtentPlatformStr = dc:GetTextExtentSize(art_size_platform_str)
                    local textExtentSizeStr     = dc:GetTextExtentSize(art_size_str)

                    dc:DrawText(art_size_platform_str,
                                colLefts[c]+colWidths[c]/2 - textExtentPlatformStr:GetWidth()/2 + x_padding/2, 
                                rowTops[r+1]                     + (rowHeights[r+1]/2 - textExtentPlatformStr:GetHeight())/2 )
                    dc:DrawText(art_size_str,
                                colLefts[c]+colWidths[c]/2 - textExtentSizeStr:GetWidth()/2     + x_padding/2, 
                                rowTops[r+1] + rowHeights[r+1]/2 + (rowHeights[r+1]/2 - textExtentSizeStr:GetHeight())/2 )
                elseif c == 0 then                
                    dc:DrawText("Native Size",      x_padding/2, rowTops[r+1]                     + (rowHeights[r+1]/2 - char_height)/2 )
                    dc:DrawText("ArtProvider Size", x_padding/2, rowTops[r+1] + rowHeights[r+1]/2 + (rowHeights[r+1]/2 - char_height)/2 )
                end
            elseif c == 0 then
                if r > 0 then
                    dc:DrawText(artId, colLefts[c]+x_padding/2, rowTops[r+1]+rowHeights[r]/2-char_height/2)
                end
            else       
                local bmp = wx.wxArtProvider.GetBitmap(artId, artClient)
                if bmp:Ok() then
                    local w, h = bmp:GetWidth(), bmp:GetHeight()
                    dc:DrawBitmap(bmp, colLefts[c]+colWidths[c]/2-w/2, rowTops[r+1]+rowHeights[r]/2-h/2, true)
                end
                bmp:delete()
            end
            
            dc:DrawLine(colLefts[0],         rowTops[r+1], 
                        colLefts[#colLefts], rowTops[r+1])
        end
        
        dc:DrawLine(colLefts[c]+colWidths[c], 0, 
                    colLefts[c]+colWidths[c], rowTops[#rowTops])
    end

    dc:DrawLine(colLefts[0],         rowTops[#rowTops], 
                colLefts[#colLefts], rowTops[#rowTops])
    
    if not did_set_scrollbars then
        did_set_scrollbars = true
        panel:SetScrollbars(20, 20, 
                            math.ceil((colLefts[#colLefts]-10)/20), 
                            math.ceil((rowTops[#rowTops])/20), 0, 0, false);
    end
    
    -- the paint DC will be automatically destroyed by the garbage collector,
    -- however on Windows 9x/Me this may be too late (DC's are precious resource)
    -- so delete it here
    dc:delete() -- ALWAYS delete() any wxDCs created when done
end

-- Create a function to encapulate the code, not necessary, but it makes it
--  easier to debug in some cases.
function main()

    -- create the wxFrame window
    frame = wx.wxFrame( wx.NULL,                    -- no parent for toplevel windows
                        wx.wxID_ANY,                -- don't need a wxWindow ID
                        "wxLua wxArtProvider Demo", -- caption on the frame
                        wx.wxDefaultPosition,       -- let system place the frame
                        wx.wxSize(450, 450),        -- set the size of the frame
                        wx.wxDEFAULT_FRAME_STYLE )  -- use default frame styles

    -- create a single child window, wxWidgets will set the size to fill frame
    panel = wx.wxScrolledWindow(frame, wx.wxID_ANY)
    panel:SetScrollbars(200, 200, 20, 20, 0, 0, true);

    -- connect the paint event handler function with the paint event
    panel:Connect(wx.wxEVT_PAINT, OnPaint)

    -- create a simple file menu
    local fileMenu = wx.wxMenu()
    fileMenu:Append(wx.wxID_EXIT, "E&xit", "Quit the program")

    -- create a simple help menu
    local helpMenu = wx.wxMenu()
    helpMenu:Append(wx.wxID_ABOUT, "&About", "About the wxLua Minimal Application")

    -- create a menu bar and append the file and help menus
    local menuBar = wx.wxMenuBar()
    menuBar:Append(fileMenu, "&File")
    menuBar:Append(helpMenu, "&Help")

    -- attach the menu bar into the frame
    frame:SetMenuBar(menuBar)

    -- create a simple status bar
    frame:CreateStatusBar(1)
    frame:SetStatusText("Welcome to wxLua.")

    -- connect the selection event of the exit menu item to an
    -- event handler that closes the window
    frame:Connect(wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED,
                  function (event) frame:Close(true) end )

    -- connect the selection event of the about menu item
    frame:Connect(wx.wxID_ABOUT, wx.wxEVT_COMMAND_MENU_SELECTED,
        function (event)
            wx.wxMessageBox('This is the "About" dialog of the Minimal wxLua sample.\n'..
                            wxlua.wxLUA_VERSION_STRING.." built with "..wx.wxVERSION_STRING,
                            "About wxLua",
                            wx.wxOK + wx.wxICON_INFORMATION,
                            frame)
        end )

    -- show the frame window
    frame:Show(true)
end

main()

-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
wx.wxGetApp():MainLoop()
