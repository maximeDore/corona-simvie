-----------------------------------------------------------------------------------------
--
-- cCredits.lua
--
-- Classe qui affiche la page des crédits et qui gère son interactivité
--
-----------------------------------------------------------------------------------------
local Credits = {}

function Credits:init()

    local credits = display.newGroup()
    local cBouton = require("cBouton")
    local cMenu = require("cMenu")
    local fade
    local logo
    local btRetour
    local texte
    
    -- Fait une transition en fondu noir avant de supprimer la page-écran
    local function listener()
        local function listener2()
            credits:kill()
            credits:retour()
        end
        btRetour:kill()
        transition.fadeOut( credits, { time=500, onComplete=listener2 } )
    end

    ------ Méthodes  ------------------------------------------------------------------------------

    -- Constructeur, affiche les éléments visuels et instancie le bouton
    function credits:init()
        display.setStatusBar( display.HiddenStatusBar )

        -- Démarrer le jeu
        local function retour()
            audio.fadeOut( { 1, 1000 } )
            self:kill()
            cMenu:init()
        end
        
        -- Fondu d'entrée
        fade = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth*2,display.contentHeight)
        fade.fill = {0,0,0}
        transition.fadeOut( fade, { time=500, onComplete=fadeListener } )
        
        -- Affichage de la barre du haut
        local barre = display.newRect( self, display.screenOriginX, 0, display.contentWidth*3, 100 )
        local degrade = {
            type = "gradient",
            color1 = { .5, .1, .1 },
            color2 = { .4, .3, .3 },
            direction = "up"
        }
        barre.fill = degrade

        -- Instanciation du bouton
        btRetour = cBouton:init("Retour",nil,display.contentCenterX/2.25,display.contentCenterY*1.5,retour)
        -- Affichage du titre, du logo et des textes
        local optionsTitreDisplay = {text = "CREDITS", width = 500, x = display.contentCenterX, y = 25, font = "ressources/fonts/8-Bit Madness.ttf", fontSize = 50, align = "center"}
        local titreDisplay = display.newText(optionsTitreDisplay)
        local optionsTexte = {text = "-PROGRAMMATION-\nMaxime Dore\n\n-MUSIQUE-\nMaxime Dore\nHermes Maheu\n\n-GRAPHISME-\nMaxime Dore\n\n-SUPPORT MORAL-\nKyan Daigneault\n\nProduit dans le cadre du cours de Production de jeu video de Techniques d'integration multimedia du Cegep de Saint-Jerome © 2018", width = display.contentWidth/3*1.5, x = display.contentCenterX*1.4, y = display.contentCenterY, font = "ressources/fonts/8-Bit Madness.ttf", fontSize = 45, align = "center"}
        texte = display.newText( optionsTexte )
        logo = display.newImage( self, "ressources/img/logo.png", btRetour.x, display.contentCenterY/1.5 )
        
        self:insert(titreDisplay)
        self:insert(texte)
        self:insert(btRetour)
    end

    -- Suppression de la page et de tous ses enfants
    function credits:kill()
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

    credits:init()
    return credits
end

return Credits