-----------------------------------------------------------------------------------------
--
-- cInstructions.lua
--
-- Classe affichant l'écran de tutoriel du jeu et gérant son interactivité
--
-----------------------------------------------------------------------------------------
local Instructions = {}

function Instructions:init()

    local instructions = display.newGroup()
    local cBouton = require("cBouton")
    local cJeu = require("cJeu")
    local rightMarg = display.contentWidth - display.screenOriginX
    local telephone = display.newGroup()
    local posUp = display.contentHeight-display.screenOriginY-250
    local posDown = display.contentHeight-display.screenOriginY+210
    local bgContacts
    local btContacts
    local bgAlertes
    local btAlertes
    local notification
    local fade
    local bg1
    local bg2
    local auto
    local narration
    local narration2
    local btSuivant
    local isPhoneUp = false
    
    -- Fondu noir avant la destruction de la page-écran et l'instanciation du jeu
    local function start()
        local function listener2()
            instructions:kill()
            instructions:jouer()
        end
        btSuivant:kill()
        transition.fadeOut( instructions, { time=500, onComplete=listener2 } )
    end

    -- Constructeur, affiche tous les éléments visuels et les boutons
    function instructions:init()
        display.setStatusBar( display.HiddenStatusBar )
        -- Index du tableau de narration
        local cpt = 1
        
        -- Tableau des textes narratifs
        local textes = {
            --1
            "Vous etes jeune, sans experience et vous souhaitez vous eloigner de chez vous.",
            --2
            "C'est pourquoi vous voila en route vers Saint-Jerome. C'est le temps de vous faire une nouvelle vie." ,
            --3
            "Vous qui etes "..( carriere == "sports" and "athletique" or "intelligent" )..", revez d'etre riche et celebre.",
            --4
            "Vous vendez votre voiture, trouvez un appartement et "..( carriere == "sports" and "une place dans une petite equipe sportive professionnelle." or "un emploi minable dans une faculte de sciences." ),
            --5
            "Vous devrez maintenant payer votre loyer, gerer votre niveau d'energie et placer votre argent en banque pour prosperer.",
            --6
            "Votre telephone est votre meilleur outil. Touchez le haut du telephone pour le montrer ou le cacher.",
            --7
            "C'est grace a celui-ci que vous pourrez utiliser un vehicule ou sauvegarder votre progression.",
            --8
            "Il vous permettra aussi de voir l'avancement de certains collegues de travail. Touchez le bouton CONTACTS.",
            --9
            "Tentez d'avoir une meilleure vie que vos autres contacts. Cette application affichera leurs statistiques de vie.",
            --10
            "Parfois, vous recevrez des messages textes, certains vous avertirons des dernieres nouvelles en ville.",
            --11
            "Vous devrez apprendre le reste par vous-meme, explorez votre nouvel environnement.\nBonne vie!"
        }
        
        -- Afficher le texte suivant/activer les animations/démarrer le jeu
        local function suivant()
            print(cpt)
            if cpt ~= 6 or isPhoneUp == true then
                cpt = cpt +1
            end
            narration.text = textes[cpt]
            narration2.text = textes[cpt]
            if cpt == 6 then
                btSuivant:disable()
                transition.to( telephone, { time = 500, y = posDown - 50, transition=easing.outQuart } )
            elseif cpt == 8 then
                btSuivant:disable()
                btContacts:enable()
            elseif cpt == 9 then
                bgContacts.isVisible = true
            elseif cpt == 10 then
                bgContacts.isVisible = false
                btSuivant:disable()
                btAlertes:enable()
                notification.isVisible = true
            elseif cpt == #textes then
                transition.to( telephone, { time = 500, y = posDown, transition=easing.outQuart } )
            elseif cpt > #textes then
                start()
            end
        end

        -- Monter/descendre le téléphone
        local function toggleTelephone()
            if telephone.y >= display.contentHeight-display.screenOriginY+125 and cpt >= 6 then
                isPhoneUp = true
                transition.to( telephone, { time = 500, y = posUp, transition=easing.outQuart } )
                if cpt == 6 then
                    suivant()
                    btSuivant:enable()
                end
            elseif telephone.y <= display.contentHeight-display.screenOriginY-100 then
                isPhoneUp = false
                transition.to( telephone, { time = 500, y = posDown, transition=easing.outQuart } )
            end
        end

        -- Affiche l'écran Contacts du téléphone
        local function afficherContacts()
            suivant()
            btContacts:disable()
            btSuivant:enable()
        end
        -- Affiche l'écran Alertes du téléphone
        local function afficherAlertes()
            suivant()
            btAlertes:disable()
            btSuivant:enable()
        end
        
        -- Fondu d'entrée
        fade = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth*2,display.contentHeight)
        fade.fill = {0,0,0}
        transition.fadeOut( fade, { time=500, onComplete=fadeListener } )

        -- Visuels des voitures
        local sprites = { "ressources/img/autoSideVert.png", "ressources/img/autoSideGris.png", "ressources/img/autoSideBleu.png" }
        local rand = math.random( #sprites )

        -- Fonds d'écran parallaxe
        bg1 = display.newImage( self, "ressources/img/bg2.jpg", display.contentCenterX, display.contentCenterY)
        bg2 = display.newImage( self, "ressources/img/bg2.jpg", display.contentCenterX+bg1.width, display.contentCenterY )
        -- bg2.x = bg2.x - 70
        bg2.xScale = -1
        
        -- Affichage de la barre du haut
        local barre = display.newRect( self, display.screenOriginX, 0, display.contentWidth*3, 100 )
        local degrade = {
            type = "gradient",
            color1 = { .5, .1, .1 },
            color2 = { .4, .3, .3 },
            direction = "up"
        }
        barre.fill = degrade

        -- Affichage du titre
        local optionsJourDisplay = {text = "INTRODUCTION", width = 500, x = display.contentCenterX, y = 25, font = "ressources/fonts/8-Bit Madness.ttf", fontSize = 50, align = "center"}
        local titreDisplay = display.newText(optionsJourDisplay)

        -- Voiture
        auto = display.newImage( self, sprites[rand], display.contentCenterX*1.5, display.contentCenterY*1.35  )
        auto.xScale = -1
        auto.width = auto.width*2
        auto.height = auto.height*2

        -- Bouton suivant
        btSuivant = cBouton:init( "Suivant", nil, display.contentCenterX/2, display.contentHeight/1.37, suivant )

        -- Texte de narration
        local optionsNarration = {
            text = textes[cpt],
            x = display.contentCenterX,
            y = bg1.height/3,
            width = display.contentWidth-200,
            height = display.contentCenterY,
            font = "ressources/fonts/8-Bit Madness.ttf",   
            fontSize = 75,
            align = "center"  -- Alignment parameter
        }
        narration = display.newText( optionsNarration )
        narration2 = display.newText( optionsNarration )
        narration2.x = narration.x + 3
        narration2.y = narration.y + 3
        narration:setFillColor(1,0,0)

        notification = display.newImageRect( "ressources/img/bell.png", 30, 30 )
        notification.x = display.contentWidth - display.screenOriginX - notification.width/2 - 25
        notification.y = 25
        notification.isVisible = false


    ------ Téléphone    ------------------------------------------------------------------------------------------------------------

        -- Fonction appelée par les boutons inactifs, pour éviter un plantage
        local function dummy()
        end

        local phone = display.newImage( telephone, "ressources/img/telephone.png" )
        bgContacts = display.newImage( "ressources/img/screenContacts.png", 0, -10.5 )
        bgContacts.isVisible = false
        bgAlertes = display.newImage( "ressources/img/screenAlertes.png", 0, -10.5 )
        bgAlertes.isVisible = false
        tapZone = cBouton:init( nil, nil, 0, -phone.height/2.25, toggleTelephone, nil, phone.width, phone.height/6 )
        telephone:insert(tapZone)

        -- Boutons de l'écran d'accueil
        -- Disposition :
        --  BtStats  btContacts  btAlertes
        --  btInventaire    btBanque    btMute
        --  btSave   btMenu
        --  btMarche btScooter   btVoiture
        local btStats = cBouton:init( "ressources/img/btStats.png", nil, -bgContacts.width/3.25, -bgContacts.height*.35, dummy )
        btContacts = cBouton:init( "ressources/img/btContacts.png", nil, 0, -bgContacts.height*.35, afficherContacts )
        btAlertes = cBouton:init( "ressources/img/btAlertes.png", nil, bgContacts.width/3.25, -bgContacts.height*.35, afficherAlertes )
        local btInventaire = cBouton:init( "ressources/img/btGps.png", nil, -bgContacts.width/3.25, -bgContacts.height*.15, dummy )
        local btBanque = cBouton:init( "ressources/img/btBanque.png", nil, 0, -bgContacts.height*.15, dummy )
        local btMute = cBouton:init( "ressources/img/btMute.png", nil, bgContacts.width/3.25, -bgContacts.height*.15, dummy )
        local btSave = cBouton:init( "ressources/img/btSave.png", nil, -bgContacts.width/3.25, bgContacts.height*.05, dummy )
        local btMenu = cBouton:init( "ressources/img/btMenu.png", nil, 0, bgContacts.height*.05, dummy )
        -- Boutons de déplacement
        local btMarche = cBouton:init( "ressources/img/btMarche.png", nil, -bgContacts.width/3.25, bgContacts.height*.35, dummy )
        local btScooter = cBouton:init( "ressources/img/btScooter.png", nil, 0, bgContacts.height*.35, dummy )
        local btVoiture = cBouton:init( "ressources/img/btAuto.png", nil, bgContacts.width/3.25, bgContacts.height*.35, dummy )

        telephone.x = display.contentWidth*.85-display.screenOriginX
        telephone.y = posDown
        
        telephone:insert(btStats)
        telephone:insert(btContacts)
        telephone:insert(btAlertes)
        telephone:insert(btInventaire)
        telephone:insert(btBanque)
        telephone:insert(btMute)
        telephone:insert(btSave)
        telephone:insert(btMenu)
        telephone:insert(btMarche)
        telephone:insert(btScooter)
        telephone:insert(btVoiture)
        telephone:insert(bgContacts)

        btStats:disable()
        btContacts:disable()
        btAlertes:disable()
        btInventaire:disable()
        btBanque:disable()
        btMute:disable()
        btSave:disable()
        btMenu:disable()
        btMarche:disable()
        btScooter:disable()
        btVoiture:disable()

        self:insert(btSuivant)
        self:insert(narration)
        self:insert(narration2)
        self:insert(telephone)
        self:insert(titreDisplay)
        self:insert(notification)
    end

    -- Démarrer le jeu
    function instructions:jouer()
        audio.fadeOut( { 1, 1000 } )
        cJeu:init()
        self:kill()
    end

    -- Event.enterFrame
    function instructions:enterFrame(e)
        bg1.x = bg1.x - 4
        bg2.x = bg2.x - 4
        if bg1.x < display.screenOriginX - bg1.width/2 then
            bg1.x = rightMarg + bg1.width/2
        end
        if bg2.x < display.screenOriginX - bg2.width/2 then
            bg2.x = rightMarg + bg2.width/2
        end
    end

    -- Suppression de la page écran, de l'écouteur et de tous ses enfants
    function instructions:kill()
        Runtime:removeEventListener( "enterFrame", instructions )
        local function recursiveKill(group) -- fonction locale appelant la fonction kill de chaque enfant (removeEventListeners)
            for i=group.numChildren,1,-1 do
                if group[i].numChildren~=nil then
                    recursiveKill(group[i])
                end
                if group[i].kill ~= nil then
                    group[i]:kill()
                end
            end
        end
        recursiveKill(self)
        self:removeSelf()
    end

    instructions:init()
    Runtime:addEventListener( "enterFrame", instructions )
    return instructions
end

return Instructions