-----------------------------------------------------------------------------------------
--
-- cAuto.lua
--
-----------------------------------------------------------------------------------------
local Auto = {}

function Auto:init(scale)

    local auto = display.newGroup()
    local srcRouge = {"autoRouge.png","autoRougeTop.png","autoRougeDown.png"}
    local srcJaune = {"taxiSide.png","taxiTop.png","taxiDown.png"}
    local srcBleue = {"autoBleue.png","autoBleueTop.png","autoBleueDown.png"}
    local src = {srcRouge,srcJaune,srcBleue}

    function auto:init()
        local rand = math.random( 3 )
        
        local sprite = display.newImage(self,src[rand][1])
        sprite.type = "auto"
        sprite.xScale = 1.5
        sprite.yScale = 1.5
        sprite.x = -3186,5
        sprite.y = -120,5 
        transition.to ( sprite, { time = math.random(6000), x = sprite.x, y = 1496,5, onComplete=wp2})
        physics.addBody( sprite, "static", { density=0.0, friction=0, bounce=0} )

        local function wp2()
            print("wp2")
            transition.to ( sprite, { time = math.random(6000), x = 3195,5, y = sprite.x, onComplete=wp3})
        end

        local function wp3()
            transition.to ( sprite, { time = math.random(6000), x = sprite.x, y = -120,5, onComplete=wp4})
        end

        local function wp4()
            -- transition.to ( sprite, { time = math.random(6000), x = sprite.x, y = 1496,5, onComplete=wp5})
        end

    end
    auto:init()
    return auto
end

return Auto