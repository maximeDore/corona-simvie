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
    local bgMusic = audio.loadStream( "toune_menu.mp3" )
    local bg
    local menuCommencer
    local btCommencer
    local btContinuer
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
                cJeu:init(946,1150)
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
        
        -- Instancie le menu de personnalisation et cache les boutons du menu principal
        local function commencer()
            menuCommencer = cMenuCommencer:init()
            self:insert(menuCommencer)
            btCommencer.isVisible = false
            btContinuer.isVisible = false
        end

        -- Démarre le jeu s'il y a une sauvegarde dans le sandbox
        local function continuer()
            if _G.data ~= nil then
                btCommencer:disable()
                btContinuer:disable()
                btCredits:removeSelf()
                listener()
            end
        end

        -- Supprime le rectangle de fondu
        local function fadeListener()
            fade:removeSelf()
        end

        -- Fondu d'entrée
        fade = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth*2,display.contentHeight)
        fade.fill = {0,0,0}
        transition.fadeOut( fade, { time=500, onComplete=fadeListener } )
        
        -- Image de fond
        bg = display.newImage("bg.jpg",display.contentCenterX,display.contentCenterY)
        local autos = autoMenu:init()
        self:insert(bg)
        self:insert(autos)

        -- Boutons
        btCommencer = bouton:init("Commencer",nil,display.contentCenterX/2,display.contentHeight/1.37,commencer)
        btContinuer = bouton:init("Continuer",nil,display.contentCenterX/.67,display.contentHeight/1.37,continuer)
        btCredits = display.newText( { text = "Maxime Dore © 2018  |  voir les sources", width = display.contentWidth, x = display.contentCenterX, y = display.contentHeight-display.screenOriginY-15, font = "8-Bit Madness.ttf", fontSize =35, align = "center" } )
        btCredits:setFillColor(.7,.5,.5)
        self:insert(btCommencer)
        self:insert(btContinuer)
        self:insert(btCredits)

        -- Désactive le bouton commencer s'il n'y a pas de partie sauvegardée dans le sandbox
        _G.data = donnees:loadTable( "sauvegarde.json" )
        if _G.data == nil then
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