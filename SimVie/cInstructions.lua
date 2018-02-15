-----------------------------------------------------------------------------------------
--
-- cInstructions.lua
--
-----------------------------------------------------------------------------------------
local Instructions = {}

function Instructions:init()

    local instructions = display.newGroup()
    local cJeu = require("cJeu")

    function instructions:init()
        audio.fadeOut( { _G.bgMusicChannel, 1000 } )
        cJeu:init(-3007.5,-295)
    end

    instructions:init()
    return instructions
end

return Instructions