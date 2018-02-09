-----------------------------------------------------------------------------------------
--
-- cHoraire.lua
--
----------------------------------------------------------------------------------------- 
local Horaire = {}
function Horaire:init(heureDepart)
    local options = {text = heureDepart..":00", width = 256, x = display.contentCenterX, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "center"}
    local horaire = display.newText(options)
    horaire:setFillColor(1,0,0)
    local heure = heureDepart
    function horaire:init()
    end 

    function horaire:getHeure()
        return heure
    end

    function horaire:update(nb)
        heure = heure+nb
        self.text = heure..":00"
        if heure==24 then
            self.text = "00:00"
        end
    end

    function horaire:reset()
        heure = heureDepart
        self:update(0)
    end

    horaire:init()
    return horaire

end

return Horaire