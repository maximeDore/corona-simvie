-----------------------------------------------------------------------------------------
--
-- cTelephone.lua
--
-----------------------------------------------------------------------------------------
local Telephone = {}
local cBouton = require("cBouton")

function Telephone:init( parent, perso, jeu )

    local posUp = display.contentHeight-display.screenOriginY-250
    local posDown = display.contentHeight-display.screenOriginY+210

    local cDonnees = require("cDonnees")

    local telephone = display.newGroup()
    local screenSave = display.newGroup()
    local screenStats = display.newGroup()
    local screenContacts = display.newGroup()
    local screenBanque = display.newGroup()
    local screenInventaire = display.newGroup()
    local screenAlertes = display.newGroup()
    local screenMenu = display.newGroup()
    local screenHome = display.newGroup()
    local alertContent
    local bgAlerteContenu
    local contenuAlerte
    local contenuAlerteTexte
    local btRetour
    local phone
    local tapZone
    local btHome
    local bgMenu
    local btScooter
    local btVoiture
    local aptitudesNum
    local carriereDisplay
    local fondEnergie
    local energieDisplay
    local barreEnergie
    local balanceDisplay
    local interetDisplay
    local screenMask = graphics.newMask( "screen.png" )
    
    function telephone:init()
        -- Monter/descendre le téléphone
        local function toggleTelephone()
            if self.y >= display.contentHeight-display.screenOriginY+125 then
                transition.to( self, { time = 500, y = posUp, transition=easing.outQuart } )
            elseif self.y <= display.contentHeight-display.screenOriginY-100 then
                transition.to( self, { time = 500, y = posDown, transition=easing.outQuart } )
            end
        end

        -- Affichage des écrans d'application
        local function afficherHome()
            screenHome.isVisible = true
            screenContacts.isVisible = false
            screenStats.isVisible = false
            screenInventaire.isVisible = false
            screenBanque.isVisible = false
            screenMenu.isVisible = false
            screenAlertes.isVisible = false
            screenMenu.isVisible = false
            screenSave.isVisible = false
        end
        local function afficherStats()
            screenHome.isVisible = false
            screenStats.isVisible = true
        end
        local function afficherContacts()
            screenHome.isVisible = false
            screenContacts.isVisible = true
        end
        local function afficherAlertes()
            screenHome.isVisible = false
            screenAlertes.isVisible = true
        end
        local function afficherInventaire()
            screenHome.isVisible = false
            screenInventaire.isVisible = true
        end
        local function afficherBanque()
            screenHome.isVisible = false
            screenBanque.isVisible = true
        end
        local function afficherMenu()
            screenHome.isVisible = false
            screenMenu.isVisible = true
        end
        local function save()
            print("Partie sauvegardée")
            donnees:prepForSave( perso, _G.infos )
            afficherHome()
        end
        local function afficherSave()
            screenHome.isVisible = false
            screenSave.isVisible = true
        end
        local function mute()
            if audio.pause() > 0 then
                audio.pause( 1 )
            else
                audio.resume( 1 )
            end
        end

        local function transport( vehicule )
            print(vehicule)
            perso:changerVehicule( vehicule )
        end

        local function quitter()
            jeu:kill()
        end

        local function afficherAlerte( indexAlerte )
            local index = indexAlerte
            for i=1,alertContent.numChildren do
                if alertContent[i].type == "bouton" then
                    alertContent[i]:disable()
                end
            end
            bgAlerteContenu.type = "content"
            transition.to( bgAlerteContenu, { time = 500, x = 0, transition=easing.outQuart } )
            transition.to( contenuAlerte, { time = 500, x = 0, transition=easing.outQuart } )
            transition.to( contenuAlerteTexte, { time = 500, x = 0, transition=easing.outQuart } )
            btRetour.isVisible = true
        end

        local function cacherAlerte()
            for i=1,alertContent.numChildren do
                if alertContent[i].type == "bouton" then
                    alertContent[i]:enable()
                end
            end
            transition.to( bgAlerteContenu, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
            transition.to( contenuAlerte, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
            transition.to( contenuAlerteTexte, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
            btRetour.isVisible = false
        end

        phone = display.newImage( self, "telephone.png" )
        -- Zone de contact dans le haut du téléphone où il faut taper pour le monter/descendre
        -- tapZone = display.newRect( self, 0, -phone.height/2.25, phone.width, phone.height/6 )
        tapZone = cBouton:init( nil, nil, 0, -phone.height/2.25, toggleTelephone, nil, phone.width, phone.height/6 )
        self:insert(tapZone)

        -- Fonds des différents écrans
        local bgAlertes = display.newImage( screenAlertes, "screenAlertes.png", 0, -10.5 )
        local bgContacts = display.newImage( screenContacts, "screenContacts.png", 0, -10.5 )
        local bgStats = display.newImage( screenStats, "screenStats.png", 0, -10.5 )
        local bgBanque = display.newImage( screenBanque, "screenBanque.png", 0, -10.5 )
        local bgSave = display.newImage( screenSave, "screenSave.png", 0, -10.5 )
        bgMenu = display.newImage( screenMenu, "screenMenu.png", 0, -10.5 ) -- Globale à la classe pour référence

        -- bgAlertes:setMask( screenMask )

        -- Bouton physique du téléphone (home button)
        local btHome = cBouton:init( "", nil, 0, bgStats.height/1.8, afficherHome, nil, 75, 50 )

        -- Boutons de l'écran d'accueil
        -- Disposition :
        -- BtStats  btContacts  btAlertes
        -- btInventaire    btBanque    btMute
        -- btSave   btMenu
        -- btMarche btScooter   btVoiture
        local btStats = cBouton:init( "btStats.png", nil, -bgStats.width/3.25, -bgStats.height*.35, afficherStats )
        local btContacts = cBouton:init( "btContacts.png", nil, 0, -bgStats.height*.35, afficherContacts )
        local btAlertes = cBouton:init( "btAlertes.png", nil, bgStats.width/3.25, -bgStats.height*.35, afficherAlertes )
        local btInventaire = cBouton:init( "btGps.png", nil, -bgStats.width/3.25, -bgStats.height*.15, afficherInventaire )
        local btBanque = cBouton:init( "btBanque.png", nil, 0, -bgStats.height*.15, afficherBanque )
        local btMute = cBouton:init( "btMute.png", nil, bgStats.width/3.25, -bgStats.height*.15, mute )
        local btSave = cBouton:init( "btSave.png", nil, -bgStats.width/3.25, bgStats.height*.05, afficherSave )
        local btMenu = cBouton:init( "btMenu.png", nil, 0, bgStats.height*.05, afficherMenu )

        -- Boutons de déplacement
        btMarche = cBouton:init( "btMarche.png", nil, -bgStats.width/3.25, bgStats.height*.35, transport, "marche" )
        btScooter = cBouton:init( "btScooter.png", nil, 0, bgStats.height*.35, transport, "scooter" )
        btVoiture = cBouton:init( "btAuto.png", nil, bgStats.width/3.25, bgStats.height*.35, transport, "voiture" )
        -- État des boutons de déplacement
        if table.indexOf( perso.inventaire, "scooter" ) then else
            btScooter:disable()
        end
        if table.indexOf( perso.inventaire, "voiture" ) then else
            btVoiture:disable()
        end
        self:updateBoutons()
        
        screenHome:insert(btStats)
        screenHome:insert(btContacts)
        screenHome:insert(btAlertes)
        screenHome:insert(btInventaire)
        screenHome:insert(btBanque)
        screenHome:insert(btMute)
        screenHome:insert(btSave)
        screenHome:insert(btMenu)
        screenHome:insert(btMarche)
        screenHome:insert(btScooter)
        screenHome:insert(btVoiture)

        -- Écran Statistiques   --------------------------------------------------------------------------------------------------------
        -- Affichage des points d'aptitudes
        local optionsAptitudesNum = {
            text = "",
            x = bgStats.width/3+5,
            y = bgStats.y-bgStats.height/6.5,
            width = 100,
            height = 100,
            font = "8-Bit Madness.ttf",
            fontSize = 40,
            align = "center"  -- Alignment parameter
        }
        aptitudesNum = display.newText( optionsAptitudesNum )
        aptitudesNum:setFillColor(1,0,0)
        screenStats:insert(aptitudesNum)

        -- Affichage de la carrière
        local optionsCarriere = {
            text = perso.carriere,
            y = bgStats.y+bgStats.height/12,
            width = 235,
            height = 50,
            font = "8-Bit Madness.ttf",
            fontSize = 30,
            align = "left"  -- Alignment parameter
        }
        carriereDisplay = display.newText( optionsCarriere )
        carriereDisplay:setFillColor(1,0,0)
        screenStats:insert(carriereDisplay)

        -- Affichage de la barre d'énergie
        local optionsEnergie = {
            text = perso.energie.." %",
            y = bgStats.height/2.45,
            width = 200,
            height = 100,
            font = "8-Bit Madness.ttf",
            fontSize = 40,
            align = "center"  -- Alignment parameter
        }
        energieDisplay = display.newText( optionsEnergie )
        screenStats:insert(energieDisplay)

        -- Barre d'énergie
        fondEnergie = display.newRect( screenStats, 0, bgStats.height/2.15-25, bgStats.width-20, 35 )
        fondEnergie.fill = { .1, .1, .1 }
        barreEnergie = display.newRect( screenStats, fondEnergie.x, fondEnergie.y, fondEnergie.width-10, fondEnergie.height-10 )
        barreEnergie.fill = { 0, 1, 0 }


        -- Écran Menu           --------------------------------------------------------------------------------------------------------
        btOui = cBouton:init( "btOui.png", nil, -bgMenu.width/4.15, 0, quitter )
        btNon = cBouton:init( "btNon.png", nil, bgMenu.width/4.25, 0, afficherHome )
        screenMenu:insert(btOui)
        screenMenu:insert(btNon)


        -- Écran Save           --------------------------------------------------------------------------------------------------------
        btOui = cBouton:init( "btOui.png", nil, -bgMenu.width/4.15, 0, save )
        btNon = cBouton:init( "btNon.png", nil, bgMenu.width/4.25, 0, afficherHome )
        screenSave:insert(btOui)
        screenSave:insert(btNon)


        -- Écran Banque         --------------------------------------------------------------------------------------------------------
        local optionsBalance = {
            text = perso.banque.." $",
            x = bgMenu.width/2-110,
            y = -bgMenu.height*.075,
            width = 200,
            height = 100,
            font = "8-Bit Madness.ttf",
            fontSize = 40,
            align = "right"  -- Alignment parameter
        }
        balanceDisplay = display.newText( optionsBalance )
        balanceDisplay:setFillColor(0,0,.7)

        local optionsInteret = {
            text = parent:getInteret().." %",
            x = bgMenu.width/2-110,
            y = bgMenu.height*.135,
            width = 200,
            height = 100,
            font = "8-Bit Madness.ttf",
            fontSize = 40,
            align = "right"  -- Alignment parameter
        }
        interetDisplay = display.newText( optionsInteret )
        interetDisplay:setFillColor(0,0,.7)
        screenBanque:insert(balanceDisplay)
        screenBanque:insert(interetDisplay)


        -- Écran Alertes        --------------------------------------------------------------------------------------------------------
        alertContent = display.newContainer( screenAlertes, bgMenu.width, bgMenu.height )
        bgAlerteContenu = display.newImage( alertContent, "alertContent.png", bgMenu.width, 25 )
        contenuAlerte = display.newRect( alertContent, bgMenu.width, bgAlerteContenu.y, bgAlerteContenu.width*.9, bgAlerteContenu.height*.9 )
        contenuAlerte.alpha = 0.75

        btRetour = cBouton:init( "flecheRetour.png", nil, -bgMenu.width/2.5, -bgMenu.height/2.4, cacherAlerte )
        btRetour.isVisible = false
        alertContent:insert( btRetour )

        for i=1,4 do
            local alerteItem = cBouton:init( "alertItem.png", nil, 0, -bgMenu.height/3.85+((i-1)*69), afficherAlerte, i )
            alerteItem.type = "listItem"
            alerteItem:disable()
            alertContent:insert(alerteItem)
        end

        local optionsAlerte1 = {
            parent = alertContent,
            text = "texte",
            x = bgMenu.width,
            y = -bgMenu.height/2+245,
            width = bgMenu.width-40,
            height = 300,
            font = "8-Bit Madness.ttf",
            fontSize = 25,
            align = "left"  -- Alignment parameter
        }
        contenuAlerteTexte = display.newText( optionsAlerte1 )
        contenuAlerteTexte:setFillColor(0,0,0)



        screenContacts.isVisible = false
        screenStats.isVisible = false
        screenMenu.isVisible = false
        screenSave.isVisible = false
        screenAlertes.isVisible = false
        screenBanque.isVisible = false
        screenInventaire.isVisible = false


        self:insert(tapZone)
        self:insert(screenHome)
        self:insert(screenContacts)
        self:insert(screenStats)
        self:insert(screenAlertes)
        self:insert(screenBanque)
        self:insert(screenInventaire)
        self:insert(screenMenu)
        self:insert(screenSave)
        self:insert(btHome)

        self.x = display.contentWidth*.85-display.screenOriginX
        self.y = posDown
        parent:insert(self)
        self:updateStats()
        self:updateEnergie()
    end

    function telephone:updateBoutons()
        -- État des boutons de déplacement
        if table.indexOf( perso.inventaire, "scooter" ) then
            btScooter:enable()
        end
        if table.indexOf( perso.inventaire, "voiture" ) then
            btVoiture:enable()
        end
    end

    function telephone:updateStats()
        aptitudesNum.text = perso.forNum.."\n"..perso.intNum.."\n"..perso.chaNum
        carriereDisplay.text = parent:getEmploi().titre
    end

    function telephone:updateBanque()
        balanceDisplay.text = perso.banque.." $"
        interetDisplay.text = parent:getInteret() .. " %"
    end

    function telephone:updateEnergie()
        local maxWidth = fondEnergie.width-10
        energieDisplay.text = perso.energie.." %"
        barreEnergie.width = maxWidth*perso.energie/100
        barreEnergie.x = (barreEnergie.width - maxWidth)/2
        if perso.energie <= 10 then
            barreEnergie.fill = { 1, 0, 0 }
        elseif perso.energie <= 25 then
            barreEnergie.fill = { 1, .4, 0 }
        elseif perso.energie <= 50 then
            barreEnergie.fill = { 1, .8, 0 }
        elseif perso.energie > 50 then
            barreEnergie.fill = { 0, 1, 0 }
        end
    end

    function telephone:updateAlertes( nbAlertes, texte1, texte2 )
        local nb = nbAlertes
        if nb == nil then
            nb = 1
        end
        local cpt=0
        for i=1,alertContent.numChildren do
            if alertContent[i].type == "listItem" and cpt<nb then
                cpt = cpt + 1
                alertContent[i]:enable()
                alertContent[i].type = "bouton"
            end
        end
        bgAlerteContenu:toFront()
        btRetour:toFront()
        contenuAlerte:toFront()
        contenuAlerteTexte:toFront()
    end
    
    function telephone:kill()
    end
    
    telephone:init()
    return telephone
end

return Telephone