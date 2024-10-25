-- Russian localisation by Xeloses (@Savaoth [EU])
-- luacheck: push ignore 631
local L = ZO_CreateStringId
local AH = "ARCHIVEHELPER_"

-- Enemies
L(AH .. "FABLED", "вымышленн") -- Fabled
L(AH .. "SHARD", "осколок то") -- Tho'at Shard
L(AH .. "GW", "гв воришка") -- Gw the Pilferer
L(AH .. "FLAMESHAPER", "огненн") -- Flame-Shaper

L(AH .. "MARADEUR_GOTHMAU", "готмо") -- gothmau
L(AH .. "MARADEUR_HILKARAX", "хилькаракс") -- hilkarax
L(AH .. "MARADEUR_ULMOR", "ульмор") -- ulmor
L(AH .. "MARAUDER_BITTOG", "bittog") -- bittog
L(AH .. "MARAUDER_ZULFIMBUL", "zulfimbul") -- zulfimbul

-- Ability
L(AH .. "WEREWOLF_BEHEMOTH", "Чудовищный вервольф") -- Werewolf Behemoth

-- Messages
L(AH .. "ALL_BOTH", "Все строфы и видения получены") -- All verses and visions acquired
L(AH .. "ALL_VISIONS", "Все видения получены") -- All visions acquired
L(AH .. "ALL_VERSES", "Все строфы получены") -- All verses acquired

L(AH .. "REMINDER_QUEST_TEXT", "Не забудьте подобрать квестовый предмет!") -- Don't forget to pick up your quest item!

L(AH .. "CYCLE_BOSS", "Впереди Босс цикла!") -- Cycle boss next
L(AH .. "ARC_BOSS", "Впереди То’ат Копировальщица!") -- Tho'at Replicanum next

L(AH .. "PROGRESS", "Прогресс достижения ''<<1>>'': осталось <<2>>.") -- <<1>> criteria advanced. <<2>> remaining.
L(AH .. "BUFF_SELECTED", "<<1>> получает [<<2>>]") -- <<1>> selected <<2>>
L(AH .. "RANDOM", "<<1>> получает [<<2>>]") -- <<1>> received <<2>>
L(AH .. "COUNT", "<<1>> из <<2>>") -- <<1>> of <<2>>
L(AH .. "DEN_TIMER", "<<1[Осталось 0 сек./Осталось 1 сек./Осталось $d сек.]>>") -- <<1[0s remaining/1s remaining/$ds remaining]>>

L(AH .. "CROSSING_TITLE", "Помощник Коварного перекрёстка") -- Treacherous Crossing Helper
L(AH .. "CROSSING_INSTRUCTIONS", "Найдите переключатель, отвечающий за начало пути, и выберите его номер в соответствующем списке (1 - самый левый переключатель, 6 - самый правый). Затем, при необходимости, укажите 2й и/или последний переключатель.") -- Find the switch corresponding to the start of the path and select it in the dropdown below (1 is the leftmost switch, 6 the rightmost). Then, if necessary, find the 2nd step or the end of the path, until only one solution remains.
L(AH .. "CROSSING_INVALID", "Помощник Коварного перекрёстка может быть включен только на Коварном перекрёстке в Бесконечном архиве.") -- The Crossing Helper can only be activated within the Treacherous Crossing in the Infinite Archive
L(AH .. "CROSSING_KEY", "<<1>> налево - <<2>> направо") -- <<1>> Turn Left - <<2>> Turn Right
L(AH .. "CROSSING_START", "Начало")
L(AH .. "CROSSING_END", "Конец")
L(AH .. "CROSSING_PATHS", "Возможные пути") -- Possible Paths
L(AH .. "CROSSING_NO_SOLUTIONS", "Пути не найдены") -- No Paths Found
L(AH .. "CROSSING_SUCCESS", "решили головоломку") -- you Solved the Corridor Puzzle / Вы решили головоломку в коридоре
L(AH .. "CROSSING_FAIL", "заклинил") -- Locked (the Levers are Locked. No-one can cross)


L(AH .. "HERD", "соберите призрачные огни") -- Herd the Ghost Lights
L(AH .. "HERD_SUCCESS", "удалось вернуть") -- you Successfully Returned the Ghostlights / Вам удалось вернуть призрачные огни
L(AH .. "HERD_FAIL", "достаточно") -- you Did Not Herd Enough Ghostlights / Вам не удалось собрать достаточно призрачных огней

L(AH .. "TOMESHELL", "Книжная оболочка") -- Tomeshell
L(AH .. "TOMESHELL_COUNT", "<<1[Осталось 0/Осталось $d]>>") -- <<1[0 remaining/1 remaining/$d remaining]>>

L(AH .. "SECONDS", "сек.")

-- Zones
L(AH .. "MAP_TREACHEROUS_CROSSING", "Коварный перекрёсток") -- Treacherous Crossing
L(AH .. "MAP_HAEFELS_BUTCHERY", "Скотобойня Хейфала") -- Haefel's Butchery
L(AH .. "MAP_FILERS_WING", "Крыло Архивиста") -- Filer's Wing
L(AH .. "MAP_ECHOING_DEN", "Гулкое логово") -- Echoing Den
L(AH .. "MAP_THEATRE_OF_WAR", "Театр войны") -- Theatre of War
L(AH .. "MAP_DESTOZUNOS_LIBRARY", "Библиотека Дестозуны") -- Destozuno's Library

-- Settings
L(AH .. "PROGRESS_ACHIEVEMENT", "Прогресс достижений") -- Achievement progress
L(AH .. "PROGRESS_CHAT", "Выводить в чат") -- Show in chat
L(AH .. "PROGRESS_SCREEN", "Оповещение в центре экрана") -- Announce on screen
L(AH .. "SHOW_SELECTION", "Отображать выбранные баффы в чате") -- Show buff selection in group chat
L(AH .. "SHOW_SELECTION_DISPLAY_NAME", "Использовать отображаемое имя")
L(AH .. "SHOW_SELECTION_DISPLAY_NAME_TOOLTIP", "Использовать отображаемое имя вместо имени персонажа")
L(AH .. "REMINDER", "Показывать напоминание о боссе") -- Show boss reminder
L(AH .. "REMINDER_TOOLTIP", "При выборе строфы показывать напоминание, если на следующем уровне будет босс.") -- When selecting verses, show a reminder notice if the next stage is a boss.
L(AH .. "REMINDER_QUEST", "Показывать напоминание о квестовых предметах") -- Show quest item reminder
L(AH .. "PREVENT", "Предотвращать случайный выбор баффов") -- Prevent accidental buff selection
L(AH .. "PREVENT_TOOLTIP", "Ненадолго отключать возможность выбора баффа при открытии панели для предотвращения случайного выбора баффов.") -- Disables the buff selection briefly when the panel opens to prevent accidental selection.
L(AH .. "BONUS", "Бонусные уровни") -- Bonus Levels
L(AH .. "SHOW_ECHO", "Показывать таймер в Гулком логове") -- Show timer in the Echoing Den
L(AH .. "SHOW_COUNT", "Показывать кол-во книжных оболочек в Крыле Архивиста") -- Show Tomeshell count in the Filer's Wing
L(AH .. "SHOW_COUNT_TOOLTIP", "Для корректной работы в режиме группы из 2х игроков оба игрока должны установить Archive Helper и LibDataShare.") -- For Duo mode to work correctly, the other player must have this addon installed. Both players must also have LibDataShare installed.
L(AH .. "SHOW_CROSSING_HELPER", "Включить помошника на Коварном перекрёстке") -- Show Treacherous Crossing helper
L(AH .. "SHOW_TERRAIN_WARNING", "Показывать предупреждения")
L(AH .. "SHOW_TERRAIN_WARNING_TOOLTIP", "Показывать предупреждения о повреждении рельефа")
L(AH .. "FABLED_MARKER", "Ставить метки на ''Вымышленных'' врагов") -- Add Target Markers to Fabled
L(AH .. "FABLED_TOOLTIP", "Эта функция не будет работать при установленном Lykeions Fabled Marker.") -- This feature will not work with Lykeions Fabled Marker addon to avoid both addons trying to mark the same things.
L(AH .. "SHARD_MARKER", "Ставить метки на Осколки То’ат") -- Add Target Markers to Tho'at Shards
L(AH .. "SHARD_IGNORE", "Игнорировать осколки до цикла 5") -- Ignore Shards outside cycle 5
L(AH .. "GW_MARKER", "Ставить метку на Гв Воришку") -- Add Target Marker to Gw the Pilferer
L(AH .. "GW_PLAY", "Звуковое оповещение для Гв Воришки") -- Play warning when Gw has been marked
L(AH .. "MARAUDER_MARKER", "Ставить метки на мародеров") -- Add Target Markers to Marauders
L(AH .. "MARAUDER_INCOMING_PLAY", "Звуковое оповещение для мародеров ") -- Play warning for incoming Marauders
L(AH .. "STACKS", "Количество стаков") -- Stack count
L(AH .. "AVOID", "Нежелательные баффы") -- Avoid
L(AH .. "ADD_AVOID", "Добавить в список нежелательных") -- Add to avoid list
L(AH .. "REMOVE_AVOID", "Убрать из списка нежелательных") -- Remove from avoid list
L(AH .. "USE_AUTO_AVOID", "Автоматически помечать бесполезные бафы") -- Use automatic avoids
L(AH .. "USE_AUTO_AVOID_TOOLTIP", "Автоматически помечать строфы и видения как бесполезные, если у вас не выбраны на панели нужные для них навыки.") -- Automatically mark verses or visions that are of no use to you due to unslotted skills
L(AH .. "WARNING", "Прим.: выпадающие списки могут не обновляться до перезагрузки UI.") -- Warning: Dropdowns may not refresh without a UI reload

L(AH .. "REQUIRES", "Требуется LibChatMessage.") -- Requires LibChatMessage
L(AH .. "OPTIONAL_LIBS_CHAT", "Для отправки сообщений в чат требуется библиотека LibChatMessage.") -- Archive Helper works best with LibChatMessage installed
L(AH .. "OPTIONAL_LIBS_SHARE", "Установите LibDataShare для эффективной работы в группе.") -- For Duo mode to work effectively, please install LibDataShare.


-- Slash command arguments
L(AH .. "CROSSING_SLASH", "helper")
L(AH .. "SLASH_MISSING", "missing")

-- Keybinds
L("SI_BINDING_NAME_" .. AH .. "MARK_CURRENT_TARGET", "Поставить метку на цель") -- Mark Current Target
L("SI_BINDING_NAME_" .. AH .. "UNMARK_CURRENT_TARGET", "Убрать метку с цели") -- Unmark Current Target
L("SI_BINDING_NAME_" .. AH .. "TOGGLE_CROSSING_HELPER", "Помощник Коварного Перекрестка") -- Toggle Crossing Helper

L(AH .. "LIB_TEXT", "Это дополнение теперь требует LibFBCommon. Пожалуйста, установите его и перезагрузите. Пожалуйста, игнорируйте любые ошибки, пока это не будет установлено.")
-- luacheck: pop