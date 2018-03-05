local Evenement = {}

function Evenement:init( chance )
    local evenement = {}

    local events = {
        events = {
            cambriolage = "Message d'interet public : \n\nLa banque sera fermee aujourd'hui suite au cambriolage de la veille.", destination="banque", status = "ferme",
            experience = "Message d'interet public : \n\nSuite a l'echec d'une experience, la faculte des sciences sera fermee aujourd'hui.", destination="faculte", status = "ferme",
            odeurs = "Message d'interet public : \n\nDes plaintes ont ete portees au sujet d'odeurs fortes provoquant la fermeture du centre sportif.", destination="centreSportif", status = "ferme",
            experience = "Message d'interet public : \n\nLe magasin n'ouvrira pas ses portes aujourd'hui pour aucune raison valable.", destination="magasin", status = "ferme",
    
        },
        timQuotes = { 
            { auteur="Daniel Gentile", texte="Le multimedia, un outil essentiel dans un monde moderne." },
            { auteur="Jeremie Bernard", texte="Quand on a un probleme, il faut faire du gros code sale." },
            { auteur="Jeremie Bernard", texte="Si tu rajoutes des ornythorynques dans ton jeu, c'est 10 points supplementaires." },
            { auteur="Martyr", texte="Faites le plein d'energie avec la boisson energisante Orny" },
            { auteur="Kyan Daigneault", texte="Hey regarde ! Ma tasse ne coule pas. Oups!" },
            { auteur="William Lafortune-Caissy", texte="La vie c'est de la m****!" },
            { auteur="Benjamin Le Du", texte="Qui a ecrit ce code de m****-la!? Oups c'est moi..." },
            { auteur="Dominique Coupal", texte="Ta tadada dada." },
            { auteur="William Lafortune-Caissy", texte="Comment t'appellerais mon projet? Visites Animales?" },
            { auteur="Maxime Doré", texte="Ca marche pas si ca n'a pas de jambe!" },
        }
    }

    function evenement:init()
        local randEvent = math.random( #events.events+chance )
        local randQuote = math.random( #events.timQuotes*2 )
        local tEvent = { events.events[randEvent], events.timQuotes[randQuote] }
        print(randQuote)
        
        if events.events[randEvent] == nil then
            return tEvent
        end
    end

    evenement:init()
    return evenement
end

return Evenement