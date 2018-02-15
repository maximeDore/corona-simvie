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
    local autos = display.newGroup()
    local filtreNocturne
    local travail

    function map:init()
        local ville = display.newImageRect(self, "map.png", 6800, 3400)

        -- Bâtiments
        -- Batiment:init( parent, img, x, y, destination, porteX )
        local gym = cBatiment:init(self,"gym.png",-1356.8,854.4,"gym",193.24)
        local depanneur = cBatiment:init(self,"depanneur.png",-2566.5,854.4,"depanneur",-64)
        local universite = cBatiment:init(self,"depanneur.png",-130,854.4,"appartement",-64)
        if _G.carriere == "sports" then
            travail = cBatiment:init(self,"depanneur.png",400,854.4,"centresportif",-64)
        else
            travail = cBatiment:init(self,"depanneur.png",400,854.4,"faculte",-64)
        end

        -- Autos
        for i=1,8,2 do
            local auto = cAuto:init(i)
            autos:insert(auto)
        end
        self:insert(autos)

        -- Filtre qui obscurcit l'écran selon l'heure
        filtreNocturne = display.newRect(self, display.screenOriginX, 0, display.contentWidth*3, display.contentHeight )
        -- filtreNocturne.fill = 

    end

    function map:darken(alpha)
        if alpha >= 17 then
            filtreNocturne.fill = { 0, .1 ,.3, alpha*2 }
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