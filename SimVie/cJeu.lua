-----------------------------------------------------------------------------------------
--
-- cJeu.lua
--
-----------------------------------------------------------------------------------------
local Jeu = {}

function Jeu:init()

    local jeu = display.newGroup()
    local cDonnees = require("cDonnees")
    local cMap = require("cMap")
    local cCamera = require("cCamera")
    local cPerso = require("cPerso")
    local cJoystick = require("cJoystick")
    local cInterieur = require("cInterieur")
    local cMenu = require("cMenu")
    local cInfos = require("cInfos")

    local bgMusic = audio.loadStream( "toune_loundge.mp3" )

    -- Points d'apparition du personnage
    local spawns = { 
        appartement = { x = 946, y= 1150 },
        loft        = { x = -1275, y = -400 }
    }

    local maMap
    local monPerso
    local interieur
    local monJoystick

    function jeu:init()
        display.setStatusBar( display.HiddenStatusBar )
        if audio.seek( 1000, bgMusicChannel ) then
            audio.stop( bgMusicChannel )
        end
        bgMusicChannel = audio.play( bgMusic, { channel=1, loops=-1, fadein=1000 } )
        
        -- Point d'apparition du personnage (devant son domicile)
        local spawn = {}
        spawn.x = spawns.appartement.x
        spawn.y = spawns.appartement.y
        if _G.data ~= nil and table.indexOf( _G.data.inventaire, "loft" ) ~= nil then
            spawn.x, spawn.y = spawns.loft.x, spawns.loft.y
        end

        -- Instanciation des éléments de jeu
        monJoystick = cJoystick:init(50,125)
        monPerso = cPerso:init(spawn.x,spawn.y,0,monJoystick,self)
        maMap = cMap:init(monPerso)
        local maCamera = cCamera:init(monPerso,maMap)

        -- Instanciation de l'heure et de l'horaire en variable globale
        _G.infos = cInfos:init(7, 2, maMap, monPerso, self)
        
        monJoystick:activate()
        maMap:insert(monPerso)

        self:insert(maCamera)
        self:insert(monJoystick)
    end

    -- Désactiver le monde/joystick et charger l'interface d'intérieur d'un batiment
    function jeu:entrerBatiment(destination)
        -- maMap:sleep()
        monJoystick:kill()
        interieur = cInterieur:init(destination,self,maMap,monPerso)
    end

    -- Réactiver le monde/joystick et décharger l'interface d'intérieur
    function jeu:sortirBatiment()
        -- maMap:wake()
        interieur:removeSelf()
        monJoystick:activate()
        -- monPerso:changerVehicule( "marche" )
    end

    -- Détruire le jeu et tous ses enfants
    function jeu:kill()
        local function recursiveKill(group) -- fonction locale récursive appelant la fonction kill de chaque enfant (removeEventListeners)
            for i=group.numChildren,1,-1 do
                if group[i].numChildren~=nil then
                    recursiveKill(group[i])
                end
                if group[i].kill ~= nil then
                    group[i]:kill()
                end
            end
        end
        recursiveKill(self)
        self:removeSelf()
        infos:removeSelf()
        _G.infos = nil
        cMenu:init()
    end

    jeu:init()
    return jeu
end

return Jeu