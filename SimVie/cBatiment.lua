-----------------------------------------------------------------------------------------
--
-- cBatiment.lua
--
-----------------------------------------------------------------------------------------
local Batiment = {}

function Batiment:init(parent,img,x,y,destination,porteX,outline)

    local batiment = display.newGroup()
    local cPorte = require("cPorte")

    function batiment:init()
        local sprite = display.newImage(self,img,x,y)
        sprite.width= sprite.width*4
        sprite.height= sprite.height*4
        local imgOutline = graphics.newOutline( 2, img )
        if destination ~= nil then
            local porte = cPorte:init(self,x+porteX,y+sprite.height/2,destination)
        end
        sprite.type = "batiment"
        if outline then
            physics.addBody( sprite, "static", { outline=imgOutline, friction=0, bounce=0} )
        else
            physics.addBody( sprite, "static", { density=100, friction=0, bounce=0} )
        end
        parent:insert(self)
    end
    batiment:init()
    return batiment
end

return Batiment