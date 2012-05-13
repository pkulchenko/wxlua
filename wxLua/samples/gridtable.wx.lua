-----------------------------------------------------------------------------
-- Name:        gridtable.wx.lua
-- Purpose:     wxGridTable wxLua sample
-- Author:      Hakki Dogusan, Michael Bedward
-- Created:     January 2008
-- Copyright:   (c) 2008 Hakki Dogusan, Michael Bedward
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")


BugsGridTable = {} -- This is the underlying data to show in the wxGrid

local function InitializeGridTable(grid, gridtable)

    BugsGridTable.gridtable = gridtable

    -- The columns in the grid so we can access them by name rather than number
    BugsGridTable.Col_Id       = 0
    BugsGridTable.Col_Summary  = 1
    BugsGridTable.Col_Severity = 2
    BugsGridTable.Col_Priority = 3
    BugsGridTable.Col_Platform = 4
    BugsGridTable.Col_Opened   = 5
    BugsGridTable.Col_Max      = 6

    -- Values for the severity column
    BugsGridTable.Sev_Wish     = 0
    BugsGridTable.Sev_Minor    = 1
    BugsGridTable.Sev_Normal   = 2
    BugsGridTable.Sev_Major    = 3
    BugsGridTable.Sev_Critical = 4
    BugsGridTable.Sev_Max      = 5

    -- Names for the severity column values
    BugsGridTable.Severities =
    {
        "wishlist",
        "minor",
        "normal",
        "major",
        "critical",
    };

    -- The data that we show in the grid, stored in a Lua table
    BugsGridTable.gs_dataBugsGrid =
    {
        { id = 18, summary = "foo doesn't work",  severity = BugsGridTable.Sev_Major,    prio = 1, platform = "wxMSW", opened = true  },
        { id = 27, summary = "bar crashes",       severity = BugsGridTable.Sev_Critical, prio = 1, platform = "all",   opened = false },
        { id = 45, summary = "printing is slow",  severity = BugsGridTable.Sev_Minor,    prio = 3, platform = "wxMSW", opened = true  },
        { id = 68, summary = "Rectangle() fails", severity = BugsGridTable.Sev_Normal,   prio = 1, platform = "wxMSW", opened = false },
    };

    -- The column headers
    BugsGridTable.ColHeaders  =
    {
        "Id",
        "Summary",
        "Severity",
        "Priority",
        "Platform",
        "Opened?",
    };

    --wxString BugsGridTable::GetTypeName(int WXUNUSED(row), int col)
    gridtable.GetTypeName = function( self, row, col )
        local type_name = ""
    
        if (col == BugsGridTable.Col_Id) or (col == BugsGridTable.Col_Priority) then
            type_name = wx.wxGRID_VALUE_NUMBER
        elseif (col == BugsGridTable.Col_Severity) or (col == BugsGridTable.Col_Summary) then
            type_name = string.format("%s:80", wx.wxGRID_VALUE_STRING)
        elseif col == BugsGridTable.Col_Platform then
            type_name = string.format("%s:all,MSW,GTK,other", wx.wxGRID_VALUE_CHOICE)
        elseif col == BugsGridTable.Col_Opened then
            type_name = wx.wxGRID_VALUE_BOOL
        else
            error("Unknown column")
        end
        
        return type_name
    end

    --int BugsGridTable::GetNumberRows()
    gridtable.GetNumberRows = function( self )
        return #BugsGridTable.gs_dataBugsGrid
    end

    --int BugsGridTable::GetNumberCols()
    gridtable.GetNumberCols = function( self )
        return BugsGridTable.Col_Max
    end

    --bool BugsGridTable::IsEmptyCell( int WXUNUSED(row), int WXUNUSED(col) )
    gridtable.IsEmptyCell = function( self, row, col )
        return false
    end

    --wxString BugsGridTable::GetValue( int row, int col )
    gridtable.GetValue = function( self, row, col )
        local function iff(cond, A, B) if cond then return A else return B end end

        local value = ""
        local gd = BugsGridTable.gs_dataBugsGrid[row+1]
        
        if     col == BugsGridTable.Col_Id       then value = string.format("%d", gd.id);
        elseif col == BugsGridTable.Col_Priority then value = string.format("%d", gd.prio);
        elseif col == BugsGridTable.Col_Opened   then value = iff(gd.opened, "1", "0")
        elseif col == BugsGridTable.Col_Severity then value = BugsGridTable.Severities[gd.severity+1];
        elseif col == BugsGridTable.Col_Summary  then value = gd.summary;
        elseif col == BugsGridTable.Col_Platform then value = gd.platform;
        end
        
        return value
    end

    --void BugsGridTable::SetValue( int row, int col, const wxString& value )
    gridtable.SetValue = function( self, row, col, value )
        local gd = BugsGridTable.gs_dataBugsGrid[row+1]
        
        if (col == BugsGridTable.Col_Id) or (col == BugsGridTable.Col_Priority) or (col == BugsGridTable.Col_Opened) then
            error("unexpected column")
        elseif col == BugsGridTable.Col_Severity then
            for n = 1, #BugsGridTable.Severities do
                if BugsGridTable.Severities[n] == value then
                    gd.severity = n-1
                    return
                end
            end
            --Invalid severity value
            gd.severity = BugsGridTable.Sev_Normal
        elseif col == BugsGridTable.Col_Summary then
            gd.summary = value
        elseif col == BugsGridTable.Col_Platform then
            gd.platform = value
        end
    end

    --bool
    --BugsGridTable::CanGetValueAs(int WXUNUSED(row),
    --                             int col,
    --                             const wxString& typeName)
    gridtable.CanGetValueAs = function( self, row, col, typeName )
        if typeName == wx.wxGRID_VALUE_STRING then
            return true
        elseif typeName == wx.wxGRID_VALUE_BOOL then
            return col == BugsGridTable.Col_Opened
        elseif typeName == wx.wxGRID_VALUE_NUMBER then
            return (col == BugsGridTable.Col_Id) or (col == BugsGridTable.Col_Priority) or (col == BugsGridTable.Col_Severity)
        else
            return false
        end
    end

    --bool BugsGridTable::CanSetValueAs( int row, int col, const wxString& typeName )
    gridtable.CanSetValueAs = function( self, row, col, typeName )
        return self:CanGetValueAs(row, col, typeName)
    end

    --long BugsGridTable::GetValueAsLong( int row, int col )
    gridtable.GetValueAsLong = function( self, row, col )
        local gd = BugsGridTable.gs_dataBugsGrid[row+1]

        if     col == BugsGridTable.Col_Id       then return gd.id;
        elseif col == BugsGridTable.Col_Priority then return gd.prio;
        elseif col == BugsGridTable.Col_Severity then return gd.severity;
        else
            error("unexpected column");
            return -1;
        end
    end

    --bool BugsGridTable::GetValueAsBool( int row, int col )
    gridtable.GetValueAsBool = function( self, row, col )
        if col == BugsGridTable.Col_Opened then
            return BugsGridTable.gs_dataBugsGrid[row+1].opened;
        else
            error("unexpected column");
            return false;
        end
    end

    --void BugsGridTable::SetValueAsLong( int row, int col, long value )
    gridtable.SetValueAsLong = function( self, row, col, value )
        local gd = BugsGridTable.gs_dataBugsGrid[row+1]

        if col == BugsGridTable.Col_Priority then
            gd.prio = value;
        else
            error("unexpected column");
        end
    end

    --void BugsGridTable::SetValueAsBool( int row, int col, bool value )
    gridtable.SetValueAsBool = function( self, row, col, value )
        if col == BugsGridTable.Col_Opened then
            BugsGridTable.gs_dataBugsGrid[row+1].opened = value;
        else
            error("unexpected column");
        end
    end

    --wxString BugsGridTable::GetColLabelValue( int col )
    gridtable.GetColLabelValue = function( self, col )
        return BugsGridTable.ColHeaders[col+1];
    end

    -- Set the table to the grid, this allows the following SetColAttr() functions
    -- to work, otherwise they silently do nothing.
    local rc = grid:SetTable(gridtable, true)
    
    -- Set up the editors for the gridtable values
    
    local attrRO          = wx.wxGridCellAttr()
    local attrRangeEditor = wx.wxGridCellAttr()
    local attrCombo       = wx.wxGridCellAttr()

    local rangeEditor  = wx.wxGridCellNumberEditor(1, 5)
    local choiceEditor = wx.wxGridCellChoiceEditor(BugsGridTable.Severities)

    attrRO:SetReadOnly()
    attrRangeEditor:SetEditor(rangeEditor)
    attrCombo:SetEditor(choiceEditor);

    grid:SetColAttr(BugsGridTable.Col_Id,       attrRO)
    grid:SetColAttr(BugsGridTable.Col_Priority, attrRangeEditor)
    grid:SetColAttr(BugsGridTable.Col_Severity, attrCombo)
end


local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "wxLua wxGrid Sample",
                         wx.wxPoint(25, 25), wx.wxSize(350, 250))

local fileMenu = wx.wxMenu("", wx.wxMENU_TEAROFF)
fileMenu:Append(wx.wxID_EXIT, "E&xit\tCtrl-X", "Quit the program")

local helpMenu = wx.wxMenu("", wx.wxMENU_TEAROFF)
helpMenu:Append(wx.wxID_ABOUT, "&About\tCtrl-A", "About the Grid wxLua Application")

local menuBar = wx.wxMenuBar()
menuBar:Append(fileMenu, "&File")
menuBar:Append(helpMenu, "&Help")

frame:SetMenuBar(menuBar)

frame:CreateStatusBar(1)
frame:SetStatusText("Welcome to wxLua.")

frame:Connect(wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        frame:Close()
    end )

frame:Connect(wx.wxID_ABOUT, wx.wxEVT_COMMAND_MENU_SELECTED,
    function (event)
        wx.wxMessageBox('This is the "About" dialog of the wxGrid wxLua sample.\n'..
                        wxlua.wxLUA_VERSION_STRING.." built with "..wx.wxVERSION_STRING,
                        "About wxLua",
                        wx.wxOK + wx.wxICON_INFORMATION,
                        frame )
    end )

grid = wx.wxGrid(frame, wx.wxID_ANY)
local gridtable = wx.wxLuaGridTableBase()
InitializeGridTable(grid, gridtable)

-- Clean up any temporary variables now.
-- This is important for wxGridCellEditor objects since once an editor is 
-- created we need to ensure that it is deleted before the grid is deleted 
-- and not afterwards since the Lua GC may not delete them in desired order.
-- Calling this ensures that any "local wx.wxGridCellEditor" objects are deleted.
collectgarbage("collect") 

frame:Show(true)

wx.wxGetApp():MainLoop()
