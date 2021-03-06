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
-- Multitouch
system.activate( "multitouch" )

-- Volume de la musique de fond 25%
audio.setVolume( 0.5, { channel=1 } )

-- Applique un filtre qui rend l'image moins floue (pour mieux voir les pixels)
display.setDefault( "magTextureFilter", "nearest" )

-- Instancie le splashscreen
 local cSplash = require("cSplashscreen")
 cSplash:init()


 -- Tests
-- local cMenu = require("cMenu")
-- cMenu:init()