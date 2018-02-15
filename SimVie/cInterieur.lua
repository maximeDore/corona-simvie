-----------------------------------------------------------------------------------------
--
-- cInterieur.lua
--
-----------------------------------------------------------------------------------------
local Interieur = {}

function Interieur:init(destination,jeu,horaire)

    local interieur = display.newGroup()
    local cJeu = require("cJeu")
    local cBouton = require("cBouton")
    local cHoraire = require("cHoraire")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )
    -- Tableau contenant des tableaux, contenant les noms de fichier pour les images des boutons et du fond selon la destination
    local tSrc = { 
        gym =         { bg = "bg.jpg", bt1 = "btCourir.png", bt2 = "btEntrainer.png", bt3 = "btSteroides.png" },
        universite =  { bg = "bg.jpg", bt1 = "btEtudier.png", bt2 = "btClasse.png", bt3 = "btTricher.png" },
        depanneur =   { bg = "bg.jpg", bt1 = "btFleche.png", bt2 = "btFleche.png", bt3 = "btFleche.png" },
        banque =      { bg = "bg.jpg", bt1 = ".png", bt2 = ".png", bt3 = ".png" },
        appartement = { bg = "bg.jpg", bt1 = "btContinuer.png" },
        centresportif = { bg = "bg.jpg", bt1 = "btFleche.png" },
        faculte =     { bg = "bg.jpg", bt1 = ".png", bt2 = ".png" }
    }
    
    function interieur:init()
        -- local bgMusicChannel = audio.play( bgMusic, { channel=2, loops=-1, fadein=2000 } )
        -- local bg = display.newImage("bg.jpg",display.contentCenterX,display.contentCenterY)
        -- Abréviation
        jeu:insert(self)
        local src = tSrc[destination]

        -- Fonctions locales des boutons
        local function retour()
            jeu:sortirBatiment()
            self:kill()
        end

        local function ajouterFor(pt)
            if(horaire:getHeure()~=24) then
                if pt==1 then
                    horaire:update(1)                    
                elseif pt==2 and jeu:getMoney()>0 then
                    jeu:setMoney(jeu:getMoney() - 20)
                    print(jeu:getMoney())
                    horaire:update(1)
                end
                print("+"..pt.." For")
            end
        end

        local function ajouterInt(pt)
            if(horaire:getHeure()~=24) then
                if pt==1 then
                    horaire:update(1)                    
                elseif pt==2 and jeu:getMoney()>0 then
                    jeu:setMoney(jeu:getMoney() - 20)
                    print(jeu:getMoney())
                    horaire:update(1)
                end
                print("+"..pt.." Int")
            end
        end

        --acheter un objet selon l'index de l'objet
        local function acheter(i)
            print("achat object #"..i)
        end

        -- enlève du temps et donne de l'argent en fonction du poste du joueur
        local function travailler()
            if(horaire:getHeure()~=24) then
                horaire:update(4)
                -- Détecter le niveau de carriere du perso
                print("+"..pt.." For")
            end
        end

        -- change de journée, reset le temps et sauvegarde
        local function dormir()
            horaire:reset()
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
            centresportif =    { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 },
            faculte =        { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 }
        }

        local func = tFunc[destination]

        -- Affichage de l'interface et des boutons
        local bg = display.newRect(self,display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight)
        -- local bg = display.newImage(self,src.bg,display.contentCenterX,display.contentCenterY)

        local optionsTitre = {
            text = destination,
            x = display.contentCenterX,
            y = display.contentCenterY/2.75,
            font = "Diskun.ttf",
            fontSize = 100,
            align = "center"  -- Alignment parameter
        }
        local titre = display.newText( optionsTitre )
        titre:setFillColor(1,0,0)
        
        local btRetour = cBouton:init("btRetour.png",display.contentCenterX*1.4,display.contentCenterY*1.5,retour)
        local bt1 = cBouton:init(src.bt1,display.contentCenterX/1.65,display.contentCenterY,func.bt1,func.bt1param)
        if src.bt2~=nil then
            local bt2 = cBouton:init(src.bt2,display.contentCenterX*1.4,display.contentCenterY,func.bt2,func.bt2param)
            self:insert(bt2)
        else
            btRetour.y = display.contentCenterY
        end
        if src.bt3~=nil then
            local bt3 = cBouton:init(src.bt3,display.contentCenterX/1.65,display.contentCenterY*1.5,func.bt3,func.bt3param)
            self:insert(bt3)
        end

        -- Insertion du visuel
        self:insert(titre)
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