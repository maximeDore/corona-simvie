-----------------------------------------------------------------------------------------
--
-- cInfos.lua
--
----------------------------------------------------------------------------------------- 
local Infos = {}
function Infos:init( heureDepart, indexDepart, map, perso )

    local infos = display.newGroup()
    local cTelephone = require("cTelephone")
    local hebdo = { "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" }
    local rightMarg = display.contentWidth - display.screenOriginX
    local heure = heureDepart
    local jourIndex = indexDepart
    local jour = hebdo[jourIndex]
    local emploiIndex = 1
    local emploi
    local cadran
    local jourDisplay
    local moneyDisplay
    local telephone

    local tEmplois = {
        sports = {
            { titre="Porteur d'eau", apt=20 }, { titre="Rechauffe-banc", apt=50 }, { titre="Joueur remplacant", apt=90 }, { titre="Squatteur de gym", apt=150 }, { titre="Athlete", apt=225 }, { titre="Maigre culturiste", apt=315 }, { titre="Culturiste", apt=400 }, { titre="Athlete professionnel", apt=500 }, { titre="Athlete sur steroides", apt=650 }, { titre="Champion du monde", apt=800 }
        },
        sciences = {
            { titre="Nerd", apt=20 }, { titre="Etudiant", apt=50 }, { titre="Finissant en microbiologie", apt=90 }, { titre="Assistant en laboratoire", apt=150 }, { titre="Chercheur meconnu", apt=225 }, { titre="Scientifique sans bourse", apt=315 }, { titre="Scientifique peu connu", apt=400 }, { titre="Scientifique fou", apt=500 }, { titre="Professeur d'universite", apt=650 }, { titre="Recipiendaire de prix Nobel", apt=800 }
        }
    }

    function infos:init()
        -- Accéder au nom de l'emploi actuel et au prochain objectif d'aptitude pour la promotion
        emploi = tEmplois[perso.carriere][emploiIndex]
        print(emploi.titre)

        telephone = cTelephone:init( self, perso )

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
        local optionsMoneyDisplay = {text = perso.money .. " $", width = 256, x = rightMarg-150, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "right"}
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

    function infos:updateHeure(nb)
        if nb ~= nil then
            if heure+nb >= 24 then
                heure = nb+heure-24
            else
                heure = heure + nb
            end
        end
        cadran.text = heure..":00"
        if heure==24 then
            heure = 0
            cadran.text = "00:00"
        end
        map:assombrir(heure)
    end
    
    function infos:updateMoney()
        moneyDisplay.text = perso.money.." $"
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
        emploi = tEmplois[perso.carriere][emploiIndex]
        print(emploi.titre)
    end

    function infos:updateStats()
        telephone:updateStats()
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