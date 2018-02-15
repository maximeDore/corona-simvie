-----------------------------------------------------------------------------------------
--
-- cDonnees.lua
--
-----------------------------------------------------------------------------------------
-- Base de données
require "sqlite3"
local path = system.pathForFile("classeTable.db", system.ResourceDirectory)
db = sqlite3.open( path )
 
--Handle the applicationExit event to close the db
function onSystemEvent( event )
  if( event.type == "applicationExit" ) then
      db:close()
  end
end
 
for row in db:nrows("SELECT * FROM classeTable") do
    -- Iterate through each of our rows of data
    -- It uses dot notation, so if you want to get a column's data, say class,strength,desterity or hitpoints
    -- OK, I'm still getting used to the special characters, but FYI the '/t'
    -- prints a tab, so that way our data lines up nicely in the output to the console
    print("classe: "..row.classe.." tForce: "..row.force.." tchance: "..row.chance.." tIntelligence: "..row.intelligence)
end

perso = {}
 
-- séparateur
print("")
 
for row in db:nrows("SELECT * FROM classeTable WHERE classe='culturiste'") do
	perso.classe = row.classe
	perso.force = row.force
	perso.chance = row.chance
	perso.intelligence = row.intelligence
	perso.carriere = row.carriere
	perso.emploi = row.emploi
	print("Classe du joueur: "..perso.classe.." tForce: "..perso.force.." tchance: "..perso.chance.." tIntelligence: "..perso.intelligence)
end


-- Fonction pour créer un personnage selon une classe passée en paramètre
function createCharacterClass(passedClass)
	local SQL = "SELECT * FROM classeTable WHERE classe='"..passedClass.."'"
	local tempTable = {}
	for row in db:nrows(SQL) do
		tempTable = row
	end
	return tempTable
end
 
player2 = {}
-- Créer un personnage de classe scientifique
player2 = createCharacterClass("scientifique")
 
if player2.classe~=nil then
	print("Nouveau "..player2.classe..": Force: "..player2.force.." chance : "..player2.chance.." Intelligence : "..player2.intelligence)
end