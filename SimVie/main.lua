-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Physiques
local physics = require( "physics" )
physics.start()
physics.setDrawMode("hybrid")
physics.setGravity(0,0)

-- local cSplash = require("cSplashscreen")
-- cSplash:init()

-- local cMenu = require("cMenu")
-- cMenu:init()

local cJeu = require("cJeu")
cJeu:init(-display.contentCenterX*2.5,display.contentCenterY*3.25)
