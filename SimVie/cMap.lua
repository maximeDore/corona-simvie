-----------------------------------------------------------------------------------------
--
-- cMap.lua
--
-----------------------------------------------------------------------------------------
local Map = {}

function Map:init( perso )

    local map = display.newGroup()
    local cCamera = require("cCamera")
    local cBatiment = require("cBatiment")
    local cAuto = require("cAuto")
    local autos = display.newGroup()
    local filtreNocturne

    function map:init()
        local ville = display.newImageRect(self, "map.png", 6800, 3400)

        -- Bâtiments avec physiques
        -- Batiment:init( parent, img, x, y, destination, porteX, outline )
        local gymTop = cBatiment:init(self,"gymTop.png",-1356.8,525)
        local depTop = cBatiment:init(self,"depanneurTop.png",-2275,435)
        local gym = cBatiment:init(self,"gym.png",-1356.8,854.4,"gym",193.24)
        local depanneur = cBatiment:init(self,"depanneur.png",-2566.5,854.4,"depanneur",-64)
        local magasin = cBatiment:init(self,"magasin.png",1425,526,"magasin",0,true)
        local appartement = cBatiment:init(self,"appartement.png",890,670,"appartement",46)
        local clotureLoft = cBatiment:init(self,"clotureLoft.png",-1429 ,-625, nil,nil,true)
        local loft = cBatiment:init(self,"loft.png",-1429 ,-800, "loft",-45,true)
        local universite = cBatiment:init(self,"universite.png",300,-735,"universite",0)
        local banque = cBatiment:init(self,"banque.png",100,650,"banque",3)
        local centreSportif = cBatiment:init(self,"centreSportif.png",1500,-735,"centresportif",-177)
        local faculte = cBatiment:init(self,"faculte.png",2330,675,"faculte",-40,true)

        -- Autos
        for i=1,8,2 do
            local auto = cAuto:init(i)
            autos:insert(auto)
        end
        self:insert(autos)

        -- Filtre qui obscurcit l'écran selon l'heure
        filtreNocturne = display.newRect(self, 0, 0, 6800, 3400 )
        filtreNocturne.fill = { 0, .1 ,.3, 0 }

    end
    
    function map:assombrir(heure)
        if heure > 12 then
            filtreNocturne.fill = { 0, .1 ,.25, (heure-17)*8/100 }
        else
            if heure < 4 then
                filtreNocturne.fill = { 0, .1 ,.25, (7)*8/100 }
            else
                filtreNocturne.fill = { 0, .1 ,.25, (13-heure*2)*8/100 }
            end
        end
    end

    function map:sleep()
        -- print("sleep")
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