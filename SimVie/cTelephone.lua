-----------------------------------------------------------------------------------------
--
-- cTelephone.lua
--
-----------------------------------------------------------------------------------------
local Telephone = {}
local cBouton = require("cBouton")

function Telephone:init( parent, perso )

    local posUp = display.contentHeight-display.screenOriginY-200
    local posDown = display.contentHeight-display.screenOriginY+210

    local telephone = display.newGroup()
    local phone
    local tapZone
    local bgStats
    local screenStats = display.newGroup()
    local btContacts
    local screenContacts = display.newGroup()
    local aptitudesNum
    
    function telephone:init()

        local function afficherStats()
            screenContacts.isVisible = false
            screenStats.isVisible = true
        end

        local function mute()
            if audio.pause() > 0 then
                audio.pause( 1 )
            else
                audio.resume( 1 )
            end
        end

        local function afficherContacts()
            screenContacts.isVisible = true
            screenStats.isVisible = false
        end

        phone = display.newImage( self, "telephone.png" )
        tapZone = display.newRect( self, 0, -phone.height/2.5, phone.width, phone.height/5 )
        tapZone.alpha = 0.01
        bgContacts = display.newImage( screenContacts, "contactsScreen.png", 0, -10.5 )
        bgStats = display.newImage( screenStats, "statsScreen.png", 0, -10.5 )
        btStats = cBouton:init( "btStats.png", -bgStats.width/3, bgStats.height/2.65, afficherStats )
        btMute = cBouton:init( "btMute.png", 0, bgStats.height/2.65, mute )
        btContacts = cBouton:init( "btContacts.png", bgStats.width/3, bgStats.height/2.65, afficherContacts )

        local optionsAptitudesNum = {
            text = "",
            x = bgStats.width/3+5,
            y = bgStats.y-bgStats.height/6,
            width = 100,
            height = 100,
            font = "8-Bit Madness.ttf",
            fontSize = 50,
            align = "center"  -- Alignment parameter
        }
        aptitudesNum = display.newText( optionsAptitudesNum )
        aptitudesNum:setFillColor(1,0,0)
        screenStats:insert(aptitudesNum)


        self:insert(screenContacts)
        self:insert(screenStats)
        self:insert(btStats)
        self:insert(btMute)
        self:insert(btContacts)

        self.x = display.contentWidth*.85-display.screenOriginX
        self.y = posDown
        parent:insert(self)
        self:updateStats()
    end

    function telephone:updateStats()
        aptitudesNum.text = perso.forNum.."\n"..perso.intNum.."\n"..perso.chaNum
    end

    function telephone:tap()
        if self.y >= display.contentHeight-display.screenOriginY+125 then
            transition.to( self, { time = 500, y = posUp, transition=easing.outQuart } )
        elseif self.y <= display.contentHeight-display.screenOriginY-100 then
            transition.to( self, { time = 500, y = posDown, transition=easing.outQuart } )
        end
    end

    telephone:init()

    tapZone:addEventListener( "tap", telephone )

    return telephone
end

return Telephone