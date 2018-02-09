-----------------------------------------------------------------------------------------
--
-- cInstructions.lua
--
-----------------------------------------------------------------------------------------
local Instructions = {}

function Instructions:init(force,intelligence,chance)

    local instructions = display.newGroup()
    local cJeu = require("cJeu")

    function instructions:init()
        cJeu:init(-3007.5,-295,force,intelligence,chance)
    end

    instructions:init()
    return instructions
end

return Instructions