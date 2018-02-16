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
    local emploiIndex = 1
    local emploi
    local cadran
    local jourDisplay
    local money = 100

    local tEmplois = {
        sports = {
            { titre="Porteur d'eau", apt=20 }, { titre="Rechauffe-banc", apt=50 }, { titre="Joueur remplaçant", apt=90 }, { titre="Squatteur de gym", apt=150 }, { titre="Athlete", apt=225 }, {"Maigre culturiste", apt=315 }, {"Culturiste", apt=400 }, {"Athlete professionnel", apt=500 }, { titre="Athlete sur steroides", apt=650 }, { titre="Champion du monde", apt=800 }
        },
        sciences = {
            { titre="Nerd", apt=20 }, { titre="Etudiant", apt=50 }, { titre="Finissant en microbiologie", apt=90 }, { titre="Assistant en laboratoire", apt=150 }, { titre="Chercheur meconnu", apt=225 }, { titre="Scientifique sans bourse", apt=315 }, { titre="Scientifique peu connu", apt=400 }, { titre="Scientifique fou", apt=500 }, { titre="Professeur d'universite", apt=650 }, { titre="Recipiendaire de prix Nobel", apt=800 }
        }
    }

    function infos:init()

        emploi = tEmplois[_G.carriere][emploiIndex]
        print(emploi.titre)

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

        self:updateHeure()
    end 

    function infos:getHeure()
        return heure
    end

    function infos:getJour()
        jour = hebdo[jourIndex]
        return jour
    end

    function infos:getMoney()
        return money
    end
    function infos:setMoney( valeur )
        money = money + valeur
        moneyDisplay.text = money.." $"
    end

    function infos:updateHeure(nb)
        if nb ~= nil then
            heure = heure + nb
        end
        cadran.text = heure..":00"
        if heure==24 then
            heure = 0
            cadran.text = "00:00"
        end
        map:assombrir(heure)
    end

    function infos:prochainJour(h)
        if jourIndex == 7 then
            jourIndex = 1
        else
            jourIndex = jourIndex + 1
        end
        jourDisplay.text = hebdo[jourIndex]
        self:updateHeure(h)
    end

    function infos:promotion()
        emploiIndex = emploiIndex + 1
        emploi = tEmplois[_G.carriere][emploiIndex]
        print(emploi.titre)
    end

    function infos:getEmploi()
        return emploi
    end
    function infos:getEmploiIndex()
        return emploiIndex
    end

    infos:init()
    return infos

end

return Infos