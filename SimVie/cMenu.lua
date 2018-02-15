-----------------------------------------------------------------------------------------
--
-- cMenu.lua
--
-----------------------------------------------------------------------------------------
 
local Menu = {}
function Menu:init()

    local menu = display.newGroup()
    local bgMusic = audio.loadStream( "Chill Wave.mp3" )
    local bouton = require("cBouton")
    local autoMenu = require("cAutoMenu")
    local cMenuCommencer = require("cMenuCommencer")
    local cInstructions = require("cInstructions")
    local forNum
    local intNum
    local chaNum
    local bg
    local menuCommencer
    local btCommencer
    local btContinuer
    local fade
    
    function listener()
        transition.fadeOut( menu, { time=500, onComplete=listener2 } )
    end

    function listener2()
        local carriere
        if forNum>intNum then
            carriere = "sports"
        else
            carriere = "sciences"            
        end
        cInstructions:init(forNum,intNum,chaNum,carriere)
        menu:removeSelf()
    end

    function menu:init()
        -- Affiche la barre de notificationsw
        display.setStatusBar( display.LightTransparentStatusBar )
        -- Applique un filtre qui rend l'image moins floue (pour mieux voir les pixels)
        display.setDefault( "magTextureFilter", "nearest" )
        
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
        -- _G.bgMusicChannel = audio.play( bgMusic, { channel=1, loops=-1, fadein=2000 } )
        
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

    function menu:setPoints(f,i,c)
        forNum = f
        intNum = i
        chaNum = c
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