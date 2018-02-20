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
    local phone
    local tapZone
    local btHome
    local bgStats
    local screenHome = display.newGroup()
    local screenStats = display.newGroup()
    local screenContacts = display.newGroup()
    local screenBanque = display.newGroup()
    local screenGps = display.newGroup()
    local screenAlertes = display.newGroup()
    local screenMenu = display.newGroup()
    local aptitudesNum
    local carriereDisplay
    local balanceDisplay
    local interetDisplay
    
    function telephone:init()

        local function afficherHome()
            screenHome.isVisible = true
            screenContacts.isVisible = false
            screenStats.isVisible = false
            screenGps.isVisible = false
            screenBanque.isVisible = false
            screenMenu.isVisible = false
            screenAlertes.isVisible = false
            screenMenu.isVisible = false
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
        local function afficherGps()
            screenHome.isVisible = false
            screenGps.isVisible = true
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
        end
        local function mute()
            if audio.pause() > 0 then
                audio.pause( 1 )
            else
                audio.resume( 1 )
            end
        end

        local function marcher()

        end
        local function scooter()
            
        end
        local function auto()

        end

        local function quitter()
            jeu:kill()
        end

        phone = display.newImage( self, "telephone.png" )
        -- Zone de contact dans le haut du téléphone où il faut tapper pour le monter/descendre
        tapZone = display.newRect( self, 0, -phone.height/2.5, phone.width, phone.height/5 )
        tapZone.alpha = 0.01

        -- Fonds des différents écrans
        bgContacts = display.newImage( screenContacts, "screenContacts.png", 0, -10.5 )
        bgStats = display.newImage( screenStats, "screenStats.png", 0, -10.5 )
        bgBanque = display.newImage( screenBanque, "screenBanque.png", 0, -10.5 )
        bgMenu = display.newImage( screenMenu, "screenMenu.png", 0, -10.5 )

        -- Bouton physique du téléphone (home button)
        btHome = cBouton:init( "", 0, bgStats.height/1.8, afficherHome, nil, 75, 50 )

        -- Boutons de l'écran d'accueil
        -- Disposition :
        -- BtStats  btContacts  btAlertes
        -- btGps    btBanque    btMute
        -- btSave   btMenu
        -- btMarche btScooter   btAuto
        btStats = cBouton:init( "btStats.png", -bgStats.width/3.25, -bgStats.height*.35, afficherStats )
        btContacts = cBouton:init( "btContacts.png", 0, -bgStats.height*.35, afficherContacts )
        btAlertes = cBouton:init( "btAlertes.png", bgStats.width/3.25, -bgStats.height*.35, afficherAlertes )
        btGps = cBouton:init( "btGps.png", -bgStats.width/3.25, -bgStats.height*.15, afficherGps )
        btBanque = cBouton:init( "btBanque.png", 0, -bgStats.height*.15, afficherBanque )
        btMute = cBouton:init( "btMute.png", bgStats.width/3.25, -bgStats.height*.15, mute )
        btSave = cBouton:init( "btSave.png", -bgStats.width/3.25, bgStats.height*.05, save )
        btMenu = cBouton:init( "btMenu.png", 0, bgStats.height*.05, afficherMenu )
        -- Boutons
        btMarche = cBouton:init( "btMarche.png", -bgStats.width/3.25, bgStats.height*.35, marcher )
        btScooter = cBouton:init( "btScooter.png", 0, bgStats.height*.35, scooter )
        btAuto = cBouton:init( "btAuto.png", bgStats.width/3.25, bgStats.height*.35, auto )
        
        screenHome:insert(btStats)
        screenHome:insert(btContacts)
        screenHome:insert(btAlertes)
        screenHome:insert(btGps)
        screenHome:insert(btBanque)
        screenHome:insert(btMute)
        screenHome:insert(btSave)
        screenHome:insert(btMenu)
        screenHome:insert(btMarche)
        screenHome:insert(btScooter)
        screenHome:insert(btAuto)

        -- Écran Statistiques
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
            text = "",
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


        -- Écran Menu
        btOui = cBouton:init( "btOui.png", -bgMenu.width/4.15, 0, quitter )
        btNon = cBouton:init( "btNon.png", bgMenu.width/4.25, 0, afficherHome )
        screenMenu:insert(btOui)
        screenMenu:insert(btNon)


        -- Écran Banque
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

        local optionsBalance = {
            text = parent:getInteret().." %",
            x = bgMenu.width/2-110,
            y = bgMenu.height*.135,
            width = 200,
            height = 100,
            font = "8-Bit Madness.ttf",
            fontSize = 40,
            align = "right"  -- Alignment parameter
        }
        interetDisplay = display.newText( optionsBalance )
        interetDisplay:setFillColor(0,0,.7)
        screenBanque:insert(balanceDisplay)
        screenBanque:insert(interetDisplay)


        screenContacts.isVisible = false
        screenStats.isVisible = false
        screenMenu.isVisible = false
        screenAlertes.isVisible = false
        screenBanque.isVisible = false
        screenGps.isVisible = false


        self:insert(screenHome)
        self:insert(screenContacts)
        self:insert(screenStats)
        self:insert(screenAlertes)
        self:insert(screenBanque)
        self:insert(screenGps)
        self:insert(screenMenu)
        self:insert(btHome)

        self.x = display.contentWidth*.85-display.screenOriginX
        self.y = posDown
        parent:insert(self)
        self:updateStats()
    end

    function telephone:updateStats()
        aptitudesNum.text = perso.forNum.."\n"..perso.intNum.."\n"..perso.chaNum
        carriereDisplay.text = parent:getEmploi().titre
    end

    function telephone:updateBanque()
        balanceDisplay.text = perso.banque.." $"
        interetDisplay.text = parent:getInteret() .. " %"
    end

    function telephone:tap()
        if self.y >= display.contentHeight-display.screenOriginY+125 then
            transition.to( self, { time = 500, y = posUp, transition=easing.outQuart } )
        elseif self.y <= display.contentHeight-display.screenOriginY-100 then
            transition.to( self, { time = 500, y = posDown, transition=easing.outQuart } )
        end
    end

    function telephone:kill()
        tapZone:removeEventListener( "tap", telephone )
    end

    telephone:init()

    tapZone:addEventListener( "tap", telephone )

    return telephone
end

return Telephone