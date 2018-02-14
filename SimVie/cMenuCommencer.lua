-----------------------------------------------------------------------------------------
--
-- cMenuCommencer.lua
--
-----------------------------------------------------------------------------------------
local MenuCommencer = {}

function MenuCommencer:init()

    local menuCommencer = display.newGroup()
    local bouton = require("cBouton")
    local aptitudesNum
    local erreurMsg
    local pointsRestants = 10
    _G.forNum = 5
    _G.intNum = 5
    _G.chaNum = 5

    function menuCommencer:init()

        local function ajouterPoint(apt)
            if pointsRestants > 0 then
                if apt=="for" then
                    forNum = forNum + 1
                elseif apt=="int" then
                    intNum = intNum + 1
                else
                    chaNum = chaNum + 1
                end
                pointsRestants = pointsRestants - 1
                aptitudesNum.text = pointsRestants.." "..forNum.." "..intNum.." "..chaNum
            end
        end

        local function enleverPoint(apt)
            if apt=="for" and forNum>0 then
                forNum = forNum - 1
                pointsRestants = pointsRestants + 1
            elseif apt=="int" and intNum>0 then
                intNum = intNum - 1
                pointsRestants = pointsRestants + 1
            elseif apt=="cha" and chaNum>0 then
                chaNum = chaNum - 1
                pointsRestants = pointsRestants + 1
            end
            aptitudesNum.text = pointsRestants.." "..forNum.." "..intNum.." "..chaNum
        end

        local function retour()
            self.parent:retour()
        end

        local function jouer()
            erreurMsg.isVisible = true
            if forNum == intNum and pointsRestants == 0 then
                erreurMsg.text = "Votre INTELLIGENCE et votre FORCE ne peuvent etre egaux"
            elseif pointsRestants ~= 0 then
                erreurMsg.text = "Vous devez assigner tous vos points"
            else
                self.parent.setPoints(1,forNum,intNum,chaNum)
                self.parent:kill()
            end
        end

        -- fond de l'interface
        local box = display.newImage("UIBox.png", display.contentCenterX ,display.contentCenterY)

        -- textes
        local optionsTitre = {
                text = "Nouvelle vie",
                x = display.contentCenterX,
                y = display.contentCenterY/2.75,
                font = "Diskun.ttf",   
                fontSize = 100,
                align = "center"  -- Alignment parameter
            }
        local titre = display.newText( optionsTitre )
        local optionsAptitudes = {
                text = "Points : Force : Intelligence : Chance :",     
                x = display.contentCenterX/1.75,
                y = display.contentCenterY*.93,
                width = 250,
                font = "Diskun.ttf",   
                fontSize = 50,
                align = "right"  -- Alignment parameter
            }
        local aptitudes = display.newText( optionsAptitudes )
        local optionsAptitudesNum = {
                text = pointsRestants.." "..forNum.." "..intNum.." "..chaNum,
                x = display.contentWidth/1.5,
                y = display.contentCenterY*.93,
                width = 45,
                font = "Diskun.ttf",
                fontSize = 50,
                align = "center"  -- Alignment parameter
            }
        aptitudesNum = display.newText( optionsAptitudesNum )
        local optionsErreur = {
            text = "",
            x = display.contentCenterX,
            y = display.contentCenterY/1.8,
            font = "Diskun.ttf",   
            fontSize = 35,
            align = "center"  -- Alignment parameter
        }
        erreurMsg = display.newText( optionsErreur )
        erreurMsg.isVisible = false
        titre:setFillColor(1,0,0)
        aptitudes:setFillColor(1,0,0)
        aptitudesNum:setFillColor(1,0,0)
        erreurMsg:setFillColor(1,0,0)
        self:insert(box)
        self:insert(titre)
        self:insert(aptitudes)
        self:insert(aptitudesNum)
        self:insert(erreurMsg)

        -- boutons aptitudes 
        btForPlus = bouton:init("btFleche.png",display.contentWidth/1.35,display.contentCenterY*.86,ajouterPoint,"for")
        btForMoins = bouton:init("btFleche.png",display.contentWidth/1.70,display.contentCenterY*.86,enleverPoint,"for")
        btForMoins.xScale = -1
        self:insert(btForPlus)
        self:insert(btForMoins)

        btIntPlus = bouton:init("btFleche.png",display.contentWidth/1.35,display.contentCenterY*.99,ajouterPoint,"int")
        btIntMoins = bouton:init("btFleche.png",display.contentWidth/1.70,display.contentCenterY*.99,enleverPoint,"int")
        btIntMoins.xScale = -1
        self:insert(btIntPlus)
        self:insert(btIntMoins)

        btChaPlus = bouton:init("btFleche.png",display.contentWidth/1.35,display.contentCenterY/.895,ajouterPoint,"cha")
        btChaMoins = bouton:init("btFleche.png",display.contentWidth/1.70,display.contentCenterY/.895,enleverPoint,"cha")
        btChaMoins.xScale = -1
        self:insert(btChaPlus)
        self:insert(btChaMoins)

        -- Boutons navigation
        btRetour = bouton:init("btRetour.png",display.contentCenterX/1.6,display.contentHeight/1.3,retour)
        btCommencerPartie = bouton:init("btCommencer.png",display.contentCenterX/.725,display.contentHeight/1.3,jouer)
        self:insert(btRetour)
        self:insert(btCommencerPartie)


    end

    menuCommencer:init()
    return menuCommencer
end

return MenuCommencer