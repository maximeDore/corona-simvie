-----------------------------------------------------------------------------------------
--
-- cJeu.lua
--
-----------------------------------------------------------------------------------------
local Jeu = {}

function Jeu:init(spawnX, spawnY)

    local jeu = display.newGroup()
    local cMap = require("cMap")
    local cCamera = require("cCamera")
    local cPerso = require("cPerso")
    local cJoystick = require("cJoystick")
    local cInterieur = require("cInterieur")
    local cMenu = require("cMenu")
    local cInfos = require("cInfos")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )
    local maMap
    local monPerso
    local interieur
    local monJoystick
    local inventaire = {}

    function jeu:init()
        display.setStatusBar( display.HiddenStatusBar )
        if audio.seek( 1000, bgMusicChannel ) then
            audio.stop( bgMusicChannel )
        end
        -- bgMusicChannel = audio.play( bgMusic, { channel=1, loops=-1, fadein=2000 } )
        
        -- Instanciation des éléments de jeu
        monJoystick = cJoystick:init(50,125)
        monPerso = cPerso:init(spawnX,spawnY,0,monJoystick,self)
        maMap = cMap:init()
        local maCamera = cCamera:init(monPerso,maMap)

        -- Instanciation de l'heure et de l'horaire en variable globale
        _G.infos = cInfos:init(7,2,maMap,monPerso)
        
        monJoystick:activate()
        maMap:insert(monPerso)

        self:insert(maCamera)
        self:insert(monJoystick)
    end

    -- Désactiver le monde/joystick et charger l'interface d'intérieur d'un batiment
    function jeu:entrerBatiment(destination)
        -- self:kill()
        maMap:sleep()
        monJoystick:kill()
        interieur = cInterieur:init(destination,self,maMap,monPerso)
    end

    -- Réactiver le monde/joystick et décharger l'interface d'intérieur
    function jeu:sortirBatiment()
        interieur:removeSelf()
        maMap:wake()
        monJoystick:activate()
    end

    -- Quand le personnage meurt ou perd la partie
    function jeu:mourir()
        self:kill()
    end

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
        infos:removeSelf()
        self:removeSelf()
        cMenu:init()
    end

    jeu:init()
    return jeu
end

return Jeu