-- French localisation
-- luacheck: ignore 631
local L = ZO_CreateStringId
local AH = "ARCHIVEHELPER_"
L(AH .. "ADD_AVOID", "Ajouter à la liste des Indésirables")
L(AH .. "ALL_BOTH", "Tous les versets et visions acquis")
L(AH .. "ALL_VISIONS", "Toutes les visions acquises")
L(AH .. "ALL_VERSES", "Tous les versets acquis")
L(AH .. "ARC_BOSS", "Replicanum de Tho’at à venir")
L(AH .. "AVOID", "Indésirables")
L(AH .. "BONUS", "Niveaux bonus")
L(AH .. "BUFF_SELECTED", "<<1>> a sélectionné <<2>>")
L(AH .. "COUNT", "<<1>> sur <<2>>")
L(AH .. "CROSSING_END", "Fin")
L(AH .. "CROSSING_FAIL", "verrouillés") -- Les leviers sont verrouillés. Personne ne peut passer
L(AH .. "CROSSING_INVALID", "L'aide ne peut être activée qu'à l'intérieur du Gué traître dans l'Archive Infinie")
L(AH .. "CROSSING_KEY", "<<1>> Prendre à gauche - <<2>> Prendre à droite")
L(AH .. "CROSSING_NO_SOLUTIONS", "Aucun chemin trouvé")
L(AH .. "CROSSING_PATHS", "Chemins possibles")
L(AH .. "CROSSING_SLASH", "aide")
L(AH .. "CROSSING_START", "Début")
L(AH .. "CROSSING_SUCCESS", "résolu") -- Vous avez résolu l'énigme du couloir
L(AH .. "CROSSING_TITLE", "Aide pour le Gué traître")
L(
    AH .. "CROSSING_INSTRUCTIONS",
    "Trouvez l'interrupteur correspondant au début du chemin et sélectionnez-le dans la liste déroulante ci-dessous (1 est le plus à gauche, 6 le plus à droite)." ..
        " Puis, si nécessaire, trouvez la 2ème étape ou la fin du chemin, jusqu'à ce qu'il ne reste qu'une solution."
)
L(AH .. "CYCLE_BOSS", "Phase de boss à venir")
L(AH .. "DEN_TIMER", "<<1[0s restantes/1s restante/$ds restantes]>>")
L(AH .. "FABLED", "fabule")
L(AH .. "FABLED_MARKER", "Mettre un marqueur de cible sur les Fables")
L(
    AH .. "FABLED_TOOLTIP",
    "Cette fonctionnalité ne fonctionnera pas avec l'addon Lykeion's Fabled Marker afin d'éviter que les deux addons n'essaient de marquer les mêmes choses."
)
L(AH .. "FLAMESHAPER", "Façonne-feu")
L(AH .. "GW", "Gw le pillard")
L(AH .. "GW_MARKER", "Ajouter un marqueur de cible sur Gw le pillard")
L(AH .. "GW_PLAY", "Jouer un son quand Gw est marqué")
L(AH .. "HERD", "Rassemblez les lueurs fantômes")
L(AH .. "HERD_FAIL", "assez") -- Vous n'avez pas assez rassemblé de lueurs fantômes
L(AH .. "HERD_SUCCESS", "ramené") -- Vous avez ramené les lueurs fantômes
L(AH .. "MARAUDER_MARKER", "Mettre un marqueur de cible sur les Maraudeurs")
L(AH .. "MARAUDER_INCOMING_PLAY", "Jouer un son à l'arrivée d'un Maraudeur")
L(AH .. "OPTIONAL_LIBS_CHAT", "Archive Helper fonctionne mieux si LibChatMessage est installé.")
L(AH .. "OPTIONAL_LIBS_SHARE", "Pour que le mode Duo fonctionne correctement, veuillez installer LibDataShare.")
L(AH .. "PREVENT", "Empêcher de sélectionner un bienfait par erreur")
L(AH .. "PREVENT_TOOLTIP", "Désactive la sélection du bienfait brièvement lorsque le panneau de sélection s'ouvre pour éviter un choix accidentel.")
L(AH .. "PROGRESS", "Avancement du critère <<1>>. Encore <<2>>.")
L(AH .. "PROGRESS_ACHIEVEMENT", "Progression des succès")
L(AH .. "PROGRESS_CHAT", "Afficher dans le log")
L(AH .. "PROGRESS_SCREEN", "Annoncer à l'écran")
L(AH .. "RANDOM", "<<1>> a reçu <<2>>")
L(AH .. "REMINDER", "Signaler les prochaines phases de boss")
L(AH .. "REMINDER_QUEST", "Rappel en cas d'objet de quête non ramassé")
L(AH .. "REMINDER_QUEST_TEXT", "Pensez à ramasser l'objet de quête !")
L(AH .. "REMINDER_TOOLTIP", "Lors de la sélection des versets, afficher un rappel si la phase suivante est un boss.")
L(AH .. "REMOVE_AVOID", "Retirer de la liste des Indésirables")
L(AH .. "REQUIRES", "Requiert LibChatMessage")
L(AH .. "SECONDS", "s")
L(AH .. "SHARD", "Fragment de Tho'at")
L(AH .. "SHARD_IGNORE", "Ignorer les Fragments en dehors du cycle 5")
L(AH .. "SHARD_MARKER", "Mettre un marqueur sur les Fragments de Tho'at")
L(AH .. "SHOW_COUNT", "Décompter les tomes-carapaces de l'Aile du greffier")
L(AH .. "SHOW_CROSSING_HELPER", "Afficher l'aide dans le Gué traître")
L(
    AH .. "SHOW_COUNT_TOOLTIP",
    "Pour que le mode Duo fonctionne correctement, l'autre joueur doit avoir installé cet addon. Les deux joueurs doivent également avoir installé LibDataShare."
)
L(AH .. "SHOW_ECHO", "Afficher un minuteur dans l'Antre aux échos")
L(AH .. "SHOW_SELECTION", "Afficher vos choix de bienfaits en discussion")
L(AH .. "SHOW_TERRAIN_WARNING", "Afficher les avertissements")
L(AH .. "SHOW_TERRAIN_WARNING_TOOLTIP", "Afficher les avertissements concernant les dommages causés au terrain")
L(AH .. "SHOW_SELECTION_DISPLAY_NAME", "Utiliser le nom d'affichage")
L(AH .. "SHOW_SELECTION_DISPLAY_NAME_TOOLTIP", "Utiliser le nom d'affichage au lieu du nom du personnage")
L(AH .. "SLASH_MISSING", "manquant")
L(AH .. "STACKS", "Nombre de bienfaits cumulés")
L(AH .. "TOMESHELL", "Tome-carapace")
L(AH .. "TOMESHELL_COUNT", "<<1[0 restants/1 restant/$d restants]>>")
L(AH .. "USE_AUTO_AVOID", "Marquer automatiquement les Indésirables")
L(
    AH .. "USE_AUTO_AVOID_TOOLTIP",
    "Marquer automatiquement les versets ou les visions qui ne vous sont d'aucune utilité en raison de compétences non équipées."
)
L(AH .. "WARNING", "Avertissement : les listes déroulantes ne seront actualisées qu'après un rechargement de l'IU")
L(AH .. "WEREWOLF_BEHEMOTH", "Béhémoth loup-garou")

-- keybinds
L("SI_BINDING_NAME_" .. AH .. "MARK_CURRENT_TARGET", "Marquer la cible actuelle")
L("SI_BINDING_NAME_" .. AH .. "TOGGLE_CROSSING_HELPER", "Ouvrir/fermer l'aide du Gué traître")
L("SI_BINDING_NAME_" .. AH .. "UNMARK_CURRENT_TARGET", "Retirer la marque sur la cible actuelle")

-- Marauders
L(AH .. "MARAUDER_GOTHMAU", "gothmau")
L(AH .. "MARAUDER_HILKARAX", "hilkarax")
L(AH .. "MARAUDER_ULMOR", "ulmor")
L(AH .. "MARAUDER_BITTOG", "bittog")
L(AH .. "MARAUDER_ZULFIMBUL", "zulfimbul")

-- Zones
L(AH .. "MAP_TREACHEROUS_CROSSING", "Treacherous Crossing")
L(AH .. "MAP_HAEFELS_BUTCHERY", "Haefel's Butchery")
L(AH .. "MAP_FILERS_WING", "Filer's Wing")
L(AH .. "MAP_ECHOING_DEN", "Echoing Den")
L(AH .. "MAP_THEATRE_OF_WAR", "Theatre of War")
L(AH .. "MAP_DESTOZUNOS_LIBRARY", "Destozuno's Library")

L(
    AH .. "LIB_TEXT",
    "Ce module complémentaire nécessite désormais LibFBCommon. Veuillez l'installer et le recharger. Veuillez ignorer les erreurs éventuelles jusqu'à ce que ce module soit installé."
)