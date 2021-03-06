-----------------------------------------------------------------------------------------
--
-- cJeu.lua
--
-- Classe qui génère tous les éléments du jeu, gère les changements de scène et contrôle la musique d'ambiance
--
-----------------------------------------------------------------------------------------
local Jeu = {}

function Jeu:init( slot )

    local jeu = display.newGroup()
    local cMap = require("cMap")
    local cCamera = require("cCamera")
    local cPerso = require("cPerso")
    local cJoystick = require("cJoystick")
    local cInterieur = require("cInterieur")
    local cMenu = require("cMenu")
    local cInfos = require("cInfos")
    local cCheats = require("cCheats")

    local bgMusic = audio.loadStream( "ressources/sfx/toune_loundge.mp3" )

    -- Points d'apparition du personnage
    local spawns = {
        appartement = { x = 946, y= 1100 },
        loft        = { x = -1275, y = -400 }
    }

    local maMap
    local monPerso
    local interieur
    local monJoystick

    -- Constructeur, appelle les constructeurs des éléments du jeu
    function jeu:init()
        display.setStatusBar( display.HiddenStatusBar )
        if audio.seek( 1000, bgMusicChannel ) then
            audio.stop( bgMusicChannel )
        end
        bgMusicChannel = audio.play( bgMusic, { channel=1, loops=-1, fadein=1000 } )
        
        -- Fondu d'entrée
        fade = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth*2,display.contentHeight)
        fade.fill = {0,0,0}
        transition.fadeOut( fade, { time=500, onComplete=fadeListener } )
        
        -- Point d'apparition du personnage (devant son domicile)
        local spawn = {}
        spawn.x = spawns.appartement.x
        spawn.y = spawns.appartement.y

        if _G.data ~= nil and _G.data.inventaire["loft"] then
            spawn.x, spawn.y = spawns.loft.x, spawns.loft.y
        end

        inventaire = nil

        -- Instanciation des éléments de jeu
        monJoystick = cJoystick:init(50,125)
        monPerso = cPerso:init(spawn.x,spawn.y,0,monJoystick,self)
        maMap = cMap:init(monPerso)
        local maCamera = cCamera:init(monPerso,maMap)

        -- Instanciation de l'heure et de l'horaire en variable globale
        _G.infos = cInfos:init(7, 2, maMap, monPerso, self)

        -- Instanciation des cheats
        _G.cheats = cCheats:init(monPerso)
        
        monJoystick:activate()
        maMap:insert(monPerso)

        self:insert(maCamera)
        self:insert(monJoystick)
    end

    -- Désactiver le monde/joystick et charger l'interface d'intérieur d'un batiment
    function jeu:entrerBatiment(destination)
        monJoystick:kill()
        interieur = cInterieur:init(destination,self,maMap,monPerso)
    end

    -- Réactiver le monde/joystick et décharger l'interface d'intérieur
    function jeu:sortirBatiment()
        interieur:removeSelf()
        monJoystick:activate()
        monPerso:setDestination()
        -- Sauvegarde la partie
        -- local function save()
            print("Partie sauvegardée automatiquement")
            -- _G.infos:feedback( "Partie sauvegardee avec succes" )
            donnees:prepForSave( monPerso, _G.infos, true )
        -- end
    end

    -- Détruire le jeu, ses écouteurs et tous ses enfants
    function jeu:kill()
        Runtime:removeEventListener( "key", jeu )
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
        _G.infos:removeSelf()
        _G.infos = nil
        _G.cheats = nil
        cMenu:init()
    end

    -- Event.key
    function jeu:key(e)
        -- Bouton retour d'Android ou Window Phone
        if e.keyName == "back" then
            if e.phase == "down" then
                _G.infos:menu()
            end
            return true
        end
    end

    jeu:init()

    Runtime:addEventListener( "key", jeu )

    return jeu
end

return Jeu