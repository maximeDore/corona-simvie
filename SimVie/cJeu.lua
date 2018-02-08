-----------------------------------------------------------------------------------------
--
-- cJeu.lua
--
-----------------------------------------------------------------------------------------
local Jeu = {}

function Jeu:init(spawnX,spawnY)

    local jeu = display.newGroup()
    local cMap = require("cMap")
    local cCamera = require("cCamera")
    local cPerso = require("cPerso")
    local cJoystick = require("cJoystick")
    local cInterieur = require("cInterieur")
    local bgMusic = audio.loadStream( "Miami Viceroy.mp3" )
    local maMap
    local interieur
    local monJoystick

    function jeu:init()
        -- local bgMusicChannel = audio.play( bgMusic, { channel=1, loops=-1, fadein=2000 } )
        monJoystick = cJoystick:init(50,100)
        local monPerso = cPerso:init(spawnX,spawnY,0,monJoystick,self)
        maMap = cMap:init()
        local maCamera = cCamera:init(monPerso,maMap)

        monJoystick:toFront()
        monJoystick:activate()
        maMap:insert(monPerso)

        self:insert(maCamera)
        self:insert(monJoystick)
    end

    function jeu:changerScene(destination)
        -- self:kill()
        maMap:sleep()
        monJoystick:kill()
        print(destination)
        interieur = cInterieur:init(destination)
    end

    function jeu:mourir()
        self:kill()
    end

    function jeu:kill()
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
        listener()
    end

    jeu:init()
    return jeu
end

return Jeu