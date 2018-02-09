-----------------------------------------------------------------------------------------
--
-- cHoraire.lua
--
----------------------------------------------------------------------------------------- 
local Horaire = {}
function Horaire:init(heure)
    local options = {text = heure..":00", width = 256, x = display.contentCenterX, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "center"}
    local horaire = display.newText(options)
    function horaire:init(heure)
        self.heure = heure
        self:update(0)
    end 

    function horaire:update(heure,min)
        self.heure = self.heure-nb
        self.heure = self.heure-nb
        self.text = self.heure..":"..self.min.."0"
        if(self.heure==0) then
            -- Victory
            self.parent:win()
            print("C'est gagné!")
        end
    end

    return horaire

end

return Horaire