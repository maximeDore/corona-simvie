-----------------------------------------------------------------------------------------
--
-- cJeu.lua
--
-----------------------------------------------------------------------------------------
local Jeu = {}

function Jeu:init()

    local jeu = {}
    local cMap = require("cMap")
    local cCamera = require("cCamera")
    local cPerso = require("cPerso")
    local cBatiment = require("cBatiment")
    local cJoystick = require("cJoystick")

    function jeu:init()
        local monJoystick = cJoystick:init(50,100)
        local monPerso = cPerso:init(display.contentCenterX,display.contentCenterY,0,monJoystick)
        local maMap = cMap:init()
        local maCamera = cCamera:init(monPerso,maMap)
        monJoystick:toFront()
        monJoystick:activate()
        maMap:insert(monPerso)
    end
    jeu:init()
    return jeu
end

return Jeu