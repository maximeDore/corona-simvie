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

    function jeu:init()
        local monPerso = cPerso:init(display.contentCenterX,display.contentCenterY,0)
        local maMap = cMap:init()
        local maCamera = cCamera:init(monPerso,maMap)

        maMap:insert(monPerso)
    end
    jeu:init()
    return jeu
end

return Jeu