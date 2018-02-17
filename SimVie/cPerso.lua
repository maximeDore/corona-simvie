-----------------------------------------------------------------------------------------
--
-- cPerso.lua
--
-----------------------------------------------------------------------------------------
-- Création du constructeur Perso
local Perso = {}

-- Mise en mémoire des infos du sprite de l'ogre (ogre en anim png et lua)
local spriteSheet = require("ogre_anim")
local myImageSheet = graphics.newImageSheet("ogre_anim.png", spriteSheet:getSheet() )

-- Méthode init du perso
function Perso:init(xorig, yorig, map, joystick, jeu)
    local perso = display.newGroup()
    -- Constructeur de Perso
    function perso:init()
        local avatar = display.newSprite(self, myImageSheet, spriteSheet:getSpriteIndex())
        self.type = "perso"
        self.avatar = avatar
        self.x = xorig
        self.y = yorig
        self.vitModif = 30
        self.vit = 0
        self.angRad = 0
        self.avatar:play()
        self.isFixedRotation = true
        if _G.data == nil then
            self.money = 100
            self.banque = 0
            self.forNum = _G.forNum
            self.intNum = _G.intNum
            self.chaNum = _G.chaNum
            self.carriere = _G.carriere
        else 
            self.money = _G.data.money
            self.banque = _G.data.banque
            self.forNum = _G.data.force
            self.intNum = _G.data.intelligence
            self.chaNum = _G.data.chance
            self.carriere = _G.data.carriere
        end

        -- Destruction des valeurs globales
        _G.forNum = nil
        _G.intNum = nil
        _G.chaNum = nil
        _G.carriere = nil
    end
    
    -- Appelée à chaque frame, utilisée pour déplacer le personnage et définir son orientation
    function perso:enterFrame(e)
        self.vit = joystick:getDistance()*self.vitModif
        self.angRad = joystick:getAngRad()
        self.x = self.x + self.vit*math.cos(self.angRad)
        self.y = self.y + self.vit*math.sin(self.angRad)
        -- local angle = self.angRad*180/math.pi
        local angle = joystick:getAngle()*-1
        if angle < -180 then
            angle = angle+360
        end

        local seq
        local sca = 1

        -- Spectre des angles pour les séquence de sprite
        if angle < 22.5 and angle >= -22.5 then
            seq ="ogre_marche_p"
            -- print("right")
        elseif angle < 67.5 and angle >= 22.5 then
            seq ="ogre_marche_45"
            -- print("down Right")
        elseif angle < 112.5 and angle >= 67.5 then
            seq ="ogre_marche_f"
            -- print("down")
        elseif angle < 157.5 and angle >= 112.5 then
            seq ="ogre_marche_45"
            sca = -1
            -- print("down Left")
        elseif angle > 157.5 or angle < -157.5 then
            seq ="ogre_marche_p"
            sca = -1
            -- print("left")
        elseif angle >= -157.5 and angle < -112.5 then
            seq ="ogre_marche_dos45"
            sca = -1
            -- print("up Left")
        elseif angle >= -112.5 and angle <- 67.5 then
            seq ="ogre_marche_dos"
            -- print("up")
        elseif angle >= -67.5 and angle < -22.5 then
            seq ="ogre_marche_dos45"
            -- print("up Right")
        else print(angle)
        end
        -- Change l'orientation du personnage selon 1 et -1 de sca
        self.xScale = sca
        -- Définit la séquence qui correspond à l'orientation du personnage
        if self.avatar.sequence ~= seq then
            self.avatar:setSequence(seq)
        end
        -- Si la distance à parcourir vers le point d'arrivée est plus grande que la valeur, on joue l'animation du perso, sinon on la met en pause
        if self.vit>0.25 then
            self.avatar:play()
        else
            self.avatar:pause()
        end

    end

    function perso:getMoney()
        return self.money
    end
    function perso:setMoney( valeur )
        self.money = self.money + valeur
        _G.infos:updateMoney()
    end
    function perso:setBanque( valeur )
        self.banque = self.banque + valeur
        _G.infos:updateMoney()
    end

    function perso:collision(e)
        if e.phase=="began" then
            if e.other.type=="porte" then
                jeu:entrerBatiment(e.other.destination)
            elseif e.other.type=="auto" then
                jeu:mourir()
            end
        end
    end

    function perso:kill()
        Runtime:removeEventListener( "enterFrame", self )
        self:removeEventListener( "collision" )
    end

    -- Appel du constructeur de la fonction et ajouts d'écouteurs
    perso:init()
    physics.addBody( perso, { density=0, friction=1, bounce=0, radius=perso.width/4 } )
    perso:addEventListener( "collision" )
    -- Runtime:addEventListener( "touch", perso )
    Runtime:addEventListener( "enterFrame", perso )
    return perso
end

return Perso