-----------------------------------------------------------------------------------------
--
-- cBouton.lua
--
-----------------------------------------------------------------------------------------
local Bouton = {}

function Bouton:init ( imageName, x, y, callbackFunction, callbackParam, width, height )
    
    local bouton
    if width==nil then
        bouton = display.newImage(imageName,x,y)
    else
        bouton = display.newRect( x, y, width, height )
        bouton.alpha = 0.01
    end

    function bouton:init()
    end

    function bouton:tap()
        callbackFunction(callbackParam)  
    end

    function bouton:kill()
        self:removeEventListener("tap", bouton)
    end

    bouton:init()
    bouton:addEventListener("tap", bouton)
    return bouton
end

return Bouton