-----------------------------------------------------------------------------------------
--
-- cInfos.lua
--
----------------------------------------------------------------------------------------- 
local Infos = {}
function Infos:init( heureDepart, indexDepart, map, perso, jeu )

    local infos = display.newGroup()
    local cTelephone = require("cTelephone")
    local cEvenement = require("cEvenement")
    local cContacts = require("cContacts")
    local hebdo = { "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" }
    local rightMarg = display.contentWidth - display.screenOriginX
    local heure = heureDepart
    local jourIndex = indexDepart
    local cptJours = 1
    local contacts
    local emploiIndex = 1
    local emploi
    local heureDisplay
    local jourDisplay
    local moneyDisplay
    local telephone
    local interet
    local notification
    local evenementDuJour = {}

    local tEmplois = {
        sports = {
            { titre="Porteur d'eau", apt=20 }, { titre="Rechauffe-banc", apt=50 }, { titre="Joueur remplacant", apt=90 }, { titre="Squatteur de gym", apt=150 }, { titre="Athlete", apt=225 }, { titre="Maigre culturiste", apt=315 }, { titre="Culturiste", apt=400 }, { titre="Athlete professionnel", apt=500 }, { titre="Athlete sur steroides", apt=650 }, { titre="Champion du monde", apt=800 }
        },
        sciences = {
            { titre="Nerd", apt=20 }, { titre="Etudiant", apt=50 }, { titre="Finissant en chimie", apt=90 }, { titre="Assistant en laboratoire", apt=150 }, { titre="Chercheur meconnu", apt=225 }, { titre="Scientifique sans budget", apt=315 }, { titre="Chimiste douteux", apt=400 }, { titre="Professeur d'universite", apt=500 }, { titre="Scientifique fou", apt=650 }, { titre="Recipiendaire de prix Nobel", apt=800 }
        }
    }

    function infos:init()
        
        -- Initialisation des contacts
        contacts = cContacts:init()
        
        -- Chargement des données si partie chargée
        if _G.data then
            heure = _G.data.heure
            emploiIndex = _G.data.emploiIndex
            jourIndex = _G.data.jourIndex
            cptJours = _G.data.cptJours
            interet = _G.data.interet
            evenementDuJour = _G.data.evenement
            _G.data = nil
        end
        if interet == nil then
            interet = math.random( 4, 7 )/100
        end

        -- Accéder au nom de l'emploi actuel et au prochain objectif d'aptitude pour la promotion
        if emploiIndex<=10 then
            emploi = tEmplois[perso.carriere][emploiIndex]
        else
            emploi = tEmplois[perso.carriere][10]
        end

        telephone = cTelephone:init( self, perso, jeu )

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
        local optionsJourDisplay = {text = hebdo[jourIndex].." - jour "..cptJours, width = 500, x = display.screenOriginX+270, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "left"}
        jourDisplay = display.newText(optionsJourDisplay)

        -- Affichage de l'heure
        local optionsheureDisplay = {text = "", width = 256, x = display.contentCenterX, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "center"}
        heureDisplay = display.newText(optionsheureDisplay)

        -- Affichage de l'argent
        local optionsMoneyDisplay = {text = perso.money .. " $", width = 256, x = rightMarg-200, y = 25, font = "8-Bit Madness.ttf", fontSize = 50, align = "right"}
        moneyDisplay = display.newText(optionsMoneyDisplay)

        notification = display.newImageRect( "bell.png", 30, 30 )
        notification.x = rightMarg - notification.width/2 - 25
        notification.y = 25

        self:insert(barre)
        self:insert(jourDisplay)
        self:insert(heureDisplay)
        self:insert(moneyDisplay)
        self:insert(notification)

        self:updateAlerte()
        self:updateHeure()
        telephone:updateAlertes( evenementDuJour )
    end

    ------ GETTERS  ------------------------------------------------------------------------------

    function infos:getHeure()
        return heure
    end
    function infos:getJourIndex()
        return jourIndex
    end
    function infos:getJour()
        jour = hebdo[jourIndex]
        return jour
    end
    function infos:getCptJours()
        return cptJours
    end
    function infos:getInteret()
        return interet*100
    end

    function infos:getContacts()
        return contacts
    end
    function infos:getEvenement()
        if evenementDuJour == {} or not evenementDuJour or #evenementDuJour == 0 then
            return nil
        else
            return evenementDuJour
        end
    end

    function infos:getEmploi()
        return emploi
    end
    function infos:getEmploiIndex()
        return emploiIndex
    end
    
    ------ UPDATES  ------------------------------------------------------------------------------

    function infos:updateHeure(nb)
        if nb ~= nil then
            if heure+nb >= 24 then
                -- Appel de l'événement du jour
                evenementDuJour = cEvenement:init( perso.chaNum )
                telephone:updateAlertes( evenementDuJour )
                -- Mise à jour de l'heure et du jour
                heure = nb+heure-24
                cptJours = cptJours + 1
                print("Jour "..cptJours)
                if jourIndex == 7 then
                    jourIndex = 1
                else
                    jourIndex = jourIndex + 1
                end
                self:updateBanque()
                self:updateContacts()
                if table.indexOf( perso.inventaire, "loft" ) == nil then
                    self:updateLoyer( 5 )
                end
                jourDisplay.text = hebdo[jourIndex].." - jour "..cptJours
            else
                heure = heure + nb
            end
        end
        heureDisplay.text = heure..":00"
        if heure==24 then
            heure = 0
            heureDisplay.text = "00:00"
        end
        map:assombrir(heure)
        perso:assombrir(heure)
    end

    -- Mise à jour de l'icône d'alerte dans le coin supérieur droit
    function infos:updateAlerte( on )
        if on then
            notification:setFillColor( display.getDefault( "fillColor" ) )
        else
            notification:setFillColor( black, 0.5 )
        end
    end

    -- Mise à jour quotidienne des contacts
    function infos:updateContacts()
        local rand
        local rand1
        local rand2
        for i=1,#contacts do
            if perso.carriere == "sciences" then
                rand2 = math.random( 4, 12 )
                rand1 = math.random( 4 )
            else
                rand1 = math.random( 4, 12 )
                rand2 = math.random( 4 )
            end
            print(i.." "..rand1, rand2 )
            contacts[i].forNum = contacts[i].forNum + rand1
            contacts[i].intNum = contacts[i].intNum + rand2
        end
        telephone:updateContacts()
    end
    
    -- Mise à jour de l'affichage des informations dans le téléphone
    function infos:updateMoney()
        moneyDisplay.text = perso.money.." $"
        telephone:updateBanque()
    end
    function infos:updateStats()
        telephone:updateStats()
    end
    function infos:updateEnergie()
        telephone:updateEnergie()
    end
    function infos:updateInventaire()
        telephone:updateInventaire()
    end
    function infos:updateBanque()
        perso.banque = math.round( perso.banque + perso.banque*interet )
        interet = math.random( 4, 7 )/100
        telephone:updateBanque()
    end
    function infos:updateLoyer( coutLoyer )
        local loyer = coutLoyer
        if perso.money-loyer < 0 then
            loyer = coutLoyer - perso.money
            perso:setMoney(-coutLoyer+loyer)
            perso:setBanque(-loyer)
        else
            perso:setMoney(-loyer)
        end
        self:updateMoney()
    end

    function infos:updateBoutons()
        telephone:updateBoutons()
    end
    
    function infos:promotion()
        if tEmplois[perso.carriere][emploiIndex] ~= nil then 
            emploiIndex = emploiIndex + 1
            emploi = tEmplois[perso.carriere][emploiIndex]
        end
        self.updateStats()
    end

    infos:init()
    return infos

end

return Infos