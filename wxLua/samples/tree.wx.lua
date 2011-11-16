-----------------------------------------------------------------------------
-- Name:        tree.wx.lua
-- Purpose:     wxTreeCtrl wxLua sample
-- Author:      J Winwood
-- Modified by:
-- Created:     16/11/2001
-- RCS-ID:
-- Copyright:   (c) 2001 J Winwood. All rights reserved.
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

-- create a nice string using the wxTreeItemId and our table of "data"
function CreateLogString(treeCtrl, treeitem_id)
    local value = treeitem_id:GetValue()
    local str = "wxTreeItemId:GetValue():"..tostring(value)
    str = str.."\n    Lua Table Data: '"..treedata[value].data.."'"
    
    local wxltreeitemdata = treeCtrl:GetItemData(treeitem_id)
    if (wxltreeitemdata) then
        str = str.."\n    wxTreeCtrl:GetItemData():GetId():GetValue() "..tostring(wxltreeitemdata:GetId():GetValue())
        str = str.."\n    wxTreeCtrl:GetItemData():GetData() "..tostring(wxltreeitemdata:GetData())
    end
    
    return str
end

-- Function to enumerates the tree and prints the text of each node
-- It also verifies that the wxTreeItemIdValue cookie works
function enumerateTreeCtrl(treeCtrl, root_id, level)
    if (not root_id) then
        root_id = treeCtrl:GetRootItem()
    end
    if (not level) then
        level = 0
    end
    
    print("wxTreeCtrl nodes: "..string.rep("-", level) .. treeCtrl:GetItemText(root_id))
    
    local child_id, cookie = treeCtrl:GetFirstChild(root_id)
    while (child_id:IsOk()) do
        enumerateTreeCtrl(treeCtrl, child_id, level+1)
        child_id, cookie = treeCtrl:GetNextChild(root_id, cookie) 
    end
end

function main()
    frame = wx.wxFrame( wx.NULL, wx.wxID_ANY, "wxLua wxTreeCtrl Sample",
                        wx.wxDefaultPosition, wx.wxSize(450, 400),
                        wx.wxDEFAULT_FRAME_STYLE )

    -- create the menubar and attach it
    local fileMenu = wx.wxMenu()
    fileMenu:Append(wx.wxID_EXIT, "E&xit", "Quit the program")
    local helpMenu = wx.wxMenu()
    helpMenu:Append(wx.wxID_ABOUT, "&About", "About the wxLua wxTreeCtrl Sample")

    local menuBar = wx.wxMenuBar()
    menuBar:Append(fileMenu, "&File")
    menuBar:Append(helpMenu, "&Help")

    frame:SetMenuBar(menuBar)

    -- connect the selection event of the exit menu item to an
    -- event handler that closes the window
    frame:Connect(wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED,
        function (event)
            frame:Close(true)
        end )

    -- connect the selection event of the about menu item
    frame:Connect(wx.wxID_ABOUT, wx.wxEVT_COMMAND_MENU_SELECTED,
        function (event)
            wx.wxMessageBox('This is the "About" dialog of the wxLua wxTreeCtrl sample.\n'..
                            wxlua.wxLUA_VERSION_STRING.." built with "..wx.wxVERSION_STRING,
                            "About wxLua",
                            wx.wxOK + wx.wxICON_INFORMATION,
                            frame)
        end )

    -- Create an image list for the treectrl
    local imgSize = wx.wxSize(16, 16)
    imageList = wx.wxImageList(imgSize:GetWidth(), imgSize:GetHeight());
    imageList:Add(wx.wxArtProvider.GetBitmap(wx.wxART_FOLDER, wx.wxART_TOOLBAR, imgSize))
    imageList:Add(wx.wxArtProvider.GetBitmap(wx.wxART_NEW_DIR, wx.wxART_TOOLBAR, imgSize))
    imageList:Add(wx.wxArtProvider.GetBitmap(wx.wxART_FLOPPY, wx.wxART_TOOLBAR, imgSize))

    -- create our treectrl
    treeCtrl = wx.wxTreeCtrl( frame, wx.wxID_ANY,
                              wx.wxDefaultPosition, wx.wxSize(-1, 200),
                              wx.wxTR_LINES_AT_ROOT + wx.wxTR_HAS_BUTTONS )
    -- We'll use AssignImageList and the treeCtrl takes ownership and will delete 
    -- the image list.
    -- If you use SetImageList, the imageList must exist for the life of the treeCtrl
    treeCtrl:AssignImageList(imageList) 

    -- create our log window
    textCtrl = wx.wxTextCtrl( frame, wx.wxID_ANY, "",
                              wx.wxDefaultPosition, wx.wxSize(-1, 200),
                              wx.wxTE_READONLY + wx.wxTE_MULTILINE )

    rootSizer = wx.wxFlexGridSizer(0, 1, 0, 0)
    rootSizer:AddGrowableCol(0)
    rootSizer:AddGrowableRow(0)
    rootSizer:Add( treeCtrl, 0, wx.wxGROW+wx.wxALIGN_CENTER_HORIZONTAL, 0 )
    rootSizer:Add( textCtrl, 0, wx.wxGROW+wx.wxALIGN_CENTER_HORIZONTAL, 0 )
    frame:SetSizer( rootSizer )
    frame:Layout() -- help sizing the windows before being shown

    -- create a table to store any extra information for each node like this
    -- you don't have to store the id in the table, but it might be useful
    -- treedata[id] = { id=wx.wxTreeCtrlId, data="whatever data we want" }
    treedata = {}

    -- You must ALWAYS create a root node, but you can hide it with the wxTR_HIDE_ROOT window style
    local root_id = treeCtrl:AddRoot( "Root", 2, -1 )
    treedata[root_id:GetValue()] = { id = root_id:GetValue(), data = "I'm the root item" }

    for idx = 0, 9 do
        -- Add parent nodes just off the root
        local parent_id = treeCtrl:AppendItem( root_id, "Parent ("..idx..")", 0, 1)
        treedata[parent_id:GetValue()] = { id = parent_id:GetValue(), data = "I'm the data for Parent ("..idx..")" }
        for jdx = 0, 4 do
            -- Add children nodes
            local child_id = treeCtrl:AppendItem( parent_id, "Child ("..idx..", "..jdx..")" )
            treedata[child_id:GetValue()] = { id = child_id:GetValue(), data = "I'm the data for Child ("..idx..", "..jdx..")" }

            -- Add one grandchild
            if (jdx == 1) then
                local child2_id = treeCtrl:AppendItem( child_id, "GrandChild ("..idx..", "..jdx..", 0)" )
                treedata[child2_id:GetValue()] = { id = child2_id:GetValue(), data = "I'm the data for GrandChild ("..idx..", "..jdx..")" }
            end
        end
        if (idx == 2) or (idx == 5) then
            treeCtrl:Expand(parent_id)
        end
    end

    -- You may use the above simple method of using a Lua table to store extra
    -- data for each treectrl node or you can SetItemData() for each node.
    -- Note that the wxTreeCtrl::Append/Insert/Prepend() functions can take a 
    -- a wxLuaTreeItemData as a parameter directly.
    -- DO NOT ever try to attach the same wxLuaTreeItemData to different nodes!
    -- The wxTreeCtrl takes ownership of the wxLuaTreeItemData and deletes it.

    -- Set some simple data to the root node
    local wxltreeitemdata = wx.wxLuaTreeItemData()
    treeCtrl:SetItemData(treeCtrl:GetRootItem(), wxltreeitemdata)

    -- Set more complicated data to the first child
    local wxltreeitemdata = wx.wxLuaTreeItemData("hello, I'm string data")
    treeCtrl:SetItemData(treeCtrl:GetFirstChild(treeCtrl:GetRootItem()), wxltreeitemdata)

    enumerateTreeCtrl(treeCtrl)

    -- connect to some events from the wxTreeCtrl
    treeCtrl:Connect( wx.wxEVT_COMMAND_TREE_ITEM_EXPANDING,
        function( event )
            local item_id = event:GetItem()
            local str = "Item expanding : "..CreateLogString(treeCtrl, item_id).."\n"
            textCtrl:AppendText(str)
        end )
    treeCtrl:Connect( wx.wxEVT_COMMAND_TREE_ITEM_COLLAPSING,
        function( event )
            local item_id = event:GetItem()
            local str = "Item collapsing : "..CreateLogString(treeCtrl, item_id).."\n"
            textCtrl:AppendText(str)
        end )
    treeCtrl:Connect( wx.wxEVT_COMMAND_TREE_ITEM_ACTIVATED,
        function( event )
            local item_id = event:GetItem()
            local str = "Item activated : "..CreateLogString(treeCtrl, item_id).."\n"
            textCtrl:AppendText(str)
        end )
    treeCtrl:Connect( wx.wxEVT_COMMAND_TREE_SEL_CHANGED,
        function( event )
            local item_id = event:GetItem()
            local str = "Item sel changed : "..CreateLogString(treeCtrl, item_id).."\n"
            textCtrl:AppendText(str)
        end )

    treeCtrl:Expand(root_id)
    wx.wxGetApp():SetTopWindow(frame)

    frame:Show(true)
    
    collectgarbage("collect")
end

main()

-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
wx.wxGetApp():MainLoop()
