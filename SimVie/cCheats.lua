-----------------------------------------------------------------------------------------
--
-- cCheats.lua
--
-- Classe qui gère les triches cachées dans le jeu
--
-----------------------------------------------------------------------------------------
local Cheats = {}
local delay = 1750
local tapCount = 7
local counter
local telephone

function Cheats:init( perso )
    self.numTaps = 0
    self.onOff = false
    self.gm = false
    local cheats = {}

    -- Ajoute/retire les véhicules de l'inventaire
    function cheats:vehicles()
        if perso.inventaire["voiture"] and perso.inventaire["scooter"] then
            perso.inventaire["voiture"] = false
            perso.inventaire["scooter"] = false
            infos:feedback( "Vehicules bloque" )
        else
            perso.inventaire["voiture"] = true
            perso.inventaire["scooter"] = true
            infos:feedback( "Vehicules debloque" )
        end
        telephone:updateBoutons()
    end
    
    -- Donne 1000$
    function cheats:money()
        perso:setMoney(1000)
        infos:feedback( "+1000$" )
    end

    -- Ajoute/retire le loft de l'inventaire
    function cheats:loftCheat()
        if perso.inventaire["loft"] then
            perso.inventaire["loft"] = false
            infos:feedback( "Loft bloque" )
        else
            perso.inventaire["loft"] = true
            infos:feedback( "Loft debloque" )
        end
    end
    
    -- Active/Désactive le godmode (invincibilité)
    function cheats:gmCheat()
        _G.cheats.gm = not _G.cheats.gm
        if _G.cheats.gm == true then
            infos:feedback( "Godmode desactive" )
        else 
            infos:feedback( "Godmode active" )
        end
    end

    return cheats
end

function Cheats:counter()

    if self.onOff == false then
        if counter == nil then
            counter = timer.performWithDelay(delay, function(e) self:unlock(e) end)
        end
        self.numTaps = self.numTaps + 1
        print(self.numTaps, self.onOff)
    end

end

function Cheats:unlock(e)

    if self.numTaps == tapCount then
        telephone = _G.infos.getTelephone()
        telephone.unlockCheats()
        infos:feedback( "Triches disponibles" )

        self.onOff = true
        print("cheats unlocked")
    else
        print("clear")
    end
    timer.cancel(counter)
    counter = nil
    self.numTaps = 0

end

return Cheats