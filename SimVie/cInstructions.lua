-----------------------------------------------------------------------------------------
--
-- cInstructions.lua
--
-----------------------------------------------------------------------------------------
local Instructions = {}

function Instructions:init()

    local instructions = display.newGroup()
    local cJeu = require("cJeu")
    local bg1
    local bg2

    function instructions:init()
        bg1 = display.newImage(self,"bg.jpg",display.contentCenterX,display.contentCenterY)
        bg1.width = bg1.width * 2
        bg1.height = bg1.height * 2
        bg2 = display.newImage(self,"bg.jpg",display.contentCenterX+bg1.width,display.contentCenterY)
        bg1.width = bg1.width
        bg1.height = bg1.height
    end

    function instructions:jouer()
        audio.fadeOut( { 1, 1000 } )
        cJeu:init()
    end

    instructions:init()
    return instructions
end

return Instructions