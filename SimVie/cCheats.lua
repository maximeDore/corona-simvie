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
    self.drawMode = "normal"
    local cheats = {}

    -- Ajoute/retire les véhicules de l'inventaire
    function cheats:vehiclesCheat()
        perso.inventaire["voiture"] = not perso.inventaire["voiture"]
        perso.inventaire["scooter"] = not perso.inventaire["scooter"]
        if perso.inventaire["voiture"] and perso.inventaire["scooter"] then
            infos:feedback( "Vehicules debloque" )
        else
            infos:feedback( "Vehicules bloque" )
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
        perso.inventaire["loft"] = not perso.inventaire["loft"]
        if perso.inventaire["loft"] then
            infos:feedback( "Loft debloque" )
        else
            infos:feedback( "Loft bloque" )
        end
    end
    
    -- Active/Désactive le godmode (invincibilité)
    function cheats:gmCheat()
        Cheats.gm = not Cheats.gm
        if Cheats.gm then
            infos:feedback( "Godmode active" )
        else 
            infos:feedback( "Godmode desactive" )
        end
    end
    
    -- Active/Désactive l'affichage des hitboxes
    function cheats:hbCheat()
        print(self.drawMode, Cheats.drawMode, Cheats.drawMode)
        if Cheats.drawMode == "normal" then
            Cheats.drawMode = "hybrid"
            physics.setDrawMode("hybrid")
        -- elseif Cheats.drawMode == "hybrid" then
        --     Cheats.drawMode = "debug"
        --     physics.setDrawMode("debug")
        else 
            Cheats.drawMode = "normal"
            physics.setDrawMode("normal")
        end
        infos:feedback( "physics.setDrawMode = "..Cheats.drawMode )
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