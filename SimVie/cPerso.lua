-----------------------------------------------------------------------------------------
--
-- cPerso.lua
--
-- Classe qui gère l'affichage du personnage et des véhicules ainsi que son comportement dans le monde
--
-----------------------------------------------------------------------------------------
local Perso = {}

-- Mise en mémoire des infos du sprite de l'ogre (ogre en anim png et lua)
local spriteSheetPerso = require("sports_anim")
local spriteSheetScooter = require("scooter_anim")
local spriteSheetVoiture = require("voiture_anim")
local marcheImageSheet = graphics.newImageSheet("sports_anim.png", spriteSheetPerso:getSheet() )
local scooterImageSheet = graphics.newImageSheet("scooter_anim.png", spriteSheetScooter:getSheet() )
local voitureImageSheet = graphics.newImageSheet("voiture_anim.png", spriteSheetVoiture:getSheet() )

local sprites = {
    marche = {
        type = "image",
        sheet = marcheImageSheet,
        frame = 1
    },
    scooter = {
        type = "image",
        sheet = scooterImageSheet,
        frame = 1
    },
    voiture = {
        type = "image",
        sheet = voitureImageSheet,
        frame = 1
    }
}

-- Effets sonores
local sfxVehicules = {
    -- Marche
    marche = audio.loadSound('footstep.wav'),
    --Scooter
    scooterStart = audio.loadSound('scooter_start.wav'),
    scooter = audio.loadSound('scooter_idle.wav'),
    scooterOff = audio.loadSound('scooter_off.wav'),
    --Voiture
    voitureStart = audio.loadSound('saturn_start.wav'),
    voiture = audio.loadSound('saturn_idle.wav'),
    voitureOff = audio.loadSound('saturn_off.wav')
}
local sfxCrash = audio.loadSound('car_crash.wav')


-- Méthode init du perso
function Perso:init(xorig, yorig, map, joystick, jeu)
    local perso = display.newGroup()
    -- Volume des channels audio utilisés
    audio.setVolume( 0.75, {channel=5} )
    audio.setVolume( 0.75, {channel=6} )
    audio.setVolume( 0.75, {channel=20} )
    -- Modificateurs de vitesse de chaque véhicule
    local vehicules = {
        marche  = { mod=7.5, sca=1.75, size=1 },
        scooter = { mod=12.5, sca=4, size=3 },
        voiture = { mod=20, sca=4.5, size=3 }
    }
    -- Constructeur de Perso
    function perso:init()
        self.avatar = display.newSprite(self, marcheImageSheet, spriteSheetPerso:getSpriteIndex())
        self.type = "perso"
        self.vehiculeActif = "marche"
        self.destination = nil
        self.x = xorig
        self.y = yorig
        self.vitModif = vehicules.marche.mod
        self.vit = 0
        self.angRad = 0
        self.avatar:play()
        local inventaire = {
            cafe = { nb=1, nrg=5, max=5 },
            barreNrg = { nb=0, nrg=10, max=5 },
            boissonNrg = { nb=0, nrg=25, max=2 }, 
            voiture = false,
            scooter = false,
            tapisRoulant = false,
            loft = false
        }
        -- Données sauvegardées
        if _G.data == nil then
            self.energie = 100
            self.money = 100
            self.banque = 0
            self.inventaire = inventaire
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
        local sca = vehicules[self.vehiculeActif].sca
        self.yScale = sca/1.15

        -- Séquences de sprite de marche selon l'angle de direction
        if self.vehiculeActif == "marche" then
            -- Spectre des angles pour les séquences de sprite de marche (4 directions)
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
        else -- Spectre des angles pour les séquences de sprite de véhicules (8 directions)
            if angle < 22.5 and angle >= -22.5 then
                seq = self.vehiculeActif.."Side"
                sca = -sca
                -- print("right")
            elseif angle < 67.5 and angle >= 22.5 then
                seq = self.vehiculeActif.."DownSide"
                -- print("down Right")
            elseif angle < 112.5 and angle >= 67.5 then
                seq =self.vehiculeActif.."Down"
                -- print("down")
            elseif angle < 157.5 and angle >= 112.5 then
                seq = self.vehiculeActif.."DownSide"
                sca = -sca
                -- print("down Left")
            elseif angle > 157.5 or angle < -157.5 then
                seq = self.vehiculeActif.."Side"
                -- print("left")
            elseif angle >= -157.5 and angle < -112.5 then
                seq = self.vehiculeActif.."TopSide"
                sca = -sca
                -- print("up Left")
            elseif angle >= -112.5 and angle <- 67.5 then
                seq = self.vehiculeActif.."Top"
                -- print("up")
            elseif angle >= -67.5 and angle < -22.5 then
                seq = self.vehiculeActif.."TopSide"
                -- print("up Right")
            else print(angle)
            end
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
            if self.vitModif == vehicules.marche.mod and audio.isChannelActive( 5 ) == false then
                audio.play( sfxVehicules[self.vehiculeActif], { channel=5 } )
            end
        else
            self.avatar:setSequence(seq.."_idle")
            self.avatar:pause()
            if self.vitModif == vehicules.marche.mod then
                audio.stop( 5 )
            end
        end
    end

    -- Change la vitesse de déplacement du personnage et son visuel selon le véhicule passé en paramètre
    function perso:changerVehicule( vehicule )
        if vehicule ~= self.vehiculeActif and self.destination == nil then
            local function listener()
                if self.type~="dead" then
                    audio.play( sfxVehicules[vehicule], { channel=5, loops=-1 } )
                end
            end
            
            -- Visuel du personnage
            self.avatar:removeSelf()
            if vehicule == "marche" then
                self.avatar = display.newSprite(self, marcheImageSheet, spriteSheetPerso:getSpriteIndex())
            elseif vehicule == "scooter" then
                self.avatar = display.newSprite(self, scooterImageSheet, spriteSheetScooter:getSpriteIndex())
            elseif vehicule == "voiture" then
                self.avatar = display.newSprite(self, voitureImageSheet, spriteSheetVoiture:getSpriteIndex())
            end
            -- Vitesse
            self.vitModif = vehicules[vehicule].mod
            audio.stop( 5 )
            if vehicule ~= "marche" then
                audio.play( sfxVehicules[vehicule.."Start"], { channel=5, onComplete=listener } )
            elseif self.vehiculeActif ~= "marche" then
                audio.play( sfxVehicules[self.vehiculeActif.."Off"], { channel=6 } )
            end
            self.vehiculeActif = vehicule

            -- Suppression et réinstanciation du corps de physique
            timer.performWithDelay(1,function()
                physics.removeBody( self )
                local w,h
                local bodyShape
                if vehicule == "marche" then
                    w,h = self.width/2,self.height/2
                    bodyShape = { w-10,h-10,  w,h,  w,h+h/2-10,  w-10,h+h/2,  -w+10,h+h/2,  -w,h+h/2-10,  -w,h,  -w+10,h-10 }
                elseif vehicule == "scooter" then
                    w,h = self.width/2*vehicules[vehicule].size,self.height*vehicules[vehicule].size
                    bodyShape = { w-10,h-100,  w,h-90,  w,h+h/2-110,  w-10,h+h/2-100,  -w+10,h+h/2-100,  -w,h+h/2-110,  -w,h-90,  -w+10,h-100 }
                elseif vehicule == "voiture" then
                    w,h = self.width/2*vehicules[vehicule].size,self.height*vehicules[vehicule].size
                    bodyShape = { w+20-10,h-180,  w+20,h-170,  w+20,h+h/2-160,  w+20-10,h+h/2-150,  -w-20+10,h+h/2-150,  -w-20,h+h/2-160,  -w-20,h-170,  -w-20+10,h-180 }
                end
                physics.addBody( perso, { density=1, friction=1, bounce=0, shape=bodyShape } )
                perso.isFixedRotation = true
            end)

            self:assombrir( infos:getHeure() )
        end
    end

    -- Consommation d'un objet dans l'inventaire, donne de l'énergie et réduit le nombre en inventaire
    -- @params aliment  String  Nom de l'aliment consommé
    function perso:consommer( aliment )
        if self.inventaire[aliment].nb > 0 then
            self:setEnergie( self.inventaire[aliment].nrg )
            infos:updateEnergie()
            self.inventaire[aliment].nb = self.inventaire[aliment].nb - 1
        else
            print("rupture de stock")
        end
        infos:updateInventaire()
    end

    ------ Setters  ------------------------------------------------------------------------------

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

    function perso:setDestination( destination )
        self.destination = destination
    end

    function perso:collision(e)
        if e.phase=="began" then
            if e.other.type=="porte" then
                jeu:entrerBatiment(e.other.destination)
            elseif e.other.type=="auto" then
                audio.play(sfxCrash, {channel=20})
                jeu:kill()
            end
        end
    end

    -- Assombri/éclairci le monde en contrôlant l'opacité du filtre nocturne
    function perso:assombrir(heure)
        if heure > 12 then
            self.avatar:setFillColor( (heure-17)*8/-100+1 )
        else
            if heure < 4 then
                self.avatar:setFillColor( (7)*8/-100+1 )
            else
                self.avatar:setFillColor( (13-heure*2)*8/-100+1 )
            end
        end
    end

    -- Suppression des écouteurs et des sons
    function perso:kill()
        audio.stop( 5 )
        self.type = "dead"
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