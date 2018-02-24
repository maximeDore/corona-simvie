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
        audio.fadeOut( { 1, 1000 } )
        cJeu:init()
    end

    instructions:init()
    return instructions
end

return Instructions