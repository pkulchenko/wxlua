-----------------------------------------------------------------------------
-- Name:        incircles.lua
-- Purpose:     Sample wxLua program for wxLua's wxluacan sample app
-- Author:      Klaas Holwerda
-- Modified by:
-- Created:
-- RCS-ID:
-- Copyright:   (c) 2005 Klaas Holwerda. All rights reserved.
-- Licence:     wxWidgets licence
-----------------------------------------------------------------------------

bluebrush   = wx.wxBrush("Blue", wx.wxSOLID)
redbrush    = wx.wxBrush("Red", wx.wxSOLID)
purplebrush = wx.wxBrush("Purple", wx.wxSOLID)
greenbrush  = wx.wxBrush("Green", wx.wxSOLID)
bluepen     = wx.wxPen("Blue", 5, wx.wxSOLID)
redpen      = wx.wxPen("Red", 2, wx.wxSOLID)
purplepen   = wx.wxPen("Purple", 10, wx.wxSOLID)
greenpen    = wx.wxPen("Green", 2, wx.wxSOLID)
purplepen1p = wx.wxPen("Purple", 1, wx.wxSOLID)

    function MonoDraw( dc, x, y )
        dc:SetBrush( redbrush )
        dc:SetPen( bluepen )
        dc:DrawRectangle(x, y, 120, 140)
        dc:SetBrush( greenbrush )
        dc:SetPen( purplepen )
        dc:DrawEllipse(x, y, 190, 30)
    end

    function MonoHit( x, y )
        local xmin, ymin, xmax, ymax
        xmin = 0
        ymin = 0
        xmax = 190
        ymax = 140
        if  x < xmax and y < ymax and x > xmin and y > ymin
        then
            return true
        end
        return false
    end

    function ApeDraw( dc, x, y )
        dc:SetBrush( purplebrush )
        dc:SetPen( bluepen )
        dc:DrawEllipse(x, y, 30, 90)
        dc:SetPen( redpen )
        for i = -20, 20 do
            local y2
            if  i ~= 0  then
                y2 = 150*math.sin(i/2)/(i/2)
            else
                y2 = 150; --sin(x)/x goes to one at zero
            end
            dc:DrawLine(x + 5*i, y, x + 5*i, y + y2  )
        end

    end

    function ApeHit( x, y )
        local xmin, ymin, xmax, ymax
        xmin = -100
        ymin = -40
        xmax = 100
        ymax = 150
        if  x < xmax and y < ymax and x > xmin and y > ymin
        then
            return true
        end
        return false
    end


    function AddSome()
        for list = 1, 10 do
            canvas = wxluacan.GetCan()
            canobjrect = wxluacan.wxlCanObjRect( 30+list*2, 40+list*3, 100, 20)
            canobjrect:SetBrush( bluebrush )
            canvas:AddObject(  canobjrect )
        end
    end

if wx.wxMessageBox(  "Now we will add some objects to the canvas",  "wxLuaCan Message",
   wx.wxYES_NO + wx.wxCENTRE)  == wx.wxYES
then
    -- fill the canvas
    canvas = wxluacan.GetCan()
    canobjrect = wxluacan.wxlCanObjRect( 40, 160, 100, 40)
    canobjrect:SetBrush( bluebrush )
    canobjrect:SetPen( purplepen )
    canvas:AddObject(  canobjrect )
    canobjrect:SetPending( true )

    -- add two script object based on lua functions
    canobjscript = wxluacan.wxlCanObjScript( 100, 20, "Mono", "monoscript"  )
    canvas:AddObject(  canobjscript )
    canobjscript = wxluacan.wxlCanObjScript( 200, 200, "Ape", "apescript"  )
    canvas:AddObject(  canobjscript )
    canobjscript:SetPending( true )
    AddSome()

        -- add script object based on lua script to add child objects
        -- make a string of the script which will add the objects from within C++ calling AddChilds on that object as input for adding child objects
        TheObjectAddScript =
        [[
                function AddChilds( canobj, x, y )
                    canobjrect2 = wxluacan.wxlCanObjCircle( 24, 16, 50)
                    canobjrect2:SetBrush( greenbrush )
                    canobjrect2:SetPen( purplepen )
                    canobj:AddObject( canobjrect2 )
                    canobjrect1 = wxluacan.wxlCanObjRect( 4, 16, 50, 80)
                    canobj:AddObject( canobjrect1 )
                end
          ]]

    -- add the object using the above string as input script
    canobjAddScript = wxluacan.wxlCanObjAddScript( 150, 250,  TheObjectAddScript  )
    canobjAddScript:SetBrush( bluebrush )
    canobjAddScript:SetPen( redpen )
    canvas:AddObject(  canobjAddScript  )

        TheObjectAddScript_2 =
        [[
                function AddChilds( canobj, x, y )
                    canobj:SetBrush( greenbrush )
                    canobj:SetPen( purplepen1p )
                    canobj1 = wxluacan.wxlCanObjCircle( 0, 0, 20 )
                    canobj1:SetPen( purplepen1p )
                    canobj:AddObject( canobj1 )
                    for i = -30, 30 do
                        local y2
                        if  i ~= 0  then
                            y2 = -150*math.sin(i/3)/(i/3)
                        else
                            y2 = -150; --sin(x)/x goes to one at zero
                        end
                        -- all relative
                        line = wxluacan.wxlCanObjRect( 5*i, 0, 3, y2 )
                        canobj:AddObject( line )
                    end
                end
            ]]

    -- add the object using the above string as input script
    canobjAddScript = wxluacan.wxlCanObjAddScript( 150, 250,  TheObjectAddScript_2  )
    canobjAddScript:SetBrush( bluebrush )
    canobjAddScript:SetPen( redpen )
    canvas:AddObject(  canobjAddScript  )

end
