-----------------------------------------------------------------------------------------
--
-- cBouton.lua
--
-----------------------------------------------------------------------------------------
local Bouton = {}

function Bouton:init (imageName,x,y,callbackFunction,callbackParam)
    
    local bouton = display.newImage(imageName,x,y)

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