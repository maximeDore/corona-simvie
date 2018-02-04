-----------------------------------------------------------------------------------------
--
-- cMap.lua
--
-----------------------------------------------------------------------------------------
local Map = {}

function Map:init()

    local map = display.newGroup()
    local cCamera = require("cCamera")
    local cBatiment = require("cBatiment")

    function map:init()
        local ville = display.newImageRect("map.jpg",6800,3400)
        self:insert(ville)
    end

    map:init()
    return map
end

return Map