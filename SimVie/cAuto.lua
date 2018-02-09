-----------------------------------------------------------------------------------------
--
-- cAuto.lua
--
-----------------------------------------------------------------------------------------
local Auto = {}

function Auto:init(actualWp)

    local auto = display.newGroup()
    local sprite
    local srcRouge = {"autoRouge.png","autoRougeTop.png","autoRougeDown.png"}
    local srcJaune = {"taxiSide.png","taxiTop.png","taxiDown.png"}
    local srcBleue = {"autoBleue.png","autoBleueTop.png","autoBleueDown.png"}
    local src = {srcRouge,srcJaune,srcBleue}
    local active = true

    local wp1 = { time = 6000, x = -3186.5, y = 1496.5}
    local wp2 = { time = 12000, x = 3195.5, y = 1496.5}
    local wp3 = { time = 6000, x = 3195.5, y = -1502.5}
    local wp4 = { time = 8000, x = -791.5, y = -1502,5}
    local wp5 = { time = 5000, x = -791.5, y = 61.5}
    local wp6 = { time = 6000, x = 2991.5, y = 61.5}
    local wp7 = { time = 5000, x = 2991.5, y = 1316,5}
    local wp8 = { time = 8000, x = -577.5, y = 1316,5}
    local wp9 = { time = 8000, x = -577.5, y = -1286}
    local wp10 = { time = 6000, x = 2972.5, y = -1286}
    local wp11 = { time = 5000, x = 2972.5, y = -120,5}
    local wp12 = { time = 12000, x = -3186.5, y = -120,5}
    local waypoints = {wp1,wp2,wp3,wp4,wp5,wp6,wp7,wp8,wp9,wp10,wp11,wp12}

    function auto:init()
        local rand = math.random( 3 )        
        sprite = display.newImage(self,src[rand][1])
        sprite.type = "auto"
        sprite.xScale = 1.5
        sprite.yScale = 1.5
        if actualWp==1 then
            sprite.x = -3186,5
            sprite.y = -120,5
        else
            sprite.x = waypoints[actualWp-1].x
            sprite.y = waypoints[actualWp-1].y
        end
        physics.addBody( sprite, "static", { density=0.0, friction=0, bounce=0} )
        self:start()
    end

    function auto:start()
        local index = actualWp
        local function trajet()
            transition.to ( sprite, waypoints[index])
            timer.performWithDelay(waypoints[index].time, function()
                if active then
                    trajet()
                end
            end)
            if index < #waypoints then
                index = index+1
            else
                index = 1
            end
        end
        trajet()
    end

    function auto:kill()
        active = false
    end

    auto:init()
    return auto
end

return Auto