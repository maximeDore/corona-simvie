-----------------------------------------------------------------------------------------
--
-- cBatiment.lua
--
-- Classe qui affiche un bâtiment sur la carte et y crée un porte d'entrée
--
-----------------------------------------------------------------------------------------
local Batiment = {}

-- @params 
-- parent :     Group   Map, groupe parent
-- img :        String  Fichier image du sprite du bâtiment
-- x, y :       Number  Position du bâtiment sur la map
-- destination: String  Nom du bâtiment dans lequel le personnage va entrer par la porte
-- porteX :     Number  Positionnement en x de la porte sur le bâtiment
-- outline :    Bool    True pour que le corps physique s'ajuste à la forme du sprite, sinon le corps est un rectangle
-- perso :      Object  Personnage du jeu, pour accéder à ses méthodes avec les cheats
function Batiment:init(parent,img,x,y,destination,porteX,outline,perso)

    local batiment = display.newGroup()
    local cPorte = require("cPorte")

    -- Constructeur
    function batiment:init()
        local sprite = display.newImage(self,img,x,y)
        sprite.width= sprite.width*4
        sprite.height= sprite.height*4
        local imgOutline = graphics.newOutline( 2, img )
        if destination ~= nil then
            local porte = cPorte:init(self,x+porteX,y+sprite.height/2,destination)
        end
        sprite.type = "batiment"
        if outline then
            physics.addBody( sprite, "static", { outline=imgOutline, friction=0, bounce=0} )
        else
            physics.addBody( sprite, "static", { density=100, friction=0, bounce=0} )
        end
        parent:insert(self)
    end
    
    function batiment:kill()
    end


    batiment:init()
    return batiment
end

return Batiment