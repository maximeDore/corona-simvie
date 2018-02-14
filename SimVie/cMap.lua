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
    local travail

    function map:init()
        local ville = display.newImageRect(self, "map.png", 6800, 3400)
        -- cBatiment:init( "image", x, y, "destination" )
        local gym = cBatiment:init(self,"gym.png",-1356.8,854.4,"gym",193.24)
        local depanneur = cBatiment:init(self,"depanneur.png",-2566.5,854.4,"depanneur",-64)
        local universite = cBatiment:init(self,"depanneur.png",-130,854.4,"appartement",-64)
        if _G.carriere == "sports" then
            travail = cBatiment:init(self,"depanneur.png",400,854.4,"centresportif",-64)
        else
            travail = cBatiment:init(self,"depanneur.png",400,854.4,"faculte",-64)
        end
        for i=1,8,2 do
            local auto = cAuto:init(i)
            self:insert(auto)
        end
    end

    function map:sleep()
        -- désactiver les voitures
    end

    function map:wake()
        -- réactiver les voitures
    end

    function map:kill()
        self:removeSelf()
    end

    map:init()
    return map
end

return Map