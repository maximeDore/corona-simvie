-----------------------------------------------------------------------------------------
--
-- cContacts.lua
--
-----------------------------------------------------------------------------------------
local Contacts = {}

function Contacts:init()
    local noms = { "Martin", "Daniel", "Jeremie", "William", "Sarah", "Justin", "Henry", "Marty", "Justine", "Alexandre", "Bernard", "Sophie", "Yannick", "Maxime", "Olivier", "Audrey", "Francis" }
    local contacts = {}

    function contacts:init( )
        local rand1 = math.random( #noms )
        local rand2 = math.random( #noms )
        while rand2 == rand1 do
            rand2 = math.random( #noms )
        end
        -- Génération d'un personnage par défaut ou avec valeur sauvegardées
        print(_G.data.contacts[1].nom)
        if _G.data.contacts then
            contacts = _G.data.contacts
        else
            contacts = {
                { nom = noms[rand1], forNum = 5, intNum = 5 },
                { nom = noms[rand2], forNum = 5, intNum = 5 },
            }
        end
    end
    
    contacts:init()
    print(contacts[1].nom)
    print(contacts[2].nom)
    return contacts
end

return Contacts