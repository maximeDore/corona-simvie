-----------------------------------------------------------------------------------------
--
-- cTelephone.lua
--
-- Classe qui génère un téléphone avec plusieurs applications/écrans
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
    local screenCheats = display.newGroup()
    local btCheats
    local contacts
    local contactDisplay1
    local contactDisplay2
    local alertes = {}
    local alertContent
    local bgAlerteContenu
    local contenuAlerte
    local contenuAlerteTexte
    local contenuAlerteTexte2
    local btRetour
    local nbCafe
    local nbBarre
    local nbBoisson
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
    local screenMask = graphics.newMask( "ressources/img/screen.png" )
    
    -- Constructeur, génère toutes les applications/écrans du téléphone ainsi que ses boutons avec leur fonction assignées
    function telephone:init()

        local cCheats = require("cCheats")

        local function listener(e)
            cCheats:unlock(perso)
        end

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
            screenCheats.isVisible = false
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
        local function afficherCheats()
            screenHome.isVisible = false
            screenCheats.isVisible = true
        end
        -- Sauvegarde la partie
        local function save()
            print("Partie sauvegardée")
            _G.infos:feedback( "Partie sauvegardee avec succes" )
            donnees:prepForSave( perso, _G.infos )
            afficherHome()
        end
        local function afficherSave()
            screenHome.isVisible = false
            screenSave.isVisible = true
        end
        -- Met la musique d'ambiance en sourdine
        local function mute()
            toggleTelephone()
            if audio.pause() > 0 then
                audio.pause( 1 )
                _G.infos:feedback( "Musique en sourdine" )
            else
                audio.resume( 1 )
                _G.infos:feedback( "Musique retablie" )
            end
        end

        -- Changer de véhicule
        local function transport( vehicule )
            print(vehicule)
            if vehicule ~= perso.vehiculeActif then
                toggleTelephone()
                perso:changerVehicule( vehicule )
            end
        end

        -- Quitter le jeu
        local function quitter()
            jeu:kill()
        end

        -- Afficher la page d'une alerte 
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
            if index==1 then
                transition.to( contenuAlerteTexte, { time = 500, x = 0, transition=easing.outQuart } )
            elseif index==2 then
                transition.to( contenuAlerteTexte2, { time = 500, x = 0, transition=easing.outQuart } )
            end
            btRetour.isVisible = true
        end

        -- Revenir sur la page d'accueil des alertes
        local function cacherAlerte()
            for i=1,alertContent.numChildren do
                if alertContent[i].type == "bouton" then
                    alertContent[i]:enable()
                end
            end
            transition.to( bgAlerteContenu, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
            transition.to( contenuAlerte, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
            transition.to( contenuAlerteTexte, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
            transition.to( contenuAlerteTexte2, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
            btRetour.isVisible = false
        end

        -- Demande au personnage de consommer l'aliment passé en paramètre
        local function consommer( aliment )
            perso:consommer(aliment)
        end

        contacts = parent.getContacts()
        phone = display.newImage( self, "ressources/img/telephone.png" )
        -- Zone de contact dans le haut du téléphone où il faut taper pour le monter/descendre
        tapZone = cBouton:init( nil, nil, 0, -phone.height/2.25, toggleTelephone, nil, phone.width, phone.height/6 )
        self:insert(tapZone)

        -- Fonds des différents écrans
        local bgAlertes = display.newImage( screenAlertes, "ressources/img/screenAlertes.png", 0, -10.5 )
        local bgInventaire = display.newImage( screenInventaire, "ressources/img/screenInventaire.png", 0, -10.5 )
        local bgContacts = display.newImage( screenContacts, "ressources/img/screenContacts.png", 0, -10.5 )
        local bgStats = display.newImage( screenStats, "ressources/img/screenStats.png", 0, -10.5 )
        local bgBanque = display.newImage( screenBanque, "ressources/img/screenBanque.png", 0, -10.5 )
        local bgSave = display.newImage( screenSave, "ressources/img/screenSave.png", 0, -10.5 )
        local bgCheats = display.newImage( screenCheats, "ressources/img/screen.png", 0, -10.5 )
        bgMenu = display.newImage( screenMenu, "ressources/img/screenMenu.png", 0, -10.5 ) -- Globale à la classe pour référence

        -- bgAlertes:setMask( screenMask )

        -- Bouton physique du téléphone (home button)
        local function homeListener(e) cCheats:counter() end
        local btHome = cBouton:init( "", nil, 0, bgStats.height/1.8, afficherHome, nil, 75, 50 )
        btHome:addEventListener( "tap", homeListener )

        -- Boutons de l'écran d'accueil
        -- Disposition :
        -- BtStats          btContacts      btAlertes
        -- btInventaire     btBanque        btMute
        -- btSave           btMenu          (btCheats)
        -- btMarche         btScooter       btVoiture
        local btStats = cBouton:init( "ressources/img/btStats.png", nil, -bgStats.width/3.25, -bgStats.height*.35, afficherStats )
        local btContacts = cBouton:init( "ressources/img/btContacts.png", nil, 0, -bgStats.height*.35, afficherContacts )
        local btAlertes = cBouton:init( "ressources/img/btAlertes.png", nil, bgStats.width/3.25, -bgStats.height*.35, afficherAlertes )
        local btInventaire = cBouton:init( "ressources/img/btInventaire.png", nil, -bgStats.width/3.25, -bgStats.height*.15, afficherInventaire )
        local btBanque = cBouton:init( "ressources/img/btBanque.png", nil, 0, -bgStats.height*.15, afficherBanque )
        local btMute = cBouton:init( "ressources/img/btMute.png", nil, bgStats.width/3.25, -bgStats.height*.15, mute )
        local btSave = cBouton:init( "ressources/img/btSave.png", nil, -bgStats.width/3.25, bgStats.height*.05, afficherSave )
        local btMenu = cBouton:init( "ressources/img/btMenu.png", nil, 0, bgStats.height*.05, afficherMenu )
        btCheats = cBouton:init( "ressources/img/btCheats.png", nil, bgStats.width/3.25, bgStats.height*.05, afficherCheats )

        btCheats.isVisible = false

        -- Boutons de déplacement
        btMarche = cBouton:init( "ressources/img/btMarche.png", nil, -bgStats.width/3.25, bgStats.height*.35, transport, "marche" )
        btScooter = cBouton:init( "ressources/img/btScooter.png", nil, 0, bgStats.height*.35, transport, "scooter" )
        btVoiture = cBouton:init( "ressources/img/btAuto.png", nil, bgStats.width/3.25, bgStats.height*.35, transport, "voiture" )
        -- État des boutons de déplacement
        btScooter:disable()
        btVoiture:disable()
        
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
        screenHome:insert(btCheats)

---------- Écran Statistiques   --------------------------------------------------------------------------------------------------------
        
        -- Affichage des points d'aptitudes
        local optionsAptitudesNum = {
            text = "",
            x = bgStats.width/3+5,
            y = bgStats.y-bgStats.height/6.5,
            width = 100,
            height = 100,
            font = "ressources/fonts/8-Bit Madness.ttf",
            fontSize = 40,
            align = "center"  -- Alignment parameter
        }
        aptitudesNum = display.newText( optionsAptitudesNum )
        aptitudesNum:setFillColor(0,0,0)
        screenStats:insert(aptitudesNum)

        -- Affichage de la carrière
        local optionsCarriere = {
            text = perso.carriere:upper(),
            y = bgStats.y+bgStats.height/12,
            width = 235,
            height = 50,
            font = "ressources/fonts/8-Bit Madness.ttf",
            fontSize = 30,
            align = "center"  -- Alignment parameter
        }
        carriereDisplay = display.newText( optionsCarriere )
        carriereDisplay:setFillColor(0,0,0)
        screenStats:insert(carriereDisplay)
        screenStats:insert(aptitudesNum)
        
        emploiDisplay = display.newText( optionsCarriere )
        emploiDisplay.y = emploiDisplay.y + 30
        emploiDisplay:setFillColor(0,0,0)
        screenStats:insert(emploiDisplay)

        -- Affichage de la barre d'énergie
        local optionsEnergie = {
            text = perso.energie.." %",
            y = bgStats.height/2.45,
            width = 200,
            height = 100,
            font = "ressources/fonts/8-Bit Madness.ttf",
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


---------- Écran Contacts       --------------------------------------------------------------------------------------------------------

        -- Options d'affichage des contacts
        local optionsContactNom = {
            text = contacts[1].nom,
            x = bgStats.width/12,
            y = bgStats.y-bgStats.height/4.5,
            width = 175,
            height = 50,
            font = "ressources/fonts/8-Bit Madness.ttf",
            fontSize = 30,
            align = "left"  -- Alignment parameter
        }
        contactDisplayName1 = display.newText( optionsContactNom )
        contactDisplayName2 = display.newText( optionsContactNom )
        contactDisplayName2.text = contacts[2].nom
        contactDisplayName2.y = bgStats.y+bgStats.height/12
        
        contactApt1 = display.newText( optionsAptitudesNum )
        contactApt1.y = contactDisplayName1.y + 60
        contactApt2 = display.newText( optionsAptitudesNum )
        contactApt2.y = contactDisplayName2.y + 60

        contactDisplayName1:setFillColor(0,0,0)
        contactDisplayName2:setFillColor(0,0,0)
        contactApt1:setFillColor(0,0,0)
        contactApt2:setFillColor(0,0,0)

        screenContacts:insert(contactDisplayName1)
        screenContacts:insert(contactDisplayName2)
        screenContacts:insert(contactApt1)
        screenContacts:insert(contactApt2)
        self:updateContacts()
        

---------- Écran Menu           --------------------------------------------------------------------------------------------------------

        btOui = cBouton:init( "ressources/img/btOui.png", nil, -bgMenu.width/4.15, 0, quitter )
        btNon = cBouton:init( "ressources/img/btNon.png", nil, bgMenu.width/4.25, 0, afficherHome )
        screenMenu:insert(btOui)
        screenMenu:insert(btNon)


---------- Écran Save           --------------------------------------------------------------------------------------------------------

        btOui = cBouton:init( "ressources/img/btOui.png", nil, -bgMenu.width/4.15, 0, save )
        btNon = cBouton:init( "ressources/img/btNon.png", nil, bgMenu.width/4.25, 0, afficherHome )
        screenSave:insert(btOui)
        screenSave:insert(btNon)


---------- Écran Banque         --------------------------------------------------------------------------------------------------------

        local optionsBalance = {
            text = perso.banque.." $",
            x = bgMenu.width/2-110,
            y = -bgMenu.height*.075,
            width = 200,
            height = 100,
            font = "ressources/fonts/8-Bit Madness.ttf",
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
            font = "ressources/fonts/8-Bit Madness.ttf",
            fontSize = 40,
            align = "right"  -- Alignment parameter
        }
        interetDisplay = display.newText( optionsInteret )
        interetDisplay:setFillColor(0,0,.7)
        screenBanque:insert(balanceDisplay)
        screenBanque:insert(interetDisplay)


---------- Écran Alertes        --------------------------------------------------------------------------------------------------------

        alertContent = display.newContainer( screenAlertes, bgMenu.width, bgMenu.height )
        bgAlerteContenu = display.newImage( alertContent, "ressources/img/alertContent.png", bgMenu.width, 25 )
        contenuAlerte = display.newRect( alertContent, bgMenu.width, bgAlerteContenu.y, bgAlerteContenu.width*.9, bgAlerteContenu.height*.9 )
        contenuAlerte.alpha = 0.75

        btRetour = cBouton:init( "ressources/img/flecheRetour.png", nil, -bgMenu.width/2.5, -bgMenu.height/2.4, cacherAlerte )
        btRetour.isVisible = false
        alertContent:insert( btRetour )

        for i=1,4 do
            local alerteItem = cBouton:init( "ressources/img/alertItem.png", nil, 0, -bgMenu.height/3.85+((i-1)*69), afficherAlerte, i )
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
            font = "ressources/fonts/8-Bit Madness.ttf",
            fontSize = 25,
            align = "left"  -- Alignment parameter
        }
        contenuAlerteTexte = display.newText( optionsAlerte1 )
        contenuAlerteTexte:setFillColor(0,0,0)
        contenuAlerteTexte2 = display.newText( optionsAlerte1 )
        contenuAlerteTexte2:setFillColor(0,0,0)
        screenBanque:insert(interetDisplay)


---------- Écran Inventaire     --------------------------------------------------------------------------------------------------------

        local cafeItem = cBouton:init( "ressources/img/itemCafe.png", nil, 0, -bgInventaire.height/3.85, consommer, "cafe" )
        local barreItem = cBouton:init( "ressources/img/itemBarre.png", nil, 0, -bgInventaire.height/3.85+69, consommer, "barreNrg" )
        local boissonItem = cBouton:init( "ressources/img/itemBoisson.png", nil, 0, -bgInventaire.height/3.85+138, consommer, "boissonNrg" )

        screenInventaire:insert(cafeItem)
        screenInventaire:insert(barreItem)
        screenInventaire:insert(boissonItem)

        local optionsItem = {
            parent = screenInventaire,
            text = "0/5",
            x = bgInventaire.width/2-30,
            y = -bgInventaire.height/3.65,
            width = 50,
            height = 25,
            font = "ressources/fonts/8-Bit Madness.ttf",
            fontSize = 25,
            align = "right"  -- Alignment parameter
        }
        nbCafe = display.newText( optionsItem )
        nbCafe:setFillColor(0,0,0)
        nbBarre = display.newText( optionsItem )
        nbBarre.y = nbCafe.y + 69
        nbBarre:setFillColor(0,0,0)
        nbBoisson = display.newText( optionsItem )
        nbBoisson.y = nbBarre.y + 69
        nbBoisson:setFillColor(0,0,0)


---------- Écran Cheats     ------------------------------------------------------------------------------------------------------------

        local function moneyCheat()
            _G.cheats:money()
        end
        local function vehiclesCheat()
            _G.cheats:vehiclesCheat()
        end
        local function gmCheat()
            _G.cheats:gmCheat()
        end
        local function loftCheat()
            _G.cheats:loftCheat()
        end
        local function hbCheat()
            _G.cheats:hbCheat()
        end

        -- Boutons de l'écran d'accueil
        -- Disposition :
        -- btCash           btVehicules     btGm
        -- --               --              --
        -- --               --              --
        -- --               --              --
        local btCash = cBouton:init( "ressources/img/btBanque.png", nil, -bgStats.width/3.25, -bgStats.height*.35, moneyCheat )
        local btVehicules = cBouton:init( "ressources/img/btAuto.png", nil, 0, -bgStats.height*.35, vehiclesCheat )
        local btGm = cBouton:init( "ressources/img/btGodmode.png", nil, bgStats.width/3.25, -bgStats.height*.35, gmCheat )
        local btLoft = cBouton:init( "ressources/img/btMenu.png", nil, -bgStats.width/3.25, -bgStats.height*.15, loftCheat )
        -- local btBanque = cBouton:init( "ressources/img/btBanque.png", nil, 0, -bgStats.height*.15, afficherBanque )
        -- local btMute = cBouton:init( "ressources/img/btMute.png", nil, bgStats.width/3.25, -bgStats.height*.15, mute )
        -- local btSave = cBouton:init( "ressources/img/btSave.png", nil, -bgStats.width/3.25, bgStats.height*.05, afficherSave )
        -- local btMenu = cBouton:init( "ressources/img/btMenu.png", nil, 0, bgStats.height*.05, afficherMenu )
        local btHitbox = cBouton:init( "ressources/img/btHitbox.png", nil, bgStats.width/3.25, bgStats.height*.05, hbCheat )
        
        screenCheats:insert(btCash)
        screenCheats:insert(btVehicules)
        screenCheats:insert(btGm)
        screenCheats:insert(btLoft)
        -- screenCheats:insert(btBanque)
        -- screenCheats:insert(btMute)
        -- screenCheats:insert(btSave)
        -- screenCheats:insert(btMenu)
        -- screenCheats:insert(btMarche)
        -- screenCheats:insert(btScooter)
        -- screenCheats:insert(btVoiture)
        screenCheats:insert(btHitbox)

----------------------------------------------------------------------------------------------------------------------------------------

        -- Cacher les écrans par défaut
        screenContacts.isVisible = false
        screenStats.isVisible = false
        screenMenu.isVisible = false
        screenSave.isVisible = false
        screenAlertes.isVisible = false
        screenBanque.isVisible = false
        screenInventaire.isVisible = false
        screenCheats.isVisible = false

        -- Insertions dans le téléphone
        self:insert(tapZone)
        self:insert(screenHome)
        self:insert(screenContacts)
        self:insert(screenStats)
        self:insert(screenAlertes)
        self:insert(screenBanque)
        self:insert(screenInventaire)
        self:insert(screenMenu)
        self:insert(screenSave)
        self:insert(screenCheats)
        self:insert(btHome)

        self.x = display.contentWidth*.85-display.screenOriginX
        self.y = posDown
        parent:insert(self)
        self:updateStats()
        self:updateEnergie()
        self:updateInventaire()
        self:updateBoutons()
        

    end --init()
    

------ UPDATES  ------------------------------------------------------------------------------

    -- Active les boutons de véhicules s'ils sont dans l'inventaire
    function telephone:updateBoutons()
        -- État des boutons de déplacement
        if perso.inventaire["scooter"] then
            btScooter:enable()
        else
            btScooter:disable()
        end
        if perso.inventaire["voiture"] then
            btVoiture:enable()
        else
            btVoiture:disable()
        end
    end

    -- Met l'affichage des statistiques à jour
    function telephone:updateStats()
        aptitudesNum.text = perso.forNum.."\n"..perso.intNum.."\n"..perso.chaNum
        emploiDisplay.text = parent:getEmploi().titre
    end

    -- Met l'affichage des contacts à jour
    function telephone:updateContacts()
        contacts = parent.getContacts()
        contactApt1.text = contacts[1].forNum.."\n"..contacts[1].intNum
        contactApt2.text = contacts[2].forNum.."\n"..contacts[2].intNum
    end

    -- Met l'affichage de l'argent en banque à jour
    function telephone:updateBanque()
        balanceDisplay.text = perso.banque.." $"
        interetDisplay.text = parent:getInteret() .. " %"
    end

    -- Met l'affichage de l'énergie à jour
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

    -- Met l'affichage des alertes à jour
    function telephone:updateAlertes( tEvents )
        -- Fermer la page d'alerte
        transition.to( bgAlerteContenu, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
        transition.to( contenuAlerte, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
        transition.to( contenuAlerteTexte, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
        transition.to( contenuAlerteTexte2, { time = 500, x = bgMenu.width, transition=easing.outQuart } )
        alertes = tEvents
        local nb = 0
        if alertes ~= nil then
            nb = #tEvents
        end
        if nb > 0 then
            parent:updateAlerte( true )
        else 
            parent:updateAlerte()            
        end
        local cpt=0
        for i=1,alertContent.numChildren do
            if alertContent[i].type == "bouton" then
                alertContent[i]:disable()
                alertContent[i].type = "listItem"
            end
        end
        for i=1,nb do
            if i==1 then
                contenuAlerteTexte.text = tEvents[i].texte .. (tEvents[i].auteur and "\n\n -" .. tEvents[i].auteur or "")
            elseif i==2 then
                contenuAlerteTexte2.text = tEvents[i].texte .. "\n\n -" .. tEvents[i].auteur
            end
        end
        for i=1,alertContent.numChildren do
            if alertContent[i].type == "listItem" and cpt<nb then
                cpt = cpt + 1
                if tEvents[cpt].auteur ~= nil then
                    alertContent[i].image.fill = { type="image", filename="ressources/img/alertItem2.png" }
                else 
                    alertContent[i].image.fill = { type="image", filename="ressources/img/alertItem.png" }
                end
                alertContent[i]:enable()
                alertContent[i].type = "bouton"
            end
        end
        bgAlerteContenu:toFront()
        btRetour:toFront()
        contenuAlerte:toFront()
        contenuAlerteTexte:toFront()
        contenuAlerteTexte2:toFront()
    end

    -- Met l'affichage de l'inventaire à jour
    function telephone:updateInventaire()
        local cafe = perso.inventaire["cafe"]
        local barre = perso.inventaire["barreNrg"]
        local boisson = perso.inventaire["boissonNrg"]

        nbCafe.text = cafe.nb .. "/" .. cafe.max
        nbBarre.text = barre.nb .. "/" .. barre.max
        nbBoisson.text = boisson.nb .. "/" .. boisson.max

        if cafe.nb <= 0 then
            screenInventaire[2]:disable()
        elseif cafe.nb > 0 then
            screenInventaire[2]:enable()
        end
        if barre.nb <= 0 then
            screenInventaire[3]:disable()
        elseif barre.nb > 0 then
            screenInventaire[3]:enable()
        end
        if boisson.nb <= 0 then
            screenInventaire[4]:disable()
        elseif boisson.nb > 0 then
            screenInventaire[4]:enable()
        end

    end

----------------------------------------------------------------------------------------------

    -- Gère la fonction du bouton Back d'Android ou Windows Phone
    function telephone:menu()
        -- Si le téléphone est levé et qu'il est sur une application
        if screenHome.isVisible == false and self.y == posUp then
            screenHome.isVisible = true
            screenContacts.isVisible = false
            screenStats.isVisible = false
            screenInventaire.isVisible = false
            screenBanque.isVisible = false
            screenMenu.isVisible = false
            screenAlertes.isVisible = false
            screenMenu.isVisible = false
            screenSave.isVisible = false
        -- Si le téléphone est levé et qu'il est sur l'accueil
        elseif screenHome.isVisible == true and self.y == posUp then
            transition.to( self, { time = 500, y = posDown, transition=easing.outQuart } )
        -- Si le téléphone est baissé
        else
            screenHome.isVisible = false
            screenMenu.isVisible = true
            transition.to( self, { time = 500, y = posUp, transition=easing.outQuart } )
        end
    end

    -- Affiche le bouton vers l'écran de cheats
    function telephone:unlockCheats()
        btCheats.isVisible = true
    end
    
    -- Fonction appelée à la suppression du téléphone
    function telephone:kill()
        btHome:removeEventListener( "tap", homeListener )
    end
    
    telephone:init()
    return telephone
end

return Telephone