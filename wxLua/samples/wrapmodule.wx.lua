-----------------------------------------------------------------------------
-- Name:        wrapmodule.wx.lua
-- Purpose:     Allow running wxLua programs using require by "appending" wx.wxGetApp():MainLoop()
-- Author:      John Labenski
-- Modified by:
-- Created:     05/13/2006
-- RCS-ID:
-- Copyright:   (c) 2001 John Labenski. All rights reserved.
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

-- Usage: $lua wrapmodule.wx.lua wxluaprogram.wx.lua

require("wx")

assert(arg and arg[1] and (type(arg[1]) == "string"), "Usage: $lua wrapmodule.wx.lua wxluaprogram.wx.lua")

dofile(arg[1])

-- ALWAYS call wx.wxGetApp():MainLoop() last to keep the program active
-- otherwise the lua program will exit immediately
wx.wxGetApp():MainLoop()

