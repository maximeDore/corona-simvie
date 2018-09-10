-----------------------------------------------------------------------------------------
--
-- cSplashscreen.lua
--
-- Classe qui gère l'affichage du splashscreen
--
-----------------------------------------------------------------------------------------
local Splash = {}

function Splash:init()

    local cMenu = require("cMenu")
    local splash = display.newGroup()
    local bg
    local logo
    local fade

    -- Fondu noir
    function listener()
        transition.fadeOut( splash, { time=500, onComplete=listener2 } )
    end

    -- Supprime la page-écran et affiche le menu
    function listener2()
        cMenu:init()
        splash:removeSelf()
    end
    
    -- Constructeur, affiche les éléments de la page-écran
    function splash:init()
    
        fade = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth*2,display.contentHeight)
        fade.fill = {0,0,0}
        transition.fadeOut( fade, { time=500 } )
        bg = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth*2,display.contentHeight)
        local degrade = {
            type = "gradient",
            color1 = { 1, .1, .1, 1 },
            color2 = { .75, .1, .1, 1 },
            direction = "down"
        }
        bg.fill = degrade

        logo = display.newImage("ressources/img/logo.png", display.contentCenterX, display.contentCenterY)
        logo.xScale = 1.5
        logo.yScale = 1.5
        timer.performWithDelay( 2500, listener)
        self:insert(bg)
        self:insert(logo)
        self:insert(fade)
    end

    splash:init()
    return splash

end

return Splash