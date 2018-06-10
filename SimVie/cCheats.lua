-----------------------------------------------------------------------------------------
--
-- cCheats.lua
--
-- Classe qui gère les triches cachées dans le jeu
--
-----------------------------------------------------------------------------------------
local Cheats = {}
local delay = 2500
local onOff = false
local counter

function Cheats:init( perso )
    self.numTaps = 0
    local cheats = {}

    function cheats:vehicles( perso )
        perso.inventaire["voiture"] = true
        perso.inventaire["scooter"] = true
    end
    
    function cheats:money( perso )
        perso:setMoney(10000)
    end

    return cheats

end

function Cheats:counter()

    if onOff == false then
        if counter == nil then
            counter = timer.performWithDelay(delay, function(e) self:unlock(e) end)
        end
        self.numTaps = self.numTaps + 1
        print(self.numTaps, onOff)
    end

end

function Cheats:unlock(e)

    if self.numTaps == 13 then
        local telephone = _G.infos.getTelephone()
        telephone.unlockCheats()

        onOff = true
        print("cheats unlocked")
    else
        print("clear")
    end
    timer.cancel(counter)
    counter = nil
    self.numTaps = 0


end

return Cheats