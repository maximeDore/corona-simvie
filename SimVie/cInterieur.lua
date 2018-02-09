-----------------------------------------------------------------------------------------
--
-- cInterieur.lua
--
-----------------------------------------------------------------------------------------
local Interieur = {}

function Interieur:init(destination,jeu)

    local interieur = display.newGroup()
    local cJeu = require("cJeu")
    local cBouton = require("cBouton")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )
    -- Tableau contenant des tableaux, contenant les noms de fichier pour les images des boutons et du fond selon la destination
    local tSrc = { 
        gym =         { bg = "bg.jpg", bt1 = "btEntrainer.png", bt2 = "btSteroides.png" },
        universite =  { bg = "bg.jpg", bt1 = "btEtudier.png", bt2 = "btClasse.png" },
        depanneur =   { bg = "bg.jpg", bt1 = "btFleche.png", bt2 = "btFleche.png", bt3 = ".png" },
        banque =      { bg = "bg.jpg", bt1 = ".png", bt2 = ".png", bt3 = ".png" },
        appartement = { bg = "bg.jpg", bt1 = ".png", bt2 = ".png", bt3 = ".png" },
        centreSport = { bg = "bg.jpg", bt1 = ".png", bt2 = ".png", bt3 = ".png" },
        faculte =     { bg = "bg.jpg", bt1 = ".png", bt2 = ".png", bt3 = ".png" }
    }
    
    function interieur:init()
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
            if pt>=2 then

            end
            print("+"..pt.." For")
        end

        local function ajouterInt(pt)
            if pt>=2 then
                -- jeu.money = jeu.money-100
            end
            print("+"..pt.." Int")
        end

        local function ajouterCha(pt)
            if pt>=2 then
                -- jeu.money = jeu.money-100
            end
            print("+"..pt.." Cha")
        end

        local function acheter(i)
            --acheter un objet selon l'index de l'objet
        end

        local function travailler()
            -- enlève du temps et donne de l'argent en fonction du poste du joueur
        end

        local function dormir()
            -- change de journée, reset le temps et sauvegarde
        end

        local function retirer(somme)
            -- à repenser, fonction pour retirer une somme définie par des boutons-flèches?
        end

        local function deposer(somme)
            -- à repenser, fonction pour déposer une somme définie par des boutons-flèches?
        end

        -- tableau des fonctions des boutons selon la destination
        local tFunc = {
            gym =            { bt1 = ajouterFor, bt1param = 1, bt2 = ajouterFor, bt2param = 2 },
            universite =     { bt1 = ajouterInt, bt1param = 1, bt2 = ajouterInt, bt2param = 2 },
            depanneur =      { bt1 = acheter, bt1param = 1, bt2 = acheter, bt2param = 1 },
            banque =         { bt1 = retirer, bt1param = 1, bt2 = deposer, bt2param = 2 },
            appartement =    { bt1 = dormir, bt1param = 1 },
            centreSport =    { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 },
            faculte =        { bt1 = travailler, bt1param = 1, bt2 = promotion, bt2param = 2 }
        }

        local func = tFunc[destination]

        -- Affichage de l'interface et des boutons
        local bg = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight)
        -- local bg = display.newImage(src.bg,display.contentCenterX,display.contentCenterY)

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
        
        local bt1 = cBouton:init(src.bt1,display.contentCenterX/1.65,display.contentCenterY,func.bt1,func.bt1param)
        local bt2 = cBouton:init(src.bt2,display.contentCenterX*1.4,display.contentCenterY,func.bt2,func.bt2param)
        local btRetour = cBouton:init("btRetour.png",display.contentCenterX/1.65,display.contentCenterY*1.5,retour)

        -- Insertion du visuel
        self:insert(bg)
        self:insert(titre)
        self:insert(bt1)
        self:insert(bt2)
        self:insert(btRetour)
    end

    function interieur:kill()
        bgMusicChannel = audio.stop(2)
    end

    interieur:init()
    return interieur
end

return Interieur