-----------------------------------------------------------------------------------------
--
-- cEvenement.lua
--
-- Classe contenant des événements et des citations et qui retourne un événement et/ou citation au hasard
--
-- Return : Array   Tableau de tableaux pouvant contenir un événement et/ou une citation aléatoire(s)
--
-----------------------------------------------------------------------------------------
local Evenement = {}

-- @params chance : Number  Valeur de chance du personnage
function Evenement:init( chance )
    local events = {
        -- Tableau des événements
        evenements = {
            -- Fermetures
            -- { texte = "Message d'interet public : \n\nUn probleme de guichet provoquera la fermeture de la banque pendant toute la journee.", destination="banque", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nLa banque sera fermee aujourd'hui suite au cambriolage de la veille.", destination="banque", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nSuite a l'echec d'une experience, la faculte des sciences sera fermee aujourd'hui.", destination="faculte", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nLa faculte des sciences n'ouvrira pas aujourd'hui pour cause de mutation contagieuse.", destination="faculte", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nDes plaintes ont ete portees au sujet d'odeurs fortes, provoquant la fermeture du centre sportif.", destination="centresportif", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nTous les matchs au centre sportifs sont annules afin de tondre la pelouse.", destination="centresportif", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nSuite a un accident dans le parking, le magasin ne pourra ouvrir aujourd'hui.", destination="magasin", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nLe magasin n'ouvrira pas ses portes aujourd'hui pour aucune raison valable.", destination="magasin", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nTrop d'enseignants se porteront absent, c'est pourquoi l'universite sera fermee.", destination="universite", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nUne greve d'etudiants a provoque un feu dans l'universite, le batiment sera donc ferme aujourd'hui.", destination="universite", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nEn raison de la fin de session, le depanneur est maintenant vide. La prochaine livraison sera demain.", destination="depanneur", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nEn raison de la fin de session, le depanneur est maintenant vide. La prochaine livraison sera demain.", destination="depanneur", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nL'air climatise de la gym ne fonctionne plus. L'endroit n'ouvrira pas ses porte avant demain.", destination="gym", status = "ferme"},
            -- { texte = "Message d'interet public : \n\nPuisque l'entraineur a fait une overdose de stimulants, la gym sera ferme.", destination="gym", status = "ferme"},
            -- Rabais
            -- { texte = "Message d'interet public : \n\nLiquidation monstre au magasin, tous les prix sont reduits de 10%!", destination="magasin", status = "rabais"},
            { texte = "Message d'interet public : \n\nMega rabais au depanneur, tout est offert a prix reduit de 20%", destination="depanneur", status = "rabais"},
            -- { texte = "Message d'interet public : \n\nSuper aubaine a ne pas manquer : Le prix du loft baisse de 20% aujourd'hui seulement!", destination="loft", status = "rabais"},
    
        },
        -- Tableau des citations
        citations = { 
            -- TIM
            { auteur="Daniel Gentile", texte="Le multimedia, un outil essentiel dans un monde moderne." },
            { auteur="Sara Belanger", texte="J'suis humaine, j'suis pas parfaite." },
            { auteur="Jeremie Bernard", texte="Quand on a un probleme, il faut faire du gros code sale." },
            { auteur="Jeremie Bernard", texte="Si tu rajoutes des ornithorynques dans ton jeu, c'est 10 points supplementaires." },
            { auteur="Martyr", texte="Faites le plein d'energie avec la boisson energisante Orny!" },
            { auteur="Kyan Daigneault", texte="Hey regarde ! Ma tasse ne coule pas. Oups!" },
            { auteur="William Lafortune-Caissy", texte="Comment t'appellerais mon projet? Visites Animales?" },
            { auteur="William Lafortune-Caissy", texte="La vie c'est de la marde!" },
            { auteur="Benjamin Le Du", texte="Qui a ecrit ce code de marde-la!? Oups c'est moi..." },
            { auteur="Benny la truie", texte="RRRRUUUIIIIIIIIIII!" },
            { auteur="Dominique Coupal", texte="Ta tadada tada." },
            { auteur="Maxime Dore", texte="Ca marche pas si ca n'a pas de jambe!" },
            { auteur="Kim Lampron-Cote", texte="C'est parti!" },
            { auteur="Samuel De Matos", texte="*Finger guns*" },
            { auteur="Samuel De Matos", texte="Non mais j'suis un expert-la." },
            { auteur="Maman", texte="Les p'tits jus c'est pour les lunchs." },
            { auteur="Francois Lavigne", texte="Push uuuuuup!"},
            { auteur="Francois Lavigne", texte="Biere!"},
            { auteur="Jean-Sebastien Richer", texte="Internet Explorer est excellent... pour telecharger Chrome."},
            { auteur="Jean-Sebastien Richer", texte="Je serais d'accord avec toi si tu avais raison."},
            { auteur="Jean-Sebastien Richer", texte="On est tous a 4 minutes de la mort, quand on respire ca réinitialise le compteur."},
            { auteur="Jean-Sebastien Richer", texte="La vie serait tellement differente si les pets etaient aussi contagieux que les eternuements."},
            { auteur="Jean-Sebastien Richer", texte="En Web, il faut prendre pour acquis que le but premier des clients c'est de peter leur site."},
            { auteur="Jean Plouffe", texte="Si les heures sont dans les doubles chiffres, c'est correct de prendre une biere."},
            -- Citations autres
            -- { auteur="Anonyme", texte="Le suicide n'est pas une option." },
            -- { auteur="Sully Prud'homme", texte="La vie n'est qu'un long reve dont la mort nous reveille." },
            -- { auteur="Maurice Barres", texte="Il est trop certain que la vie n'as pas de but et que l'homme pourtant a besoin de poursuivre un reve." },
            -- { auteur="Anonyme", texte="C'est juste un mauvais jour, pas une mauvaise vie." },
            -- { auteur="MC Gueul 2 Boi", texte="La vie c’est comme la banque: plus t’es pauvre, plus tu payes." },
            -- { auteur="Gustave Le Bon", texte="On se ruine souvent pour soutenir qu'on est riche." },
            -- { auteur="Dominique Devillepin", texte="L'argent, c'est simplement parce qu'on lui donne de l'importance, qu'il a de l'importance." },
            -- { auteur="Louis-Sebastien Mercier", texte="On est toujours riche, quand on a tout paye." },
            -- { auteur="Victor Hugo", texte="Le bonheur est parfois cache dans l'inconnu." },
            -- { auteur="Mirna Loy", texte="La vie, ce n'est pas avoir et obtenir, mais etre et devenir." },
            -- { auteur="Michele Blouin", texte="La vie, c'est une tartine de merde et il faut que tu en manges une bouchee tous les jours." },
        }
    }
    local tEvenement = {}

    -- Nombres aléatoires servant à déterminer si un événement/citation va être retourné
    local randIsEvent = math.random( 15+chance )
    local randIsQuote = math.random( #events.citations*2 )

    -- S'il y a un événement aujourd'hui, insère le tableau d'un événement au hasard dans le tableau d'événement du jour
    if 15 > randIsEvent then
        local randEvent = math.random( #events.evenements )
        table.insert( tEvenement, events.evenements[randEvent] )
    end
    -- S'il y a une citation aujourd'hui, insère le tableau d'une citation au hasard dans le tableau d'événement du jour
    if randIsQuote > #events.citations then
        local randQuote = math.random( #events.citations )
        table.insert( tEvenement, events.citations[randQuote] )
    end

    return tEvenement
end

return Evenement