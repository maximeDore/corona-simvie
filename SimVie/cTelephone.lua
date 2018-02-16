-----------------------------------------------------------------------------------------
--
-- cTelephone.lua
--
-----------------------------------------------------------------------------------------
local Telephone = {}

function Telephone:init( parent )

    local telephone = display.newGroup()
    local phone
    
    function telephone:init()
        phone = display.newImage( self, "telephone.png" )
        local screen = display.newImage( self, "screen.png", 0, -10.5 )
        self.x = display.contentWidth*.85-display.screenOriginX
        self.y = display.contentHeight-display.screenOriginY+175
        parent:insert(self)
    end

    function telephone:tap()
        if self.y >= display.contentHeight-display.screenOriginY+125 then
            transition.to( self, { time = 500, y = display.contentHeight-display.screenOriginY-150, transition=easing.outQuart } )
        elseif self.y <= display.contentHeight-display.screenOriginY-100 then
            transition.to( self, { time = 500, y = display.contentHeight-display.screenOriginY+175, transition=easing.outQuart } )
        end
    end

    telephone:init()

    phone:addEventListener( "tap", telephone )

    return telephone
end

return Telephone