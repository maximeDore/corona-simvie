-----------------------------------------------------------------------------------------
--
-- cCamera.lua
--
----------------------------------------------------------------------------------------- 
local Camera = {}

function Camera:init(cible, monde)
    local camera = display.newGroup()

    function camera:init()
        self.cible = cible
        self:insert(monde)
    end

    function camera:enterFrame()
        local x,y = self.cible:localToContent(0,0)
        self.x = display.contentWidth/2 + self.x - x
        self.y = display.contentHeight/2 + self.y - y
    end

    function camera:kill()
        Runtime:removeEventListener("enterFrame", self)
    end

    camera:init()
    Runtime:addEventListener("enterFrame", camera)
    return camera
end
return Camera