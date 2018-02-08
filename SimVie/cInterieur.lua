-----------------------------------------------------------------------------------------
--
-- cInterieur.lua
--
-----------------------------------------------------------------------------------------
local Interieur = {}

function Interieur:init(destination,jeu)

    local interieur = display.newGroup()
    local cJeu = require("cJeu")
    local cBouton = require("cBouton")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )
    

    function interieur:init()
        -- local bgMusicChannel = audio.play( bgMusic, { channel=2, loops=-1, fadein=2000 } )
        -- local bg = display.newImage("bg.jpg",display.contentCenterX,display.contentCenterY)

        local function retour()
            jeu:sortirBatiment()
            self:kill()
        end

        local bg = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight)
        local btRetour = cBouton:init("btContinuer.png",display.contentCenterX,display.contentCenterY,retour)
        self:insert(bg)
        self:insert(btRetour)
    end

    function interieur:kill()
        bgMusicChannel = audio.stop(2)
    end

    interieur:init()
    return interieur
end

return Interieur