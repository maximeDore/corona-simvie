-----------------------------------------------------------------------------------------
--
-- cPerso.lua
--
-----------------------------------------------------------------------------------------
-- Création du constructeur Perso
local Perso = {}

-- Mise en mémoire des infos du sprite de l'ogre (ogre en anim png et lua)
local spriteSheet = require("sports_anim")
local myImageSheet = graphics.newImageSheet("sports_anim.png", spriteSheet:getSheet() )

-- Effets sonores
local sfxVehicules = {
    -- Marche
    marche = audio.loadSound('footstep.mp3'),
    --Scooter
    scooterStart = audio.loadSound('scooter_start.mp3'),
    scooter = audio.loadSound('scooter_idle.mp3'),
    scooterOff = audio.loadSound('scooter_off.mp3'),
    --Voiture
    voitureStart = audio.loadSound('saturn_start.mp3'),
    voiture = audio.loadSound('saturn_idle.mp3'),
    voitureOff = audio.loadSound('saturn_off.mp3')
}
local sfxCrash = audio.loadSound('car_crash.mp3')

-- Méthode init du perso
function Perso:init(xorig, yorig, map, joystick, jeu)
    local perso = display.newGroup()
    audio.setVolume( 0.1, {channel=5} )
    audio.setVolume( 0.1, {channel=6} )
    -- Modificateurs de vitesse de chaque véhicule
    local vehicules = {
        marche  = 7.5,
        scooter = 12.5,
        voiture = 20
    }
    -- Constructeur de Perso
    function perso:init()
        local avatar = display.newSprite(self, myImageSheet, spriteSheet:getSpriteIndex())
        self.type = "perso"
        self.vehiculeActif = "marche"
        self.avatar = avatar
        self.x = xorig
        self.y = yorig
        self.vitModif = 30
        self.vit = 0
        self.angRad = 0
        self.avatar:play()
        -- Données sauvegardées
        if _G.data == nil then
            self.energie = 100
            self.money = 100
            self.banque = 0
            self.inventaire = {}
            self.forNum = _G.forNum
            self.intNum = _G.intNum
            self.chaNum = _G.chaNum
            self.carriere = _G.carriere
        else -- données par défaut
            self.energie = _G.data.energie
            self.money = _G.data.money
            self.banque = _G.data.banque
            self.forNum = _G.data.force
            self.intNum = _G.data.intelligence
            self.chaNum = _G.data.chance
            self.carriere = _G.data.carriere
            self.inventaire = _G.data.inventaire
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
        -- self.x = self.x + self.vit*math.cos(self.angRad)
        -- self.y = self.y + self.vit*math.sin(self.angRad)
        self:setLinearVelocity( self.vit*math.cos(self.angRad)*50,self.vit*math.sin(self.angRad)*50 )
        self.angularVelocity = 0
        local angle = joystick:getAngle()*-1
        if angle < -180 then
            angle = angle+360
        end

        local seq
        local sca = 1.75
        self.yScale = sca/1.15

        -- Spectre des angles pour les séquence de sprite
        if angle >= 135 or angle <= -135 then
            seq ="perso_profil"
            sca = -sca
        elseif angle < 45 and angle >= -45 then
            seq ="perso_profil"
        elseif angle < 135 and angle >= 45 then
            seq ="perso_face"
        elseif angle < -35 and angle >= -135 then
            seq ="perso_dos"
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
            if self.vitModif == vehicules.marche and audio.isChannelActive( 5 ) == false then
                audio.play( sfxVehicules[self.vehiculeActif], { channel=5 } )
            end
        else
            self.avatar:setSequence(seq.."_idle")
            self.avatar:pause()
            if self.vitModif == vehicules.marche then
                audio.stop( 5 )
            end
        end
    end

    -- Change la vitesse de déplacement du personnage et son visuel selon le véhicule passé en paramètre
    function perso:changerVehicule( vehicule )

        local function listener()
            audio.play( sfxVehicules[vehicule], { channel=5, loops=-1 } )
        end

        if table.indexOf( self.inventaire, vehicule ) ~= nil or vehicule == "marche"  then
            self.vitModif = vehicules[vehicule]
            audio.stop( 5 )
            if vehicule ~= "marche" then
                audio.play( sfxVehicules[vehicule.."Start"], { channel=5, onComplete=listener } )
            elseif vehiculeActif ~= "marche" then
                audio.play( sfxVehicules[self.vehiculeActif.."Off"], { channel=6 } )
            end
            self.vehiculeActif = vehicule
        end
    end

    -- Setters
    function perso:setMoney( valeur )
        self.money = self.money + valeur
        _G.infos:updateMoney()
    end
    function perso:setBanque( valeur )
        self.banque = self.banque + valeur
        _G.infos:updateMoney()
    end
    function perso:setEnergie( valeur )
        if self.energie+valeur <= 100 and self.energie+valeur >= 0 then
            self.energie = self.energie + valeur
            infos:updateEnergie()
            return true
        elseif self.energie+valeur >= 100 then
            self.energie = 100
            infos:updateEnergie()
            return true
        else
            return false
        end
    end

    function perso:collision(e)
        if e.phase=="began" then
            if e.other.type=="porte" then
                jeu:entrerBatiment(e.other.destination)
            elseif e.other.type=="auto" then
                audio.play(sfxCrash)
                jeu:kill()
            end
        end
    end

    function perso:assombrir(heure)
        if heure > 12 then
            perso.avatar:setFillColor( (heure-17)*8/-100+1 )
        else
            if heure < 4 then
                perso.avatar:setFillColor( (7)*8/-100+1 )
            else
                perso.avatar:setFillColor( (13-heure*2)*8/-100+1 )
            end
        end
    end

    function perso:kill()
        Runtime:removeEventListener( "enterFrame", self )
        self:removeEventListener( "collision" )
    end

    -- Appel du constructeur de la fonction et ajouts d'écouteurs
    perso:init()

    -- Forme du corps de physique du personnage (octogone)
    local w,h = perso.width/2,perso.height/2
    local bodyShape = { w-10,h-10,  w,h,  w,h+h/2-10,  w-10,h+h/2,  -w+10,h+h/2,  -w,h+h/2-10,  -w,h,  -w+10,h-10 }
    physics.addBody( perso, { density=1, friction=1, bounce=0, shape=bodyShape } )
    perso.isFixedRotation = true

    perso:addEventListener( "collision" )
    Runtime:addEventListener( "enterFrame", perso )
    return perso
end

return Perso