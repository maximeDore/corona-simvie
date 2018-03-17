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
-- Volume de la musique de fond 25%
audio.setVolume( 0.25, { channel=1 } )
-- Applique un filtre qui rend l'image moins floue (pour mieux voir les pixels)
display.setDefault( "magTextureFilter", "nearest" )

--  local cSplash = require("cSplashscreen")
--  cSplash:init()

local cMenu = require("cMenu")
cMenu:init()