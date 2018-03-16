-----------------------------------------------------------------------------------------
--
-- cContacts.lua
--
-----------------------------------------------------------------------------------------
local Contacts = {}

function Contacts:init( )
    local noms = { "Martin", "Daniel", "Jeremie", "William", "Sarah", "Justin", "Henry", "Marty", "Justine", "Alexandre", "Bernard", "Sophie", "Yannick", "Maxime", "Olivier", "Audrey", "Francis" }
    local contacts = {}

    function contacts:init( )
        local rand1 = math.random( #noms )
        local rand2 = math.random( #noms )
        while rand2 == rand1 do
            rand2 = math.random( #noms )
        end
        -- Assignation des valeurs chargées ou celles par défaut
        if _G.data.contact1 and _G.data.contact2 then
            self = {
                { nom = contact1.nom, forNum = contact1.forNum, intNum = contact1.intNum },
                { nom = contact2.nom, forNum = contact2.forNum, intNum = contact2.intNum },
            }
        else
            self = {
                { nom = noms[rand1], forNum = 5, intNum = 5 },
                { nom = noms[rand2], forNum = 5, intNum = 5 },
            }
        end
        print(self[1].nom)
        print(self[2].nom)
    end

    contacts:init()
    return contacts
end

return Contacts