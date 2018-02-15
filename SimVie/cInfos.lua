-----------------------------------------------------------------------------------------
--
-- cInfos.lua
--
----------------------------------------------------------------------------------------- 
local Infos = {}
function Infos:init( heureDepart, indexDepart, map )

    local infos = display.newGroup()
    local hebdo = { "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" }
    local rightMarg = display.contentWidth - display.screenOriginX
    local heure = heureDepart
    local jourIndex = indexDepart
    local jour = hebdo[jourIndex]
    local cadran
    local jourDisplay
    local money = 100

    function infos:init()
        -- Affichage de la barre du haut
        local barre = display.newRect( self, display.screenOriginX, 0, display.contentWidth*3, 100 )
        local degrade = {
            type = "gradient",
            color1 = { .5, .1, .1 },
            color2 = { .4, .3, .3 },
            direction = "up"
        }
        barre.fill = degrade

        -- Affichage du jour
        local optionsJourDisplay = {text = hebdo[jourIndex], width = 256, x = display.screenOriginX+150, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "left"}
        jourDisplay = display.newText(optionsJourDisplay)

        -- Affichage de l'heure
        local optionsCadran = {text = "", width = 256, x = display.contentCenterX, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "center"}
        cadran = display.newText(optionsCadran)

        -- Affichage de l'argent
        local optionsMoneyDisplay = {text = money .. " $", width = 256, x = rightMarg-150, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "right"}
        moneyDisplay = display.newText(optionsMoneyDisplay)

        self:update()
    end 

    function infos:getHeure()
        return heure
    end

    function infos:getJour()
        return jour
    end

    function infos:getMoney()
        return money
    end
    function infos:setMoney( valeur )
        money = money + valeur
        moneyDisplay.text = money.." $"
    end

    function infos:update(nb)
        if nb ~= nil then
            heure = heure + nb
        end
        cadran.text = heure..":00"
        if heure==24 then
            cadran.text = "00:00"
        end
        map:assombrir(heure)
    end

    function infos:reset()
        heure = heureDepart
        if jourIndex == 7 then
            jourIndex = 1
        else
            jourIndex = jourIndex + 1
        end
        jourDisplay.text = hebdo[jourIndex]
        self:update()
    end

    infos:init()
    return infos

end

return Infos