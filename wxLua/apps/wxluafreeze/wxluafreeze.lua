#! ../../bin/lua

-------------------------------------------------------------------------------
-- Name:        wxluafreeze.lua
-- Purpose:     Append a wxLua script to the wxLuaFreeze executable to run
-- Author:      John Labenski
-- Created:     2005
-- Copyright:   (c) 2005 John Labenski
-- Licence:     wxWidgets licence
-------------------------------------------------------------------------------
-- This program loads a wxLua script and appends it to the end of the given
--   wxLuaFreeze C++ program to run it.
--
-- See "Usage()" function for usage or just run this with no parameters.
-------------------------------------------------------------------------------

-- formatted print statement
function printf(...)
    io.write(string.format(unpack(arg)))
end

-- simple test to see if the file exits or not
function FileExists(filename)
    local file = io.open(filename, "r")
    if (file == nil) then return false end
    io.close(file)
    return true
end

-------------------------------------------------------------------------------

-- Print the Usage to the console
function Usage()
  print("wxluafreeze.lua appends a wxLua program to a precompiled C++ wxLuaFreeze application.")
  print("Usage : $wxluafreeze.lua input_wxLuaFreezeApp input_wxLua_script.lua output_wxLuaFreezeApp")
  print()
  print(" If using unix, don't forget to $chmod +x output_wxLuaFreezeApp")
end


-- The main() program to run
function main()

    if not arg or (#arg ~= 3) then
        Usage()
        return
    end

    local in_wxluafreeze  = arg[1]
    local in_wxluascript  = arg[2]
    local out_wxluafreeze = arg[3]

    if not FileExists(in_wxluafreeze) then
        printf("Input wxLuaFreeze program '%s' does not exist! Aborting.\n", in_wxluafreeze)
        return
    end
    if not FileExists(in_wxluascript) then
        printf("Input wxLua script '%s' does not exist! Aborting.\n", in_wxluascript)
        return
    end
    if FileExists(out_wxluafreeze) then
        printf("Output wxLuaFreeze program '%s' will be overwritten.\n", out_wxluafreeze)
    end

    printf("Appending '%s' to wxLuaFreeze program '%s' and outputting to '%s'\n",
            in_wxluascript, in_wxluafreeze, out_wxluafreeze)

    -- read the whole wxLuaFreeze program into memory
    local in_wxluafreeze_handle = io.open(in_wxluafreeze, "rb")
    local in_wxluafreeze_data   = in_wxluafreeze_handle:read("*a")
    local in_wxluafreeze_length = in_wxluafreeze_handle:seek("end")
    io.close(in_wxluafreeze_handle)

    -- check to see if they're trying to append another script to wxLuaFreeze
    if string.sub(in_wxluafreeze_data, in_wxluafreeze_length-21, in_wxluafreeze_length-10) == "wxLuaFreeze:" then
        printf("Input wxLuaFreeze program '%s' already has a wxLua script attached! Aborting.\n", in_wxluafreeze)
        return
    end

    -- read the whole wxLua script into memory
    local in_wxluascript_handle = io.open(in_wxluascript, "rb")
    local in_wxluascript_data   = in_wxluascript_handle:read("*a")
    local in_wxluascript_length = in_wxluascript_handle:seek("end")
    io.close(in_wxluascript_handle)

    -- write the output file and our tag at the end
    local out_wxluafreeze_handle = io.open(out_wxluafreeze, "wb+")
    out_wxluafreeze_handle:write(in_wxluafreeze_data)
    out_wxluafreeze_handle:write(in_wxluascript_data)
    -- 2^32 = 4294967296, should be enough? Our data is 24 bytes from end.
    out_wxluafreeze_handle:write(string.format("<wxLuaFreeze:%010d>", in_wxluascript_length))
    io.close(out_wxluafreeze_handle)
end

main()
