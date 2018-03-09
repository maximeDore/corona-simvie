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
    -- Tableau contenant les objets en vente et leur prix (index : 1-3 = dépanneur, 4-6 = magasin)
    local objets = {
        -- Objets d'énergie (dépanneur)
        { nom = "Cafe", prix = 5, energie = 6 },
        { nom = "Barre d'energie", prix = 10, energie = 10 },
        { nom = "Boisson energisante", prix = 20, energie = 25 },
        -- Objets de qualité de vie
        { nom = "Tapis roulant", prix = 1 },    --750
        { nom = "scooter", prix = 1 },          --500
        { nom = "voiture", prix = 1 },          --1500
        { nom = "loft", prix = 1 }              --3500
    }
    -- Tableau contenant des tableaux, contenant le nom de l'endroit et le texte affiché dans les boutons
    local tSrc = { 
        gym =           { titre = "Gym", bg = "bg.jpg", bt1 = "Courir", bt1desc = "+1 force", bt2 = "S'entrainer", bt2desc = "+2 Force, -20$", bt3 = "Steroides", bt3desc = "? For (chance)" },
        universite =    { titre = "Universite", bg = "bg.jpg", bt1 = "Etudier", bt1desc = "+1 intelligence", bt2 = "Classe", bt2desc = "+2 int, -20$", bt3 = "Tricher", bt3desc = "?int (chance)"},
        depanneur =     { titre = "Depanneur", bg = "bg.jpg", bt1 = "Cafe", bt1desc = "+5 nrg, -"..objets[1].prix.."$", bt2 = "Barre d'nrg", bt2desc = "+10 nrg, -"..objets[2].prix.."$", bt3 = "Boisson NRG", bt3desc = "+25 nrg, -"..objets[3].prix.."$" },
        magasin =       { titre = "Magasin", bg = "bg.jpg", bt1 = "Tapis Roulant", bt1desc = objets[4].prix.."$", bt2 = "Mobilette", bt2desc = "+12.5 vit, -"..objets[5].prix.."$", bt3 = "Voiture", bt3desc = "+20 vit, -"..objets[6].prix.."$" },
        banque =        { titre = "Banque", bg = "bg.jpg", bt1 = "Deposer", bt2 = "Retirer" },
        appartement =   { titre = "Appartement", bg = "bgAppartement.png", bt1 = "Dormir", bt1desc = "+80 nrg, +9h", bt2 = "Sieste", bt2desc = "+5 nrg, +1h", bt3 = "S'entrainer", bt3desc = "+1 For" },
        loft =          { titre = "Loft", bg = "bg.jpg", bt1 = "Dormir", bt1desc = "+100 nrg, +9h", bt2 = "Sieste", bt2desc = "+5 nrg, +1h", bt3 = "S'entrainer", bt3desc = "+1 For"},
        centresportif = { titre = "Centre Sportif", bg = "bgCentreSportif.png", bt1 = "Travailler", bt1desc = "$$$", bt2 = "Demander", bt2desc = "une promotion"},
        faculte =       { titre = "Faculte des sciences", bg = "bgFaculte.png", bt1 = "Travailler", bt1desc = "$$$", bt2 = "Demander", bt2desc = "une promotion"}
    }
    if perso.carriere == "sciences" then
        tSrc.magasin.bt1 = "Bibliotheque"
        tSrc.loft.bt3 = "Etudier"
        tSrc.loft.bt3desc = "+1 Intelligence"
        tSrc.appartement.bt3 = "Etudier"
        tSrc.appartement.bt3desc = "+1 Intelligence"
    end
    
    function interieur:init()
        jeu:insert(self)

        -- Abréviation
        print(destination)
        local src = tSrc[destination]

        for i=1,#perso.inventaire do
            print(perso.inventaire[i])
        end


        -- Fond d'écran
        local bg
        if src.bg == "bg.jpg" then
            bg = display.newRect(self, display.contentCenterX, display.contentCenterY, display.contentWidth-display.screenOriginX*2, display.contentHeight-display.screenOriginY)
        else 
            bg = display.newImageRect(self, src.bg, display.contentWidth-display.screenOriginX*2, display.contentHeight-display.screenOriginY)
            bg.x = display.contentCenterX
            bg.y = display.contentCenterY
        end

        -- Fonctions locales des boutons
        local function retour()
            jeu:sortirBatiment()
            self:kill()
        end
        local function ajouterFor( pt )
            if infos:getHeure() < 6 or (table.indexOf(perso.inventaire, "Tapis roulant") == nil and (destination=="appartement" or destination=="loft")) then
                retroaction.text = "Il est trop tot pour s'entrainer."
            elseif infos:getHeure() < 22 then
                if pt==1 then
                    if perso:setEnergie( -10 ) then
                        perso.forNum = perso.forNum + pt
                        retroaction.text = "Vous devenez plus fort : +"..pt.." Force"
                        infos:updateHeure(1)
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                elseif pt==2 and perso.money-20>=0 then
                    if perso:setEnergie( -10 ) then
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
                    if perso:setEnergie( -10 ) then
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
            if infos:getHeure() < 6 and (destination~="appartement" or destination~="loft") then
                retroaction.text = "Il est trop tot pour etudier."
            elseif infos:getHeure() < 22 or destination=="appartement" or destination=="loft" then
                if pt==1 then
                    if perso:setEnergie( -10 ) then
                        perso.intNum = perso.intNum + pt
                        retroaction.text = "Vous devenez plus intelligent : +"..pt.." Int"
                        infos:updateHeure(1)
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                elseif pt==2 and perso.money-20>=0 then
                    if perso:setEnergie( -10 ) then
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
                    if perso:setEnergie( -10 ) then
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
                    if objets[i].nom == "voiture" and table.indexOf( perso.inventaire, "loft" ) ~= nil or objets[i].nom ~= "voiture" then
                        if table.indexOf( perso.inventaire, objets[i].nom ) == nil then
                            table.insert( perso.inventaire, objet.nom )
                            perso:setMoney( -objet.prix )
                            retroaction.text = "Vous achetez un(e) "..objet.nom.." pour "..objet.prix.." $."
                            infos:updateBoutons()
                        else
                            retroaction.text = "Vous possedez deja ceci."
                        end
                    else 
                        retroaction.text = "Vous devez posseder un loft pour acheter une voiture."
                    end
                else
                    retroaction.text = "Vous achetez un(e) "..objet.nom.." pour "..objet.prix.." $."
                    perso:setMoney( -objet.prix )
                    perso:setEnergie( objet.energie )
                end
                if objet.nom == "loft" then
                    retour()
                    jeu:entrerBatiment(destination)
                end
            else
                retroaction.text = "Vous n'avez pas assez d'argent."
            end
        end

        -- enlève du temps (5h) et donne de l'argent en fonction du poste du joueur
        local function travailler()
            if (perso.carriere == "sciences" and destination == "faculte") or (perso.carriere == "sports" and destination == "centresportif") then
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
        end

        -- Augmente l'indice de carrière du personnage s'il a assez de points d'aptitudes
        local function promotion()
            local emploi = infos:getEmploi()
            if perso.carriere == "sciences" then
                print("actuel : "..perso.intNum, "requis : "..emploi.apt)
                if perso.intNum >= emploi.apt then
                    if emploi.apt ~= infos:getEmploi().apt then
                        retroaction.text = "Promotion : "..infos:getEmploi().titre
                        infos:promotion()
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

        -- Avance le temps de 9h et donne 80% d'énergie ou 100% si loft est acheté
        local function dormir()
            retroaction.text = "Vous dormez pendant 9 heures."
            infos:updateHeure(9)
            if destination ~= "loft" then
                perso:setEnergie(80)
            else 
                perso:setEnergie(100)
            end
        end

        local function attendre( h )
            infos:updateHeure(h)
            perso:setEnergie(5)
        end

        -- retire une somme du compte en banque
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
                retroaction.text = "Veuillez entrer une valeur dans le champ texte."
            end
        end

        -- dépose une somme dans le compte en banque
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
            appartement =    { bt1 = dormir, bt1param = 1, bt2 = attendre, bt2param = 1, bt3 = ajouterFor, bt3param = 1 },
            loft =           { bt1 = dormir, bt1param = 1, bt2 = attendre, bt2param = 1, bt3 = ajouterFor, bt3param = 1 },
            centresportif =  { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 },
            faculte =        { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 }
        }
        if perso.carriere == "sciences" then
            tFunc.appartement.bt3 = ajouterInt
            tFunc.appartement.bt3param = 1
            tFunc.loft.bt3 = ajouterInt
            tFunc.loft.bt3param = 1
        end

        local func = tFunc[destination]

        -- Affichage de l'interface et des boutons

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
        -- Si le perso entre dans un bâtiment qui n'est pas le loft ou qu'il a acheté le loft
        if destination ~= "loft" or table.indexOf( perso.inventaire, "loft" ) ~= nil then
            if destination == "appartement" and table.indexOf( perso.inventaire, "Tapis roulant") == nil then
                src.bt3 = nil
            end
            -- Si le perso entre dans l'appartement et qu'il a acheté le loft
            if destination == "appartement" and table.indexOf( perso.inventaire, "loft" ) ~= nil then
                btRetour.x = display.contentCenterX
                btRetour.y = display.contentCenterY*1.25
                retroaction.text = "Vous n'habitez plus ici desormais."
            -- Si le perso entre dans un bâtiment de travail et qu'il ne travaille pas là
            elseif (perso.carriere == "sports" and destination == "faculte") or (perso.carriere == "sciences" and destination == "centresportif") then
                btRetour.x = display.contentCenterX
                btRetour.y = display.contentCenterY*1.25
                retroaction.text = "Vous ne travaillez pas ici."
            else
                local bt1 = cBouton:init(src.bt1,src.bt1desc,display.contentCenterX/1.65,display.contentCenterY,func.bt1,func.bt1param)
                self:insert(bt1)
                -- S'il y a un troisième bouton à générer
                if src.bt3~=nil then
                    local bt3 = cBouton:init(src.bt3,src.bt3desc,display.contentCenterX/1.65,display.contentCenterY*1.5,func.bt3,func.bt3param)
                    self:insert(bt3)
                -- Si le bâtiment n'est pas la banque
                elseif destination ~= "banque" then
                    if src.bt2==nil then
                        btRetour.y = bt1.y
                    else
                        btRetour.x = bt1.x
                    end
                end
                -- S'il y a un deuxième bouton à générer
                if src.bt2~=nil then
                    local bt2 = cBouton:init(src.bt2,src.bt2desc,display.contentCenterX*1.4,display.contentCenterY,func.bt2,func.bt2param)
                    self:insert(bt2)
                end
            end
        -- Si le joueur n'a pas acheté le loft
        elseif destination == "loft" and table.indexOf( perso.inventaire, "loft" ) == nil then 
            local bt1 = cBouton:init("Acheter loft",objets[7].prix.."$",display.contentCenterX/1.65,display.contentCenterY,acheter,7)
            btRetour.y = bt1.y
            self:insert(bt1)
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