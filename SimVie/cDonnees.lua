-----------------------------------------------------------------------------------------
--
-- cDonnees.lua
--
-- Objet contenant des méthodes qui gère la sauvegarde et le chargement de données (IO) 
--
-----------------------------------------------------------------------------------------
local json = require("json")

donnees = {}
local persoParams

-- Sauvegarde les données dans un fichier dans le sandbox
-- @params 
-- t		Array	Tableau contenant les données à sauvegarder
-- filename	String	Nom du fichier dans lequel les données seront sauvegardées
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

-- Récupère les données depuis un fichier dans le sandbox
-- @params 
-- filename	String	Nom du fichier dans lequel les données seront chargées
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

-- Récupère toutes les valeurs à sauvegarder à partir du jeu dans un tableau et l'envoie se faire sauvegarder
-- @params 
-- perso	Object	Classe contenant le personnage
-- infos	Object	Classe contenant les informations relatives au déroulement du jeu
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
	persoParams.evenement = infos:getEvenement()
	persoParams.contacts = infos:getContacts()
	persoParams.energie = perso.energie
	persoParams.money = perso.money
	persoParams.banque = perso.banque
	persoParams.inventaire = perso.inventaire
	self:saveTable(persoParams, "sauvegarde.json")
end

return donnees