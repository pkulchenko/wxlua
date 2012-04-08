-----------------------------------------------------------------------------
-- Name:        catch.wx.lua
-- Purpose:     'Catch' wxLua sample
--              Simple game using either the keyboard or one or two joysticks.

-- Author:      A. Arpin
-- Modified by:
-- Created:     August 6, 2009    
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------
-- Thanks to John Labenski for his suggestions
------------------------------------------------------------------------------
version = 1.0
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"

require("wx")

function iff(cond, a, b) if cond then return a else return b end end

-- Generate a unique new wxWindowID
local ids = {wx.wxID_HIGHEST + 1}
function ids:NewID() ids[1] = ids[1] + 1 return ids[1] end

math.randomseed(os.time())
local lastElapsed = -1
local minCellWidth = 16
local cellWidth = 18
local cellHeight = 18
local VerWall, HorWall, offScreenBitmap = nil, nil, nil
local levelMenu

local wallThickness = 5

local joyStick1 = wx.wxJoystick(wx.wxJOYSTICK1)
local joyStick2 = wx.wxJoystick(wx.wxJOYSTICK2)

local redrawRequired = true
local frame          = nil   -- the main wxFrame
local panel          = nil   -- the child wxPanel of the wxScrolledWindow to draw on
local timer          = nil
local initialTimer   = 50
local timeTimer      = initialTimer

ids.ID_EASY    = ids:NewID()
ids.ID_HARD    = ids:NewID()
ids.ID_HARDER  = ids:NewID()
ids.ID_HARDEST = ids:NewID()

ids.ID_JOY_ONE_PLAYER  = ids:NewID()
ids.ID_JOY_TWO_PLAYERS = ids:NewID()
ids.ID_JOY_MV_PERSON   = ids:NewID()
ids.ID_JOY_MV_PRESENT  = ids:NewID()

local numberOfPlayers  = iff(wx.wxJoystick.GetNumberJoysticks() > 1, 2, 1)
local joystick1Control = ids.ID_JOY_MV_PERSON
local Present, Person
local bitmapPost

-- These sounds are from MS Windows, however wxSound doesn't assert in Linux so we
-- create a tempory wxLogNull to ignore the warnings and use wxSound:IsOk() before
-- we try to use them
local logNo = wx.wxLogNull();
local soundTata    = wx.wxSound(wx.wxGetOSDirectory()..[[\media\tada.wav]])
local soundRecycle = wx.wxSound(wx.wxGetOSDirectory()..[[\media\recycle.wav]])
logNo:delete();

--~-- This code was added for window 7 without it the joysticks do not work after the first sound is played
if soundTata:IsOk() then soundTata:Play() soundTata:Stop() 
elseif soundRecycle:IsOk() then soundRecycle:Play() soundRecycle:Stop() end

function distance(m)
    local rd, cd = Present:Offet(m[1], m[2])
    if rd then
        return ((Person.r - rd)^2 + (Person.c - cd)^2)^0.5
    end
    return 0
end

local Game =
{
    width  = 30;
    height = 20;
    hw = {}, -- horizontal walls
    vw = {}, -- vertical walls
    post = {},
    randomPosition = function () return math.random(2, self.height), math.random(1,self.width) end,
    setLevel = function (self, level, menu)
        timeTimer = initialTimer
        self.levelId = level
        if level == ids.ID_EASY then
            self.level          = 'Easy'
            self.numberOfWalls  = 25
            self.numberOfBlocks = 10
            self.maxExtraMove   = 1
            self.maxHoleMoved   = 1
            self.maxWallMoved   = 5
            self.maxTimer       = 500
        elseif level == ids.ID_HARD then
            self.level          = 'Hard'
            self.numberOfWalls  = 35
            self.numberOfBlocks = 15
            self.maxExtraMove   = 2
            self.maxHoleMoved   = 3
            self.maxWallMoved   = 10
            self.maxTimer       = 400
        elseif level == ids.ID_HARDER then
            self.level          = 'Harder'
            self.numberOfWalls  = 100
            self.numberOfBlocks = 20
            self.maxExtraMove   = 2
            self.maxHoleMoved   = 5
            self.maxWallMoved   = 15
            self.maxTimer       = 300
        else
            level = ids.ID_HARDER
            self.level          = 'Hardest !!!'
            self.numberOfWalls  = 200
            self.numberOfBlocks = 40
            self.maxExtraMove   = 2
            self.maxHoleMoved   = 6
            self.maxWallMoved   = 20
            self.maxTimer       = 100
        end
        if levelMenu then levelMenu:Check(level, true) end
    end
}

Game:setLevel(ids.ID_EASY)
local Location = {r=0, c=0, minR = 1, minC = 1, maxR = Game.height, maxC = Game.width}

function Location:new (o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Location:Position()
    return Position(self.r, self.c)
end

function Location:Offet(dr, dc)
    local nr, nc = self.r + dr, self.c + dc
    if  (nr >= self.minR and nr<= self.maxR and nc >= self.minC and nc <= self.maxC)  then
        return nr, nc
    end
end

function Location:Place(r,c)
    assert(r >= self.minR and r<= self.maxR and c >= self.minC and c <= self.maxC)
    self.r, self.c = r, c
end

local Occupant = Location:new() -- location for a bitmap

-- vertical or horizontal wall
function GenWall(w, h)
    local bm = wx.wxBitmap(w, h)
    local memDC = wx.wxMemoryDC()
    local pen = wx.wxPen("red", 0, wx.wxSOLID)
    local brush = wx.wxBrush('green', wx.wxSOLID)
    
    memDC:SelectObject(bm)
    memDC:SetBrush(brush)
    memDC:SetPen(pen)
    memDC:DrawRectangle(0, 0, w, h)
    
    pen:delete()
    brush:delete()
    memDC:SelectObject(wx.wxNullBitmap)
    memDC:delete()
    return bm
end

function PositionWall(r, c)
    return (c-1)*(cellWidth+wallThickness) ,  (r-1)*(cellHeight+wallThickness)
end

function Game:initBitMap()
    local w, h =  Game.width*(cellWidth+wallThickness)+1, Game.height*(cellHeight+wallThickness)+1       
    return wx.wxBitmap(w, h)
end

function Game:Place(b, r, c)
    if self[r][c] then return end
    b:Place(r,c)
    self[r][c] = b
    return true
end

function Game:Remove(b)
    if b.r ~= 0 and self[b.r][b.c] == b then
        self[b.r][b.c]=nil
    end
end

function Location:Draw(dc)
    dc:DrawBitmap(bitmap, wallThickness+x, wallThickness+y, true)
end

function Game:RandomRC()
    return math.random(1, self.height), math.random(1,self.width)
end

function Game:RandomWall(h)
    if h then
        return math.random(1, self.height - 1), math.random(1, self.width)
    else
        return math.random(1, self.height), math.random(1, self.width - 1)
    end
end

function Game:RandomIncr()
    -- note: 0, 0 is possible
    return math.random(-1, 1), math.random(-1, 1)
end

function Game:Init()
    VerWall = GenWall(wallThickness, cellHeight + wallThickness)
    HorWall = GenWall(cellWidth + wallThickness, wallThickness)
    offScreenBitmap = Game:initBitMap()
    frame:SetClientSize(wx.wxSize(offScreenBitmap.Width, offScreenBitmap.Height))
    local r, c
    for r = 1, self.height   do self[r]    = {} end
    for r = 1, self.height-1 do self.hw[r] = {} end
    for c = 1, self.width-1  do self.vw[c] = {} end
    repeat
        for _, v in ipairs(({Present, Person}))  do
            self:Remove(v)
            repeat until self:Place(v, self:RandomRC())
        end
    until distance({0,0}) > 20
    self.post = {}
    for i= 1, 10 + self.maxHoleMoved  do
        local post = Occupant:new({bitmap = bitmapPost})
        repeat until self:Place(post, self:RandomRC())
        table.insert(self.post, post)
    end
    for i = 1, self.numberOfWalls  do
        repeat r, c = self:RandomWall(false) until self.vw[c][r] == nil
        self.vw[c][r]=true
        repeat r, c = self:RandomWall(true) until self.hw[r][c]== nil
        self.hw[r][c]=true
    end
    self.start = os.time()
    RestartTimer()
    frame:Refresh()
    redrawRequired = true
    timeTimer = initialTimer
end

function main()
    bitmapPost = wx.wxBitmap(xpm('wall'))
    Person = Occupant:new({bitmap = wx.wxBitmap(xpm('Person'))})
    Present = Occupant:new({bitmap = wx.wxBitmap(xpm('Present'))})       
    frame = wx.wxFrame( wx.NULL, wx.wxID_ANY, "wxLua Catch the present", 
                       wx.wxDefaultPosition, wx.wxDefaultSize,
                       wx.wxCAPTION+wx.wxSYSTEM_MENU+wx.wxCLOSE_BOX+wx.wxMINIMIZE_BOX)
    -- -----------------------------------------------------------------------
    -- Create the menubar
    local fileMenu = wx.wxMenu()
    fileMenu:Append(wx.wxID_EXIT,   "E&xit\tCtrl+Q",      "Quit the program")

    local helpMenu = wx.wxMenu()
    helpMenu:Append(wx.wxID_ABOUT,  "&About...", "About the wxLua Catch Application")

    levelMenu = wx.wxMenu()
    levelMenu:AppendRadioItem(ids.ID_EASY, "&1 Easy", "Level the game is being played")
    levelMenu:AppendRadioItem(ids.ID_HARD, "&2 Hard", "Level the game is being played")
    levelMenu:AppendRadioItem(ids.ID_HARDER, "&3 Harder", "Level the game is being played")
    levelMenu:AppendRadioItem(ids.ID_HARDEST, "&4 Hardest", "Level the game is being played")
    local joystickControlMenu = wx.wxMenu()
    joystickControlMenu:AppendRadioItem(ids.ID_JOY_ONE_PLAYER, "&1 One player", "One player present moves by itself")
    joystickControlMenu:AppendRadioItem(ids.ID_JOY_TWO_PLAYERS, "&2 Two players", "Two players")
    joystickControlMenu:AppendSeparator()
    joystickControlMenu:AppendRadioItem(ids.ID_JOY_MV_PERSON, "&3 Joystick:1 move Person", "Joystick with id set to 1")
    joystickControlMenu:AppendRadioItem(ids.ID_JOY_MV_PRESENT, "&4 JoyStick:1 move Present", "Joystick with id set to 1")

    local menuBar = wx.wxMenuBar()
    menuBar:Append(fileMenu, "&File")
    menuBar:Append(levelMenu, "&Level")
    menuBar:Append(joystickControlMenu, '&Joystick ('.. wx.wxJoystick.GetNumberJoysticks() ..')')
    menuBar:Append(helpMenu, "&Help")
    frame:SetMenuBar(menuBar)
    if (wx.wxJoystick.GetNumberJoysticks() == 0) then menuBar:EnableTop(2, false) end
    -- Create the statusbar
    local statusBar = frame:CreateStatusBar(1)
    frame:SetStatusText("Welcome to Catch.")

    panel = wx.wxPanel(frame, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxWANTS_CHARS)
    timer = wx.wxTimer(panel)       
    panel:Connect(wx.wxEVT_PAINT, OnPaint)
    panel:Connect(wx.wxEVT_TIMER, OnTimer)
    panel:Connect(wx.wxEVT_ERASE_BACKGROUND, function(event)
            --// intentionally empty
        end)

    panel:Connect(wx.wxEVT_KEY_DOWN, OnKeyDown)
    panel:Connect(wx.wxEVT_JOY_MOVE,  OnJoyStick)

    if joyStick1:IsOk() then joyStick1:SetCapture(panel, 100) end
    if joyStick2:IsOk() then joyStick2:SetCapture(panel, 100) end

    Game:Init()

    frame:Connect(wx.wxEVT_CLOSE_WINDOW,
        function (event)
            -- prevent paint events using the memDC during closing
            if joyStick1:IsOk() then joyStick1:ReleaseCapture() end
            if joyStick2:IsOk() then joyStick2:ReleaseCapture() end
            if offScreenBitmap then
                offScreenBitmap:delete()
                offScreenBitmap = nil
            end
            soundTata:delete()
            soundRecycle:delete()
            if timer then
                timer:Stop() -- always stop before exiting or deleting it
                timer:delete()
                timer = nil
            end
            -- ensure the event is skipped to allow the frame to close
            event:Skip()
        end )

    -- -----------------------------------------------------------------------
    -- File menu events

    frame:Connect(wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED,
        function (event)
            frame:Close(true)
        end )

    -- -----------------------------------------------------------------------
    -- Game type menu
    frame:Connect(ids.ID_JOY_ONE_PLAYER, wx.wxEVT_COMMAND_MENU_SELECTED,
        function (event)
            numberOfPlayers = 1
            joystickControlMenu:Check(ids.ID_JOY_MV_PERSON, true)
            joystick1Control = ids.ID_JOY_MV_PERSON            
        end)
    frame:Connect(ids.ID_JOY_TWO_PLAYERS, wx.wxEVT_COMMAND_MENU_SELECTED, function (event) numberOfPlayers = 2 end)
    frame:Connect(ids.ID_JOY_MV_PERSON, wx.wxEVT_COMMAND_MENU_SELECTED, function (event) joystick1Control = event.Id end)
    frame:Connect(ids.ID_JOY_MV_PRESENT, wx.wxEVT_COMMAND_MENU_SELECTED,
        function (event)
        joystick1Control = event.Id
        joystickControlMenu:Check(ids.ID_JOY_TWO_PLAYERS, true)
        numberOfPlayers = 2 -- must have 2 players
        end)

    -- -----------------------------------------------------------------------
    -- Level menu events
    frame:Connect(ids.ID_EASY, wx.wxEVT_COMMAND_MENU_SELECTED, function (event) Game:setLevel(event.Id) Game:Init() end)
    frame:Connect(ids.ID_HARD, wx.wxEVT_COMMAND_MENU_SELECTED, function (event) Game:setLevel(event.Id) Game:Init() end)
    frame:Connect(ids.ID_HARDER, wx.wxEVT_COMMAND_MENU_SELECTED, function (event) Game:setLevel(event.Id) Game:Init() end)
    frame:Connect(ids.ID_HARDEST, wx.wxEVT_COMMAND_MENU_SELECTED, function (event) Game:setLevel(event.Id) Game:Init() end)

    -- -----------------------------------------------------------------------
    -- Help menu events

    frame:Connect(wx.wxID_ABOUT, wx.wxEVT_COMMAND_MENU_SELECTED,
        function (event)
            wx.wxMessageBox('"About" dialog for the Catch wxLua Sample.\n\n'..
                "How long will it take you to catch the present\n"..
                'Use either the arrow keys and/or a JoyStick(s)\n'..
                'Do not drop into the holes!\n'..
                'Walls move around and sometime disappear\n\n'..
                "JOYSTICK: (not necessary)\nOne or 2 joysticks are supported\n\n"..
                wxlua.wxLUA_VERSION_STRING.." built with "..wx.wxVERSION_STRING,
                "About wxLua Catch v "..version,
                wx.wxOK + wx.wxICON_INFORMATION,
                frame )
        end )
        
    frame:Center()
    frame:Show(true)    
    
    if (not joyStick1:IsOk() and joyStick2:IsOk()) then
        wx.wxMessageBox('Only one joystick and joystick id is set to 2\n change id to one or program will not work','Catch')
    end
end

function Game:Draw(dc)
    local function PositionPieces(r, c)
        return (c-1)*(cellWidth+wallThickness) + (cellWidth - minCellWidth)/2,
        (r-1)*(cellHeight+wallThickness)  + (cellHeight - minCellWidth)/2
    end
    for r,v in ipairs(self)  do
        for c, bitmap in pairs(v)  do
            local x,y = PositionPieces(r,c)
            dc:DrawBitmap(bitmap.bitmap, x+wallThickness, y+wallThickness, true)
        end
    end

    for r,v in ipairs(self.hw)  do
        for c,v in pairs(v)  do
            local x, y = PositionWall(r + 1, c)
            dc:DrawBitmap(HorWall, x+1, y, false)
        end
    end

    for c,v in ipairs(self.vw)  do
        for r,v in pairs(v)  do
            local x, y = PositionWall(r, c + 1)
            dc:DrawBitmap(VerWall, x, y+1, false)
        end
    end
end

function Game:DrawOffScreenBitMap(bmp)
    local dc = wx.wxMemoryDC()       -- create off screen dc to draw on
    dc:SelectObject(bmp)             -- select our bitmap to draw into
    local brush = wx.wxBrush('turquoise', wx.wxSOLID)
    dc:SetBackground(brush)
    dc:Clear()
    self:Draw(dc)
    dc:SelectObject(wx.wxNullBitmap) -- always release bitmap
    dc:delete()    -- ALWAYS delete() any wxDCs created when done
    brush:delete() -- ALWAYS delete() all GDI objects
end

function OnPaint(event)
    -- ALWAYS create wxPaintDC in wxEVT_PAINT handler, even if unused
    local dc = wx.wxPaintDC(panel)
    if offScreenBitmap and offScreenBitmap:Ok() then
        if redrawRequired then
            Game:DrawOffScreenBitMap(offScreenBitmap)
            redrawRequired = false
        end
        dc:DrawBitmap(offScreenBitmap, 0, 0, false)
    end
    dc:delete() -- ALWAYS delete() any wxDCs created when done
end

function Occupant:move(d_r, d_c)
    local r, c = self:Offet(d_r, d_c)
    if c then
        -- check if a gate is crossed, allow crossing corners (present does that on automatic)
        if d_r == 0 or d_c==0 then
            if d_r ~= 0 then
                if Game.hw[iff(d_r > 0, self.r, r)][c] then return end
            elseif d_c ~= 0 then
                if Game.vw[iff(d_c> 0,  self.c, c)][r] then return end
            end
        end
        if Game[r][c] then return false, Game[r][c] end
        Game[self.r] [self.c] = nil
        Game:Place(self, r, c)
        return true
    end
end

function Game:Elapse()
    return os.time() - self.start
end

function Game:MoveAll()
    if numberOfPlayers == 1 then
        for i= 1, math.random(1,  self.maxExtraMove) do
            local bestMove = {self:RandomIncr()}
            -- 70 % of the time we are moving away for the 1st 30 second
            if  i==1 and math.mod(Game:Elapse(),10) > 2 then
                local otherMove = {self:RandomIncr()}
                if distance(bestMove) < distance(otherMove) then
                    bestMove = otherMove
                end
            end
            Present:move(bestMove[1], bestMove[2])
        end
    end

    for i= 1, math.random(1, self.maxHoleMoved) do
        local extra = math.random(1, #self.post)
        self.post[extra]:move(self:RandomIncr())
    end

    for i= 1, math.random(1, self.maxWallMoved) do
        local r, c = self:RandomWall(true)
        local tr, tc = self:RandomWall(true)
        if not self.hw[tr][tc] then self.hw[r][c], self.hw[tr][tc]  =  self.hw[tr][tc], self.hw[r][c] end
    end

    for i= 1, math.random(1, self.maxWallMoved) do
        local r, c = self:RandomWall(false)
        local tr, tc = self:RandomWall(false)
        if  not self.vw[tc][tr] then  self.vw[c][r], self.vw[tc][tr]  =  self.vw[tc][tr], self.vw[c][r] end
    end

    RestartTimer()
    if lastElapsed ~= Game:Elapse() then
        local w = 0;
        for k,v in pairs(self.hw)  do
            for k,v in pairs(v)  do
                w = w + 1
            end
        end
        for k,v in pairs(self.vw)  do
            for k,v in pairs(v)  do
                w = w + 1
            end
        end
        frame:SetStatusText(string.format("<<< %s >>>     %s%6d     %s%6d     %s%6d",
                string.upper(self.level),"TIME:",Game:Elapse(), 'Speed: ',600 - timeTimer ,'Walls:',w))
        lastElapsed = Game:Elapse()
        -- removing walls makes the game easier as time goes byeselft.
        local r, c = self:RandomWall(false) self.vw[c][r] = nil
        local r, c = self:RandomWall(true)  self.hw[r][c]= nil
    end

    redrawRequired = true
    frame:Refresh()
end

function Occupant:MovePlayer(keyCode)
    local moved, target
    if keyCode == wx.WXK_RIGHT then
        moved, target = self:move(0, 1)
    elseif keyCode == wx.WXK_LEFT then
        moved, target = self:move(0, -1)
    elseif keyCode == wx.WXK_UP then
        moved, target = self:move(-1, 0)
    elseif keyCode == wx.WXK_DOWN then
        moved, target = self:move(1, 0)
    end
    if target then
        timer:Stop()
        local message
        if target == Present or target == Person then
            message = "Got the present "
            if soundTata:IsOk() then soundTata:Play() end
            Game:setLevel(Game.levelId + 1)
        elseif self == Person then
            message = "Sorry you lost the present "
        end
        if message then
            local dialog = wx.wxMessageDialog( frame, message..Game:Elapse() .. ' second(s).\n\nPlay one more', "Catch", wx.wxCENTRE + wx.wxYES_NO)
            local result = dialog:ShowModal()
            dialog:Destroy()
            if result == wx.wxID_YES then Game:Init() else frame:Close(true) end
            return
        end
        RestartTimer()
    end
    if moved then
        Game:MoveAll()
    else
        if soundRecycle:IsOk() then soundRecycle:Play() end
    end
end

function OnKeyDown(event)
    if event.KeyCode == wx.WXK_ESCAPE then frame:Close() end
    if numberOfPlayers == 1 or joystick1Control == ids.ID_JOY_MV_PRESENT then
        Person:MovePlayer(event.KeyCode)
    else
        Present:MovePlayer(event.KeyCode)
    end
end

function OnJoyStick(event)
    if timer:IsRunning() then
        local player = Person
        if event:GetJoystick() == 1 then -- not the same as wx.wxJOYSTICK1 (sorry)
            joystick = joyStick1
            if joystick1Control == ids.ID_JOY_MV_PRESENT then
                player = Present
            end
        else
            joystick = joyStick2
            if joystick1Control ~= ids.ID_JOY_MV_PRESENT then
                player = Present
            end
        end
        local pt = joystick.Position
        local x, y = pt.X - joystick.XMax/2, pt.Y - joystick.YMax/2
        local xym = math.max(math.abs(x), math.abs(y))
        if xym > joystick.XMax/11 then
            if xym == math.abs(x) then
                player:MovePlayer(iff(x > 0, wx.WXK_RIGHT, wx.WXK_LEFT))
            else
                player:MovePlayer(iff(y < 0, wx.WXK_UP, wx.WXK_DOWN))
            end
        end
    end
end

function RestartTimer()
    -- the game slows down
    timeTimer = math.min(timeTimer+1, Game.maxTimer)
    timer:Start(timeTimer)
    collectgarbage("collect")
end

function OnTimer(event)
    Game:MoveAll()
end

-- XPM data
function xpm(name)
    local names = {}

    names.Present = {
"16 16 7 1",
"  c #FFFFFF",
". c #06985C",
"+ c #091925",
"@ c #E1B901",
"# c #68F89B",
"$ c #CBF95B",
"% c #FF7611",
"      .         ",
".......+++......",
".      + +     .",
". @@@@@+@+@@@@@.",
". @   .+ +    @.",
". @ ###+#+####@.",
". @ #. + +   #@.",
"++++++++++++++++",
"+.@ # $+ +  $#@.",
"++++++++++++++++",
". @ # $+%+ %$#@.",
". @ # $+%+%%$#@.",
". @ # $+$+$$$#@.",
". @ ###+#+####@.",
". @@@@@+@+@@@@@.",
".......+.+......"};

    names.Person = {
        "16 16 2 1",
"  c none",
".    c #000000",
"                ",
"       ...      ",
"     ..   ..    ",
"    .       .   ",
"    .  .  .  .  ",
"    .       .   ",
"     ..   ..    ",
"       ...      ",
"       . .      ",
"        .       ",
"       . .      ",
"      .   .     ",
"      .   .     ",
"     .     .    ",
"    .       .   ",
"                "};

    names.wall = {
        "16 16 11 1",
        "   c None",
        ".    c #00950B",
        "+ c #fFfF00",
        "@ c #EF0000",
        "# c #F01002",
        "$ c #F23007",
        "% c #F5600F",
        "& c #F67F13",
        "* c #F9AF1B",
        "= c #FCDF22",
        "- c #FBCF20",
        "................",
        "................",
        "..+@#$%&&%$#++..",
        "..++%*=++=*++@..",
        "..#%++++++++%#..",
        "..$*++++++++*$..",
        "..%=++++++++=%..",
        "..&++++++++++&..",
        "..&++++++++++&..",
        "..%=++++++++=%..",
        "..$*++++++++*$..",
        "..#%-++++++-%#..",
        "..@+++=++=*+#@..",
        "..++#$%&&%$+++..",
        "................",
        "................"};
    return names[name]
end

main()

-- set frame icon
local icon = wx.wxIcon()
local xpm = xpm('Person')
xpm[2] = "  c #FFFFFF" -- change background
icon:CopyFromBitmap(wx.wxBitmap(xpm))
frame:SetIcon(icon)

--~dump(_G)
-- Call wx.wxGetApp():MainLoop() last to start the wxWidgets event loop,
-- otherwise the wxLua program will exit immediately.
-- Does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit since the
-- MainLoop is already running or will be started by the C++ program.
wx.wxGetApp():MainLoop()
