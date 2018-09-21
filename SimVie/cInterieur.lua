-----------------------------------------------------------------------------------------
--
-- cInterieur.lua
--
-- Classe qui génère l'interface d'intérieur d'un bâtiment et qui gère son interactivité
--
-----------------------------------------------------------------------------------------
local Interieur = {}

function Interieur:init( destination, jeu, map, perso )

    local interieur = display.newGroup()
    local cJeu = require("cJeu")
    local cBouton = require("cBouton")
    local horaireDisplay
    local bt1
    local bt2
    local bt3
    local bt4
    local retroaction
    local inputBanque
    -- Tableau contenant les objets en vente et leur prix (index : 1-3 = dépanneur, 4+ = magasin)
    local objets = {
        -- Objets d'énergie (dépanneur)
        { nom = "Cafe", slug = "cafe", m = true, prix = 6, energie = 5, max = 5 },
        { nom = "Barre d'NRG", slug = "barreNrg", m = false, prix = 10, energie = 10, max = 5 },
        { nom = "Boisson NRG", slug = "boissonNrg", m = false, prix = 20, energie = 25, max = 2 },
        -- Objets de qualité de vie
        { nom = "Tapis roulant", slug = "tapisRoulant", m = true, prix = 750 },       --750
        { nom = "scooter", prix = 500, m = true },                                    --500
        { nom = "voiture", prix = 1500, m = false },                                  --1500
        { nom = "loft", prix = 3500, m = true }                                       --3500
    }
    local tHoraires = {
        gym =           { ouv = 6, ferm = 22 },
        universite =    { ouv = 6, ferm = 22 },
        -- depanneur =     { ouv = 0, ferm = 25 },
        magasin =       { ouv = 9, ferm = 18 },
        -- banque =        { ouv = 0, ferm = 25 },
        -- appartement =   { ouv = , ferm =  },
        -- loft =          { ouv = , ferm =  },
        centresportif = { ouv = 8, ferm = 16 },
        faculte =       { ouv = 8, ferm = 16 }
    }
    local evenement = infos:getEvenement()

    if evenement ~= nil and evenement[1].destination == "depanneur" and evenement[1].status == "rabais" then
        for i=1,3 do
            objets[i].prix = math.floor(objets[i].prix*0.8)
        end
    end
    if evenement ~= nil and evenement[1].destination == "magasin" and evenement[1].status == "rabais" then
        for i=4,6 do
            objets[i].prix = math.floor(objets[i].prix*0.9)
        end
    end
    if evenement ~= nil and evenement[1].destination == "loft" and evenement[1].status == "rabais" then
        objets[7].prix = math.floor(objets[7].prix*0.8)
    end
    -- Tableau contenant des tableaux, contenant le nom de l'endroit et le texte affiché dans les boutons
    local tSrc = { 
        gym =           { titre = "Gym", bg = "ressources/img/bgGym.png", bt1 = "Courir", bt1desc = "+1 force", bt2 = "S'entrainer", bt2desc = "+2 Force, -20$", bt3 = "Steroides", bt3desc = "? For (chance)" },
        universite =    { titre = "Universite", bg = "ressources/img/bgUniversite.png", bt1 = "Etudier", bt1desc = "+1 intelligence", bt2 = "Classe", bt2desc = "+2 int, -20$", bt3 = "Tricher", bt3desc = "?int (chance)" },
        depanneur =     { titre = "Depanneur", bg = "ressources/img/bg.jpg", bt1 = "Cafe", bt1desc = "+5 nrg, -"..objets[1].prix.."$", bt2 = "Barre d'nrg", bt2desc = "+10 nrg, -"..objets[2].prix.."$", bt3 = "Boisson NRG", bt3desc = "+25 nrg, -"..objets[3].prix.."$" },
        magasin =       { titre = "Magasin", bg = "ressources/img/bgMagasin.png", bt1 = "Tapis Roulant", bt1desc = "-"..objets[4].prix.."$", bt2 = "Mobilette", bt2desc = "+12.5 vit, -"..objets[5].prix.."$", bt3 = "Voiture", bt3desc = "+20 vit, -"..objets[6].prix.."$" },
        banque =        { titre = "Banque", bg = "ressources/img/bgBanque.png", bt1 = "Deposer", bt2 = "Retirer", bt4 = "Tout deposer" },
        appartement =   { titre = "Appartement", bg = "ressources/img/bgAppartement.png", bt1 = "Dormir", bt1desc = "+80 nrg, +9h", bt2 = "Sieste", bt2desc = "+5 nrg, +1h", bt3 = "S'entrainer", bt3desc = "+1 For" },
        loft =          { titre = "Loft", bg = "ressources/img/bg.jpg", bt1 = "Dormir", bt1desc = "+100 nrg, +9h", bt2 = "Sieste", bt2desc = "+5 nrg, +1h", bt3 = "S'entrainer", bt3desc = "+1 For" },
        centresportif = { titre = "Centre Sportif", bg = "ressources/img/bgCentreSportif.png", bt1 = "Travailler", bt1desc = "$$$", bt2 = "Demander", bt2desc = "une promotion" },
        faculte =       { titre = "Faculte des sciences", bg = "ressources/img/bgFaculte.png", bt1 = "Travailler", bt1desc = "$$$", bt2 = "Demander", bt2desc = "une promotion" }
    }
    if perso.carriere == "sciences" then
        objets[4].nom = "Bibliotheque"
        objets[4].m = false
        tSrc.magasin.bt1 = "Bibliotheque"
        tSrc.loft.bt3 = "Etudier"
        tSrc.loft.bt3desc = "+1 Intelligence"
        tSrc.appartement.bt3 = "Etudier"
        tSrc.appartement.bt3desc = "+1 Intelligence"
    end
    local attrStr = {
        force = { adj = "fort", gamble1 = "Vous depassez vos limites", gamble2 = "Vous perdez votre masculinite", verbe1 = "s'entrainer", verbe2 = "vous entrainer" },
        intelligence = { adj = "intelligent", gamble1 = "Vous trichez avec succes", gamble2 = "Vous vous faites prendre", verbe1 = "etudier", verbe2 = "assister au cours" }
    }
    
    -- Constructeur, affichage de l'interface d'intérieur de bâtiment selon la destination
    function interieur:init()
        jeu:insert(self)
        perso:changerVehicule( "marche" )
        perso:setDestination( destination )

        -- Abréviation
        local src = tSrc[destination]

        -- Fond d'écran
        local bg
        if src.bg == "ressources/img/bg.jpg" then
            bg = display.newRect(self, display.contentCenterX, display.contentCenterY, display.contentWidth-display.screenOriginX*2, display.contentHeight-display.screenOriginY)
        else 
            bg = display.newImageRect(self, src.bg, display.contentWidth-display.screenOriginX*2, display.contentHeight-display.screenOriginY)
            bg.x = display.contentCenterX
            bg.y = display.contentCenterY
        end

        -- Fonctions locales des boutons
        -- Sortir du bâtiment et revenir dans le monde
        local function retour()
            jeu:sortirBatiment()
            self:kill()
        end

        -- Si le perso entre dans un bâtiment fermé
        local function checkHoraire()
            if tHoraires[destination] ~= nil then
                local ouv = tHoraires[destination].ouv
                local ferm  = tHoraires[destination].ferm
                local heure = _G.infos:getHeure()
                
                if heure < ouv or heure >= ferm then
                    retroaction.text = "Cet etablissement est ferme."

                    retour()
                    jeu:entrerBatiment(destination)
                end
            end
        end
        -- Afficher l'horaire du bâtiment ou le cacher
        local function horaire()
            retroaction.text = ""
            -- Afficher l'horaire ici ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            if bt1 then
                bt1.isVisible = not bt1.isVisible
            end
            if bt2 then
                bt2.isVisible = not bt2.isVisible
            end
            if bt3 then
                bt3.isVisible = not bt3.isVisible
            end
            if bt4 then
                bt4.isVisible = not bt4.isVisible
            end

            horaireDisplay.isVisible = not horaireDisplay.isVisible
        end
        -- Augmenter/diminuer un attribut
        local function ajouterAttr( nom, attr, tStr, pt )
            -- if infos:getHeure() < 6 and destination ~= "appartement" and destination ~= "loft" then
            --     retroaction.text = "Il est trop tot pour "..tStr["verbe1"].."."
            -- elseif infos:getHeure() < 22 or destination=="appartement" or destination=="loft" then
                if pt==1 then
                    if perso:setEnergie( -10 ) then
                        perso[attr] = perso[attr] + pt
                        retroaction.text = "Vous devenez plus "..tStr["adj"].." : +"..pt.." "..nom
                        infos:updateHeure(1)
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                elseif pt==2 and perso.money-20>=0 then
                    if perso:setEnergie( -10 ) then
                        perso:setMoney(-20)
                        perso[attr] = perso[attr] + pt
                        retroaction.text = "Vous devenez plus "..tStr["adj"].." : +"..pt.." "..nom
                        infos:updateHeure(1)
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                elseif pt==2 then
                    retroaction.text = "Vous n'avez pas assez d'argent pour "..tStr["verbe2"].."."
                elseif pt==3 then
                    if perso:setEnergie( -10 ) then
                        infos:updateHeure(1)
                        local rand = math.random(25)
                        print(rand, perso.chaNum)
                        if rand < perso.chaNum then
                            random = math.random(5)
                            perso[attr] = perso[attr] + random
                            retroaction.text = tStr["gamble1"].." : +"..random.." "..nom
                            print(perso[attr])
                        else
                            random = math.random(3)
                            perso[attr] = perso[attr] - random
                            if perso[attr] < 0 then
                                perso[attr] = 0
                            end
                            retroaction.text = tStr["gamble2"].." : -"..random.." "..nom
                        end
                    else 
                        retroaction.text = "Vous n'avez pas assez d'energie."
                    end
                end
                print(perso.forNum, perso.intNum)
                infos:updateStats( perso )
            -- else
            --     retroaction.text = "Il est trop tard pour "..tStr["verb1"].."."
            -- end

            checkHoraire()
        end
        local function ajouterFor( pt )
            ajouterAttr( "Force", "forNum", attrStr["force"], pt )
        end
        local function ajouterInt( pt )
            ajouterAttr( "Intelligence", "intNum", attrStr["intelligence"], pt )
        end

        --acheter un objet selon l'index de l'objet
        local function acheter( i )
            local objet = objets[i]
            local nom = objet.nom
            if perso.inventaire[nom] == nil and objet.slug ~= nil then
                nom = objet.slug
                if perso.inventaire[nom] == nil then
                    perso.inventaire[nom] = false
                end
            elseif perso.inventaire[nom] == nil then
                perso.inventaire[objet.nom] = false
            elseif objet.slug ~= nil then
                perso.inventaire[objet.slug] = false
            end
            print(perso.inventaire[nom])

            if perso.inventaire[nom] == true then
                retroaction.text = "Vous possedez deja ceci."
            elseif perso.inventaire[nom] == nil then
                retroaction.text = "Erreur 204 : Pas de donnees a retourner"
            elseif objet.prix <= perso.money then
                if objet.energie == nil and nom ~= "loft" then
                    if nom == "voiture" and perso.inventaire["loft"] or nom ~= "voiture" then
                        if perso.inventaire[nom] == false then
                            perso.inventaire[nom] = true
                            perso:setMoney( -objet.prix )
                            retroaction.text = "Vous achetez un"..(objet.m and " " or "e ")..objet.nom.." pour "..objet.prix.." $."
                            infos:updateBoutons()
                        end
                    else 
                        retroaction.text = "Vous devez posseder un loft pour acheter une voiture."
                    end
                elseif nom == "loft" then
                    retour()
                    perso.inventaire[nom] = true
                    perso:setMoney( -objet.prix )
                    retroaction.text = "Vous achetez un(e) "..objet.nom.." pour "..objet.prix.." $."
                    jeu:entrerBatiment(destination)
                else
                    if objet.max > perso.inventaire[objet.slug].nb then
                        retroaction.text = "Vous achetez un"..(objet.m and " " or "e ")..objet.nom.." pour "..objet.prix.." $."
                        perso:setMoney( -objet.prix )
                        perso.inventaire[objet.slug].nb = perso.inventaire[objet.slug].nb + 1
                        infos:updateInventaire()
                    else 
                        print("max atteint")
                        retroaction.text = "Vous ne pouvez posseder plus de "..objet.max.." "..objet.nom.."s."
                    end
                end
            else
                retroaction.text = "Vous n'avez pas assez d'argent."
            end
        end

        -- enlève du temps (5h) et donne de l'argent en fonction du poste du joueur
        local function travailler()
            if (perso.carriere == "sciences" and destination == "faculte") or (perso.carriere == "sports" and destination == "centresportif") then
                -- if infos:getJour() ~= "Dimanche" then
                    -- if infos:getHeure() < 8 then
                    --     retroaction.text = "Il est trop tot pour travailler."
                    -- elseif infos:getHeure() <= 16 then
                        if perso:setEnergie( -30 ) then
                            infos:updateHeure(5)
                            -- Détecter le niveau de carriere du perso
                            emploiIndex = infos:getEmploiIndex()
                            perso:setMoney( 4 * emploiIndex/2 * 6 )
                            retroaction.text = "Vous travaillez pendant 5 heures."
                        else 
                            retroaction.text = "Vous n'avez pas assez d'energie."
                        end
                    -- else 
                    --     retroaction.text = "Il est trop tard pour travailler."
                    -- end
                -- else
                --     retroaction.text = "Cet endroit n'ouvre pas les dimanches."
                -- end
            end

            checkHoraire()
        end

        -- Augmente l'indice de carrière du personnage s'il a assez de points d'aptitudes
        local function promotion()
            local emploi = infos:getEmploi()
            if perso.carriere == "sciences" then
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
        local function deposer( all )
            if inputBanque.text ~= "" or all then
                local montant = tonumber( inputBanque.text )
                if all then
                    montant = perso.money
                end
                if perso.money >= montant and montant ~= 0 then
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
            banque =         { bt1 = deposer, bt1param = false, bt2 = retirer, bt2param = false, bt4 = deposer, bt4param = true },
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
            parent = self,
            text = src.titre,
            x = display.contentCenterX,
            y = display.contentCenterY/2.75,
            font = "ressources/fonts/Diskun.ttf",
            fontSize = 100,
            align = "center"  -- Alignment parameter
        }
        local titre = display.newText( optionsTitre )
        titre:setFillColor(1,0,0)

        -- Message de rétroaction selon l'interaction du joueur
        local optionsRetroaction = {
            parent = self,
            text = "",
            x = display.contentCenterX,
            y = display.contentCenterY/1.6,
            font = "ressources/fonts/Diskun.ttf",   
            fontSize = 50,
            align = "center"  -- Alignment parameter
        }
        retroaction = display.newText( optionsRetroaction )
        retroaction:setFillColor(1,0,0)
        
        local btRetour = cBouton:init("ressources/img/exit.png",nil,display.contentCenterX*1.4,display.contentCenterY*1.5,retour)
        btRetour.x = display.contentWidth - display.screenOriginX - 100
        btRetour.y = titre.y
        local btHoraire

        -- Affiche le bouton horaire si le bâtiment a un horaire
        if tHoraires[destination] ~= nil then
            btHoraire = cBouton:init("ressources/img/horaire.png",nil,display.contentCenterX*1.4,display.contentCenterY*1.5,horaire)
            self:insert(btHoraire)
            btHoraire.x = display.screenOriginX + 100
            btHoraire.y =  titre.y
            local dimancheHoraire
            if destination == "centresportif" or destination == "faculte" then
                dimancheHoraire = "Dim : Ferme"
            else
                dimancheHoraire = "Dim : "..tHoraires[destination].ouv.."h - "..tHoraires[destination].ferm.."h"
            end

            local optionsHoraire = {
                parent = self,
                text = dimancheHoraire.."\nLun : "..tHoraires[destination].ouv.."h - "..tHoraires[destination].ferm.."h"..
                    "\nMar : "..tHoraires[destination].ouv.."h - "..tHoraires[destination].ferm.."h"..
                    "\nMer : "..tHoraires[destination].ouv.."h - "..tHoraires[destination].ferm.."h"..
                    "\nJeu : "..tHoraires[destination].ouv.."h - "..tHoraires[destination].ferm.."h"..
                    "\nVen : "..tHoraires[destination].ouv.."h - "..tHoraires[destination].ferm.."h"..
                    "\nSam : "..tHoraires[destination].ouv.."h - "..tHoraires[destination].ferm.."h",
                x = display.contentCenterX,
                y = display.contentCenterY*1.3,
                font = "ressources/fonts/Diskun.ttf",   
                fontSize = 50,
                align = "center"  -- Alignment parameter
            }

            horaireDisplay = display.newText( optionsHoraire )
            horaireDisplay:setFillColor(1,0,0)
            horaireDisplay.isVisible = false
        end

        -- Insertion du visuel
        self:insert(btRetour)

        -- Détecte si le bâtiment est ouvert actuellement et met fin à la fonction si ce n'est pas le cas
        if (destination == "centresportif" or destination == "faculte") and infos:getJour() == "Dimanche" then
            retroaction.text = "Cet etablissement n'ouvre pas les dimanches."

            return
        elseif tHoraires[destination] ~= nil then
            local ouv = tHoraires[destination].ouv
            local ferm  = tHoraires[destination].ferm
            local heure = _G.infos:getHeure()
            
            if heure < ouv or heure >= ferm then
                retroaction.text = "Cet etablissement est ferme."

                return
            end
        end

        -- Si le perso entre dans un bâtiment qui n'est pas le loft ou qu'il a acheté le loft
        if destination ~= "loft" or perso.inventaire["loft"] == true then
            if (destination == "appartement" or destination == "loft") and (perso.inventaire["Tapis roulant"] ~= true and perso.inventaire["tapisRoulant"] ~= true) then
                src.bt3 = nil
            end
            if destination == "banque" and evenement ~= nil and (evenement[1].destination == "banque" and evenement[1].status == "ferme") then
                inputBanque = false
            end
            -- Si le perso entre dans l'appartement et qu'il a acheté le loft
            if destination == "appartement" and perso.inventaire["loft"] == true then
                retroaction.text = "Vous n'habitez plus ici."
            -- Si le perso entre dans un bâtiment de travail et qu'il ne travaille pas là
            elseif evenement ~= nil and destination == evenement[1].destination and evenement[1].status == "ferme" then
                retroaction.text = "L'etablissement est ferme aujourd'hui."
            elseif (perso.carriere == "sports" and destination == "faculte") or (perso.carriere == "sciences" and destination == "centresportif") then
                retroaction.text = "Vous ne travaillez pas ici."
            else
                bt1 = cBouton:init(src.bt1,src.bt1desc,display.contentCenterX/1.65,display.contentCenterY,func.bt1,func.bt1param)
                self:insert(bt1)
                -- S'il y a un troisième bouton à générer
                if src.bt3~=nil then
                    bt3 = cBouton:init(src.bt3,src.bt3desc,display.contentCenterX/1.65,display.contentCenterY*1.5,func.bt3,func.bt3param)
                    self:insert(bt3)
                end
                -- S'il y a un deuxième bouton à générer
                if src.bt2~=nil then
                    bt2 = cBouton:init(src.bt2,src.bt2desc,display.contentCenterX*1.4,display.contentCenterY,func.bt2,func.bt2param)
                    self:insert(bt2)
                end
            end
        -- Si le joueur n'a pas acheté le loft
        elseif destination == "loft" and perso.inventaire["loft"] ~= true then 
            bt1 = cBouton:init("Acheter loft",objets[7].prix.."$",display.contentCenterX/1.65,display.contentCenterY,acheter,7)
            -- btRetour.y = bt1.y
            self:insert(bt1)
        end

        -- Champ de texte pour la banque
        if destination == "banque" and inputBanque ~= false then
            local btBanque = display.newImage( self, "ressources/img/bt.png" )
            inputBanque = native.newTextField( display.contentCenterX/1.65, display.contentCenterY*1.5, bt1.width-50, bt1.height/2 )
            inputBanque.inputType = "number"
            inputBanque.placeholder = "-Montant-"
            inputBanque.isFontSizeScaled = true
            inputBanque.font = native.newFont( "ressources/fonts/8-Bit Madness.ttf", 75 )
            inputBanque.align = "center"
            btBanque.x, btBanque.y = inputBanque.x, inputBanque.y
            print(src)
            bt4 = cBouton:init(src.bt4,src.bt4desc,display.contentCenterX*1.4,display.contentCenterY*1.5,func.bt4,func.bt4param)
            self:insert(inputBanque)
            self:insert(bt4)
        end
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

    return interieur
end

return Interieur