-----------------------------------------------------------------------------------------
--
-- cInterieur.lua
--
-----------------------------------------------------------------------------------------
local Interieur = {}

function Interieur:init()

    local interieur = {}
    local cJeu = require("cJeu")
    local cBouton = require("cBouton")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )

    function interieur:init()
        -- local bgMusicChannel = audio.play( bgMusic, { channel=2, loops=-1, fadein=2000 } )
        local bg = display.newImage("bg.jpg",display.contentCenterX,display.contentCenterY)
        
    end

    function interieur:retour()
        jeu:init()
    end

    function interieur:kill()
        bgMusicChannel = audio.stop()
    end

    interieur:init()
    return interieur
end

return Interieur