-----------------------------------------------------------------------------------------
--
-- cJoystick.lua
--
-----------------------------------------------------------------------------------------
local Joystick = {}

function Joystick:init(innerRadius, outerRadius)
    local stage = display.getCurrentStage()
    
    local joyGroup = display.newGroup()
    
    local bgJoystick = display.newCircle( joyGroup, 0,0, outerRadius )
    bgJoystick:setFillColor( .2,.2,.2,.25 )
    
    local radToDeg = 180/math.pi
    local degToRad = math.pi/180
    local radAngle = 0
    local joystick = display.newCircle( joyGroup, 0,0, innerRadius )
    joystick:setFillColor( .8,.8,.8,.25 )
    local paint = { 1,1,1,.5 }
    joystick.stroke = paint
    joystick.strokeWidth = 5
    -- pour faciliter l'appel
    joyGroup.joystick = joystick
    
    -- distance à laquelle le joystick s'arrête
    local stopRadius = outerRadius - innerRadius/2
    
    local angle = 0
    local distance = 0

    function joyGroup:getAngle()
    	return angle
    end
    function joyGroup:getDistance()
    	return distance/stopRadius
    end
    function joyGroup:getAngRad()
        return radAngle*-1
    end
    
    function joystick:touch(event)
        local phase = event.phase
        if phase=='began' or phase=="moved"  then
        	if phase == 'began'  then
                stage:setFocus(event.target, event.id)
            end
            local parent = self.parent
            local posX, posY = parent:contentToLocal(event.x, event.y)
            angle = (math.atan2( posX, posY )*radToDeg)-90
            if( angle < 0 ) then
                angle = 360 + angle
            end
            
            -- could emit "direction" events here
            --Runtime:dispatchEvent( {name='direction',directionId=directionId } )
            
            distance = math.sqrt((posX*posX)+(posY*posY))
            
            if( distance >= stopRadius ) then
                distance = stopRadius
            else
                self.x = posX
                self.y = posY
            end
            radAngle = angle*degToRad
            self.x = distance*math.cos(radAngle)
            self.y = -distance*math.sin(radAngle)
        else
            self.x = 0
			self.y = 0
            stage:setFocus(nil, event.id)
            
            angle = 0
            distance = 0
        end
        return true
    end
    
    function joyGroup:activate()
        self:addEventListener("touch", self.joystick )
        angle = 0
        distance = 0
        self.isVisible = true
    end
    
    function joyGroup:kill()
        self:removeEventListener("touch", self.joystick )
        stage:setFocus(nil)
        joystick.x = 0
        joystick.y = 0
        angle = 0
        distance = 0
        self.isVisible = false
    end

    joyGroup.x = display.screenOriginX+outerRadius+innerRadius;
    joyGroup.y = display.contentHeight-outerRadius-innerRadius;
    return( joyGroup )
end

return Joystick