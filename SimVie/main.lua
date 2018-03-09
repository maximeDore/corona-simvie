-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Physiques
local physics = require( "physics" )
physics.start()
-- physics.setDrawMode("hybrid")
physics.setGravity(0,0)
-- Volume de la musique de fond 50%
audio.setVolume( 0.25, { channel=1 } )

--  local cSplash = require("cSplashscreen")
--  cSplash:init()

local cMenu = require("cMenu")
cMenu:init()