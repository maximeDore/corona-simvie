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
function Perso:init(xorig, yorig, ispeed, score, map)
    speed = ispeed      -- vitesse de déplacement du personnage passée en paramètre (+élevé = +lent)
    local perso = display.newGroup()
    -- Constructeur de Perso
    function perso:init()
        local avatar = display.newSprite(myImageSheet, spriteSheet:getSpriteIndex())
        local partdesigner = require("particleDesigner")
        local emitter = partdesigner.newEmitter("emitter44878.rg")
        self:insert(emitter)
        self:insert(avatar)
        self.avatar = avatar
        self.x = xorig
        self.y = yorig
        self.vit = 0
        self.angRad = 0
        self.avatar:play()
        self.isFixedRotation = true
    end
    -- Appelée dès que l'on touche l'écran, met à jour le point d'arrivée du personnage sur la position touchée, ou sur son point de départ une fois le contact rompu
    function perso:touch(e)
        if e.phase == "ended" then
            self.avatar:pause()
            self.vit = 0
        else
            self.avatar:play()
            local dx = e.x-display.contentWidth/2
            local dy = e.y-display.contentHeight/2
            local d = math.sqrt(dx*dx+dy*dy)
            local angRad = math.atan2(dy,dx)
            self.vit = d/30
            self.angRad = angRad
        end
    end
    -- Appelée à chaque frame, utilisée pour déplacer le personnage et définir son orientation
    function perso:enterFrame(e)
        self.x = self.x + self.vit*math.cos(self.angRad)
        self.y = self.y + self.vit*math.sin(self.angRad)
        local angle = self.angRad*180/math.pi

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
        if self.vit>3 then
            self.avatar:play()
        else
            self.avatar:pause()
        end

    end

    function perso:collision(e)
        if e.other.type == "plant" then
            e.other:flameOn()
        elseif e.other.type == "diamant" then
            e.other:collect()
            score:update(1)
        end
    end

    function perso:kill()
        Runtime:removeEventListener( "touch", self )
        Runtime:removeEventListener( "enterFrame", self )
        self:removeEventListener( "collision" )
    end

    -- Appel du constructeur de la fonction et ajouts d'écouteurs
    perso:init()
    physics.addBody( perso, { density=1.0, friction=1, bounce=0, radius=perso.width/2.5 } )
    perso:addEventListener( "collision" )
    Runtime:addEventListener( "touch", perso )
    Runtime:addEventListener( "enterFrame", perso )
    map:insert(perso)
    return perso
end

return Perso