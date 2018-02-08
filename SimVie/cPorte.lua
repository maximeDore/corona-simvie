-----------------------------------------------------------------------------------------
--
-- cPorte.lua
--
----------------------------------------------------------------------------------------- 

local Porte = {}

function Porte:init(parent,x,y,destination)

    local porte = display.newRect(0,0,75,5)

    function porte:init()
        self.destination = destination
        self.type = "porte"
        self.x = x
        self.y = y
        parent:insert(self)
        physics.addBody( self, "static", { density=0.0, friction=0.5, bounce=0 } )
    end

    porte:init()
    return porte
end

return Porte