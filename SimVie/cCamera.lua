-----------------------------------------------------------------------------------------
--
-- cCamera.lua
--
-- Caméra suivant le personnage dans le monde et ne dépassant pas les limites de la map
--
----------------------------------------------------------------------------------------- 
local Camera = {}

function Camera:init(cible, monde)
    local camera = display.newGroup()

    -- Constructeur
    function camera:init()
        self.cible = cible
        self:insert(monde)
    end

    -- Event.enterFrame
    function camera:enterFrame()
        local x,y = self.cible:localToContent(0,0)
        if cible.x >= -monde.width/2+display.contentWidth/2-display.screenOriginX and cible.x <= monde.width/2-display.contentWidth/2+display.screenOriginX then
            self.x = display.contentWidth/2 + self.x - x
        end
        if cible.y >= -monde.height/2+display.contentHeight/2-display.screenOriginY and cible.y <= monde.height/2-display.contentHeight/2+display.screenOriginY then
            self.y = display.contentHeight/2 + self.y - y
        end
    end

    -- Suppression de l'écouteur
    function camera:kill()
        Runtime:removeEventListener("enterFrame", self)
    end

    camera:init()
    Runtime:addEventListener("enterFrame", camera)
    return camera
end
return Camera