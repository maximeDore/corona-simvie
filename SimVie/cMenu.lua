-----------------------------------------------------------------------------------------
--
-- cMenu.lua
--
-- Classe qui affiche le menu principal et gère son interactivité
--
-----------------------------------------------------------------------------------------
 
local Menu = {}
function Menu:init()

    local menu = display.newGroup()
    local bouton = require("cBouton")
    local autoMenu = require("cAutoMenu")
    local cMenuCommencer = require("cMenuCommencer")
    local cInstructions = require("cInstructions")
    local cCredits = require("cCredits")
    local cDonnees = require("cDonnees")
    local cJeu = require("cJeu")
    local bgMusic = audio.loadStream( "ressources/sfx/toune_menu.mp3" )
    local bg
    local menuCommencer
    local btCommencer
    local btContinuer
    local saveMenu = display.newGroup()
    local btSave1
    local btSave2
    local btSaveRetour
    local save1
    local save2
    local fade
    local nouvellePartie
    
    -- Définit la carrière du personnage et fait une transition en fondu noir avant de supprimer le menu
    local function listener()
        -- Initialisation et destruction
        local function listener2()
            if _G.data == nil or nouvellePartie ~= nil then
                if _G.forNum>_G.intNum then
                    _G.carriere = "sports"
                else
                    _G.carriere = "sciences"            
                end
                _G.data = nil
                cInstructions:init()
            else 
                audio.fadeOut( { 1, 1000 } )
                cJeu:init()
            end
            menu:removeSelf()
        end
        -- Fondu
        transition.fadeOut( menu, { time=500, onComplete=listener2 } )
    end


    ------ Méthodes  ------------------------------------------------------------------------------

    -- Constructeur, instancie tous les éléments visuels et interactifs
    function menu:init()
        -- Affiche la barre de notifications
        display.setStatusBar( display.LightTransparentStatusBar )

        -- Charge la musique de fond dans le channel 1
        audio.stop( 1 )
        bgMusicChannel = audio.play( bgMusic, { channel=1, loops=-1, fadein=2000 } )
        
        -- Chargement des sauvegardes
        save1 = donnees:loadTable( "sauvegarde_auto.json" )
        save2 = donnees:loadTable( "sauvegarde.json" )
        
        -- Instancie le menu de personnalisation et cache les boutons du menu principal
        local function commencer()
            menuCommencer = cMenuCommencer:init()
            self:insert(menuCommencer)
            btCommencer.isVisible = false
            btContinuer.isVisible = false
        end

        -- Démarre le jeu s'il y a une sauvegarde dans le sandbox
        local function load( saveSlot )
            if saveSlot == 1 then
                _G.data = save1
                btCommencer:disable()
                btContinuer:disable()
                btCredits:removeSelf()
                listener()
            elseif saveSlot == 2 then
                _G.data = save2
                btCommencer:disable()
                btContinuer:disable()
                btCredits:removeSelf()
                listener()
            end
        end
            
        -- Démarre le jeu s'il y a une sauvegarde dans le sandbox
        local function continuer( saveSlot )
            if save1 ~= nil or save2 ~= nil then
                btCommencer:disable()
                btContinuer:disable()
                btCommencer.isVisible = false
                btContinuer.isVisible = false
                saveMenu.isVisible = true
                if donnees:loadTable( "sauvegarde_auto.json" ) ~= nil then
                    btSave1:enable() 
                end
                if donnees:loadTable( "sauvegarde.json" ) ~= nil then
                    btSave2:enable()
                end
                btSaveRetour:enable()
            end
        end
        -- Démarre le jeu s'il y a une sauvegarde dans le sandbox
        local function continuerRetour()
            btCommencer:enable()
            btContinuer:enable()
            btCommencer.isVisible = true
            btContinuer.isVisible = true
            saveMenu.isVisible = false
            btSave1:disable()
            btSave2:disable()
            btSaveRetour:disable()
        end

        -- Supprime le rectangle de fondu
        local function fadeListener()
            fade:removeSelf()
        end

        -- Menu Continuer ---------------------------------------------------------------------------------------
        local box = display.newImage( saveMenu, "ressources/img/UIBox.png", display.contentCenterX ,display.contentCenterY )
        
        -- textes
        local optionsTitre = {
            parent = saveMenu,
            text = "Continuer une vie",
            x = display.contentCenterX,
            y = display.contentCenterY/2.75,
            font = "ressources/fonts/Diskun.ttf",   
            fontSize = 100,
            align = "center"  -- Alignment parameter
        }
        local titre = display.newText( optionsTitre )
        titre:setFillColor(1,0,0)

        btSave1 = bouton:init("Sauvegarde 1","Automatique",display.contentCenterX/1.6,display.contentHeight/1.9,load, 1)
        btSave2 = bouton:init("Sauvegarde 2","Jour "..save2.cptJours..", "..save2.money+save2.banque.."$",display.contentCenterX/.725,display.contentHeight/1.9,load, 2)
        btSaveRetour = bouton:init("Retour",nil,display.contentCenterX/1.6,display.contentHeight/1.3,continuerRetour)

        btSave1:disable()
        btSave2:disable()

        saveMenu:insert(btSave1)
        saveMenu:insert(btSave2)
        saveMenu:insert(btSaveRetour)
        saveMenu.isVisible = false

        self:insert(saveMenu)

        -- Fondu d'entrée
        fade = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth*2,display.contentHeight)
        fade.fill = {0,0,0}
        transition.fadeOut( fade, { time=500, onComplete=fadeListener } )
        
        -- Image de fond
        bg = display.newImage( self, "ressources/img/bg.jpg",display.contentCenterX,display.contentCenterY)
        local autos = autoMenu:init()
        self:insert(autos)

        -- Boutons
        btCommencer = bouton:init("Commencer",nil,display.contentCenterX/2,display.contentHeight/1.37,commencer)
        btContinuer = bouton:init("Continuer",nil,display.contentCenterX/.67,display.contentHeight/1.37,continuer)
        btCredits = display.newText( { parent = self, text = "{MARTYR} © 2018 | Maxime Dore", width = display.contentWidth, x = display.contentCenterX, y = display.contentHeight-display.screenOriginY-15, font = "ressources/fonts/8-Bit Madness.ttf", fontSize =35, align = "center" } )
        btCredits:setFillColor(.7,.5,.5)
        self:insert(btCommencer)
        self:insert(btContinuer)

        -- Met le menu en premier plan
        saveMenu:toFront()

        -- Désactive le bouton commencer s'il n'y a pas de partie sauvegardée dans le sandbox
        if save1 == nil and save2 == nil then
            btContinuer:disable()
        end
    end
        
    -- Supprime le menu de personnalisation et affiche les boutons du menu principal
    function menu:retour()
        menuCommencer:removeSelf()
        -- Boutons
        btCommencer.isVisible = true
        btContinuer.isVisible = true
    end

    -- Affiche la page de crédits et supprime le menu
    local function afficherCredits(e)
        if e.phase == "began" then
            menu:kill(true)
            menu:removeSelf()
            cCredits:init()
        end
    end

    -- Suppression du menu, ses enfants et tous ses écouteurs
    -- @params
    -- param:       bool    Destruction sans fondu (défaut avec fondu)
    -- new:         bool    Commencer une nouvelle partie (défaut nil)
    function menu:kill( param, new )
        btCredits:removeEventListener( "touch", afficherCredits )
        nouvellePartie = new
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
        if param == nil then
            listener()
        end
    end
    
    menu:init()
    btCredits:addEventListener( "touch", afficherCredits )
    return menu

end

return Menu