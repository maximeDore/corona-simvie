-----------------------------------------------------------------------------------------
--
-- cCheats.lua
--
-- Classe qui gère les triches cachées dans le jeu
--
-----------------------------------------------------------------------------------------
local Cheats = {}
local delay = 2500
local tapCount = 10
local onOff = false
local counter
local telephone

function Cheats:init( perso )
    self.numTaps = 0
    local cheats = {}

    function cheats:vehicles()
        if perso.inventaire["voiture"] and perso.inventaire["scooter"] then
            perso.inventaire["voiture"] = false
            perso.inventaire["scooter"] = false
        else
            perso.inventaire["voiture"] = true
            perso.inventaire["scooter"] = true
        end
        telephone:updateBoutons()
    end
    
    function cheats:money()
        perso:setMoney(1000)
    end

    function cheats:loft()
        if perso.inventaire["loft"] then
            perso.inventaire["loft"] = false
        else
            perso.inventaire["loft"] = true
        end
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

    if self.numTaps == tapCount then
        telephone = _G.infos.getTelephone()
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