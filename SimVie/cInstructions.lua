-----------------------------------------------------------------------------------------
--
-- cInstructions.lua
--
-----------------------------------------------------------------------------------------
local Instructions = {}

function Instructions:init()

    local instructions = display.newGroup()
    local cBouton = require("cBouton")
    local cJeu = require("cJeu")
    local rightMarg = display.contentWidth - display.screenOriginX
    local bg1
    local bg2
    local auto
    local narration
    local btNext

    function instructions:init()

        local sprites = { "autoSideVert.png", "autoSideGris.png", "autoSideBleu.png" }
        local rand = math.random( #sprites )

        bg1 = display.newImage( self, "bg2.jpg", display.contentCenterX, display.contentCenterY) 
        bg1.width = bg1.width
        bg1.height = bg1.height

        bg2 = display.newImage( self, "bg2.jpg", display.contentCenterX+bg1.width, display.contentCenterY )
        bg1.width = bg1.width
        bg1.height = bg1.height

        auto = display.newImage( self, sprites[rand], display.contentCenterX*1.5, display.contentCenterY*1.35  )
        auto.xScale = -1
        auto.width = auto.width*2
        auto.height = auto.height*2

        local optionsNarration = {
            text = "Nouvelle vie",
            x = display.contentCenterX,
            y = bg1.height/3,
            width = display.contentWidth-200,
            height = display.contentCenterY,
            font = "8-Bit Madness.ttf",   
            fontSize = 100,
            align = "center"  -- Alignment parameter
        }
        narration = display.newText( optionsNarration )
        self:insert(narration)
    end

    function instructions:jouer()
        audio.fadeOut( { 1, 1000 } )
        cJeu:init()
    end

    function instructions:enterFrame(e)
        bg1.x = bg1.x - 5
        bg2.x = bg2.x - 5
        if bg1.x < display.screenOriginX - bg1.width/2 then
            bg1.x = rightMarg + bg1.width/2
        end
        if bg2.x < display.screenOriginX - bg2.width/2 then
            bg2.x = rightMarg + bg2.width/2
        end
    end

    instructions:init()
    Runtime:addEventListener( "enterFrame", instructions )
    return instructions
end

return Instructions