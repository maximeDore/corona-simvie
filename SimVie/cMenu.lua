-----------------------------------------------------------------------------------------
--
-- cMenu.lua
--
-----------------------------------------------------------------------------------------
local physics = require("physics")
 
local Menu = {}
function Menu:init()

    local menu = display.newGroup()
    local bg
    local bgMusic = audio.loadStream( "Chill Wave.mp3" )
    local bouton = require("cBouton")
    local autoMenu = require("cAutoMenu")
    local cMenuCommencer = require("cMenuCommencer")
    local cInstructions = require("cInstructions")
    local menuCommencer
    local btCommencer
    local btContinuer
    local fade
    
    function listener()
        transition.fadeOut( menu, { time=500, onComplete=listener2 } )
    end

    function listener2()
        cInstructions:init()
        menu:removeSelf()
    end

    function menu:init()
        
        local function commencer()
            menuCommencer = cMenuCommencer:init()
            self:insert(menuCommencer)
            btCommencer:removeSelf()
            btContinuer:removeSelf()
        end

        local function fadeListener()
            fade:removeSelf()
        end

        -- Charge la musique de fond dans le channel 1
        -- local bgMusicChannel = audio.play( bgMusic, { channel=1, loops=-1, fadein=2000 } )
        
        -- Fondu d'entrée
        fade = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth*2,display.contentHeight)
        fade.fill = {0,0,0}
        transition.fadeOut( fade, { time=500, onComplete=fadeListener } )
        
        -- Image de fond
        bg = display.newImage("bg.jpg",display.contentCenterX,display.contentCenterY)
        local autos = autoMenu:init()
        self:insert(bg)
        self:insert(autos)

        -- Boutons
        btCommencer = bouton:init("btCommencer.png",display.contentCenterX/2,display.contentHeight/1.37,commencer)
        btContinuer = bouton:init("btContinuer.png",display.contentCenterX/.67,display.contentHeight/1.37,commencer)
        self:insert(btCommencer)
        self:insert(btContinuer)

    end
        
    function menu:retour()
        local function commencer()
            menuCommencer = cMenuCommencer:init()
            self:insert(menuCommencer)
            btCommencer:removeSelf()
            btContinuer:removeSelf()
        end
        menuCommencer:removeSelf()
        btCommencer = bouton:init("btCommencer.png",display.contentCenterX/2,display.contentHeight/1.37,commencer)
        btContinuer = bouton:init("btContinuer.png",display.contentCenterX/.67,display.contentHeight/1.37,commencer)

    end

    function menu:kill()
        local function recursiveKill(group) -- fonction locale appelant la fonction kill de chaque enfant (removeEventListeners)
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
        listener()
    end
    

    menu:init()
    return menu

end

return Menu