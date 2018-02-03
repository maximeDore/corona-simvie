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
        cJeu:init()
    end

    instructions:init()
    return instructions
end

return Instructions