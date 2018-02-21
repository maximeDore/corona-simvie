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

    -- Si le paramètre de largeur existe, le bouton est un rectangle invisible
    if width~=nil then
        bouton = display.newRect( x, y, width, height )
        bouton.alpha = 0.01
    end

    function bouton:init()
        local image
        if width == nil then
            if string.find( texte1, ".png" ) ~= nil then
                image = display.newImage( self, texte1 )
            elseif texte1 ~= nil then
                image = display.newImage( self, "bt.png" )
                local optionsTitre = {
                        text = texte1,
                        y = -image.height/6,
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
                            y = image.height/6,
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

    function bouton:tap()
        callbackFunction(callbackParam)  
    end

    function bouton:kill()
        self:removeEventListener("tap", bouton)
    end

    bouton:init()
    bouton:addEventListener("tap", bouton)
    return bouton
end

return Bouton