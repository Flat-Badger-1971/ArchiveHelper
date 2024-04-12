-- German localisation
-- luacheck: ignore 631
local L = ZO_CreateStringId
local AH = "ARCHIVEHELPER_"
L(AH .. "ADD_AVOID", "Auf \"Zu Vermeiden\" hinzufügen")
L(AH .. "ALL_BOTH", "Alle Verse und Visionen erworben")
L(AH .. "ALL_VISIONS", "Alle Visionen erworben")
L(AH .. "ALL_VERSES", "Alle Verse erworben")
L(AH .. "ARC_BOSS", "Tho’at Replicanum folgt")
L(AH .. "AVOID", "Zu Vermeiden")
L(AH .. "BONUS", "Bonuslevel")
L(AH .. "BUFF_SELECTED", "<<1>> hat <<2>> ausgewählt")
L(AH .. "COUNT", "<<1>> von <<2>>")
L(AH .. "CROSSING_INVALID", "Hilfe kann nur im Treacherous Ford im Infinite Archive aktiviert werden")
L(AH .. "CROSSING_KEY", "<<1>> Biegen Sie links ab - <<2>> Biegen Sie rechts ab")
L(AH .. "CROSSING_NO_SOLUTIONS", "Keine Pfade gefunden")
L(AH .. "CROSSING_PATHS", "Mögliche Wege")
L(AH .. "CROSSING_SLASH", "helfer")
L(AH .. "CROSSING_START", "Anfang")
L(AH .. "CROSSING_TITLE", "Treacherous Crossing Helper")
L(
    AH .. "CROSSING_INSTRUCTIONS",
    "Suchen Sie den Schalter, der dem Anfang des Pfads entspricht, und wählen Sie ihn im Dropdown-Menü unten aus (1 ist der Schalter ganz links, 6 ganz rechts)." ..
        " Finden Sie dann ggf. den 2. Schritt oder das Ende des Weges, bis nur noch eine Lösung übrig bleibt."
)
L(AH .. "CYCLE_BOSS", "Bosskampf folgt")
L(AH .. "DEN_TIMER", "Noch <<1[0s übrig/1s übrig/$ds übrig]>>")
L(AH .. "FABLED", "umwobene")
L(AH .. "FABLED_MARKER", "Zielmarkierungen zu Sagenumwobenen hinzufügen")
L(
    AH .. "FABLED_TOOLTIP",
    "Diese Funktion wird nicht zusammen mit Lykeions Fabled Marker Addon funktionieren, da sonst beide Addons die gleichen Dinge markieren würden."
)
L(AH .. "FLAMESHAPER", "Flammenformer")
L(AH .. "GW", "Gw Langfinger")
L(AH .. "GW_MARKER", "Zielmarkierungen zu Gw Langfinger hinzufügen")
L(AH .. "GW_PLAY", "Warnung bei ankommenden Gw abspielen")
L(AH .. "HERD", "Hütet die Geisterlichter")
L(AH .. "HERD_FAIL", "ausreichend") -- Ihr habt nicht ausreichend Geisterlichter gehütet
L(AH .. "HERD_SUCCESS", "erfolgreich") -- Ihr habt die Geisterlichter erfolgreich zurückgebracht
L(AH .. "MARAUDER_MARKER", "Zielmarkierungen zu Marodeuren hinzufügen")
L(AH .. "MARAUDER_INCOMING_PLAY", "Warnung bei ankommenden Marodeuren abspielen")
L(AH .. "PREVENT", "Verhindern Sie eine versehentliche Buff-Auswahl")
L(AH .. "PREVENT_TOOLTIP", "Deaktiviert die Aktionstaste kurzzeitig, wenn die Buff-Auswahl geöffnet wird")
L(AH .. "PROGRESS", "<<1>><<2>><<3>> Kriterien fortgeschritten. <<4>> verbleiben.")
L(AH .. "PROGRESS_ACHIEVEMENT", "Fortschritt der Errungenschaften")
L(AH .. "PROGRESS_CHAT", "Im Chat anzeigen")
L(AH .. "PROGRESS_SCREEN", "Auf dem Bildschirm ankündigen")
L(AH .. "RANDOM", "<<1>> hat <<2>> bekommen")
L(AH .. "REMINDER", "Erinnerung an ein Bosskampf anzeigen")
L(AH .. "REMINDER_QUEST", "Erinnerung an ein Quest Gegenstand anzeigen")
L(AH .. "REMINDER_QUEST_TEXT", "Questgegenstand nicht vergessen!")
L(AH .. "REMINDER_TOOLTIP", "Bei der Auswahl von Versen eine Erinnerung anzeigen, wenn der nächste Abschnitt ein Boss ist.")
L(AH .. "REMOVE_AVOID", "Von \"Zu Vermeiden\" entfernen")
L(AH .. "REQUIRES", "Benötigt LibChatMessage")
L(AH .. "SECONDS", "s")
L(AH .. "SHARD", "Tho'at-Scherbe")
L(AH .. "SHARD_IGNORE", "Scherben außerhalb von Zyklus 5 ignorieren")
L(AH .. "SHARD_MARKER", "Zielmarkierungen zu Tho'at Scherben hinzufügen")
L(AH .. "SHOW_COUNT", "Verbleibende Buchsiedler im Erfasser-Flügel zählen")
L(AH .. "SHOW_CROSSING_HELPER", "Show Treacherous Crossing helper")
-- luacheck: push ignore 631
L(
    AH .. "SHOW_COUNT_TOOLTIP",
    "Damit der Duo-Modus korrekt funktioniert, muss auch der andere Spieler dieses Addon installiert haben. Außerdem müssen beide Spieler LibDataShare installiert haben."
)
-- luacheck: pop
L(AH .. "SHOW_ECHO", "Verbleibende Zeit in der Hallende Höhle anzeigen")
L(AH .. "SHOW_SELECTION", "Buff-Auswahl im Gruppenchat anzeigen")
L(AH .. "SLASH_MISSING", "fehlende")
L(AH .. "STACKS", "Anzahl der Stapel")
L(AH .. "TOMESHELL", "Buchsiedler")
L(AH .. "TOMESHELL_COUNT", "<<1[0 verbleibend/1 verbleibend/$d verbleibend]>>")
L(AH .. "USE_AUTO_AVOID", "Automatische Markierungen benutzen")
L(AH .. "USE_AUTO_AVOID_TOOLTIP", "Automatisch Verse oder Visionen markieren, die aufgrund nicht vorhandener Fähigkeiten nutzlos sind")
L(AH .. "WARNING", "Warnung: Liste benötigt zum Aktualisieren ein Neuladen der Benutzeroberfläche")
L(AH .. "WEREWOLF_BEHEMOTH", "Werwolfbehemoth")

-- keybinds
L("SI_BINDING_NAME_" .. AH .. "MARK_CURRENT_TARGET", "Aktuelles Ziel markieren")
L("SI_BINDING_NAME_" .. AH .. "TOGGLE_CROSSING_HELPER", "Toggle Crossing Helper")
L("SI_BINDING_NAME_" .. AH .. "UNMARK_CURRENT_TARGET", "Markierung des aktuellen Ziels aufheben")
