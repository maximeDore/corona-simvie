-----------------------------------------------------------------------------------------
--
-- cDonnees.lua
--
-----------------------------------------------------------------------------------------
local json = require("json")

donnees = {}
local persoParams

function donnees:saveTable( t, filename )
	local path = system.pathForFile( filename, system.DocumentsDirectory )
	local fichier = io.open(path, "w+")
	if fichier then
		local contenu = json.encode(t)
		fichier:write( contenu )
		io.close( fichier )
		return true
	else
		return false
	end
end

function donnees:loadTable( filename )
	local path = system.pathForFile( filename, system.DocumentsDirectory )
	local contenu = ""
	local monTableau = {}
	local fichier = io.open( path, "r" )
	if fichier then
		-- Transforme le contenu du fichier en string
		local contenu = fichier:read( "*a" )
		monTableau = json.decode(contenu);
		io.close( fichier )
		return monTableau
	end
	return nil
end

function donnees:prepForSave( perso, infos )
	local interet = infos:getInteret()
	persoParams = {}
	persoParams.force = perso.forNum
	persoParams.intelligence = perso.intNum
	persoParams.chance = perso.chaNum
	persoParams.carriere = perso.carriere
	persoParams.cptJours = infos:getCptJours()
	persoParams.emploiIndex = infos:getEmploiIndex()
	persoParams.jourIndex = infos:getJourIndex()
	persoParams.interet = infos:getInteret()/100
	persoParams.heure = infos:getHeure()
	persoParams.energie = perso.energie
	persoParams.money = perso.money
	persoParams.banque = perso.banque
	persoParams.inventaire = perso.inventaire
	self:saveTable(persoParams, "sauvegarde.json")
end



return donnees