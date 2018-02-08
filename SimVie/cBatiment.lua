-----------------------------------------------------------------------------------------
--
-- cBatiment.lua
--
-----------------------------------------------------------------------------------------
local Batiment = {}

function Batiment:init(img,scaleX,scaleY,x,y)

    local batiment = display.newGroup()
    local cPorte = require("cPorte")

    function batiment:init()
        local sprite = display.newImageRect(self,img,scaleX,scaleY)
        local porte = cPorte:init(self,x+scaleX/3.85,y+scaleY/2,50,2.5)
        sprite.type = "batiment"
        sprite.x = x
        sprite.y = y
        physics.addBody( sprite, "static", { density=0.0, friction=0, bounce=0} )
    end
    batiment:init()
    return batiment
end

return Batiment