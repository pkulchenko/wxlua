-----------------------------------------------------------------------------
-- Name:        wxwebrequest.wx.lua
-- Purpose:     wxWebRequest sample
-- Author:      Daniel Collins
-- Modified by:
-- Created:     19/09/2025
-- Copyright:   (c) 2025 Daniel Collins. All rights reserved.
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

-- wxLuaFreeze seems to discard any errors/output from the script, so have this hack for now...
-- TODO: Remove and use print() when wxLuaFreeze's output handling works
local stdout = io.open("/dev/stdout", "a")

function main()
	-- Sequentially make some web requests.
	-- See the download() function for a description of the storage methods.
	
	download("http://google.com/", wx.wxWebRequest.Storage_Memory, "Storage_Memory", function()
	download("http://google.com/", wx.wxWebRequest.Storage_None, "Storage_None", function()
	download("http://google.com/", wx.wxWebRequest.Storage_File, "Storage_File", function() end)
	end)
	end)
end

function download(url, storage, storage_desc, finished_callback)
	stdout:write("\n>>> Fetching " .. url .. " using " .. storage_desc .. "\n")
	
	-- We use a wxFrame both to process the events from wxWebRequest and to prevent the event loop
	-- from automatically exiting as soon as we return. If the application had another wxFrame or
	-- other arrangements to keep the event loop running, then a simple wxEvtHandler could be used
	-- in its place.
	
	local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "wxWebRequest handler frame")
	local request = wx.wxWebSession.GetDefault():CreateRequest(frame, url);
	
	local finished = function()
		-- Clean up the request objects
		request = nil
		frame:Destroy()
		
		-- Go on to the next request (or exit)
		finished_callback()
	end

	if not request:IsOk()
	then
		stdout:write("Error creating web request\n")
		finished()
		return
	end

	request:SetStorage(storage)

	frame:Connect(wx.wxEVT_WEBREQUEST_DATA, function(event)
		local data = event:GetData()
		stdout:write("Received " .. data:len() .. " bytes in wxEVT_WEBREQUEST_DATA event\n")
	end)

	frame:Connect(wx.wxEVT_WEBREQUEST_STATE, function(event)
		local state = event:GetState()

		if state == wx.wxWebRequest.State_Completed
		then
			local response = event:GetResponse()
			
			-- For requests using Storage_File, we call wxWebResponse.GetDataFile() to get the
			-- path to the downloaded response body.
			--
			-- For requests using Storage_Memory, we read the buffered data from memory via the
			-- wxInputStream from the wxWebResponse:GetStream() method.
			--
			-- For requests using Storage_None, the data was already sequentially fed to us via
			-- the wxEVT_WEBREQUEST_DATA event, so we don't get any data here.
			
			if storage == wx.wxWebRequest.Storage_File
			then
				local file = response:GetDataFile()
				
				stdout:write("Request succeeded, response body written to temporary file " .. file .. "\n")
				os.execute("ls -l '" .. file .. "'")
				
			elseif storage == wx.wxWebRequest.Storage_Memory
			then
				local stream = response:GetStream()
			
				-- We don't know how much data was downloaded, so we must read from the stream
				-- until it is empty.
				--
				-- NOTE: We can't use the wxWebResponse.GetContentLength() value as that is the
				-- value of the Content-Length header, which is:
				--
				-- a) Optional.
				--
				-- b) Reflects the encoded body length in the case of compressed responses rather
				--    than the unpacked payload length.
				
				local total = 0
				while not stream:Eof()
				do
					-- Read up to 1KiB from the stream, then truncate data to the length actually
					-- read from the stream.
					local data = stream:Read(1024)
					data = data:sub(1, stream:LastRead())
					
					total = total + data:len()
				end
				
				stdout:write("Request succeeded, got " .. total .. " byte body in wxEVT_WEBREQUEST_STATE event\n")
			else
				stdout:write("Request succeeded\n")
			end
			
			finished()
		elseif state == wx.wxWebRequest.State_Failed or state == wx.wxWebRequest.State_Unauthorized
		then
			stdout:write("Request error: " .. event:GetErrorDescription() .. "\n")
			finished()
		end
	end)

	request:Start()
end

main()

-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
wx.wxGetApp():MainLoop()
