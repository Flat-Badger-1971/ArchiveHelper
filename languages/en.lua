-- English localisation
-- luacheck: push ignore 631
local L = ZO_CreateStringId
local AH = "ARCHIVEHELPER_"
L(AH .. "ADD_AVOID", "Add to avoid list")
L(AH .. "ALL_BOTH", "All verses and visions acquired")
L(AH .. "ALL_VISIONS", "All visions acquired")
L(AH .. "ALL_VERSES", "All verses acquired")
L(AH .. "ARC_BOSS", "Tho'at Replicanum next")
L(AH .. "AVOID", "Avoid")
L(AH .. "BONUS", "Bonus Levels")
L(AH .. "BUFF_SELECTED", "<<1>> selected <<2>>")
L(AH .. "COUNT", "<<1>> of <<2>>")
L(AH .. "CROSSING_END", "End")
L(AH .. "CROSSING_KEY", "<<1>> Turn Left - <<2>> Turn Right")
L(AH .. "CROSSING_INVALID", "The Crossing Helper can only be activated within the Treacherous Crossing in the Infinite Archive")
L(AH .. "CROSSING_FAIL", "Locked") -- The Levers are Locked. No-one can cross
L(AH .. "CROSSING_NO_SOLUTIONS", "No Paths Found")
L(AH .. "CROSSING_PATHS", "Possible Paths")
L(AH .. "CROSSING_SLASH", "helper")
L(AH .. "CROSSING_START", "Start")
L(AH .. "CROSSING_SUCCESS", "Solved") -- You Solved the Corridor Puzzle
L(AH .. "CROSSING_TITLE", "Treacherous Crossing Helper")
L(
    AH .. "CROSSING_INSTRUCTIONS",
    "Find the switch corresponding to the start of the path and select it in the dropdown below (1 is the leftmost switch, 6 the rightmost)." ..
        " Then, if necessary, find the 2nd step or the end of the path, until only one solution remains."
)
L(AH .. "CYCLE_BOSS", "Cycle boss next")
L(AH .. "DEN_TIMER", "<<1[0s remaining/1s remaining/$ds remaining]>>")
L(AH .. "FABLED", "Fabled")
L(AH .. "FABLED_MARKER", "Add Target Markers to Fabled")
L(
    AH .. "FABLED_TOOLTIP",
    "This feature will not work with Lykeions Fabled Marker addon to avoid both addons trying to mark the same things."
)
L(AH .. "FLAMESHAPER", "Flame-Shaper")
L(AH .. "GW", "Gw the Pilferer")
L(AH .. "GW_MARKER", "Add Target Marker to Gw the Pilferer")
L(AH .. "GW_PLAY", "Play warning when Gw has been marked")
L(AH .. "HERD", "Herd the Ghost Lights")
L(AH .. "HERD_FAIL", "Enough") -- You Did Not Herd Enough Ghostlights
L(AH .. "HERD_SUCCESS", "Returned") -- You Successfully Returned the Ghostlights
L(AH .. "MARAUDER_MARKER", "Add Target Markers to Marauders")
L(AH .. "MARAUDER_INCOMING_PLAY", "Play warning for incoming Marauders")
L(AH .. "OPTIONAL_LIBS_CHAT", "Archive Helper works best with LibChatMessage installed.")
L(AH .. "OPTIONAL_LIBS_SHARE", "For Duo mode to work effectively, please install LibDataShare.")
L(AH .. "PREVENT", "Prevent accidental buff selection")
L(AH .. "PREVENT_TOOLTIP", "Disables the buff selection briefly when the panel opens to prevent accidental selection.")
L(AH .. "PROGRESS", "<<1>> criteria advanced. <<2>> remaining.")
L(AH .. "PROGRESS_ACHIEVEMENT", "Achievement progress")
L(AH .. "PROGRESS_CHAT", "Show in chat")
L(AH .. "PROGRESS_SCREEN", "Announce on screen")
L(AH .. "RANDOM", "<<1>> received <<2>>")
L(AH .. "REMINDER", "Show boss reminder")
L(AH .. "REMINDER_QUEST", "Show quest item reminder")
L(AH .. "REMINDER_QUEST_TEXT", "Don't forget to pick up your quest item!")
L(AH .. "REMINDER_TOOLTIP", "When selecting verses, show a reminder notice if the next stage is a boss.")
L(AH .. "REMOVE_AVOID", "Remove from avoid list")
L(AH .. "REQUIRES", "Requires LibChatMessage")
L(AH .. "SECONDS", "s")
L(AH .. "SHARD", "Tho'at Shard")
L(AH .. "SHARD_IGNORE", "Ignore Shards outside cycle 5")
L(AH .. "SHARD_MARKER", "Add Target Markers to Tho'at Shards")
L(AH .. "SHOW_COUNT", "Show Tomeshell count in the Filer's Wing")
L(AH .. "SHOW_CROSSING_HELPER", "Show Treacherous Crossing helper")
L(
    AH .. "SHOW_COUNT_TOOLTIP",
    "For Duo mode to work correctly, the other player must have this addon installed. Both players must also have LibDataShare installed."
)
L(AH .. "SHOW_ECHO", "Show timer in the Echoing Den")
L(AH .. "SHOW_SELECTION", "Show buff selection in group chat")
L(AH .. "SHOW_SELECTION_DISPLAY_NAME", "Use display name")
L(AH .. "SHOW_SELECTION_DISPLAY_NAME_TOOLTIP", "Use display name instead of character name")
L(AH .. "SHOW_TERRAIN_WARNING", "Show warnings for terrain damage")
L(AH .. "SLASH_MISSING", "missing")
L(AH .. "STACKS", "Stack count")
L(AH .. "TOMESHELL", "Tomeshell")
L(AH .. "TOMESHELL_COUNT", "<<1[0 remaining/1 remaining/$d remaining]>>")
L(AH .. "USE_AUTO_AVOID", "Use automatic avoids")
L(
    AH .. "USE_AUTO_AVOID_TOOLTIP",
    "Automatically mark verses or visions that are of no use to you due to unslotted skills"
)
L(AH .. "WARNING", "Warning: Dropdowns may not refresh without a UI reload")
L(AH .. "WEREWOLF_BEHEMOTH", "Werewolf Behemoth")

-- keybinds
L("SI_BINDING_NAME_" .. AH .. "MARK_CURRENT_TARGET", "Mark Current Target")
L("SI_BINDING_NAME_" .. AH .. "TOGGLE_CROSSING_HELPER", "Toggle Crossing Helper")
L("SI_BINDING_NAME_" .. AH .. "UNMARK_CURRENT_TARGET", "Unmark Current Target")

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
-- luacheck: pop