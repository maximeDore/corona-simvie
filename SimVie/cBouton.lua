-----------------------------------------------------------------------------------------
--
-- cBouton.lua
--
-----------------------------------------------------------------------------------------
local Bouton = {}

function Bouton:init ( texte1, texte2, x, y, callbackFunction, callbackParam, width, height )
    
    local bouton = display.newGroup()
    local titre
    local sousTitre
    local sfxToc = audio.loadSound( "toc.wav" )

    -- Si le paramètre de largeur existe, le bouton est un rectangle invisible
    if width~=nil then
        bouton = display.newRect( x, y, width, height )
        bouton.alpha = 0.01
    end

    function bouton:init()
        self.image = nil
        if width == nil then
            if string.find( texte1, ".png" ) ~= nil then
                self.image = display.newImage( self, texte1 )
            elseif texte1 ~= nil then
                self.image = display.newImage( self, "bt.png" )
                local optionsTitre = {
                        text = texte1,
                        y = -self.image.height/6,
                        font = "Diskun.ttf",   
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
                            font = "Diskun.ttf",   
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

    function bouton:touch( e )
        if e.phase == "began" then
            callbackFunction(callbackParam)
            audio.play( sfxToc, { channel=10 } )
        end
    end

    function bouton:enable()
        if self._tableListeners["touch"] then else
            self:addEventListener("touch", self)
        end
        self.alpha = 1
    end

    function bouton:disable()
        if self._tableListeners["touch"] then
            bouton:removeEventListener("touch", bouton)
        end
        bouton.alpha = .25
    end

    function bouton:kill()
        self:removeEventListener("touch", bouton)
    end

    bouton:init()
    bouton:addEventListener("touch", bouton)
    return bouton
end

return Bouton