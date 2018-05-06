-----------------------------------------------------------------------------------------
--
-- cMap.lua
--
-- Classe qui génère le monde et ses bâtiments
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
    local nbAutos = 4   -- Maximum 6

    -- Constructeur, construit tous les bâtiments et 
    function map:init()
        local ville = display.newImageRect(self, "map.png", 6800, 3400)

        -- Limites physiques de la map
        local murNord = display.newRect( self, ville.x, -ville.height/2, ville.width, 50 )
        physics.addBody( murNord, "static", { density=0, friction=0, bounce=0} )
        murNord.isVisible = false
        local murSud = display.newRect( self, ville.x, ville.height/2, ville.width, 20 )
        physics.addBody( murSud, "static", { density=0, friction=0, bounce=0} )
        murSud.isVisible = false
        local murOuest = display.newRect( self, ville.width/2, ville.y, 20, ville.height )
        physics.addBody( murOuest, "static", { density=0, friction=0, bounce=0} )
        murOuest.isVisible = false
        local murEst = display.newRect( self, -ville.width/2, ville.y, 20, ville.height )
        physics.addBody( murEst, "static", { density=0, friction=0, bounce=0} )
        murEst.isVisible = false

        -- Bâtiments avec physiques
        local gymTop = cBatiment:init(self,"gymTop.png",-1356.8,525)
        local depTop = cBatiment:init(self,"depanneurTop.png",-2275,435)
        local panneauPub = cBatiment:init(self,"panneauPub.png",-2275,-525, nil, nil, nil, perso)
        
        -- Bâtiments avec intérieur
        -- Batiment:init( parent, img, x, y, destination, porteX, outline )
        local gym = cBatiment:init(self,"gym.png",-1356.8,854.4,"gym",193.24)
        local depanneur = cBatiment:init(self,"depanneur.png",-2566.5,854.4,"depanneur",-64)
        local magasin = cBatiment:init(self,"magasin.png",1425,526,"magasin",0,true)
        local banque = cBatiment:init(self,"banque.png",100,650,"banque",3)
        local appartement = cBatiment:init(self,"appartement.png",890,670,"appartement",46)
        local clotureLoft = cBatiment:init(self,"clotureLoft.png",-1429 ,-625, nil,nil,true)
        local loft = cBatiment:init(self,"loft.png",-1429 ,-800, "loft",-45,true)
        local universite = cBatiment:init(self,"universite.png",296,-735,"universite",0)
        local centreSportif = cBatiment:init(self,"centreSportif.png",1519,-777,"centresportif",-177)
        local faculte = cBatiment:init(self,"faculte.png",2330,675,"faculte",-40,true)

        -- Instanciation des autos
        for i=1,nbAutos*2,2 do
            local auto = cAuto:init(i,perso)
            autos:insert(auto)
        end
        self:insert(autos)

        -- Filtre qui obscurcit l'écran selon l'heure
        filtreNocturne = display.newRect(self, 0, 0, 6800, 3400 )
        filtreNocturne.fill = { 0, .1 ,.3, 0 }

    end
    
    -- Augmente/diminue l'opacité du filtre de nuit selon l'heure du jour
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

    -- Supprime le monde
    function map:kill()
        self:removeSelf()
    end

    map:init()
    return map
end

return Map