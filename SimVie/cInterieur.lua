-----------------------------------------------------------------------------------------
--
-- cInterieur.lua
--
-----------------------------------------------------------------------------------------
local Interieur = {}

function Interieur:init( destination, jeu, map, perso )

    local interieur = display.newGroup()
    local cJeu = require("cJeu")
    local cBouton = require("cBouton")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )
    local retroaction
    local inputBanque
    -- Tableau contenant des tableaux, contenant les noms de fichier pour les images des boutons et du fond selon la destination
    local tSrc = { 
        gym =           { 
            titre = "Gym", bg = "bg.jpg", bt1 = "Courir", bt1desc = "+1 force", bt2 = "S'entrainer", bt2desc = "+2 Force, -20$", bt3 = "Steroides", bt3desc = "? For (chance)" 
        },
        universite =    {
             titre = "Universite", bg = "bg.jpg", bt1 = "Etudier", bt1desc = "+1 intelligence", bt2 = "Classe", bt2desc = "+2 int, -20$", bt3 = "Tricher", bt3desc = "?int (chance)"
        },
        depanneur =     {
             titre = "Depanneur", bg = "bg.jpg", bt1 = "Cafe", bt1desc = "+5 nrg, -5$", bt2 = "Barre d'nrg", bt2desc = "+10 nrg, -10$", bt3 = "Boisson NRG", bt3desc = "+25 nrg, -25$" 
        },
        magasin =       {
             titre = "Magasin", bg = "bg.jpg", bt1 = "bt.png", bt1desc = "", bt2 = "Mobilette", bt2desc = "+15 vit, -500$", bt3 = "Voiture", bt3desc = "+20 vit, -1500$" 
        },
        banque =        {
             titre = "Banque", bg = "bg.jpg", bt1 = "Deposer", bt2 = "Retirer" 
        },
        appartement =   {
             titre = "Appartement", bg = "bg.jpg", bt1 = "Dormir", bt1desc = "+80 nrg, +9h", bt2 = "Sieste", bt2desc = "+5 nrg, +1h" 
        },
        centresportif = {
             titre = "Centre Sportif", bg = "bg.jpg", bt1 = "Travailler", bt1desc = "$$$", bt2 = "Demander", bt2desc = "une promotion"
        },
        faculte =       {
             titre = "Faculte des sciences", bg = "bg.jpg", bt1 = "Travailler", bt1desc = "$$$", bt2 = "Demander", bt2desc = "une promotion"
        }
    }
    -- Tableau contenant les objets en vente et leur prix (1-3 = dépanneur, 4-6 = magasin)
    local objets = {
        { nom = "Cafe", prix = 5, energie = 5 },
        { nom = "Barre d'energie", prix = 10, energie = 10 },
        { nom = "Boisson energisante", prix = 25, energie = 25 },
        { nom = "Tapis roulant", prix = 15 },
        { nom = "scooter", prix = 500 },
        { nom = "voiture", prix = 1500 }
    }
    
    function interieur:init()
        jeu:insert(self)
        -- local bgMusicChannel = audio.play( bgMusic, { channel=2, loops=-1, fadein=2000 } )
        -- local bg = display.newImage("bg.jpg",display.contentCenterX,display.contentCenterY)

        -- Abréviation
        print(destination)
        local src = tSrc[destination]
        -- Fonctions locales des boutons
        local function retour()
            jeu:sortirBatiment()
            self:kill()
        end
        local function ajouterFor( pt )
            if infos:getHeure() < 6 then
                retroaction.text = "Il est trop tot pour s'entrainer."
            elseif infos:getHeure() < 22 then
                if pt==1 then
                    if perso:setEnergie( -5 ) then
                        perso.forNum = perso.forNum + pt
                        retroaction.text = "Vous devenez plus fort : +"..pt.." Force"
                        infos:updateHeure(1)
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                elseif pt==2 and perso.money-20>=0 then
                    if perso:setEnergie( -5 ) then
                        perso:setMoney(-20)
                        perso.forNum = perso.forNum + pt
                        retroaction.text = "Vous devenez plus fort : +"..pt.." Force"
                        infos:updateHeure(1)
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                elseif pt==2 then
                    retroaction.text = "Vous n'avez pas assez d'argent pour vous entrainer."
                elseif pt==3 then
                    if perso:setEnergie( -5 ) then
                        infos:updateHeure(1)
                        local rand = math.random(25)
                        print(rand, perso.chaNum)
                        if rand < perso.chaNum then
                            random = math.random(5)
                            perso.forNum = perso.forNum + random
                            retroaction.text = "Vous devenez plus fort : +"..random.." Force"
                            print(perso.forNum)
                        else
                            random = math.random(3)
                            perso.forNum = perso.forNum - random
                            if perso.forNum < 0 then
                                perso.forNum = 0
                            end
                            retroaction.text = "Vous perdez votre masculinite : -"..random.." Force"
                        end
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                end
                print(perso.forNum)
                infos:updateStats( perso )
            else
                retroaction.text = "Il est trop tard pour s'entrainer."
            end
        end

        local function ajouterInt( pt )
            if infos:getHeure() < 6 then
                retroaction.text = "Il est trop tot pour etudier"
            elseif infos:getHeure() < 22 then
                if pt==1 then
                    if perso:setEnergie( -5 ) then
                        perso.intNum = perso.intNum + pt
                        retroaction.text = "Vous devenez plus intelligent : +"..pt.." Int"
                        infos:updateHeure(1)
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                elseif pt==2 and perso.money-20>=0 then
                    if perso:setEnergie( -5 ) then
                        perso:setMoney(-20)
                        perso.intNum = perso.intNum + pt
                        retroaction.text = "Vous devenez plus intelligent : +"..pt.." Int"
                        infos:updateHeure(1)
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                elseif pt==2 then
                    retroaction.text = "Vous n'avez pas assez d'argent pour assister au cours."
                elseif pt==3 then
                    if perso:setEnergie( -5 ) then
                        infos:updateHeure(1)
                        local rand = math.random(25)
                        print(rand, perso.chaNum)
                        if rand < perso.chaNum then
                            random = math.random(5)
                            perso.intNum = perso.intNum + random
                            retroaction.text = "Vous trichez avec succes : +"..random.." int"
                            print(perso.intNum)
                        else
                            random = math.random(3)
                            perso.intNum = perso.intNum - random
                            if perso.intNum < 0 then
                                perso.intNum = 0
                            end
                            retroaction.text = "Vous vous faites prendre : -"..random.." int"
                        end
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                end
                print(perso.intNum)
                infos:updateStats( perso )
            else
                retroaction.text = "Il est trop tard pour etudier."
            end
        end

        --acheter un objet selon l'index de l'objet
        local function acheter( i )
            local objet = objets[i]
            if objet.prix <= perso.money then
                if objet.energie == nil then
                    table.insert( perso.inventaire, objet.nom )
                else
                    perso:setEnergie( objet.energie )
                end
                retroaction.text = "Vous achetez un(e) "..objet.nom.." pour "..objet.prix.." $."
                perso:setMoney( -objet.prix )
            else
                retroaction.text = "Vous n'avez pas assez d'argent."
            end
        end

        -- enlève du temps (5h) et donne de l'argent en fonction du poste du joueur
        local function travailler()
            if infos:getJour() ~= "Dimanche" then
                if infos:getHeure() < 8 then
                    retroaction.text = "Il est trop tot pour travailler."
                elseif infos:getHeure() <= 16 then
                    if perso:setEnergie( -30 ) then
                        infos:updateHeure(5)
                        -- Détecter le niveau de carriere du perso
                        emploiIndex = infos:getEmploiIndex()
                        perso:setMoney( 4 * emploiIndex/2 * 6 )
                        retroaction.text = "Vous travailler pendant 5 heures."
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
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
            if perso.carriere == "sciences" then
                print("actuel : "..perso.intNum, "requis : "..emploi.apt)
                if perso.intNum >= emploi.apt then
                    infos:promotion()
                    if emploi.apt ~= infos:getEmploi().apt then
                        retroaction.text = "Promotion : "..infos:getEmploi().titre
                    else 
                        retroaction.text = "Vous occupez le poste le plus important imaginable."
                    end
                else
                    retroaction.text = "Il vous manque "..infos:getEmploi().apt-perso.intNum.." d'Int pour etre promu."
                end
            else
                print("actuel : "..perso.forNum, "requis : "..emploi.apt)
                if perso.forNum >= emploi.apt then
                    infos:promotion()
                    if emploi.apt ~= infos:getEmploi().apt then
                        retroaction.text = "Promotion : "..infos:getEmploi().titre
                    else 
                        retroaction.text = "Vous occupez le poste le plus important imaginable."
                    end
                else
                    retroaction.text = "Il vous manque "..infos:getEmploi().apt-perso.forNum.." de Force pour etre promu."
                end
            end
        end

        -- change de journée, reset le temps et sauvegarde
        local function dormir()
            retroaction.text = "Vous dormez pendant 9 heures."
            infos:updateHeure(9)
            perso:setEnergie(80)
        end

        local function attendre( h )
            infos:updateHeure(h)
            perso:setEnergie(5)
        end

        -- à repenser, fonction pour retirer une somme définie par des boutons-flèches?
        local function retirer()
            if inputBanque.text ~= "" then
                local montant = tonumber( inputBanque.text )
                if perso.banque >= montant then
                    perso:setMoney(montant)
                    perso:setBanque(-montant)
                    retroaction.text = "Vous retirez "..montant.." $. Balance : "..perso.banque.." $."
                else
                    retroaction.text = "Fonds insuffisants. Vous avez "..perso.banque.." $ en banque."
                end
            else 
                retroaction.text = "Veuillez entrer une valeur dans le champ-texte."
            end
        end

        -- à repenser, fonction pour déposer une somme définie par des boutons-flèches?
        local function deposer()
            if inputBanque.text ~= "" then
                local montant = tonumber( inputBanque.text )
                if perso.money >= montant then
                    perso:setMoney(-montant)
                    perso:setBanque(montant)
                    retroaction.text = "Vous deposez "..montant.." $. Balance : "..perso.banque.." $."
                else
                    retroaction.text = "Fonds insuffisants. Vous avez "..perso.money.." $ sur vous."
                end
            else 
                retroaction.text = "Veuillez entrer une valeur dans le champ texte."
            end
        end

        -- tableau des fonctions des boutons selon la destination
        local tFunc = {
            gym =            { bt1 = ajouterFor, bt1param = 1, bt2 = ajouterFor, bt2param = 2, bt3= ajouterFor, bt3param = 3 },
            universite =     { bt1 = ajouterInt, bt1param = 1, bt2 = ajouterInt, bt2param = 2, bt3= ajouterInt, bt3param = 3 },
            depanneur =      { bt1 = acheter, bt1param = 1, bt2 = acheter, bt2param = 2, bt3= acheter, bt3param = 3 },
            magasin =        { bt1 = acheter, bt1param = 4, bt2 = acheter, bt2param = 5, bt3= acheter, bt3param = 6 },
            banque =         { bt1 = deposer, bt1param = 1, bt2 = retirer, bt2param = 2 },
            appartement =    { bt1 = dormir, bt1param = 1, bt2 = attendre, bt2param = 1 },
            centresportif =  { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 },
            faculte =        { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 }
        }

        local func = tFunc[destination]

        -- Affichage de l'interface et des boutons
        local bg = display.newRect(self,display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight)
        -- local bg = display.newImage(self,src.bg,display.contentCenterX,display.contentCenterY)

        -- Titre de l'endroit actuel
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
        
        local btRetour = cBouton:init("Retour",nil,display.contentCenterX*1.4,display.contentCenterY*1.5,retour)
        local bt1 = cBouton:init(src.bt1,src.bt1desc,display.contentCenterX/1.65,display.contentCenterY,func.bt1,func.bt1param)
        if src.bt3~=nil then
            local bt3 = cBouton:init(src.bt3,src.bt3desc,display.contentCenterX/1.65,display.contentCenterY*1.5,func.bt3,func.bt3param)
            self:insert(bt3)
        elseif destination ~= "banque" then
            if src.bt2==nil then
                btRetour.y = bt1.y
            else
                btRetour.x = bt1.x
            end
        end
        if src.bt2~=nil then
            local bt2 = cBouton:init(src.bt2,src.bt2desc,display.contentCenterX*1.4,display.contentCenterY,func.bt2,func.bt2param)
            self:insert(bt2)
        end

        -- Champ de texte pour la banque
        if destination == "banque" then
            inputBanque = native.newTextField( display.contentCenterX/1.65, display.contentCenterY*1.5, btRetour.width-10, btRetour.height/2 )
            inputBanque.inputType = "number"
            inputBanque.placeholder = "-Montant-"
            inputBanque.isFontSizeScaled = true
            inputBanque.font = native.newFont( "8-Bit Madness.ttf", 75 )
            inputBanque.align = "center"
            self:insert(inputBanque)
        end

        -- Insertion du visuel
        self:insert(titre)
        self:insert(retroaction)
        self:insert(bt1)
        self:insert(btRetour)
    end

    function interieur:kill()
        local function recursiveKill(group) -- fonction locale récursive appelant la fonction kill de chaque enfant (removeEventListeners)
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
        bgMusicChannel = audio.stop(2)
    end

    interieur:init()

    if inputBanque ~= nil then
        -- inputBanque:addEventListener( "userInput", testListener )
    end

    return interieur
end

return Interieur