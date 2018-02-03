-----------------------------------------------------------------------------------------
--
-- cAutoMenu.lua
--
-----------------------------------------------------------------------------------------
local AutoMenu = {}

function AutoMenu:init()

    local autoMenu = display.newGroup()
    local autoResetter
    local autoBleue
    local autoRouge
    local autoJaune

    local function autoReset(e)
        timer.performWithDelay(1, function()
            e.other.x = -display.contentCenterX
            transition.to(e.other, { time = math.random(4000,7000), x = display.contentWidth*1.5, y = e.other.y})
            end
        )
    end

    function autoMenu:init()

        -- Box de collision servant à détecter la 
        autoResetter = display.newRect(display.contentWidth*1.35, display.contentCenterY, 1, display.contentHeight)
        physics.addBody( autoResetter, "static", { density=100.0, friction=1, bounce=0 } )
        autoMenu:insert(autoResetter)
        
        -- Voitures
        autoRouge = display.newImage("autoRouge.png",math.random(display.contentWidth),display.contentHeight*0.82)
        physics.addBody( autoRouge, "dynamic", { density=100.0, friction=1, bounce=0 } )
        autoRouge.isFixedRotation = true
        autoMenu:insert(autoRouge)
    
        autoBleue = display.newImage("autoBleue.png",math.random(display.contentWidth),display.contentHeight*0.58)
        physics.addBody( autoBleue, "dynamic", { density=100.0, friction=1, bounce=0 } )
        autoBleue.isFixedRotation = true
        autoMenu:insert(autoBleue)
    
        autoJaune = display.newImage("autoJaune.png",math.random(display.contentWidth),display.contentHeight*0.69)
        physics.addBody( autoJaune, "dynamic", { density=100.0, friction=1, bounce=0 } )
        autoJaune.isFixedRotation = true
        autoMenu:insert(autoJaune)
    
        -- Déplacement des voitures
        transition.to ( autoRouge, { time = math.random(2000,4000), x = display.contentWidth*1.5, y = autoRouge.y})
        transition.to ( autoBleue, { time = math.random(2000,4000), x = display.contentWidth*1.5, y = autoBleue.y})
        transition.to ( autoJaune, { time = math.random(2000,4000), x = display.contentWidth*1.5, y = autoJaune.y})

    end

    autoMenu:init()

    autoResetter:addEventListener( "collision", autoReset )

    return autoMenu
    
end

return AutoMenu

