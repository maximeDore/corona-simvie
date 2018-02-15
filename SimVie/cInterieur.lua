-----------------------------------------------------------------------------------------
--
-- cInterieur.lua
--
-----------------------------------------------------------------------------------------
local Interieur = {}

function Interieur:init(destination,jeu,map)

    local interieur = display.newGroup()
    local cJeu = require("cJeu")
    local cBouton = require("cBouton")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )
    local retroaction
    -- Tableau contenant des tableaux, contenant les noms de fichier pour les images des boutons et du fond selon la destination
    local tSrc = { 
        gym =           { titre = "Gym", bg = "bg.jpg", bt1 = "btCourir.png", bt2 = "btEntrainer.png", bt3 = "btSteroides.png" },
        universite =    { titre = "Universite", bg = "bg.jpg", bt1 = "btEtudier.png", bt2 = "btClasse.png", bt3 = "btTricher.png" },
        depanneur =     { titre = "Depanneur", bg = "bg.jpg", bt1 = "btFleche.png", bt2 = "btFleche.png", bt3 = "btFleche.png" },
        banque =        { titre = "Banque", bg = "bg.jpg", bt1 = "btFleche.png", bt2 = "btFleche.png", bt3 = "btFleche.png" },
        appartement =   { titre = "Appartement", bg = "bg.jpg", bt1 = "btContinuer.png" },
        centresportif = { titre = "Centre Sportif", bg = "bg.jpg", bt1 = "btTravailler.png", bt2 = "btPromotion.png" },
        faculte =       { titre = "Faculte des sciences", bg = "bg.jpg", bt1 = "btTravailler.png", bt2 = "btPromotion.png" }
    }
    
    function interieur:init()
        jeu:insert(self)
        -- local bgMusicChannel = audio.play( bgMusic, { channel=2, loops=-1, fadein=2000 } )
        -- local bg = display.newImage("bg.jpg",display.contentCenterX,display.contentCenterY)

        -- Abréviation
        local src = tSrc[destination]

        -- Fonctions locales des boutons
        local function retour()
            jeu:sortirBatiment()
            self:kill()
        end
        local function ajouterFor(pt)
            if infos:getHeure() ~= 24 then
                retroaction.text = "Vous devenez plus fort : +"..pt.." Force"
                if pt==1 then
                    _G.forNum = _G.forNum + pt
                    infos:updateHeure(1)
                elseif pt==2 and infos:getMoney()-20>=0 then
                    infos:setMoney(-20)
                    _G.forNum = _G.forNum + pt
                    infos:updateHeure(1)
                elseif pt==3 then
                    infos:updateHeure(1)
                    local rand = math.random(30)
                    print(rand, _G.chaNum)
                    if rand < _G.chaNum then
                        random = math.random(3,6)
                        _G.forNum = _G.forNum + random
                        retroaction.text = "Vous devenez plus fort : +"..random.." Force"
                        print(_G.forNum)
                    else
                        random = math.random(3)
                        _G.forNum = _G.forNum - random
                        if _G.forNum < 0 then
                            _G.forNum = 0
                        end
                        retroaction.text = "Vous perdez votre masculinite : -"..random.." Force"
                        print(_G.forNum)
                    end
                end
            end
        end

        local function ajouterInt(pt)
            if infos:getHeure() ~= 24 then
                retroaction.text = "Vous devenez plus intelligent : +"..pt.." Int"
                if pt==1 then
                    _G.intNum = _G.intNum + pt
                    infos:updateHeure(1)
                elseif pt==2 and infos:getMoney()-20>=0 then
                    infos:setMoney(-20)
                    _G.intNum = _G.intNum + pt
                    infos:updateHeure(1)
                elseif pt==3 then
                    infos:updateHeure(1)
                    local rand = math.random(30)
                    print(rand, _G.chaNum)
                    if rand < _G.chaNum then
                        random = math.random(3,6)
                        _G.intNum = _G.intNum + random
                        retroaction.text = "Vous trichez avec succes : +"..random.." int"
                        print(_G.intNum)
                    else
                        random = math.random(3)
                        _G.intNum = _G.intNum - random
                        if _G.intNum < 0 then
                            _G.intNum = 0
                        end
                        retroaction.text = "Vous vous faites prendre : -"..random.." int"
                        print(_G.intNum)
                    end
                end
            end
        end

        --acheter un objet selon l'index de l'objet
        local function acheter(i)
            print("achat object #"..i)
        end

        -- enlève du temps (5h) et donne de l'argent en fonction du poste du joueur
        local function travailler()
            print(infos:getJour())
            if infos:getJour() ~= "Dimanche" then
                if(infos:getHeure()<=19) then
                    infos:updateHeure(5)
                    -- Détecter le niveau de carriere du perso
                    emploiIndex = infos:getEmploiIndex()
                    print(emploiIndex)
                    infos:setMoney( 4 * emploiIndex/2 * 5 )
                else 
                    retroaction.text = "Il est trop tard pour travailler."
                end
            else
                retroaction.text = "Cet endroit n'ouvre pas les dimanches."
            end
        end

        -- Augmente l'indice de carrière du personnage s'il a assez de points d'aptitudes
        local function promotion()
            local emploi = infos:getEmploi()
            if _G.carriere == "sciences" then
                print("actuel : ".._G.intNum, "requis : "..emploi.apt)
                if _G.intNum >= emploi.apt then
                    infos:promotion()
                    retroaction.text = "Promotion : "..infos:getEmploi().titre
                else
                    retroaction.text = "Il vous manque "..infos:getEmploi().apt-_G.intNum.." d'Int pour etre promu."
                end
            else
                print("actuel : ".._G.forNum, "requis : "..emploi.apt)
                if _G.forNum >= emploi.apt then
                    infos:promotion()
                    retroaction.text = "Promotion : "..infos:getEmploi().titre
                else
                    retroaction.text = "Il vous manque "..infos:getEmploi().apt-_G.forNum.." de Force pour etre promu."
                end
            end
        end

        -- change de journée, reset le temps et sauvegarde
        local function dormir()
            infos:prochainJour()
        end

        -- à repenser, fonction pour retirer une somme définie par des boutons-flèches?
        local function retirer(somme)
        end

        -- à repenser, fonction pour déposer une somme définie par des boutons-flèches?
        local function deposer(somme)
        end

        -- tableau des fonctions des boutons selon la destination
        local tFunc = {
            gym =            { bt1 = ajouterFor, bt1param = 1, bt2 = ajouterFor, bt2param = 2, bt3= ajouterFor, bt3param = 3 },
            universite =     { bt1 = ajouterInt, bt1param = 1, bt2 = ajouterInt, bt2param = 2, bt3= ajouterInt, bt3param = 3 },
            depanneur =      { bt1 = acheter, bt1param = 1, bt2 = acheter, bt2param = 2, bt3= acheter, bt3param = 3 },
            banque =         { bt1 = retirer, bt1param = 1, bt2 = deposer, bt2param = 2, bt3= nil, bt3param = nil },
            appartement =    { bt1 = dormir, bt1param = 1 },
            centresportif =  { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 },
            faculte =        { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 }
        }

        local func = tFunc[destination]

        -- Affichage de l'interface et des boutons
        local bg = display.newRect(self,display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight)
        -- local bg = display.newImage(self,src.bg,display.contentCenterX,display.contentCenterY)

        local optionsTitre = {
            text = src.titre,
            x = display.contentCenterX,
            y = display.contentCenterY/2.75,
            font = "Diskun.ttf",
            fontSize = 100,
            align = "center"  -- Alignment parameter
        }
        local titre = display.newText( optionsTitre )
        titre:setFillColor(1,0,0)

        -- Message de rétroaction selon l'interaction du joueur
        local optionsRetroaction = {
            text = "",
            x = display.contentCenterX,
            y = display.contentCenterY/1.6,
            font = "Diskun.ttf",   
            fontSize = 50,
            align = "center"  -- Alignment parameter
        }
        retroaction = display.newText( optionsRetroaction )
        retroaction:setFillColor(1,0,0)
        
        local btRetour = cBouton:init("btRetour.png",display.contentCenterX*1.4,display.contentCenterY*1.5,retour)
        local bt1 = cBouton:init(src.bt1,display.contentCenterX/1.65,display.contentCenterY,func.bt1,func.bt1param)
        if src.bt3~=nil then
            local bt3 = cBouton:init(src.bt3,display.contentCenterX/1.65,display.contentCenterY*1.5,func.bt3,func.bt3param)
            self:insert(bt3)
        else
            if src.bt2==nil then
                btRetour.y = bt1.y
            else
                btRetour.x = bt1.x
            end
        end
        if src.bt2~=nil then
            local bt2 = cBouton:init(src.bt2,display.contentCenterX*1.4,display.contentCenterY,func.bt2,func.bt2param)
            self:insert(bt2)
        end

        -- Insertion du visuel
        self:insert(titre)
        self:insert(retroaction)
        self:insert(bt1)
        self:insert(btRetour)
    end

    function interieur:kill()
        bgMusicChannel = audio.stop(2)
    end

    interieur:init()
    return interieur
end

return Interieur