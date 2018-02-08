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
    local cAuto = require("cAuto")

    function map:init()
        local ville = display.newImageRect("map.png",6800,3400)
        local gym = cBatiment:init("gym.png",744,484,-display.contentCenterX*2.65,display.contentCenterY*2.225,"gym")
        self:insert(ville)
        self:insert(gym);
    end

    function map:sleep()
        
    end

    function map:resume()

    end

    function map:kill()
        self:removeSelf()
    end

    map:init()
    return map
end

return Map