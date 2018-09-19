-----------------------------------------------------------------------------------------
--
-- cBouton.lua
--
-- Classe qui génère un bouton selon une liste de paramètres
--
-----------------------------------------------------------------------------------------
local Bouton = {}

-- @params
-- texte1 :         String  Plus gros texte affiché sur le bouton centré si texte2 est nil || fichier image s'il contient l'extension ".png"
-- texte2 :         String  Si !nil, affiche un second texte dans le bouton, plus petit
-- x, y :           Number  Position du bouton en x et y
-- callbackFunc :   Func    Fonction appelée une fois le bouton touché
-- callbackParam :  Any     Paramètre donné à callbackFunc
---- POUR QUE LE BOUTON SOIT UN RECTANGLE QUASI INVISIBLE --------------------------------------------------------
-- width :          Number  Si !nil, largeur du bouton invisible
-- height :         Number  Hauteur du bouton invisible
function Bouton:init ( texte1, texte2, x, y, callbackFunc, callbackParam, width, height )
    
    local bouton = display.newGroup()
    local titre
    local sousTitre
    local sfxToc = audio.loadSound( "ressources/sfx/toc.wav" )

    -- Si le paramètre de largeur existe, le bouton est un rectangle invisible
    if width~=nil then
        bouton = display.newRect( x, y, width, height )
        bouton.alpha = 0.01
    end

    -- Constructeur
    function bouton:init()
        self.image = nil
        if width == nil then
            if string.find( texte1, ".png" ) ~= nil then
                self.image = display.newImage( self, texte1 )
            elseif texte1 ~= nil then
                self.image = display.newImage( self, "ressources/img/bt.png" )
                local optionsTitre = {
                        text = texte1,
                        y = -self.image.height/6,
                        font = "ressources/fonts/Diskun.ttf",   
                        fontSize = 60,
                        align = "center"  -- Alignment parameter
                    }
                titre = display.newText( optionsTitre )
                titre:setFillColor(1,0,0)
                self:insert(titre)
                if texte2 ~= nil then
                    local optionsSousTitre = {
                            text = texte2,
                            y = self.image.height/6,
                            font = "ressources/fonts/Diskun.ttf",   
                            fontSize = 50,
                            align = "center"  -- Alignment parameter
                        }
                    sousTitre = display.newText( optionsSousTitre )
                    sousTitre:setFillColor(1,0,0)
                    self:insert(sousTitre)
                else
                    titre.y = 0
                end
            end
            bouton.x = x
            bouton.y = y
        end
    end

    -- Event.touch
    function bouton:touch( e )
        if e.phase == "began" then
            callbackFunc(callbackParam)
            audio.play( sfxToc, { channel=10 } )
        end
    end

    -- Active le bouton et lui donne 100% d'opacité
    function bouton:enable()
        if self._tableListeners["touch"] then else
            self:addEventListener("touch", self)
        end
        self.alpha = 1
    end

    -- Désactive le bouton et lui donne 25% d'opacité
    function bouton:disable()
        if self._tableListeners["touch"] then
            self:removeEventListener("touch", bouton)
            self.alpha = .25
        end
    end

    -- Supprime l'événement
    function bouton:kill()
        self:removeEventListener("touch", bouton)
    end

    bouton:init()
    bouton:addEventListener("touch", bouton)
    return bouton
end

return Bouton