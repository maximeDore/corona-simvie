-----------------------------------------------------------------------------------------
--
-- cJeu.lua
--
-----------------------------------------------------------------------------------------
local Jeu = {}

function Jeu:init(spawnX,spawnY)

    local jeu = {}
    local cMap = require("cMap")
    local cInterieur = require("cInterieur")
    local cCamera = require("cCamera")
    local cPerso = require("cPerso")
    local cBatiment = require("cBatiment")
    local cJoystick = require("cJoystick")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )

    function jeu:init()
        -- local bgMusicChannel = audio.play( bgMusic, { channel=1, loops=-1, fadein=2000 } )
        local monJoystick = cJoystick:init(50,100)
        local monPerso = cPerso:init(spawnX,spawnY,0,monJoystick)
        local maMap = cMap:init()
        local maCamera = cCamera:init(monPerso,maMap)

        monJoystick:toFront()
        monJoystick:activate()
        maMap:insert(monPerso)
    end

    function jeu:changerScene()

    end

    function jeu:kill()

    end

    jeu:init()
    return jeu
end

return Jeu