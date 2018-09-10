-----------------------------------------------------------------------------------------
--
-- cAutoMenu.lua
--
-- Classe qui affiche des voitures dans le fond du menu principal et qui gère leur déplacement
--
-----------------------------------------------------------------------------------------
local AutoMenu = {}

function AutoMenu:init()

    local autoMenu = display.newGroup()
    local autoResetter
    local autoBleue
    local autoGrise
    local autoVerte

    local function autoReset(e)
        timer.performWithDelay(1, function()
            e.other.x = -display.contentCenterX
            transition.to(e.other, { time = math.random(4000,7000), x = display.contentWidth*1.5, y = e.other.y})
            end
        )
    end

    function autoMenu:init()

        -- Box de collision servant à détecter les autos à l'extérieur de l'écran pour les renvoyer au début
        autoResetter = display.newRect(display.contentWidth*1.35, display.contentCenterY, 1, display.contentHeight)
        autoMenu:insert(autoResetter)
        
        -- Voitures
        autoGrise = display.newImage("ressources/img/autoSideGris.png",math.random(display.contentWidth),display.contentHeight*0.82)
        autoGrise.xScale = -2
        autoGrise.yScale = 2
        autoMenu:insert(autoGrise)
    
        autoBleue = display.newImage("ressources/img/autoSideBleu.png",math.random(display.contentWidth),display.contentHeight*0.58)
        autoBleue.xScale = -2
        autoBleue.yScale = 2
        autoMenu:insert(autoBleue)
    
        autoVerte = display.newImage("ressources/img/autoSideVert.png",math.random(display.contentWidth),display.contentHeight*0.69)
        autoVerte.xScale = -2
        autoVerte.yScale = 2
        autoMenu:insert(autoVerte)

        -- Ajout des corps de physique avec un délai d'un frame pour éviter un bogue de collision en fin de partie
        timer.performWithDelay(1, function()
            physics.addBody( autoResetter, "static", { density=100.0, friction=1, bounce=0 } )
            physics.addBody( autoGrise, "dynamic", { density=100.0, friction=1, bounce=0 } )
            autoGrise.isFixedRotation = true
            physics.addBody( autoBleue, "dynamic", { density=100.0, friction=1, bounce=0 } )
            autoBleue.isFixedRotation = true
            physics.addBody( autoVerte, "dynamic", { density=100.0, friction=1, bounce=0 } )
            autoVerte.isFixedRotation = true
        end)
    
        -- Déplacement des voitures
        transition.to ( autoGrise, { time = math.random(2000,4000), x = display.contentWidth*1.5, y = autoGrise.y})
        transition.to ( autoBleue, { time = math.random(2000,4000), x = display.contentWidth*1.5, y = autoBleue.y})
        transition.to ( autoVerte, { time = math.random(2000,4000), x = display.contentWidth*1.5, y = autoVerte.y})

    end

    autoMenu:init()

    autoResetter:addEventListener( "collision", autoReset )

    return autoMenu
    
end

return AutoMenu

