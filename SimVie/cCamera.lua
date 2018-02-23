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
        if cible.x >= -monde.width/2+display.contentWidth/2 and cible.x <= monde.width/2-display.contentWidth/2 then
            self.x = display.contentWidth/2 + self.x - x
        end
        if cible.y >= -monde.height/2+display.contentHeight/2 and cible.y <= monde.height/2-display.contentHeight/2 then
            self.y = display.contentHeight/2 + self.y - y
        end
    end

    function camera:kill()
        Runtime:removeEventListener("enterFrame", self)
    end

    camera:init()
    Runtime:addEventListener("enterFrame", camera)
    return camera
end
return Camera